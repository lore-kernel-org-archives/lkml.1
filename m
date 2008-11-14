Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYKNDnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYKNDnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKNDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:43:21 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:13371 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYKNDnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:43:20 -0500
X-BigFish: VPS-7(z5edJz936eQzzzz1497iz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KAB0Z9-04-78K-01
Subject: [PATCH UPDATED] usb: fix SB700 usb subsystem hang bug
From: Andiry Xu <andiry.xu@amd.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
CC: greg@kroah.com, volker.armin.hemmann@tu-clausthal.de, shane.huang@amd.com,
       libin.yang@amd.com, "Xu, Andiry" <Andiry.Xu@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Nov 2008 11:42:29 +0800
Message-ID: <1226634149.5734.1.camel@crane-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-OriginalArrivalTime: 14 Nov 2008 03:42:57.0760 (UTC) FILETIME=[15976E00:01C9460B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is required for AMD SB700 south bridge revision A12 and A13 to avoid
USB subsystem hang symptom. The USB subsystem hang symptom is observed when the
system has multiple USB devices connected to it. In some cases a USB hub may be
required to observe this symptom.

This patch works around the problem by correcting the internal register setting
that will help by changing the behavior of the internal logic to avoid the
USB subsystem hang issue. The change in the behavior of the logic does not
impact the normal operation of the USB subsystem.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Libin Yang <libin.yang@amd.com>
Reported-by: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Tested-by: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>

diff -ruN a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
--- a/drivers/usb/host/ehci-pci.c	2008-11-13 23:15:51.000000000 +0800
+++ b/drivers/usb/host/ehci-pci.c	2008-11-13 23:17:01.000000000 +0800
@@ -66,6 +66,8 @@
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
+	struct pci_dev		*p_smbus;
+	u8			rev;
 	u32			temp;
 	int			retval;
 
@@ -166,6 +168,25 @@
 			pci_write_config_byte(pdev, 0x4b, tmp | 0x20);
 		}
 		break;
+	case PCI_VENDOR_ID_ATI:
+		/* SB700 old version has a bug in EHCI controller,
+		 * which causes usb devices lose response in some cases.
+		 */
+		if (pdev->device == 0x4396) {
+			p_smbus = pci_get_device(PCI_VENDOR_ID_ATI,
+						 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+						 NULL);
+			if (!p_smbus)
+				break;
+			rev = p_smbus->revision;
+			if ((rev == 0x3a) || (rev == 0x3b)) {
+				u8 tmp;
+				pci_read_config_byte(pdev, 0x53, &tmp);
+				pci_write_config_byte(pdev, 0x53, tmp | (1<<3));
+			}
+			pci_dev_put(p_smbus);
+		}
+		break;
 	}
 
 	ehci_reset(ehci);


