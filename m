Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYG0Gk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYG0Gk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbYG0Gj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:39:29 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845AbYG0Gj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=PbcXWYGqqLu3KrkRBOCeJiy81NgihkB2So53ezhtzDQJpj14SEOVYDWCmJCbSc/4/w
         Jxp7b4L/CqYvWurH4eQ6F/YIoFo+b5NxL31MADDc8hYY0J7J+veucAZjoy7Y/o5JNEDZ
         vO6FekD0M3ixE6ada4FhBtJVvKR8n8Aw0DC0w=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 7/8] Blackfin RTC Driver: convert PIE handling to irq_set_state() as pointed out by David Brownell
Date: Sun, 27 Jul 2008 14:38:26 +0800
Message-Id: <1217140707-21263-8-git-send-email-cooloney@kernel.org>
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
 drivers/rtc/rtc-bfin.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index e6b0470..ceebce7 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -264,16 +264,6 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 	bfin_rtc_sync_pending(dev);
 
 	switch (cmd) {
-	case RTC_PIE_ON:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
-		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-		break;
-	case RTC_PIE_OFF:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
-		break;
-
 	case RTC_UIE_ON:
 		dev_dbg_stamp(dev);
 		bfin_rtc_int_set(RTC_ISTAT_SEC);
@@ -381,6 +371,23 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 #undef yesno
 }
 
+static int bfin_irq_set_state(struct device *dev, int enabled)
+{
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
+
+	dev_dbg_stamp(dev);
+
+	bfin_rtc_sync_pending(dev);
+
+	if (enabled) {
+		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
+		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
+	} else
+		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
+
+	return 0;
+}
+
 static struct rtc_class_ops bfin_rtc_ops = {
 	.open          = bfin_rtc_open,
 	.release       = bfin_rtc_release,
@@ -390,6 +397,7 @@ static struct rtc_class_ops bfin_rtc_ops = {
 	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
+	.irq_set_state = bfin_irq_set_state,
 };
 
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
-- 
1.5.6

