Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbXGZQg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbXGZQg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbXGZQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:34:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35384 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383AbXGZQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] deal with alpha section warnings
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6I7-0005Gz-LL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:34:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/head.S        |    1 +
 arch/alpha/kernel/pci.c         |   10 +++++-----
 arch/alpha/kernel/pci_iommu.c   |    4 ++--
 arch/alpha/kernel/smp.c         |    6 +++---
 arch/alpha/kernel/vmlinux.lds.S |    1 +
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/kernel/head.S b/arch/alpha/kernel/head.S
index e27d23c..7ac1f13 100644
--- a/arch/alpha/kernel/head.S
+++ b/arch/alpha/kernel/head.S
@@ -10,6 +10,7 @@
 #include <asm/system.h>
 #include <asm/asm-offsets.h>
 
+.section .text.head, "ax"
 .globl swapper_pg_dir
 .globl _stext
 swapper_pg_dir=SWAPPER_PGD
diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index ab642a4..9dc1cee 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -195,7 +195,7 @@ pcibios_init(void)
 
 subsys_initcall(pcibios_init);
 
-char * __init
+char * __devinit
 pcibios_setup(char *str)
 {
 	return str;
@@ -204,7 +204,7 @@ pcibios_setup(char *str)
 #ifdef ALPHA_RESTORE_SRM_SETUP
 static struct pdev_srm_saved_conf *srm_saved_configs;
 
-void __init
+void __devinit
 pdev_save_srm_config(struct pci_dev *dev)
 {
 	struct pdev_srm_saved_conf *tmp;
@@ -247,14 +247,14 @@ pci_restore_srm_config(void)
 }
 #endif
 
-void __init
+void __devinit
 pcibios_fixup_resource(struct resource *res, struct resource *root)
 {
 	res->start += root->start;
 	res->end += root->start;
 }
 
-void __init
+void __devinit
 pcibios_fixup_device_resources(struct pci_dev *dev, struct pci_bus *bus)
 {
 	/* Update device resources.  */
@@ -273,7 +273,7 @@ pcibios_fixup_device_resources(struct pci_dev *dev, struct pci_bus *bus)
 	}
 }
 
-void __init
+void __devinit
 pcibios_fixup_bus(struct pci_bus *bus)
 {
 	/* Propagate hose info into the subordinate devices.  */
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 6b07f89..e1c4707 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -58,7 +58,7 @@ size_for_memory(unsigned long max)
 	return max;
 }
 
-struct pci_iommu_arena *
+struct pci_iommu_arena * __init
 iommu_arena_new_node(int nid, struct pci_controller *hose, dma_addr_t base,
 		     unsigned long window_size, unsigned long align)
 {
@@ -117,7 +117,7 @@ iommu_arena_new_node(int nid, struct pci_controller *hose, dma_addr_t base,
 	return arena;
 }
 
-struct pci_iommu_arena *
+struct pci_iommu_arena * __init
 iommu_arena_new(struct pci_controller *hose, dma_addr_t base,
 		unsigned long window_size, unsigned long align)
 {
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index b287314..0804b6a 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -358,7 +358,7 @@ secondary_cpu_start(int cpuid, struct task_struct *idle)
 /*
  * Bring one cpu online.
  */
-static int __devinit
+static int __cpuinit
 smp_boot_one_cpu(int cpuid)
 {
 	struct task_struct *idle;
@@ -487,7 +487,7 @@ smp_prepare_boot_cpu(void)
 {
 }
 
-int __devinit
+int __cpuinit
 __cpu_up(unsigned int cpu)
 {
 	smp_boot_one_cpu(cpu);
@@ -541,7 +541,7 @@ smp_percpu_timer_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-int __init
+int
 setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index fe13daa..7af07d3 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -15,6 +15,7 @@ SECTIONS
 
   _text = .;					/* Text and read-only data */
   .text : { 
+	*(.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
-- 
1.5.3.GIT


