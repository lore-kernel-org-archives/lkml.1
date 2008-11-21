Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYKUPcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYKUPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYKUPcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:32:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbYKUPc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:32:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121001539.GA5889@x200.localdomain>
References: <20081121001539.GA5889@x200.localdomain> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144236.10667.83390.stgit@warthog.procyon.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/45] FS-Cache: Add use of /proc and presentation of statistics [ver #41]
Date: Fri, 21 Nov 2008 15:32:16 +0000
Message-ID: <15505.1227281536@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> This is overly complex for unclear need. Just set_printf() all these lines
> and drop iterator business. Use single_open()! Ditto for histo stuff.

I disagree with respect to the histogram stuff.  The whole point of having
iterators is to iterate over a lot of things, and the histogram code may
generate several pages worth of data.

Anyway, I've sorted the stats and histogram code and documentation out for both
FS-Cache and CacheFiles and attached it here in one delta patch.  Could you
look it over and see what you think?  I'll merge it into the various patches
later.

David
---
diff --git a/Documentation/filesystems/caching/cachefiles.txt b/Documentation/filesystems/caching/cachefiles.txt
index ed5bb0c..c78a49b 100644
--- a/Documentation/filesystems/caching/cachefiles.txt
+++ b/Documentation/filesystems/caching/cachefiles.txt
@@ -22,6 +22,10 @@ Contents:
 
  (*) A note on security.
 
+ (*) Statistical information.
+
+ (*) Debugging.
+
 
 ========
 OVERVIEW
@@ -439,3 +443,59 @@ file.
 LSM hooks exist that allow SELinux (or Smack or whatever) to reject a request
 for CacheFiles to run in a context of a specific security label, or to create
 files and directories with another security label.
+
+
+=======================
+STATISTICAL INFORMATION
+=======================
+
+If FS-Cache is compiled with the following option enabled:
+
+	CONFIG_CACHEFILES_HISTOGRAM=y
+
+then it will gather certain statistics and display them through a proc file.
+
+ (*) /proc/fs/cachefiles/histogram
+
+	cat /proc/fs/cachefiles/histogram
+	JIFS  SECS  LOOKUPS   MKDIRS    CREATES
+	===== ===== ========= ========= =========
+
+     This shows the breakdown of the number of times each amount of time
+     between 0 jiffies and HZ-1 jiffies a variety of tasks took to run.  The
+     columns are as follows:
+
+	COLUMN		TIME MEASUREMENT
+	=======		=======================================================
+	LOOKUPS		Length of time to perform a lookup on the backing fs
+	MKDIRS		Length of time to perform a mkdir on the backing fs
+	CREATES		Length of time to perform a create on the backing fs
+
+     Each row shows the number of events that took a particular range of times.
+     Each step is 1 jiffy in size.  The JIFS column indicates the particular
+     jiffy range covered, and the SECS field the equivalent number of seconds.
+
+
+=========
+DEBUGGING
+=========
+
+If CONFIG_CACHEFILES_DEBUG is enabled, the CacheFiles facility can have runtime
+debugging enabled by adjusting the value in:
+
+	/sys/module/cachefiles/parameters/debug
+
+This is a bitmask of debugging streams to enable:
+
+	BIT	VALUE	STREAM				POINT
+	=======	=======	===============================	=======================
+	0	1	General				Function entry trace
+	1	2					Function exit trace
+	2	4					General
+
+The appropriate set of values should be OR'd together and the result written to
+the control file.  For example:
+
+	echo $((1|4|8)) >/sys/module/cachefiles/parameters/debug
+
+will turn on all function entry debugging.
diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 8ff2caa..9e94b94 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -200,7 +200,6 @@ STATISTICAL INFORMATION
 
 If FS-Cache is compiled with the following options enabled:
 
-	CONFIG_FSCACHE_PROC=y (implied by the following two)
 	CONFIG_FSCACHE_STATS=y
 	CONFIG_FSCACHE_HISTOGRAM=y
 
@@ -280,7 +279,7 @@ proc files.
  (*) /proc/fs/fscache/histogram
 
 	cat /proc/fs/fscache/histogram
-	+HZ   +TIME OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS
+	JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS
 	===== ===== ========= ========= ========= ========= =========
 
      This shows the breakdown of the number of times each amount of time
@@ -296,16 +295,16 @@ proc files.
 	RETRIEVLS	Time between beginning and end of a retrieval
 
      Each row shows the number of events that took a particular range of times.
-     Each step is 1 jiffy in size.  The +HZ column indicates the particular
-     jiffy range covered, and the +TIME field the equivalent number of seconds.
+     Each step is 1 jiffy in size.  The JIFS column indicates the particular
+     jiffy range covered, and the SECS field the equivalent number of seconds.
 
 
 =========
 DEBUGGING
 =========
 
-The FS-Cache facility can have runtime debugging enabled by adjusting the value
-in:
+If CONFIG_FSCACHE_DEBUG is enabled, the FS-Cache facility can have runtime
+debugging enabled by adjusting the value in:
 
 	/sys/module/fscache/parameters/debug
 
@@ -332,4 +331,3 @@ the control file.  For example:
 	echo $((1|8|64)) >/sys/module/fscache/parameters/debug
 
 will turn on all function entry debugging.
-
diff --git a/fs/cachefiles/Kconfig b/fs/cachefiles/Kconfig
index ddbdd85..11f54c3 100644
--- a/fs/cachefiles/Kconfig
+++ b/fs/cachefiles/Kconfig
@@ -21,13 +21,19 @@ config CACHEFILES_DEBUG
 
 config CACHEFILES_HISTOGRAM
 	bool "Gather latency information on CacheFiles"
-	depends on CACHEFILES && FSCACHE_PROC
+	depends on CACHEFILES && PROC_FS
 	help
 
 	  This option causes latency information to be gathered on CacheFiles
 	  operation and exported through file:
 
-		/proc/fs/fscache/cachefiles/histogram
+		/proc/fs/cachefiles/histogram
+
+	  The generation of this histogram adds a certain amount of overhead to
+	  execution as there are a number of points at which data is gathered,
+	  and on a multi-CPU system these may be on cachelines that keep
+	  bouncing between CPUs.  On the other hand, the histogram may be
+	  useful for debugging purposes.  Saying 'N' here is recommended.
 
 	  See Documentation/filesystems/caching/cachefiles.txt for more
 	  information.
diff --git a/fs/cachefiles/cf-proc.c b/fs/cachefiles/cf-proc.c
index c0d5444..d09beb5 100644
--- a/fs/cachefiles/cf-proc.c
+++ b/fs/cachefiles/cf-proc.c
@@ -14,104 +14,47 @@
 #include <linux/seq_file.h>
 #include "cf-internal.h"
 
-struct cachefiles_proc {
-	unsigned			nlines;
-	const struct seq_operations	*ops;
-};
-
 atomic_t cachefiles_lookup_histogram[HZ];
 atomic_t cachefiles_mkdir_histogram[HZ];
 atomic_t cachefiles_create_histogram[HZ];
 
-static struct proc_dir_entry *proc_cachefiles;
-
-static int cachefiles_proc_open(struct inode *inode, struct file *file);
-static void *cachefiles_proc_start(struct seq_file *m, loff_t *pos);
-static void cachefiles_proc_stop(struct seq_file *m, void *v);
-static void *cachefiles_proc_next(struct seq_file *m, void *v, loff_t *pos);
-static int cachefiles_histogram_show(struct seq_file *m, void *v);
-
-static const struct file_operations cachefiles_proc_fops = {
-	.open		= cachefiles_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct seq_operations cachefiles_histogram_ops = {
-	.start		= cachefiles_proc_start,
-	.stop		= cachefiles_proc_stop,
-	.next		= cachefiles_proc_next,
-	.show		= cachefiles_histogram_show,
-};
-
-static const struct cachefiles_proc cachefiles_histogram = {
-	.nlines		= HZ + 1,
-	.ops		= &cachefiles_histogram_ops,
-};
-
 /*
- * initialise the /proc/fs/fscache/cachefiles/ directory
+ * display the latency histogram
  */
-int __init cachefiles_proc_init(void)
+static int cachefiles_histogram_show(struct seq_file *m, void *v)
 {
-	struct proc_dir_entry *p;
-
-	_enter("");
-
-	proc_cachefiles = proc_mkdir("cachefiles", proc_fscache);
-	if (!proc_cachefiles)
-		goto error_dir;
-	proc_cachefiles->owner = THIS_MODULE;
-
-	p = create_proc_entry("histogram", 0, proc_cachefiles);
-	if (!p)
-		goto error_histogram;
-	p->proc_fops = &cachefiles_proc_fops;
-	p->owner = THIS_MODULE;
-	p->data = (void *) &cachefiles_histogram;
-
-	_leave(" = 0");
-	return 0;
+	unsigned long index;
+	unsigned x, y, z, t;
 
-error_histogram:
-	remove_proc_entry("fs/cachefiles", NULL);
-error_dir:
-	_leave(" = -ENOMEM");
-	return -ENOMEM;
-}
+	switch ((unsigned long) v) {
+	case 1:
+		seq_puts(m, "JIFS  SECS  LOOKUPS   MKDIRS    CREATES\n");
+		return 0;
+	case 2:
+		seq_puts(m, "===== ===== ========= ========= =========\n");
+		return 0;
+	default:
+		index = (unsigned long) v - 3;
+		x = atomic_read(&cachefiles_lookup_histogram[index]);
+		y = atomic_read(&cachefiles_mkdir_histogram[index]);
+		z = atomic_read(&cachefiles_create_histogram[index]);
+		if (x == 0 && y == 0 && z == 0)
+			return 0;
 
-/*
- * clean up the /proc/fs/fscache/cachefiles/ directory
- */
-void cachefiles_proc_cleanup(void)
-{
-	remove_proc_entry("histogram", proc_cachefiles);
-	remove_proc_entry("cachefiles", proc_fscache);
-}
+		t = (index * 1000) / HZ;
 
-/*
- * open "/proc/fs/fscache/cachefiles/XXX" which provide statistics summaries
- */
-static int cachefiles_proc_open(struct inode *inode, struct file *file)
-{
-	const struct cachefiles_proc *proc = PDE(inode)->data;
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, proc->ops);
-	if (ret == 0) {
-		m = file->private_data;
-		m->private = (void *) proc;
+		seq_printf(m, "%4lu  0.%03u %9u %9u %9u\n", index, t, x, y, z);
+		return 0;
 	}
-	return ret;
 }
 
 /*
  * set up the iterator to start reading from the first line
  */
-static void *cachefiles_proc_start(struct seq_file *m, loff_t *_pos)
+static void *cachefiles_histogram_start(struct seq_file *m, loff_t *_pos)
 {
+	if ((unsigned long long)*_pos >= HZ + 2)
+		return NULL;
 	if (*_pos == 0)
 		*_pos = 1;
 	return (void *)(unsigned long) *_pos;
@@ -120,47 +63,72 @@ static void *cachefiles_proc_start(struct seq_file *m, loff_t *_pos)
 /*
  * move to the next line
  */
-static void *cachefiles_proc_next(struct seq_file *m, void *v, loff_t *pos)
+static void *cachefiles_histogram_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	const struct cachefiles_proc *proc = m->private;
-
 	(*pos)++;
-	return *pos > proc->nlines ? NULL : (void *)(unsigned long) *pos;
+	return (unsigned long long)*pos > HZ + 2 ?
+		NULL : (void *)(unsigned long) *pos;
 }
 
 /*
  * clean up after reading
  */
-static void cachefiles_proc_stop(struct seq_file *m, void *v)
+static void cachefiles_histogram_stop(struct seq_file *m, void *v)
 {
 }
 
+static const struct seq_operations cachefiles_histogram_ops = {
+	.start		= cachefiles_histogram_start,
+	.stop		= cachefiles_histogram_stop,
+	.next		= cachefiles_histogram_next,
+	.show		= cachefiles_histogram_show,
+};
+
 /*
- * display the time-taken histogram
+ * open "/proc/fs/cachefiles/XXX" which provide statistics summaries
  */
-static int cachefiles_histogram_show(struct seq_file *m, void *v)
+static int cachefiles_histogram_open(struct inode *inode, struct file *file)
 {
-	unsigned long index;
-	unsigned x, y, z, t;
+	return seq_open(file, &cachefiles_histogram_ops);
+}
 
-	switch ((unsigned long) v) {
-	case 1:
-		seq_puts(m, "JIFS  SECS  LOOKUPS   MKDIRS    CREATES\n");
-		return 0;
-	case 2:
-		seq_puts(m, "===== ===== ========= ========= =========\n");
-		return 0;
-	default:
-		index = (unsigned long) v - 3;
-		x = atomic_read(&cachefiles_lookup_histogram[index]);
-		y = atomic_read(&cachefiles_mkdir_histogram[index]);
-		z = atomic_read(&cachefiles_create_histogram[index]);
-		if (x == 0 && y == 0 && z == 0)
-			return 0;
+static const struct file_operations cachefiles_histogram_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cachefiles_histogram_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 
-		t = (index * 1000) / HZ;
+/*
+ * initialise the /proc/fs/cachefiles/ directory
+ */
+int __init cachefiles_proc_init(void)
+{
+	_enter("");
 
-		seq_printf(m, "%4lu  0.%03u %9u %9u %9u\n", index, t, x, y, z);
-		return 0;
-	}
+	if (!proc_mkdir("fs/cachefiles", NULL))
+		goto error_dir;
+
+	if (!proc_create("fs/cachefiles/histogram", S_IFREG | 0444, NULL,
+			 &cachefiles_histogram_fops))
+		goto error_histogram;
+
+	_leave(" = 0");
+	return 0;
+
+error_histogram:
+	remove_proc_entry("fs/cachefiles", NULL);
+error_dir:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+
+/*
+ * clean up the /proc/fs/cachefiles/ directory
+ */
+void cachefiles_proc_cleanup(void)
+{
+	remove_proc_entry("fs/cachefiles/histogram", NULL);
+	remove_proc_entry("fs/cachefiles", NULL);
 }
diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index b9ff04a..9bbb8ce 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -11,31 +11,38 @@ config FSCACHE
 
 	  See Documentation/filesystems/caching/fscache.txt for more information.
 
-config FSCACHE_PROC
-	bool "Provide /proc interface for local caching statistics"
-	depends on FSCACHE && PROC_FS
-
 config FSCACHE_STATS
 	bool "Gather statistical information on local caching"
-	depends on FSCACHE_PROC
+	depends on FSCACHE && PROC_FS
 	help
 	  This option causes statistical information to be gathered on local
 	  caching and exported through file:
 
 		/proc/fs/fscache/stats
 
+	  The gathering of statistics adds a certain amount of overhead to
+	  execution as there are a quite a few stats gathered, and on a
+	  multi-CPU system these may be on cachelines that keep bouncing
+	  between CPUs.  On the other hand, the stats are very useful for
+	  debugging purposes.  Saying 'Y' here is recommended.
+
 	  See Documentation/filesystems/caching/fscache.txt for more information.
 
 config FSCACHE_HISTOGRAM
 	bool "Gather latency information on local caching"
-	depends on FSCACHE_PROC
+	depends on FSCACHE && PROC_FS
 	help
-
 	  This option causes latency information to be gathered on local
 	  caching and exported through file:
 
 		/proc/fs/fscache/histogram
 
+	  The generation of this histogram adds a certain amount of overhead to
+	  execution as there are a number of points at which data is gathered,
+	  and on a multi-CPU system these may be on cachelines that keep
+	  bouncing between CPUs.  On the other hand, the histogram may be
+	  useful for debugging purposes.  Saying 'N' here is recommended.
+
 	  See Documentation/filesystems/caching/fscache.txt for more information.
 
 config FSCACHE_DEBUG
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 572b012..3f6a198 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -10,8 +10,10 @@ fscache-y := \
 	fsc-netfs.o \
 	fsc-object.o \
 	fsc-operation.o \
-	fsc-page.o \
-	fsc-proc.o \
-	fsc-stats.o
+	fsc-page.o
+
+fscache-$(CONFIG_PROC_FS) += fsc-proc.o
+fscache-$(CONFIG_FSCACHE_STATS) += fsc-stats.o
+fscache-$(CONFIG_FSCACHE_HISTOGRAM) += fsc-histogram.o
 
 obj-$(CONFIG_FSCACHE) := fscache.o
diff --git a/fs/fscache/fsc-histogram.c b/fs/fscache/fsc-histogram.c
new file mode 100644
index 0000000..d1cbbc3
--- /dev/null
+++ b/fs/fscache/fsc-histogram.c
@@ -0,0 +1,109 @@
+/* FS-Cache latency histogram
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL THREAD
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "fsc-internal.h"
+
+atomic_t fscache_obj_instantiate_histogram[HZ];
+atomic_t fscache_objs_histogram[HZ];
+atomic_t fscache_ops_histogram[HZ];
+atomic_t fscache_retrieval_delay_histogram[HZ];
+atomic_t fscache_retrieval_histogram[HZ];
+
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
+
+/*
+ * set up the iterator to start reading from the first line
+ */
+static void *fscache_histogram_start(struct seq_file *m, loff_t *_pos)
+{
+	if ((unsigned long long)*_pos >= HZ + 2)
+		return NULL;
+	if (*_pos == 0)
+		*_pos = 1;
+	return (void *)(unsigned long) *_pos;
+}
+
+/*
+ * move to the next line
+ */
+static void *fscache_histogram_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (unsigned long long)*pos > HZ + 2 ?
+		NULL : (void *)(unsigned long) *pos;
+}
+
+/*
+ * clean up after reading
+ */
+static void fscache_histogram_stop(struct seq_file *m, void *v)
+{
+}
+
+static const struct seq_operations fscache_histogram_ops = {
+	.start		= fscache_histogram_start,
+	.stop		= fscache_histogram_stop,
+	.next		= fscache_histogram_next,
+	.show		= fscache_histogram_show,
+};
+
+/*
+ * open "/proc/fs/fscache/histogram" to provide latency data
+ */
+static int fscache_histogram_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &fscache_histogram_ops);
+}
+
+const struct file_operations fscache_histogram_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fscache_histogram_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
index f2ff86b..e5eb297 100644
--- a/fs/fscache/fsc-internal.h
+++ b/fs/fscache/fsc-internal.h
@@ -51,6 +51,30 @@ extern struct fscache_cookie fscache_fsdef_index;
 extern struct fscache_cookie_def fscache_fsdef_netfs_def;
 
 /*
+ * fsc-histogram.c
+ */
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
+extern const struct file_operations fscache_histogram_fops;
+
+#else
+#define fscache_hist(hist, start_jif) do {} while (0)
+#endif
+
+/*
  * fsc-main.c
  */
 extern unsigned fscache_defer_lookup;
@@ -80,6 +104,17 @@ extern void fscache_start_operations(struct fscache_object *);
 extern void fscache_operation_gc(struct work_struct *);
 
 /*
+ * fsc-proc.c
+ */
+#ifdef CONFIG_PROC_FS
+extern int __init fscache_proc_init(void);
+extern void fscache_proc_cleanup(void);
+#else
+#define fscache_proc_init()	(0)
+#define fscache_proc_cleanup()	do {} while (0)
+#endif
+
+/*
  * fsc-stats.c
  */
 #ifdef CONFIG_FSCACHE_STATS
@@ -164,36 +199,11 @@ static inline void fscache_stat(atomic_t *stat)
 {
 	atomic_inc(stat);
 }
-#else
-
-#define fscache_stat(stat) do {} while (0)
-#endif
-
-#ifdef CONFIG_FSCACHE_HISTOGRAM
-extern atomic_t fscache_obj_instantiate_histogram[HZ];
-extern atomic_t fscache_objs_histogram[HZ];
-extern atomic_t fscache_ops_histogram[HZ];
-extern atomic_t fscache_retrieval_delay_histogram[HZ];
-extern atomic_t fscache_retrieval_histogram[HZ];
-
-static inline void fscache_hist(atomic_t histogram[], unsigned long start_jif)
-{
-	unsigned long jif = jiffies - start_jif;
-	if (jif >= HZ)
-		jif = HZ - 1;
-	atomic_inc(&histogram[jif]);
-}
 
+extern const struct file_operations fscache_stats_fops;
 #else
-#define fscache_hist(hist, start_jif) do {} while (0)
-#endif
 
-#ifdef CONFIG_FSCACHE_PROC
-extern int __init fscache_proc_init(void);
-extern void fscache_proc_cleanup(void);
-#else
-#define fscache_proc_init()	(0)
-#define fscache_proc_cleanup()	do {} while (0)
+#define fscache_stat(stat) do {} while (0)
 #endif
 
 /*
diff --git a/fs/fscache/fsc-proc.c b/fs/fscache/fsc-proc.c
index dd6daa5..2f549f3 100644
--- a/fs/fscache/fsc-proc.c
+++ b/fs/fscache/fsc-proc.c
@@ -15,94 +15,26 @@
 #include <linux/seq_file.h>
 #include "fsc-internal.h"
 
-struct fscache_proc {
-	unsigned			nlines;
-	const struct seq_operations	*ops;
-};
-
-struct proc_dir_entry *proc_fscache;
-EXPORT_SYMBOL(proc_fscache);
-
-#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
-static int fscache_proc_open(struct inode *inode, struct file *file);
-static void *fscache_proc_start(struct seq_file *m, loff_t *pos);
-static void fscache_proc_stop(struct seq_file *m, void *v);
-static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos);
-
-static const struct file_operations fscache_proc_fops = {
-	.open		= fscache_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-#endif
-
-#ifdef CONFIG_FSCACHE_STATS
-static int fscache_stats_show(struct seq_file *m, void *v);
-
-static const struct seq_operations fscache_stats_ops = {
-	.start		= fscache_proc_start,
-	.stop		= fscache_proc_stop,
-	.next		= fscache_proc_next,
-	.show		= fscache_stats_show,
-};
-
-static const struct fscache_proc fscache_stats = {
-	.nlines		= 17,
-	.ops		= &fscache_stats_ops,
-};
-#endif
-
-#ifdef CONFIG_FSCACHE_HISTOGRAM
-static int fscache_histogram_show(struct seq_file *m, void *v);
-
-static const struct seq_operations fscache_histogram_ops = {
-	.start		= fscache_proc_start,
-	.stop		= fscache_proc_stop,
-	.next		= fscache_proc_next,
-	.show		= fscache_histogram_show,
-};
-
-static const struct fscache_proc fscache_histogram = {
-	.nlines		= HZ + 1,
-	.ops		= &fscache_histogram_ops,
-};
-#endif
-
-#define FSC_DESC(SELECT, N) ((void *) (unsigned long) (((SELECT) << 16) | (N)))
-
 /*
  * initialise the /proc/fs/fscache/ directory
  */
 int __init fscache_proc_init(void)
 {
-#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
-	struct proc_dir_entry *p;
-#endif
-
 	_enter("");
 
-	proc_fscache = proc_mkdir("fs/fscache", NULL);
-	if (!proc_fscache)
+	if (!proc_mkdir("fs/fscache", NULL))
 		goto error_dir;
-	proc_fscache->owner = THIS_MODULE;
 
 #ifdef CONFIG_FSCACHE_STATS
-	p = create_proc_entry("stats", 0, proc_fscache);
-	if (!p)
+	if (!proc_create("fs/fscache/stats", S_IFREG | 0444, NULL,
+			 &fscache_stats_fops))
 		goto error_stats;
-	p->proc_fops = &fscache_proc_fops;
-	p->owner = THIS_MODULE;
-	p->data = (void *) &fscache_stats;
 #endif
 
 #ifdef CONFIG_FSCACHE_HISTOGRAM
-	p = create_proc_entry("histogram", 0, proc_fscache);
-	if (!p)
+	if (!proc_create("fs/fscache/histogram", S_IFREG | 0444, NULL,
+			 &fscache_histogram_fops))
 		goto error_histogram;
-	p->proc_fops = &fscache_proc_fops;
-	p->owner = THIS_MODULE;
-	p->data = (void *) &fscache_histogram;
 #endif
 
 	_leave(" = 0");
@@ -112,7 +44,7 @@ int __init fscache_proc_init(void)
 error_histogram:
 #endif
 #ifdef CONFIG_FSCACHE_STATS
-	remove_proc_entry("stats", proc_fscache);
+	remove_proc_entry("fs/fscache/stats", NULL);
 error_stats:
 #endif
 	remove_proc_entry("fs/fscache", NULL);
@@ -127,244 +59,10 @@ error_dir:
 void fscache_proc_cleanup(void)
 {
 #ifdef CONFIG_FSCACHE_HISTOGRAM
-	remove_proc_entry("histogram", proc_fscache);
+	remove_proc_entry("fs/fscache/histogram", NULL);
 #endif
 #ifdef CONFIG_FSCACHE_STATS
-	remove_proc_entry("stats", proc_fscache);
+	remove_proc_entry("fs/fscache/stats", NULL);
 #endif
 	remove_proc_entry("fs/fscache", NULL);
 }
-
-#if defined(CONFIG_FSCACHE_STATS) || defined(CONFIG_FSCACHE_HISTOGRAM)
-/*
- * open "/proc/fs/fscache/XXX" which provide statistics summaries
- */
-static int fscache_proc_open(struct inode *inode, struct file *file)
-{
-	const struct fscache_proc *proc = PDE(inode)->data;
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, proc->ops);
-	if (ret == 0) {
-		m = file->private_data;
-		m->private = (void *) proc;
-	}
-	return ret;
-}
-
-/*
- * set up the iterator to start reading from the first line
- */
-static void *fscache_proc_start(struct seq_file *m, loff_t *_pos)
-{
-	if (*_pos == 0)
-		*_pos = 1;
-	return (void *)(unsigned long) *_pos;
-}
-
-/*
- * move to the next line
- */
-static void *fscache_proc_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	const struct fscache_proc *proc = m->private;
-
-	(*pos)++;
-	return *pos > proc->nlines ? NULL : (void *)(unsigned long) *pos;
-}
-
-/*
- * clean up after reading
- */
-static void fscache_proc_stop(struct seq_file *m, void *v)
-{
-}
-#endif
-
-#ifdef CONFIG_FSCACHE_STATS
-/*
- * display the general statistics
- */
-static int fscache_stats_show(struct seq_file *m, void *v)
-{
-	unsigned long line = (unsigned long) v;
-
-	switch (line) {
-	case 1:
-		seq_puts(m, "FS-Cache statistics\n");
-		break;
-
-	case 2:
-		seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
-			   atomic_read(&fscache_n_cookie_index),
-			   atomic_read(&fscache_n_cookie_data),
-			   atomic_read(&fscache_n_cookie_special));
-		break;
-
-	case 3:
-		seq_printf(m, "Objects: alc=%u nal=%u avl=%u ded=%u\n",
-			   atomic_read(&fscache_n_object_alloc),
-			   atomic_read(&fscache_n_object_no_alloc),
-			   atomic_read(&fscache_n_object_avail),
-			   atomic_read(&fscache_n_object_dead));
-		break;
-
-	case 4:
-		seq_printf(m, "ChkAux : non=%u ok=%u upd=%u obs=%u\n",
-			   atomic_read(&fscache_n_checkaux_none),
-			   atomic_read(&fscache_n_checkaux_okay),
-			   atomic_read(&fscache_n_checkaux_update),
-			   atomic_read(&fscache_n_checkaux_obsolete));
-		break;
-
-	case 5:
-		seq_printf(m, "Pages  : mrk=%u unc=%u\n",
-			   atomic_read(&fscache_n_marks),
-			   atomic_read(&fscache_n_uncaches));
-		break;
-
-	case 6:
-		seq_printf(m, "Acquire: n=%u nul=%u noc=%u ok=%u nbf=%u"
-			   " oom=%u\n",
-			   atomic_read(&fscache_n_acquires),
-			   atomic_read(&fscache_n_acquires_null),
-			   atomic_read(&fscache_n_acquires_no_cache),
-			   atomic_read(&fscache_n_acquires_ok),
-			   atomic_read(&fscache_n_acquires_nobufs),
-			   atomic_read(&fscache_n_acquires_oom));
-		break;
-
-	case 7:
-		seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u\n",
-			   atomic_read(&fscache_n_object_lookups),
-			   atomic_read(&fscache_n_object_lookups_negative),
-			   atomic_read(&fscache_n_object_lookups_positive),
-			   atomic_read(&fscache_n_object_created));
-		break;
-
-	case 8:
-		seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
-			   atomic_read(&fscache_n_updates),
-			   atomic_read(&fscache_n_updates_null),
-			   atomic_read(&fscache_n_updates_run));
-		break;
-
-	case 9:
-		seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u\n",
-			   atomic_read(&fscache_n_relinquishes),
-			   atomic_read(&fscache_n_relinquishes_null),
-			   atomic_read(&fscache_n_relinquishes_waitcrt));
-		break;
-
-	case 10:
-		seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
-			   atomic_read(&fscache_n_attr_changed),
-			   atomic_read(&fscache_n_attr_changed_ok),
-			   atomic_read(&fscache_n_attr_changed_nobufs),
-			   atomic_read(&fscache_n_attr_changed_nomem),
-			   atomic_read(&fscache_n_attr_changed_calls));
-		break;
-
-	case 11:
-		seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u\n",
-			   atomic_read(&fscache_n_allocs),
-			   atomic_read(&fscache_n_allocs_ok),
-			   atomic_read(&fscache_n_allocs_wait),
-			   atomic_read(&fscache_n_allocs_nobufs));
-		break;
-	case 12:
-		seq_printf(m, "Allocs : ops=%u owt=%u\n",
-			   atomic_read(&fscache_n_alloc_ops),
-			   atomic_read(&fscache_n_alloc_op_waits));
-		break;
-
-	case 13:
-		seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
-			   " int=%u oom=%u\n",
-			   atomic_read(&fscache_n_retrievals),
-			   atomic_read(&fscache_n_retrievals_ok),
-			   atomic_read(&fscache_n_retrievals_wait),
-			   atomic_read(&fscache_n_retrievals_nodata),
-			   atomic_read(&fscache_n_retrievals_nobufs),
-			   atomic_read(&fscache_n_retrievals_intr),
-			   atomic_read(&fscache_n_retrievals_nomem));
-		break;
-	case 14:
-		seq_printf(m, "Retrvls: ops=%u owt=%u\n",
-			   atomic_read(&fscache_n_retrieval_ops),
-			   atomic_read(&fscache_n_retrieval_op_waits));
-		break;
-
-	case 15:
-		seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
-			   atomic_read(&fscache_n_stores),
-			   atomic_read(&fscache_n_stores_ok),
-			   atomic_read(&fscache_n_stores_again),
-			   atomic_read(&fscache_n_stores_nobufs),
-			   atomic_read(&fscache_n_stores_oom));
-		break;
-	case 16:
-		seq_printf(m, "Stores : ops=%u run=%u\n",
-			   atomic_read(&fscache_n_store_ops),
-			   atomic_read(&fscache_n_store_calls));
-		break;
-
-	case 17:
-		seq_printf(m, "Ops    : pend=%u run=%u enq=%u\n",
-			   atomic_read(&fscache_n_op_pend),
-			   atomic_read(&fscache_n_op_run),
-			   atomic_read(&fscache_n_op_enqueue));
-		break;
-
-	case 18:
-		seq_printf(m, "Ops    : dfr=%u rel=%u gc=%u\n",
-			   atomic_read(&fscache_n_op_deferred_release),
-			   atomic_read(&fscache_n_op_release),
-			   atomic_read(&fscache_n_op_gc));
-		break;
-
-	default:
-		break;
-	}
-	return 0;
-}
-
-#endif /* end CONFIG_FSCACHE_STATS */
-
-#ifdef CONFIG_FSCACHE_HISTOGRAM
-/*
- * display the time-taken histogram
- */
-static int fscache_histogram_show(struct seq_file *m, void *v)
-{
-	unsigned long index;
-	unsigned n[5], t;
-
-	switch ((unsigned long) v) {
-	case 1:
-		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS "
-			 " RETRV DLY RETRIEVLS\n");
-		return 0;
-	case 2:
-		seq_puts(m, "===== ===== ========= ========= ========="
-			 " ========= =========\n");
-		return 0;
-	default:
-		index = (unsigned long) v - 3;
-		n[0] = atomic_read(&fscache_obj_instantiate_histogram[index]);
-		n[1] = atomic_read(&fscache_ops_histogram[index]);
-		n[2] = atomic_read(&fscache_objs_histogram[index]);
-		n[3] = atomic_read(&fscache_retrieval_delay_histogram[index]);
-		n[4] = atomic_read(&fscache_retrieval_histogram[index]);
-		if (!(n[0] | n[1] | n[2] | n[3] | n[4]))
-			return 0;
-
-		t = (index * 1000) / HZ;
-
-		seq_printf(m, "%4lu  0.%03u %9u %9u %9u %9u %9u\n",
-			   index, t, n[0], n[1], n[2], n[3], n[4]);
-		return 0;
-	}
-}
-#endif /* end CONFIG_FSCACHE_HISTOGRAM */
diff --git a/fs/fscache/fsc-stats.c b/fs/fscache/fsc-stats.c
index 8762d43..93ffc8f 100644
--- a/fs/fscache/fsc-stats.c
+++ b/fs/fscache/fsc-stats.c
@@ -18,7 +18,6 @@
 /*
  * operation counters
  */
-#ifdef CONFIG_FSCACHE_STATS
 atomic_t fscache_n_op_pend;
 atomic_t fscache_n_op_run;
 atomic_t fscache_n_op_enqueue;
@@ -93,12 +92,121 @@ atomic_t fscache_n_checkaux_none;
 atomic_t fscache_n_checkaux_okay;
 atomic_t fscache_n_checkaux_update;
 atomic_t fscache_n_checkaux_obsolete;
-#endif
-
-#ifdef CONFIG_FSCACHE_HISTOGRAM
-atomic_t fscache_obj_instantiate_histogram[HZ];
-atomic_t fscache_objs_histogram[HZ];
-atomic_t fscache_ops_histogram[HZ];
-atomic_t fscache_retrieval_delay_histogram[HZ];
-atomic_t fscache_retrieval_histogram[HZ];
-#endif
+
+/*
+ * display the general statistics
+ */
+static int fscache_stats_show(struct seq_file *m, void *v)
+{
+	seq_puts(m, "FS-Cache statistics\n");
+
+	seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
+		   atomic_read(&fscache_n_cookie_index),
+		   atomic_read(&fscache_n_cookie_data),
+		   atomic_read(&fscache_n_cookie_special));
+
+	seq_printf(m, "Objects: alc=%u nal=%u avl=%u ded=%u\n",
+		   atomic_read(&fscache_n_object_alloc),
+		   atomic_read(&fscache_n_object_no_alloc),
+		   atomic_read(&fscache_n_object_avail),
+		   atomic_read(&fscache_n_object_dead));
+	seq_printf(m, "ChkAux : non=%u ok=%u upd=%u obs=%u\n",
+		   atomic_read(&fscache_n_checkaux_none),
+		   atomic_read(&fscache_n_checkaux_okay),
+		   atomic_read(&fscache_n_checkaux_update),
+		   atomic_read(&fscache_n_checkaux_obsolete));
+
+	seq_printf(m, "Pages  : mrk=%u unc=%u\n",
+		   atomic_read(&fscache_n_marks),
+		   atomic_read(&fscache_n_uncaches));
+
+	seq_printf(m, "Acquire: n=%u nul=%u noc=%u ok=%u nbf=%u"
+		   " oom=%u\n",
+		   atomic_read(&fscache_n_acquires),
+		   atomic_read(&fscache_n_acquires_null),
+		   atomic_read(&fscache_n_acquires_no_cache),
+		   atomic_read(&fscache_n_acquires_ok),
+		   atomic_read(&fscache_n_acquires_nobufs),
+		   atomic_read(&fscache_n_acquires_oom));
+
+	seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u\n",
+		   atomic_read(&fscache_n_object_lookups),
+		   atomic_read(&fscache_n_object_lookups_negative),
+		   atomic_read(&fscache_n_object_lookups_positive),
+		   atomic_read(&fscache_n_object_created));
+
+	seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
+		   atomic_read(&fscache_n_updates),
+		   atomic_read(&fscache_n_updates_null),
+		   atomic_read(&fscache_n_updates_run));
+
+	seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u\n",
+		   atomic_read(&fscache_n_relinquishes),
+		   atomic_read(&fscache_n_relinquishes_null),
+		   atomic_read(&fscache_n_relinquishes_waitcrt));
+
+	seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
+		   atomic_read(&fscache_n_attr_changed),
+		   atomic_read(&fscache_n_attr_changed_ok),
+		   atomic_read(&fscache_n_attr_changed_nobufs),
+		   atomic_read(&fscache_n_attr_changed_nomem),
+		   atomic_read(&fscache_n_attr_changed_calls));
+
+	seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u\n",
+		   atomic_read(&fscache_n_allocs),
+		   atomic_read(&fscache_n_allocs_ok),
+		   atomic_read(&fscache_n_allocs_wait),
+		   atomic_read(&fscache_n_allocs_nobufs));
+	seq_printf(m, "Allocs : ops=%u owt=%u\n",
+		   atomic_read(&fscache_n_alloc_ops),
+		   atomic_read(&fscache_n_alloc_op_waits));
+
+	seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
+		   " int=%u oom=%u\n",
+		   atomic_read(&fscache_n_retrievals),
+		   atomic_read(&fscache_n_retrievals_ok),
+		   atomic_read(&fscache_n_retrievals_wait),
+		   atomic_read(&fscache_n_retrievals_nodata),
+		   atomic_read(&fscache_n_retrievals_nobufs),
+		   atomic_read(&fscache_n_retrievals_intr),
+		   atomic_read(&fscache_n_retrievals_nomem));
+	seq_printf(m, "Retrvls: ops=%u owt=%u\n",
+		   atomic_read(&fscache_n_retrieval_ops),
+		   atomic_read(&fscache_n_retrieval_op_waits));
+
+	seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
+		   atomic_read(&fscache_n_stores),
+		   atomic_read(&fscache_n_stores_ok),
+		   atomic_read(&fscache_n_stores_again),
+		   atomic_read(&fscache_n_stores_nobufs),
+		   atomic_read(&fscache_n_stores_oom));
+	seq_printf(m, "Stores : ops=%u run=%u\n",
+		   atomic_read(&fscache_n_store_ops),
+		   atomic_read(&fscache_n_store_calls));
+
+	seq_printf(m, "Ops    : pend=%u run=%u enq=%u\n",
+		   atomic_read(&fscache_n_op_pend),
+		   atomic_read(&fscache_n_op_run),
+		   atomic_read(&fscache_n_op_enqueue));
+	seq_printf(m, "Ops    : dfr=%u rel=%u gc=%u\n",
+		   atomic_read(&fscache_n_op_deferred_release),
+		   atomic_read(&fscache_n_op_release),
+		   atomic_read(&fscache_n_op_gc));
+	return 0;
+}
+
+/*
+ * open "/proc/fs/fscache/stats" allowing provision of a statistical summary
+ */
+static int fscache_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fscache_stats_show, NULL);
+}
+
+const struct file_operations fscache_stats_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fscache_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index a31f4c1..0410bd9 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -29,10 +29,6 @@ struct fscache_cache_ops;
 struct fscache_object;
 struct fscache_operation;
 
-#ifdef CONFIG_FSCACHE_PROC
-extern struct proc_dir_entry *proc_fscache;
-#endif
-
 /*
  * cache tag definition
  */

