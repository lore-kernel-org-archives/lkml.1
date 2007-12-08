Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbXLHPsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbXLHPsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXLHPsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:48:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXLHPsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:48:21 -0500
Date: Sat, 8 Dec 2007 16:47:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Message-ID: <20071208154755.GA5255@elte.hu>
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com> <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com> <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain> <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com> <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

>  [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
>  [<c0437ce2>] tick_notify+0x1d4/0x2eb
>  [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
>  [<c06058a1>] notifier_call_chain+0x2a/0x47
>  [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
>  [<c043781e>] clockevents_notify+0x19/0x4f
>  [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
>  [<c058cf03>] cpuidle_idle_call+0x53/0x78
>  [<c058ceb0>] cpuidle_idle_call+0x0/0x78
>  [<c0402575>] cpu_idle+0x97/0xb8
>  =======================
> BUG: soft lockup - CPU#1 stuck for 11s! [vim:3736]

does the patch below help? But the root cause is likely some timer 
problems - do you get consistent results from:

   while :; do time usleep 1111111; done

or do these sleeps fluctuate?

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -774,6 +774,7 @@ void sched_clock_idle_wakeup_event(u64 d
 	struct rq *rq = cpu_rq(smp_processor_id());
 	u64 now = sched_clock();
 
+	touch_softlockup_watchdog();
 	rq->idle_clock += delta_ns;
 	/*
 	 * Override the previous timestamp and ignore all
