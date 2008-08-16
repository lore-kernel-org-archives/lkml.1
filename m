Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYHPBkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYHPBkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 21:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYHPBjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 21:39:52 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:22266 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752944AbYHPBjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:39:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=SCXUXx7NVo737prseoWr1FagPxf6DNjlMsHc1WYrDsNsQgTw6BOMsF5yuGrO7ScM/oSHBRnrIKQA8mV1dnwhVMIDnCsOI+vhqoxO5EXmCC2/FWpnxaIhR7Bt7PHxPoakjV6YjKrZBdWiPOgLy9bRmMraIXZk6zLJvI9JFuBygdM=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27-rc3] rtc-cmos: strongly avoid "HPET emulation"
Date: Fri, 15 Aug 2008 18:39:47 -0700
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808151839.48038.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add a new mechanism to the rtc-cmos platform glue:  an irq_handler_t
can now "filter" the interrupts.

Update rtc-cmos to use that mechanism where it's been set up, instead 
of "HPET emulation".  http://bugzilla.kernel.org/show_bug.cgi?id=11153
shows the problem:  that emulation makes update interrupts misbehave
wildly, and thus makes NTP synch tools malfunction.

Make ACPI glue always set this using ACPI "events".  That seems to
work even if HPET isn't set up for "legacy replacement mode", which
reroutes RTC irqs to SCI.  In the future, ACPI might need to blacklist
some boards where ACPI event handling doesn't work as well as "real"
IRQs, yet booting "hpet=disable" isn't OK.  For now we work around
such problems by leaving ACPI RTC event code disabled most of the time.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
CC'd ACPI team since this already works around at least two bugs
in the ACPI event handling, or is it BIOS code?, and I don't have
a good handle on what other surprises may lurk there.  Should the
RTC just request_irq(SCI, IRQF_SHARED, ...), in case of boards that
don't expose this particular ACPI event?  If so, how can it know the
SCI irq?  Maybe this should cook a while and not merge til 2.6.28 ...

 drivers/acpi/glue.c         |   27 ++++++++---
 drivers/rtc/rtc-cmos.c      |  102 ++++++++++++++++++++++++++++++++------------
 include/linux/mc146818rtc.h |    1 
 3 files changed, 97 insertions(+), 33 deletions(-)

--- a/drivers/acpi/glue.c	2008-08-13 12:47:15.000000000 -0700
+++ b/drivers/acpi/glue.c	2008-08-13 12:48:28.000000000 -0700
@@ -11,6 +11,8 @@
 #include <linux/device.h>
 #include <linux/rwsem.h>
 #include <linux/acpi.h>
+#include <linux/interrupt.h>
+
 
 #define ACPI_GLUE_DEBUG	0
 #if ACPI_GLUE_DEBUG
@@ -261,14 +263,29 @@ arch_initcall(init_acpi_device_notify);
 
 #if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
 
-#ifdef CONFIG_PM
+static irq_handler_t handler;
+static void *irq_context;
+
 static u32 rtc_handler(void *context)
 {
+	/* Handler will clear status at the IRQ chip; this matters most
+	 * when RTC irqs are routed through ACPI because of HPET.
+	 */
+	if (handler)
+		handler(0, irq_context);
+	else
+		acpi_disable_event(ACPI_EVENT_RTC, 0);
+
 	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	return ACPI_INTERRUPT_HANDLED;
 }
 
+static void rtc_set_filter(irq_handler_t h, void *c)
+{
+	handler = h;
+	irq_context = c;
+}
+
 static inline void rtc_wake_setup(void)
 {
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, NULL);
@@ -290,11 +307,6 @@ static void rtc_wake_off(struct device *
 {
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
-#else
-#define rtc_wake_setup()	do{}while(0)
-#define rtc_wake_on		NULL
-#define rtc_wake_off		NULL
-#endif
 
 /* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
  * its device node and pass extra config data.  This helps its driver use
@@ -338,6 +350,7 @@ static int __init acpi_rtc_init(void)
 
 	if (dev) {
 		rtc_wake_setup();
+		rtc_info.set_filter = rtc_set_filter;
 		rtc_info.wake_on = rtc_wake_on;
 		rtc_info.wake_off = rtc_wake_off;
 
--- a/drivers/rtc/rtc-cmos.c	2008-08-13 12:47:15.000000000 -0700
+++ b/drivers/rtc/rtc-cmos.c	2008-08-13 13:43:27.000000000 -0700
@@ -45,6 +45,7 @@ struct cmos_rtc {
 	int			irq;
 	struct resource		*iomem;
 
+	void			(*set_filter)(irq_handler_t h, void *c);
 	void			(*wake_on)(struct device *);
 	void			(*wake_off)(struct device *);
 
@@ -55,6 +56,7 @@ struct cmos_rtc {
 	u8			day_alrm;
 	u8			mon_alrm;
 	u8			century;
+	bool			hpet_emulation;
 };
 
 /* both platform and pnp busses use negative numbers for invalid irqs */
@@ -84,11 +86,14 @@ static inline int is_intr(u8 rtc_intr)
  * other (better) use.
  *
  * When that broken mode is in use, platform glue provides a partial
- * emulation of hardware RTC IRQ facilities using HPET #1.  We don't
- * want to use HPET for anything except those IRQs though...
+ * emulation of hardware RTC IRQ facilities using HPET comparator #1.
+ * We'll use that if we have no choice, but normally we can just let
+ * ACPI filter the real RTC interrupts through to us.
  */
 #ifdef CONFIG_HPET_EMULATE_RTC
 #include <asm/hpet.h>
+#define IRQ_FILTER_TYPE		"ACPI"	/* all but certainly */
+
 #else
 
 static inline int is_hpet_enabled(void)
@@ -98,6 +103,7 @@ static inline int is_hpet_enabled(void)
 
 static inline int hpet_mask_rtc_irq_bit(unsigned long mask)
 {
+	/* we "know":  won't touch hardware in emulation */
 	return 0;
 }
 
@@ -109,11 +115,13 @@ static inline int hpet_set_rtc_irq_bit(u
 static inline int
 hpet_set_alarm_time(unsigned char hrs, unsigned char min, unsigned char sec)
 {
+	/* we "know":  won't touch hardware in emulation */
 	return 0;
 }
 
 static inline int hpet_set_periodic_freq(unsigned long freq)
 {
+	/* we "know":  won't touch hardware in emulation */
 	return 0;
 }
 
@@ -139,6 +147,8 @@ static inline int hpet_unregister_irq_ha
 	return 0;
 }
 
+#define IRQ_FILTER_TYPE		"filtered"
+
 #endif
 
 /*----------------------------------------------------------------*/
@@ -244,7 +254,7 @@ static void cmos_checkintr(struct cmos_r
 	 */
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 
-	if (is_hpet_enabled())
+	if (cmos->hpet_emulation)
 		return;
 
 	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
@@ -262,9 +272,15 @@ static void cmos_irq_enable(struct cmos_
 	rtc_control = CMOS_READ(RTC_CONTROL);
 	cmos_checkintr(cmos, rtc_control);
 
+	/* enable filtering whenever IRQs are enabled */
+	if (!(rtc_control & RTC_IRQMASK) && cmos->set_filter)
+		cmos->wake_on(cmos->dev);
+
 	rtc_control |= mask;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
-	hpet_set_rtc_irq_bit(mask);
+
+	if (cmos->hpet_emulation)
+		hpet_set_rtc_irq_bit(mask);
 
 	cmos_checkintr(cmos, rtc_control);
 }
@@ -278,6 +294,10 @@ static void cmos_irq_disable(struct cmos
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
 	hpet_mask_rtc_irq_bit(mask);
 
+	/* disable filtering when IRQs are disabled */
+	if (!(rtc_control & RTC_IRQMASK) && cmos->set_filter)
+		cmos->wake_off(cmos->dev);
+
 	cmos_checkintr(cmos, rtc_control);
 }
 
@@ -450,7 +470,7 @@ static int cmos_procfs(struct device *de
 			"batt_status\t: %s\n",
 			(rtc_control & RTC_PIE) ? "yes" : "no",
 			(rtc_control & RTC_UIE) ? "yes" : "no",
-			is_hpet_enabled() ? "yes" : "no",
+			cmos->hpet_emulation ? "yes" : "no",
 			// (rtc_control & RTC_SQWE) ? "yes" : "no",
 			// (rtc_control & RTC_DM_BINARY) ? "no" : "yes",
 			(rtc_control & RTC_DST_EN) ? "yes" : "no",
@@ -567,7 +587,7 @@ static irqreturn_t cmos_interrupt(int ir
 	 */
 	irqstat = CMOS_READ(RTC_INTR_FLAGS);
 	rtc_control = CMOS_READ(RTC_CONTROL);
-	if (is_hpet_enabled())
+	if (cmos_rtc.hpet_emulation)
 		irqstat = (unsigned long)irq & 0xF0;
 	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
 
@@ -663,6 +683,18 @@ cmos_do_probe(struct device *dev, struct
 		if (info->wake_on && info->wake_off) {
 			cmos_rtc.wake_on = info->wake_on;
 			cmos_rtc.wake_off = info->wake_off;
+
+			/* We really want to avoid "HPET emulation".  Since
+			 * the real RTC IRQs get routed to SCI, and thence
+			 * through ACPI, let ACPI deliver those IRQs to us.
+			 *
+			 * Some flakey-board issues -- spurious IRQs, and
+			 * nonfunctional ACPI interrupts -- are reasons to
+			 * avoid the simpler solution of always using ACPI
+			 * routing, when available.
+			 */
+			if (is_hpet_enabled())
+				cmos_rtc.set_filter = info->set_filter;
 		}
 	}
 
@@ -705,7 +737,9 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup1;
 	}
 
-	if (is_valid_irq(rtc_irq)) {
+	if (cmos_rtc.set_filter)
+		cmos_rtc.set_filter(cmos_interrupt, cmos_rtc.rtc);
+	else if (is_valid_irq(rtc_irq)) {
 		irq_handler_t rtc_cmos_int_handler;
 
 		if (is_hpet_enabled()) {
@@ -718,6 +752,7 @@ cmos_do_probe(struct device *dev, struct
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
+			cmos_rtc.hpet_emulation = true;
 		} else
 			rtc_cmos_int_handler = cmos_interrupt;
 
@@ -728,8 +763,10 @@ cmos_do_probe(struct device *dev, struct
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
 			goto cleanup1;
 		}
+
+		if (cmos_rtc.hpet_emulation)
+			hpet_rtc_timer_init();
 	}
-	hpet_rtc_timer_init();
 
 	/* export at least the first block of NVRAM */
 	nvram.size = address_space - NVRAM_OFFSET;
@@ -739,23 +776,29 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s%s\n",
+	pr_info("%s: alarms up to one %s%s, %s irqs\n",
 			cmos_rtc.rtc->dev.bus_id,
-			is_valid_irq(rtc_irq)
-				?  (cmos_rtc.mon_alrm
-					? "year"
-					: (cmos_rtc.day_alrm
-						? "month" : "day"))
-				: "no",
+			cmos_rtc.mon_alrm
+				? "year"
+				: (cmos_rtc.day_alrm
+					? "month" : "day"),
 			cmos_rtc.century ? ", y3k" : "",
-			is_hpet_enabled() ? ", hpet irqs" : "");
+			cmos_rtc.set_filter
+				? IRQ_FILTER_TYPE
+				: (is_valid_irq(rtc_irq)
+					? (cmos_rtc.hpet_emulation
+						? "hpet" : "native")
+					: "no"));
 
 	return 0;
 
 cleanup2:
-	if (is_valid_irq(rtc_irq))
+	if (cmos_rtc.set_filter)
+		cmos_rtc.set_filter(NULL, NULL);
+	else if (is_valid_irq(rtc_irq))
 		free_irq(rtc_irq, cmos_rtc.rtc);
 cleanup1:
+	hpet_unregister_irq_handler(cmos_interrupt);
 	cmos_rtc.dev = NULL;
 	rtc_device_unregister(cmos_rtc.rtc);
 cleanup0:
@@ -779,7 +822,9 @@ static void __exit cmos_do_remove(struct
 
 	sysfs_remove_bin_file(&dev->kobj, &nvram);
 
-	if (is_valid_irq(cmos->irq)) {
+	if (cmos_rtc.set_filter)
+		cmos_rtc.set_filter(NULL, NULL);
+	else if (is_valid_irq(cmos->irq)) {
 		free_irq(cmos->irq, cmos->rtc);
 		hpet_unregister_irq_handler(cmos_interrupt);
 	}
@@ -823,9 +868,11 @@ static int cmos_suspend(struct device *d
 
 	if (tmp & RTC_AIE) {
 		cmos->enabled_wake = 1;
-		if (cmos->wake_on)
-			cmos->wake_on(dev);
-		else
+		if (cmos->wake_on) {
+			/* already enabled if filtering is in use */
+			if (!cmos->set_filter)
+				cmos->wake_on(dev);
+		} else
 			enable_irq_wake(cmos->irq);
 	}
 
@@ -847,9 +894,11 @@ static int cmos_resume(struct device *de
 		unsigned char	mask;
 
 		if (cmos->enabled_wake) {
-			if (cmos->wake_off)
-				cmos->wake_off(dev);
-			else
+			if (cmos->wake_off) {
+				/* leave enabled if filtering is in use */
+				if (!cmos->set_filter)
+					cmos->wake_off(dev);
+			} else
 				disable_irq_wake(cmos->irq);
 			cmos->enabled_wake = 0;
 		}
@@ -857,11 +906,12 @@ static int cmos_resume(struct device *de
 		spin_lock_irq(&rtc_lock);
 		do {
 			CMOS_WRITE(tmp, RTC_CONTROL);
-			hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
+			if (cmos->hpet_emulation)
+				hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
 
 			mask = CMOS_READ(RTC_INTR_FLAGS);
 			mask &= (tmp & RTC_IRQMASK) | RTC_IRQF;
-			if (!is_hpet_enabled() || !is_intr(mask))
+			if (!cmos->hpet_emulation || !is_intr(mask))
 				break;
 
 			/* force one-shot behavior if HPET blocked
--- a/include/linux/mc146818rtc.h	2008-08-13 12:47:15.000000000 -0700
+++ b/include/linux/mc146818rtc.h	2008-08-13 12:48:28.000000000 -0700
@@ -28,6 +28,7 @@ extern spinlock_t rtc_lock;		/* serializ
  * a separate wakeup alarm used by some almost-clone chips.
  */
 struct cmos_rtc_board_info {
+	void	(*set_filter)(irq_handler_t handler, void *context);
 	void	(*wake_on)(struct device *dev);
 	void	(*wake_off)(struct device *dev);
 
