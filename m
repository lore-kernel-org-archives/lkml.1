Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYKGSeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYKGSeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYKGSdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:33:50 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:36658 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKGSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:33:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAKwYFElMQWxa/2dsb2JhbACBdsd8g1Y
Date: Fri, 7 Nov 2008 13:33:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, nico@cam.org, torvalds@linux-foundation.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107183346.GJ22134@Krystal>
References: <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <alpine.LFD.2.00.0811070952150.13034@xanadu.home> <8189.1226074915@redhat.com> <8509.1226077800@redhat.com> <20081107092643.0bd9bb4e.akpm@linux-foundation.org> <20081107180041.GG22134@Krystal> <20081107102148.6eb53dea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081107102148.6eb53dea.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:32:14 up 155 days, 23:12,  6 users,  load average: 1.04, 0.53,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 7 Nov 2008 13:00:41 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > On Fri, 07 Nov 2008 17:10:00 +0000 David Howells <dhowells@redhat.com> wrote:
> > > 
> > > > 
> > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > I'd expect it to behave in the same way as it would if the function was
> > > > > implemented out-of-line.
> > > > > 
> > > > > But it occurs to me that the modrobe-doesnt-work thing would happen if
> > > > > the function _is_ inlined anyway, so we won't be doing that.
> > > > > 
> > > > > Whatever.  Killing this many puppies because gcc may do something so
> > > > > bizarrely wrong isn't justifiable.
> > > > 
> > > > With gcc, you get one instance of the static variable from inside a static
> > > > (inline or outofline) function per .o file that invokes it, and these do not
> > > > merge even though they're common symbols.  I asked around and the opinion
> > > > seems to be that this is correct C.  I suppose it's the equivalent of cutting
> > > > and pasting a function between several files - why should the compiler assume
> > > > it's the same function in each?
> > > > 
> > > 
> > > OK, thanks, I guess that makes sense.  For static inline.  I wonder if
> > > `extern inline' or plain old `inline' should change it.
> > > 
> > > It's one of those things I hope I never need to know about, but perhaps
> > > we do somewhere have static storage in an inline.  Wouldn't surprise
> > > me, and I bet that if we do, it's a bug.
> > 
> > Tracepoints actually use that.
> 
> Referring to include/linux/tracepoint.h:DEFINE_TRACE()?
> 
> It does look a bit fragile.  Does every .c file which included
> include/trace/block.h get a copy of __tracepoint_block_rq_issue,
> whether or not it used that tracepoint? Hopefully not.
> 

No, __tracepoint_block_rq_issue is only instanciated if the static
inline function is used. One instance per use.

> > It could be changed so they use :
> > 
> > DECLARE_TRACE() (in include/trace/group.h)
> > DEFINE_TRACE()  (in the appropriate kernel c file)
> > trace_somename(); (in the code)
> > 
> > instead. That would actually make more sense and remove the need for
> > multiple declarations when the same tracepoint name is used in many
> > spots (this is a problem kmemtrace has, it generates a lot of tracepoint
> > declarations).
> 
> I'm unsure of the requirements here.  Do you _want_ each call to
> trace_block_rq_issue() to share some in-memory state?  If so then yes,
> there's a problem with calls to trace_block_rq_issue() from within
> separate compilation units.
> 
> otoh, if all calls to trace_block_rq_issue() are supposed to have
> independent state (which seems to be the case) then that could be
> addressed by making trace_block_rq_issue() a macro which defines
> static storage, as cnt32_to_63() shouldn't have done ;)
> 

They could share the same data, given it *has* to be the same. I'll
try to fix this.

Mathieu

> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
