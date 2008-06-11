Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYFKPHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYFKPHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYFKPGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:06:32 -0400
Received: from mail.suse.de ([195.135.220.2]:60488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875AbYFKPGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:06:31 -0400
From: Stefan Assmann <sassmann@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 3/5] Introduce pci=ioapicreroute kernel cmdline option
Date: Wed, 11 Jun 2008 16:35:15 +0200
Message-Id: <12131949173188-git-send-email-sassmann@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12131949173532-git-send-email-sassmann@suse.de>
References: <12131949173532-git-send-email-sassmann@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@suse.de>

Introduce pci=ioapicreroute kernel cmdline option to enable rerouting of boot
interrupts to the primary io-apic.

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/pci/common.c               |    5 +++++
 include/asm-x86/io_apic.h           |    4 ++++
 include/asm-x86/pci.h               |    1 +
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4bfd0e6..01b638b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1510,6 +1510,10 @@ and is between 256 and 4096 characters. It is defined in the file
 		noioapicquirk	[APIC] Disable all boot interrupt quirks.
 				Safety option to keep boot IRQs enabled. This
 				should never be necessary.
+		ioapicreroute	[APIC] Enable rerouting of boot IRQs to the
+				primary IO-APIC for bridges that cannot disable
+				boot IRQs. This fixes a source of spurious IRQs
+				when the system masks IRQs.
 		biosirq		[X86-32] Use PCI BIOS calls to get the interrupt
 				routing table. These calls are known to be buggy
 				on several machines and they hang the machine
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 4ddb5cb..00a319c 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -23,6 +23,7 @@ unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 static int pci_bf_sort;
 int pci_routeirq;
 int noioapicquirk;
+int noioapicreroute = 1;
 int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
@@ -499,6 +500,10 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "noioapicquirk")) {
 		noioapicquirk = 1;
 		return NULL;
+	} else if (!strcmp(str, "ioapicreroute")) {
+		if (noioapicreroute != -1)
+			noioapicreroute = 0;
+		return NULL;
 	}
 	return str;
 }
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 92c2916..4ea118a 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -160,12 +160,16 @@ extern int skip_ioapic_setup;
 /* 1 if "noapic" boot option passed */
 extern int noioapicquirk;
 
+/* -1 if "noapic" boot option passed */
+extern int noioapicreroute;
+
 /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
 extern int timer_through_8259;
 
 static inline void disable_ioapic_setup(void)
 {
 	noioapicquirk = 1;
+	noioapicreroute = -1;
 	skip_ioapic_setup = 1;
 }
 
diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
index 30eec93..52a29f7 100644
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -20,6 +20,7 @@ struct pci_sysdata {
 
 extern int pci_routeirq;
 extern int noioapicquirk;
+extern int ioapicreroute;
 
 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
-- 
1.5.2.4

