Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZFEIWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZFEIWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZFEIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37587 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZFEIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 49/62] Blackfin: convert SMP to only use generic time framework
Date: Fri,  5 Jun 2009 04:04:58 -0400
Message-Id: <1244189111-19639-50-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig       |    1 +
 arch/blackfin/kernel/time.c |   53 +++++++++++++++---------------------------
 2 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f1a7969..c56fd3e 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -223,6 +223,7 @@ endchoice
 
 config SMP
 	depends on BF561
+	select GENERIC_TIME
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU,
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index daa02d4..adb54aa 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -24,14 +24,10 @@
 
 static struct irqaction bfin_timer_irq = {
 	.name = "Blackfin Timer Tick",
-#ifdef CONFIG_IRQ_PER_CPU
-	.flags = IRQF_DISABLED | IRQF_PERCPU,
-#else
 	.flags = IRQF_DISABLED
-#endif
 };
 
-#if defined(CONFIG_TICKSOURCE_GPTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_IPIPE)
 void __init setup_system_timer0(void)
 {
 	/* Power down the core timer, just to play safe. */
@@ -74,7 +70,7 @@ void __init setup_core_timer(void)
 static void __init
 time_sched_init(irqreturn_t(*timer_routine) (int, void *))
 {
-#if defined(CONFIG_TICKSOURCE_GPTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_IPIPE)
 	setup_system_timer0();
 	bfin_timer_irq.handler = timer_routine;
 	setup_irq(IRQ_TIMER0, &bfin_timer_irq);
@@ -94,7 +90,7 @@ static unsigned long gettimeoffset(void)
 	unsigned long offset;
 	unsigned long clocks_per_jiffy;
 
-#if defined(CONFIG_TICKSOURCE_GPTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_IPIPE)
 	clocks_per_jiffy = bfin_read_TIMER0_PERIOD();
 	offset = bfin_read_TIMER0_COUNTER() / \
 		(((clocks_per_jiffy + 1) * HZ) / USEC_PER_SEC);
@@ -133,36 +129,25 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 	static long last_rtc_update;
 
 	write_seqlock(&xtime_lock);
-#if defined(CONFIG_TICKSOURCE_GPTMR0) && !defined(CONFIG_IPIPE)
+	do_timer(1);
+
 	/*
-	 * TIMIL0 is latched in __ipipe_grab_irq() when the I-Pipe is
-	 * enabled.
+	 * If we have an externally synchronized Linux clock, then update
+	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
+	 * called as close as possible to 500 ms before the new second starts.
 	 */
-	if (get_gptimer_status(0) & TIMER_STATUS_TIMIL0) {
-#endif
-		do_timer(1);
-
-		/*
-		 * If we have an externally synchronized Linux clock, then update
-		 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-		 * called as close as possible to 500 ms before the new second starts.
-		 */
-		if (ntp_synced() &&
-		    xtime.tv_sec > last_rtc_update + 660 &&
-		    (xtime.tv_nsec / NSEC_PER_USEC) >=
-		    500000 - ((unsigned)TICK_SIZE) / 2
-		    && (xtime.tv_nsec / NSEC_PER_USEC) <=
-		    500000 + ((unsigned)TICK_SIZE) / 2) {
-			if (set_rtc_mmss(xtime.tv_sec) == 0)
-				last_rtc_update = xtime.tv_sec;
-			else
-				/* Do it again in 60s. */
-				last_rtc_update = xtime.tv_sec - 600;
-		}
-#if defined(CONFIG_TICKSOURCE_GPTMR0) && !defined(CONFIG_IPIPE)
-		set_gptimer_status(0, TIMER_STATUS_TIMIL0);
+	if (ntp_synced() &&
+	    xtime.tv_sec > last_rtc_update + 660 &&
+	    (xtime.tv_nsec / NSEC_PER_USEC) >=
+	    500000 - ((unsigned)TICK_SIZE) / 2
+	    && (xtime.tv_nsec / NSEC_PER_USEC) <=
+	    500000 + ((unsigned)TICK_SIZE) / 2) {
+		if (set_rtc_mmss(xtime.tv_sec) == 0)
+			last_rtc_update = xtime.tv_sec;
+		else
+			/* Do it again in 60s. */
+			last_rtc_update = xtime.tv_sec - 600;
 	}
-#endif
 	write_sequnlock(&xtime_lock);
 
 #ifdef CONFIG_IPIPE
-- 
1.6.3.1

