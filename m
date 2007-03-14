Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbXCNPXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbXCNPXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXCNPWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:22:40 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23722 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925AbXCNPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:21:36 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:21:25 +0200
Message-Id: <20070314152125.1112.94096.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 22/22 take 3] UBI: Linux build integration
X-OriginalArrivalTime: 14 Mar 2007 15:21:25.0020 (UTC) FILETIME=[6DDE95C0:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/Kconfig tmp-to/drivers/mtd/Kconfig
--- tmp-from/drivers/mtd/Kconfig	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/drivers/mtd/Kconfig	2007-03-14 17:15:49.000000000 +0200
@@ -292,5 +292,7 @@ source "drivers/mtd/nand/Kconfig"
 
 source "drivers/mtd/onenand/Kconfig"
 
+source "drivers/mtd/ubi/Kconfig"
+
 endmenu
 
diff -auNrp tmp-from/drivers/mtd/Makefile tmp-to/drivers/mtd/Makefile
--- tmp-from/drivers/mtd/Makefile	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/drivers/mtd/Makefile	2007-03-14 17:15:49.000000000 +0200
@@ -28,3 +28,5 @@ nftl-objs		:= nftlcore.o nftlmount.o
 inftl-objs		:= inftlcore.o inftlmount.o
 
 obj-y		+= chips/ maps/ devices/ nand/ onenand/
+
+obj-$(CONFIG_MTD_UBI)		+= ubi/
diff -auNrp tmp-from/drivers/mtd/ubi/Kconfig tmp-to/drivers/mtd/ubi/Kconfig
--- tmp-from/drivers/mtd/ubi/Kconfig	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/Kconfig	2007-03-14 17:15:49.000000000 +0200
@@ -0,0 +1,60 @@
+# drivers/mtd/ubi/Kconfig
+
+menu "UBI - Unsorted block images"
+	depends on MTD
+
+config MTD_UBI
+	tristate "Enable UBI"
+	depends on MTD
+	select CRC32
+	help
+	  UBI is a software layer above MTD layer which admits of LVM-like
+	  logical volumes on top of MTD devices, hides some complexities of
+	  flash chips like wear and bad blocks and provides some other useful
+	  capabilities. Please, consult the MTD web site for more details
+	  (www.linux-mtd.infradead.org).
+
+config MTD_UBI_WL_THRESHOLD
+	int "UBI wear-leveling threshold"
+	default 4096
+	range 2 65536
+	depends on MTD_UBI
+	help
+	  This parameter defines the maximum difference between the highest
+	  erase counter value and the lowest erase counter value of eraseblocks
+	  of UBI devices. When this threshold is exceeded, UBI starts performing
+	  wear leveling by means of moving data from eraseblock with low erase
+	  counter to eraseblocks with high erase counter. Leave the default
+	  value if unsure.
+
+config MTD_UBI_BEB_RESERVE
+	int "Percentage of reserved eraseblocks for bad eraseblocks handling"
+	default 1
+	range 0 25
+	depends on MTD_UBI
+	help
+	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
+	  reserves some amount of physical eraseblocks to handle new bad
+	  eraseblocks. For example, if a flash physical eraseblock becomes bad,
+	  UBI uses these reserved physical eraseblocks to relocate the bad one.
+	  This option specifies how many physical eraseblocks will be reserved
+	  for bad eraseblock handling (percents of total number of good flash
+	  eraseblocks). If the underlying flash does not admit of bad
+	  eraseblocks (e.g. NOR flash), this value is ignored and nothing is
+	  reserved. Leave the default value if unsure.
+
+config MTD_UBI_GLUEBI
+	bool "Emulate MTD devices"
+	default n
+	depends on MTD_UBI
+	help
+	   This option enables MTD devices emulation on top of UBI volumes: for
+	   each UBI volumes an MTD device is created, and all I/O to this MTD
+	   device is redirected to the UBI volume. This is handy to make
+	   MTD-oriented software (like JFFS2) work on top of UBI. Do not enable
+	   this if no legacy software will be used.
+
+# There are a lot of debugging options, so they are moved to a distinct file
+source "drivers/mtd/ubi/Kconfig.debug"
+
+endmenu
diff -auNrp tmp-from/drivers/mtd/ubi/Kconfig.debug tmp-to/drivers/mtd/ubi/Kconfig.debug
--- tmp-from/drivers/mtd/ubi/Kconfig.debug	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/Kconfig.debug	2007-03-14 17:15:49.000000000 +0200
@@ -0,0 +1,153 @@
+# UBI debugging configuration options, part of drivers/mtd/ubi/Kconfig
+
+comment "UBI debugging options"
+	depends on MTD_UBI
+
+config MTD_UBI_DEBUG
+	bool "UBI debugging"
+	depends on SYSFS
+	depends on MTD_UBI
+	select DEBUG_FS
+	select KALLSYMS_ALL
+	help
+	  This enables UBI debugging support: enables various assertions in the
+	  code, verbose debugging messages and allows to switch many other
+	  debugging features on. UBI exposes its debugging stuff via the Linux
+	  debugfs virtual file-system under the "ubi" directory. Mount debugfs
+	  to access this stuff: mount -t debugfs none <mount_point>
+
+config MTD_UBI_DEBUG_DISABLE_BGT
+	bool "Do not enable the UBI background thread"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option switches the background thread off by default. The thread
+	  may be also be enabled/disabled via UBI sysfs.
+
+config MTD_UBI_DEBUG_USERSPACE_IO
+	bool "Direct user-space write/erase support"
+	default n
+	depends on MTD_UBI
+	help
+	  By default, users cannot directly write and erase individual
+	  eraseblocks of dynamic volumes, and have to use update operation
+	  instead. This option enables this capability - it is very useful for
+	  debugging and testing.
+
+config MTD_UBI_DEBUG_EMULATE_BITFLIPS
+	bool "Emulate flash bit-flips"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option emulates bit-flips with probability 1/50, which in turn
+	  causes scrubbing. Useful for debugging and stressing UBI.
+
+config MTD_UBI_DEBUG_EMULATE_WRITE_FAILURES
+	bool "Emulate flash write failures"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option emulates write failures with probability 1/100. Useful for
+	  debugging and testing how UBI handlines errors.
+
+config MTD_UBI_DEBUG_EMULATE_ERASE_FAILURES
+	bool "Emulate flash erase failures"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option emulates erase failures with probability 1/100. Useful for
+	  debugging and testing how UBI handlines errors.
+
+menu "UBI debugging messages"
+	depends on MTD_UBI_DEBUG
+
+config MTD_UBI_DEBUG_MSG_UIF
+	bool "User interface unit messages"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables debugging messages from the UBI user interfaces
+	  unit.
+
+config MTD_UBI_DEBUG_MSG_VTBL
+	bool "Volume table unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI volume table
+	  unit.
+
+config MTD_UBI_DEBUG_MSG_EBA
+	bool "Eraseblock association unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI eraseblock
+	  association unit.
+
+config MTD_UBI_DEBUG_MSG_WL
+	bool "Wear-leveling unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI wear-leveling
+	  unit.
+
+config MTD_UBI_DEBUG_MSG_IO
+	bool "Input/output unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI input/output unit.
+
+config MTD_UBI_DEBUG_MSG_BLD
+	bool "UBI build messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables UBI build debugging messages
+
+endmenu # UBI debugging messages
+
+menu "UBI paranoid checks"
+	depends on MTD_UBI_DEBUG
+
+config MTD_UBI_DEBUG_PARANOID_VTBL
+	bool "Paranoid checks in the volume table unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the volume table unit.
+
+config MTD_UBI_DEBUG_PARANOID_EBA
+	bool "Paranoid checks in the eraseblock association unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the eraseblock association
+	  unit.
+
+config MTD_UBI_DEBUG_PARANOID_WL
+	bool "Paranoid checks in the wear-leveling unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the wear-leveling unit.
+
+config MTD_UBI_DEBUG_PARANOID_IO
+	bool "Paranoid checks in the input/output unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the input/output unit.
+	  Warning, this is rather heavy-weight and will slow UBI down.
+
+config MTD_UBI_DEBUG_PARANOID_SCAN
+	bool "Paranoid checks in the scanning unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the scanning unit. Warning,
+	  this is rather heavy-weight and will slow UBI down.
+
+endmenu # UBI paranoid checks
diff -auNrp tmp-from/drivers/mtd/ubi/Makefile tmp-to/drivers/mtd/ubi/Makefile
--- tmp-from/drivers/mtd/ubi/Makefile	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/Makefile	2007-03-14 17:15:49.000000000 +0200
@@ -0,0 +1,7 @@
+obj-$(CONFIG_MTD_UBI) += ubi.o
+
+ubi-y += upd.o sysfs.o cdev.o uif.o vtbl.o vmt.o eba.o io.o wl.o scan.o build.o
+ubi-y += account.o misc.o
+
+ubi-$(CONFIG_MTD_UBI_DEBUG) += debug.o
+ubi-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
diff -auNrp tmp-from/include/mtd/Kbuild tmp-to/include/mtd/Kbuild
--- tmp-from/include/mtd/Kbuild	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/include/mtd/Kbuild	2007-03-14 17:15:49.000000000 +0200
@@ -3,3 +3,5 @@ header-y += jffs2-user.h
 header-y += mtd-abi.h
 header-y += mtd-user.h
 header-y += nftl-user.h
+header-y += ubi-header.h
+header-y += ubi-user.h
