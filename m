Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXJKU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXJKU5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbXJKU53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 16:57:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36059 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbXJKU53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 16:57:29 -0400
Date: Thu, 11 Oct 2007 16:57:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Greg KH <greg@kroah.com>, Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/2] PCI: Add 'nodomains' boot option, and
	pci_domains_supported global
Message-ID: <20071011205727.GA29222@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Introduce pci_domains_supported global, hardcoded to zero if
  !CONFIG_PCI_DOMAINS.

* Introduce 'nodomains' boot option, which clears pci_domains_supported
  on platforms that enable it by default (x86, x86-64, and others when
  they are converted to use this).

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Revised per Andi's comments, and split into two patches.

As found in jgarzik/misc-2.6.git#ALL and jgarzik/misc-2.6.git#pciseg.

 Documentation/kernel-parameters.txt |    2 ++
 drivers/pci/pci.c                   |   13 +++++++++++++
 include/linux/pci.h                 |    7 +++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

5d29ec863821020822c00384eca8b1006ab3c686
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4d175c7..a4d43ae 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1269,6 +1269,8 @@ and is between 256 and 4096 characters. It is defined in the file
 				Mechanism 1.
 		conf2		[X86-32] Force use of PCI Configuration
 				Mechanism 2.
+		nodomains	[PCI] Disable support for multiple PCI
+				root domains (aka PCI segments, in ACPI-speak).
 		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
 				Configuration
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 37c00f6..a82b4d1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -22,6 +22,10 @@
 
 unsigned int pci_pm_d3_delay = 10;
 
+#ifdef CONFIG_PCI_DOMAINS
+int pci_domains_supported = 1;
+#endif
+
 #define DEFAULT_CARDBUS_IO_SIZE		(256)
 #define DEFAULT_CARDBUS_MEM_SIZE	(64*1024*1024)
 /* pci=cbmemsize=nnM,cbiosize=nn can override this */
@@ -1566,6 +1570,13 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
 	return bars;
 }
 
+static void __devinit pci_no_domains(void)
+{
+#ifdef CONFIG_PCI_DOMAINS
+	pci_domains_supported = 0;
+#endif
+}
+
 static int __devinit pci_init(void)
 {
 	struct pci_dev *dev = NULL;
@@ -1585,6 +1596,8 @@ static int __devinit pci_setup(char *str)
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strcmp(str, "nodomains")) {
+				pci_no_domains();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 038a0dc..ee99959 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -685,13 +685,16 @@ extern void pci_unblock_user_cfg_access(struct pci_dev *dev);
  * a PCI domain is defined to be a set of PCI busses which share
  * configuration space.
  */
-#ifndef CONFIG_PCI_DOMAINS
+#ifdef CONFIG_PCI_DOMAINS
+extern int pci_domains_supported;
+#else
+enum { pci_domains_supported = 0; };
 static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
 static inline int pci_proc_domain(struct pci_bus *bus)
 {
 	return 0;
 }
-#endif
+#endif /* CONFIG_PCI_DOMAINS */
 
 #else /* CONFIG_PCI is not enabled */
 
