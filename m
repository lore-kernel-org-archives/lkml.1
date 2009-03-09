Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZCIIVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZCIIVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZCIIU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:20:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:37095 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZCIIU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:20:26 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 4/8] EDAC: Add edac_pci_alloc_index()
Date: Mon,  9 Mar 2009 16:08:13 +0800
Message-Id: <1236586097-3830-5-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236586097-3830-4-git-send-email-qingtao.cao@windriver.com>
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-3-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-4-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 09 Mar 2009 08:20:22.0760 (UTC) FILETIME=[E44A1E80:01C9A08F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add edac_pci_alloc_index(), because for MAPLE platform there may
exist several EDAC driver modules that could make use of
edac_pci_ctl_info structure at the same time. The index allocation
for these structures should be taken care of by EDAC core.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/edac_core.h |    1 +
 drivers/edac/edac_pci.c  |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 4b55ec6..76cb7c2 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -831,6 +831,7 @@ extern void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci);
 extern void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
 				unsigned long value);
 
+extern int edac_pci_alloc_index(void);
 extern int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx);
 extern struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev);
 
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 5d3c808..5b150ae 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -30,6 +30,7 @@
 
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
 static LIST_HEAD(edac_pci_list);
+static atomic_t pci_indexes = ATOMIC_INIT(0);
 
 /*
  * edac_pci_alloc_ctl_info
@@ -318,6 +319,19 @@ void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
 EXPORT_SYMBOL_GPL(edac_pci_reset_delay_period);
 
 /*
+ * edac_pci_alloc_index: Allocate a unique PCI index number
+ *
+ * Return:
+ *      allocated index number
+ *
+ */
+int edac_pci_alloc_index(void)
+{
+	return atomic_inc_return(&pci_indexes) - 1;
+}
+EXPORT_SYMBOL_GPL(edac_pci_alloc_index);
+
+/*
  * edac_pci_add_device: Insert the 'edac_dev' structure into the
  * edac_pci global list and create sysfs entries associated with
  * edac_pci structure.
-- 
1.5.6.2

