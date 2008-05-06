Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbYEFI7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbYEFI7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761063AbYEFIvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:51:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:45213 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbYEFIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:50:26 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 2 28/28] UBIFS: include FS to compilation
Date: Tue,  6 May 2008 13:35:59 +0300
Message-Id: <1210070159-22794-29-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 06 May 2008 08:50:22.0448 (UTC) FILETIME=[382B7700:01C8AF56]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UBIFS to Makefile and Kbuild.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/Kconfig             |    3 +++
 fs/Makefile            |    1 +
 fs/ubifs/Kconfig       |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/Kconfig.debug |   30 ++++++++++++++++++++++++++++++
 fs/ubifs/Makefile      |    9 +++++++++
 5 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index c509123..292251d 100644
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
index 0000000..1f23642
--- /dev/null
+++ b/fs/ubifs/Kconfig.debug
@@ -0,0 +1,30 @@
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
+config UBIFS_FS_DEBUG_MSG_LVL
+	int "Default message level (0 = no extra messages, 3 = lots)"
+	depends on UBIFS_FS_DEBUG
+	default "0"
+	help
+	  This controls the amount of debugging messages produced by UBIFS.
+	  If reporting bugs, please try to have available a full dump of the
+	  messages at level 1 while the misbehaviour was occurring. Level 2
+	  may become necessary if level 1 messages were not enough to find the
+	  bug. Generally Level 3 should be avoided.
+
+config UBIFS_FS_DEBUG_CHKS
+	bool "Enable extra checks"
+	depends on UBIFS_FS_DEBUG
+	help
+	  If extra checks are enabled UBIFS will check the consistency of its
+	  internal data structures during operation. However, UBIFS performance
+	  is dramatically slower when this option is selected especially if the
+	  file system is large.
diff --git a/fs/ubifs/Makefile b/fs/ubifs/Makefile
new file mode 100644
index 0000000..f616bd7
--- /dev/null
+++ b/fs/ubifs/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_UBIFS_FS) += ubifs.o
+
+ubifs-y += shrinker.o journal.o build.o file.o dir.o super.o sb.o io.o
+ubifs-y += tnc.o master.o scan.o replay.o log.o commit.o gc.o orphan.o
+ubifs-y += budget.o find.o tnc_commit.o compress.o lpt.o lprops.o
+ubifs-y += recovery.o ioctl.o lpt_commit.o tnc_misc.o
+
+ubifs-$(CONFIG_UBIFS_FS_DEBUG) += debug.o
+ubifs-$(CONFIG_UBIFS_FS_XATTR) += xattr.o
-- 
1.5.4.1

