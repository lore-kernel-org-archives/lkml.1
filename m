Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbXFWN2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbXFWN2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758342AbXFWNWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:24 -0400
Received: from www.osadl.org ([213.239.205.134]:59264 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758129AbXFWNWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:11 -0400
Message-Id: <20070623124030.982824210@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 19/28] x86_64: Use generic cmos update
Content-Disposition: inline; filename=x86-64-use-generic-cmos-update.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic cmos update function in kernel/time/ntp.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Kconfig       |    4 ++++
 arch/x86_64/kernel/time.c |   25 +++++++++----------------
 2 files changed, 13 insertions(+), 16 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/time.c	2007-06-23 14:38:58.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c	2007-06-23 14:38:59.000000000 +0200
@@ -82,8 +82,9 @@ EXPORT_SYMBOL(profile_pc);
  * sheet for details.
  */
 
-static void set_rtc_mmss(unsigned long nowtime)
+static int set_rtc_mmss(unsigned long nowtime)
 {
+	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
 
@@ -123,6 +124,7 @@ static void set_rtc_mmss(unsigned long n
 	if (abs(real_minutes - cmos_minutes) >= 30) {
 		printk(KERN_WARNING "time.c: can't update CMOS clock "
 		       "from %d to %d\n", cmos_minutes, real_minutes);
+		retval = -1;
 	} else {
 		BIN_TO_BCD(real_seconds);
 		BIN_TO_BCD(real_minutes);
@@ -142,12 +144,17 @@ static void set_rtc_mmss(unsigned long n
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
 	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
 
 void main_timer_handler(void)
 {
-	static unsigned long rtc_update = 0;
 /*
  * Here we are in the timer irq handler. We have irqs locally disabled (so we
  * don't need spin_lock_irqsave()) but we don't know if the timer_bh is running
@@ -175,20 +182,6 @@ void main_timer_handler(void)
 	if (!using_apic_timer)
 		smp_local_timer_interrupt();
 
-/*
- * If we have an externally synchronized Linux clock, then update CMOS clock
- * accordingly every ~11 minutes. set_rtc_mmss() will be called in the jiffy
- * closest to exactly 500 ms before the next second. If the update fails, we
- * don't care, as it'll be updated on the next turn, and the problem (time way
- * off) isn't likely to go away much sooner anyway.
- */
-
-	if (ntp_synced() && xtime.tv_sec > rtc_update &&
-		abs(xtime.tv_nsec - 500000000) <= tick_nsec / 2) {
-		set_rtc_mmss(xtime.tv_sec);
-		rtc_update = xtime.tv_sec + 660;
-	}
- 
 	write_sequnlock(&xtime_lock);
 }
 
Index: linux-2.6.22-rc4-mm/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/Kconfig	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/Kconfig	2007-06-23 14:38:59.000000000 +0200
@@ -32,6 +32,10 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
 config ZONE_DMA32
 	bool
 	default y

-- 

