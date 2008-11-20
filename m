Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYKTOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYKTOsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbYKTOnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:43:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbYKTOmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:42:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/45] FS-Cache: Add use of /proc and presentation of
	statistics [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:42:36 +0000
Message-ID: <20081120144236.10667.83390.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make FS-Cache create its /proc interface and present various statistical
information through it.  Also provide the functions for updating this
information.

These features are enabled by:

	CONFIG_FSCACHE_PROC
	CONFIG_FSCACHE_STATS
	CONFIG_FSCACHE_HISTOGRAM

The /proc directory for FS-Cache is also exported so that caching modules can
add their own statistics there too.

The FS-Cache module is loadable at this point, and the statistics files can be
examined by userspace:

	cat /proc/fs/fscache/stats
	cat /proc/fs/fscache/histogram

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/Kconfig        |   27 +++
 fs/fscache/Makefile       |    4 
 fs/fscache/fsc-internal.h |  117 ++++++++++++++
 fs/fscache/fsc-main.c     |    7 +
 fs/fscache/fsc-proc.c     |  370 +++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/fsc-stats.c    |  104 +++++++++++++
 6 files changed, 628 insertions(+), 1 deletions(-)
 create mode 100644 fs/fscache/fsc-proc.c
 create mode 100644 fs/fscache/fsc-stats.c


diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index 7c7bccd..b9ff04a 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -11,6 +11,33 @@ config FSCACHE
 
 	  See Documentation/filesystems/caching/fscache.txt for more information.
 
+config FSCACHE_PROC
+	bool "Provide /proc interface for local caching statistics"
+	depends on FSCACHE && PROC_FS
+
+config FSCACHE_STATS
+	bool "Gather statistical information on local caching"
+	depends on FSCACHE_PROC
+	help
+	  This option causes statistical information to be gathered on local
+	  caching and exported through file:
+
+		/proc/fs/fscache/stats
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_HISTOGRAM
+	bool "Gather latency information on local caching"
+	depends on FSCACHE_PROC
+	help
+
+	  This option causes latency information to be gathered on local
+	  caching and exported through file:
+
+		/proc/fs/fscache/histogram
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
 config FSCACHE_DEBUG
 	bool "Debug FS-Cache"
 	depends on FSCACHE
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 7f15726..ba55ab1 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -3,6 +3,8 @@
 #
 
 fscache-y := \
-	fsc-main.o
+	fsc-main.o \
+	fsc-proc.o \
+	fsc-stats.o
 
 obj-$(CONFIG_FSCACHE) := fscache.o
diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
index fd60aed..4ada505 100644
--- a/fs/fscache/fsc-internal.h
+++ b/fs/fscache/fsc-internal.h
@@ -35,6 +35,123 @@ extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
 
+/*
+ * fsc-stats.c
+ */
+#ifdef CONFIG_FSCACHE_STATS
+extern atomic_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];
+extern atomic_t fscache_n_objs_processed[FSCACHE_MAX_THREADS];
+
+extern atomic_t fscache_n_op_pend;
+extern atomic_t fscache_n_op_run;
+extern atomic_t fscache_n_op_enqueue;
+extern atomic_t fscache_n_op_deferred_release;
+extern atomic_t fscache_n_op_release;
+extern atomic_t fscache_n_op_gc;
+
+extern atomic_t fscache_n_attr_changed;
+extern atomic_t fscache_n_attr_changed_ok;
+extern atomic_t fscache_n_attr_changed_nobufs;
+extern atomic_t fscache_n_attr_changed_nomem;
+extern atomic_t fscache_n_attr_changed_calls;
+
+extern atomic_t fscache_n_allocs;
+extern atomic_t fscache_n_allocs_ok;
+extern atomic_t fscache_n_allocs_wait;
+extern atomic_t fscache_n_allocs_nobufs;
+extern atomic_t fscache_n_alloc_ops;
+extern atomic_t fscache_n_alloc_op_waits;
+
+extern atomic_t fscache_n_retrievals;
+extern atomic_t fscache_n_retrievals_ok;
+extern atomic_t fscache_n_retrievals_wait;
+extern atomic_t fscache_n_retrievals_nodata;
+extern atomic_t fscache_n_retrievals_nobufs;
+extern atomic_t fscache_n_retrievals_intr;
+extern atomic_t fscache_n_retrievals_nomem;
+extern atomic_t fscache_n_retrieval_ops;
+extern atomic_t fscache_n_retrieval_op_waits;
+
+extern atomic_t fscache_n_stores;
+extern atomic_t fscache_n_stores_ok;
+extern atomic_t fscache_n_stores_again;
+extern atomic_t fscache_n_stores_nobufs;
+extern atomic_t fscache_n_stores_oom;
+extern atomic_t fscache_n_store_ops;
+extern atomic_t fscache_n_store_calls;
+
+extern atomic_t fscache_n_marks;
+extern atomic_t fscache_n_uncaches;
+
+extern atomic_t fscache_n_acquires;
+extern atomic_t fscache_n_acquires_null;
+extern atomic_t fscache_n_acquires_no_cache;
+extern atomic_t fscache_n_acquires_ok;
+extern atomic_t fscache_n_acquires_nobufs;
+extern atomic_t fscache_n_acquires_oom;
+
+extern atomic_t fscache_n_updates;
+extern atomic_t fscache_n_updates_null;
+extern atomic_t fscache_n_updates_run;
+
+extern atomic_t fscache_n_relinquishes;
+extern atomic_t fscache_n_relinquishes_null;
+extern atomic_t fscache_n_relinquishes_waitcrt;
+
+extern atomic_t fscache_n_cookie_index;
+extern atomic_t fscache_n_cookie_data;
+extern atomic_t fscache_n_cookie_special;
+
+extern atomic_t fscache_n_object_alloc;
+extern atomic_t fscache_n_object_no_alloc;
+extern atomic_t fscache_n_object_lookups;
+extern atomic_t fscache_n_object_lookups_negative;
+extern atomic_t fscache_n_object_lookups_positive;
+extern atomic_t fscache_n_object_created;
+extern atomic_t fscache_n_object_avail;
+extern atomic_t fscache_n_object_dead;
+
+extern atomic_t fscache_n_checkaux_none;
+extern atomic_t fscache_n_checkaux_okay;
+extern atomic_t fscache_n_checkaux_update;
+extern atomic_t fscache_n_checkaux_obsolete;
+
+static inline void fscache_stat(atomic_t *stat)
+{
+	atomic_inc(stat);
+}
+#else
+
+#define fscache_stat(stat) do {} while (0)
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+extern atomic_t fscache_obj_instantiate_histogram[HZ];
+extern atomic_t fscache_objs_histogram[HZ];
+extern atomic_t fscache_ops_histogram[HZ];
+extern atomic_t fscache_retrieval_delay_histogram[HZ];
+extern atomic_t fscache_retrieval_histogram[HZ];
+
+static inline void fscache_hist(atomic_t histogram[], unsigned long start_jif)
+{
+	unsigned long jif = jiffies - start_jif;
+	if (jif >= HZ)
+		jif = HZ - 1;
+	atomic_inc(&histogram[jif]);
+}
+
+#else
+#define fscache_hist(hist, start_jif) do {} while (0)
+#endif
+
+#ifdef CONFIG_FSCACHE_PROC
+extern int __init fscache_proc_init(void);
+extern void fscache_proc_cleanup(void);
+#else
+#define fscache_proc_init()	(0)
+#define fscache_proc_cleanup()	do {} while (0)
+#endif
+
 /*****************************************************************************/
 /*
  * debug tracing
diff --git a/fs/fscache/fsc-main.c b/fs/fscache/fsc-main.c
index 2dd0e21..1819e9d 100644
--- a/fs/fscache/fsc-main.c
+++ b/fs/fscache/fsc-main.c
@@ -52,9 +52,15 @@ static int __init fscache_init(void)
 	if (ret < 0)
 		goto error_slow_work;
 
+	ret = fscache_proc_init();
+	if (ret < 0)
+		goto error_proc;
+
 	printk(KERN_NOTICE "FS-Cache: Loaded\n");
 	return 0;
 
+error_proc:
+	slow_work_unregister_user();
 error_slow_work:
 	return ret;
 }
@@ -68,6 +74,7 @@ static void __exit fscache_exit(void)
 {
 	_enter("");
 
+	fscache_proc_cleanup();
 	slow_work_unregister_user();
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
diff --git a/fs/fscache/fsc-proc.c b/fs/fscache/fsc-proc.c
new file mode 100644
index 0000000..dd6daa5
--- /dev/null
+++ b/fs/fscache/fsc-proc.c
@@ -0,0 +1,370 @@
+/* FS-Cache statistics viewing interface
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL OPERATION
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "fsc-internal.h"
+
+struct fscache_proc {
+	unsigned			nlines;
+	const struct seq_operations	*ops;
+};
+
+struct proc_dir_entry *proc_fscache;
+EXPORT_SYMBOL(proc_fscache);
+
+#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
+static int fscache_proc_open(struct inode *inode, struct file *file);
+static void *fscache_proc_start(struct seq_file *m, loff_t *pos);
+static void fscache_proc_stop(struct seq_file *m, void *v);
+static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos);
+
+static const struct file_operations fscache_proc_fops = {
+	.open		= fscache_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+#endif
+
+#ifdef CONFIG_FSCACHE_STATS
+static int fscache_stats_show(struct seq_file *m, void *v);
+
+static const struct seq_operations fscache_stats_ops = {
+	.start		= fscache_proc_start,
+	.stop		= fscache_proc_stop,
+	.next		= fscache_proc_next,
+	.show		= fscache_stats_show,
+};
+
+static const struct fscache_proc fscache_stats = {
+	.nlines		= 17,
+	.ops		= &fscache_stats_ops,
+};
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+static int fscache_histogram_show(struct seq_file *m, void *v);
+
+static const struct seq_operations fscache_histogram_ops = {
+	.start		= fscache_proc_start,
+	.stop		= fscache_proc_stop,
+	.next		= fscache_proc_next,
+	.show		= fscache_histogram_show,
+};
+
+static const struct fscache_proc fscache_histogram = {
+	.nlines		= HZ + 1,
+	.ops		= &fscache_histogram_ops,
+};
+#endif
+
+#define FSC_DESC(SELECT, N) ((void *) (unsigned long) (((SELECT) << 16) | (N)))
+
+/*
+ * initialise the /proc/fs/fscache/ directory
+ */
+int __init fscache_proc_init(void)
+{
+#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
+	struct proc_dir_entry *p;
+#endif
+
+	_enter("");
+
+	proc_fscache = proc_mkdir("fs/fscache", NULL);
+	if (!proc_fscache)
+		goto error_dir;
+	proc_fscache->owner = THIS_MODULE;
+
+#ifdef CONFIG_FSCACHE_STATS
+	p = create_proc_entry("stats", 0, proc_fscache);
+	if (!p)
+		goto error_stats;
+	p->proc_fops = &fscache_proc_fops;
+	p->owner = THIS_MODULE;
+	p->data = (void *) &fscache_stats;
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+	p = create_proc_entry("histogram", 0, proc_fscache);
+	if (!p)
+		goto error_histogram;
+	p->proc_fops = &fscache_proc_fops;
+	p->owner = THIS_MODULE;
+	p->data = (void *) &fscache_histogram;
+#endif
+
+	_leave(" = 0");
+	return 0;
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+error_histogram:
+#endif
+#ifdef CONFIG_FSCACHE_STATS
+	remove_proc_entry("stats", proc_fscache);
+error_stats:
+#endif
+	remove_proc_entry("fs/fscache", NULL);
+error_dir:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+
+/*
+ * clean up the /proc/fs/fscache/ directory
+ */
+void fscache_proc_cleanup(void)
+{
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+	remove_proc_entry("histogram", proc_fscache);
+#endif
+#ifdef CONFIG_FSCACHE_STATS
+	remove_proc_entry("stats", proc_fscache);
+#endif
+	remove_proc_entry("fs/fscache", NULL);
+}
+
+#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
+/*
+ * open "/proc/fs/fscache/XXX" which provide statistics summaries
+ */
+static int fscache_proc_open(struct inode *inode, struct file *file)
+{
+	const struct fscache_proc *proc = PDE(inode)->data;
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, proc->ops);
+	if (ret == 0) {
+		m = file->private_data;
+		m->private = (void *) proc;
+	}
+	return ret;
+}
+
+/*
+ * set up the iterator to start reading from the first line
+ */
+static void *fscache_proc_start(struct seq_file *m, loff_t *_pos)
+{
+	if (*_pos == 0)
+		*_pos = 1;
+	return (void *)(unsigned long) *_pos;
+}
+
+/*
+ * move to the next line
+ */
+static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	const struct fscache_proc *proc = m->private;
+
+	(*pos)++;
+	return *pos > proc->nlines ? NULL : (void *)(unsigned long) *pos;
+}
+
+/*
+ * clean up after reading
+ */
+static void fscache_proc_stop(struct seq_file *m, void *v)
+{
+}
+#endif
+
+#ifdef CONFIG_FSCACHE_STATS
+/*
+ * display the general statistics
+ */
+static int fscache_stats_show(struct seq_file *m, void *v)
+{
+	unsigned long line = (unsigned long) v;
+
+	switch (line) {
+	case 1:
+		seq_puts(m, "FS-Cache statistics\n");
+		break;
+
+	case 2:
+		seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
+			   atomic_read(&fscache_n_cookie_index),
+			   atomic_read(&fscache_n_cookie_data),
+			   atomic_read(&fscache_n_cookie_special));
+		break;
+
+	case 3:
+		seq_printf(m, "Objects: alc=%u nal=%u avl=%u ded=%u\n",
+			   atomic_read(&fscache_n_object_alloc),
+			   atomic_read(&fscache_n_object_no_alloc),
+			   atomic_read(&fscache_n_object_avail),
+			   atomic_read(&fscache_n_object_dead));
+		break;
+
+	case 4:
+		seq_printf(m, "ChkAux : non=%u ok=%u upd=%u obs=%u\n",
+			   atomic_read(&fscache_n_checkaux_none),
+			   atomic_read(&fscache_n_checkaux_okay),
+			   atomic_read(&fscache_n_checkaux_update),
+			   atomic_read(&fscache_n_checkaux_obsolete));
+		break;
+
+	case 5:
+		seq_printf(m, "Pages  : mrk=%u unc=%u\n",
+			   atomic_read(&fscache_n_marks),
+			   atomic_read(&fscache_n_uncaches));
+		break;
+
+	case 6:
+		seq_printf(m, "Acquire: n=%u nul=%u noc=%u ok=%u nbf=%u"
+			   " oom=%u\n",
+			   atomic_read(&fscache_n_acquires),
+			   atomic_read(&fscache_n_acquires_null),
+			   atomic_read(&fscache_n_acquires_no_cache),
+			   atomic_read(&fscache_n_acquires_ok),
+			   atomic_read(&fscache_n_acquires_nobufs),
+			   atomic_read(&fscache_n_acquires_oom));
+		break;
+
+	case 7:
+		seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u\n",
+			   atomic_read(&fscache_n_object_lookups),
+			   atomic_read(&fscache_n_object_lookups_negative),
+			   atomic_read(&fscache_n_object_lookups_positive),
+			   atomic_read(&fscache_n_object_created));
+		break;
+
+	case 8:
+		seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
+			   atomic_read(&fscache_n_updates),
+			   atomic_read(&fscache_n_updates_null),
+			   atomic_read(&fscache_n_updates_run));
+		break;
+
+	case 9:
+		seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u\n",
+			   atomic_read(&fscache_n_relinquishes),
+			   atomic_read(&fscache_n_relinquishes_null),
+			   atomic_read(&fscache_n_relinquishes_waitcrt));
+		break;
+
+	case 10:
+		seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
+			   atomic_read(&fscache_n_attr_changed),
+			   atomic_read(&fscache_n_attr_changed_ok),
+			   atomic_read(&fscache_n_attr_changed_nobufs),
+			   atomic_read(&fscache_n_attr_changed_nomem),
+			   atomic_read(&fscache_n_attr_changed_calls));
+		break;
+
+	case 11:
+		seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u\n",
+			   atomic_read(&fscache_n_allocs),
+			   atomic_read(&fscache_n_allocs_ok),
+			   atomic_read(&fscache_n_allocs_wait),
+			   atomic_read(&fscache_n_allocs_nobufs));
+		break;
+	case 12:
+		seq_printf(m, "Allocs : ops=%u owt=%u\n",
+			   atomic_read(&fscache_n_alloc_ops),
+			   atomic_read(&fscache_n_alloc_op_waits));
+		break;
+
+	case 13:
+		seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
+			   " int=%u oom=%u\n",
+			   atomic_read(&fscache_n_retrievals),
+			   atomic_read(&fscache_n_retrievals_ok),
+			   atomic_read(&fscache_n_retrievals_wait),
+			   atomic_read(&fscache_n_retrievals_nodata),
+			   atomic_read(&fscache_n_retrievals_nobufs),
+			   atomic_read(&fscache_n_retrievals_intr),
+			   atomic_read(&fscache_n_retrievals_nomem));
+		break;
+	case 14:
+		seq_printf(m, "Retrvls: ops=%u owt=%u\n",
+			   atomic_read(&fscache_n_retrieval_ops),
+			   atomic_read(&fscache_n_retrieval_op_waits));
+		break;
+
+	case 15:
+		seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
+			   atomic_read(&fscache_n_stores),
+			   atomic_read(&fscache_n_stores_ok),
+			   atomic_read(&fscache_n_stores_again),
+			   atomic_read(&fscache_n_stores_nobufs),
+			   atomic_read(&fscache_n_stores_oom));
+		break;
+	case 16:
+		seq_printf(m, "Stores : ops=%u run=%u\n",
+			   atomic_read(&fscache_n_store_ops),
+			   atomic_read(&fscache_n_store_calls));
+		break;
+
+	case 17:
+		seq_printf(m, "Ops    : pend=%u run=%u enq=%u\n",
+			   atomic_read(&fscache_n_op_pend),
+			   atomic_read(&fscache_n_op_run),
+			   atomic_read(&fscache_n_op_enqueue));
+		break;
+
+	case 18:
+		seq_printf(m, "Ops    : dfr=%u rel=%u gc=%u\n",
+			   atomic_read(&fscache_n_op_deferred_release),
+			   atomic_read(&fscache_n_op_release),
+			   atomic_read(&fscache_n_op_gc));
+		break;
+
+	default:
+		break;
+	}
+	return 0;
+}
+
+#endif /* end CONFIG_FSCACHE_STATS */
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+/*
+ * display the time-taken histogram
+ */
+static int fscache_histogram_show(struct seq_file *m, void *v)
+{
+	unsigned long index;
+	unsigned n[5], t;
+
+	switch ((unsigned long) v) {
+	case 1:
+		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS "
+			 " RETRV DLY RETRIEVLS\n");
+		return 0;
+	case 2:
+		seq_puts(m, "===== ===== ========= ========= ========="
+			 " ========= =========\n");
+		return 0;
+	default:
+		index = (unsigned long) v - 3;
+		n[0] = atomic_read(&fscache_obj_instantiate_histogram[index]);
+		n[1] = atomic_read(&fscache_ops_histogram[index]);
+		n[2] = atomic_read(&fscache_objs_histogram[index]);
+		n[3] = atomic_read(&fscache_retrieval_delay_histogram[index]);
+		n[4] = atomic_read(&fscache_retrieval_histogram[index]);
+		if (!(n[0] | n[1] | n[2] | n[3] | n[4]))
+			return 0;
+
+		t = (index * 1000) / HZ;
+
+		seq_printf(m, "%4lu  0.%03u %9u %9u %9u %9u %9u\n",
+			   index, t, n[0], n[1], n[2], n[3], n[4]);
+		return 0;
+	}
+}
+#endif /* end CONFIG_FSCACHE_HISTOGRAM */
diff --git a/fs/fscache/fsc-stats.c b/fs/fscache/fsc-stats.c
new file mode 100644
index 0000000..8762d43
--- /dev/null
+++ b/fs/fscache/fsc-stats.c
@@ -0,0 +1,104 @@
+/* FS-Cache statistics
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL THREAD
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "fsc-internal.h"
+
+/*
+ * operation counters
+ */
+#ifdef CONFIG_FSCACHE_STATS
+atomic_t fscache_n_op_pend;
+atomic_t fscache_n_op_run;
+atomic_t fscache_n_op_enqueue;
+atomic_t fscache_n_op_requeue;
+atomic_t fscache_n_op_deferred_release;
+atomic_t fscache_n_op_release;
+atomic_t fscache_n_op_gc;
+
+atomic_t fscache_n_attr_changed;
+atomic_t fscache_n_attr_changed_ok;
+atomic_t fscache_n_attr_changed_nobufs;
+atomic_t fscache_n_attr_changed_nomem;
+atomic_t fscache_n_attr_changed_calls;
+
+atomic_t fscache_n_allocs;
+atomic_t fscache_n_allocs_ok;
+atomic_t fscache_n_allocs_wait;
+atomic_t fscache_n_allocs_nobufs;
+atomic_t fscache_n_alloc_ops;
+atomic_t fscache_n_alloc_op_waits;
+
+atomic_t fscache_n_retrievals;
+atomic_t fscache_n_retrievals_ok;
+atomic_t fscache_n_retrievals_wait;
+atomic_t fscache_n_retrievals_nodata;
+atomic_t fscache_n_retrievals_nobufs;
+atomic_t fscache_n_retrievals_intr;
+atomic_t fscache_n_retrievals_nomem;
+atomic_t fscache_n_retrieval_ops;
+atomic_t fscache_n_retrieval_op_waits;
+
+atomic_t fscache_n_stores;
+atomic_t fscache_n_stores_ok;
+atomic_t fscache_n_stores_again;
+atomic_t fscache_n_stores_nobufs;
+atomic_t fscache_n_stores_oom;
+atomic_t fscache_n_store_ops;
+atomic_t fscache_n_store_calls;
+
+atomic_t fscache_n_marks;
+atomic_t fscache_n_uncaches;
+
+atomic_t fscache_n_acquires;
+atomic_t fscache_n_acquires_null;
+atomic_t fscache_n_acquires_no_cache;
+atomic_t fscache_n_acquires_ok;
+atomic_t fscache_n_acquires_nobufs;
+atomic_t fscache_n_acquires_oom;
+
+atomic_t fscache_n_updates;
+atomic_t fscache_n_updates_null;
+atomic_t fscache_n_updates_run;
+
+atomic_t fscache_n_relinquishes;
+atomic_t fscache_n_relinquishes_null;
+atomic_t fscache_n_relinquishes_waitcrt;
+
+atomic_t fscache_n_cookie_index;
+atomic_t fscache_n_cookie_data;
+atomic_t fscache_n_cookie_special;
+
+atomic_t fscache_n_object_alloc;
+atomic_t fscache_n_object_no_alloc;
+atomic_t fscache_n_object_lookups;
+atomic_t fscache_n_object_lookups_negative;
+atomic_t fscache_n_object_lookups_positive;
+atomic_t fscache_n_object_created;
+atomic_t fscache_n_object_avail;
+atomic_t fscache_n_object_dead;
+
+atomic_t fscache_n_checkaux_none;
+atomic_t fscache_n_checkaux_okay;
+atomic_t fscache_n_checkaux_update;
+atomic_t fscache_n_checkaux_obsolete;
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+atomic_t fscache_obj_instantiate_histogram[HZ];
+atomic_t fscache_objs_histogram[HZ];
+atomic_t fscache_ops_histogram[HZ];
+atomic_t fscache_retrieval_delay_histogram[HZ];
+atomic_t fscache_retrieval_histogram[HZ];
+#endif

