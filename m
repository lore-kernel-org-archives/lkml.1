Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYJVJjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYJVJjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYJVJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:37:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:37875 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbYJVJh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:37:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,463,1220252400"; 
   d="scan'208";a="454255268"
Date: Wed, 22 Oct 2008 16:42:18 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 6/16 v6] PCI: add a new function to map BAR offset
Message-ID: <20081022084218.GF3773@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to map resource number to corresponding register so
people can get the offset and type of device specific BARs.

Cc: Alex Chiang <achiang@hp.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
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

