Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYG0GkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYG0GkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYG0GjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:39:11 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbYG0GjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=M8qmD6DGXRoACazwWEUQ7y6yD8Pvxt2ljDA2EbUANy65N3bCVPdHYl3kQDx1mFTsOt
         n5y6nOVU3SiXaruYgGAQE+RJCNo80alCAGloy50czxTlwF851ue8ScmT+oSzNw8Yaha/
         xko9oGvLcBdflxUY3WCxZn4FBwDsEfzNF1rQk=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/8] Blackfin RTC Driver: disable the write complete irq upon close
Date: Sun, 27 Jul 2008 14:38:24 +0800
Message-Id: <1217140707-21263-6-git-send-email-cooloney@kernel.org>
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
 drivers/rtc/rtc-bfin.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 56656dd..d53772f 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -144,13 +144,13 @@ static void bfin_rtc_sync_pending(struct device *dev)
  * Initialize the RTC.  Enable pre-scaler to scale RTC clock
  * to 1Hz and clear interrupt/status registers.
  */
-static void bfin_rtc_reset(struct device *dev)
+static void bfin_rtc_reset(struct device *dev, u16 rtc_ictl)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
 	bfin_rtc_sync_pending(dev);
 	bfin_write_RTC_PREN(0x1);
-	bfin_write_RTC_ICTL(RTC_ISTAT_WRITE_COMPLETE);
+	bfin_write_RTC_ICTL(rtc_ictl);
 	bfin_write_RTC_SWCNT(0);
 	bfin_write_RTC_ALARM(0);
 	bfin_write_RTC_ISTAT(0xFFFF);
@@ -226,7 +226,7 @@ static int bfin_rtc_open(struct device *dev)
 
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, to_platform_device(dev)->name, dev);
 	if (!ret)
-		bfin_rtc_reset(dev);
+		bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 
 	return ret;
 }
@@ -234,7 +234,7 @@ static int bfin_rtc_open(struct device *dev)
 static void bfin_rtc_release(struct device *dev)
 {
 	dev_dbg_stamp(dev);
-	bfin_rtc_reset(dev);
+	bfin_rtc_reset(dev, 0);
 	free_irq(IRQ_RTC, dev);
 }
 
-- 
1.5.6

