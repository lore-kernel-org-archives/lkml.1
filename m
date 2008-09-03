Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYIDAKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYIDAKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYIDAJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:09:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:34249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYIDAJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:09:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="41316116"
Message-Id: <20080904000238.193359000@linux-os.sc.intel.com>
References: <20080904000237.746216000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 16:58:34 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [patch 4/5] dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
Content-Disposition: inline; filename=safe_traversal_in_dmar.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()

In dmar_dev_scope_init(), functions called under for_each_drhd_unit()/
for_each_rmrr_units() can delete the list entry under some error conditions.

So we should use list_for_each_entry_safe() for safe traversal.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-09-03 14:43:02.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-09-03 14:50:15.000000000 -0700
@@ -397,10 +397,10 @@
 
 int __init dmar_dev_scope_init(void)
 {
-	struct dmar_drhd_unit *drhd;
+	struct dmar_drhd_unit *drhd, *drhd_n;
 	int ret = -ENODEV;
 
-	for_each_drhd_unit(drhd) {
+	list_for_each_entry_safe(drhd, drhd_n, &dmar_drhd_units, list) {
 		ret = dmar_parse_dev(drhd);
 		if (ret)
 			return ret;
@@ -408,8 +408,8 @@
 
 #ifdef CONFIG_DMAR
 	{
-		struct dmar_rmrr_unit *rmrr;
-		for_each_rmrr_units(rmrr) {
+		struct dmar_rmrr_unit *rmrr, *rmrr_n;
+		list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
 			ret = rmrr_parse_dev(rmrr);
 			if (ret)
 				return ret;

-- 

