Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbYHMTak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbYHMTak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYHMTaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:30:17 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:36523 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbYHMTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:30:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFAPvQokhMRKxB/2dsb2JhbACBYLR3gVU
Date: Wed, 13 Aug 2008 15:30:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
Message-ID: <20080813193011.GC15547@Krystal>
References: <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080813184142.GM1366@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:22:51 up 70 days, 3 min,  8 users,  load average: 0.44, 1.00,
	1.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > So microbenchmarking this way will probably make some things look 
> > unrealistically good. 
> 
> Must be careful to miss the big picture here.
> 
> We have two assumptions here in this thread:
> 
> - Normal alternative() nops are relatively infrequent, typically
> in points with enough pipeline bubbles anyways, and it likely doesn't
> matter how they are encode. And also they don't have an issue
> with mult part instructions anyways because they're not patched
> at runtime, so always the best known can be used.
> 
> - The one case where nops are very frequent and matter and multipart
> is a problem is with ftrace noping out the call to mcount at runtime 
> because that happens on every function entry.
> Even there the overhead is not that big, but at least measurable 
> in kernel builds.
> 
> Now the numbers have shown that just by not using frame pointer (
> -pg right now implies frame pointer) you can get more benefit 
> than what you lose from using non optimal nops.
> 
> So for me the best strategy would be to get rid of the frame pointer
> and ignore the nops. This unfortunately would require going away
> from -pg and instead post process gcc output to insert "call mcount"
> manually. But the nice advantage of that is that you could actually 
> set up a custom table of callers built in a ELF section and with
> that you don't actually need the runtime patching (which is only
> done currently because there's no global table of mcount calls),
> but could do everything in stop_machine(). Without
> runtime patching you also don't need single part nops. 
> 

I agree that if frame pointer brings a too big overhead, it should not
be used.

Sorry to ask, I feel I must be missing something, but I'm trying to
figure out where you propose to add the "call mcount" ? In the caller or
in the callee ?

In the caller, I guess it would replace the normal function call, call a
trampoline which would jump to the normal code.

In the callee, as what is currently done with -pg, the callee would have
a call mcount at the beginning of the function.

Or is it a different scheme I don't see ? I am trying to figure out how
you happen to do all that without dynamic code modification and manage
not to hurt performance.

Mathieu

> I think that would be the best option. I especially like it because
> it would prevent forcing frame pointer which seems to be costlier
> than any kinds of nosp.
> 
> -Andi
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
