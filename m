Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbXJXOgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbXJXOgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbXJXOdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:33:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:46178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777AbXJXOdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:33:18 -0400
Subject: [Fwd: [PATCH 5/5] Check for ACPI resource conflicts in i2c bus
	drivers]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-acpi <linux-acpi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Andrew Morton <akpm@osdl.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Wed, 24 Oct 2007 16:33:17 +0200
Message-Id: <1193236397.4590.232.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-------- Forwarded Message --------
From: Jean Delvare <jdelvare@suse.de>
To: Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/3] Check for ACPI resource conflicts in i2c bus
drivers
Date: Sun, 21 Oct 2007 15:11:12 +0200

Check for ACPI resource conflicts in i2c bus drivers. I've included
all recent SMBus master drivers for PC hardware.

I've voluntarily left out:
* Drivers that don't run on PCs: they can't conflict with ACPI.
* Bit-banged bus device drivers: it's very unlikely that ACPI would
  deal with such buses.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/i2c/busses/i2c-ali1535.c |    6 ++++++
 drivers/i2c/busses/i2c-ali1563.c |    5 +++++
 drivers/i2c/busses/i2c-ali15x3.c |    5 +++++
 drivers/i2c/busses/i2c-amd756.c  |    6 ++++++
 drivers/i2c/busses/i2c-amd8111.c |    5 +++++
 drivers/i2c/busses/i2c-i801.c    |    5 +++++
 drivers/i2c/busses/i2c-nforce2.c |    6 ++++++
 drivers/i2c/busses/i2c-piix4.c   |    4 ++++
 drivers/i2c/busses/i2c-sis5595.c |    6 ++++++
 drivers/i2c/busses/i2c-sis630.c  |    6 ++++++
 drivers/i2c/busses/i2c-sis96x.c  |    5 +++++
 drivers/i2c/busses/i2c-viapro.c  |    5 +++++
 12 files changed, 64 insertions(+)

--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-ali1535.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-ali1535.c	2007-10-21 14:44:46.000000000 +0200
@@ -61,6 +61,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 

@@ -159,6 +160,11 @@ static int ali1535_setup(struct pci_dev 
 		goto exit;
 	}
 
+	retval = acpi_check_region(ali1535_smba, ALI1535_SMB_IOSIZE,
+				   ali1535_driver.name);
+	if (retval)
+		goto exit;
+
 	if (!request_region(ali1535_smba, ALI1535_SMB_IOSIZE,
 			    ali1535_driver.name)) {
 		dev_err(&dev->dev, "ALI1535_smb region 0x%x already in use!\n",
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-ali1563.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-ali1563.c	2007-10-21 14:44:46.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/i2c.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 
 #define ALI1563_MAX_TIMEOUT	500
 #define	ALI1563_SMBBA		0x80
@@ -345,6 +346,10 @@ static int __devinit ali1563_setup(struc
 		}
 	}
 
+	if (acpi_check_region(ali1563_smba, ALI1563_SMB_IOSIZE,
+			      ali1563_pci_driver.name))
+		goto Err;
+
 	if (!request_region(ali1563_smba, ALI1563_SMB_IOSIZE,
 			    ali1563_pci_driver.name)) {
 		dev_err(&dev->dev, "Could not allocate I/O space at 0x%04x\n",
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-ali15x3.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-ali15x3.c	2007-10-21 14:44:46.000000000 +0200
@@ -68,6 +68,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* ALI15X3 SMBus address offsets */
@@ -166,6 +167,10 @@ static int ali15x3_setup(struct pci_dev 
 	if(force_addr)
 		ali15x3_smba = force_addr & ~(ALI15X3_SMB_IOSIZE - 1);
 
+	if (acpi_check_region(ali15x3_smba, ALI15X3_SMB_IOSIZE,
+			      ali15x3_driver.name))
+		return -EBUSY;
+
 	if (!request_region(ali15x3_smba, ALI15X3_SMB_IOSIZE,
 			    ali15x3_driver.name)) {
 		dev_err(&ALI15X3_dev->dev,
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-amd756.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-amd756.c	2007-10-21 14:44:46.000000000 +0200
@@ -45,6 +45,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* AMD756 SMBus address offsets */
@@ -364,6 +365,11 @@ static int __devinit amd756_probe(struct
 		amd756_ioport += SMB_ADDR_OFFSET;
 	}
 
+	error = acpi_check_region(amd756_ioport, SMB_IOSIZE,
+				  amd756_driver.name);
+	if (error)
+		return error;
+
 	if (!request_region(amd756_ioport, SMB_IOSIZE, amd756_driver.name)) {
 		dev_err(&pdev->dev, "SMB region 0x%x already in use!\n",
 			amd756_ioport);
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-amd8111.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-amd8111.c	2007-10-21 14:44:46.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 MODULE_LICENSE("GPL");
@@ -359,6 +360,10 @@ static int __devinit amd8111_probe(struc
 	smbus->base = pci_resource_start(dev, 0);
 	smbus->size = pci_resource_len(dev, 0);
 
+	error = acpi_check_resource_conflict(&dev->resource[0]);
+	if (error)
+		goto out_kfree;
+
 	if (!request_region(smbus->base, smbus->size, amd8111_driver.name)) {
 		error = -EBUSY;
 		goto out_kfree;
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-i801.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-i801.c	2007-10-21 14:44:46.000000000 +0200
@@ -52,6 +52,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* I801 SMBus address offsets */
@@ -588,6 +589,10 @@ static int __devinit i801_probe(struct p
 		goto exit;
 	}
 
+	err = acpi_check_resource_conflict(&dev->resource[SMBBAR]);
+	if (err)
+		goto exit;
+
 	err = pci_request_region(dev, SMBBAR, i801_driver.name);
 	if (err) {
 		dev_err(&dev->dev, "Failed to request SMBus region "
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-nforce2.c	2007-10-21 14:21:51.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-nforce2.c	2007-10-21 14:44:46.000000000 +0200
@@ -50,6 +50,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 MODULE_LICENSE("GPL");
@@ -315,6 +316,11 @@ static int __devinit nforce2_probe_smb (
 		smbus->size = 64;
 	}
 
+	error = acpi_check_region(smbus->base, smbus->size,
+				  nforce2_driver.name);
+	if (error)
+		return -1;
+
 	if (!request_region(smbus->base, smbus->size, nforce2_driver.name)) {
 		dev_err(&smbus->adapter.dev, "Error requesting region %02x .. %02X for %s\n",
 			smbus->base, smbus->base+smbus->size-1, name);
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-piix4.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-piix4.c	2007-10-21 14:44:46.000000000 +0200
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/apm_bios.h>
 #include <linux/dmi.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 

@@ -151,6 +152,9 @@ static int __devinit piix4_setup(struct 
 		}
 	}
 
+	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
+		return -EBUSY;
+
 	if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
 		dev_err(&PIIX4_dev->dev, "SMB region 0x%x already in use!\n",
 			piix4_smba);
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-sis5595.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-sis5595.c	2007-10-21 14:44:46.000000000 +0200
@@ -62,6 +62,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static int blacklist[] = {
@@ -174,6 +175,11 @@ static int sis5595_setup(struct pci_dev 
 
 	/* NB: We grab just the two SMBus registers here, but this may still
 	 * interfere with ACPI :-(  */
+	retval = acpi_check_region(sis5595_base + SMB_INDEX, 2,
+				   sis5595_driver.name);
+	if (retval)
+		return retval;
+
 	if (!request_region(sis5595_base + SMB_INDEX, 2,
 			    sis5595_driver.name)) {
 		dev_err(&SIS5595_dev->dev, "SMBus registers 0x%04x-0x%04x already in use!\n",
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-sis630.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-sis630.c	2007-10-21 14:44:46.000000000 +0200
@@ -55,6 +55,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* SIS630 SMBus registers */
@@ -433,6 +434,11 @@ static int sis630_setup(struct pci_dev *
 
 	dev_dbg(&sis630_dev->dev, "ACPI base at 0x%04x\n", acpi_base);
 
+	retval = acpi_check_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION,
+				   sis630_driver.name);
+	if (retval)
+		goto exit;
+
 	/* Everything is happy, let's grab the memory and set things up. */
 	if (!request_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION,
 			    sis630_driver.name)) {
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-sis96x.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-sis96x.c	2007-10-21 14:44:46.000000000 +0200
@@ -40,6 +40,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* base address register in PCI config space */
@@ -286,6 +287,10 @@ static int __devinit sis96x_probe(struct
 	dev_info(&dev->dev, "SiS96x SMBus base address: 0x%04x\n",
 			sis96x_smbus_base);
 
+	retval = acpi_check_resource_conflict(&dev->resource[SIS96x_BAR]);
+	if (retval)
+		return retval;
+
 	/* Everything is happy, let's grab the memory and set things up. */
 	if (!request_region(sis96x_smbus_base, SMB_IOSIZE,
 			    sis96x_driver.name)) {
--- linux-2.6.24-rc0.orig/drivers/i2c/busses/i2c-viapro.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/i2c/busses/i2c-viapro.c	2007-10-21 14:44:46.000000000 +0200
@@ -49,6 +49,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static struct pci_dev *vt596_pdev;
@@ -349,6 +350,10 @@ static int __devinit vt596_probe(struct 
 	}
 
 found:
+	error = acpi_check_region(vt596_smba, 8, vt596_driver.name);
+	if (error)
+		return error;
+
 	if (!request_region(vt596_smba, 8, vt596_driver.name)) {
 		dev_err(&pdev->dev, "SMBus region 0x%x already in use!\n",
 			vt596_smba);

-- 
Thomas Renninger

Research and Developement Departement
SUSE LINUX Products GmbH,
Maxfeldstr. 5, D - 90409 Nürnberg
Phone: +49 (0)911 - 740 53 675
e-mail: trenn@suse.de

SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)

