Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZEEDqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZEEDqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbZEEDpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:45:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:42053 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbZEEDpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:45:46 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] EDAC: Delete device soft lockup fix
Date: Tue,  5 May 2009 11:46:20 +0800
Message-Id: <1241495180-15193-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1241495180-15193-1-git-send-email-qingtao.cao@windriver.com>
References: <1241495180-15193-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 05 May 2009 03:45:38.0098 (UTC) FILETIME=[F4361120:01C9CD33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delayed_work structure will be setup for EDAC Memory Controller,
EDAC PCI Device and common Device only in POLL mode, so it should be
teardown only in POLL mode as well. Otherwise, trying to delete an
uninitialized timer will cause soft lockup as below call trace on
Maple platform:

...
NIP [c000000000057ba8] .lock_timer_base+0x24/0x94
LR [c000000000057c3c] .try_to_del_timer_sync+0x24/0x8c
Call Trace:
[...] [c00000000067acc8] debug_table+0xb290/0x1af60 (unreliable)
[...] [c000000000057c3c] .try_to_del_timer_sync+0x24/0x8c
[...] [c000000000057cc0] .del_timer_sync+0x1c/0x44
[...] [d000000000036c78] .edac_pci_workq_teardown+0x48/0x98 [edac_core]
[...] [d000000000036d64] .edac_pci_del_device+0x9c/0xd8 [edac_core]
[...] [d00000000005e654] .amd8111_pci_remove+0xb8/0xec [amd8111_edac]
[...] [c0000000002349ec] .pci_device_remove+0x50/0x90
[...] [c00000000026a620] .__device_release_driver+0x90/0xd0
[...] [c00000000026ae40] .driver_detach+0xf8/0x12c
[...] [c00000000026928c] .bus_remove_driver+0xc4/0x124
[...] [c00000000026af18] .driver_unregister+0x60/0x80
[...] [c000000000234da0] .pci_unregister_driver+0x60/0xfc
[...] [d00000000005f414] .amd8111_edac_exit+0x24/0x4c [amd8111_edac]
[...] [c00000000007afa8] .SyS_delete_module+0x230/0x2cc
[...] [c0000000000074ac] syscall_exit+0x0/0x40

This can be addressed by invoking edac_xxxx_workq_teardown() only
when related edac_check pointer is not NULL.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/edac_device.c |    3 ++-
 drivers/edac/edac_mc.c     |    4 +++-
 drivers/edac/edac_pci.c    |    3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 68ffb0f..626e32a 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -610,7 +610,8 @@ struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
 	mutex_unlock(&device_ctls_mutex);
 
 	/* clear workq processing on this instance */
-	edac_device_workq_teardown(edac_dev);
+	if (edac_dev->edac_check != NULL)
+		edac_device_workq_teardown(edac_dev);
 
 	/* Tear down the sysfs entries for this instance */
 	edac_device_remove_sysfs(edac_dev);
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 25d6694..6ed6fa3 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -560,7 +560,9 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* flush workq processes and remove sysfs */
-	edac_mc_workq_teardown(mci);
+	if (mci->edac_check != NULL)
+		edac_mc_workq_teardown(mci);
+
 	edac_remove_sysfs_mci_device(mci);
 
 	edac_printk(KERN_INFO, EDAC_MC,
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 5b150ae..c6a4829 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -425,7 +425,8 @@ struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev)
 	mutex_unlock(&edac_pci_ctls_mutex);
 
 	/* stop the workq timer */
-	edac_pci_workq_teardown(pci);
+	if (pci->edac_check != NULL)
+		edac_pci_workq_teardown(pci);
 
 	edac_printk(KERN_INFO, EDAC_PCI,
 		"Removed device %d for %s %s: DEV %s\n",
-- 
1.5.6.2

