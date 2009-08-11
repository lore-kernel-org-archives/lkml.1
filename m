Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbZHKLzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbZHKLzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZHKLzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:55:04 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42020 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZHKLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:57 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i209h6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO6ZD9-04-ZGP-01
Date: Tue, 11 Aug 2009 11:07:58 +0800
From: Crane Cai <crane.cai@amd.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] I2C: Add support for new AMD SMBus devices
Message-ID: <20090811030758.GC29858@crane-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Aug 2009 03:07:58.0807 (UTC) FILETIME=[EE0D1E70:01CA1A30]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD newer SMBus device uses the piix4 driver, and device is added by vendor ID
and class code. This method will include AMD old SMBus controller in, and need
to filter it out.

Signed-off-by: Crane Cai <crane.cai@amd.com>
---
 drivers/i2c/busses/i2c-piix4.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 0249a7d..2539282 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -232,6 +232,14 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 	unsigned short smba_idx = 0xcd6;
 	u8 smba_en_lo, smba_en_hi, i2ccfg, i2ccfg_offset = 0x10, smb_en = 0x2c;
 
+	/* Filter AMD old SMBus controller out */
+	if (PIIX4_dev->vendor == PCI_VENDOR_ID_AMD &&
+	    (PIIX4_dev->device <= PCI_DEVICE_ID_AMD_8111_SMBUS &&
+	     PIIX4_dev->device >= PCI_DEVICE_ID_AMD_VIPER_740B)) {
+		dev_info(&PIIX4_dev->dev, "Does not support this chip.\n");
+		return -ENODEV;
+	}
+
 	/* SB800 SMBus does not support forcing address */
 	if (force || force_addr) {
 		dev_err(&PIIX4_dev->dev, "SB800 SMBus does not support "
@@ -479,6 +487,10 @@ static struct pci_device_id piix4_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
+	/* AMD Generic, PCI class code and Vendor ID for SMBus */
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_ANY_ID),
+	  .class = PCI_CLASS_SERIAL_SMBUS << 8,
+	  .class_mask = 0xffffff },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
@@ -499,9 +511,10 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 {
 	int retval;
 
-	if ((dev->vendor == PCI_VENDOR_ID_ATI) &&
+	if (((dev->vendor == PCI_VENDOR_ID_ATI) &&
 	    (dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS) &&
-	    (dev->revision >= 0x40))
+	    (dev->revision >= 0x40)) ||
+	    dev->vendor == PCI_VENDOR_ID_AMD)
 		/* base address location etc changed in SB800 */
 		retval = piix4_setup_sb800(dev, id);
 	else
-- 
1.6.0.4

