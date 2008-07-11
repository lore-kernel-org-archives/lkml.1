Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYGKLKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYGKLKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYGKLC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:57 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37538 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYGKLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:55 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U9CH-02-S0V-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86/pci: Changing subsystem init for visws
Date: Fri, 11 Jul 2008 12:26:59 +0200
Message-ID: <1215772019-28477-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 11 Jul 2008 11:02:43.0836 (UTC) FILETIME=[A4DE9BC0:01C8E345]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know, if this new code boots, but at least it
compiles. Someone should really test it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/legacy.c |    3 +++
 arch/x86/pci/pci.h    |    1 +
 arch/x86/pci/visws.c  |   23 +++++++----------------
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index f405eb0..ec9ce35 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -63,6 +63,9 @@ int __init pci_subsys_init(void)
 #ifdef CONFIG_ACPI
 	pci_acpi_init();
 #endif
+#ifdef CONFIG_X86_VISWS
+	pci_visws_init();
+#endif
 	pci_legacy_init();
 	pcibios_irq_init();
 	pcibios_init();
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 36b8dd0..a2c55ee 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -107,6 +107,7 @@ extern void __init dmi_check_skip_isa_align(void);
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
 extern int __init pcibios_irq_init(void);
+extern int __init pci_visws_init(void);
 extern int __init pci_numaq_init(void);
 extern int __init pcibios_init(void);
 
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 1a7bed4..42f4cb1 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -86,8 +86,14 @@ void __init pcibios_update_irq(struct pci_dev *dev, int irq)
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 }
 
-static int __init pci_visws_init(void)
+int __init pci_visws_init(void)
 {
+	if (!is_visws_box())
+		return -1;
+
+	pcibios_enable_irq = &pci_visws_enable_irq;
+	pcibios_disable_irq = &pci_visws_disable_irq;
+
 	/* The VISWS supports configuration access type 1 only */
 	pci_probe = (pci_probe | PCI_PROBE_CONF1) &
 		    ~(PCI_PROBE_BIOS | PCI_PROBE_CONF2);
@@ -105,18 +111,3 @@ static int __init pci_visws_init(void)
 	pcibios_resource_survey();
 	return 0;
 }
-
-static __init int pci_subsys_init(void)
-{
-	if (!is_visws_box())
-		return -1;
-
-	pcibios_enable_irq = &pci_visws_enable_irq;
-	pcibios_disable_irq = &pci_visws_disable_irq;
-
-	pci_visws_init();
-	pcibios_init();
-
-	return 0;
-}
-subsys_initcall(pci_subsys_init);
-- 
1.5.5.4


