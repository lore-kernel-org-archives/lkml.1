Return-Path: <linux-kernel-owner+w=401wt.eu-S1030193AbXBZNNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193AbXBZNNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030205AbXBZNNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:13:55 -0500
Received: from mx1.suse.de ([195.135.220.2]:47541 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030193AbXBZNNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:13:54 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Dave Jones <davej@codemonkey.org.uk>, linux-kernel@vger.kernel.org
Subject: [patch]prevent probe collision of sis-agp and amd64_agp
Date: Mon, 26 Feb 2007 14:13:36 +0100
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261413.37333.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for some vendor/id pairs the kernel will autoload both the sis-agp
and the amd64_agp modules as the sis-agp module will load for all
sis devices. This collision causes the bug reported in:
http://bugzilla.novell.com/show_bug.cgi?id=248665

As currently sis_probe does its own matching, requesting the whole
range gains nothing. The clean fix seems to me to leave the matching to
the core and advertise only the devices actually supported. This patch
does so.

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>
----

--- a/drivers/char/agp/sis-agp.c	2007-02-26 11:19:22.000000000 +0100
+++ b/drivers/char/agp/sis-agp.c	2007-02-26 13:31:09.000000000 +0100
@@ -142,96 +142,6 @@
 	.agp_destroy_page	= agp_generic_destroy_page,
 };
 
-static struct agp_device_ids sis_agp_device_ids[] __devinitdata =
-{
-	{
-		.device_id	= PCI_DEVICE_ID_SI_5591_AGP,
-		.chipset_name	= "5591",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_530,
-		.chipset_name	= "530",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_540,
-		.chipset_name	= "540",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_550,
-		.chipset_name	= "550",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_620,
-		.chipset_name	= "620",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_630,
-		.chipset_name	= "630",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_635,
-		.chipset_name	= "635",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_645,
-		.chipset_name	= "645",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_646,
-		.chipset_name	= "646",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_648,
-		.chipset_name	= "648",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_650,
-		.chipset_name	= "650",
-	},
-	{
-		.device_id  = PCI_DEVICE_ID_SI_651,
-		.chipset_name   = "651",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_655,
-		.chipset_name	= "655",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_661,
-		.chipset_name	= "661",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_730,
-		.chipset_name	= "730",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_735,
-		.chipset_name	= "735",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_740,
-		.chipset_name	= "740",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_741,
-		.chipset_name	= "741",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_745,
-		.chipset_name	= "745",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_746,
-		.chipset_name	= "746",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_SI_760,
-		.chipset_name	= "760",
-	},
-	{ }, /* dummy final entry, always present */
-};
-
-
 // chipsets that require the 'delay hack'
 static int sis_broken_chipsets[] __devinitdata = {
 	PCI_DEVICE_ID_SI_648,
@@ -268,29 +178,15 @@
 static int __devinit agp_sis_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-	struct agp_device_ids *devs = sis_agp_device_ids;
 	struct agp_bridge_data *bridge;
 	u8 cap_ptr;
-	int j;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
 
-	/* probe for known chipsets */
-	for (j = 0; devs[j].chipset_name; j++) {
-		if (pdev->device == devs[j].device_id) {
-			printk(KERN_INFO PFX "Detected SiS %s chipset\n",
-					devs[j].chipset_name);
-			goto found;
-		}
-	}
-
-	printk(KERN_ERR PFX "Unsupported SiS chipset (device id: %04x)\n",
-		    pdev->device);
-	return -ENODEV;
 
-found:
+	printk(KERN_INFO PFX "Detected SiS chipset - id:%i\n", pdev->device);
 	bridge = agp_alloc_bridge();
 	if (!bridge)
 		return -ENOMEM;
@@ -319,12 +215,172 @@
 
 static struct pci_device_id agp_sis_pci_table[] = {
 	{
-	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
-	.class_mask	= ~0,
-	.vendor		= PCI_VENDOR_ID_SI,
-	.device		= PCI_ANY_ID,
-	.subvendor	= PCI_ANY_ID,
-	.subdevice	= PCI_ANY_ID,
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_5591_AGP,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_530,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_540,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_550,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_620,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_630,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_635,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_645,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_646,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_648,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_650,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_651,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_655,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_661,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_730,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_735,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_740,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_741,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_745,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_746,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+	{
+		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
+		.class_mask	= ~0,
+		.vendor		= PCI_VENDOR_ID_SI,
+		.device		= PCI_DEVICE_ID_SI_760,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
 	},
 	{ }
 };
