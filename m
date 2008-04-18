Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbYDRX0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbYDRX0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYDRXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:19 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48193 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYDRXXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:09 -0400
Message-Id: <6c7546e6a6380ac155282355ec185690ff3a08f1.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: tglx@linutronix.de, a.zummo@towertech.it, rtc-linux@googlegroups.com
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/15] [RTC] minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:23:00 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- pass rtc_int_flag to rtc_interrupt() via the standard method, dev_id

- where irq handler has been analyzed and shown never to use its
  'irq' argument, rename it to 'dummy'

- remove pointless casts from void*

- remove uses of 'irq' function arg where it duplicates information
  already stored in driver-private struct

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/x86/kernel/hpet.c       |    4 ++--
 drivers/char/rtc.c           |    7 ++++---
 drivers/rtc/rtc-at32ap700x.c |    2 +-
 drivers/rtc/rtc-ds1374.c     |    4 ++--
 drivers/rtc/rtc-m48t59.c     |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 36652ea..eddbf39 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -675,7 +675,7 @@ static void hpet_rtc_timer_reinit(void)
 	}
 }
 
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
+irqreturn_t hpet_rtc_interrupt(int dummy, void *dev_id)
 {
 	struct rtc_time curr_time;
 	unsigned long rtc_int_flag = 0;
@@ -707,7 +707,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 	if (rtc_int_flag) {
 		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
 		if (irq_handler)
-			irq_handler(rtc_int_flag, dev_id);
+			irq_handler(-1, (void *) rtc_int_flag);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 5c3142b..6e3de5b 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -235,7 +235,7 @@ static inline unsigned char rtc_is_updating(void)
  *	(See ./arch/XXXX/kernel/time.c for the set_rtc_mmss() function.)
  */
 
-irqreturn_t rtc_interrupt(int irq, void *dev_id)
+irqreturn_t rtc_interrupt(int dummy, void *dev_id)
 {
 	/*
 	 *	Can be an alarm interrupt, update complete interrupt,
@@ -248,12 +248,13 @@ irqreturn_t rtc_interrupt(int irq, void *dev_id)
 	rtc_irq_data += 0x100;
 	rtc_irq_data &= ~0xff;
 	if (is_hpet_enabled()) {
+		unsigned long val = (unsigned long) dev_id;
 		/*
 		 * In this case it is HPET RTC interrupt handler
 		 * calling us, with the interrupt information
-		 * passed as arg1, instead of irq.
+		 * passed as arg2 (dev_id)
 		 */
-		rtc_irq_data |= (unsigned long)irq & 0xF0;
+		rtc_irq_data |= val & 0xF0UL;
 	} else {
 		rtc_irq_data |= (CMOS_READ(RTC_INTR_FLAGS) & 0xF0);
 	}
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 42244f1..3d3461c 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -167,7 +167,7 @@ static int at32_rtc_ioctl(struct device *dev, unsigned int cmd,
 
 static irqreturn_t at32_rtc_interrupt(int irq, void *dev_id)
 {
-	struct rtc_at32ap700x *rtc = (struct rtc_at32ap700x *)dev_id;
+	struct rtc_at32ap700x *rtc = dev_id;
 	unsigned long isr = rtc_readl(rtc, ISR);
 	unsigned long events = 0;
 	int ret = IRQ_NONE;
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 45bda18..06017e1 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -257,12 +257,12 @@ out:
 	return ret;
 }
 
-static irqreturn_t ds1374_irq(int irq, void *dev_id)
+static irqreturn_t ds1374_irq(int dummy, void *dev_id)
 {
 	struct i2c_client *client = dev_id;
 	struct ds1374 *ds1374 = i2c_get_clientdata(client);
 
-	disable_irq_nosync(irq);
+	disable_irq_nosync(client->irq);
 	schedule_work(&ds1374->work);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 013e6c1..5f18c9e 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -283,7 +283,7 @@ static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
  */
 static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
 {
-	struct device *dev = (struct device *)dev_id;
+	struct device *dev = dev_id;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
-- 
1.5.4.1

