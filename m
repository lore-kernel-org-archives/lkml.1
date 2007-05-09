Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXEIMXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXEIMXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbXEIMXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:23:19 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:2107 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbXEIMXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=GGMds6aJVJ0Oi8HSQgpaLkN3/eXC5BOvTdcwUNgwrLNO6LNs2MhgyT7OSCx9Ua5gtYS51MwyrOgxxoPStrgxPDkZbR1w8i4kcgpFH24ydDQngLJpDyoteHF9N5xLE1sixq5UaXRMQC8yBIwtN40LTuTJtVRbUCXIs003Jx1/vtI=
Message-ID: <4641BD26.1020501@gmail.com>
Date: Wed, 09 May 2007 14:23:02 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg K-H <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       =?ISO-8859-1?Q?Mat=ED=ADas_Alejandro_Torres?= <torresmat@gmail.com>
Subject: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480, take #2
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel
boot parameter for ahci to work.  This patch renames quirk_svw_msi()
to quirk_disable_all_msi() and use it to disable MSI on those chips.

  http://thread.gmane.org/gmane.linux.ide/17820
  http://thread.gmane.org/gmane.linux.ide/17516
  https://bugzilla.novell.com/show_bug.cgi?id=263893

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Matí­as Alejandro Torres <torresmat@gmail.com>
---
Okay, this is the fixed version and should probably included in
-stable too as there have been quite some number of reports which got
resolved by adding 'pci=nomsi'.  Verified by Matí­as Alejandro Torres.

Thanks.

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3411483..1e3070e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1624,18 +1624,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
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
