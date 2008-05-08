Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbYEHSd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbYEHSd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbYEHSdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:33:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:55467 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753113AbYEHSdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:33:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,455,1204531200"; 
   d="scan'208";a="562373843"
Date: Thu, 8 May 2008 11:40:54 -0700
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Make intel iommu_wait_op work with jiffies arn't running
Message-ID: <20080508184054.GA20557@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that a few times when the bios is buggy the code for
detecting failing DMAR hardware can get stuck in an infinite loop in
early boot waiting for jiffies to time out.  Which are not running at
the time we get stuck in this macro.

This patch replaces the use of the jiffies to detect the failing
hardware with the tsc counter.  Not a big change, instead of getting a
black screen forever, you get a panic...

I also changed the time out from an arbitrary 60 seconds to an arbitrary
10 seconds.

--mgross

Signed-Off-by: mark gross <mgross@linux.intel.com>


Index: linux-next/drivers/pci/intel-iommu.c
===================================================================
--- linux-next.orig/drivers/pci/intel-iommu.c	2008-05-08 11:02:21.000000000 -0700
+++ linux-next/drivers/pci/intel-iommu.c	2008-05-08 11:13:02.000000000 -0700
@@ -49,7 +49,7 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
 
-#define DMAR_OPERATION_TIMEOUT (HZ*60) /* 1m */
+#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
 
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
@@ -490,13 +490,13 @@
 
 #define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
 {\
-	unsigned long start_time = jiffies;\
+	cycles_t start_time = get_cycles();\
 	while (1) {\
 		sts = op (iommu->reg + offset);\
 		if (cond)\
 			break;\
-		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))\
-			panic("DMAR hardware is malfunctioning\n");\
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
+			panic(KERN_ERR "DMAR hardware is malfunctioning\n");\
 		cpu_relax();\
 	}\
 }
