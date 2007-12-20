Return-Path: <linux-kernel-owner+w=401wt.eu-S937838AbXLTPtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937838AbXLTPtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966075AbXLTPjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:39:39 -0500
Received: from mail.suse.de ([195.135.220.2]:53769 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966070AbXLTPjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:39:37 -0500
Message-Id: <20071220153935.846818202@stravinsky.suse.de>
User-Agent: quilt/0.46_cvs20071105-2.3
Date: Thu, 20 Dec 2007 16:39:38 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, clemens@ladisch.de
Subject: [patch 3/3] Add HPET RTC emulation to RTC_DRV_CMOS
References: <20071220153935.069780745@stravinsky.suse.de>
Content-Disposition: inline; filename=hpet-rtc-cmos
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That patch adds the RTC emulation of the HPET timer to the new RTC_DRV_CMOS.
The old drivers/char/rtc.ko driver had that functionality and it's important
on new systems.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/Kconfig       |    2 -
 drivers/rtc/rtc-cmos.c |   79 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 67 insertions(+), 14 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -405,7 +405,7 @@ config HPET_TIMER
 
 config HPET_EMULATE_RTC
 	def_bool y
-	depends on HPET_TIMER && (RTC=y || RTC=m)
+	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -35,10 +35,22 @@
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
+#include <asm/hpet.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
 
+#ifndef CONFIG_HPET_EMULATE_RTC
+#define is_hpet_enabled()			0
+#define hpet_set_alarm_time(hrs, min, sec) 	do { } while (0)
+#define hpet_set_periodic_freq(arg) 		0
+#define hpet_mask_rtc_irq_bit(arg) 		do { } while (0)
+#define hpet_set_rtc_irq_bit(arg) 		do { } while (0)
+#define hpet_rtc_timer_init() 			do { } while (0)
+#define hpet_register_irq_handler(h) 		0
+#define hpet_unregister_irq_handler(h)		do { } while (0)
+extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+#endif
 
 struct cmos_rtc {
 	struct rtc_device	*rtc;
@@ -199,6 +211,7 @@ static int cmos_set_alarm(struct device 
 	sec = t->time.tm_sec;
 	sec = (sec < 60) ? BIN2BCD(sec) : 0xff;
 
+	hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min, t->time.tm_sec);
 	spin_lock_irq(&rtc_lock);
 
 	/* next rtc irq must not be from previous alarm setting */
@@ -252,7 +265,8 @@ static int cmos_irq_set_freq(struct devi
 	f = 16 - f;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
+	if (!hpet_set_periodic_freq(freq))
+		CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return 0;
@@ -314,28 +328,37 @@ cmos_rtc_ioctl(struct device *dev, unsig
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
 		rtc_control &= ~RTC_AIE;
+		hpet_mask_rtc_irq_bit(RTC_AIE);
 		break;
 	case RTC_AIE_ON:	/* alarm on */
 		rtc_control |= RTC_AIE;
+		hpet_set_rtc_irq_bit(RTC_AIE);
 		break;
 	case RTC_UIE_OFF:	/* update off */
 		rtc_control &= ~RTC_UIE;
+		hpet_mask_rtc_irq_bit(RTC_UIE);
 		break;
 	case RTC_UIE_ON:	/* update on */
 		rtc_control |= RTC_UIE;
+		hpet_set_rtc_irq_bit(RTC_UIE);
 		break;
 	case RTC_PIE_OFF:	/* periodic off */
 		rtc_control &= ~RTC_PIE;
+		hpet_mask_rtc_irq_bit(RTC_PIE);
 		break;
 	case RTC_PIE_ON:	/* periodic on */
 		rtc_control |= RTC_PIE;
+		hpet_set_rtc_irq_bit(RTC_PIE);
 		break;
 	}
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	if (!is_hpet_enabled())
+		CMOS_WRITE(rtc_control, RTC_CONTROL);
+
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
 	if (is_intr(rtc_intr))
 		rtc_update_irq(cmos->rtc, 1, rtc_intr);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
@@ -475,15 +498,25 @@ static irqreturn_t cmos_interrupt(int ir
 	u8		rtc_control;
 
 	spin_lock(&rtc_lock);
-	irqstat = CMOS_READ(RTC_INTR_FLAGS);
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	/*
+	 * In this case it is HPET RTC interrupt handler
+	 * calling us, with the interrupt information
+	 * passed as arg1, instead of irq.
+	 */
+	if (is_hpet_enabled())
+		irqstat = (unsigned long)irq & 0xF0;
+	else {
+		irqstat = CMOS_READ(RTC_INTR_FLAGS);
+		rtc_control = CMOS_READ(RTC_CONTROL);
+		irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	}
 
 	/* All Linux RTC alarms should be treated as if they were oneshot.
 	 * Similar code may be needed in system wakeup paths, in case the
 	 * alarm woke the system.
 	 */
 	if (irqstat & RTC_AIE) {
+		rtc_control = CMOS_READ(RTC_CONTROL);
 		rtc_control &= ~RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		CMOS_READ(RTC_INTR_FLAGS);
@@ -591,8 +624,9 @@ cmos_do_probe(struct device *dev, struct
 	 * doesn't use 32KHz here ... for portability we might need to
 	 * do something about other clock frequencies.
 	 */
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 	cmos_rtc.rtc->irq_freq = 1024;
+	if (!hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq))
+		CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 
 	/* disable irqs.
 	 *
@@ -615,14 +649,31 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup1;
 	}
 
-	if (is_valid_irq(rtc_irq))
-		retval = request_irq(rtc_irq, cmos_interrupt, IRQF_DISABLED,
-				cmos_rtc.rtc->dev.bus_id,
+	if (is_valid_irq(rtc_irq)) {
+		irq_handler_t rtc_cmos_int_handler;
+
+		if (is_hpet_enabled()) {
+			int err;
+
+			rtc_cmos_int_handler = hpet_rtc_interrupt;
+			err = hpet_register_irq_handler(cmos_interrupt);
+			if (err != 0) {
+				printk(KERN_WARNING "hpet_register_irq_handler "
+						" failed in rtc_init().");
+				goto cleanup1;
+			}
+		} else
+			rtc_cmos_int_handler = cmos_interrupt;
+
+		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
+				IRQF_DISABLED, cmos_rtc.rtc->dev.bus_id,
 				cmos_rtc.rtc);
-	if (retval < 0) {
-		dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
-		goto cleanup1;
+		if (retval < 0) {
+			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
+			goto cleanup1;
+		}
 	}
+	hpet_rtc_timer_init();
 
 	/* export at least the first block of NVRAM */
 	nvram.size = address_space - NVRAM_OFFSET;
@@ -677,8 +728,10 @@ static void __exit cmos_do_remove(struct
 
 	sysfs_remove_bin_file(&dev->kobj, &nvram);
 
-	if (is_valid_irq(cmos->irq))
+	if (is_valid_irq(cmos->irq)) {
 		free_irq(cmos->irq, cmos->rtc);
+		hpet_unregister_irq_handler(cmos_interrupt);
+	}
 
 	rtc_device_unregister(cmos->rtc);
 	cmos->rtc = NULL;

