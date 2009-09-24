Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZIXWtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZIXWtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIXWtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZIXWtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:49:31 -0400
Date: Thu, 24 Sep 2009 19:49:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 21/63] pci: Add a probing code that seeks for an specific
 bus
Message-ID: <20090924194901.5c748286@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a probing code that seeks for an specific pci bus. It
still needs testing, but it is hoped that this will help to identify the
memory controller with Xeon 55xx series.

Signed-off-by: Aristeu Sergio <arozansk@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 arch/x86/include/asm/pci_x86.h |    2 +
 arch/x86/pci/legacy.c          |   42 +++++++++++++++++++++++----------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b399988..e61147f 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -52,6 +52,8 @@ extern int pcibios_last_bus;
 extern struct pci_bus *pci_root_bus;
 extern struct pci_ops pci_root_ops;
 
+void pcibios_scan_specific_bus(int busn);
+
 /* pci-irq.c */
 
 struct irq_info {
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 4061bb0..d3f46b0 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -11,28 +11,14 @@
  */
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
-	int n, devfn;
-	long node;
+	int n;
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus > 0xff)
 		return;
 	DBG("PCI: Peer bridge fixup\n");
 
-	for (n=0; n <= pcibios_last_bus; n++) {
-		u32 l;
-		if (pci_find_bus(0, n))
-			continue;
-		node = get_mp_bus_to_node(n);
-		for (devfn = 0; devfn < 256; devfn += 8) {
-			if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
-			    l != 0x0000 && l != 0xffff) {
-				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
-				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus_on_node(n, &pci_root_ops, node);
-				break;
-			}
-		}
-	}
+	for (n=0; n <= pcibios_last_bus; n++)
+		pcibios_scan_specific_bus(n);
 }
 
 static int __init pci_legacy_init(void)
@@ -52,6 +38,28 @@ static int __init pci_legacy_init(void)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pci_legacy_init);
+
+void pcibios_scan_specific_bus(int busn)
+{
+	int devfn;
+	long node;
+	u32 l;
+
+	if (pci_find_bus(0, busn))
+		return;
+
+	node = get_mp_bus_to_node(busn);
+	for (devfn = 0; devfn < 256; devfn += 8) {
+		if (!raw_pci_read(0, busn, devfn, PCI_VENDOR_ID, 2, &l) &&
+		    l != 0x0000 && l != 0xffff) {
+			DBG("Found device at %02x:%02x [%04x]\n", busn, devfn, l);
+			printk(KERN_INFO "PCI: Discovered peer bus %02x\n", busn);
+			pci_scan_bus_on_node(busn, &pci_root_ops, node);
+			return;
+		}
+	}
+}
 
 int __init pci_subsys_init(void)
 

-- 

Cheers,
Mauro
