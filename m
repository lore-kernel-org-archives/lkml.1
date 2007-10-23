Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbXJWU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbXJWU4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXJWU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:56:17 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:56468 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbXJWU4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:56:16 -0400
Message-Id: <20071023205515.406778977@ldl.fc.hp.com>
References: <20071023204843.442608289@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:48:44 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Subject: [patch 1/2] rtc: release correct region in error path
Content-Disposition: inline; filename=rtc-factor
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The misc_register() error path always released an I/O port region,
even if the region was memory-mapped (only mips uses memory-mapped RTC,
as far as I can see).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/char/rtc.c
===================================================================
--- w.orig/drivers/char/rtc.c	2007-10-23 09:59:33.000000000 -0600
+++ w/drivers/char/rtc.c	2007-10-23 14:41:23.000000000 -0600
@@ -918,6 +918,14 @@
 };
 #endif
 
+static void rtc_release_region(void)
+{
+	if (RTC_IOMAPPED)
+		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+	else
+		release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+}
+
 static int __init rtc_init(void)
 {
 #ifdef CONFIG_PROC_FS
@@ -992,10 +1000,7 @@
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
 		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: IRQ %d is not free.\n", RTC_IRQ);
-		if (RTC_IOMAPPED)
-			release_region(RTC_PORT(0), RTC_IO_EXTENT);
-		else
-			release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+		rtc_release_region();
 		return -EIO;
 	}
 	hpet_rtc_timer_init();
@@ -1009,7 +1014,7 @@
 		free_irq(RTC_IRQ, NULL);
 		rtc_has_irq = 0;
 #endif
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+		rtc_release_region();
 		return -ENODEV;
 	}
 
@@ -1091,10 +1096,7 @@
 	if (rtc_has_irq)
 		free_irq (rtc_irq, &rtc_port);
 #else
-	if (RTC_IOMAPPED)
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
-	else
-		release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+	rtc_release_region();
 #ifdef RTC_IRQ
 	if (rtc_has_irq)
 		free_irq (RTC_IRQ, NULL);

--
