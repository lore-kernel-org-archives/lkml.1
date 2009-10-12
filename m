Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbZJLPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbZJLPsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbZJLPsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:48:17 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:37379 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbZJLPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:48:16 -0400
X-Greylist: delayed 724 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 11:48:15 EDT
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] cciss: Add cciss_allow_hpsa module parameter.
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Mon, 12 Oct 2009 10:36:25 -0500
Message-ID: <20091012153606.4367.73416.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cciss_allow_hpsa module parameter.  This parameter causes
the cciss driver to ignore any Smart Array devices known to be
supported by the hpsa driver.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   74 +++++++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 52f53c1..6399e50 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -68,6 +68,12 @@ MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
 MODULE_VERSION("3.6.20");
 MODULE_LICENSE("GPL");
 
+static int cciss_allow_hpsa;
+module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(cciss_allow_hpsa,
+	"Prevent cciss driver from accessing hardware known to be "
+	" supported by the hpsa driver");
+
 #include "cciss_cmd.h"
 #include "cciss.h"
 #include <linux/cciss_ioctl.h>
@@ -101,8 +107,6 @@ static const struct pci_device_id cciss_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
 
@@ -123,8 +127,6 @@ static struct board_type products[] = {
 	{0x409D0E11, "Smart Array 6400 EM", &SA5_access},
 	{0x40910E11, "Smart Array 6i", &SA5_access},
 	{0x3225103C, "Smart Array P600", &SA5_access},
-	{0x3223103C, "Smart Array P800", &SA5_access},
-	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x3235103C, "Smart Array P400i", &SA5_access},
 	{0x3211103C, "Smart Array E200i", &SA5_access},
 	{0x3212103C, "Smart Array E200", &SA5_access},
@@ -132,6 +134,10 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
 	{0x3237103C, "Smart Array E500", &SA5_access},
+/* controllers below this line are also supported by the hpsa driver. */
+#define HPSA_BOUNDARY 0x3223103C
+	{0x3223103C, "Smart Array P800", &SA5_access},
+	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x323D103C, "Smart Array P700m", &SA5_access},
 	{0x3241103C, "Smart Array P212", &SA5_access},
 	{0x3243103C, "Smart Array P410", &SA5_access},
@@ -140,7 +146,6 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
-	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
@@ -3754,7 +3759,27 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	__u64 cfg_offset;
 	__u32 cfg_base_addr;
 	__u64 cfg_base_addr_index;
-	int i, err;
+	int i, prod_index, err;
+
+	subsystem_vendor_id = pdev->subsystem_vendor;
+	subsystem_device_id = pdev->subsystem_device;
+	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
+		    subsystem_vendor_id);
+
+	for (i = 0; i < ARRAY_SIZE(products); i++) {
+		/* Stand aside for hpsa driver on request */
+		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
+			return -ENODEV;
+		if (board_id == products[i].board_id)
+			break;
+	}
+	prod_index = i;
+	if (prod_index == ARRAY_SIZE(products)) {
+		dev_warn(&pdev->dev,
+			"unrecognized board ID: 0x%08lx, ignoring.\n",
+			(unsigned long) board_id);
+		return -ENODEV;
+	}
 
 	/* check to see if controller has been disabled */
 	/* BEFORE trying to enable it */
@@ -3778,11 +3803,6 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 		return err;
 	}
 
-	subsystem_vendor_id = pdev->subsystem_vendor;
-	subsystem_device_id = pdev->subsystem_device;
-	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
-		    subsystem_vendor_id);
-
 #ifdef CCISS_DEBUG
 	printk("command = %x\n", command);
 	printk("irq = %x\n", pdev->irq);
@@ -3868,14 +3888,9 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	 * leave a little room for ioctl calls.
 	 */
 	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
-	for (i = 0; i < ARRAY_SIZE(products); i++) {
-		if (board_id == products[i].board_id) {
-			c->product_name = products[i].product_name;
-			c->access = *(products[i].access);
-			c->nr_cmds = c->max_commands - 4;
-			break;
-		}
-	}
+	c->product_name = products[prod_index].product_name;
+	c->access = *(products[prod_index].access);
+	c->nr_cmds = c->max_commands - 4;
 	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
 	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
 	    (readb(&c->cfgtable->Signature[2]) != 'S') ||
@@ -3884,27 +3899,6 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
-	/* We didn't find the controller in our list. We know the
-	 * signature is valid. If it's an HP device let's try to
-	 * bind to the device and fire it up. Otherwise we bail.
-	 */
-	if (i == ARRAY_SIZE(products)) {
-		if (subsystem_vendor_id == PCI_VENDOR_ID_HP) {
-			c->product_name = products[i-1].product_name;
-			c->access = *(products[i-1].access);
-			c->nr_cmds = c->max_commands - 4;
-			printk(KERN_WARNING "cciss: This is an unknown "
-				"Smart Array controller.\n"
-				"cciss: Please update to the latest driver "
-				"available from www.hp.com.\n");
-		} else {
-			printk(KERN_WARNING "cciss: Sorry, I don't know how"
-				" to access the Smart Array controller %08lx\n"
-					, (unsigned long)board_id);
-			err = -ENODEV;
-			goto err_out_free_res;
-		}
-	}
 #ifdef CONFIG_X86
 	{
 		/* Need to enable prefetch in the SCSI core for 6400 in x86 */

