Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZBWQN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZBWQN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZBWQNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:13:20 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:37062 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbZBWQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:13:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAEdXoklMQWXi/2dsb2JhbACBbtNihA8G
Date: Mon, 23 Feb 2009 11:13:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090223161312.GA30279@Krystal>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com> <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:56:35 up 2 days,  7:30,  3 users,  load average: 0.54, 0.68,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> > > 
> > > As for RO_DATA and bugs, it is a very small window for this to happen, and 
> > > the sys-admin is the one making the change. This is not some periodical 
> > > update. The sys-admin must be the one to initiate the tracer to modify 
> > > text, ie, enabling or disabling the function tracer. Which, by the way, is 
> > > something a sys-admin should only do when the system is off line. The 
> > > overhead of all functions being traced, would not be something to be 
> > > doing on a production system, unless they need to analyze something going 
> > > wrong.
> > > 
> > 
> > The argument "not to be used on production systems" is incompatible with
> > the LTTng view, sorry. If you design your code so it's usable only in
> > debugging scenarios on development machines and not in the field, then I
> > doubt LTTng will be able to rely on it. I'm OK with that, as long as
> > nobody argue that such tracepoint could be replaced by the function
> > tracer, because tracepoints has to be enabled in the field on production
> > machines.
> 
> Please do not confuse ftrace with the function tracer. The stop_machine
> is only about the function tracer and has nothing to do with the rest of
> ftrace. This is one detail. Yes, tracing EVERY function in the kernel
> will add an overhead. There's no way around it. It's OK to do it on a
> production system, but it WILL add overhead. That's what happens when you
> trace EVERY function.
> 

I specifically talked about the function tracer here, so there is no
confusion.

> Note, I leave a lot of the other tracers on by default, and those are all
> within the noise of overhead. I'm only talking about the function tracer
> that is meant to do a lot of tracing. Does LTTng trace EVERY function?
> 

It can, by using your function tracer. It has a mode where it can
enable/disable a filter in a callback connected on tracepoints. This
filter is then used to enable detailed function tracing for a short time
window. Also, you could think of tracing every function calls with
LTTng's flight recorder mode, which only spins in memory overwriting the
oldest information. That would provide snapshots on demand of the last
functions called.

> Now, yes, if you only select a few functions, there's no noticeable 
> overhead. And yes then you would need to do the stop_machine anyway, and 
> there will be a small window where the kernel text will be writable. 
> Tracing only a small set of functions (say a few 100) is not much of an 
> overhead, and I could see that being done on a production system.
> 

This is what LTTng can do today. But that involves the function tracer
stop_machine() call, which I dislike.

> > 
> > I agree that the racy time window is not that large and is not really a
> > security concern, but it's still just annoying.
> 
> Annoying? how so?
> 
> Again, the stop_machine part has nothing to do with DEBUG_RODATA, it is 
> about the safest and easiest way to modify kernel text.
> 

We are running in circles here because there is no real argument
brought.

1 - You claim that changing the kernel's mapping, which has been
pointed out as an intrusive kernel modification, is faster than using a
text-poke-like approach. Please provide numbers to support such claims.

2 - You claim that using stop_machine is simpler and therefore safer
than using a breakpoint-based approach. I start having some doubts about
simplicity when you start talking about the workarounds you have to do
for NMIs, but more importantly, you seem to recognise that the latency
it induces would be inadequate for production systems. Therefore it's
unusable in some LTTng use-cases just because of that. If you expect the
function tracer to become used more widely in LTTng, these concerns
should be addressed.

If, in the end, your argument is "the function tracer works as-is now,
and I have no time to change it given it represents too much work" or "I
don't care about your use-cases", I'm OK with that. But please then don't
argue that it's because it's the best technical solution when it isn't.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
