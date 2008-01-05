Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYAEQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYAEQVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYAEQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:21:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58378 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYAEQVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:21:23 -0500
Date: Sat, 5 Jan 2008 18:21:10 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zanussi@us.ibm.com
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <1199419890.4608.77.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
 <1199419890.4608.77.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, 3 Jan 2008, Matt Mackall wrote:
> >  SLUB can align these without a 2 byte 
> > overhead. In some configurations this results in SLUB using even less 
> > memory than SLOB. See f.e. Pekka's test at 
> > http://marc.info/?l=linux-kernel&m=118405559214029&w=2
> 
> Available memory after boot is not a particularly stable measurement and
> not valid if there's memory pressure. At any rate, I wasn't able to
> reproduce this.

So, I have this silly memory profiler derived from the kleak patches by 
the relayfs people and would love to try it out on an embedded workload 
where SLUB memory footprint is terrible. Any suggestions?

			Pekka

---
 Documentation/kmemprof/Makefile    |    5 +
 Documentation/kmemprof/kmemprof.c  |  136 +++++++++++++++++++++++++++++++++++++
 Documentation/kmemprof/kmemprof.pl |  125 ++++++++++++++++++++++++++++++++++
 include/linux/slab.h               |   16 ++++
 include/linux/slub_def.h           |   27 +++++--
 lib/Kconfig.debug                  |    8 ++
 mm/Makefile                        |    2 
 mm/kmemprof.c                      |  124 +++++++++++++++++++++++++++++++++
 mm/slub.c                          |   34 +++++++--
 9 files changed, 463 insertions(+), 14 deletions(-)

Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug	2008-01-05 12:13:46.000000000 +0200
+++ linux-2.6/lib/Kconfig.debug	2008-01-05 18:11:53.000000000 +0200
@@ -173,6 +173,14 @@
 	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
 	  "slub_debug=-".
 
+config KMEMPROF
+	bool "Kernel memory profiling support"
+	depends on SLUB
+	default n
+	help
+	  Say Y here to have the kernel track every memory allocation in
+	  the kernel.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2008-01-05 12:13:46.000000000 +0200
+++ linux-2.6/mm/Makefile	2008-01-05 18:12:12.000000000 +0200
@@ -30,4 +30,4 @@
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-
+obj-$(CONFIG_KMEMPROF) += kmemprof.o
Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2008-01-05 12:13:46.000000000 +0200
+++ linux-2.6/include/linux/slab.h	2008-01-05 18:13:12.000000000 +0200
@@ -95,6 +95,22 @@
 void kfree(const void *);
 size_t ksize(const void *);
 
+#ifdef CONFIG_KMEMPROF
+void kmem_track_alloc(void *, const void *, unsigned long, unsigned long, gfp_t);
+void kmem_track_free(void *, const void *);
+#else
+static inline void kmem_track_alloc(void *call_site, const void *p,
+				    unsigned long nr_req,
+				    unsigned long nr_allocated,
+				    gfp_t flags)
+{
+}
+
+static inline void kmem_track_free(void *call_site, const void *p)
+{
+}
+#endif /* CONFIG_KMEMPROF */
+
 /*
  * Allocator specific definitions. These are mainly used to establish optimized
  * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2008-01-05 12:13:46.000000000 +0200
+++ linux-2.6/include/linux/slub_def.h	2008-01-05 12:14:15.000000000 +0200
@@ -162,20 +162,37 @@
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
+static __always_inline void *__kmalloc_pagealloc(size_t size, gfp_t flags)
+{
+	unsigned long order = get_order(size);
+	void *p;
+
+	p = (void *)__get_free_pages(flags | __GFP_COMP, order);
+	kmem_track_alloc(__builtin_return_address(0), p, size,
+			 PAGE_SIZE << order, flags);
+	return p;
+}
+
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
 		if (size > PAGE_SIZE / 2)
-			return (void *)__get_free_pages(flags | __GFP_COMP,
-							get_order(size));
+			return __kmalloc_pagealloc(size, flags);
 
 		if (!(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
+			void *p;
 
-			if (!s)
+			if (!s) {
+				kmem_track_alloc(__builtin_return_address(0),
+						 ZERO_SIZE_PTR, size, 0,
+						 flags);
 				return ZERO_SIZE_PTR;
-
-			return kmem_cache_alloc(s, flags);
+			}
+			p = kmem_cache_alloc(s, flags);
+			kmem_track_alloc(__builtin_return_address(0), p, size,
+					 s->size, flags);
+			return p;
 		}
 	}
 	return __kmalloc(size, flags);
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-01-05 12:13:46.000000000 +0200
+++ linux-2.6/mm/slub.c	2008-01-05 15:45:12.000000000 +0200
@@ -1566,14 +1566,22 @@
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	void *p;
+
+	p = slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	kmem_track_alloc(__builtin_return_address(0), p, s->size, s->size, gfpflags);
+	return p;
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	void *p;
+
+	p = slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	kmem_track_alloc(__builtin_return_address(0), p, s->size, s->size, gfpflags);
+	return p;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1670,6 +1678,8 @@
 {
 	struct page *page;
 
+	kmem_track_free(__builtin_return_address(0), x);
+
 	page = virt_to_head_page(x);
 
 	slab_free(s, page, x, __builtin_return_address(0));
@@ -2516,17 +2526,20 @@
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
+	void *p;
 
 	if (unlikely(size > PAGE_SIZE / 2))
-		return (void *)__get_free_pages(flags | __GFP_COMP,
-							get_order(size));
+		return __kmalloc_pagealloc(size, flags);
 
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	p = slab_alloc(s, flags, -1, __builtin_return_address(0));
+	kmem_track_alloc(__builtin_return_address(0), p, size, s->size,
+			 flags);
+	return p;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2534,17 +2547,20 @@
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
+	void *p;
 
 	if (unlikely(size > PAGE_SIZE / 2))
-		return (void *)__get_free_pages(flags | __GFP_COMP,
-							get_order(size));
+		return __kmalloc_pagealloc(size, flags);
 
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	p = slab_alloc(s, flags, node, __builtin_return_address(0));
+	kmem_track_alloc(__builtin_return_address(0), p, size, s->size,
+			 flags);
+	return p;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2593,6 +2609,8 @@
 {
 	struct page *page;
 
+	kmem_track_free(__builtin_return_address(0), x);
+
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
Index: linux-2.6/Documentation/kmemprof/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/kmemprof/Makefile	2008-01-05 18:11:25.000000000 +0200
@@ -0,0 +1,5 @@
+default:
+	$(CC) -lpthread -Wall kmemprof.c -o kmemprof
+
+clean:
+	rm -rf kmemprof cpu*.out kmemprof.all
Index: linux-2.6/Documentation/kmemprof/kmemprof.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/kmemprof/kmemprof.c	2008-01-05 18:11:33.000000000 +0200
@@ -0,0 +1,136 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <pthread.h>
+#include <poll.h>
+#include <signal.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+static void panic(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vprintf(fmt, args);
+	va_end(args);
+	exit(EXIT_FAILURE);
+}
+
+static void write_str(const char *filename, const char *value)
+{
+	int fd;
+
+	fd = open(filename, O_RDWR);
+	if (fd < 0)
+		panic("Could not open() file %s: %s\n", filename, strerror(errno));
+
+	if (write(fd, value, strlen(value)) < 0)
+		panic("Could not write() to file %s: %s\n", filename, strerror(errno));
+
+	close(fd);
+}
+
+static int open_channel(int cpu)
+{
+	char filename[PATH_MAX];
+	int fd;
+
+	sprintf(filename, "/debug/kmemprof/cpu%d", cpu);
+	fd = open(filename, O_RDONLY | O_NONBLOCK);
+	if (fd < 0)
+		panic("Could not open() file %s: %s\n", filename, strerror(errno));
+	return fd;
+}
+
+static int open_log(int cpu)
+{
+	char filename[PATH_MAX];
+	int fd;
+
+	sprintf(filename, "cpu%d.out", cpu);
+	fd = open(filename, O_CREAT | O_RDWR | O_TRUNC,
+			S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+	if (fd < 0)
+		panic("Could not open() file %s: %s\n", filename, strerror(errno));
+	return fd;
+}
+
+static void *reader_thread(void *data)
+{
+	unsigned long cpu = (unsigned long) data;
+	struct pollfd pollfd;
+	int relay_fd, log_fd;
+	char buf[4096];
+	int retval;
+
+	relay_fd = open_channel(cpu);
+	log_fd = open_log(cpu);
+
+	do {
+		pollfd.fd = relay_fd;
+		pollfd.events = POLLIN;
+		retval = poll(&pollfd, 1, 1);
+		if (retval < 0)
+			panic("poll() failed: %s\n", strerror(errno));
+
+		retval = read(relay_fd, buf, 4096);
+		if (!retval)
+			continue;
+		if (retval < 0) {
+			if (errno == EAGAIN)
+				continue;
+			perror("read");
+			break;
+		}
+		if (write(log_fd, buf, retval) < 0)
+			panic("Could not write() for cpu %lu: %s\n", cpu, strerror(errno));
+	} while (1);
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long nr_cpus;
+	pthread_t *readers;
+	sigset_t signals;
+	unsigned long i;
+	int signal;
+
+	sigemptyset(&signals);
+	sigaddset(&signals, SIGINT);
+	sigaddset(&signals, SIGTERM);
+	pthread_sigmask(SIG_BLOCK, &signals, NULL);
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+
+	readers = calloc(1, nr_cpus);
+	if (!readers)
+		panic("out of memory\n");
+
+	for (i = 0; i < nr_cpus; i++) {
+		int err;
+
+		err = pthread_create(&readers[i], NULL, reader_thread,
+				(void *) i);
+		if (err)
+			panic("Could not pthread_create(): %s\n", strerror(errno));
+	}
+
+	write_str("/debug/kmemprof/enabled", "1");
+	printf("Logging... Press Control-C to stop.\n");
+
+	while (sigwait(&signals, &signal) == 0) {
+		if (signal == SIGINT || signal == SIGTERM)
+			break;
+	}
+	write_str("/debug/kmemprof/enabled", "0");
+
+	return EXIT_SUCCESS;
+}
Index: linux-2.6/Documentation/kmemprof/kmemprof.pl
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/kmemprof/kmemprof.pl	2008-01-05 18:11:25.000000000 +0200
@@ -0,0 +1,125 @@
+#!/usr/bin/perl
+
+$tracefile = "kmemprof.all";
+$symbolfile = "/proc/kallsyms";
+
+my $nr_allocs;
+my $nr_frees;
+
+use constant KMALLOC_ID => 0x1;
+use constant KFREE_ID => 0x2;
+
+open(SYMBOLFILE, $symbolfile) or die "can't open $symbolfile: $!";
+while (<SYMBOLFILE>) {
+    chomp;
+    @fields = split;
+    $symbols{hex $fields[0]} = $fields[2];
+}
+@sorted_keys = sort(keys(%symbols));
+
+system("cat cpu* > $tracefile");
+open(TRACEFILE, $tracefile) or die "can't open $tracefile: $!";
+binmode($tracefile);
+while (read(TRACEFILE, $buf, 8)) {
+    ($eventid) = unpack("C", $buf);
+    read(TRACEFILE, $buf, 40);
+    if ($eventid == KMALLOC_ID) {
+	($caller, $addr, $nr_req, $nr_alloc) = unpack("QQQQ", $buf);
+#	printf("%x %x %x %d %d\n", $eventid, $addr, $caller, $nr_req, $nr_alloc);
+	$nr_allocs++;
+	$bytes_requested+=$nr_req;
+	$bytes_allocated+=$nr_alloc;
+	$nr_allocs_by_caller{$caller}++;
+	$nr_bytes_requested_by_caller{$caller}+=$nr_req;
+	$nr_bytes_allocated_by_caller{$caller}+=$nr_alloc;
+	$nr_bytes_wasted_by_caller{$caller}+=($nr_alloc-$nr_req);
+	$alloc_addrs{$addr} = $caller;
+    } else {
+	($caller, $addr) = unpack("QQ", $buf);
+#	printf("%x %x %x %d %d\n", $eventid, $addr, $caller, $objsize);
+	$nr_frees++;
+	$nr_frees_by_caller{$caller}++;
+	$nr_bytes_freed_by_caller{$caller}+=0;
+	$free_addrs{$addr} = $caller;
+    }
+}
+summarize();
+
+sub lookup_symbol {
+    my ($caller) = @_;
+    $symbol = $cached_callers{$caller};
+    if ($symbol) {
+	return $symbol;
+    }
+    for($i = 0; $i < scalar(@sorted_keys) - 1; $i++) {
+	if (($caller >= $sorted_keys[$i]) && ($caller <= $sorted_keys[$i+1])) {
+	    $symbol = sprintf("%s+0x%x", $symbols{$sorted_keys[$i]}, $offset);
+	    $cached_callers{$caller} = $symbol;
+	    $offset = $caller - $sorted_keys[$i];
+	    break;
+	}
+    }
+    if (!$symbol) {
+	$symbol = "unknown";
+    }
+
+    return $symbol;
+}
+
+sub summarize {
+    print "Total number of allocations: $nr_allocs\n";
+    print "Total number of frees: $nr_frees\n";
+
+    print "\nTotal bytes requested: $bytes_requested [$bytes_allocated allocated]\n";
+    printf("Total bytes wasted: %d\n", $bytes_allocated-$bytes_requested);
+
+    print "\nTotal number of allocations by caller:\n";
+    while (($caller, $count) = each %nr_allocs_by_caller) {
+	$symbol = lookup_symbol($caller);
+	printf("  %x [%s]: %d\n", $caller, $symbol, $count);
+    }
+    print "\nTotal number of frees by caller:\n";
+    while (($caller, $count) = each %nr_frees_by_caller) {
+	$symbol = lookup_symbol($caller);
+	printf("  %x [%s]: %d\n", $caller, $symbol, $count);
+    }
+
+    print "\nTotal bytes requested by caller:\n";
+    while (($caller, $count) = each %nr_bytes_requested_by_caller) {
+	$symbol = lookup_symbol($caller);
+	printf("  %x [%s]: %d [%d]\n", $caller, $symbol, $count, $nr_bytes_allocated_by_caller{$caller});
+    }
+    print "\nTotal bytes wasted by caller:\n";
+    while (($caller, $count) = each %nr_bytes_wasted_by_caller) {
+	$symbol = lookup_symbol($caller);
+	printf("  %x [%s]: %d [average %d]\n", $caller, $symbol, $count, $count/$nr_allocs_by_caller{$caller});
+    }
+#    print "\nTotal bytes freed by caller:\n";
+#    while (($caller, $count) = each %nr_bytes_freed_by_caller) {
+#	$symbol = lookup_symbol($caller);
+#	printf("  %x [%s]: %d\n", $caller, $symbol, $count);
+#    }
+
+    print "\nUnfreed number of allocations:\n";
+    while (($addr, $caller) = each %alloc_addrs) {
+	if (!$free_addrs{$addr}) {
+	    $symbol = lookup_symbol($caller);
+	    $unfreed_nr_allocs{$symbol}++;
+	}
+    }
+    while (($symbol, $count) = each %unfreed_nr_allocs) {
+	    printf("  %s: %d\n", $symbol, $count);
+    }
+    print "\nUnmalloced number of frees:\n";
+    while (($addr, $caller) = each %free_addrs) {
+	if (!$alloc_addrs{$addr}) {
+	    $symbol = lookup_symbol($caller);
+	    $unmalloced_nr_frees{$symbol}++;
+	}
+    }
+    while (($symbol, $count) = each %unmalloced_nr_frees) {
+	    printf("  %s: %d\n", $symbol, $count);
+    }
+    close(TRACEFILE);
+    close(SYMBOL_FILE);
+}
Index: linux-2.6/mm/kmemprof.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/mm/kmemprof.c	2008-01-05 17:08:56.000000000 +0200
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) 2008  Pekka Enberg
+ *
+ * This file is released under the GPL version 2.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/relay.h>
+#include <linux/slab.h>
+
+static struct rchan *kmemprof_chan;
+static u32 kmemprof_enabled;
+
+/*
+ * This is the user-space visible ABI for kmem events.
+ */
+enum kmem_event_id {
+	KMEM_ALLOC	= 0x01,
+	KMEM_FREE	= 0x02,
+};
+
+struct kmem_event {
+	u64	event_id;
+	u64	call_site;
+	u64	ptr;
+	u64	nr_req;
+	u64	nr_alloc;
+	u32	gfp_flags;
+};
+
+static void kmemprof_log_event(struct kmem_event *e)
+{
+	relay_write(kmemprof_chan, e, sizeof(*e));
+}
+
+void kmem_track_alloc(void *call_site, const void *p, unsigned long nr_req,
+		      unsigned long nr_alloc, gfp_t flags)
+{
+	if (kmemprof_enabled) {
+		struct kmem_event e = {
+			.event_id	= KMEM_ALLOC,
+			.call_site	= (u64) call_site,
+			.ptr		= (u64) p,
+			.nr_req		= nr_req,
+			.nr_alloc	= nr_alloc,
+			.gfp_flags	= flags,
+		};
+		kmemprof_log_event(&e);
+	}
+}
+EXPORT_SYMBOL_GPL(kmem_track_alloc);
+
+void kmem_track_free(void *call_site, const void *p)
+{
+	if (kmemprof_enabled) {
+		struct kmem_event e = {
+			.event_id	= KMEM_FREE,
+			.call_site	= (u64) call_site,
+			.ptr		= (u64) p,
+		};
+		kmemprof_log_event(&e);
+	}
+}
+EXPORT_SYMBOL_GPL(kmem_track_free);
+
+/*
+ * The debugfs ABI for kmemprof
+ */
+#define KMEMPROF_MODE (S_IFREG | S_IRUSR | S_IWUSR)
+
+static struct dentry *kmemprof_dir;
+static struct dentry *kmemprof_enabled_file;
+
+#define KMEMPROF_SUBBUF_SIZE 262144
+#define KMEMPROF_NR_SUBBUFS  4
+
+static struct dentry *
+kmemprof_create_buf_file(const char *filename, struct dentry *parent,
+			 int mode, struct rchan_buf *buf, int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static int kmemprof_remove_buf_file(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.create_buf_file = kmemprof_create_buf_file,
+	.remove_buf_file = kmemprof_remove_buf_file,
+};
+
+static int __init kmemprof_debugfs_init(void)
+{
+	kmemprof_dir = debugfs_create_dir("kmemprof", NULL);
+	if (!kmemprof_dir)
+		goto failed;
+
+	kmemprof_chan = relay_open("cpu", kmemprof_dir, KMEMPROF_SUBBUF_SIZE,
+				KMEMPROF_NR_SUBBUFS, &relay_callbacks, NULL);
+	if (!kmemprof_chan)
+		goto failed;
+
+	kmemprof_enabled_file = debugfs_create_bool("enabled", KMEMPROF_MODE,
+					kmemprof_dir, &kmemprof_enabled);
+	if (!kmemprof_enabled_file)
+		goto failed;
+
+	return 0;
+failed:
+	printk(KERN_ERR "kmemprof: failed to initialize debugfs.\n");
+	debugfs_remove(kmemprof_enabled_file);
+	relay_close(kmemprof_chan);
+	debugfs_remove(kmemprof_dir);
+	return -ENOMEM;
+}
+
+late_initcall(kmemprof_debugfs_init);
