Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbXJUH5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbXJUH5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbXJUHw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47596 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXJUHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:57 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: a.zummo@towertech.it
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 17/17] RTC interrupt handling cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075256.0975B19041E@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:56 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit f94d41db30d6430bc6d3e53602258d3933f93103
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Oct 21 01:51:50 2007 -0400

    RTC interrupt handling cleanups
    
    arm/mach-integrator/time: arm_rtc_interrupt() never uses its arguments,
    so pass NULL to make this explicit and potentially reduce future
    confusion.
    
    hpet.c and rtc.c: pass rtc_int_flag through the standard data-passing
    mechanism, dev_id (2nd arg).
    
    rtc-at32ap700x, rtc-m48t59.c: delete pointless cast from void*
    
    rtc-bfin: calling spin_lock_irq() in interrupt handler marked
    IRQF_DISABLED is unwise.  Use safer spin_lock_irqsave() instead.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 arch/arm/mach-integrator/time.c |    2 +-
 arch/x86/kernel/hpet.c          |    4 ++--
 drivers/char/rtc.c              |    7 ++++---
 drivers/rtc/rtc-at32ap700x.c    |    2 +-
 drivers/rtc/rtc-bfin.c          |    5 +++--
 drivers/rtc/rtc-m48t59.c        |    2 +-
 6 files changed, 12 insertions(+), 10 deletions(-)

f94d41db30d6430bc6d3e53602258d3933f93103
diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
index 5278f58..5235f64 100644
--- a/arch/arm/mach-integrator/time.c
+++ b/arch/arm/mach-integrator/time.c
@@ -125,7 +125,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
 	xtime.tv_sec = __raw_readl(rtc_base + RTC_DR);
 
 	ret = request_irq(dev->irq[0], arm_rtc_interrupt, IRQF_DISABLED,
-			  "rtc-pl030", dev);
+			  "rtc-pl030", NULL);
 	if (ret)
 		goto map_out;
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 53303f2..7c07653 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -621,7 +621,7 @@ static void hpet_rtc_timer_reinit(void)
 	}
 }
 
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
+irqreturn_t hpet_rtc_interrupt(int dummy, void *dev_id)
 {
 	struct rtc_time curr_time;
 	unsigned long rtc_int_flag = 0;
@@ -651,7 +651,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 
 	if (rtc_int_flag) {
 		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
-		rtc_interrupt(rtc_int_flag, dev_id);
+		rtc_interrupt(-1, (void *) rtc_int_flag);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index ec6b65e..533328b 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -233,7 +233,7 @@ static inline unsigned char rtc_is_updating(void)
  *	(See ./arch/XXXX/kernel/time.c for the set_rtc_mmss() function.)
  */
 
-irqreturn_t rtc_interrupt(int irq, void *dev_id)
+irqreturn_t rtc_interrupt(int dummy, void *dev_id)
 {
 	/*
 	 *	Can be an alarm interrupt, update complete interrupt,
@@ -246,12 +246,13 @@ irqreturn_t rtc_interrupt(int irq, void *dev_id)
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
+		rtc_irq_data |= val & 0xF0;
 	} else {
 		rtc_irq_data |= (CMOS_READ(RTC_INTR_FLAGS) & 0xF0);
 	}
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 2999214..2c1890f 100644
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
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 1aa709d..5afd24c 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -143,10 +143,11 @@ static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
 	unsigned long events = 0;
 	u16 rtc_istat;
+	unsigned long flags;
 
 	stampit();
 
-	spin_lock_irq(&rtc->lock);
+	spin_lock_irqsave(&rtc->lock, flags);
 
 	rtc_istat = bfin_read_RTC_ISTAT();
 
@@ -168,7 +169,7 @@ static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 
 	rtc_update_irq(rtc->rtc_dev, 1, events);
 
-	spin_unlock_irq(&rtc->lock);
+	spin_unlock_irqrestore(&rtc->lock, flags);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index bf60d35..934405d 100644
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
