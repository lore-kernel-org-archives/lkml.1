Return-Path: <linux-kernel-owner+w=401wt.eu-S932282Ab0ANVsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0ANVsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221Ab0ANVsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:48:06 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59994 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0ANVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:48:05 -0500
Subject: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 22:47:57 +0100
Message-ID: <1263505677.2074.2.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by default

All major distros enable devtmpfs on recent systems, so remove
the EXPERIMENTAL flag, and enable it by default to reflect how it
is used today.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/Kconfig |   45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

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
+	bool "Automount devtmpfs at /dev, after the kernel mouted the rootfs"
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
+	  the devtmpfs filesystem always needs to be mouted manually
+	  after the roots is mounted.
+	  With this option enabled, it allows to bring up a system in
+	  rescue mode with init=/bin/sh, even when the /dev directory
+	  on the rootfs is completely empty.
+	  If unsure, say Y here.
 
 config STANDALONE
 	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL


