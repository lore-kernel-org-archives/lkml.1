Return-Path: <linux-kernel-owner+w=401wt.eu-S937915AbXLTPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937915AbXLTPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966079AbXLTPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:39:40 -0500
Received: from mail.suse.de ([195.135.220.2]:53765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966068AbXLTPjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:39:37 -0500
Message-Id: <20071220153935.647364626@stravinsky.suse.de>
User-Agent: quilt/0.46_cvs20071105-2.3
Date: Thu, 20 Dec 2007 16:39:37 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, clemens@ladisch.de
Subject: [patch 2/3] Use the IRQ callback interface in (old) RTC driver
References: <20071220153935.069780745@stravinsky.suse.de>
Content-Disposition: inline; filename=use-exported-operations-in-rtc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That function uses the new registration callback mechanism which was added in
the previous patch in the old RTC driver. It also removes the direct
rtc_interrupt() call from arch/x86/kernel/hpetc.c so that there's finally
no (code) dependency to CONFIG_RTC in arch/x86/kernel/hpet.c.

Because of this, it's possible to compile the drivers/char/rtc.ko driver
as module and still use the HPET emulation functionality. This is also
expressed in Kconfig.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/Kconfig       |    2 +-
 arch/x86/kernel/hpet.c |    2 --
 drivers/char/rtc.c     |   15 ++++++++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -405,7 +405,7 @@ config HPET_TIMER
 
 config HPET_EMULATE_RTC
 	def_bool y
-	depends on HPET_TIMER && RTC=y
+	depends on HPET_TIMER && (RTC=y || RTC=m)
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -708,8 +708,6 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
 		if (irq_handler)
 			irq_handler(rtc_int_flag, dev_id);
-
-		rtc_interrupt(rtc_int_flag, dev_id);
 	}
 	return IRQ_HANDLED;
 }
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -110,6 +110,8 @@ static int rtc_has_irq = 1;
 #define hpet_set_rtc_irq_bit(arg)		0
 #define hpet_rtc_timer_init()			do { } while (0)
 #define hpet_rtc_dropped_irq()			0
+#define hpet_register_irq_handler(h)		0
+#define hpet_unregister_irq_handler(h)		0
 #ifdef RTC_IRQ
 static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {
@@ -1027,7 +1029,15 @@ no_irq:
 
 #ifdef RTC_IRQ
 	if (is_hpet_enabled()) {
+		int err;
+
 		rtc_int_handler_ptr = hpet_rtc_interrupt;
+		err = hpet_register_irq_handler(rtc_interrupt);
+		if (err != 0) {
+			printk(KERN_WARNING "hpet_register_irq_handler failed "
+					"in rtc_init().");
+			return err;
+		}
 	} else {
 		rtc_int_handler_ptr = rtc_interrupt;
 	}
@@ -1050,6 +1060,7 @@ no_irq:
 	if (misc_register(&rtc_dev)) {
 #ifdef RTC_IRQ
 		free_irq(RTC_IRQ, NULL);
+		hpet_unregister_irq_handler(rtc_interrupt);
 		rtc_has_irq = 0;
 #endif
 		rtc_release_region();
@@ -1141,8 +1152,10 @@ static void __exit rtc_exit(void)
 #else
 	rtc_release_region();
 #ifdef RTC_IRQ
-	if (rtc_has_irq)
+	if (rtc_has_irq) {
 		free_irq(RTC_IRQ, NULL);
+		hpet_unregister_irq_handler(hpet_rtc_interrupt);
+	}
 #endif
 #endif /* CONFIG_SPARC32 */
 }

