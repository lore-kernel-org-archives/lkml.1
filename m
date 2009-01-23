Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbZAWXYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbZAWXYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZAWXYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:24:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbZAWXYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:24:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
Date: Sat, 24 Jan 2009 00:21:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <200901240019.36794.rjw@sisk.pl>
In-Reply-To: <200901240019.36794.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901240021.14940.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce new function pci_msix_table_size() returning the size of
the MSI-X table of given PCI device or 0 if the device doesn't
support MSI-X.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c   |   24 +++++++++++++++++++-----
 include/linux/pci.h |    5 +++++
 2 files changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -670,6 +670,23 @@ static int msi_free_irqs(struct pci_dev*
 }
 
 /**
+ * pci_msix_table_size - return the number of device's MSI-X table entries
+ * @dev: pointer to the pci_dev data structure of MSI-X device function
+ */
+int pci_msix_table_size(struct pci_dev *dev)
+{
+	int pos;
+	u16 control;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	if (!pos)
+		return 0;
+
+	pci_read_config_word(dev, msi_control_reg(pos), &control);
+	return multi_msix_capable(control);
+}
+
+/**
  * pci_enable_msix - configure device's MSI-X capability structure
  * @dev: pointer to the pci_dev data structure of MSI-X device function
  * @entries: pointer to an array of MSI-X entries
@@ -686,9 +703,8 @@ static int msi_free_irqs(struct pci_dev*
  **/
 int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 {
-	int status, pos, nr_entries;
+	int status, nr_entries;
 	int i, j;
-	u16 control;
 
 	if (!entries)
  		return -EINVAL;
@@ -697,9 +713,7 @@ int pci_enable_msix(struct pci_dev* dev,
 	if (status)
 		return status;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	nr_entries = multi_msix_capable(control);
+	nr_entries = pci_msix_table_size(dev);
 	if (nvec > nr_entries)
 		return -EINVAL;
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -799,6 +799,10 @@ static inline void pci_msi_shutdown(stru
 static inline void pci_disable_msi(struct pci_dev *dev)
 { }
 
+static inline int pci_msix_table_size(struct pci_dev *dev)
+{
+	return 0;
+}
 static inline int pci_enable_msix(struct pci_dev *dev,
 				  struct msix_entry *entries, int nvec)
 {
@@ -823,6 +827,7 @@ static inline int pci_msi_enabled(void)
 extern int pci_enable_msi(struct pci_dev *dev);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
+extern int pci_msix_table_size(struct pci_dev *dev);
 extern int pci_enable_msix(struct pci_dev *dev,
 	struct msix_entry *entries, int nvec);
 extern void pci_msix_shutdown(struct pci_dev *dev);

