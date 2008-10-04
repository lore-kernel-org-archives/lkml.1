Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYJDIk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYJDIk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYJDIkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:40:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbYJDIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:40:16 -0400
Date: Sat, 4 Oct 2008 10:40:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081004084002.GE27624@elte.hu>
References: <20081004060057.660306328@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004060057.660306328@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> These patches need to be put through the ringer. Could you add them to 
> your ring-buffer branch, so we can test them out before putting them 
> into your master branch.

hey, in fact your latest iteration already tested out so well on a wide 
range of boxes that i've merged it all into tip/tracing/core already.

I'll reuse tip/tracing/ring-buffer for these latest 3 patches (merge it 
up to tip/tracing/core and add these three patches) but it's a delta, 
i.e. the whole ring-buffer approach is ready for prime time i think.

Hm, do we do deallocation of the buffers already when we switch tracers?

> The following patches bring the ring buffer closer to a lockless 
> solution. They move the locking only to the actual moving the 
> tail/write pointer from one page to the next. Interrupts are now 
> enabled during most of the writes.

very nice direction!

> A lot of the locking protection is still within the ftrace 
> infrastructure. The last patch takes some of that away.
> 
> The function tracer cannot be reentrant just due to the nature that it 
> traces everything, and can cause recursion issues.

Correct, and that's by far the yuckiest aspect of it. And there's 
another aspect: NMIs. We've still got the tip/tracing/nmisafe angle with 
these commits:

 d979781: ftrace: mark lapic_wd_event() notrace
 c2c27ba: ftrace: ignore functions that cannot be kprobe-ed
 431e946: ftrace: do not trace NMI contexts
 1eda930: x86, tracing, nmisafe: fix threadinfo_ -> TI_ rename fallout
 84c2ca9: sched: sched_clock() improvement: use in_nmi()
 0d84b78: x86 NMI-safe INT3 and Page Fault
 a04464b: x86_64 page fault NMI-safe
 b335389: Change avr32 active count bit
 a581cbd: Change Alpha active count bit
 eca0999: Stringify support commas

but i'm not yet fully convinced about the NMI angle, the practical cross 
section to random lowlevel x86 code is wider than any sched_clock() 
impact for example. We might be best off avoiding it: force-disable the 
NMI watchdog when we trace?

	Ingo
