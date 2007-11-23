Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbXKWKJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbXKWKJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbXKWKIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:08:42 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:7015 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbXKWKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:08:40 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="56898551:sNHT26897409"
From: Bryan Wu <bryan.wu@analog.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/7] Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
Date: Fri, 23 Nov 2007 18:08:26 +0800
Message-Id: <1195812512-25979-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 1aa709d..303ed6e 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -72,7 +72,7 @@ struct bfin_rtc {
 #define SEC_BITS_OFF    0
 
 /* Some helper functions to convert between the common RTC notion of time
- * and the internal Blackfin notion that is stored in 32bits.
+ * and the internal Blackfin notion that is encoded in 32bits.
  */
 static inline u32 rtc_time_to_bfin(unsigned long now)
 {
@@ -112,6 +112,11 @@ static inline void rtc_bfin_to_tm(u32 rtc_bfin, struct rtc_time *tm)
  * If anyone can point out the obvious solution here, i'm listening :).  This
  * shouldn't be an issue on an SMP or preempt system as this function should
  * only be called with the rtc lock held.
+ *
+ * Other options:
+ *  - disable PREN so the sync happens at 32.768kHZ ... but this changes the
+ *    inc rate for all RTC registers from 1HZ to 32.768kHZ ...
+ *  - use the write complete IRQ
  */
 static void rtc_bfin_sync_pending(void)
 {
@@ -356,12 +361,18 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 	return 0;
 }
 
+/**
+ *	bfin_irq_set_freq - make sure hardware supports requested freq
+ *	@dev: pointer to RTC device structure
+ *	@freq: requested frequency rate
+ *
+ *	The Blackfin RTC can only generate periodic events at 1 per
+ *	second (1 Hz), so reject any attempt at changing it.
+ */
 static int bfin_irq_set_freq(struct device *dev, int freq)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	stampit();
-	rtc->rtc_dev->irq_freq = freq;
-	return 0;
+	return -ENOTTY;
 }
 
 static struct rtc_class_ops bfin_rtc_ops = {
@@ -394,14 +405,13 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err;
 	}
-	rtc->rtc_dev->irq_freq = 0;
-	rtc->rtc_dev->max_user_freq = (2 << 16); /* stopwatch is an unsigned 16 bit reg */
+	rtc->rtc_dev->irq_freq = 1;
 
 	platform_set_drvdata(pdev, rtc);
 
 	return 0;
 
-err:
+ err:
 	kfree(rtc);
 	return ret;
 }
-- 
1.5.3.4
