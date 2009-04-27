Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZD0D2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZD0D2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 23:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZD0D2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 23:28:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:51235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZD0D2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 23:28:19 -0400
Message-ID: <49F525E0.9070501@kernel.org>
Date: Sun, 26 Apr 2009 20:26:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] x86/irq: make MSI irq_desc numa aware -v2
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org>
In-Reply-To: <49E804AD.9020702@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


try to get irq_desc on the node in create_irq_nr

v2: don't check if we can move it when sparse_irq is not used
[ Impact: use irq_desc_alloc_node ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   17 +++++++++++++----
 include/linux/irq.h            |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3027,14 +3027,13 @@ static int nr_irqs_gsi = NR_IRQS_LEGACY;
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int irq_want)
+unsigned int create_irq_nr(unsigned int irq_want, int node)
 {
 	/* Allocate an unused irq */
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
-	int node = cpu_to_node(boot_cpu_id);
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3052,6 +3051,13 @@ unsigned int create_irq_nr(unsigned int
 
 		if (cfg_new->vector != 0)
 			continue;
+
+#ifdef CONFIG_SPARSE_IRQ
+		/* different node ?*/
+		if (desc_new->node != node)
+			continue;
+#endif
+
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
@@ -3069,11 +3075,12 @@ unsigned int create_irq_nr(unsigned int
 
 int create_irq(void)
 {
+	int node = cpu_to_node(boot_cpu_id);
 	unsigned int irq_want;
 	int irq;
 
 	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want);
+	irq = create_irq_nr(irq_want, node);
 
 	if (irq == 0)
 		irq = -1;
@@ -3331,15 +3338,17 @@ int arch_setup_msi_irqs(struct pci_dev *
 	unsigned int irq_want;
 	struct intel_iommu *iommu = NULL;
 	int index = 0;
+	int node;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
+	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want);
+		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -374,7 +374,7 @@ extern void set_irq_noprobe(unsigned int
 extern void set_irq_probe(unsigned int irq);
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want);
+extern unsigned int create_irq_nr(unsigned int irq_want, int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
