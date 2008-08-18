Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbYHRUqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbYHRUqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbYHRUpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:45:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:37295 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYHRUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ImfIcKTsGLP+Nwn4Kjq82lbpwLcH+iMKxil++QCB2FwYgm+XtianHfYWh7L0YQgL8y
         wpKLC6TnnBIycNo3za2C47iwTQdUvhwe3I7/Jw3VuEBN3hFj15MKGXNAb0yWwN5v4C7c
         YaAwRKQDSQK2jTnrEJhAPWIKgRkbHoXXaClvU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] irq: rename irq_desc() to to_irq_desc() - fix #3
Date: Mon, 18 Aug 2008 13:44:50 -0700
Message-Id: <1219092290-30154-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219092290-30154-2-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com>
 <1219092290-30154-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add create_irq_nr, and retore create_irq to old

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/arm/mach-iop13xx/msi.c  |    4 ++--
 arch/ia64/kernel/iosapic.c   |    6 +++---
 arch/ia64/kernel/irq_ia64.c  |    2 +-
 arch/ia64/kernel/msi_ia64.c  |    2 +-
 arch/ia64/sn/kernel/msi_sn.c |    2 +-
 arch/x86/kernel/io_apic.c    |   18 +++++++++++++++---
 drivers/pci/htirq.c          |    2 +-
 drivers/pci/intel-iommu.c    |    2 +-
 include/linux/irq.h          |    3 ++-
 9 files changed, 27 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/arm/mach-iop13xx/msi.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop13xx/msi.c
+++ linux-2.6/arch/arm/mach-iop13xx/msi.c
@@ -125,7 +125,7 @@ void __init iop13xx_msi_init(void)
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq(unsigned not_used)
+int create_irq(void)
 {
 	int irq, pos;
 
@@ -173,7 +173,7 @@ static struct irq_chip iop13xx_msi_chip
 
 int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 {
-	int id, irq = create_irq(0);
+	int id, irq = create_irq();
 	struct msi_msg msg;
 
 	if (irq < 0)
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -532,7 +532,7 @@ iosapic_reassign_vector (int irq)
 	int new_irq;
 
 	if (iosapic_intr_info[irq].count) {
-		new_irq = create_irq(0);
+		new_irq = create_irq();
 		if (new_irq < 0)
 			panic("%s: out of interrupt vectors!\n", __func__);
 		printk(KERN_INFO "Reassigning vector %d to %d\n",
@@ -783,7 +783,7 @@ iosapic_register_intr (unsigned int gsi,
 			goto unlock_iosapic_lock;
 		}
 	} else
-		irq = create_irq(0);
+		irq = create_irq();
 
 	/* If vector is running out, we try to find a sharable vector */
 	if (irq < 0) {
@@ -922,7 +922,7 @@ iosapic_register_platform_intr (u32 int_
 		delivery = IOSAPIC_PMI;
 		break;
 	      case ACPI_INTERRUPT_INIT:
-		irq = create_irq(0);
+		irq = create_irq();
 		if (irq < 0)
 			panic("%s: out of interrupt vectors!\n", __func__);
 		vector = irq_to_vector(irq);
Index: linux-2.6/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6/arch/ia64/kernel/irq_ia64.c
@@ -403,7 +403,7 @@ void destroy_and_reserve_irq(unsigned in
 /*
  * Dynamic irq allocate and deallocation for MSI
  */
-unsigned int create_irq(unsigned int not_used)
+int create_irq(void)
 {
 	unsigned long flags;
 	int irq, vector, cpu;
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -84,7 +84,7 @@ int ia64_setup_msi_irq(struct pci_dev *p
 	int	irq, vector;
 	cpumask_t mask;
 
-	irq = create_irq(0);
+	irq = create_irq();
 	if (irq < 0)
 		return irq;
 
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -83,7 +83,7 @@ int sn_setup_msi_irq(struct pci_dev *pde
 	if (provider == NULL || provider->dma_map_consistent == NULL)
 		return -EINVAL;
 
-	irq = create_irq(0);
+	irq = create_irq();
 	if (irq < 0)
 		return irq;
 
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3039,7 +3039,7 @@ device_initcall(ioapic_init_sysfs);
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq(unsigned int irq_want)
+unsigned int create_irq_nr(unsigned int irq_want)
 {
 	/* Allocate an unused irq */
 	unsigned int irq;
@@ -3074,6 +3074,18 @@ unsigned int create_irq(unsigned int irq
 	return irq;
 }
 
+int create_irq(void)
+{
+	int irq;
+
+	irq = create_irq_nr(nr_irqs - 1);
+
+	if (irq == 0)
+		irq = -1;
+
+	return irq;
+}
+
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
@@ -3346,7 +3358,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 
 	irq_want = build_irq_for_pci_dev(dev) + 0x100;
 
-	irq = create_irq(irq_want);
+	irq = create_irq_nr(irq_want);
 	if (irq == 0)
 		return -1;
 
@@ -3388,7 +3400,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 	irq_want = build_irq_for_pci_dev(dev) + 0x100;
 	sub_handle = 0;
 	list_for_each_entry(desc, &dev->msi_list, list) {
-		irq = create_irq(irq_want--);
+		irq = create_irq_nr(irq_want--);
 		if (irq == 0)
 			return -1;
 #ifdef CONFIG_INTR_REMAP
Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c
+++ linux-2.6/drivers/pci/htirq.c
@@ -139,7 +139,7 @@ int __ht_create_irq(struct pci_dev *dev,
 	cfg->msg.address_hi = 0xffffffff;
 
 	irq_want= build_irq_for_pci_dev(dev);
-	irq = create_irq(irq_want + idx);
+	irq = create_irq_nr(irq_want + idx);
 	if (irq == 0) {
 		kfree(cfg);
 		return -EBUSY;
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -915,7 +915,7 @@ int dmar_set_interrupt(struct intel_iomm
 {
 	int irq, ret;
 
-	irq = create_irq(0);
+	irq = create_irq();
 	if (!irq) {
 		printk(KERN_ERR "IOMMU: no free vectors\n");
 		return -EINVAL;
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -396,7 +396,8 @@ extern void set_irq_noprobe(unsigned int
 extern void set_irq_probe(unsigned int irq);
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq(unsigned int irq_want);
+extern unsigned int create_irq_nr(unsigned int irq_want);
+extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
 /* Test to see if a driver has successfully requested an irq */
