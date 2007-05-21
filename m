Return-Path: <linux-kernel-owner+w=401wt.eu-S1765303AbXEUTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765303AbXEUTVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764213AbXEUTVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:01 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46191 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbXEUTVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:00 -0400
Message-Id: <20070521191736.494772000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org,
       torresmat@gmail.com
Subject: [patch 41/69] pci-quirks: disable MSI on RS400-200 and RS480
Content-Disposition: inline; filename=pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel boot
parameter for ahci to work.  This patch renames quirk_svw_msi() to
quirk_disable_all_msi() and use it to disable MSI on those chips.

  http://thread.gmane.org/gmane.linux.ide/17820
  http://thread.gmane.org/gmane.linux.ide/17516
  https://bugzilla.novell.com/show_bug.cgi?id=263893

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Matí-as Alejandro Torres <torresmat@gmail.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 drivers/pci/quirks.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- linux-2.6.21.1.orig/drivers/pci/quirks.c
+++ linux-2.6.21.1/drivers/pci/quirks.c
@@ -1737,18 +1737,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
 #ifdef CONFIG_PCI_MSI
-/* The Serverworks PCI-X chipset does not support MSI. We cannot easily rely
- * on setting PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
- * some other busses controlled by the chipset even if Linux is not aware of it.
- * Instead of setting the flag on all busses in the machine, simply disable MSI
- * globally.
+/* Some chipsets do not support MSI. We cannot easily rely on setting
+ * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
+ * some other busses controlled by the chipset even if Linux is not
+ * aware of it.  Instead of setting the flag on all busses in the
+ * machine, simply disable MSI globally.
  */
-static void __init quirk_svw_msi(struct pci_dev *dev)
+static void __init quirk_disable_all_msi(struct pci_dev *dev)
 {
 	pci_no_msi();
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_svw_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)

-- 
