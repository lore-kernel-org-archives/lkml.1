Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYFKPGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYFKPGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYFKPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:06:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:60463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074AbYFKPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:06:21 -0400
From: Stefan Assmann <sassmann@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 2/5] Introduce pci=noioapicquirk kernel cmdline option
Date: Wed, 11 Jun 2008 16:35:14 +0200
Message-Id: <121319491749-git-send-email-sassmann@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12131949173532-git-send-email-sassmann@suse.de>
References: <12131949173532-git-send-email-sassmann@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@suse.de>

Introduce pci=noioapicquirk kernel cmdline option to disable all boot
interrupt quirks

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/pci/common.c               |    4 ++++
 include/asm-x86/io_apic.h           |    4 ++++
 include/asm-x86/pci.h               |    1 +
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2000977..4bfd0e6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1507,6 +1507,9 @@ and is between 256 and 4096 characters. It is defined in the file
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
 				enabled, this kernel boot option can be used to
 				disable the use of MSI interrupts system-wide.
+		noioapicquirk	[APIC] Disable all boot interrupt quirks.
+				Safety option to keep boot IRQs enabled. This
+				should never be necessary.
 		biosirq		[X86-32] Use PCI BIOS calls to get the interrupt
 				routing table. These calls are known to be buggy
 				on several machines and they hang the machine
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 6e64aaf..4ddb5cb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -22,6 +22,7 @@ unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 
 static int pci_bf_sort;
 int pci_routeirq;
+int noioapicquirk;
 int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
@@ -495,6 +496,9 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "skip_isa_align")) {
 		pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
 		return NULL;
+	} else if (!strcmp(str, "noioapicquirk")) {
+		noioapicquirk = 1;
+		return NULL;
 	}
 	return str;
 }
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 8b1f568..92c2916 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -157,11 +157,15 @@ extern int sis_apic_bug;
 /* 1 if "noapic" boot option passed */
 extern int skip_ioapic_setup;
 
+/* 1 if "noapic" boot option passed */
+extern int noioapicquirk;
+
 /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
 extern int timer_through_8259;
 
 static inline void disable_ioapic_setup(void)
 {
+	noioapicquirk = 1;
 	skip_ioapic_setup = 1;
 }
 
diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
index 2db14cf..30eec93 100644
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -19,6 +19,7 @@ struct pci_sysdata {
 };
 
 extern int pci_routeirq;
+extern int noioapicquirk;
 
 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
-- 
1.5.2.4

