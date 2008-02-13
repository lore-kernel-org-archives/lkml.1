Return-Path: <linux-kernel-owner+w=401wt.eu-S1764795AbYBMUeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764795AbYBMUeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYBMUeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:34:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52292 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbYBMUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:34:03 -0500
Subject: [PATCH] xtime_lock vs update_process_times
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rth <rth@twiddle.net>, "bryan.wu" <bryan.wu@analog.com>,
       David Howells <dhowells@redhat.com>, lethal <lethal@linux-sh.org>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       gerg@uclinux.org, Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:33:16 +0100
Message-Id: <1202934796.20209.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time with LKML CC'ed. Sorry for the duplication.

----
Subject: xtime_lock vs update_process_times
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

( repost from: http://lkml.org/lkml/2008/1/28/101 )

Commit: d3d74453c34f8fd87674a8cf5b8a327c68f22e99
Subject: hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ fallback

Broke several archs, since only Russel bothered to merge the fix,
and Greg to ACK his arch, I'm sending this for merger.

I have confirmation that the Alpha bit results in a booting kernel.
That leaves: blackfin, frv, sh and sparc untested.

The deadlock in question was found by Russell:

  IRQ handle 
    -> timer_tick() - xtime seqlock held for write
      -> update_process_times() 
        -> run_local_timers()
          -> hrtimer_run_queues()
            -> hrtimer_get_softirq_time() - tries to get a read lock

Now, Thomas assures me the fix is trivial, only do_timer() needs to be
done under the xtime_lock, and update_process_times() can savely be removed
from under it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Greg Ungerer <gerg@uclinux.org>
CC: rth@twiddle.net
CC: bryan.wu@analog.com
CC: dhowells@redhat.com
CC: lethal@linux-sh.org
CC: wli@holomorphy.com
---
 arch/alpha/kernel/time.c           |   15 ++++++++-------
 arch/blackfin/kernel/time.c        |    8 +++++---
 arch/frv/kernel/time.c             |    6 ++++--
 arch/m68knommu/kernel/time.c       |   12 +++++++-----
 arch/sh/kernel/timers/timer-cmt.c  |    9 ---------
 arch/sh/kernel/timers/timer-mtu2.c |    2 --
 arch/sparc/kernel/pcic.c           |    2 +-
 arch/sparc/kernel/time.c           |    7 +++----
 8 files changed, 28 insertions(+), 33 deletions(-)

Index: linux-2.6/arch/alpha/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/time.c
+++ linux-2.6/arch/alpha/kernel/time.c
@@ -119,13 +119,8 @@ irqreturn_t timer_interrupt(int irq, voi
 	state.partial_tick = delta & ((1UL << FIX_SHIFT) - 1); 
 	nticks = delta >> FIX_SHIFT;
 
-	while (nticks > 0) {
-		do_timer(1);
-#ifndef CONFIG_SMP
-		update_process_times(user_mode(get_irq_regs()));
-#endif
-		nticks--;
-	}
+	if (nticks)
+		do_timer(nticks);
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -141,6 +136,12 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 
 	write_sequnlock(&xtime_lock);
+
+#ifndef CONFIG_SMP
+	while (nticks--)
+		update_process_times(user_mode(get_irq_regs()));
+#endif
+
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/blackfin/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/time.c
+++ linux-2.6/arch/blackfin/kernel/time.c
@@ -137,9 +137,6 @@ irqreturn_t timer_interrupt(int irq, voi
 
 	do_timer(1);
 
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
 	profile_tick(CPU_PROFILING);
 
 	/*
@@ -161,6 +158,11 @@ irqreturn_t timer_interrupt(int irq, voi
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+
+#ifndef CONFIG_SMP
+	update_process_times(user_mode(get_irq_regs()));
+#endif
+
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/frv/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/time.c
+++ linux-2.6/arch/frv/kernel/time.c
@@ -63,6 +63,7 @@ static irqreturn_t timer_interrupt(int i
 	/* last time the cmos clock got updated */
 	static long last_rtc_update = 0;
 
+	profile_tick(CPU_PROFILING);
 	/*
 	 * Here we are in the timer irq handler. We just have irqs locally
 	 * disabled but we don't know if the timer_bh is running on the other
@@ -73,8 +74,6 @@ static irqreturn_t timer_interrupt(int i
 	write_seqlock(&xtime_lock);
 
 	do_timer(1);
-	update_process_times(user_mode(get_irq_regs()));
-	profile_tick(CPU_PROFILING);
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -99,6 +98,9 @@ static irqreturn_t timer_interrupt(int i
 #endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
+
+	update_process_times(user_mode(get_irq_regs()));
+
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/m68knommu/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/time.c
+++ linux-2.6/arch/m68knommu/kernel/time.c
@@ -42,14 +42,12 @@ irqreturn_t arch_timer_interrupt(int irq
 	/* last time the cmos clock got updated */
 	static long last_rtc_update=0;
 
+	if (current->pid)
+		profile_tick(CPU_PROFILING);
+
 	write_seqlock(&xtime_lock);
 
 	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-	if (current->pid)
-		profile_tick(CPU_PROFILING);
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -67,6 +65,10 @@ irqreturn_t arch_timer_interrupt(int irq
 	}
 
 	write_sequnlock(&xtime_lock);
+
+#ifndef CONFIG_SMP
+	update_process_times(user_mode(get_irq_regs()));
+#endif
 	return(IRQ_HANDLED);
 }
 
Index: linux-2.6/arch/sh/kernel/timers/timer-cmt.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/timers/timer-cmt.c
+++ linux-2.6/arch/sh/kernel/timers/timer-cmt.c
@@ -100,16 +100,7 @@ static irqreturn_t cmt_timer_interrupt(i
 	timer_status &= ~0x80;
 	ctrl_outw(timer_status, CMT_CMCSR_0);
 
-	/*
-	 * Here we are in the timer irq handler. We just have irqs locally
-	 * disabled but we don't know if the timer_bh is running on the other
-	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
-	 * the irq version of write_lock because as just said we have irq
-	 * locally disabled. -arca
-	 */
-	write_seqlock(&xtime_lock);
 	handle_timer_tick();
-	write_sequnlock(&xtime_lock);
 
 	return IRQ_HANDLED;
 }
Index: linux-2.6/arch/sh/kernel/timers/timer-mtu2.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/timers/timer-mtu2.c
+++ linux-2.6/arch/sh/kernel/timers/timer-mtu2.c
@@ -100,9 +100,7 @@ static irqreturn_t mtu2_timer_interrupt(
 	ctrl_outb(timer_status, MTU2_TSR_1);
 
 	/* Do timer tick */
-	write_seqlock(&xtime_lock);
 	handle_timer_tick();
-	write_sequnlock(&xtime_lock);
 
 	return IRQ_HANDLED;
 }
Index: linux-2.6/arch/sparc/kernel/pcic.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pcic.c
+++ linux-2.6/arch/sparc/kernel/pcic.c
@@ -713,10 +713,10 @@ static irqreturn_t pcic_timer_handler (i
 	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
 	do_timer(1);
+	write_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
-	write_sequnlock(&xtime_lock);
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/sparc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/time.c
+++ linux-2.6/arch/sparc/kernel/time.c
@@ -128,10 +128,6 @@ irqreturn_t timer_interrupt(int irq, voi
 	clear_clock_irq();
 
 	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-
 
 	/* Determine when to update the Mostek clock. */
 	if (ntp_synced() &&
@@ -145,6 +141,9 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 	write_sequnlock(&xtime_lock);
 
+#ifndef CONFIG_SMP
+	update_process_times(user_mode(get_irq_regs()));
+#endif
 	return IRQ_HANDLED;
 }
 


