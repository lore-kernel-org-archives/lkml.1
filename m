Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYJNHHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYJNHHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJNHHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:07:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55319 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYJNHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:07:30 -0400
Date: Tue, 14 Oct 2008 10:07:27 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       eduard.munteanu@linux360.ro, mpm@selenic.com, tzanussi@gmail.com,
       cl@linux-foundation.org
Subject: [GIT PULL] kmemtrace for 2.6.28
Message-ID: <Pine.LNX.4.64.0810141006220.18474@sbz-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the kmemtrace topic branch from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git topic/kmemtrace

The purpose of kmemtrace is to provide kernel memory profiling tools to
developers for optimizing kernel memory usage and analyzing the memory
efficiency of the current SLUB and SLOB allocators. It has been written by
Eduard-Gabriel Munteanu as part of Google Summer of Code 2008.

The kmemtrace userspace tools are available at:

   git://repo.or.cz/kmemtrace-user.git

                Pekka

Eduard - Gabriel Munteanu (9):
      kmemtrace: Core implementation.
      kmemtrace: Additional documentation.
      kmemtrace: SLAB hooks.
      kmemtrace: SLOB hooks.
      SLUB: Replace __builtin_return_address(0) with _RET_IP_.
      kmemtrace: SLUB hooks.
      kmemtrace: Fix typos in documentation.
      kmemtrace: Better alternative to "kmemtrace: fix printk format warnings".
      kmemtrace: SLUB hooks for caller-tracking functions.

Pekka Enberg (3):
      kmemtrace: remove unnecessary casts
      kmemtrace: allow kmemtrace to be enabled after boot
      kmemtrace: remove config option for enabling tracing at boot

Tom Zanussi (1):
      relayfs: fix infinite loop with splice()

 Documentation/ABI/testing/debugfs-kmemtrace |   71 ++++++
 Documentation/kernel-parameters.txt         |   10 +
 Documentation/vm/kmemtrace.txt              |  126 ++++++++++
 MAINTAINERS                                 |    6 +
 include/linux/kmemtrace.h                   |   86 +++++++
 include/linux/slab.h                        |    8 +-
 include/linux/slab_def.h                    |   68 +++++-
 include/linux/slob_def.h                    |    9 +-
 include/linux/slub_def.h                    |   53 ++++-
 init/main.c                                 |    2 +
 kernel/relay.c                              |    7 +-
 lib/Kconfig.debug                           |   20 ++
 mm/Makefile                                 |    2 +-
 mm/kmemtrace.c                              |  333 +++++++++++++++++++++++++++
 mm/slab.c                                   |   79 ++++++-
 mm/slob.c                                   |   37 +++-
 mm/slub.c                                   |  123 ++++++++---
 17 files changed, 969 insertions(+), 71 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-kmemtrace b/Documentation/ABI/testing/debugfs-kmemtrace
new file mode 100644
index 0000000..5e6a92a
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-kmemtrace
@@ -0,0 +1,71 @@
+What:		/sys/kernel/debug/kmemtrace/
+Date:		July 2008
+Contact:	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
+Description:
+
+In kmemtrace-enabled kernels, the following files are created:
+
+/sys/kernel/debug/kmemtrace/
+	cpu<n>		(0400)	Per-CPU tracing data, see below. (binary)
+	total_overruns	(0400)	Total number of bytes which were dropped from
+				cpu<n> files because of full buffer condition,
+				non-binary. (text)
+	abi_version	(0400)	Kernel's kmemtrace ABI version. (text)
+
+Each per-CPU file should be read according to the relay interface. That is,
+the reader should set affinity to that specific CPU and, as currently done by
+the userspace application (though there are other methods), use poll() with
+an infinite timeout before every read(). Otherwise, erroneous data may be
+read. The binary data has the following _core_ format:
+
+	Event ID	(1 byte)	Unsigned integer, one of:
+		0 - represents an allocation (KMEMTRACE_EVENT_ALLOC)
+		1 - represents a freeing of previously allocated memory
+		    (KMEMTRACE_EVENT_FREE)
+	Type ID		(1 byte)	Unsigned integer, one of:
+		0 - this is a kmalloc() / kfree()
+		1 - this is a kmem_cache_alloc() / kmem_cache_free()
+		2 - this is a __get_free_pages() et al.
+	Event size	(2 bytes)	Unsigned integer representing the
+					size of this event. Used to extend
+					kmemtrace. Discard the bytes you
+					don't know about.
+	Sequence number	(4 bytes)	Signed integer used to reorder data
+					logged on SMP machines. Wraparound
+					must be taken into account, although
+					it is unlikely.
+	Caller address	(8 bytes)	Return address to the caller.
+	Pointer to mem	(8 bytes)	Pointer to target memory area. Can be
+					NULL, but not all such calls might be
+					recorded.
+
+In case of KMEMTRACE_EVENT_ALLOC events, the next fields follow:
+
+	Requested bytes	(8 bytes)	Total number of requested bytes,
+					unsigned, must not be zero.
+	Allocated bytes (8 bytes)	Total number of actually allocated
+					bytes, unsigned, must not be lower
+					than requested bytes.
+	Requested flags	(4 bytes)	GFP flags supplied by the caller.
+	Target CPU	(4 bytes)	Signed integer, valid for event id 1.
+					If equal to -1, target CPU is the same
+					as origin CPU, but the reverse might
+					not be true.
+
+The data is made available in the same endianness the machine has.
+
+Other event ids and type ids may be defined and added. Other fields may be
+added by increasing event size, but see below for details.
+Every modification to the ABI, including new id definitions, are followed
+by bumping the ABI version by one.
+
+Adding new data to the packet (features) is done at the end of the mandatory
+data:
+	Feature size	(2 byte)
+	Feature ID	(1 byte)
+	Feature data	(Feature size - 3 bytes)
+
+
+Users:
+	kmemtrace-user - git://repo.or.cz/kmemtrace-user.git
+
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1150444..10c59cb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -49,6 +49,7 @@ parameter is applicable:
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
+	KMEMTRACE kmemtrace is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
 	LOOP	Loopback device support is enabled.
@@ -1000,6 +1001,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+	kmemtrace.enable=	[KNL,KMEMTRACE] Format: { yes | no }
+				Controls whether kmemtrace is enabled
+				at boot-time.
+
+	kmemtrace.subbufs=n	[KNL,KMEMTRACE] Overrides the number of
+			subbufs kmemtrace's relay channel has. Set this
+			higher than default (KMEMTRACE_N_SUBBUFS in code) if
+			you experience buffer overruns.
+
 	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
 			is similar to kernelcore except it specifies the
 			amount of memory used for migratable allocations.
diff --git a/Documentation/vm/kmemtrace.txt b/Documentation/vm/kmemtrace.txt
new file mode 100644
index 0000000..a956d9b
--- /dev/null
+++ b/Documentation/vm/kmemtrace.txt
@@ -0,0 +1,126 @@
+			kmemtrace - Kernel Memory Tracer
+
+			  by Eduard - Gabriel Munteanu
+			     <eduard.munteanu@linux360.ro>
+
+I. Introduction
+===============
+
+kmemtrace helps kernel developers figure out two things:
+1) how different allocators (SLAB, SLUB etc.) perform
+2) how kernel code allocates memory and how much
+
+To do this, we trace every allocation and export information to the userspace
+through the relay interface. We export things such as the number of requested
+bytes, the number of bytes actually allocated (i.e. including internal
+fragmentation), whether this is a slab allocation or a plain kmalloc() and so
+on.
+
+The actual analysis is performed by a userspace tool (see section III for
+details on where to get it from). It logs the data exported by the kernel,
+processes it and (as of writing this) can provide the following information:
+- the total amount of memory allocated and fragmentation per call-site
+- the amount of memory allocated and fragmentation per allocation
+- total memory allocated and fragmentation in the collected dataset
+- number of cross-CPU allocation and frees (makes sense in NUMA environments)
+
+Moreover, it can potentially find inconsistent and erroneous behavior in
+kernel code, such as using slab free functions on kmalloc'ed memory or
+allocating less memory than requested (but not truly failed allocations).
+
+kmemtrace also makes provisions for tracing on some arch and analysing the
+data on another.
+
+II. Design and goals
+====================
+
+kmemtrace was designed to handle rather large amounts of data. Thus, it uses
+the relay interface to export whatever is logged to userspace, which then
+stores it. Analysis and reporting is done asynchronously, that is, after the
+data is collected and stored. By design, it allows one to log and analyse
+on different machines and different arches.
+
+As of writing this, the ABI is not considered stable, though it might not
+change much. However, no guarantees are made about compatibility yet. When
+deemed stable, the ABI should still allow easy extension while maintaining
+backward compatibility. This is described further in Documentation/ABI.
+
+Summary of design goals:
+	- allow logging and analysis to be done across different machines
+	- be fast and anticipate usage in high-load environments (*)
+	- be reasonably extensible
+	- make it possible for GNU/Linux distributions to have kmemtrace
+	included in their repositories
+
+(*) - one of the reasons Pekka Enberg's original userspace data analysis
+    tool's code was rewritten from Perl to C (although this is more than a
+    simple conversion)
+
+
+III. Quick usage guide
+======================
+
+1) Get a kernel that supports kmemtrace and build it accordingly (i.e. enable
+CONFIG_KMEMTRACE).
+
+2) Get the userspace tool and build it:
+$ git-clone git://repo.or.cz/kmemtrace-user.git		# current repository
+$ cd kmemtrace-user/
+$ ./autogen.sh
+$ ./configure
+$ make
+
+3) Boot the kmemtrace-enabled kernel if you haven't, preferably in the
+'single' runlevel (so that relay buffers don't fill up easily), and run
+kmemtrace:
+# '$' does not mean user, but root here.
+$ mount -t debugfs none /sys/kernel/debug
+$ mount -t proc none /proc
+$ cd path/to/kmemtrace-user/
+$ ./kmemtraced
+Wait a bit, then stop it with CTRL+C.
+$ cat /sys/kernel/debug/kmemtrace/total_overruns	# Check if we didn't
+							# overrun, should
+							# be zero.
+$ (Optionally) [Run kmemtrace_check separately on each cpu[0-9]*.out file to
+		check its correctness]
+$ ./kmemtrace-report
+
+Now you should have a nice and short summary of how the allocator performs.
+
+IV. FAQ and known issues
+========================
+
+Q: 'cat /sys/kernel/debug/kmemtrace/total_overruns' is non-zero, how do I fix
+this? Should I worry?
+A: If it's non-zero, this affects kmemtrace's accuracy, depending on how
+large the number is. You can fix it by supplying a higher
+'kmemtrace.subbufs=N' kernel parameter.
+---
+
+Q: kmemtrace_check reports errors, how do I fix this? Should I worry?
+A: This is a bug and should be reported. It can occur for a variety of
+reasons:
+	- possible bugs in relay code
+	- possible misuse of relay by kmemtrace
+	- timestamps being collected unorderly
+Or you may fix it yourself and send us a patch.
+---
+
+Q: kmemtrace_report shows many errors, how do I fix this? Should I worry?
+A: This is a known issue and I'm working on it. These might be true errors
+in kernel code, which may have inconsistent behavior (e.g. allocating memory
+with kmem_cache_alloc() and freeing it with kfree()). Pekka Enberg pointed
+out this behavior may work with SLAB, but may fail with other allocators.
+
+It may also be due to lack of tracing in some unusual allocator functions.
+
+We don't want bug reports regarding this issue yet.
+---
+
+V. See also
+===========
+
+Documentation/kernel-parameters.txt
+Documentation/ABI/testing/debugfs-kmemtrace
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..66651c9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2456,6 +2456,12 @@ M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 
+KMEMTRACE
+P:	Eduard - Gabriel Munteanu
+M:	eduard.munteanu@linux360.ro
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
new file mode 100644
index 0000000..5bea8ea
--- /dev/null
+++ b/include/linux/kmemtrace.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright (C) 2008 Eduard - Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#ifndef _LINUX_KMEMTRACE_H
+#define _LINUX_KMEMTRACE_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/marker.h>
+
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
+};
+
+#ifdef CONFIG_KMEMTRACE
+
+extern void kmemtrace_init(void);
+
+static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+					     unsigned long call_site,
+					     const void *ptr,
+					     size_t bytes_req,
+					     size_t bytes_alloc,
+					     gfp_t gfp_flags,
+					     int node)
+{
+	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
+		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
+		   type_id, call_site, (unsigned long) ptr,
+		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
+		   (unsigned long) gfp_flags, node);
+}
+
+static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+				       unsigned long call_site,
+				       const void *ptr)
+{
+	trace_mark(kmemtrace_free, "type_id %d call_site %lu ptr %lu",
+		   type_id, call_site, (unsigned long) ptr);
+}
+
+#else /* CONFIG_KMEMTRACE */
+
+static inline void kmemtrace_init(void)
+{
+}
+
+static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+					     unsigned long call_site,
+					     const void *ptr,
+					     size_t bytes_req,
+					     size_t bytes_alloc,
+					     gfp_t gfp_flags,
+					     int node)
+{
+}
+
+static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+				       unsigned long call_site,
+				       const void *ptr)
+{
+}
+
+#endif /* CONFIG_KMEMTRACE */
+
+static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
+					unsigned long call_site,
+					const void *ptr,
+					size_t bytes_req,
+					size_t bytes_alloc,
+					gfp_t gfp_flags)
+{
+	kmemtrace_mark_alloc_node(type_id, call_site, ptr,
+				  bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMEMTRACE_H */
+
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 5ff9676..27e7fb4 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -225,9 +225,9 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
  * request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
-extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
+extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
-	__kmalloc_track_caller(size, flags, __builtin_return_address(0))
+	__kmalloc_track_caller(size, flags, _RET_IP_)
 #else
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc(size, flags)
@@ -243,10 +243,10 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
  * allocation request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
-extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
+extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
-			__builtin_return_address(0))
+			_RET_IP_)
 #else
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node(size, flags, node)
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 39c3a5e..7555ce9 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -14,6 +14,7 @@
 #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
+#include <linux/kmemtrace.h>
 
 /* Size description struct for general caches. */
 struct cache_sizes {
@@ -28,8 +29,26 @@ extern struct cache_sizes malloc_sizes[];
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-static inline void *kmalloc(size_t size, gfp_t flags)
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags);
+extern size_t slab_buffer_size(struct kmem_cache *cachep);
+#else
+static __always_inline void *
+kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
 {
+	return kmem_cache_alloc(cachep, flags);
+}
+static inline size_t slab_buffer_size(struct kmem_cache *cachep)
+{
+	return 0;
+}
+#endif
+
+static __always_inline void *kmalloc(size_t size, gfp_t flags)
+{
+	struct kmem_cache *cachep;
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		int i = 0;
 
@@ -50,10 +69,17 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
-			return kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
-						flags);
+			cachep = malloc_sizes[i].cs_dmacachep;
+		else
 #endif
-		return kmem_cache_alloc(malloc_sizes[i].cs_cachep, flags);
+			cachep = malloc_sizes[i].cs_cachep;
+
+		ret = kmem_cache_alloc_notrace(cachep, flags);
+
+		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
+				     size, slab_buffer_size(cachep), flags);
+
+		return ret;
 	}
 	return __kmalloc(size, flags);
 }
@@ -62,8 +88,25 @@ found:
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
+					   gfp_t flags,
+					   int nodeid);
+#else
+static __always_inline void *
+kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
+			      gfp_t flags,
+			      int nodeid)
+{
+	return kmem_cache_alloc_node(cachep, flags, nodeid);
+}
+#endif
+
+static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
+	struct kmem_cache *cachep;
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		int i = 0;
 
@@ -84,11 +127,18 @@ static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
-			return kmem_cache_alloc_node(malloc_sizes[i].cs_dmacachep,
-						flags, node);
+			cachep = malloc_sizes[i].cs_dmacachep;
+		else
 #endif
-		return kmem_cache_alloc_node(malloc_sizes[i].cs_cachep,
-						flags, node);
+			cachep = malloc_sizes[i].cs_cachep;
+
+		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
+					  ret, size, slab_buffer_size(cachep),
+					  flags, node);
+
+		return ret;
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 59a3fa4..0ec00b3 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -3,14 +3,15 @@
 
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-static inline void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
+static __always_inline void *kmem_cache_alloc(struct kmem_cache *cachep,
+					      gfp_t flags)
 {
 	return kmem_cache_alloc_node(cachep, flags, -1);
 }
 
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __kmalloc_node(size, flags, node);
 }
@@ -23,12 +24,12 @@ static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
  * kmalloc is the normal method of allocating memory
  * in the kernel.
  */
-static inline void *kmalloc(size_t size, gfp_t flags)
+static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	return __kmalloc_node(size, flags, -1);
 }
 
-static inline void *__kmalloc(size_t size, gfp_t flags)
+static __always_inline void *__kmalloc(size_t size, gfp_t flags)
 {
 	return kmalloc(size, flags);
 }
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 2f5c16b..dc28432 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,6 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <linux/kmemtrace.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -204,13 +205,31 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags);
+#else
+static __always_inline void *
+kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
+{
+	return kmem_cache_alloc(s, gfpflags);
+}
+#endif
+
 static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 {
-	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
+	unsigned int order = get_order(size);
+	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
+			     size, PAGE_SIZE << order, flags);
+
+	return ret;
 }
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		if (size > PAGE_SIZE)
 			return kmalloc_large(size, flags);
@@ -221,7 +240,13 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 			if (!s)
 				return ZERO_SIZE_PTR;
 
-			return kmem_cache_alloc(s, flags);
+			ret = kmem_cache_alloc_notrace(s, flags);
+
+			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
+					     _THIS_IP_, ret,
+					     size, s->size, flags);
+
+			return ret;
 		}
 	}
 	return __kmalloc(size, flags);
@@ -231,8 +256,24 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
+					   gfp_t gfpflags,
+					   int node);
+#else
+static __always_inline void *
+kmem_cache_alloc_node_notrace(struct kmem_cache *s,
+			      gfp_t gfpflags,
+			      int node)
+{
+	return kmem_cache_alloc_node(s, gfpflags, node);
+}
+#endif
+
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
+	void *ret;
+
 	if (__builtin_constant_p(size) &&
 		size <= PAGE_SIZE && !(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
@@ -240,7 +281,13 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 		if (!s)
 			return ZERO_SIZE_PTR;
 
-		return kmem_cache_alloc_node(s, flags, node);
+		ret = kmem_cache_alloc_node_notrace(s, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _THIS_IP_, ret,
+					  size, s->size, flags, node);
+
+		return ret;
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff --git a/init/main.c b/init/main.c
index f6f7042..e391f6c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -66,6 +66,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
+#include <linux/kmemtrace.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
@@ -648,6 +649,7 @@ asmlinkage void __init start_kernel(void)
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	kmemtrace_init();
 	debug_objects_mem_init();
 	idr_init_cache();
 	setup_per_cpu_pageset();
diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..6a4d439 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1318,12 +1318,9 @@ static ssize_t relay_file_splice_read(struct file *in,
 		if (ret < 0)
 			break;
 		else if (!ret) {
-			if (spliced)
-				break;
-			if (flags & SPLICE_F_NONBLOCK) {
+			if (flags & SPLICE_F_NONBLOCK)
 				ret = -EAGAIN;
-				break;
-			}
+			break;
 		}
 
 		*ppos += ret;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0b50481..4cae48b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -743,6 +743,26 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
+config KMEMTRACE
+	bool "Kernel memory tracer (kmemtrace)"
+	depends on RELAY && DEBUG_FS && MARKERS
+	help
+	  kmemtrace provides tracing for slab allocator functions, such as
+	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
+	  data is then fed to the userspace application in order to analyse
+	  allocation hotspots, internal fragmentation and so on, making it
+	  possible to see how well an allocator performs, as well as debug
+	  and profile kernel code.
+
+	  This requires an userspace application to use. See
+	  Documentation/vm/kmemtrace.txt for more information.
+
+	  Saying Y will make the kernel somewhat larger and slower. However,
+	  if you disable kmemtrace at run-time or boot-time, the performance
+	  impact is minimal (depending on the arch the kernel is built for).
+
+	  If unsure, say N.
+
 menuconfig BUILD_DOCSRC
 	bool "Build targets in Documentation/ tree"
 	depends on HEADERS_CHECK
diff --git a/mm/Makefile b/mm/Makefile
index da4ccf0..7f42d55 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -34,4 +34,4 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
-
+obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
diff --git a/mm/kmemtrace.c b/mm/kmemtrace.c
new file mode 100644
index 0000000..f7704f5
--- /dev/null
+++ b/mm/kmemtrace.c
@@ -0,0 +1,333 @@
+/*
+ * Copyright (C) 2008 Pekka Enberg, Eduard - Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#include <linux/string.h>
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/gfp.h>
+#include <linux/kmemtrace.h>
+
+#define KMEMTRACE_SUBBUF_SIZE		524288
+#define KMEMTRACE_DEF_N_SUBBUFS		20
+
+static struct rchan *kmemtrace_chan;
+static u32 kmemtrace_buf_overruns;
+
+static unsigned int kmemtrace_n_subbufs;
+
+/* disabled by default */
+static unsigned int kmemtrace_enabled;
+
+/*
+ * The sequence number is used for reordering kmemtrace packets
+ * in userspace, since they are logged as per-CPU data.
+ *
+ * atomic_t should always be a 32-bit signed integer. Wraparound is not
+ * likely to occur, but userspace can deal with it by expecting a certain
+ * sequence number in the next packet that will be read.
+ */
+static atomic_t kmemtrace_seq_num;
+
+#define KMEMTRACE_ABI_VERSION		1
+
+static u32 kmemtrace_abi_version __read_mostly = KMEMTRACE_ABI_VERSION;
+
+enum kmemtrace_event_id {
+	KMEMTRACE_EVENT_ALLOC = 0,
+	KMEMTRACE_EVENT_FREE,
+};
+
+struct kmemtrace_event {
+	u8		event_id;
+	u8		type_id;
+	u16		event_size;
+	s32		seq_num;
+	u64		call_site;
+	u64		ptr;
+} __attribute__ ((__packed__));
+
+struct kmemtrace_stats_alloc {
+	u64		bytes_req;
+	u64		bytes_alloc;
+	u32		gfp_flags;
+	s32		numa_node;
+} __attribute__ ((__packed__));
+
+static void kmemtrace_probe_alloc(void *probe_data, void *call_data,
+				  const char *format, va_list *args)
+{
+	unsigned long flags;
+	struct kmemtrace_event *ev;
+	struct kmemtrace_stats_alloc *stats;
+	void *buf;
+
+	local_irq_save(flags);
+
+	buf = relay_reserve(kmemtrace_chan,
+			    sizeof(struct kmemtrace_event) +
+			    sizeof(struct kmemtrace_stats_alloc));
+	if (!buf)
+		goto failed;
+
+	/*
+	 * Don't convert this to use structure initializers,
+	 * C99 does not guarantee the rvalues evaluation order.
+	 */
+
+	ev = buf;
+	ev->event_id = KMEMTRACE_EVENT_ALLOC;
+	ev->type_id = va_arg(*args, int);
+	ev->event_size = sizeof(struct kmemtrace_event) +
+			 sizeof(struct kmemtrace_stats_alloc);
+	ev->seq_num = atomic_add_return(1, &kmemtrace_seq_num);
+	ev->call_site = va_arg(*args, unsigned long);
+	ev->ptr = va_arg(*args, unsigned long);
+
+	stats = buf + sizeof(struct kmemtrace_event);
+	stats->bytes_req = va_arg(*args, unsigned long);
+	stats->bytes_alloc = va_arg(*args, unsigned long);
+	stats->gfp_flags = va_arg(*args, unsigned long);
+	stats->numa_node = va_arg(*args, int);
+
+failed:
+	local_irq_restore(flags);
+}
+
+static void kmemtrace_probe_free(void *probe_data, void *call_data,
+				 const char *format, va_list *args)
+{
+	unsigned long flags;
+	struct kmemtrace_event *ev;
+
+	local_irq_save(flags);
+
+	ev = relay_reserve(kmemtrace_chan, sizeof(struct kmemtrace_event));
+	if (!ev)
+		goto failed;
+
+	/*
+	 * Don't convert this to use structure initializers,
+	 * C99 does not guarantee the rvalues evaluation order.
+	 */
+	ev->event_id = KMEMTRACE_EVENT_FREE;
+	ev->type_id = va_arg(*args, int);
+	ev->event_size = sizeof(struct kmemtrace_event);
+	ev->seq_num = atomic_add_return(1, &kmemtrace_seq_num);
+	ev->call_site = va_arg(*args, unsigned long);
+	ev->ptr = va_arg(*args, unsigned long);
+
+failed:
+	local_irq_restore(flags);
+}
+
+static struct dentry *
+kmemtrace_create_buf_file(const char *filename, struct dentry *parent,
+			  int mode, struct rchan_buf *buf, int *is_global)
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
+static int kmemtrace_subbuf_start(struct rchan_buf *buf,
+				  void *subbuf,
+				  void *prev_subbuf,
+				  size_t prev_padding)
+{
+	if (relay_buf_full(buf)) {
+		/*
+		 * We know it's not SMP-safe, but neither
+		 * debugfs_create_u32() is.
+		 */
+		kmemtrace_buf_overruns++;
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.create_buf_file = kmemtrace_create_buf_file,
+	.remove_buf_file = kmemtrace_remove_buf_file,
+	.subbuf_start = kmemtrace_subbuf_start,
+};
+
+static struct dentry *kmemtrace_dir;
+static struct dentry *kmemtrace_overruns_dentry;
+static struct dentry *kmemtrace_abi_version_dentry;
+
+static struct dentry *kmemtrace_enabled_dentry;
+
+static int kmemtrace_start_probes(void)
+{
+	int err;
+
+	err = marker_probe_register("kmemtrace_alloc", "type_id %d "
+				    "call_site %lu ptr %lu "
+				    "bytes_req %lu bytes_alloc %lu "
+				    "gfp_flags %lu node %d",
+				    kmemtrace_probe_alloc, NULL);
+	if (err)
+		return err;
+	err = marker_probe_register("kmemtrace_free", "type_id %d "
+				    "call_site %lu ptr %lu",
+				    kmemtrace_probe_free, NULL);
+
+	return err;
+}
+
+static void kmemtrace_stop_probes(void)
+{
+	marker_probe_unregister("kmemtrace_alloc",
+				kmemtrace_probe_alloc, NULL);
+	marker_probe_unregister("kmemtrace_free",
+				kmemtrace_probe_free, NULL);
+}
+
+static int kmemtrace_enabled_get(void *data, u64 *val)
+{
+	*val = *((int *) data);
+
+	return 0;
+}
+
+static int kmemtrace_enabled_set(void *data, u64 val)
+{
+	u64 old_val = kmemtrace_enabled;
+
+	*((int *) data) = !!val;
+
+	if (old_val == val)
+		return 0;
+	if (val)
+		kmemtrace_start_probes();
+	else
+		kmemtrace_stop_probes();
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(kmemtrace_enabled_fops,
+			kmemtrace_enabled_get,
+			kmemtrace_enabled_set, "%llu\n");
+
+static void kmemtrace_cleanup(void)
+{
+	if (kmemtrace_enabled_dentry)
+		debugfs_remove(kmemtrace_enabled_dentry);
+
+	kmemtrace_stop_probes();
+
+	if (kmemtrace_abi_version_dentry)
+		debugfs_remove(kmemtrace_abi_version_dentry);
+	if (kmemtrace_overruns_dentry)
+		debugfs_remove(kmemtrace_overruns_dentry);
+
+	relay_close(kmemtrace_chan);
+	kmemtrace_chan = NULL;
+
+	if (kmemtrace_dir)
+		debugfs_remove(kmemtrace_dir);
+}
+
+static int __init kmemtrace_setup_late(void)
+{
+	if (!kmemtrace_chan)
+		goto failed;
+
+	kmemtrace_dir = debugfs_create_dir("kmemtrace", NULL);
+	if (!kmemtrace_dir)
+		goto cleanup;
+
+	kmemtrace_abi_version_dentry =
+		debugfs_create_u32("abi_version", S_IRUSR,
+				   kmemtrace_dir, &kmemtrace_abi_version);
+	kmemtrace_overruns_dentry =
+		debugfs_create_u32("total_overruns", S_IRUSR,
+				   kmemtrace_dir, &kmemtrace_buf_overruns);
+	if (!kmemtrace_overruns_dentry || !kmemtrace_abi_version_dentry)
+		goto cleanup;
+
+	kmemtrace_enabled_dentry =
+		debugfs_create_file("enabled", S_IRUSR | S_IWUSR,
+				    kmemtrace_dir, &kmemtrace_enabled,
+				    &kmemtrace_enabled_fops);
+	if (!kmemtrace_enabled_dentry)
+		goto cleanup;
+
+	if (relay_late_setup_files(kmemtrace_chan, "cpu", kmemtrace_dir))
+		goto cleanup;
+
+	printk(KERN_INFO "kmemtrace: fully up.\n");
+
+	return 0;
+
+cleanup:
+	kmemtrace_cleanup();
+failed:
+	return 1;
+}
+late_initcall(kmemtrace_setup_late);
+
+static int __init kmemtrace_set_boot_enabled(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "yes"))
+		kmemtrace_enabled = 1;
+	else if (!strcmp(str, "no"))
+		kmemtrace_enabled = 0;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kmemtrace.enable", kmemtrace_set_boot_enabled);
+
+static int __init kmemtrace_set_subbufs(char *str)
+{
+	get_option(&str, &kmemtrace_n_subbufs);
+	return 0;
+}
+early_param("kmemtrace.subbufs", kmemtrace_set_subbufs);
+
+void kmemtrace_init(void)
+{
+	if (!kmemtrace_n_subbufs)
+		kmemtrace_n_subbufs = KMEMTRACE_DEF_N_SUBBUFS;
+
+	kmemtrace_chan = relay_open(NULL, NULL, KMEMTRACE_SUBBUF_SIZE,
+				    kmemtrace_n_subbufs, &relay_callbacks,
+				    NULL);
+	if (!kmemtrace_chan) {
+		printk(KERN_ERR "kmemtrace: could not open relay channel.\n");
+		return;
+	}
+
+	if (!kmemtrace_enabled) {
+		printk(KERN_INFO "kmemtrace: disabled. Pass "
+			"kemtrace.enable=yes as kernel parameter for "
+			"boot-time tracing.");
+		return;
+	}
+	if (kmemtrace_start_probes()) {
+		printk(KERN_ERR "kmemtrace: could not register marker probes!\n");
+		kmemtrace_cleanup();
+		return;
+	}
+
+	printk(KERN_INFO "kmemtrace: enabled.\n");
+}
+
diff --git a/mm/slab.c b/mm/slab.c
index e76eee4..4f4a704 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -111,6 +111,7 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
+#include	<linux/kmemtrace.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -567,6 +568,14 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 
 #endif
 
+#ifdef CONFIG_KMEMTRACE
+size_t slab_buffer_size(struct kmem_cache *cachep)
+{
+	return cachep->buffer_size;
+}
+EXPORT_SYMBOL(slab_buffer_size);
+#endif
+
 /*
  * Do not go above this order unless 0 objects fit into the slab.
  */
@@ -3612,10 +3621,23 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
  */
 void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
-	return __cache_alloc(cachep, flags, __builtin_return_address(0));
+	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			     obj_size(cachep), cachep->buffer_size, flags);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
+{
+	return __cache_alloc(cachep, flags, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(kmem_cache_alloc_notrace);
+#endif
+
 /**
  * kmem_ptr_validate - check if an untrusted pointer might be a slab entry.
  * @cachep: the cache we're checking against
@@ -3660,23 +3682,47 @@ out:
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 {
-	return __cache_alloc_node(cachep, flags, nodeid,
-			__builtin_return_address(0));
+	void *ret = __cache_alloc_node(cachep, flags, nodeid,
+				       __builtin_return_address(0));
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+				  obj_size(cachep), cachep->buffer_size,
+				  flags, nodeid);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
+				    gfp_t flags,
+				    int nodeid)
+{
+	return __cache_alloc_node(cachep, flags, nodeid,
+				  __builtin_return_address(0));
+}
+EXPORT_SYMBOL(kmem_cache_alloc_node_notrace);
+#endif
+
 static __always_inline void *
 __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 {
 	struct kmem_cache *cachep;
+	void *ret;
 
 	cachep = kmem_find_general_cachep(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	return kmem_cache_alloc_node(cachep, flags, node);
+	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+				  (unsigned long) caller, ret,
+				  size, cachep->buffer_size, flags, node);
+
+	return ret;
 }
 
-#ifdef CONFIG_DEBUG_SLAB
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __do_kmalloc_node(size, flags, node,
@@ -3685,9 +3731,9 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 EXPORT_SYMBOL(__kmalloc_node);
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t flags,
-		int node, void *caller)
+		int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, flags, node, caller);
+	return __do_kmalloc_node(size, flags, node, (void *)caller);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #else
@@ -3709,6 +3755,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 					  void *caller)
 {
 	struct kmem_cache *cachep;
+	void *ret;
 
 	/* If you want to save a few bytes .text space: replace
 	 * __ with kmem_.
@@ -3718,20 +3765,26 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 	cachep = __find_general_cachep(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	return __cache_alloc(cachep, flags, caller);
+	ret = __cache_alloc(cachep, flags, caller);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
+			     (unsigned long) caller, ret,
+			     size, cachep->buffer_size, flags);
+
+	return ret;
 }
 
 
-#ifdef CONFIG_DEBUG_SLAB
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	return __do_kmalloc(size, flags, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kmalloc);
 
-void *__kmalloc_track_caller(size_t size, gfp_t flags, void *caller)
+void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
 {
-	return __do_kmalloc(size, flags, caller);
+	return __do_kmalloc(size, flags, (void *)caller);
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
@@ -3761,6 +3814,8 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 		debug_check_no_obj_freed(objp, obj_size(cachep));
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3787,6 +3842,8 @@ void kfree(const void *objp)
 	debug_check_no_obj_freed(objp, obj_size(c));
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index 4c82dd4..531b212 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -65,6 +65,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
+#include <linux/kmemtrace.h>
 #include <asm/atomic.h>
 
 /*
@@ -463,27 +464,38 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	void *ret;
 
 	if (size < PAGE_SIZE - align) {
 		if (!size)
 			return ZERO_SIZE_PTR;
 
 		m = slob_alloc(size + align, gfp, align, node);
+
 		if (!m)
 			return NULL;
 		*m = size;
-		return (void *)m + align;
+		ret = (void *)m + align;
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _RET_IP_, ret,
+					  size, size + align, gfp, node);
 	} else {
-		void *ret;
+		unsigned int order = get_order(size);
 
-		ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
+		ret = slob_new_page(gfp | __GFP_COMP, order, node);
 		if (ret) {
 			struct page *page;
 			page = virt_to_page(ret);
 			page->private = size;
 		}
-		return ret;
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _RET_IP_, ret,
+					  size, PAGE_SIZE << order, gfp, node);
 	}
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
@@ -501,6 +513,8 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else
 		put_page(&sp->page);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -567,10 +581,19 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 {
 	void *b;
 
-	if (c->size < PAGE_SIZE)
+	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-	else
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
+					  _RET_IP_, b, c->size,
+					  SLOB_UNITS(c->size) * SLOB_UNIT,
+					  flags, node);
+	} else {
 		b = slob_new_page(flags, get_order(c->size), node);
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
+					  _RET_IP_, b, c->size,
+					  PAGE_SIZE << get_order(c->size),
+					  flags, node);
+	}
 
 	if (c->ctor)
 		c->ctor(b);
@@ -606,6 +629,8 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 	} else {
 		__kmem_cache_free(b, c->size);
 	}
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index 0c83e6a..954a251 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/kmemtrace.h>
 
 /*
  * Lock order:
@@ -177,7 +178,7 @@ static LIST_HEAD(slab_caches);
  * Tracking user of a slab.
  */
 struct track {
-	void *addr;		/* Called from address */
+	unsigned long addr;	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -366,7 +367,7 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 static void set_track(struct kmem_cache *s, void *object,
-				enum track_item alloc, void *addr)
+			enum track_item alloc, unsigned long addr)
 {
 	struct track *p;
 
@@ -390,8 +391,8 @@ static void init_tracking(struct kmem_cache *s, void *object)
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	set_track(s, object, TRACK_FREE, NULL);
-	set_track(s, object, TRACK_ALLOC, NULL);
+	set_track(s, object, TRACK_FREE, 0UL);
+	set_track(s, object, TRACK_ALLOC, 0UL);
 }
 
 static void print_track(const char *s, struct track *t)
@@ -400,7 +401,7 @@ static void print_track(const char *s, struct track *t)
 		return;
 
 	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, t->addr, jiffies - t->when, t->cpu, t->pid);
+		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
 }
 
 static void print_tracking(struct kmem_cache *s, void *object)
@@ -865,7 +866,7 @@ static void setup_object_debug(struct kmem_cache *s, struct page *page,
 }
 
 static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto bad;
@@ -905,7 +906,7 @@ bad:
 }
 
 static int free_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -1028,10 +1029,10 @@ static inline void setup_object_debug(struct kmem_cache *s,
 			struct page *page, void *object) {}
 
 static inline int alloc_debug_processing(struct kmem_cache *s,
-	struct page *page, void *object, void *addr) { return 0; }
+	struct page *page, void *object, unsigned long addr) { return 0; }
 
 static inline int free_debug_processing(struct kmem_cache *s,
-	struct page *page, void *object, void *addr) { return 0; }
+	struct page *page, void *object, unsigned long addr) { return 0; }
 
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 			{ return 1; }
@@ -1498,8 +1499,8 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
  * we need to allocate a new slab. This is the slowest path since it involves
  * a call to the page allocator and the setup of a new slab.
  */
-static void *__slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
+static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
+			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void **object;
 	struct page *new;
@@ -1583,7 +1584,7 @@ debug:
  * Otherwise we can simply pick the next object from the lockless free list.
  */
 static __always_inline void *slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr)
+		gfp_t gfpflags, int node, unsigned long addr)
 {
 	void **object;
 	struct kmem_cache_cpu *c;
@@ -1612,18 +1613,46 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			     s->objsize, s->size, gfpflags);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
+{
+	return slab_alloc(s, gfpflags, -1, _RET_IP_);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_notrace);
+#endif
+
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+				  s->objsize, s->size, gfpflags, node);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
+				    gfp_t gfpflags,
+				    int node)
+{
+	return slab_alloc(s, gfpflags, node, _RET_IP_);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_node_notrace);
+#endif
+
 /*
  * Slow patch handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
@@ -1633,7 +1662,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-				void *x, void *addr, unsigned int offset)
+			void *x, unsigned long addr, unsigned int offset)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1703,7 +1732,7 @@ debug:
  * with all sorts of special processing.
  */
 static __always_inline void slab_free(struct kmem_cache *s,
-			struct page *page, void *x, void *addr)
+			struct page *page, void *x, unsigned long addr)
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
@@ -1730,7 +1759,9 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	page = virt_to_head_page(x);
 
-	slab_free(s, page, x, __builtin_return_address(0));
+	slab_free(s, page, x, _RET_IP_);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2649,6 +2680,7 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large(size, flags);
@@ -2658,7 +2690,12 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	ret = slab_alloc(s, flags, -1, _RET_IP_);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
+			     size, s->size, flags);
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2677,16 +2714,30 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
+	void *ret;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, flags, node);
+	if (unlikely(size > PAGE_SIZE)) {
+		ret = kmalloc_large_node(size, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _RET_IP_, ret,
+					  size, PAGE_SIZE << get_order(size),
+					  flags, node);
+
+		return ret;
+	}
 
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	ret = slab_alloc(s, flags, node, _RET_IP_);
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
+				  size, s->size, flags, node);
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2743,7 +2794,9 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, object, __builtin_return_address(0));
+	slab_free(page->slab, page, object, _RET_IP_);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3199,9 +3252,10 @@ static struct notifier_block __cpuinitdata slab_notifier = {
 
 #endif
 
-void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
+void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large(size, gfpflags);
@@ -3211,13 +3265,20 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, gfpflags, -1, caller);
+	ret = slab_alloc(s, gfpflags, -1, caller);
+
+	/* Honor the call site pointer we recieved. */
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
+			     s->size, gfpflags);
+
+	return ret;
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
-					int node, void *caller)
+					int node, unsigned long caller)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large_node(size, gfpflags, node);
@@ -3227,7 +3288,13 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, gfpflags, node, caller);
+	ret = slab_alloc(s, gfpflags, node, caller);
+
+	/* Honor the call site pointer we recieved. */
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
+				  size, s->size, gfpflags, node);
+
+	return ret;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -3426,7 +3493,7 @@ static void resiliency_test(void) {};
 
 struct location {
 	unsigned long count;
-	void *addr;
+	unsigned long addr;
 	long long sum_time;
 	long min_time;
 	long max_time;
@@ -3474,7 +3541,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 {
 	long start, end, pos;
 	struct location *l;
-	void *caddr;
+	unsigned long caddr;
 	unsigned long age = jiffies - track->when;
 
 	start = -1;
