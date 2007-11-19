Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXKSXGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXKSXGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXKSXF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:05:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:4320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXKSXF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:05:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,438,1188802800"; 
   d="scan'208";a="322627330"
Date: Mon, 19 Nov 2007 15:03:48 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: [PATCH] More Sanity checks for DMAR
Message-ID: <20071119230348.GA18775@linux-os.sc.intel.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds and changes a few sanity checks in dmar.c.

1. The haw field in ACPI DMAR table in VT-d spec doesn't describe the range of
haw. But since DMA page size is 4KB in DMA remapping, haw should be at least
4KB. The current VT-d code in dmar.c returns failure when haw==0. This sanity
check is not accurate and execution can pass when haw is less than one page
size 4KB. This patch changes the haw sanity check to validate if haw is less
than 4KB.
2. Add dmar_rmrr_units verification.
3. Add parse_dmar_table() verification.

Thanks.

-Fenghua

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 dmar.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 5dfdfda..a5b6ed0 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -25,6 +25,7 @@
 
 #include <linux/pci.h>
 #include <linux/dmar.h>
+#include "iova.h"
 
 #undef PREFIX
 #define PREFIX "DMAR:"
@@ -263,8 +264,8 @@ parse_dmar_table(void)
 	if (!dmar)
 		return -ENODEV;
 
-	if (!dmar->width) {
-		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
+	if (dmar->width < PAGE_SHIFT_4K - 1) {
+		printk (KERN_WARNING PREFIX "Invalid DMAR haw\n");
 		return -EINVAL;
 	}
 
@@ -301,11 +302,24 @@ parse_dmar_table(void)
 int __init dmar_table_init(void)
 {
 
-	parse_dmar_table();
+	int ret;
+	
+	ret = parse_dmar_table();
+	if (ret) {
+		printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
+		return ret;
+	}
+
 	if (list_empty(&dmar_drhd_units)) {
 		printk(KERN_INFO PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
+
+	if (list_empty(&dmar_rmrr_units)) {
+		printk(KERN_INFO PREFIX "No RMRR found\n");
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
