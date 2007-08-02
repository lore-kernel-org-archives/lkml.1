Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbXHBKSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbXHBKSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXHBKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:17:53 -0400
Received: from ns.suse.de ([195.135.220.2]:51711 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXHBKRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:17:52 -0400
Date: Thu, 2 Aug 2007 12:17:50 +0200
From: Jan Blunck <jblunck@suse.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/26] VFS based Union Mount (V2)
Message-ID: <20070802101750.GV5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <20070802064943.GB24152@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <20070802064943.GB24152@in.ibm.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 02, Bharata B Rao wrote:

> On Mon, Jul 30, 2007 at 06:13:23PM +0200, Jan Blunck wrote:
> > Here is another post of the VFS based union mount implementation. Unlike the
> > traditional mount which hides the contents of the mount point, union mounts
> > present the merged view of the mount point and the mounted filesytem.
> 
> Doesn't compile without CONFIG_DEBUG_UNION_MOUNT.
> 
> fs/namei.c: In function `hash_lookup_union':
> fs/namei.c:1798: error: implicit declaration of function `UM_DEBUG_LOOKUP'
> make[1]: *** [fs/namei.o] Error 1

Umm, typo in the debug infrastruture patch. Here is the fixed version.

Thanks,
Jan

--L6iaP+gRLNZHKoI4
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="union-mount-debug-infrastructure.diff"

Subject: union-mount: Debug Infrastructure

This adds debugfs/relay based debugging infrastructure helpful when doing
development of the union-mount code itself. The debgging output can be enabled
during runtime by:

 echo 1 > /proc/sys/fs/union-debug

This registers the relayfs files where the debug code is writing its output
to. There are different levels of debugging output available which can be ORed
together. For the valid sysctl values see include/linux/union_debug.h.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/linux/union_debug.h |   91 ++++++++++++++
 lib/Kconfig.debug           |    9 +
 lib/Makefile                |    2 
 lib/union_debug.c           |  268 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 370 insertions(+)

--- /dev/null
+++ b/include/linux/union_debug.h
@@ -0,0 +1,91 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef __LINUX_UNION_DEBUG_H
+#define __LINUX_UNION_DEBUG_H
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_DEBUG_UNION_MOUNT
+
+#include <linux/sched.h>
+
+/* This is taken from klog debugging facility */
+extern void klog(const void *data, int len);
+extern void klog_printk(const char *fmt, ...);
+extern void klog_printk_dentry(const char *func, struct dentry *dentry);
+
+extern int sysctl_union_debug;
+
+#define UNION_MOUNT_DEBUG		1
+#define UNION_MOUNT_DEBUG_DCACHE	2
+#define UNION_MOUNT_DEBUG_LOCK		4
+#define UNION_MOUNT_DEBUG_READDIR	8
+#define UNION_MOUNT_DEBUG_LOOKUP	16
+
+#define UM_DEBUG(fmt, args...)						\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG)			\
+		klog_printk("%s: " fmt, __FUNCTION__, ## args);		\
+} while (0)
+#define UM_DEBUG_DENTRY(dentry)						\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG)			\
+		klog_printk_dentry(__FUNCTION__, (dentry));		\
+} while (0)
+#define UM_DEBUG_DCACHE(fmt, args...)					\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG_DCACHE)		\
+		klog_printk("%s: " fmt, __FUNCTION__, ## args);		\
+} while (0)
+#define UM_DEBUG_DCACHE_DENTRY(dentry)					\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG_DCACHE)		\
+		klog_printk_dentry(__FUNCTION__, (dentry));		\
+} while (0)
+#define UM_DEBUG_LOCK(fmt, args...)					\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG_LOCK)		\
+		klog_printk("%s: " fmt, __FUNCTION__, ## args);		\
+} while (0)
+#define UM_DEBUG_READDIR(fmt, args...)					\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG_READDIR)		\
+		klog_printk("%s: " fmt, __FUNCTION__, ## args);		\
+} while (0)
+#define UM_DEBUG_LOOKUP(fmt, args...)					\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG_LOOKUP)		\
+		klog_printk("%s: " fmt, __FUNCTION__, ## args);		\
+} while (0)
+#define UM_DEBUG_LOOKUP_DENTRY(dentry)					\
+do {									\
+	if (sysctl_union_debug & UNION_MOUNT_DEBUG_LOOKUP)		\
+		klog_printk_dentry(__FUNCTION__, (dentry));		\
+} while (0)
+
+#else	/* CONFIG_DEBUG_UNION_MOUNT */
+
+#define UM_DEBUG(fmt, args...)			do { /* empty */ } while (0)
+#define UM_DEBUG_DENTRY(fmt, args...)		do { /* empty */ } while (0)
+#define UM_DEBUG_DCACHE(fmt, args...)		do { /* empty */ } while (0)
+#define UM_DEBUG_DCACHE_DENTRY(fmt, args...)	do { /* empty */ } while (0)
+#define UM_DEBUG_LOCK(fmt, args...)		do { /* empty */ } while (0)
+#define UM_DEBUG_READDIR(fmt, args...)		do { /* empty */ } while (0)
+#define UM_DEBUG_LOOKUP(fmt, args...)		do { /* empty */ } while (0)
+#define UM_DEBUG_LOOKUP_DENTRY(fmt, args...)	do { /* empty */ } while (0)
+
+#endif	/* CONFIG_DEBUG_UNION_MOUNT */
+
+#endif	/* __KERNEL__ */
+#endif	/*  __LINUX_UNION_DEBUG_H */
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -393,6 +393,15 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_UNION_MOUNT
+	bool "Debug VFS based union mounts"
+	depends on DEBUG_KERNEL && UNION_MOUNT
+	select DEBUG_FS
+	default n
+	help
+	  If you say Y here, the union mount debugging code will be
+	  compiled in.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN)
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -35,6 +35,8 @@ obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 
+obj-$(CONFIG_DEBUG_UNION_MOUNT) += union_debug.o
+
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
 endif
--- /dev/null
+++ b/lib/union_debug.c
@@ -0,0 +1,268 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2007 SUSE Linux
+ *   Author(s): Jan Blunck (jblunck@suse.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/sysctl.h>
+#include <linux/init.h>
+#include <linux/relay.h>
+#include <linux/debugfs.h>
+
+int sysctl_union_debug;
+EXPORT_SYMBOL_GPL(sysctl_union_debug);
+
+static struct rchan *debug_rchan;
+static struct dentry *debug_logdir;
+#define SUBBUF_SIZE 262144
+#define N_SUBBUF 4
+
+static struct dentry *create_buf_file(const char *filename,
+				      struct dentry *parent, int mode,
+				      struct rchan_buf *buf, int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static int remove_buf_file(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+static int subbuf_start(struct rchan_buf *buf, void *subbuf, void *prev_subbuf,
+			unsigned int prev_padding)
+{
+	return 1;
+}
+
+static struct rchan_callbacks debug_relay_cb = {
+	.create_buf_file = create_buf_file,
+	.remove_buf_file = remove_buf_file,
+	.subbuf_start = subbuf_start,
+};
+
+static int union_debug_relay_init(void)
+{
+	struct dentry *dentry;
+	struct rchan *rchan;
+
+	if (!debug_logdir) {
+		dentry = debugfs_create_dir("union", NULL);
+		if (IS_ERR(dentry)) {
+			printk(KERN_INFO
+			       "%s: debugfs directory creation failed\n",
+			       __FUNCTION__);
+			return PTR_ERR(dentry);
+		}
+
+		debug_logdir = dentry;
+	}
+
+	if (!debug_rchan) {
+		rchan = relay_open("logfile", debug_logdir,
+				   SUBBUF_SIZE, N_SUBBUF,
+				   &debug_relay_cb, NULL);
+		if (!rchan) {
+			printk(KERN_INFO "%s: relay channel creation failed\n",
+			       __FUNCTION__);
+			debugfs_remove(debug_logdir);
+			return -ENOMEM;
+		}
+
+		debug_rchan = rchan;
+	}
+
+	return 0;
+}
+
+static void union_debug_relay_exit(void)
+{
+	if (debug_rchan)
+		relay_close(debug_rchan);
+	debug_rchan = NULL;
+	if (debug_logdir)
+		debugfs_remove(debug_logdir);
+	debug_logdir = NULL;
+}
+
+/*
+ * klog operations
+ */
+struct klog_operations
+{
+	/*
+	 * klog - called when klog called, same params
+	 */
+	void (*klog) (const void *data, int len);
+};
+
+/* maximum size of klog formatting buffer beyond which truncation will occur */
+#define KLOG_TMPBUF_SIZE (1024)
+/* per-cpu klog formatting temporary buffer */
+static char klog_buf[NR_CPUS][KLOG_TMPBUF_SIZE];
+
+/*
+ * do-nothing default klog handler, called if nothing registered
+ */
+static void default_klog(const void *data, int len)
+{
+}
+
+/*
+ * default klog operations, used if nothing registered
+ */
+static struct klog_operations default_klog_ops =
+{
+	.klog = default_klog,
+};
+
+static struct klog_operations *cur_klog_ops = &default_klog_ops;
+
+/**
+ *      register_klog_handler - register klog handler
+ *      @klog_ops: klog operations callbacks
+ *
+ *      replaces default klog handler with passed-in version
+ */
+int register_klog_handler(struct klog_operations *klog_ops)
+{
+	if (!klog_ops)
+		return -EINVAL;
+
+	if (!klog_ops->klog)
+		klog_ops->klog = default_klog;
+
+	cur_klog_ops = klog_ops;
+	return 0;
+}
+
+/**
+ *      unregister_klog_handler - unregister klog handler
+ *
+ *      default handler will be in effect after this
+ */
+void unregister_klog_handler(void)
+{
+	cur_klog_ops = &default_klog_ops;
+}
+
+/**
+ *      klog - send raw data to klog handler
+ */
+void klog(const void *data, int len)
+{
+	cur_klog_ops->klog(data, len);
+}
+
+/**
+ *      klog_printk - send a formatted string to the klog handler
+ *      @fmt: format string, same as printk
+ */
+void klog_printk(const char *fmt, ...)
+{
+	va_list args;
+	int len;
+	char *cbuf;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cbuf = klog_buf[smp_processor_id()];
+	va_start(args, fmt);
+	len = vsnprintf(cbuf, KLOG_TMPBUF_SIZE, fmt, args);
+	va_end(args);
+	klog(cbuf, len);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(klog_printk);
+
+void klog_printk_dentry(const char *func, struct dentry *dentry)
+{
+	klog_printk("%s: %p{i=%p/%lx,c=%d,n=\"%s\"}\n",
+		    func,
+		    dentry,
+		    dentry->d_inode,
+		    dentry->d_inode ?
+		    dentry->d_inode->i_ino : 0UL,
+		    atomic_read(&dentry->d_count),
+		    dentry->d_name.name);
+}
+EXPORT_SYMBOL_GPL(klog_printk_dentry);
+
+static void log_data(const void *data, int len)
+{
+	relay_write(debug_rchan, data, len);
+}
+
+static struct klog_operations klog_handler =
+{
+	.klog = log_data,
+};
+
+static int union_debug_sysctl_handler(ctl_table *table, int write,
+				      struct file *file,
+				      void __user *buffer, size_t *length,
+				      loff_t *ppos)
+{
+	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
+
+	if (!write)
+		return 0;
+
+	printk(KERN_INFO "sysctl.fs.union-debug: %d\n", sysctl_union_debug);
+
+	switch (sysctl_union_debug) {
+	case 0:
+		unregister_klog_handler();
+		union_debug_relay_exit();
+		break;
+	default:
+		union_debug_relay_init();
+		if (register_klog_handler(&klog_handler))
+			union_debug_relay_exit();
+		break;
+	}
+
+	return 0;
+}
+
+static ctl_table union_table[] = {
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "union-debug",
+		.data = &sysctl_union_debug,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &union_debug_sysctl_handler,
+	},
+	{.ctl_name = 0}
+};
+
+static ctl_table fs_root[] = {
+	{
+		.ctl_name = CTL_FS,
+		.procname = "fs",
+		.maxlen = 0,
+		.mode = 0555,
+		.child = union_table,
+	},
+	{.ctl_name = 0}
+};
+
+static struct ctl_table_header *sysctl_header;
+
+static int union_debug_init(void)
+{
+	sysctl_header = register_sysctl_table(fs_root);
+	return 0;
+}
+
+late_initcall(union_debug_init);

--L6iaP+gRLNZHKoI4--
