Return-Path: <linux-kernel-owner+w=401wt.eu-S1761843AbXFAOUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761843AbXFAOUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbXFAOUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:20:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:38001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252AbXFAOUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:20:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,373,1175497200"; 
   d="scan'208";a="249784980"
Message-ID: <46602B2D.7070902@intel.com>
Date: Fri, 01 Jun 2007 18:20:29 +0400
From: akorolev <alexey.korolev@intel.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH] SPI FLASH naming conflicts solving
References: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com> <20070317064637.GA14739@1wt.eu> <45FEC94F.8090006@intel.com>
In-Reply-To: <45FEC94F.8090006@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2007 14:20:29.0337 (UTC) FILETIME=[018BE090:01C7A458]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dawid

I tried to enable SPI flash device in our development platform (Mainstone).
Since the platform driver uses NOR flash device - it includes 
"include/asm-arm/mach/flash.h" file where the structure "flhash_platform 
_data" is defined.
The structure with the same name "flhash_platform _data" is also defined 
in "include/linux/spi/flash.h".
These structures are different - so they cause compile errors.

I attached the fix for this issue. IMHO it's more preferable to resolve 
issue by minor modification of SPI driver than touching all arm platform 
drivers.

=============================
diff -aur orig/drivers/mtd/devices/m25p80.c new/drivers/mtd/devices/m25p80.c
--- orig/drivers/mtd/devices/m25p80.c	2007-06-01 19:06:52.000000000 +0400
+++ new/drivers/mtd/devices/m25p80.c	2007-05-10 16:56:15.000000000 +0400
@@ -423,7 +449,7 @@
  */
 static int __devinit m25p_probe(struct spi_device *spi)
 {
-	struct flash_platform_data	*data;
+	struct spi_flash_platform_data	*data;
 	struct m25p			*flash;
 	struct flash_info		*info;
 	unsigned			i;
diff -aur orig/drivers/mtd/devices/mtd_dataflash.c new/drivers/mtd/devices/mtd_dataflash.c
--- orig/drivers/mtd/devices/mtd_dataflash.c	2007-06-01 19:06:48.000000000 +0400
+++ new/drivers/mtd/devices/mtd_dataflash.c	2007-05-10 14:41:39.000000000 +0400
@@ -457,7 +457,7 @@
 {
 	struct dataflash		*priv;
 	struct mtd_info			*device;
-	struct flash_platform_data	*pdata = spi->dev.platform_data;
+	struct spi_flash_platform_data	*pdata = spi->dev.platform_data;
 
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
=============================
Could you please take a look at this. The fix is simple. If you don't complain could you please include it. 

Thanks,
Alexey

P/S Also I have a question:
I faced rather strange problem with sending read and write commands  to 
SPI  flash. It works Ok if I reverse 32bit SPI FLASH command
I mean - read/write/erase works if to substitute
    flash->command[0] = OPCODE_SE;
    flash->command[1] = offset >> 16;
    flash->command[2] = offset >> 8;
    flash->command[3] = offset;
for
    flash->command[3] = OPCODE_SE;
    flash->command[2] = offset >> 16;
    flash->command[1] = offset >> 8;
    flash->command[0] = offset;
in file drivers/mtd/devices/m25p80.c

It seems pretty strange and may require more investigation.
I wonder If you have any ideas why it could happen? If anybody tested 
m25p80.c driver on LittleEndian platforms?
