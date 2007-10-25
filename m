Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbXJYIRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbXJYIRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbXJYIPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:15:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33915
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758983AbXJYIPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:15:52 -0400
Date: Thu, 25 Oct 2007 01:15:53 -0700 (PDT)
Message-Id: <20071025.011553.88769579.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: [PATCH 2/5]: [PCI]: Add MSI quirk for ServerWorks HT1000 PCIX
 bridge.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is the fix for the following problem:

https://bugzilla.redhat.com/show_bug.cgi?id=227657

The bnx2 device 5706 complains about MSI not working behind a
ServerWorks HT1000 PCIX bridge. An earlier commit to fix the problem:

e3008dedff4bdc96a5f67224cd3d8d12237082a0:

"PCI: disable MSI by default on systems with Serverworks HT1000 chips"

was not entirely correct, and has been reverted.

MSI does not work on the PCIX bus because the BIOS did not set the
HT_MSI_FLAGS_ENABLE bit in the HyperTransport MSI capability on the
bridge.  We use the existing quirk_msi_ht_cap() to detect the problem
and disable MSI in all buses behind it.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Cc: Anantha Subramanyam <ananth@broadcom.com>
Cc: Naren Sankar <nsankar@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/pci/quirks.c    |    3 +++
 include/linux/pci_ids.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f5999f5..f975f7f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1677,6 +1677,9 @@ static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
+			PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
+			quirk_msi_ht_cap);
 
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0571d6a..c64bb89 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1432,6 +1432,7 @@
 #define PCI_DEVICE_ID_SERVERWORKS_HE	  0x0008
 #define PCI_DEVICE_ID_SERVERWORKS_LE	  0x0009
 #define PCI_DEVICE_ID_SERVERWORKS_GCNB_LE 0x0017
+#define PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB	0x0036
 #define PCI_DEVICE_ID_SERVERWORKS_EPB	  0x0103
 #define PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE	0x0132
 #define PCI_DEVICE_ID_SERVERWORKS_OSB4	  0x0200
-- 
1.5.2.5

