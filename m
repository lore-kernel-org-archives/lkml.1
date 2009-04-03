Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZDCGNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZDCGNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZDCGMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:12:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:34281 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZDCGMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:12:54 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [v1 PATCH 2/3] EDAC: Add edac_device_alloc_index()
Date: Fri,  3 Apr 2009 14:09:56 +0800
Message-Id: <1238738996-19901-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1238738996-19901-1-git-send-email-qingtao.cao@windriver.com>
References: <1238738996-19901-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 03 Apr 2009 06:12:37.0617 (UTC) FILETIME=[2FD5DE10:01C9B423]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add edac_device_alloc_index(), because for MAPLE platform there may
exist several EDAC driver modules that could make use of
edac_device_ctl_info structure at the same time. The index allocation
for these structures should be taken care of by EDAC core.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/amd8111_edac.c |    3 +--
 drivers/edac/edac_core.h    |    1 +
 drivers/edac/edac_device.c  |   13 +++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/edac/amd8111_edac.c
+++ b/drivers/edac/amd8111_edac.c
@@ -37,7 +37,6 @@
 #define AMD8111_EDAC_MOD_STR	"amd8111_edac"
 
 #define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
-static int edac_dev_idx;
 
 enum amd8111_edac_devs {
 	LPC_BRIDGE = 0,
@@ -377,7 +376,7 @@ static int amd8111_dev_probe(struct pci_
 	 * edac_device_ctl_info, but make use of existing
 	 * one instead.
 	*/
-	dev_info->edac_idx = edac_dev_idx++;
+	dev_info->edac_idx = edac_device_alloc_index();
 	dev_info->edac_dev =
 		edac_device_alloc_ctl_info(0, dev_info->ctl_name, 1,
 					   NULL, 0, 0,
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -819,6 +819,7 @@ extern void edac_device_handle_ue(struct
 				int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
+extern int edac_device_alloc_index(void);
 
 /*
  * edac_pci APIs
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -37,6 +37,7 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
+static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -490,6 +491,18 @@ void edac_device_reset_delay_period(stru
 	mutex_unlock(&device_ctls_mutex);
 }
 
+/*
+ * edac_device_alloc_index: Allocate a unique device index number
+ *
+ * Return:
+ *	allocated index number
+ */
+int edac_device_alloc_index(void)
+{
+	return atomic_inc_return(&device_indexes) - 1;
+}
+EXPORT_SYMBOL_GPL(edac_device_alloc_index);
+
 /**
  * edac_device_add_device: Insert the 'edac_dev' structure into the
  * edac_device global list and create sysfs entries associated with
