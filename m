Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZDGX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZDGX4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZDGX4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:56:39 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:22500 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754248AbZDGX4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:56:39 -0400
Date: Tue, 07 Apr 2009 17:45:50 -0600
From: dougthompson@xmission.com
To: khali@linux-fr.org, qingtao.cao@windriver.com, jharan@Brocade.COM,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 3/3] edac: add new core index allocator
Message-ID: <49dbe5ae.rglwvzb95ZzxtybW%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Ciao <qingtao.cao@windriver.com>

Add edac_device_alloc_index(), because for some platforms there may
exist several EDAC driver modules that could make use of
edac_device_ctl_info structure at the same time. The index allocation
for these structures should be taken care of by EDAC core.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 edac_core.h   |    1 +
 edac_device.c |   13 +++++++++++++
 2 files changed, 14 insertions(+)

Index: linux-2.6.29/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.29.orig/drivers/edac/edac_core.h
+++ linux-2.6.29/drivers/edac/edac_core.h
@@ -840,6 +840,7 @@ extern void edac_device_handle_ue(struct
 				int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
+extern int edac_device_alloc_index(void);
 
 /*
  * edac_pci APIs
Index: linux-2.6.29/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.29.orig/drivers/edac/edac_device.c
+++ linux-2.6.29/drivers/edac/edac_device.c
@@ -37,6 +37,7 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
+static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -491,6 +492,18 @@ void edac_device_reset_delay_period(stru
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
