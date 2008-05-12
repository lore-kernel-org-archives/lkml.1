Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYELUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYELUey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYELUeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:34:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:17618 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755963AbYELUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,475,1204531200"; 
   d="scan'208";a="382930043"
Date: Mon, 12 May 2008 13:41:57 -0700
From: mark gross <mgross@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH]Make the intel-iommu_wait_op macro work when jiffies are
	not running
Message-ID: <20080512204157.GA32017@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch changes the intel-iommu.c code to use the TSC
instead of jiffies for detecting bad DMAR functionality.  Some systems
with bad bios's have been seen to hang in early boot spinning in the
IOMMU_WAIT_IO macro.  This patch will replace the forever spin with a
call to panic.


diffstat:
$ diffstat patches/wait_op_tsc.patch 
 intel-iommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--mgross

Signed-off-by:mark gross <mgross@linux.intel.com>


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
+			panic("DMAR hardware is malfunctioning\n");\
 		cpu_relax();\
 	}\
 }
