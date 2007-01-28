Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXA1T6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXA1T6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXA1T6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:58:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56133 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbXA1T6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:58:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>,
       Kyle McMartin <kyle@parisc-linux.org>, <linuxppc-dev@ozlabs.org>,
       Brice Goglin <brice@myri.com>, <shaohua.li@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/6] msi: Make MSI useable more architectures
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
	<m18xfnq6lm.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pqbq6j1.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm83orvb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veiroroc.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 28 Jan 2007 12:56:37 -0700
In-Reply-To: <m1veiroroc.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 28 Jan 2007 12:52:03 -0700")
Message-ID: <m1r6tforgq.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The arch hooks arch_setup_msi_irq and arch_teardown_msi_irq are now
responsible for allocating and freeing the linux irq in addition to
setting up the the linux irq to work with the interrupt.

arch_setup_msi_irq now takes a pci_device and a msi_desc and returns
an irq.

With this change in place this code should be useable by all platforms
except those that won't let the OS touch the hardware like ppc RTAS.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/io_apic.c   |   17 ++++++---
 arch/ia64/kernel/msi_ia64.c  |   19 ++++++----
 arch/ia64/sn/kernel/msi_sn.c |   20 +++++++---
 arch/x86_64/kernel/io_apic.c |   17 ++++++---
 drivers/pci/msi.c            |   80 +++++++++++------------------------------
 include/asm-ia64/machvec.h   |    3 +-
 include/linux/msi.h          |    2 +-
 7 files changed, 75 insertions(+), 83 deletions(-)

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 2424cc9..9ba4f99 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -2600,25 +2600,32 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-int arch_setup_msi_irq(unsigned int irq, struct pci_dev *dev)
+int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
 	struct msi_msg msg;
-	int ret;
+	int irq, ret;
+	irq = create_irq();
+	if (irq < 0)
+		return irq;
+
+	set_irq_msi(irq, desc);
 	ret = msi_compose_msg(dev, irq, &msg);
-	if (ret < 0)
+	if (ret < 0) {
+		destroy_irq(irq);
 		return ret;
+	}
 
 	write_msi_msg(irq, &msg);
 
 	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq,
 				      "edge");
 
-	return 0;
+	return irq;
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
 {
-	return;
+	destroy_irq(irq);
 }
 
 #endif /* CONFIG_PCI_MSI */
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 822e59a..0d05450 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -64,12 +64,17 @@ static void ia64_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 }
 #endif /* CONFIG_SMP */
 
-int ia64_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
+int ia64_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 {
 	struct msi_msg	msg;
 	unsigned long	dest_phys_id;
-	unsigned int	vector;
+	unsigned int	irq, vector;
 
+	irq = create_irq();
+	if (irq < 0)
+		return irq;
+
+	set_irq_msi(irq, desc);
 	dest_phys_id = cpu_physical_id(first_cpu(cpu_online_map));
 	vector = irq;
 
@@ -89,12 +94,12 @@ int ia64_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 	write_msi_msg(irq, &msg);
 	set_irq_chip_and_handler(irq, &ia64_msi_chip, handle_edge_irq);
 
-	return 0;
+	return irq;
 }
 
 void ia64_teardown_msi_irq(unsigned int irq)
 {
-	return;		/* no-op */
+	destroy_irq(irq);
 }
 
 static void ia64_ack_msi_irq(unsigned int irq)
@@ -126,12 +131,12 @@ static struct irq_chip ia64_msi_chip = {
 };
 
 
-int arch_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
+int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 {
 	if (platform_setup_msi_irq)
-		return platform_setup_msi_irq(irq, pdev);
+		return platform_setup_msi_irq(pdev, desc);
 
-	return ia64_setup_msi_irq(irq, pdev);
+	return ia64_setup_msi_irq(pdev, desc);
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 31fbb85..ea3dc38 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -59,13 +59,12 @@ void sn_teardown_msi_irq(unsigned int irq)
 	sn_intr_free(nasid, widget, sn_irq_info);
 	sn_msi_info[irq].sn_irq_info = NULL;
 
-	return;
+	destroy_irq(irq);
 }
 
-int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
+int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 {
 	struct msi_msg msg;
-	struct msi_desc *entry;
 	int widget;
 	int status;
 	nasid_t nasid;
@@ -73,8 +72,8 @@ int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 	struct sn_irq_info *sn_irq_info;
 	struct pcibus_bussoft *bussoft = SN_PCIDEV_BUSSOFT(pdev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	int irq;
 
-	entry = get_irq_msi(irq);
 	if (!entry->msi_attrib.is_64)
 		return -EINVAL;
 
@@ -84,6 +83,11 @@ int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 	if (provider == NULL || provider->dma_map_consistent == NULL)
 		return -EINVAL;
 
+	irq = create_irq();
+	if (irq < 0)
+		return irq;
+
+	set_irq_msi(irq, entry);
 	/*
 	 * Set up the vector plumbing.  Let the prom (via sn_intr_alloc)
 	 * decide which cpu to direct this msi at by default.
@@ -95,12 +99,15 @@ int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 			SWIN_WIDGETNUM(bussoft->bs_base);
 
 	sn_irq_info = kzalloc(sizeof(struct sn_irq_info), GFP_KERNEL);
-	if (! sn_irq_info)
+	if (! sn_irq_info) {
+		destroy_irq(irq);
 		return -ENOMEM;
+	}
 
 	status = sn_intr_alloc(nasid, widget, sn_irq_info, irq, -1, -1);
 	if (status) {
 		kfree(sn_irq_info);
+		destroy_irq(irq);
 		return -ENOMEM;
 	}
 
@@ -121,6 +128,7 @@ int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 	if (! bus_addr) {
 		sn_intr_free(nasid, widget, sn_irq_info);
 		kfree(sn_irq_info);
+		destroy_irq(irq);
 		return -ENOMEM;
 	}
 
@@ -139,7 +147,7 @@ int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 	write_msi_msg(irq, &msg);
 	set_irq_chip_and_handler(irq, &sn_msi_chip, handle_edge_irq);
 
-	return 0;
+	return irq;
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index d7bad90..6be6730 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -1956,24 +1956,31 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-int arch_setup_msi_irq(unsigned int irq, struct pci_dev *dev)
+int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
 	struct msi_msg msg;
-	int ret;
+	int irq, ret;
+	irq = create_irq();
+	if (irq < 0)
+		return irq;
+
+	set_irq_msi(irq, desc);
 	ret = msi_compose_msg(dev, irq, &msg);
-	if (ret < 0)
+	if (ret < 0) {
+		destroy_irq(irq);
 		return ret;
+	}
 
 	write_msi_msg(irq, &msg);
 
 	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
-	return 0;
+	return irq;
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
 {
-	return;
+	destroy_irq(irq);
 }
 
 #endif /* CONFIG_PCI_MSI */
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d7a2259..c6a6d46 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -192,37 +192,6 @@ static struct msi_desc* alloc_msi_entry(void)
 	return entry;
 }
 
-static int create_msi_irq(void)
-{
-	struct msi_desc *entry;
-	int irq;
-
-	entry = alloc_msi_entry();
-	if (!entry)
-		return -ENOMEM;
-
-	irq = create_irq();
-	if (irq < 0) {
-		kmem_cache_free(msi_cachep, entry);
-		return -EBUSY;
-	}
-
-	set_irq_msi(irq, entry);
-
-	return irq;
-}
-
-static void destroy_msi_irq(unsigned int irq)
-{
-	struct msi_desc *entry;
-
-	entry = get_irq_msi(irq);
-	set_irq_chip(irq, NULL);
-	set_irq_msi(irq, NULL);
-	destroy_irq(irq);
-	kmem_cache_free(msi_cachep, entry);
-}
-
 static void enable_msi_mode(struct pci_dev *dev, int pos, int type)
 {
 	u16 control;
@@ -449,7 +418,6 @@ void pci_restore_msi_state(struct pci_dev *dev)
  **/
 static int msi_capability_init(struct pci_dev *dev)
 {
-	int status;
 	struct msi_desc *entry;
 	int pos, irq;
 	u16 control;
@@ -457,13 +425,10 @@ static int msi_capability_init(struct pci_dev *dev)
    	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	/* MSI Entry Initialization */
-	irq = create_msi_irq();
-	if (irq < 0)
-		return irq;
+	entry = alloc_msi_entry();
+	if (!entry)
+		return -ENOMEM;
 
-	entry = get_irq_msi(irq);
-	entry->link.head = irq;
-	entry->link.tail = irq;
 	entry->msi_attrib.type = PCI_CAP_ID_MSI;
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
@@ -489,14 +454,16 @@ static int msi_capability_init(struct pci_dev *dev)
 			maskbits);
 	}
 	/* Configure MSI capability structure */
-	status = arch_setup_msi_irq(irq, dev);
-	if (status < 0) {
-		destroy_msi_irq(irq);
-		return status;
+	irq = arch_setup_msi_irq(dev, entry);
+	if (irq < 0) {
+		kmem_cache_free(msi_cachep, entry);
+		return irq;
 	}
-
+	entry->link.head = irq;
+	entry->link.tail = irq;
 	dev->first_msi_irq = irq;
 	set_irq_msi(irq, entry);
+
 	/* Set MSI enabled bits	 */
 	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
 
@@ -518,7 +485,6 @@ static int msix_capability_init(struct pci_dev *dev,
 				struct msix_entry *entries, int nvec)
 {
 	struct msi_desc *head = NULL, *tail = NULL, *entry = NULL;
-	int status;
 	int irq, pos, i, j, nr_entries, temp = 0;
 	unsigned long phys_addr;
 	u32 table_offset;
@@ -541,13 +507,11 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	/* MSI-X Table Initialization */
 	for (i = 0; i < nvec; i++) {
-		irq = create_msi_irq();
-		if (irq < 0)
+		entry = alloc_msi_entry();
+		if (!entry)
 			break;
 
-		entry = get_irq_msi(irq);
  		j = entries[i].entry;
- 		entries[i].vector = irq;
 		entry->msi_attrib.type = PCI_CAP_ID_MSIX;
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
@@ -556,6 +520,14 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->msi_attrib.pos = pos;
 		entry->dev = dev;
 		entry->mask_base = base;
+
+		/* Configure MSI-X capability structure */
+		irq = arch_setup_msi_irq(dev, entry);
+		if (irq < 0) {
+			kmem_cache_free(msi_cachep, entry);
+			break;
+		}
+ 		entries[i].vector = irq;
 		if (!head) {
 			entry->link.head = irq;
 			entry->link.tail = irq;
@@ -568,12 +540,6 @@ static int msix_capability_init(struct pci_dev *dev,
 		}
 		temp = irq;
 		tail = entry;
-		/* Configure MSI-X capability structure */
-		status = arch_setup_msi_irq(irq, dev);
-		if (status < 0) {
-			destroy_msi_irq(irq);
-			break;
-		}
 
 		set_irq_msi(irq, entry);
 	}
@@ -717,8 +683,6 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 	int head, entry_nr, type;
 	void __iomem *base;
 
-	arch_teardown_msi_irq(irq);
-
 	entry = get_irq_msi(irq);
 	if (!entry || entry->dev != dev) {
 		return -EINVAL;
@@ -729,9 +693,9 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 	base = entry->mask_base;
 	get_irq_msi(entry->link.head)->link.tail = entry->link.tail;
 	get_irq_msi(entry->link.tail)->link.head = entry->link.head;
-	entry->dev = NULL;
 
-	destroy_msi_irq(irq);
+	arch_teardown_msi_irq(irq);
+	kmem_cache_free(msi_cachep, entry);
 
 	if (type == PCI_CAP_ID_MSIX) {
 		writel(1, base + entry_nr * PCI_MSIX_ENTRY_SIZE +
diff --git a/include/asm-ia64/machvec.h b/include/asm-ia64/machvec.h
index a3891eb..3c96ac1 100644
--- a/include/asm-ia64/machvec.h
+++ b/include/asm-ia64/machvec.h
@@ -21,6 +21,7 @@ struct mm_struct;
 struct pci_bus;
 struct task_struct;
 struct pci_dev;
+struct msi_desc;
 
 typedef void ia64_mv_setup_t (char **);
 typedef void ia64_mv_cpu_init_t (void);
@@ -79,7 +80,7 @@ typedef unsigned short ia64_mv_readw_relaxed_t (const volatile void __iomem *);
 typedef unsigned int ia64_mv_readl_relaxed_t (const volatile void __iomem *);
 typedef unsigned long ia64_mv_readq_relaxed_t (const volatile void __iomem *);
 
-typedef int ia64_mv_setup_msi_irq_t (unsigned int irq, struct pci_dev *pdev);
+typedef int ia64_mv_setup_msi_irq_t (struct pci_dev *pdev, struct msi_desc *);
 typedef void ia64_mv_teardown_msi_irq_t (unsigned int irq);
 
 static inline void
diff --git a/include/linux/msi.h b/include/linux/msi.h
index b99976b..74c8a2e 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -41,7 +41,7 @@ struct msi_desc {
 /*
  * The arch hook for setup up msi irqs
  */
-int arch_setup_msi_irq(unsigned int irq, struct pci_dev *dev);
+int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
 
 
-- 
1.4.4.1.g278f

