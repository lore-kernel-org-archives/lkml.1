Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab0CBX4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:56:41 -0500
Received: from kroah.org ([198.145.64.141]:38537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0CBX3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by default
Date: Tue,  2 Mar 2010 15:28:18 -0800
Message-Id: <1267572541-410-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

All major distros enable devtmpfs on recent systems, so remove
the EXPERIMENTAL flag, and enable it by default to reflect how it
is used today.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |   45 ++++++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index ee37727..8497ce9 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -9,29 +9,40 @@ config UEVENT_HELPER_PATH
 	  every uevent.
 
 config DEVTMPFS
-	bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
+	bool "Maintain a devtmpfs filesystem to mount at /dev"
 	depends on HOTPLUG && SHMEM && TMPFS
+	default y
 	help
-	  This creates a tmpfs filesystem, and mounts it at bootup
-	  and mounts it at /dev. The kernel driver core creates device
-	  nodes for all registered devices in that filesystem. All device
-	  nodes are owned by root and have the default mode of 0600.
-	  Userspace can add and delete the nodes as needed. This is
-	  intended to simplify bootup, and make it possible to delay
-	  the initial coldplug at bootup done by udev in userspace.
-	  It should also provide a simpler way for rescue systems
-	  to bring up a kernel with dynamic major/minor numbers.
-	  Meaningful symlinks, permissions and device ownership must
-	  still be handled by userspace.
-	  If unsure, say N here.
+	  This creates a tmpfs filesystem instance early at bootup.
+	  In this filesystem, the kernel driver core maintains device
+	  nodes with their default names and permissions for all
+	  registered devices with an assigned major/minor number.
+	  Userspace can modify the filesystem content as needed, add
+	  symlinks, and apply needed permissions.
+	  It provides a fully functional /dev directory, where usually
+	  udev runs on top, managing permissions and adding meaningful
+	  symlinks.
+	  In very limited environments, it may provide a sufficient
+	  functional /dev without any further help. It also allows simple
+	  rescue systems, and reliably handles dynamic major/minor numbers.
+	  If unsure, say Y here.
 
 config DEVTMPFS_MOUNT
-	bool "Automount devtmpfs at /dev"
+	bool "Automount devtmpfs at /dev, after the kernel mounted the rootfs"
 	depends on DEVTMPFS
+	default y
 	help
-	  This will mount devtmpfs at /dev if the kernel mounts the root
-	  filesystem. It will not affect initramfs based mounting.
-	  If unsure, say N here.
+	  This will instruct the kernel to automatically mount the
+	  devtmpfs filesystem at /dev, directly after the kernel has
+	  mounted the root filesystem. The behavior can be overridden
+	  with the commandline parameter: devtmpfs.mount=0|1.
+	  This option does not affect initramfs based booting, here
+	  the devtmpfs filesystem always needs to be mounted manually
+	  after the roots is mounted.
+	  With this option enabled, it allows to bring up a system in
+	  rescue mode with init=/bin/sh, even when the /dev directory
+	  on the rootfs is completely empty.
+	  If unsure, say Y here.
 
 config STANDALONE
 	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
-- 
1.7.0.1

