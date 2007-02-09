Return-Path: <linux-kernel-owner+w=401wt.eu-S2992432AbXBIQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992432AbXBIQmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946668AbXBIQj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51732 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946649AbXBIQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:51 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] powerpc: celleb trivial endianness and iomem annotations
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HFYms-0006qj-OO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/celleb/pci.c      |   12 +++---
 arch/powerpc/platforms/celleb/scc_epci.c |   56 +++++++++++++++---------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/platforms/celleb/pci.c b/arch/powerpc/platforms/celleb/pci.c
index 867f83a..98de836 100644
--- a/arch/powerpc/platforms/celleb/pci.c
+++ b/arch/powerpc/platforms/celleb/pci.c
@@ -65,13 +65,13 @@ static inline u8 celleb_fake_config_readb(void *addr)
 
 static inline u16 celleb_fake_config_readw(void *addr)
 {
-	u16 *p = addr;
+	__le16 *p = addr;
 	return le16_to_cpu(*p);
 }
 
 static inline u32 celleb_fake_config_readl(void *addr)
 {
-	u32 *p = addr;
+	__le32 *p = addr;
 	return le32_to_cpu(*p);
 }
 
@@ -83,16 +83,16 @@ static inline void celleb_fake_config_writeb(u32 val, void *addr)
 
 static inline void celleb_fake_config_writew(u32 val, void *addr)
 {
-	u16 val16;
-	u16 *p = addr;
+	__le16 val16;
+	__le16 *p = addr;
 	val16 = cpu_to_le16(val);
 	*p = val16;
 }
 
 static inline void celleb_fake_config_writel(u32 val, void *addr)
 {
-	u32 val32;
-	u32 *p = addr;
+	__le32 val32;
+	__le32 *p = addr;
 	val32 = cpu_to_le32(val);
 	*p = val32;
 }
diff --git a/arch/powerpc/platforms/celleb/scc_epci.c b/arch/powerpc/platforms/celleb/scc_epci.c
index 0edbc0c..c11b39c 100644
--- a/arch/powerpc/platforms/celleb/scc_epci.c
+++ b/arch/powerpc/platforms/celleb/scc_epci.c
@@ -47,7 +47,7 @@
 #if 0 /* test code for epci dummy read */
 static void celleb_epci_dummy_read(struct pci_dev *dev)
 {
-	void *epci_base;
+	void __iomem *epci_base;
 	struct device_node *node;
 	struct pci_controller *hose;
 	u32 val;
@@ -58,7 +58,7 @@ static void celleb_epci_dummy_read(struct pci_dev *dev)
 	if (!hose)
 		return;
 
-	epci_base = (void *)hose->cfg_addr;
+	epci_base = hose->cfg_addr;
 
 	val = in_be32(epci_base + SCC_EPCI_WATRP);
 	iosync();
@@ -71,18 +71,18 @@ static inline void clear_and_disable_master_abort_interrupt(
 					struct pci_controller *hose)
 {
 	void __iomem *addr;
-	addr = (void *)hose->cfg_addr + PCI_COMMAND;
+	addr = hose->cfg_addr + PCI_COMMAND;
 	out_be32(addr, in_be32(addr) | (PCI_STATUS_REC_MASTER_ABORT << 16));
 }
 
 static int celleb_epci_check_abort(struct pci_controller *hose,
-				   unsigned long addr)
+				   void __iomem *addr)
 {
 	void __iomem *reg, *epci_base;
 	u32 val;
 
 	iob();
-	epci_base = (void *)hose->cfg_addr;
+	epci_base = hose->cfg_addr;
 
 	reg = epci_base + PCI_COMMAND;
 	val = in_be32(reg);
@@ -108,23 +108,23 @@ static int celleb_epci_check_abort(struct pci_controller *hose,
 	return PCIBIOS_SUCCESSFUL;
 }
 
-static unsigned long celleb_epci_make_config_addr(struct pci_controller *hose,
+static void __iomem *celleb_epci_make_config_addr(struct pci_controller *hose,
 					unsigned int devfn, int where)
 {
-	unsigned long addr;
+	void __iomem *addr;
 	struct pci_bus *bus = hose->bus;
 
 	if (bus->self)
-		addr = (unsigned long)hose->cfg_data +
+		addr = hose->cfg_data +
 		       (((bus->number & 0xff) << 16)
 		        | ((devfn & 0xff) << 8)
 		        | (where & 0xff)
 		        | 0x01000000);
 	else
-		addr = (unsigned long)hose->cfg_data +
+		addr = hose->cfg_data +
 		       (((devfn & 0xff) << 8) | (where & 0xff));
 
-	pr_debug("EPCI: config_addr = 0x%016lx\n", addr);
+	pr_debug("EPCI: config_addr = 0x%p\n", addr);
 
 	return addr;
 }
@@ -132,7 +132,7 @@ static unsigned long celleb_epci_make_config_addr(struct pci_controller *hose,
 static int celleb_epci_read_config(struct pci_bus *bus,
 			unsigned int devfn, int where, int size, u32 * val)
 {
-	unsigned long addr;
+	void __iomem *addr;
 	struct device_node *node;
 	struct pci_controller *hose;
 
@@ -148,17 +148,17 @@ static int celleb_epci_read_config(struct pci_bus *bus,
 	if (bus->number == hose->first_busno && devfn == 0) {
 		/* EPCI controller self */
 
-		addr = (unsigned long)hose->cfg_addr + where;
+		addr = hose->cfg_addr + where;
 
 		switch (size) {
 		case 1:
-			*val = in_8((u8 *)addr);
+			*val = in_8(addr);
 			break;
 		case 2:
-			*val = in_be16((u16 *)addr);
+			*val = in_be16(addr);
 			break;
 		case 4:
-			*val = in_be32((u32 *)addr);
+			*val = in_be32(addr);
 			break;
 		default:
 			return PCIBIOS_DEVICE_NOT_FOUND;
@@ -171,13 +171,13 @@ static int celleb_epci_read_config(struct pci_bus *bus,
 
 		switch (size) {
 		case 1:
-			*val = in_8((u8 *)addr);
+			*val = in_8(addr);
 			break;
 		case 2:
-			*val = in_le16((u16 *)addr);
+			*val = in_le16(addr);
 			break;
 		case 4:
-			*val = in_le32((u32 *)addr);
+			*val = in_le32(addr);
 			break;
 		default:
 			return PCIBIOS_DEVICE_NOT_FOUND;
@@ -188,13 +188,13 @@ static int celleb_epci_read_config(struct pci_bus *bus,
 		 "addr=0x%lx, devfn=0x%x, where=0x%x, size=0x%x, val=0x%x\n",
 		 addr, devfn, where, size, *val);
 
-	return celleb_epci_check_abort(hose, 0);
+	return celleb_epci_check_abort(hose, NULL);
 }
 
 static int celleb_epci_write_config(struct pci_bus *bus,
 			unsigned int devfn, int where, int size, u32 val)
 {
-	unsigned long addr;
+	void __iomem *addr;
 	struct device_node *node;
 	struct pci_controller *hose;
 
@@ -210,17 +210,17 @@ static int celleb_epci_write_config(struct pci_bus *bus,
 	if (bus->number == hose->first_busno && devfn == 0) {
 		/* EPCI controller self */
 
-		addr = (unsigned long)hose->cfg_addr + where;
+		addr = hose->cfg_addr + where;
 
 		switch (size) {
 		case 1:
-			out_8((u8 *)addr, val);
+			out_8(addr, val);
 			break;
 		case 2:
-			out_be16((u16 *)addr, val);
+			out_be16(addr, val);
 			break;
 		case 4:
-			out_be32((u32 *)addr, val);
+			out_be32(addr, val);
 			break;
 		default:
 			return PCIBIOS_DEVICE_NOT_FOUND;
@@ -233,13 +233,13 @@ static int celleb_epci_write_config(struct pci_bus *bus,
 
 		switch (size) {
 		case 1:
-			out_8((u8 *)addr, val);
+			out_8(addr, val);
 			break;
 		case 2:
-			out_le16((u16 *)addr, val);
+			out_le16(addr, val);
 			break;
 		case 4:
-			out_le32((u32 *)addr, val);
+			out_le32(addr, val);
 			break;
 		default:
 			return PCIBIOS_DEVICE_NOT_FOUND;
@@ -261,7 +261,7 @@ static int __devinit celleb_epci_init(struct pci_controller *hose)
 	void __iomem *reg, *epci_base;
 	int hwres = 0;
 
-	epci_base = (void *)hose->cfg_addr;
+	epci_base = hose->cfg_addr;
 
 	/* PCI core reset(Internal bus and PCI clock) */
 	reg = epci_base + SCC_EPCI_CKCTRL;
-- 
1.5.0-rc2.GIT


