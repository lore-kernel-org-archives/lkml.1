Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYBJX4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYBJX4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYBJX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:56:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYBJX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:56:06 -0500
Date: Sun, 10 Feb 2008 15:55:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH] make /dev/kmem a config option
Message-ID: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] make /dev/kmem a config option
From: Arjan van de Ven <arjan@linux.intel.com>

This patch makes /dev/kmem a config option; /dev/kmem is VERY rarely
used, and when used, it's generally for no good (rootkits tend to be
the most common users). With this config option, users have the
choice to disable /dev/kmem, saving some size as well.

A patch to disable /dev/kmem has been in the Fedora and RHEL kernels for
4+ years now without any known problems or legit users of /dev/kmem.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/char/Kconfig |    8 ++++++++
 drivers/char/mem.c   |   12 ++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4666295..7716af0 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -80,6 +80,14 @@ config VT_HW_CONSOLE_BINDING
 	 information. For framebuffer console users, please refer to
 	 <file:Documentation/fb/fbcon.txt>.
 
+config DEV_KMEM
+	bool "/dev/kmem virtual device support"
+	help
+	  Say Y here if you want to support the /dev/kmem device. The
+	  /dev/kmem device is rarely used, but can be used for certain
+	  kind of kernel debugging operations.
+	  When in doubt, say "N".
+
 config SERIAL_NONSTANDARD
 	bool "Non-standard serial port support"
 	depends on HAS_IOMEM
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 3745e6b..49c5fac 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -323,6 +323,7 @@ static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 	return 0;
 }
 
+#ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
 {
 	unsigned long pfn;
@@ -343,6 +344,7 @@ static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
+#endif
 
 #ifdef CONFIG_CRASH_DUMP
 /*
@@ -381,6 +383,7 @@ static ssize_t read_oldmem(struct file *file, char __user *buf,
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
 
+#ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
@@ -585,6 +588,11 @@ static ssize_t write_kmem(struct file * file, const char __user * buf,
  	*ppos = p;
  	return virtr + wrote;
 }
+#else
+#define read_kmem NULL
+#define write_kmem NULL
+#define mmap_kmem NULL
+#endif
 
 #ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file * file, char __user * buf,
@@ -848,11 +856,13 @@ static int memory_open(struct inode * inode, struct file * filp)
 			filp->f_mapping->backing_dev_info =
 				&directly_mappable_cdev_bdi;
 			break;
+#ifdef CONFIG_DEVKMEM
 		case 2:
 			filp->f_op = &kmem_fops;
 			filp->f_mapping->backing_dev_info =
 				&directly_mappable_cdev_bdi;
 			break;
+#endif
 		case 3:
 			filp->f_op = &null_fops;
 			break;
@@ -901,7 +911,9 @@ static const struct {
 	const struct file_operations	*fops;
 } devlist[] = { /* list of minor devices */
 	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops},
+#ifdef CONFIG_DEVKMEM
 	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops},
+#endif
 	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops},
 #ifdef CONFIG_DEVPORT
 	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops},
-- 
1.5.3.4



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
