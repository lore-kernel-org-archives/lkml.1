Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZIUMIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZIUMIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZIUMIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:08:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZIUMIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:08:43 -0400
Message-ID: <4AB76CC4.4070802@redhat.com>
Date: Mon, 21 Sep 2009 14:08:36 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, g.giorgetti@teamsystem.com,
       Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
Subject: [PATCH] PCI: avoid boot interrupt quirk for AMD 813x B1 devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@redhat.com>

AMD 813x rev. B1 (like rev. B2) devices generate no interrupts if
quirk_disable_amd_813x_boot_interrupt is executed, add an exception.
http://bugzilla.kernel.org/show_bug.cgi?id=14159

Patch also adds missing cases for DECLARE_PCI_FIXUP_RESUME and
DECLARE_PCI_FIXUP_FINAL calls to quirk_disable_amd_813x_boot_interrupt.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
Tested-by: Gabriele Giorgetti <g.giorgetti@teamsystem.com>
---
 drivers/pci/quirks.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 06b9656..7d809b8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1661,6 +1661,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SERVERWORKS,   PCI_DEVICE_ID_SERVERWORKS_
  */
 #define AMD_813X_MISC			0x40
 #define AMD_813X_NOIOAMODE		(1<<0)
+#define AMD_813X_REV_B1			0x12
 #define AMD_813X_REV_B2			0x13

 static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
@@ -1669,7 +1670,8 @@ static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)

 	if (noioapicquirk)
 		return;
-	if (dev->revision == AMD_813X_REV_B2)
+	if ((dev->revision == AMD_813X_REV_B1) ||
+	    (dev->revision == AMD_813X_REV_B2))
 		return;

 	pci_read_config_dword(dev, AMD_813X_MISC, &pci_config_dword);
@@ -1679,8 +1681,10 @@ static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
 	printk(KERN_INFO "disabled boot interrupts on PCI device "
 			"0x%04x:0x%04x\n", dev->vendor, dev->device);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8131_BRIDGE, 	quirk_disable_amd_813x_boot_interrupt);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8132_BRIDGE, 	quirk_disable_amd_813x_boot_interrupt);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8131_BRIDGE,	quirk_disable_amd_813x_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8131_BRIDGE,	quirk_disable_amd_813x_boot_interrupt);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8132_BRIDGE,	quirk_disable_amd_813x_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8132_BRIDGE,	quirk_disable_amd_813x_boot_interrupt);

 #define AMD_8111_PCI_IRQ_ROUTING	0x56


