Return-Path: <linux-kernel-owner+w=401wt.eu-S939769AbXHIMml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939769AbXHIMml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939628AbXHIMlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939622AbXHIMla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:30 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: dean@arctic.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD Fam10h
Message-Id: <20070809124128.886BE14F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: dean gaudet <dean@arctic.org>

Some broken devices have been discovered to require %al/%ax/%eax registers 
for MMIO config space accesses.  Modify mmconfig.c to use these registers 
explicitly (rather than modify the global readb/writeb/etc inlines).

AK: also changed i386 to always use eax
AK: moved change to extended space probing to different patch
AK: reworked with inlines according to Linus' requirements.
AK: improve comments.

Signed-off-by: dean gaudet <dean@arctic.org>
Signed-off-by: Andi Kleen <ak@suse.de>


---
 arch/i386/pci/mmconfig.c   |   14 ++++++--------
 arch/i386/pci/pci.h        |   43 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86_64/pci/mmconfig.c |   12 ++++++------
 3 files changed, 55 insertions(+), 14 deletions(-)

Index: linux/arch/x86_64/pci/mmconfig.c
===================================================================
--- linux.orig/arch/x86_64/pci/mmconfig.c
+++ linux/arch/x86_64/pci/mmconfig.c
@@ -66,13 +66,13 @@ static int pci_mmcfg_read(unsigned int s
 
 	switch (len) {
 	case 1:
-		*value = readb(addr + reg);
+		*value = mmio_config_readb(addr + reg);
 		break;
 	case 2:
-		*value = readw(addr + reg);
+		*value = mmio_config_readw(addr + reg);
 		break;
 	case 4:
-		*value = readl(addr + reg);
+		*value = mmio_config_readl(addr + reg);
 		break;
 	}
 
@@ -94,13 +94,13 @@ static int pci_mmcfg_write(unsigned int 
 
 	switch (len) {
 	case 1:
-		writeb(value, addr + reg);
+		mmio_config_writeb(addr + reg, value);
 		break;
 	case 2:
-		writew(value, addr + reg);
+		mmio_config_writew(addr + reg, value);
 		break;
 	case 4:
-		writel(value, addr + reg);
+		mmio_config_writel(addr + reg, value);
 		break;
 	}
 
Index: linux/arch/i386/pci/mmconfig.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig.c
+++ linux/arch/i386/pci/mmconfig.c
@@ -82,16 +82,15 @@ static int pci_mmcfg_read(unsigned int s
 
 	switch (len) {
 	case 1:
-		*value = readb(mmcfg_virt_addr + reg);
+		*value = mmio_config_readb(mmcfg_virt_addr + reg);
 		break;
 	case 2:
-		*value = readw(mmcfg_virt_addr + reg);
+		*value = mmio_config_readw(mmcfg_virt_addr + reg);
 		break;
 	case 4:
-		*value = readl(mmcfg_virt_addr + reg);
+		*value = mmio_config_readl(mmcfg_virt_addr + reg);
 		break;
 	}
-
 	spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
@@ -116,16 +115,15 @@ static int pci_mmcfg_write(unsigned int 
 
 	switch (len) {
 	case 1:
-		writeb(value, mmcfg_virt_addr + reg);
+		mmio_config_writeb(mmcfg_virt_addr, value);
 		break;
 	case 2:
-		writew(value, mmcfg_virt_addr + reg);
+		mmio_config_writew(mmcfg_virt_addr, value);
 		break;
 	case 4:
-		writel(value, mmcfg_virt_addr + reg);
+		mmio_config_writel(mmcfg_virt_addr, value);
 		break;
 	}
-
 	spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
Index: linux/arch/i386/pci/pci.h
===================================================================
--- linux.orig/arch/i386/pci/pci.h
+++ linux/arch/i386/pci/pci.h
@@ -104,3 +104,46 @@ extern DECLARE_BITMAP(pci_mmcfg_fallback
 extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
 					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
+
+/*
+ * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
+ * on their northbrige except through the * %eax register. As such, you MUST
+ * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
+ * accessor functions.
+ * In fact just use pci_config_*, nothing else please.
+ */
+static inline unsigned char mmio_config_readb(void __iomem *pos)
+{
+	u8 val;
+	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline unsigned short mmio_config_readw(void __iomem *pos)
+{
+	u16 val;
+	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline unsigned int mmio_config_readl(void __iomem *pos)
+{
+	u32 val;
+	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline void mmio_config_writeb(void __iomem *pos, u8 val)
+{
+	asm volatile("movb %%al,(%1)" :: "a" (val), "r" (pos) : "memory");
+}
+
+static inline void mmio_config_writew(void __iomem *pos, u16 val)
+{
+	asm volatile("movw %%ax,(%1)" :: "a" (val), "r" (pos) : "memory");
+}
+
+static inline void mmio_config_writel(void __iomem *pos, u32 val)
+{
+	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
+}
