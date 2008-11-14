Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYKNB2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYKNB2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbYKNBXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:23:07 -0500
Received: from cobra.newdream.net ([66.33.216.30]:38158 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbYKNBVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:35 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 19/19] ceph: Kconfig, Makefile
Date: Thu, 13 Nov 2008 16:56:18 -0800
Message-Id: <1226624178-3761-20-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1226624178-3761-19-git-send-email-sage@newdream.net>
References: <1226624178-3761-1-git-send-email-sage@newdream.net>
 <1226624178-3761-2-git-send-email-sage@newdream.net>
 <1226624178-3761-3-git-send-email-sage@newdream.net>
 <1226624178-3761-4-git-send-email-sage@newdream.net>
 <1226624178-3761-5-git-send-email-sage@newdream.net>
 <1226624178-3761-6-git-send-email-sage@newdream.net>
 <1226624178-3761-7-git-send-email-sage@newdream.net>
 <1226624178-3761-8-git-send-email-sage@newdream.net>
 <1226624178-3761-9-git-send-email-sage@newdream.net>
 <1226624178-3761-10-git-send-email-sage@newdream.net>
 <1226624178-3761-11-git-send-email-sage@newdream.net>
 <1226624178-3761-12-git-send-email-sage@newdream.net>
 <1226624178-3761-13-git-send-email-sage@newdream.net>
 <1226624178-3761-14-git-send-email-sage@newdream.net>
 <1226624178-3761-15-git-send-email-sage@newdream.net>
 <1226624178-3761-16-git-send-email-sage@newdream.net>
 <1226624178-3761-17-git-send-email-sage@newdream.net>
 <1226624178-3761-18-git-send-email-sage@newdream.net>
 <1226624178-3761-19-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig options and Makefile.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/Kconfig       |   20 ++++++++++++++++++++
 fs/Makefile      |    1 +
 fs/ceph/Makefile |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index abccb5d..c5d61b8 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1803,6 +1803,26 @@ config RPCSEC_GSS_SPKM3
 
 	  If unsure, say N.
 
+config CEPH_FS
+        tristate "Ceph distributed file system (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
+	select LIBCRC32C
+	help
+	  Choose Y or M here to include support for mounting the
+	  experimental Ceph distributed file system.  Ceph is an extremely
+	  scalable file system designed to provide high performance,
+	  reliable access to petabytes of storage.
+
+	  More information at http://ceph.newdream.net/.
+
+	  If unsure, say N.
+
+config CEPH_BOOKKEEPER
+	bool "Ceph leaks detection tool"
+	depends on CEPH_FS
+	help
+	  Leaks detection tool for the Ceph fs.
+
 config SMB_FS
 	tristate "SMB file system support (OBSOLETE, please use CIFS)"
 	depends on INET
diff --git a/fs/Makefile b/fs/Makefile
index a1482a5..549e129 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -122,3 +122,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_CEPH_FS)           += ceph/
diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
new file mode 100644
index 0000000..7926eec
--- /dev/null
+++ b/fs/ceph/Makefile
@@ -0,0 +1,35 @@
+#
+# Makefile for CEPH filesystem.
+#
+
+ifneq ($(KERNELRELEASE),)
+
+obj-$(CONFIG_CEPH_FS) += ceph.o
+
+ceph-objs := super.o inode.o dir.o file.o addr.o ioctl.o \
+	export.o caps.o snap.o \
+	messenger.o \
+	mds_client.o mdsmap.o \
+	mon_client.o \
+	osd_client.o osdmap.o crush/crush.o crush/mapper.o \
+	proc.o ceph_tools.o
+
+else
+#Otherwise we were called directly from the command
+# line; invoke the kernel build system.
+
+KERNELDIR ?= /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+
+default: all
+
+all:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_FS=m modules
+
+modules_install:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_FS=m modules_install
+
+clean:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
+
+endif
-- 
1.5.6.5

