Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYDJABb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYDJABb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYDJABK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:01:10 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:15380 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754306AbYDJABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:01:08 -0400
Date: Wed, 09 Apr 2008 18:01:05 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/2] EDAC remove unneeded functions and add static
 accessor
Message-ID: <47fd58c1.FnXAunJY/g71NvbN%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Adrian Bunk <bunk@kernel.org>

diff against 2.6.25-rc8-mm1

Collection of patches, merged into one, from Adrian that do the following:

1) This patch makes the following needlessly global functions static:
- edac_pci_get_log_pe()
- edac_pci_get_log_npe()
- edac_pci_get_panic_on_pe()
- edac_pci_unregister_sysfs_instance_kobj()
- edac_pci_main_kobj_setup()

2) Remove unneeded function edac_device_find()

3) Added #if 0 around function  edac_pci_find()

4) make the needlessly global edac_pci_generic_check() static

5) Removed function edac_check_mc_devices()

Doug Thompson modified Adrian's patches, to bettern represent
the direction of EDAC, and make them one patch.

Cc:		Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by:	Adrian Bunk <bunk@kernel.org>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 2.6.25-rc8-mm1                                     |    5 ---
 linux-2.6.25-rc8-mm1/drivers/edac/edac_device.c    |   31 ---------------------
 linux-2.6.25-rc8-mm1/drivers/edac/edac_mc.c        |   21 --------------
 linux-2.6.25-rc8-mm1/drivers/edac/edac_module.h    |    1
 linux-2.6.25-rc8-mm1/drivers/edac/edac_pci.c       |    6 +++-
 linux-2.6.25-rc8-mm1/drivers/edac/edac_pci_sysfs.c |   11 ++++---
 6 files changed, 11 insertions(+), 64 deletions(-)

Index: linux-2.6.25-rc8-mm1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/edac_mc.c
@@ -886,24 +886,3 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 	mci->csrows[csrow].channels[channel].ce_count++;
 }
 EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
-
-/*
- * Iterate over all MC instances and check for ECC, et al, errors
- */
-void edac_check_mc_devices(void)
-{
-	struct list_head *item;
-	struct mem_ctl_info *mci;
-
-	debugf3("%s()\n", __func__);
-	mutex_lock(&mem_ctls_mutex);
-
-	list_for_each(item, &mc_devices) {
-		mci = list_entry(item, struct mem_ctl_info, link);
-
-		if (mci->edac_check != NULL)
-			mci->edac_check(mci);
-	}
-
-	mutex_unlock(&mem_ctls_mutex);
-}
Index: linux-2.6.25-rc8-mm1/drivers/edac/edac_module.h
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/edac_module.h
+++ linux-2.6.25-rc8-mm1/drivers/edac/edac_module.h
@@ -27,7 +27,6 @@ extern int edac_mc_register_sysfs_main_k
 extern void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci);
 extern int edac_create_sysfs_mci_device(struct mem_ctl_info *mci);
 extern void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci);
-extern void edac_check_mc_devices(void);
 extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
 extern int edac_get_panic_on_ue(void);
Index: linux-2.6.25-rc8-mm1/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/edac_device.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/edac_device.c
@@ -375,37 +375,6 @@ static void del_edac_device_from_global_
 	wait_for_completion(&edac_device->removal_complete);
 }
 
-/**
- * edac_device_find
- *	Search for a edac_device_ctl_info structure whose index is 'idx'.
- *
- * If found, return a pointer to the structure.
- * Else return NULL.
- *
- * Caller must hold device_ctls_mutex.
- */
-struct edac_device_ctl_info *edac_device_find(int idx)
-{
-	struct list_head *item;
-	struct edac_device_ctl_info *edac_dev;
-
-	/* Iterate over list, looking for exact match of ID */
-	list_for_each(item, &edac_device_list) {
-		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
-
-		if (edac_dev->dev_idx >= idx) {
-			if (edac_dev->dev_idx == idx)
-				return edac_dev;
-
-			/* not on list, so terminate early */
-			break;
-		}
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(edac_device_find);
-
 /*
  * edac_device_workq_function
  *	performs the operation scheduled by a workq request
Index: linux-2.6.25-rc8-mm1/drivers/edac/edac_pci.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/edac_pci.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/edac_pci.c
@@ -189,6 +189,9 @@ static void del_edac_pci_from_global_lis
 	wait_for_completion(&pci->complete);
 }
 
+#if 0
+/* Older code, but might use in the future */
+
 /*
  * edac_pci_find()
  * 	Search for an edac_pci_ctl_info structure whose index is 'idx'
@@ -219,6 +222,7 @@ struct edac_pci_ctl_info *edac_pci_find(
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(edac_pci_find);
+#endif
 
 /*
  * edac_pci_workq_function()
@@ -422,7 +426,7 @@ EXPORT_SYMBOL_GPL(edac_pci_del_device);
  *
  *	a Generic parity check API
  */
-void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
+static void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
 	debugf4("%s()\n", __func__);
 	edac_pci_do_parity_check();
Index: linux-2.6.25-rc8-mm1/drivers/edac/edac_pci_sysfs.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/edac_pci_sysfs.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/edac_pci_sysfs.c
@@ -37,17 +37,17 @@ int edac_pci_get_check_errors(void)
 	return check_pci_errors;
 }
 
-int edac_pci_get_log_pe(void)
+static int edac_pci_get_log_pe(void)
 {
 	return edac_pci_log_pe;
 }
 
-int edac_pci_get_log_npe(void)
+static int edac_pci_get_log_npe(void)
 {
 	return edac_pci_log_npe;
 }
 
-int edac_pci_get_panic_on_pe(void)
+static int edac_pci_get_panic_on_pe(void)
 {
 	return edac_pci_panic_on_pe;
 }
@@ -197,7 +197,8 @@ error_out:
  *
  *	unregister the kobj for the EDAC PCI instance
  */
-void edac_pci_unregister_sysfs_instance_kobj(struct edac_pci_ctl_info *pci)
+static void edac_pci_unregister_sysfs_instance_kobj(
+			struct edac_pci_ctl_info *pci)
 {
 	debugf0("%s()\n", __func__);
 
@@ -337,7 +338,7 @@ static struct kobj_type ktype_edac_pci_m
  *	setup the sysfs for EDAC PCI attributes
  *	assumes edac_class has already been initialized
  */
-int edac_pci_main_kobj_setup(void)
+static int edac_pci_main_kobj_setup(void)
 {
 	int err;
 	struct sysdev_class *edac_class;
