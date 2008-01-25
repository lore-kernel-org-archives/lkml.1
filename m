Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYAYGqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYAYGqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 01:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYAYGqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 01:46:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:1565 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYAYGqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 01:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=T8PFBKDZVpZqMy7UWrv7VmB0wrVfg4KBD6Mzpcu+rjXm9Zm9QbEDOp68HI09MaobiNViivQbztyGcVdkoba40R8m/8u9eKl+YvkJM8JM5B0OUan9kfQTnESAYm5S/aJaVmjDjuSBda2zPNK7IgJzuU+drrtM75bRvZwIF6GD/uU=
Message-ID: <479985C0.9020100@gmail.com>
Date: Fri, 25 Jan 2008 15:46:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Shane Huang <Shane.Huang@amd.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] PCI: modify SB700 SATA MSI quirk
References: <B90463BC30D2E446BA423D888DC85E501BF9C7@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF9C7@sshaexmb1.amd.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shane Huang <shane.huang@amd.com>

SB700 SATA MSI bug will be fixed in SB700 revision A21 at hardware
level, but the SB700 revision older than A21 will also be found in the
market.  This patch modify the original quirk commit
bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.
The patch also removes quirk to 0x4395 because 0x4395 is SB800 device
ID.

Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Okay, here's reformatted in-line version.  Shane, please invest some
time into setting up email environment.  Sending patches via email is
an important part of the linux kernel development process and if
you're gonna submit patches, you're just gonna have to do it.

 drivers/pci/quirks.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 72e0bd5..a45c177 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1715,6 +1715,23 @@ static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
 }
+static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev *dev)
+{
+	struct pci_dev *p;
+
+	/* SB700 MSI issue will be fixed at HW level from revision A21,
+	 * we need check PCI REVISION ID of SMBus controller to get SB700
+	 * revision.
+	 */
+	p = pci_get_device(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+			   NULL);
+	if (!p)
+		return;
+
+	if ((p->revision < 0x3B) && (p->revision >= 0x30))
+		dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+	pci_dev_put(p);
+}
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_TIGON3_5780,
 			quirk_msi_intx_disable_bug);
@@ -1735,17 +1752,15 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			quirk_msi_intx_disable_bug);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4390,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4391,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4392,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4393,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4394,
-			quirk_msi_intx_disable_bug);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4395,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4373,
 			quirk_msi_intx_disable_bug);
