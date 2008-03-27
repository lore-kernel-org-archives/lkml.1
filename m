Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYC0NRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYC0NRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbYC0NJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:09:17 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49953 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254AbYC0NJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:09:15 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [RFC PATCH 26/26] UBIFS: include FS to compilation
Date: Thu, 27 Mar 2008 16:55:46 +0200
Message-Id: <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 27 Mar 2008 13:06:56.0263 (UTC) FILETIME=[6F133970:01C8900B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UBIFS to Makefile and Kbuild.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/Kconfig             |    3 +
 fs/Makefile            |    1 +
 fs/ubifs/Kconfig       |   47 ++++++++++++++
 fs/ubifs/Kconfig.debug |  159 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/Makefile      |    9 +++
 5 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..70edf5c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1347,6 +1347,9 @@ config JFFS2_CMODE_FAVOURLZO
 
 endchoice
 
+# UBIFS File system configuration
+source "fs/ubifs/Kconfig"
+
 config CRAMFS
 	tristate "Compressed ROM file system support (cramfs)"
 	depends on BLOCK
diff --git a/fs/Makefile b/fs/Makefile
index 1e7a11b..fcae06a 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
+obj-$(CONFIG_UBIFS_FS)		+= ubifs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
new file mode 100644
index 0000000..21a6fae
--- /dev/null
+++ b/fs/ubifs/Kconfig
@@ -0,0 +1,47 @@
+config UBIFS_FS
+	tristate "UBIFS file system support"
+	select CRC16
+	select CRC32
+	depends on MTD_UBI
+	help
+	  UBIFS is a file system for flash devices which works on top of UBI.
+
+config UBIFS_FS_XATTR
+	bool "Extended attributes support"
+	depends on UBIFS_FS
+	default n
+	help
+	  This option enables support of extended attributes.
+
+config UBIFS_FS_ADVANCED_COMPR
+	bool "Advanced compression options"
+	depends on UBIFS_FS
+	default n
+	help
+	  This option allows to explicitly choose which compressions, if any,
+	  are enabled in UBIFS. Removing compressors means inbility to read
+	  existing file systems.
+
+	  If unsure, say 'N'.
+
+config UBIFS_FS_LZO
+	bool "LZO compression support" if UBIFS_FS_ADVANCED_COMPR
+	select CRYPTO
+	select CRYPTO_LZO
+	depends on UBIFS_FS
+	default y
+	help
+	   LZO compressor is generally faster then zlib but compresses worse.
+	   Say 'Y' if unsure.
+
+config UBIFS_FS_ZLIB
+	bool "ZLIB compression support" if UBIFS_FS_ADVANCED_COMPR
+	select CRYPTO
+	select CRYPTO_DEFLATE
+	depends on UBIFS_FS
+	default y
+	help
+	  Zlib copresses better then LZO but it is slower. Say 'Y' if unsure.
+
+# Debugging-related stuff
+source "fs/ubifs/Kconfig.debug"
diff --git a/fs/ubifs/Kconfig.debug b/fs/ubifs/Kconfig.debug
new file mode 100644
index 0000000..4bfccef
--- /dev/null
+++ b/fs/ubifs/Kconfig.debug
@@ -0,0 +1,159 @@
+# UBIFS debugging configuration options, part of fs/ubifs/Kconfig
+
+config UBIFS_FS_DEBUG
+	bool "Enable debugging"
+	default n
+	depends on UBIFS_FS
+	select DEBUG_FS
+	select KALLSYMS_ALL
+	help
+	  This option enables UBIFS debugging.
+
+menu "Debugging messages"
+	depends on UBIFS_FS_DEBUG
+
+config UBIFS_FS_DEBUG_MSG_GEN
+	bool "General messages"
+	default n
+	help
+	  This option enables general debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_JRN
+	bool "Journal messages"
+	default n
+	help
+	  This option enables detailed journal debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_CMT
+	bool "Commit messages"
+	default n
+	help
+	  This option enables detailed journal commit debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_BUDG
+	bool "Budgeting messages"
+	default n
+	help
+	  This option enables detailed budgeting debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_LOG
+	bool "Log messages"
+	default n
+	help
+	  This option enables detailed journal log debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_TNC
+	bool "Tree Node Cache (TNC) messages"
+	default n
+	help
+	  This option enables detailed TNC debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_LP
+	bool "LEB properties (lprops) messages"
+	default n
+	help
+	  This option enables detailed lprops debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_FIND
+	bool "LEB search messages"
+	default n
+	help
+	  This option enables detailed LEB search debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_MNT
+	bool "Mount messages"
+	default n
+	help
+	  This option enables detailed mount debugging messages, including
+	  recovery messages.
+
+config UBIFS_FS_DEBUG_MSG_IO
+	bool "Input/output messages"
+	default n
+	help
+	  This option enables detailed I/O debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_GC
+	bool "Garbage collection messages"
+	default n
+	help
+	  This option enables detailed garbage collection debugging messages.
+
+config UBIFS_FS_DEBUG_MSG_SCAN
+	bool "Scan messages"
+	default n
+	help
+	  This option enables detailed scan debugging messages.
+
+endmenu
+
+menu "Extra self-checks"
+	depends on UBIFS_FS_DEBUG
+
+config UBIFS_FS_DEBUG_CHK_MEMPRESS
+	bool "Create memory pressure"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option causes kernel memory pressure in order to make TNC shrinker
+	  run.
+
+config UBIFS_FS_DEBUG_CHK_LPROPS
+	bool "Check LEB properties (lprops)"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option enables a function which runs during journal commit and
+	  checks that the dirty and free space is correct for every LEB.
+
+config UBIFS_FS_DEBUG_CHK_TNC
+	bool "Check Tree Node Cache (TNC)"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option enables a function which runs after every
+	  TNC insert / delete and checks that the TNC nodes are correct.
+
+config UBIFS_FS_DEBUG_CHK_ORPH
+	bool "Check orphan area"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option enables a function which runs during journal commit and
+	  checks that the orphan area is correct.
+
+config UBIFS_FS_DEBUG_CHK_IDX_SZ
+	bool "Check indexing tree size"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option enables checking of the znode size accounting variables.
+
+config UBIFS_FS_DEBUG_CHK_OLD_IDX
+	bool "Check old indexing tree"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option enables checking of the old indexing tree which must be
+	  intact to allow recovery in the event of an unclean unmount.
+
+config UBIFS_FS_DEBUG_CHK_OTHER
+	bool "Other checks"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option enables different checks which are light-weight and do not
+	  affect file-system performance too much.
+
+endmenu
+
+config UBIFS_FS_DEBUG_TEST_RCVRY
+	bool "Simulate random device removal (recovery testing)"
+	default n
+	depends on UBIFS_FS_DEBUG
+	help
+	  This option provides the ability to test recovery from unclean
+	  unmounts. It causes UBIFS to simulate device removal.  At a some
+	  random point UBIFS will switch to "failure mode" after which all I/O
+	  operations will fail. UBIFS can then be unmounted and mounted again
+	  at which point "failure mode" is switched off and recovery ensues.
diff --git a/fs/ubifs/Makefile b/fs/ubifs/Makefile
new file mode 100644
index 0000000..6b84f0f
--- /dev/null
+++ b/fs/ubifs/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_UBIFS_FS) += ubifs.o
+
+ubifs-y += shrinker.o journal.o build.o file.o dir.o super.o sb.o io.o
+ubifs-y += tnc.o master.o scan.o replay.o log.o commit.o gc.o orphan.o
+ubifs-y += budget.o find.o tnc_commit.o compress.o lpt.o lprops.o
+ubifs-y += recovery.o ioctl.o lpt_commit.o
+
+ubifs-$(CONFIG_UBIFS_FS_DEBUG) += debug.o
+ubifs-$(CONFIG_UBIFS_FS_XATTR) += xattr.o
-- 
1.5.4.1

