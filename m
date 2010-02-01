Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0BALQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 06:16:39 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:46590 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0BALQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 06:16:37 -0500
Message-ID: <4B66B793.4070603@sirrix.com>
Date: Mon, 01 Feb 2010 12:14:27 +0100
From: Marcel Selhorst <m.selhorst@sirrix.com>
Organization: Sirrix AG Security Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100110 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>
Subject: Re: [PATCH] tpm_infineon: Fix suspend/resume handler for pnp_driver
References: <87d41xu18p.fsf@devron.myhome.or.jp>	<20100105155900.7cf92358.akpm@linux-foundation.org> <87vdfasv8z.fsf@devron.myhome.or.jp>
In-Reply-To: <87vdfasv8z.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.1.154; VDF: 7.10.3.141; host: mail.selhorst.net); id=32388-iwqOwI
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> With review, it seems anybody doesn't call pnp_driver->driver.suspend/resume().
> (pnp_bus calls pnp_device->pnp_driver->suspend/resume())

after testing the patch, it seems that it is not working correctly.
When suspending, tpm_infineon calls the generic suspend function
of the TPM framework. However, the TPM framework does not return 
and the system hangs upon suspend. When sending the necessary 
command "TPM_SaveState" directly within the driver, suspending and 
resuming works fine.

Please revert the patch "tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch"
from Ogawa Hirofumi from 12/29/2009 and use the attached patch instead.

Best regards,
Marcel Selhorst

Signed-off-by: Marcel Selhorst <m.selhorst@sirrix.com>

diff -pruN orig/drivers/char/tpm/tpm_infineon.c new/drivers/char/tpm/tpm_infineon.c
--- orig/drivers/char/tpm/tpm_infineon.c	2009-09-10 00:13:59.000000000 +0200
+++ new/drivers/char/tpm/tpm_infineon.c	2010-02-01 11:39:20.358002383 +0100
@@ -39,12 +39,12 @@
 struct tpm_inf_dev {
 	int iotype;
 
-	void __iomem *mem_base;		/* MMIO ioremap'd addr */
-	unsigned long map_base;		/* phys MMIO base */
-	unsigned long map_size;		/* MMIO region size */
-	unsigned int index_off;		/* index register offset */
+	void __iomem *mem_base;	/* MMIO ioremap'd addr */
+	unsigned long map_base;	/* phys MMIO base */
+	unsigned long map_size;	/* MMIO region size */
+	unsigned int index_off;	/* index register offset */
 
-	unsigned int data_regs;		/* Data registers */
+	unsigned int data_regs;	/* Data registers */
 	unsigned int data_size;
 
 	unsigned int config_port;	/* IO Port config index reg */
@@ -406,14 +406,14 @@ static const struct tpm_vendor_specific 
 	.miscdev = {.fops = &inf_ops,},
 };
 
-static const struct pnp_device_id tpm_pnp_tbl[] = {
+static const struct pnp_device_id tpm_inf_pnp_tbl[] = {
 	/* Infineon TPMs */
 	{"IFX0101", 0},
 	{"IFX0102", 0},
 	{"", 0}
 };
 
-MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
+MODULE_DEVICE_TABLE(pnp, tpm_inf_pnp_tbl);
 
 static int __devinit tpm_inf_pnp_probe(struct pnp_dev *dev,
 				       const struct pnp_device_id *dev_id)
@@ -430,7 +430,7 @@ static int __devinit tpm_inf_pnp_probe(s
 	if (pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) &&
 	    !(pnp_port_flags(dev, 0) & IORESOURCE_DISABLED)) {
 
-	    	tpm_dev.iotype = TPM_INF_IO_PORT;
+		tpm_dev.iotype = TPM_INF_IO_PORT;
 
 		tpm_dev.config_port = pnp_port_start(dev, 0);
 		tpm_dev.config_size = pnp_port_len(dev, 0);
@@ -459,9 +459,9 @@ static int __devinit tpm_inf_pnp_probe(s
 			goto err_last;
 		}
 	} else if (pnp_mem_valid(dev, 0) &&
-	           !(pnp_mem_flags(dev, 0) & IORESOURCE_DISABLED)) {
+		   !(pnp_mem_flags(dev, 0) & IORESOURCE_DISABLED)) {
 
-	    	tpm_dev.iotype = TPM_INF_IO_MEM;
+		tpm_dev.iotype = TPM_INF_IO_MEM;
 
 		tpm_dev.map_base = pnp_mem_start(dev, 0);
 		tpm_dev.map_size = pnp_mem_len(dev, 0);
@@ -563,11 +563,11 @@ static int __devinit tpm_inf_pnp_probe(s
 			 "product id 0x%02x%02x"
 			 "%s\n",
 			 tpm_dev.iotype == TPM_INF_IO_PORT ?
-				tpm_dev.config_port :
-				tpm_dev.map_base + tpm_dev.index_off,
+			 tpm_dev.config_port :
+			 tpm_dev.map_base + tpm_dev.index_off,
 			 tpm_dev.iotype == TPM_INF_IO_PORT ?
-				tpm_dev.data_regs :
-				tpm_dev.map_base + tpm_dev.data_regs,
+			 tpm_dev.data_regs :
+			 tpm_dev.map_base + tpm_dev.data_regs,
 			 version[0], version[1],
 			 vendorid[0], vendorid[1],
 			 productid[0], productid[1], chipname);
@@ -607,20 +607,55 @@ static __devexit void tpm_inf_pnp_remove
 			iounmap(tpm_dev.mem_base);
 			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
 		}
+		tpm_dev_vendor_release(chip);
 		tpm_remove_hardware(chip->dev);
 	}
 }
 
+static int tpm_inf_pnp_suspend(struct pnp_dev *dev, pm_message_t pm_state)
+{
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	int rc;
+	if (chip) {
+		u8 savestate[] = {
+			0, 193,	/* TPM_TAG_RQU_COMMAND */
+			0, 0, 0, 10,	/* blob length (in bytes) */
+			0, 0, 0, 152	/* TPM_ORD_SaveState */
+		};
+		dev_info(&dev->dev, "saving TPM state\n");
+		rc = tpm_inf_send(chip, savestate, sizeof(savestate));
+		if (rc < 0) {
+			dev_err(&dev->dev, "error while saving TPM state\n");
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static int tpm_inf_pnp_resume(struct pnp_dev *dev)
+{
+	/* Re-configure TPM after suspending */
+	tpm_config_out(ENABLE_REGISTER_PAIR, TPM_INF_ADDR);
+	tpm_config_out(IOLIMH, TPM_INF_ADDR);
+	tpm_config_out((tpm_dev.data_regs >> 8) & 0xff, TPM_INF_DATA);
+	tpm_config_out(IOLIML, TPM_INF_ADDR);
+	tpm_config_out((tpm_dev.data_regs & 0xff), TPM_INF_DATA);
+	/* activate register */
+	tpm_config_out(TPM_DAR, TPM_INF_ADDR);
+	tpm_config_out(0x01, TPM_INF_DATA);
+	tpm_config_out(DISABLE_REGISTER_PAIR, TPM_INF_ADDR);
+	/* disable RESET, LP and IRQC */
+	tpm_data_out(RESET_LP_IRQC_DISABLE, CMD);
+	return tpm_pm_resume(&dev->dev);
+}
+
 static struct pnp_driver tpm_inf_pnp_driver = {
 	.name = "tpm_inf_pnp",
-	.driver = {
-		.owner = THIS_MODULE,
-		.suspend = tpm_pm_suspend,
-		.resume = tpm_pm_resume,
-	},
-	.id_table = tpm_pnp_tbl,
+	.id_table = tpm_inf_pnp_tbl,
 	.probe = tpm_inf_pnp_probe,
-	.remove = __devexit_p(tpm_inf_pnp_remove),
+	.suspend = tpm_inf_pnp_suspend,
+	.resume = tpm_inf_pnp_resume,
+	.remove = __devexit_p(tpm_inf_pnp_remove)
 };
 
 static int __init init_inf(void)
@@ -638,5 +673,5 @@ module_exit(cleanup_inf);
 
 MODULE_AUTHOR("Marcel Selhorst <m.selhorst@sirrix.com>");
 MODULE_DESCRIPTION("Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2");
-MODULE_VERSION("1.9");
+MODULE_VERSION("1.9.2");
 MODULE_LICENSE("GPL");

-- 
Sirrix AG security technologies -- http://www.sirrix.com
Dipl.-Ing. Marcel Selhorst  eMail: m.selhorst@sirrix.com
Tel: +49 (234) 610071-126   Fax: +49 (234) 610071-526
Tel: +49 (681)  95986-126   Fax: +49 (681)  95986-526
Get my public key from keyserver, KeyId: 0x7C9821CC
Fingerprint 4138 E617 E62E 79D3 E663 BE5A 14E7 1CD8 7C98 21CC

Vorstand: Ammar Alkassar (Vors.), Christian Stueble
Vorsitzender des Aufsichtsrates: Prof. Dr. Kai Rannenberg
Sitz der Gesellschaft: Homburg/Saar, HRB 3857 Amtsgericht Saarbruecken

This message may contain confidential and/or privileged information.
If you are not the addressee, you must not use, copy, disclose or
take any action based on this message or any information herein.
If you have received this message in error, please advise the sender
immediately by reply e-mail and delete this message.
