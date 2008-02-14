Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbYBNHab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbYBNHab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYBNHaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:30:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYBNHaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:30:22 -0500
Date: Thu, 14 Feb 2008 08:30:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080214073003.GA25699@elte.hu>
References: <20080213164853.GA25476@elte.hu> <47B333B1.28931.A31602E@pageexec.freemail.hu> <20080214061648.GB31327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214061648.GB31327@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > was removed from arch/x86/kernel/process_64.c:__switch_to? that's 
> > the only reason i can think of that would trigger this trace.
> 
> I hand-ported your fixes [the patch was whitespace damaged] so i'm 
> quite sure i got every bit of it - but find it below for reference. I 
> think the percpu changes in .25 might have interfered somewhere. Will 
> investigate.

ok, Arjan found the bug: it was that idle threads didnt have their 
canary set up right.

[ note that this is still not complete because the initial idle thread
  still has a zero canary. But it at least boots now. ]

	Ingo

------------------------->
Subject: x86: setup stack canary for the idle threads
From: Arjan van de Ven <arjan@linux.intel.com>

The idle threads for non-boot CPUs are a bit special in how they
are created; the result is that these don't have the stack canary
set up properly in their PDA. Easiest fix is to just always set
the PDA up correctly when entering the idle thread; this is a NOP
for the boot cpu.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_64.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-x86.q/arch/x86/kernel/process_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/process_64.c
+++ linux-x86.q/arch/x86/kernel/process_64.c
@@ -166,6 +166,15 @@ static inline void play_dead(void)
 void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/*
+	 * If we're the non-boot CPU, nothing set the PDA stack
+	 * canary up for us. This is as good a place as any for
+	 * doing that.
+	 */
+	write_pda(stack_canary, current->stack_canary);
+#endif
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick();
