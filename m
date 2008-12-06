Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbYLFC7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbYLFC7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYLFC7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:59:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:36151 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbYLFC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=Izjv8faVafeOewHvUt0lWSk2/aIH21MGEP7Z9OC8Eb9mohI7YgvIeDmhSP9/pcpfJ2
         G3ukrx38vejzLyO7oeAmfdPZKzq/YhManOkyIf/veKKB2ULoq5Pg3LiRdwutoHdV5n3H
         S8AqyeQRQzs6MMt2fmf2sbh9ZDgpHrM/MTg+g=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/5] MSI irq start from nr_irqs_gsi
Date: Fri,  5 Dec 2008 18:58:33 -0800
Message-Id: <1228532315-28799-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
References: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

impact: msr irq number ordering

increase that from nr_irqs_gsi instead of decresing from NR_IRQS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    2 +-
 arch/x86/kernel/io_apic.c      |   24 +++++++++++++++++-------
 arch/x86/kernel/setup.c        |    2 +-
 3 files changed, 19 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -198,7 +198,7 @@ extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
-extern int probe_nr_irqs(void);
+extern void probe_nr_irqs_gsi(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -2973,7 +2973,7 @@ unsigned int create_irq_nr(unsigned int
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = irq_want; new > 0; new--) {
+	for (new = irq_want; new < NR_IRQS; new++) {
 		if (platform_legacy_irq(new))
 			continue;
 
@@ -3001,11 +3001,14 @@ unsigned int create_irq_nr(unsigned int
 	return irq;
 }
 
+static int nr_irqs_gsi = NR_IRQS_LEGACY;
 int create_irq(void)
 {
+	unsigned int irq_want;
 	int irq;
 
-	irq = create_irq_nr(nr_irqs - 1);
+	irq_want = nr_irqs_gsi;
+	irq = create_irq_nr(irq_want);
 
 	if (irq == 0)
 		irq = -1;
@@ -3281,7 +3284,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 	int ret;
 	unsigned int irq_want;
 
-	irq_want = nr_irqs - 1;
+	irq_want = nr_irqs_gsi;
 	irq = create_irq_nr(irq_want);
 	if (irq == 0)
 		return -1;
@@ -3321,11 +3324,11 @@ int arch_setup_msi_irqs(struct pci_dev *
 	int index = 0;
 #endif
 
-	irq_want = nr_irqs - 1;
+	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want);
-		irq_want--;
+		irq_want++;
 		if (irq == 0)
 			return -1;
 #ifdef CONFIG_INTR_REMAP
@@ -3674,9 +3677,16 @@ int __init io_apic_get_redir_entries (in
 	return reg_01.bits.entries;
 }
 
-int __init probe_nr_irqs(void)
+void __init probe_nr_irqs_gsi(void)
 {
-	return NR_IRQS;
+	int idx;
+	int nr = 0;
+
+	for (idx = 0; idx < nr_ioapics; idx++)
+		nr += io_apic_get_redir_entries(idx) + 1;
+
+	if (nr > nr_irqs_gsi)
+		nr_irqs_gsi = nr;
 }
 
 /* --------------------------------------------------------------------------
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -954,7 +954,7 @@ void __init setup_arch(char **cmdline_p)
 	ioapic_init_mappings();
 
 	/* need to wait for io_apic is mapped */
-	nr_irqs = probe_nr_irqs();
+	probe_nr_irqs_gsi();
 
 	kvm_guest_init();
 
