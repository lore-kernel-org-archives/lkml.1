Return-Path: <linux-kernel-owner+w=401wt.eu-S935249AbZDBGLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249AbZDBGLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZDBGJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:09:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:41546 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760422AbZDBGJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:09:51 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v0 PATCH 4/5] EDAC: Add edac_device_alloc_index()
Date: Thu,  2 Apr 2009 14:07:19 +0800
Message-Id: <1238652440-9224-5-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com>
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-2-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 02 Apr 2009 06:09:46.0493 (UTC) FILETIME=[9F6CAAD0:01C9B359]
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
