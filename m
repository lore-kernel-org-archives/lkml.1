Return-Path: <linux-kernel-owner+w=401wt.eu-S1763779AbYBHAhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763779AbYBHAhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbYBHAbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:31:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:7734 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678AbYBHAbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ifWLaPlohbK2VgXSiL7XiJvyGEvA59unpZakVkD+Z/5mZd0T9BWyXHWXBSftz202MgyeLD6MZMJnfesbuJECm/SZbKM2L4n13nVHKWFwFNB+KSA9qVPvQXvIc/cjc2j68QwQNdvC0i49U3ec7Tf8E9XcJwpVUJVMrYTNLaf+eA8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:52 +0100
Message-Id: <20080208004552.17746.61665.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/18] ide: remove CONFIG_BLK_DEV_HD_IDE config option
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove CONFIG_BLK_DEV_HD hack from init_hwif_default() ("ide0=noprobe"
  kernel parameter should be used instead if somebody wishes to use the
  old "hd" driver).

* Make CONFIG_BLK_DEV_HD_ONLY config option available also when IDE
  subsystem is used and update help entry.

* Remove no longer needed CONFIG_BLK_DEV_HD_IDE config option.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig |   25 +++++--------------------
 drivers/ide/ide.c   |    4 ----
 2 files changed, 5 insertions(+), 24 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -118,24 +118,6 @@ config BLK_DEV_IDE_SATA
 
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
@@ -1112,7 +1094,6 @@ endif
 
 config BLK_DEV_HD_ONLY
 	bool "Old hard disk (MFM/RLL/IDE) driver"
-	depends on BLK_DEV_IDE=n
 	help
 	  There are two drivers for MFM/RLL/IDE hard disks. Most people use
 	  the newer enhanced driver, but this old one is still around for two
@@ -1124,12 +1105,16 @@ config BLK_DEV_HD_ONLY
 	  for systems with only older MFM/RLL/ESDI drives. Choosing the old
 	  driver can save 13 KB or so of kernel memory.
 
+	  If you want to use this driver together with the new one you have
+	  to use "ide0=noprobe" kernel parameter to prevent the new driver
+	  from probing the primary interface.
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
@@ -179,10 +179,6 @@ static void init_hwif_default(ide_hwif_t
 	memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
 
 	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
-#ifdef CONFIG_BLK_DEV_HD
-	if (hwif->io_ports[IDE_DATA_OFFSET] == HD_DATA)
-		hwif->noprobe = 1;	/* may be overridden by ide_setup() */
-#endif
 }
 
 /*
