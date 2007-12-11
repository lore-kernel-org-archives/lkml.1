Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXLKWTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXLKWTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXLKWTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:19:43 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54600 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbXLKWTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:19:43 -0500
Date: Tue, 11 Dec 2007 23:19:41 +0100
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] drivers/pci/msi.c: move arch hooks to the top
Message-ID: <20071211221940.GA14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following problem present with older gcc versions:

<--  snip  -->

...
  CC      drivers/pci/msi.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:692: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:704: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:724: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/pci/msi.c |   91 ++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 46 deletions(-)

6b61f9979425bec016aefdddfd415f6fa5240b67 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 07c9f09..21c73d5 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -25,6 +25,51 @@
 
 static int pci_msi_enable = 1;
 
+/* Arch hooks */
+
+int __attribute__ ((weak))
+arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+{
+	return 0;
+}
+
+int __attribute__ ((weak))
+arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
+{
+	return 0;
+}
+
+int __attribute__ ((weak))
+arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_desc *entry;
+	int ret;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		ret = arch_setup_msi_irq(dev, entry);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
+{
+	return;
+}
+
+void __attribute__ ((weak))
+arch_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		if (entry->irq != 0)
+			arch_teardown_msi_irq(entry->irq);
+	}
+}
+
 static void msi_set_enable(struct pci_dev *dev, int enable)
 {
 	int pos;
@@ -683,49 +728,3 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
 {
 	INIT_LIST_HEAD(&dev->msi_list);
 }
-
-
-/* Arch hooks */
-
-int __attribute__ ((weak))
-arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
-{
-	return 0;
-}
-
-int __attribute__ ((weak))
-arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
-{
-	return 0;
-}
-
-int __attribute__ ((weak))
-arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-{
-	struct msi_desc *entry;
-	int ret;
-
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		ret = arch_setup_msi_irq(dev, entry);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
-{
-	return;
-}
-
-void __attribute__ ((weak))
-arch_teardown_msi_irqs(struct pci_dev *dev)
-{
-	struct msi_desc *entry;
-
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq != 0)
-			arch_teardown_msi_irq(entry->irq);
-	}
-}

