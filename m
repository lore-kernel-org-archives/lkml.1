Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYGCMNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYGCMNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbYGCMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:13:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:41455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbYGCMNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:13:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,742,1204531200"; 
   d="scan'208";a="584663125"
Subject: [RFC PATCH] AHCI: speed up resume
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: tj@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:48:02 +0800
Message-Id: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During S3 resume, AHCI driver sleeps 1 second to wait for the HBA reset
to finish. This is luxurious, :)

According to the AHCI 1.2 spec, We should poll the HOST_CTL register,
and return error if the host reset is not finished within 1 second.

Test results show that the HBA reset can be done quickly(in usecs).
And this patch may save nearly 1 second during resume.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
--
 drivers/ata/ahci.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c	2007-05-03 11:06:33.000000000 +0800
+++ linux-2.6/drivers/ata/ahci.c	2008-07-02 16:25:54.000000000 +0800
@@ -1073,18 +1073,29 @@
 
 	/* global controller reset */
 	if (!ahci_skip_host_reset) {
+		int delay = msecs_to_jiffies(1000);
+		int timeout;
+
 		tmp = readl(mmio + HOST_CTL);
 		if ((tmp & HOST_RESET) == 0) {
 			writel(tmp | HOST_RESET, mmio + HOST_CTL);
 			readl(mmio + HOST_CTL); /* flush */
 		}
 
-		/* reset must complete within 1 second, or
+		/*
+ 		 * to perform host reset, OS should set HOST_RESET
+		 * and poll until this bit is read to be "0"
+ 		 * reset must complete within 1 second, or
 		 * the hardware should be considered fried.
 		 */
-		ssleep(1);
+		timeout = jiffies + delay;
+		while (jiffies < timeout) {
+			tmp = readl(mmio + HOST_CTL);
+			if (!(tmp & HOST_RESET))
+				break;
+			cpu_relax();
+		}
 
-		tmp = readl(mmio + HOST_CTL);
 		if (tmp & HOST_RESET) {
 			dev_printk(KERN_ERR, host->dev,
 				   "controller reset failed (0x%x)\n", tmp);


