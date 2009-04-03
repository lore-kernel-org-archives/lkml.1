Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbZDCQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbZDCQAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbZDCPzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933999AbZDCPzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/41] FS-Cache: Add use of /proc and presentation of
	statistics [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:28 +0100
Message-ID: <20090403155528.28714.19141.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
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
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 Documentation/filesystems/caching/backend-api.txt |    6 -
 Documentation/filesystems/caching/fscache.txt     |   12 -
 fs/fscache/Kconfig                                |   34 +++
 fs/fscache/Makefile                               |    4 
 fs/fscache/histogram.c                            |  109 +++++++++++
 fs/fscache/internal.h                             |  127 +++++++++++++
 fs/fscache/main.c                                 |    7 +
 fs/fscache/proc.c                                 |   68 +++++++
 fs/fscache/stats.c                                |  212 +++++++++++++++++++++
 include/linux/fscache-cache.h                     |    4 
 10 files changed, 566 insertions(+), 17 deletions(-)
 create mode 100644 fs/fscache/histogram.c
 create mode 100644 fs/fscache/proc.c
 create mode 100644 fs/fscache/stats.c


diff --git a/Documentation/filesystems/caching/backend-api.txt b/Documentation/filesystems/caching/backend-api.txt
index 1772305..382d52c 100644
--- a/Documentation/filesystems/caching/backend-api.txt
+++ b/Documentation/filesystems/caching/backend-api.txt
@@ -100,12 +100,6 @@ A sysfs directory called /sys/fs/fscache/<cachetag>/ is created if CONFIG_SYSFS
 is enabled.  This is accessible through the kobject struct fscache_cache::kobj
 and is for use by the cache as it sees fit.
 
-The cache driver may create itself a directory named for the cache type in the
-/proc/fs/fscache/ directory.  This is available if CONFIG_FSCACHE_PROC is
-enabled and is accessible through:
-
-	struct proc_dir_entry *proc_fscache;
-
 
 ========================
 RELEVANT DATA STRUCTURES
diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index a759d91..0a751f3 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -195,7 +195,6 @@ STATISTICAL INFORMATION
 
 If FS-Cache is compiled with the following options enabled:
 
-	CONFIG_FSCACHE_PROC=y (implied by the following two)
 	CONFIG_FSCACHE_STATS=y
 	CONFIG_FSCACHE_HISTOGRAM=y
 
@@ -275,7 +274,7 @@ proc files.
  (*) /proc/fs/fscache/histogram
 
 	cat /proc/fs/fscache/histogram
-	+HZ   +TIME OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS
+	JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS
 	===== ===== ========= ========= ========= ========= =========
 
      This shows the breakdown of the number of times each amount of time
@@ -291,16 +290,16 @@ proc files.
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
 
@@ -327,4 +326,3 @@ the control file.  For example:
 	echo $((1|8|64)) >/sys/module/fscache/parameters/debug
 
 will turn on all function entry debugging.
-
diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index 7c7bccd..9bbb8ce 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -11,6 +11,40 @@ config FSCACHE
 
 	  See Documentation/filesystems/caching/fscache.txt for more information.
 
+config FSCACHE_STATS
+	bool "Gather statistical information on local caching"
+	depends on FSCACHE && PROC_FS
+	help
+	  This option causes statistical information to be gathered on local
+	  caching and exported through file:
+
+		/proc/fs/fscache/stats
+
+	  The gathering of statistics adds a certain amount of overhead to
+	  execution as there are a quite a few stats gathered, and on a
+	  multi-CPU system these may be on cachelines that keep bouncing
+	  between CPUs.  On the other hand, the stats are very useful for
+	  debugging purposes.  Saying 'Y' here is recommended.
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_HISTOGRAM
+	bool "Gather latency information on local caching"
+	depends on FSCACHE && PROC_FS
+	help
+	  This option causes latency information to be gathered on local
+	  caching and exported through file:
+
+		/proc/fs/fscache/histogram
+
+	  The generation of this histogram adds a certain amount of overhead to
+	  execution as there are a number of points at which data is gathered,
+	  and on a multi-CPU system these may be on cachelines that keep
+	  bouncing between CPUs.  On the other hand, the histogram may be
+	  useful for debugging purposes.  Saying 'N' here is recommended.
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
 config FSCACHE_DEBUG
 	bool "Debug FS-Cache"
 	depends on FSCACHE
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index f8038b8..1384823 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -5,4 +5,8 @@
 fscache-y := \
 	main.o
 
+fscache-$(CONFIG_PROC_FS) += proc.o
+fscache-$(CONFIG_FSCACHE_STATS) += stats.o
+fscache-$(CONFIG_FSCACHE_HISTOGRAM) += histogram.o
+
 obj-$(CONFIG_FSCACHE) := fscache.o
diff --git a/fs/fscache/histogram.c b/fs/fscache/histogram.c
new file mode 100644
index 0000000..bad4967
--- /dev/null
+++ b/fs/fscache/histogram.c
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
+#include "internal.h"
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
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 95dc92d..16f9f1f 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -28,6 +28,30 @@
 #define FSCACHE_MAX_THREADS	32
 
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
@@ -35,6 +59,109 @@ extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
 
+/*
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
+
+extern const struct file_operations fscache_stats_fops;
+#else
+
+#define fscache_stat(stat) do {} while (0)
+#endif
+
 /*****************************************************************************/
 /*
  * debug tracing
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 76f7c69..7c734b7 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
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
diff --git a/fs/fscache/proc.c b/fs/fscache/proc.c
new file mode 100644
index 0000000..beeab44
--- /dev/null
+++ b/fs/fscache/proc.c
@@ -0,0 +1,68 @@
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
+#include "internal.h"
+
+/*
+ * initialise the /proc/fs/fscache/ directory
+ */
+int __init fscache_proc_init(void)
+{
+	_enter("");
+
+	if (!proc_mkdir("fs/fscache", NULL))
+		goto error_dir;
+
+#ifdef CONFIG_FSCACHE_STATS
+	if (!proc_create("fs/fscache/stats", S_IFREG | 0444, NULL,
+			 &fscache_stats_fops))
+		goto error_stats;
+#endif
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+	if (!proc_create("fs/fscache/histogram", S_IFREG | 0444, NULL,
+			 &fscache_histogram_fops))
+		goto error_histogram;
+#endif
+
+	_leave(" = 0");
+	return 0;
+
+#ifdef CONFIG_FSCACHE_HISTOGRAM
+error_histogram:
+#endif
+#ifdef CONFIG_FSCACHE_STATS
+	remove_proc_entry("fs/fscache/stats", NULL);
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
+	remove_proc_entry("fs/fscache/histogram", NULL);
+#endif
+#ifdef CONFIG_FSCACHE_STATS
+	remove_proc_entry("fs/fscache/stats", NULL);
+#endif
+	remove_proc_entry("fs/fscache", NULL);
+}
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
new file mode 100644
index 0000000..65deb99
--- /dev/null
+++ b/fs/fscache/stats.c
@@ -0,0 +1,212 @@
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
+#include "internal.h"
+
+/*
+ * operation counters
+ */
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
index b2a9a48..84d3532 100644
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

