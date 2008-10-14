Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYJNLoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYJNLoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYJNLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:43:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:25154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbYJNLnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,409,1220252400"; 
   d="scan'208";a="451006615"
Date: Tue, 14 Oct 2008 18:48:37 +0800
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
Subject: [PATCH 2/8 v4] PCI: export __pci_read_base
Message-ID: <20081014104837.GB1734@yzhao12-linux.sh.intel.com>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export __pci_read_base() so it can be used by whole PCI subsystem.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.h   |    9 +++++++++
 drivers/pci/probe.c |   20 +++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 69b6365..922b742 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -150,6 +150,15 @@ struct pci_slot_attribute {
 };
 #define to_pci_slot_attr(s) container_of(s, struct pci_slot_attribute, attr)
 
+enum pci_bar_type {
+	pci_bar_unknown,	/* Standard PCI BAR probe */
+	pci_bar_io,		/* An io port BAR */
+	pci_bar_mem32,		/* A 32-bit memory BAR */
+	pci_bar_mem64,		/* A 64-bit memory BAR */
+};
+
+extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+				struct resource *res, unsigned int reg);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 03ddfee..2326609 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -201,13 +201,6 @@ static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 	return size;
 }
 
-enum pci_bar_type {
-	pci_bar_unknown,	/* Standard PCI BAR probe */
-	pci_bar_io,		/* An io port BAR */
-	pci_bar_mem32,		/* A 32-bit memory BAR */
-	pci_bar_mem64,		/* A 64-bit memory BAR */
-};
-
 static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
 {
 	if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
@@ -222,11 +215,16 @@ static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
 	return pci_bar_mem32;
 }
 
-/*
- * If the type is not unknown, we assume that the lowest bit is 'enable'.
- * Returns 1 if the BAR was 64-bit and 0 if it was 32-bit.
+/**
+ * pci_read_base - read a PCI BAR
+ * @dev: the PCI device
+ * @type: type of the BAR
+ * @res: resource buffer to be filled in
+ * @pos: BAR position in the config space
+ *
+ * Returns 1 if the BAR is 64-bit, or 0 if 32-bit.
  */
-static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			struct resource *res, unsigned int pos)
 {
 	u32 l, sz, mask;
-- 
1.5.6.4

