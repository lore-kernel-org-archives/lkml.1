Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYCVPQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYCVPQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYCVPQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:16:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:26743 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYCVPQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HRueAXoGfOGrFSF/bYifVvETH13DEDgz4ljTc/RODKZTYtxB8zAofi4g0LIgA9v8FTBJioRH3gKmNxL6emo7gGW/Oh0Vr+a4sZvy6n1Vl8EQZqkO2BzjV+ALibyOSX0WC0QdL0uIljemj+SOl6J0xBvOVh2k1uH9RegpEOQ1x+0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: remove CONFIG_BLK_DEV_HD_IDE config option (take 2)
Date: Sat, 22 Mar 2008 16:31:04 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803221631.04716.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove CONFIG_BLK_DEV_HD hack from init_hwif_default()
  ("hda=noprobe hdb=noprobe" kernel parameters should be used
  instead if somebody wishes to use the old "hd" driver).

* Make CONFIG_BLK_DEV_HD_ONLY config option available also when
  IDE subsystem is used and update help entry.

* Remove no longer needed CONFIG_BLK_DEV_HD_IDE config option.

v2:
* Update documentation to suggest "hda=noprobe hdb=noprobe"
  instead of obsoleted "ide0=noprobe".

* Update Documentation/ide/ide.txt.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 Documentation/ide/ide.txt |    7 -------
 drivers/ide/Kconfig       |   25 +++++--------------------
 drivers/ide/ide.c         |    4 ----
 3 files changed, 5 insertions(+), 31 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -184,13 +184,6 @@ provided it is mounted with the default 
 Please pass on any feedback on any of this stuff to the maintainer,
 whose address can be found in linux/MAINTAINERS.
 
-Note that if BOTH hd.c and ide.c are configured into the kernel,
-hd.c will normally be allowed to control the primary IDE interface.
-This is useful for older hardware that may be incompatible with ide.c,
-and still allows newer hardware to run on the 2nd/3rd/4th IDE ports
-under control of ide.c.   To have ide.c also "take over" the primary
-IDE port in this situation, use the "command line" parameter:  ide0=0x1f0
-
 The IDE driver is modularized.  The high level disk/CD-ROM/tape/floppy
 drivers can always be compiled as loadable modules, the chipset drivers
 can only be compiled into the kernel, and the core code (ide.c) can be
Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -122,24 +122,6 @@ config BLK_DEV_IDE_SATA
 
 	  If unsure, say N.
 
-config BLK_DEV_HD_IDE
-	bool "Use old disk-only driver on primary interface"
-	depends on (X86 || SH_MPC1211)
-	---help---
-	  There are two drivers for MFM/RLL/IDE disks.  Most people use just
-	  the new enhanced driver by itself.  This option however installs the
-	  old hard disk driver to control the primary IDE/disk interface in
-	  the system, leaving the new enhanced IDE driver to take care of only
-	  the 2nd/3rd/4th IDE interfaces.  Doing this will prevent you from
-	  having an IDE/ATAPI CD-ROM or tape drive connected to the primary
-	  IDE interface.  Choosing this option may be useful for older systems
-	  which have MFM/RLL/ESDI controller+drives at the primary port
-	  address (0x1f0), along with IDE drives at the secondary/3rd/4th port
-	  addresses.
-
-	  Normally, just say N here; you will then use the new driver for all
-	  4 interfaces.
-
 config BLK_DEV_IDEDISK
 	tristate "Include IDE/ATA-2 DISK support"
 	---help---
@@ -1114,7 +1096,6 @@ endif
 
 config BLK_DEV_HD_ONLY
 	bool "Old hard disk (MFM/RLL/IDE) driver"
-	depends on BLK_DEV_IDE=n
 	help
 	  There are two drivers for MFM/RLL/IDE hard disks. Most people use
 	  the newer enhanced driver, but this old one is still around for two
@@ -1126,12 +1107,16 @@ config BLK_DEV_HD_ONLY
 	  for systems with only older MFM/RLL/ESDI drives. Choosing the old
 	  driver can save 13 KB or so of kernel memory.
 
+	  If you want to use this driver together with the new one you have
+	  to use "hda=noprobe hdb=noprobe" kernel parameters to prevent the new
+	  driver from probing the primary interface.
+
 	  If you are unsure, then just choose the Enhanced IDE/MFM/RLL driver
 	  instead of this one. For more detailed information, read the
 	  Disk-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
 config BLK_DEV_HD
-	def_bool BLK_DEV_HD_IDE || BLK_DEV_HD_ONLY
+	def_bool BLK_DEV_HD_ONLY
 
 endif # IDE
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -177,10 +177,6 @@ static void init_hwif_default(ide_hwif_t
 	memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
 
 	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
-#ifdef CONFIG_BLK_DEV_HD
-	if (hwif->io_ports[IDE_DATA_OFFSET] == HD_DATA)
-		hwif->noprobe = 1;	/* may be overridden by ide_setup() */
-#endif
 }
 
 /*
