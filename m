Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbXJEUTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbXJEUTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXJEUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:19:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37061 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760724AbXJEUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:19:23 -0400
Date: Fri, 5 Oct 2007 13:17:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linas@austin.ibm.com
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] pci: implement "pci=noaer"
Message-Id: <20071005131758.5dd8cf85.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

For cases in which CONFIG_PCIEAER=y (such as distro kernels), allow users
to disable PCIE Advanced Error Reporting by using "pci=noaer" on the
kernel command line.

This can be used to work around hardware or (kernel) software problems.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 drivers/pci/pci.c                   |    2 ++
 drivers/pci/pci.h                   |    6 ++++++
 drivers/pci/pcie/aer/aerdrv.c       |    9 +++++++++
 4 files changed, 21 insertions(+)

--- linux-2.6.23-rc9.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.23-rc9/Documentation/kernel-parameters.txt
@@ -67,6 +67,7 @@ parameter is applicable:
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
+	PCIE	PCI Express support is enabled.
 	PCMCIA	The PCMCIA subsystem is enabled.
 	PNP	Plug & Play support is enabled.
 	PPC	PowerPC architecture is enabled.
@@ -1269,6 +1270,9 @@ and is between 256 and 4096 characters. 
 				Mechanism 1.
 		conf2		[X86-32] Force use of PCI Configuration
 				Mechanism 2.
+		noaer		[PCIE] If the PCIEAER kernel config parameter is
+				enabled, this kernel boot option can be used to
+				disable the use of PCIE advanced error reporting.
 		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
 				Configuration
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
--- linux-2.6.23-rc9.orig/drivers/pci/pci.c
+++ linux-2.6.23-rc9/drivers/pci/pci.c
@@ -1585,6 +1585,8 @@ static int __devinit pci_setup(char *str
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strcmp(str, "noaer")) {
+				pci_no_aer();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
--- linux-2.6.23-rc9.orig/drivers/pci/pci.h
+++ linux-2.6.23-rc9/drivers/pci/pci.h
@@ -52,6 +52,12 @@ void pci_restore_msi_state(struct pci_de
 static inline void pci_restore_msi_state(struct pci_dev *dev) {}
 #endif
 
+#ifdef CONFIG_PCIEAER
+void pci_no_aer(void);
+#else
+static inline void pci_no_aer(void) { }
+#endif
+
 static inline int pci_no_d1d2(struct pci_dev *dev)
 {
 	unsigned int parent_dstates = 0;
--- linux-2.6.23-rc9.orig/drivers/pci/pcie/aer/aerdrv.c
+++ linux-2.6.23-rc9/drivers/pci/pcie/aer/aerdrv.c
@@ -81,6 +81,13 @@ static struct pcie_port_service_driver a
 	.reset_link	= aer_root_reset,
 };
 
+static int pcie_aer_disable;
+
+void pci_no_aer(void)
+{
+	pcie_aer_disable = 1;	/* has priority over 'forceload' */
+}
+
 /**
  * aer_irq - Root Port's ISR
  * @irq: IRQ assigned to Root Port
@@ -327,6 +334,8 @@ static void aer_error_resume(struct pci_
  **/
 static int __init aer_service_init(void)
 {
+	if (pcie_aer_disable)
+		return -ENXIO;
 	return pcie_port_service_register(&aerdriver);
 }
 
