Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZDGMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZDGMhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZDGMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:37:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:21886 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZDGMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dMke/sdluZv6NQZUe4tWd5YCxnFunC/30e+LcgOQLozFabIFOse4C11pqkYZzLF5qS
         mbsQC52MknLFQM9fdPHrzQIFb7xgQ7EMCmsIc7azn0mOvNhWM2xFkPMVGZCqu1bAFSu8
         HrpT9Z9iiq2rGKkvTI35Ke2AKeycxBYHQTKXo=
Date: Tue, 7 Apr 2009 16:37:08 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: [PATCH next] pci: fix build error with !PCIE_ECRC
Message-ID: <20090407123707.GA18687@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
drivers/built-in.o: In function `pci_init_capabilities':
drivers/pci/probe.c:989: undefined reference to `pcie_set_ecrc_checking'
drivers/built-in.o: In function `pci_setup':
drivers/pci/pci.c:2547: undefined reference to `pcie_ecrc_get_policy'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/pci/pci.c        |    2 ++
 drivers/pci/pcie/Kconfig |    2 +-
 drivers/pci/probe.c      |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f61b2cf..f1c393e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2543,8 +2543,10 @@ static int __init pci_setup(char *str)
 			} else if (!strncmp(str, "resource_alignment=", 19)) {
 				pci_set_resource_alignment_param(str + 19,
 							strlen(str + 19));
+#ifdef CONFIG_PCIE_ECRC
 			} else if (!strncmp(str, "ecrc=", 5)) {
 				pcie_ecrc_get_policy(str + 5);
+#endif
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index a79e52b..9d0e727 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -52,7 +52,7 @@ config PCIEASPM_DEBUG
 #
 config PCIE_ECRC
 	bool "PCI Express ECRC support"
-	depends on PCI
+	depends on PCI && PCIEPORTBUS
 	help
 	  Enables PCI Express ECRC (transaction layer end-to-end CRC
 	  checking)
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d5125a1..8d402a8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -985,8 +985,10 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	/* Single Root I/O Virtualization */
 	pci_iov_init(dev);
 
+#ifdef CONFIG_PCIE_ECRC
 	/* PCIe end-to-end CRC checking */
 	pcie_set_ecrc_checking(dev);
+#endif
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
