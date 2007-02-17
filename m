Return-Path: <linux-kernel-owner+w=401wt.eu-S2992709AbXBQRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992709AbXBQRFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992587AbXBQRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:01:25 -0500
Received: from smtp.nokia.com ([131.228.20.173]:33820 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992573AbXBQRBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:19 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:54:29 +0200
Message-Id: <20070217165429.5845.13221.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/44 take 2] [UBI] Linux build integration
X-OriginalArrivalTime: 17 Feb 2007 16:54:29.0174 (UTC) FILETIME=[49F51D60:01C752B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/Kconfig tmp-to/drivers/mtd/Kconfig
--- tmp-from/drivers/mtd/Kconfig	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/drivers/mtd/Kconfig	2007-02-17 18:07:26.000000000 +0200
@@ -292,5 +292,7 @@ source "drivers/mtd/nand/Kconfig"
 
 source "drivers/mtd/onenand/Kconfig"
 
+source "drivers/mtd/ubi/Kconfig"
+
 endmenu
 
diff -auNrp tmp-from/drivers/mtd/Makefile tmp-to/drivers/mtd/Makefile
--- tmp-from/drivers/mtd/Makefile	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/drivers/mtd/Makefile	2007-02-17 18:07:26.000000000 +0200
@@ -28,3 +28,5 @@ nftl-objs		:= nftlcore.o nftlmount.o
 inftl-objs		:= inftlcore.o inftlmount.o
 
 obj-y		+= chips/ maps/ devices/ nand/ onenand/
+
+obj-$(CONFIG_MTD_UBI)		+= ubi/
diff -auNrp tmp-from/drivers/mtd/ubi/Kconfig tmp-to/drivers/mtd/ubi/Kconfig
--- tmp-from/drivers/mtd/ubi/Kconfig	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/Kconfig	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,71 @@
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
+config MTD_UBI_USERSPACE_IO
+	bool "UBI user-space write/erase"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  By default, users cannot directly write and erase individual
+	  eraseblocks of dynamic volumes, and have to use update operation.
+	  This option enables this capability. Disabling this feature is more
+	  robust because it discourage users from using tools like 'dd' to copy
+	  their images to UBI volumes. Do not enable if unsure.
+
+# There are a lot of debugging options, so they are moved to a distinct file
+source "drivers/mtd/ubi/Kconfig.debug"
+
+endmenu
diff -auNrp tmp-from/drivers/mtd/ubi/Kconfig.debug tmp-to/drivers/mtd/ubi/Kconfig.debug
--- tmp-from/drivers/mtd/ubi/Kconfig.debug	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/Kconfig.debug	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,218 @@
+# UBI debugging configuration options, part of drivers/mtd/ubi/Kconfig
+
+comment "UBI debugging options"
+	depends on MTD_UBI
+
+config MTD_UBI_DEBUG
+	bool "UBI debugging"
+	default n
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
+config MTD_UBI_DEBUG_MSG_VB_ERR
+	bool "Verbose errors reporting"
+	depends on MTD_UBI_DEBUG
+	default y
+	help
+	  This option enables verbose reporting about errors occurred in UBI.
+
+config MTD_UBI_DEBUG_MSG_UIF
+	bool "User interface unit messages"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables debugging messages from the UBI user interfaces
+	  unit.
+
+config MTD_UBI_DEBUG_MSG_CDEV
+	bool "Messages from the character device sub-unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables debugging messages from the UBI character device
+	  handling sub-unit of the user interfaces unit.
+
+config MTD_UBI_DEBUG_MSG_GLUEBI
+	bool "Messages from the gluebi sub-unit"
+	depends on MTD_UBI_DEBUG
+	depends on MTD_UBI_GLUEBI
+	default n
+	help
+	  This option enables debugging messages from the gluebi (MTD devices
+	  emulation) sub-unit of the user interfaces unit.
+
+config MTD_UBI_DEBUG_MSG_VMT
+	bool "Volume management unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI volume management
+	  unit.
+
+config MTD_UBI_DEBUG_MSG_UPD
+	bool "Update unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI update unit.
+
+config MTD_UBI_DEBUG_MSG_VTBL
+	bool "Volume table unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI volume table
+	  unit.
+
+config MTD_UBI_DEBUG_MSG_ACC
+	bool "Accounting unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI accountig unit.
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
+config MTD_UBI_DEBUG_MSG_BGT
+	bool "Background thread unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI background thread
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
+	bool "Build unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI build unit.
+
+config MTD_UBI_DEBUG_MSG_SCAN
+	bool "Scanning unit messages"
+	default n
+	depends on MTD_UBI_DEBUG
+	help
+	  This option enables debugging messages from the UBI scanning unit.
+
+endmenu # UBI debugging messages
+
+menu "UBI paranoid checks"
+	depends on MTD_UBI_DEBUG
+
+config MTD_UBI_DEBUG_PARANOID_VMT
+	bool "Paranoid checks in the volume management unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the volume management unit.
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
+config MTD_UBI_DEBUG_PARANOID_ALLOC
+	bool "Paranoid checks in the memory allocation unit"
+	depends on MTD_UBI_DEBUG
+	default n
+	help
+	  This option enables extra self-checks in the memory allocation unit.
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
+++ tmp-to/drivers/mtd/ubi/Makefile	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,7 @@
+obj-$(CONFIG_MTD_UBI) += ubi.o
+
+ubi-y += badeb.o upd.o sysfs.o cdev.o uif.o vtbl.o volmgmt.o eba.o io.o wl.o
+ubi-y += scan.o build.o background.o alloc.o init.o account.o misc.o
+
+ubi-$(CONFIG_MTD_UBI_DEBUG) += debug.o
+ubi-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
diff -auNrp tmp-from/include/mtd/Kbuild tmp-to/include/mtd/Kbuild
--- tmp-from/include/mtd/Kbuild	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/include/mtd/Kbuild	2007-02-17 18:07:26.000000000 +0200
@@ -3,3 +3,5 @@ header-y += jffs2-user.h
 header-y += mtd-abi.h
 header-y += mtd-user.h
 header-y += nftl-user.h
+header-y += ubi-header.h
+header-y += ubi-user.h
