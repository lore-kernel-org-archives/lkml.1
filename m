Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZKBQSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZKBQSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZKBQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:18:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:53681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbZKBQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:18:42 -0500
Date: Mon, 2 Nov 2009 16:17:43 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091026230001.947855317@sbs-t61.sc.intel.com>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Use EOI register in io-apic on intel platforms
Message-ID: <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
Git-Commit-ID: b3ec0a37a7907813bb4fb85a2d94102c152470b7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3ec0a37a7907813bb4fb85a2d94102c152470b7
Gitweb:     http://git.kernel.org/tip/b3ec0a37a7907813bb4fb85a2d94102c152470b7
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Oct 2009 14:24:35 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:56:36 +0100

x86: Use EOI register in io-apic on intel platforms

IO-APIC's in intel chipsets support EOI register starting from
IO-APIC version 2. Use that when ever we need to clear the
IO-APIC RTE's RemoteIRR bit explicitly.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <20091026230001.947855317@sbs-t61.sc.intel.com>
[ Marked use_eio_reg as __read_mostly, fixed small details ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   81 ++++++++++++++++++++++++++-------------
 1 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4e886ef..31e9db3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2492,6 +2492,51 @@ static void ack_apic_edge(unsigned int irq)
 
 atomic_t irq_mis_count;
 
+static int use_eoi_reg __read_mostly;
+
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		if (irq_remapped(irq))
+			io_apic_eoi(entry->apic, entry->pin);
+		else
+			io_apic_eoi(entry->apic, cfg->vector);
+	}
+}
+
+static void eoi_ioapic_irq(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__eoi_ioapic_irq(irq, cfg);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
+static int ioapic_supports_eoi(void)
+{
+	struct pci_dev *root;
+
+	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
+	    mp_ioapics[0].apicver >= 0x2) {
+		use_eoi_reg = 1;
+		printk(KERN_INFO "IO-APIC supports EOI register\n");
+	} else
+		printk(KERN_INFO "IO-APIC doesn't support EOI\n");
+
+	return 0;
+}
+
+fs_initcall(ioapic_supports_eoi);
+
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2575,37 +2620,19 @@ static void ack_apic_level(unsigned int irq)
 	/* Tail end of version 0x11 I/O APIC bug workaround */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
-		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(cfg);
-		__unmask_and_level_IO_APIC_irq(cfg);
-		spin_unlock(&ioapic_lock);
+
+		if (use_eoi_reg)
+			eoi_ioapic_irq(desc);
+		else {
+			spin_lock(&ioapic_lock);
+			__mask_and_edge_IO_APIC_irq(cfg);
+			__unmask_and_level_IO_APIC_irq(cfg);
+			spin_unlock(&ioapic_lock);
+		}
 	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-
-	for_each_irq_pin(entry, cfg->irq_2_pin)
-		io_apic_eoi(entry->apic, entry->pin);
-}
-
-static void
-eoi_ioapic_irq(struct irq_desc *desc)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ir_ack_apic_edge(unsigned int irq)
 {
 	ack_APIC_irq();
