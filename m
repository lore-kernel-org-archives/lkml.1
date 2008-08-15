Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYHOJMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYHOJMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYHOJL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:11:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16458 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYHOJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:11:26 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="58087370"
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/4] Blackfin RTC Driver: dont let RTC programming in bootloaders randomly cause ~5 second boot delays
Date: Fri, 15 Aug 2008 17:01:20 +0800
Message-Id: <1218790880-12477-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
References: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 9d2da1c..34439ce 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -363,6 +363,7 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 	struct bfin_rtc *rtc;
 	struct device *dev = &pdev->dev;
 	int ret = 0;
+	unsigned long timeout;
 
 	dev_dbg_stamp(dev);
 
@@ -377,6 +378,13 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
 	if (unlikely(ret))
 		goto err;
+	/* sometimes the bootloader touched things, but the write complete was not
+	 * enabled, so let's just do a quick timeout here since the IRQ will not fire ...
+	 */
+	timeout = jiffies + HZ;
+	while (bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING)
+		if (time_after(jiffies, timeout))
+			break;
 	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
-- 
1.5.6
