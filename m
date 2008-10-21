Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYJUMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYJUMoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYJUMna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:43:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:1406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbYJUMn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="453860038"
Date: Tue, 21 Oct 2008 19:48:27 +0800
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
Subject: [PATCH 6/15 v5] PCI: add a new function to map BAR offset
Message-ID: <20081021114827.GG3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to map resource number to base register (offset
and type).

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.c       |   22 ++++++++++++++++++++++
 drivers/pci/pci.h       |    2 ++
 drivers/pci/setup-res.c |   13 +++++--------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a9b554e..b02167a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1924,6 +1924,28 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
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
index baa3d23..d707477 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -167,6 +167,8 @@ enum pci_bar_type {
 extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
 extern int pci_resource_alignment(struct pci_dev *dev, int resno);
+extern int pci_resource_bar(struct pci_dev *dev, int resno,
+			    enum pci_bar_type *type);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 88a9c70..5812f4b 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -31,6 +31,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	struct pci_bus_region region;
 	u32 new, check, mask;
 	int reg;
+	enum pci_bar_type type;
 	struct resource *res = dev->resource + resno;
 
 	/*
@@ -62,17 +63,13 @@ void pci_update_resource(struct pci_dev *dev, int resno)
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

