Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbYKYHNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbYKYHNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYKYHMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:12:53 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53532 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYKYHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:12:52 -0500
X-BigFish: VPS-4(zz936eQzzzz1497i23ebiz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KAVO0N-04-K2Z-01
Subject: [PATCH] USB: fix SB600 USB subsystem hang bug
From: Shane Huang <shane.huang@amd.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
CC: ralfconn@tele2.it, roman@rm.pp.ru, "Yang, Libin" <Libin.Yang@amd.com>,
       "Xu, Andiry" <Andiry.Xu@amd.com>, "Huang, Shane" <Shane.Huang@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Nov 2008 15:12:33 +0800
Message-ID: <1227597153.5518.6.camel@chunhao-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-OriginalArrivalTime: 25 Nov 2008 07:12:37.0918 (UTC) FILETIME=[327E73E0:01C94ECD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is required for all AMD SB600 revisions to avoid USB subsystem hang
symptom. The USB subsystem hang symptom is observed when the system has
multiple USB devices connected to it. In some cases a USB hub may be required
to observe this symptom.

Reported in bugzilla as #11599, the similar patch for SB700 old revision is:
commit b09bc6cbae4dd3a2d35722668ef2c502a7b8b093

Reported-by: raffaele <ralfconn@tele2.it>
Tested-by: Roman Mamedov <roman@rm.pp.ru>
Signed-off-by: Shane Huang <shane.huang@amd.com>

diff -ruN a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
--- a/drivers/usb/host/ehci-pci.c	2008-11-25 18:49:51.000000000 +0800
+++ b/drivers/usb/host/ehci-pci.c	2008-11-25 18:49:55.000000000 +0800
@@ -169,18 +169,21 @@
 		}
 		break;
 	case PCI_VENDOR_ID_ATI:
-		/* SB700 old version has a bug in EHCI controller,
+		/* SB600 and old version of SB700 have a bug in EHCI controller,
 		 * which causes usb devices lose response in some cases.
 		 */
-		if (pdev->device == 0x4396) {
+		if ((pdev->device == 0x4386) || (pdev->device == 0x4396)) {
 			p_smbus = pci_get_device(PCI_VENDOR_ID_ATI,
 						 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 						 NULL);
 			if (!p_smbus)
 				break;
 			rev = p_smbus->revision;
-			if ((rev == 0x3a) || (rev == 0x3b)) {
+			if ((pdev->device == 0x4386) || (rev == 0x3a)
+			    || (rev == 0x3b)) {
 				u8 tmp;
+				ehci_info(ehci, "applying AMD SB600/SB700 USB "
+					"freeze workaround\n");
 				pci_read_config_byte(pdev, 0x53, &tmp);
 				pci_write_config_byte(pdev, 0x53, tmp | (1<<3));
 			}


