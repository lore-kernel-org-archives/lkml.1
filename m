Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYG0GlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYG0GlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbYG0Gjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:39:36 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbYG0Gjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=SiiU14dXxTokma926NobM0qvOYpui3pxr5eIsQjLjFr1gi76uxqSLzikrRpoEIf7J1
         eOnqQgLwmLYOj7+clB+t7L+4NHSGm2O1IfxcJGcfmlNQxtOwMgMSQS+lxkqWAInQbcys
         5pVezCaICqXyxXVIP+ArQv7cSNUvzi3yP6QpE=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 8/8] Blackfin RTC Driver: drop PIE/stopwatch code since the hardware can only do a max of 1HZ and this same functionality is provided by UIE
Date: Sun, 27 Jul 2008 14:38:27 +0800
Message-Id: <1217140707-21263-9-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
References: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |   46 ++++++++++++++--------------------------------
 1 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index ceebce7..a1af4c2 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -32,6 +32,15 @@
  * writes to clear status registers complete immediately.
  */
 
+/* It may seem odd that there is no SWCNT code in here (which would be exposed
+ * via the periodic interrupt event, or PIE).  Since the Blackfin RTC peripheral
+ * runs in units of seconds (N/HZ) but the Linux framework runs in units of HZ
+ * (2^N HZ), there is no point in keeping code that only provides 1 HZ PIEs.
+ * The same exact behavior can be accomplished by using the update interrupt
+ * event (UIE).  Maybe down the line the RTC peripheral will suck less in which
+ * case we can re-introduce PIE support.
+ */
+
 #include <linux/bcd.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -151,7 +160,6 @@ static void bfin_rtc_reset(struct device *dev, u16 rtc_ictl)
 	bfin_rtc_sync_pending(dev);
 	bfin_write_RTC_PREN(0x1);
 	bfin_write_RTC_ICTL(rtc_ictl);
-	bfin_write_RTC_SWCNT(0);
 	bfin_write_RTC_ALARM(0);
 	bfin_write_RTC_ISTAT(0xFFFF);
 	rtc->rtc_wrote_regs = 0;
@@ -194,14 +202,6 @@ static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 		}
 	}
 
-	if (rtc_ictl & RTC_ISTAT_STOPWATCH) {
-		if (rtc_istat & RTC_ISTAT_STOPWATCH) {
-			bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
-			events |= RTC_PF | RTC_IRQF;
-			bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-		}
-	}
-
 	if (rtc_ictl & RTC_ISTAT_SEC) {
 		if (rtc_istat & RTC_ISTAT_SEC) {
 			bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
@@ -361,33 +361,14 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 	seq_printf(seq,
 		"alarm_IRQ\t: %s\n"
 		"wkalarm_IRQ\t: %s\n"
-		"seconds_IRQ\t: %s\n"
-		"periodic_IRQ\t: %s\n",
+		"seconds_IRQ\t: %s\n",
 		yesno(ictl & RTC_ISTAT_ALARM),
 		yesno(ictl & RTC_ISTAT_ALARM_DAY),
-		yesno(ictl & RTC_ISTAT_SEC),
-		yesno(ictl & RTC_ISTAT_STOPWATCH));
+		yesno(ictl & RTC_ISTAT_SEC));
 	return 0;
 #undef yesno
 }
 
-static int bfin_irq_set_state(struct device *dev, int enabled)
-{
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-
-	dev_dbg_stamp(dev);
-
-	bfin_rtc_sync_pending(dev);
-
-	if (enabled) {
-		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
-		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-	} else
-		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
-
-	return 0;
-}
-
 static struct rtc_class_ops bfin_rtc_ops = {
 	.open          = bfin_rtc_open,
 	.release       = bfin_rtc_release,
@@ -397,7 +378,6 @@ static struct rtc_class_ops bfin_rtc_ops = {
 	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
-	.irq_set_state = bfin_irq_set_state,
 };
 
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
@@ -416,7 +396,9 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err;
 	}
-	rtc->rtc_dev->irq_freq = 1;
+
+	/* see comment at top of file about stopwatch/PIE */
+	bfin_write_RTC_SWCNT(0);
 
 	platform_set_drvdata(pdev, rtc);
 
-- 
1.5.6

