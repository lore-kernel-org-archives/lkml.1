Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYDFRt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYDFRt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYDFRtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:49:18 -0400
Received: from [194.117.236.238] ([194.117.236.238]:50642 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYDFRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:49:17 -0400
Date: Sun, 6 Apr 2008 20:48:53 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tom Zanussi <zanussi@comcast.net>
Subject: Re: [PATCH] relay: add buffer-only functionality, for early kernel
 tracing
Message-ID: <20080406204853.66a6f263@linux360.ro>
In-Reply-To: <20080406203426.40431e74@linux360.ro>
References: <20080406203426.40431e74@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is _not_ a patched intended for merging!

Mathieu, please take a look (maybe test) and see if I didn't mess up
the CPU hotplug stuff. AFAICS, it shoudn't be affected, but better be
sure.

I have also attached some sample code using this functionality. It
currently logs some text on every kmalloc() (SLUB-only), so one can
easily check for data corruption. Make sure you enable CONFIG_SLUB and
CONFIG_KMEMTRACE.

Oh, and I've tried Tom Zanussi's other e-mail address and Comcast
rejects my mails. :(

---
diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
new file mode 100644
index 0000000..8b7eda9
--- /dev/null
+++ b/include/linux/kmemtrace.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2008 Eduard-Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#ifndef _LINUX_KMEMTRACE_H
+#define _LINUX_KMEMTRACE_H
+
+#include <linux/cache.h>
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+
+extern int kmemtrace_is_inited __read_mostly;
+
+extern void kmemtrace_init(void);
+extern void kmemtrace_track_alloc(void *call_site, const void *ptr, 
+				  unsigned long nr_req,
+				  unsigned long nr_alloc,
+				  gfp_t flags);
+extern void kmemtrace_track_free(void *call_site, const void *ptr);
+extern void kmemtrace_log_string(char *str);
+
+#endif /* __KERNEL__ */
+
+enum kmemtrace_event_id {
+	KMEM_ALLOC	= 0x01,
+	KMEM_FREE	= 0x02,
+};
+
+struct kmemtrace_event {
+	enum kmemtrace_event_id		event_id;
+	uintptr_t			call_site;
+	uintptr_t			ptr;
+	unsigned long			nr_req;
+	unsigned long			nr_alloc;
+	unsigned long			gfp_flags;
+};
+
+#endif /* _LINUX_KMEMTRACE_H */
+
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index b00c1c7..53e62f7 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -11,6 +11,10 @@
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
 
+#ifdef CONFIG_KMEMTRACE
+#include <linux/kmemtrace.h>
+#endif
+
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
 	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */
@@ -196,20 +200,36 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
-	if (__builtin_constant_p(size)) {
-		if (size > PAGE_SIZE)
-			return kmalloc_large(size, flags);
+	void *ret = NULL;
+	size_t nr_alloc = 0;
 
-		if (!(flags & SLUB_DMA)) {
+	if (__builtin_constant_p(size)) {
+		if (size > PAGE_SIZE) {
+			ret = kmalloc_large(size, flags);
+			nr_alloc = PAGE_SIZE << get_order(size);
+		} else if (!(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
 
-			if (!s)
-				return ZERO_SIZE_PTR;
-
-			return kmem_cache_alloc(s, flags);
+			if (!s) {
+				ret = ZERO_SIZE_PTR;
+				nr_alloc = 0;
+			} else {
+				ret = kmem_cache_alloc(s, flags);
+				nr_alloc = s->size;
+			}
 		}
+	} else {
+		ret = __kmalloc(size, flags);
+		nr_alloc = size;
 	}
-	return __kmalloc(size, flags);
+
+#ifdef CONFIG_KMEMTRACE
+	if (kmemtrace_is_inited) /* Has kmemtrace been initialized yet? */
+		kmemtrace_track_alloc(__builtin_return_address(0), ret,
+				      size, nr_alloc, flags);
+#endif
+
+	return ret;
 }
 
 #ifdef CONFIG_NUMA
diff --git a/init/main.c b/init/main.c
index 99ce949..26db1c1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -65,6 +65,10 @@
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
+#ifdef CONFIG_KMEMTRACE
+#include <linux/kmemtrace.h>
+#endif
+
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
 #endif
@@ -610,6 +614,10 @@ asmlinkage void __init start_kernel(void)
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+#ifdef CONFIG_KMEMTRACE
+	kmemtrace_init();
+	kmemtrace_log_string("kmemtrace_init() just ran!\n");
+#endif
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff --git a/mm/Kconfig b/mm/Kconfig
index 0016ebd..b12555b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1,3 +1,8 @@
+config KMEMTRACE
+	bool "Kernel memory tracer"
+	depends on SLUB
+	default n
+
 config SELECT_MEMORY_MODEL
 	def_bool y
 	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
diff --git a/mm/Makefile b/mm/Makefile
index a5b0dd9..67aa3f4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -33,4 +33,5 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 
diff --git a/mm/kmemtrace.c b/mm/kmemtrace.c
new file mode 100644
index 0000000..4ecefc4
--- /dev/null
+++ b/mm/kmemtrace.c
@@ -0,0 +1,116 @@
+/*
+ * Copyright (C) 2008 Pekka Enberg, Eduard-Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#include <linux/kmemtrace.h>
+#include <linux/string.h>
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+#include <linux/module.h>
+
+#define KMEMTRACE_SUBBUF_SIZE	262144
+#define KMEMTRACE_NR_SUBBUFS	4
+
+static struct rchan *kmemtrace_chan;
+
+static inline void kmemtrace_log_event(struct kmemtrace_event *event)
+{
+	relay_write(kmemtrace_chan, event, sizeof(struct kmemtrace_event));
+}
+
+void kmemtrace_log_string(char *str)
+{
+	relay_write(kmemtrace_chan, str, strlen(str) + 1);
+}
+
+void kmemtrace_track_alloc(void *call_site, const void *ptr,
+			   unsigned long nr_req, unsigned long nr_alloc,
+			   gfp_t flags)
+{
+	struct kmemtrace_event ev = {
+		.event_id	= KMEM_ALLOC,
+		.call_site	= (uintptr_t) call_site,
+		.ptr		= (uintptr_t) ptr,
+		.nr_req		= nr_req,
+		.nr_alloc	= nr_alloc,
+		.gfp_flags	= flags,
+	};
+
+	/*kmemtrace_log_event(&ev);*/
+	kmemtrace_log_string("ABCDEFGHIJKLMNOPQRSTUVWXYZa");
+}
+EXPORT_SYMBOL(kmemtrace_track_alloc);
+
+void kmemtrace_track_free(void *call_site, const void *ptr)
+{
+	struct kmemtrace_event ev = {
+		.event_id	= KMEM_FREE,
+		.call_site	= (uintptr_t) call_site,
+		.ptr		= (uintptr_t) ptr,
+	};
+
+	kmemtrace_log_event(&ev);
+}
+EXPORT_SYMBOL(kmemtrace_track_free);
+
+
+static struct dentry
+*kmemtrace_create_buf_file(const char *filename, struct dentry *parent,
+			   int mode, struct rchan_buf *buf, int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static int kmemtrace_remove_buf_file(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.create_buf_file = kmemtrace_create_buf_file,
+	.remove_buf_file = kmemtrace_remove_buf_file,
+};
+
+static struct dentry *kmemtrace_dir;
+
+static int __init kmemtrace_setup_late(void)
+{
+	if (!kmemtrace_chan)
+		goto failed;
+	
+	kmemtrace_dir = debugfs_create_dir("kmemtrace", NULL);
+	if (!kmemtrace_dir)
+		goto failed;
+
+	relay_late_setup_files(kmemtrace_chan, "cpu", kmemtrace_dir);
+
+	kmemtrace_log_string("Late setup ran!\n");
+
+	return 0;
+
+failed:
+	return 1;
+}
+late_initcall(kmemtrace_setup_late);
+
+int kmemtrace_is_inited __read_mostly = 0;
+EXPORT_SYMBOL(kmemtrace_is_inited);
+
+void kmemtrace_init(void)
+{
+	kmemtrace_chan = relay_open(NULL, NULL, KMEMTRACE_SUBBUF_SIZE,
+				    KMEMTRACE_NR_SUBBUFS, &relay_callbacks, 
+				    NULL);
+	if (!kmemtrace_chan) {
+		printk("kmemtrace: could not open relay channel\n");
+		return;
+	}
+
+	kmemtrace_is_inited = 1;
+}
+
