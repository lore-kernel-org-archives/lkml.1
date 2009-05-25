Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZEYVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZEYVsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZEYVsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:48:09 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:36445 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZEYVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Gfa7DmjvOZkq4C9fCjp64a1opHbAXmzVBMtbZWUIEDs7MAGvzFlaonnXQCK7EPzvqg
         D4+7nPqbXNimxxkm0U6cGznew3PP9X8yvdoTC0SCcDbNWvWlPcW7uxjIvGsdWUvtbvco
         yI8C4Wabbq7/9RhHrE22mqoiiGLASkpv851UM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Mon, 25 May 2009 23:44:11 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252344.11826.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "ignore_hpa" module parameter (modelled after corresponding
libata's parameter) to allow preserving of Host Protected Area.

While at it make some Documentation/kernel-parameters.txt fixes:
- remove stale "idebus=" entry
- s/ide-core/ide_core/g

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This patchset is for Linus' tree and is destined for 2.6.30-rc8.

 Documentation/kernel-parameters.txt |   10 +++++++---
 drivers/ide/ide-disk.c              |    3 +++
 drivers/ide/ide.c                   |    7 +++++++
 include/linux/ide.h                 |    1 +
 4 files changed, 18 insertions(+), 3 deletions(-)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -833,14 +833,18 @@ and is between 256 and 4096 characters. 
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
-	ide-core.nodma=	[HW] (E)IDE subsystem
+	ide_core.nodma=	[HW] (E)IDE subsystem
 			Format: =0.0 to prevent dma on hda, =0.1 hdb =1.0 hdc
 			.vlb_clock .pci_clock .noflush .noprobe .nowerr .cdrom
 			.chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
-	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
-			See Documentation/ide/ide.txt.
+	ide_core.ignore_hpa=
+			[HW] (E)IDE subsystem
+			Ignore HPA limit
+			Format: { "0" | "1" }
+			0 -- keep BIOS limits
+			1 -- ignore limits, using full disk (default)
 
 	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
 			Claim all unknown PCI IDE storage controllers.
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -330,6 +330,9 @@ static void idedisk_check_hpa(ide_drive_
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
+	if (ide_ignore_hpa == 0)
+		return;
+
 	set_max = idedisk_set_max_address(drive, set_max, lba48);
 
 	if (set_max) {
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -166,6 +166,13 @@ struct bus_type ide_bus_type = {
 
 EXPORT_SYMBOL_GPL(ide_bus_type);
 
+int ide_ignore_hpa = 1;
+EXPORT_SYMBOL_GPL(ide_ignore_hpa);
+
+module_param_named(ignore_hpa, ide_ignore_hpa, int, 0);
+MODULE_PARM_DESC(ignore_hpa,
+"Ignore HPA limit (0=keep BIOS limits, 1=ignore limits, using full disk)");
+
 int ide_vlb_clk;
 EXPORT_SYMBOL_GPL(ide_vlb_clk);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1072,6 +1072,7 @@ int ide_setting_ioctl(ide_drive_t *, str
 
 int generic_ide_ioctl(ide_drive_t *, struct block_device *, unsigned, unsigned long);
 
+extern int ide_ignore_hpa;
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
