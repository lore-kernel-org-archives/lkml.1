Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbXCEWKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbXCEWKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXCEWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:10:39 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:32828 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXCEWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:10:37 -0500
Message-ID: <1173132574.45ec951e4c014@imp.free.fr>
Date: Mon, 05 Mar 2007 23:09:34 +0100
From: dimitri.gorokhovik@free.fr
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jean-paul.saman@nxp.com
Subject: [PATCH] initramfs should not depend on CONFIG_BLOCK
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 87.88.35.208
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

initramfs ended up depending on BLOCK:

  INITRAMFS_SOURCE <-- BLK_DEV_INITRD <-- BLOCK

This inhibits use of customized-initramfs-over-ramfs without block layer
(ramfs would still be enabled), useful in embedded applications.

Move BLK_DEV_INITRD out of 'drivers/block/Kconfig' and into 'init/Kconfig',
make it unconditional.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>


--- linux-2.6.21-rc2-git4-broken/init/Kconfig	2007-03-05 23:20:27.000000000 +0100
+++ linux-2.6.21-rc2-git4-fixed/init/Kconfig	2007-03-05 22:22:48.000000000 +0100
@@ -304,6 +304,23 @@ config RELAY

 	  If unsure, say N.

+config BLK_DEV_INITRD
+	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
+	depends on BROKEN || !FRV
+	help
+	  The initial RAM filesystem is a ramfs which is loaded by the
+	  boot loader (loadlin or lilo) and that is mounted as root
+	  before the normal boot procedure. It is typically used to
+	  load modules needed to mount the "real" root file system,
+	  etc. See <file:Documentation/initrd.txt> for details.
+
+	  If RAM disk support (BLK_DEV_RAM) is also included, this
+	  also enables initial RAM disk (initrd) support and adds
+	  15 Kbytes (more on some other architectures) to the kernel size.
+
+	  If unsure say Y.
+
 if BLK_DEV_INITRD

 source "usr/Kconfig"
--- linux-2.6.21-rc2-git4-broken/drivers/block/Kconfig	2007-03-05 23:20:21.000000000 +0100
+++ linux-2.6.21-rc2-git4-fixed/drivers/block/Kconfig	2007-03-05 22:22:48.000000000 +0100
@@ -406,21 +406,6 @@ config BLK_DEV_RAM_BLOCKSIZE
 	  setups function - apparently needed by the rd_load_image routine
 	  that supposes the filesystem in the image uses a 1024 blocksize.

-config BLK_DEV_INITRD
-	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
-	depends on BROKEN || !FRV
-	help
-	  The initial RAM filesystem is a ramfs which is loaded by the
-	  boot loader (loadlin or lilo) and that is mounted as root
-	  before the normal boot procedure. It is typically used to
-	  load modules needed to mount the "real" root file system,
-	  etc. See <file:Documentation/initrd.txt> for details.
-
-	  If RAM disk support (BLK_DEV_RAM) is also included, this
-	  also enables initial RAM disk (initrd) support and adds
-	  15 Kbytes (more on some other architectures) to the kernel size.
-
-	  If unsure say Y.

 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
@@ -472,3 +457,5 @@ config ATA_OVER_ETH
 endmenu

 endif




