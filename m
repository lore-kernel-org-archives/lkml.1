Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYBKBF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYBKBF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 20:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbYBKBFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 20:05:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34816 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYBKBFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 20:05:46 -0500
Date: Sun, 10 Feb 2008 17:05:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [PATCH] make /dev/kmem a config option
Message-ID: <20080210170509.36999240@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
References: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
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

On Mon, 11 Feb 2008 01:13:09 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Feb 10 2008 15:55, Arjan van de Ven wrote:
> >+#ifdef CONFIG_DEVKMEM
> > /*
> >  * This function reads the *virtual* memory as seen by the kernel.
> >  */
> >@@ -585,6 +588,11 @@ static ssize_t write_kmem(struct file * file,
> >const char __user * buf,
> >  	*ppos = p;
> >  	return virtr + wrote;
> > }
> >+#else
> >+#define read_kmem NULL
> >+#define write_kmem NULL
> >+#define mmap_kmem NULL
> >+#endif
> 
> Is the #else case needed? All kmem_fops uses seem #ifdef'ed out
> anyway, except kmem_fops itself. In other words,
> 
> +#ifdef CONFIG_DEVKMEM
>  static const struct file_operations kmem_fops = {
>  ...
>  }
> +#endif
> 
> and do away with the three defines. No? :)

yup you're right; updated patch below

---

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
 drivers/char/mem.c   |   10 ++++++++++
 2 files changed, 18 insertions(+)

Index: linux.trees.git/drivers/char/Kconfig
===================================================================
--- linux.trees.git.orig/drivers/char/Kconfig
+++ linux.trees.git/drivers/char/Kconfig
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
Index: linux.trees.git/drivers/char/mem.c
===================================================================
--- linux.trees.git.orig/drivers/char/mem.c
+++ linux.trees.git/drivers/char/mem.c
@@ -295,6 +295,7 @@ static int mmap_mem(struct file * file, 
 	return 0;
 }
 
+#ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
 {
 	unsigned long pfn;
@@ -315,6 +316,7 @@ static int mmap_kmem(struct file * file,
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
+#endif
 
 #ifdef CONFIG_CRASH_DUMP
 /*
@@ -353,6 +355,7 @@ static ssize_t read_oldmem(struct file *
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
 
+#ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
@@ -557,6 +560,7 @@ static ssize_t write_kmem(struct file * 
  	*ppos = p;
  	return virtr + wrote;
 }
+#endif
 
 #ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file * file, char __user * buf,
@@ -734,6 +738,7 @@ static const struct file_operations mem_
 	.get_unmapped_area = get_unmapped_area_mem,
 };
 
+#ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_kmem,
@@ -742,6 +747,7 @@ static const struct file_operations kmem
 	.open		= open_kmem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
+#endif
 
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
@@ -820,11 +826,13 @@ static int memory_open(struct inode * in
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
@@ -873,7 +881,9 @@ static const struct {
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
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
