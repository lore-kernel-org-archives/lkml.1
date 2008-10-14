Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYJNLxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYJNLxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYJNLxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:53:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:37092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbYJNLxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:53:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,409,1220252400"; 
   d="scan'208";a="451008786"
Date: Tue, 14 Oct 2008 18:57:52 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 5/8 v4] PCI: add a new function to map BAR offset
Message-ID: <20081014105752.GE1734@yzhao12-linux.sh.intel.com>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to map resource number to base register (offset and type).

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.c       |   22 ++++++++++++++++++++++
 drivers/pci/pci.h       |    2 ++
 drivers/pci/setup-res.c |   13 +++++--------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 381e958..3575124 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1909,6 +1909,28 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
 	return 0;
 }
 
+/**
+ * pci_resource_bar - get position of the BAR associated with a resource
+ * @dev: the PCI device
+ * @resno: the resource number
+ * @type: the BAR type to be filled in
+ *
+ * Returns BAR position in config space, or 0 if the BAR is invalid.
+ */
+int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
+{
+	if (resno < PCI_ROM_RESOURCE) {
+		*type = pci_bar_unknown;
+		return PCI_BASE_ADDRESS_0 + 4 * resno;
+	} else if (resno == PCI_ROM_RESOURCE) {
+		*type = pci_bar_mem32;
+		return dev->rom_base_reg;
+	}
+
+	dev_err(&dev->dev, "BAR: invalid resource #%d\n", resno);
+	return 0;
+}
+
 static void __devinit pci_no_domains(void)
 {
 #ifdef CONFIG_PCI_DOMAINS
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 720b7d6..e2237ad 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -162,6 +162,8 @@ extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 extern struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 				struct pci_dev *bridge, int busnr);
 extern int pci_resource_alignment(struct pci_dev *dev, int resno);
+extern int pci_resource_bar(struct pci_dev *dev, int resno,
+			    enum pci_bar_type *type);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index ecff483..c3585a0 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -31,6 +31,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	struct pci_bus_region region;
 	u32 new, check, mask;
 	int reg;
+	enum pci_bar_type type;
 	struct resource *res = dev->resource + resno;
 
 	/*
@@ -64,17 +65,13 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	else
 		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 
-	if (resno < 6) {
-		reg = PCI_BASE_ADDRESS_0 + 4 * resno;
-	} else if (resno == PCI_ROM_RESOURCE) {
+	reg = pci_resource_bar(dev, resno, &type);
+	if (!reg)
+		return;
+	if (type != pci_bar_unknown) {
 		if (!(res->flags & IORESOURCE_ROM_ENABLE))
 			return;
 		new |= PCI_ROM_ADDRESS_ENABLE;
-		reg = dev->rom_base_reg;
-	} else {
-		/* Hmm, non-standard resource. */
-	
-		return;		/* kill uninitialised var warning */
 	}
 
 	pci_write_config_dword(dev, reg, new);
-- 
1.5.6.4

