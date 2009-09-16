Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZIPKau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZIPKau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbZIPKaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:30:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:30866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbZIPK3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224413"
Message-Id: <20090916100657.517973272@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 5/8] page-types: make standalone pagemap/kpageflags read routines
Content-Disposition: inline; filename=page-types-standalone-read-funcs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the code to be more modular and easier to reuse.

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |  156 ++++++++++++++++++--------------
 1 file changed, 90 insertions(+), 66 deletions(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 14:59:48.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 15:15:37.000000000 +0800
@@ -154,8 +154,6 @@ static unsigned long	pg_start[MAX_VMAS];
 static unsigned long	pg_end[MAX_VMAS];
 static unsigned long	voffset;
 
-static int		pagemap_fd;
-
 #define MAX_BIT_FILTERS	64
 static int		nr_bit_filters;
 static uint64_t		opt_mask[MAX_BIT_FILTERS];
@@ -163,7 +161,7 @@ static uint64_t		opt_bits[MAX_BIT_FILTER
 
 static int		page_size;
 
-#define PAGES_BATCH	(64 << 10)	/* 64k pages */
+static int		pagemap_fd;
 static int		kpageflags_fd;
 
 #define HASH_SHIFT	13
@@ -219,6 +217,62 @@ int checked_open(const char *pathname, i
 	return fd;
 }
 
+/*
+ * pagemap/kpageflags routines
+ */
+
+static unsigned long do_u64_read(int fd, char *name,
+				 uint64_t *buf,
+				 unsigned long index,
+				 unsigned long count)
+{
+	long bytes;
+
+	if (index > ULONG_MAX / 8)
+		fatal("index overflow: %lu\n", index);
+
+	if (lseek(fd, index * 8, SEEK_SET) < 0) {
+		perror(name);
+		exit(EXIT_FAILURE);
+	}
+
+	bytes = read(fd, buf, count * 8);
+	if (bytes < 0) {
+		perror(name);
+		exit(EXIT_FAILURE);
+	}
+	if (bytes % 8)
+		fatal("partial read: %lu bytes\n", bytes);
+
+	return bytes / 8;
+}
+
+static unsigned long kpageflags_read(uint64_t *buf,
+				     unsigned long index,
+				     unsigned long pages)
+{
+	return do_u64_read(kpageflags_fd, PROC_KPAGEFLAGS, buf, index, pages);
+}
+
+static unsigned long pagemap_read(uint64_t *buf,
+				  unsigned long index,
+				  unsigned long pages)
+{
+	return do_u64_read(pagemap_fd, "/proc/pid/pagemap", buf, index, pages);
+}
+
+static unsigned long pagemap_pfn(uint64_t val)
+{
+	unsigned long pfn;
+
+	if (val & PM_PRESENT)
+		pfn = PM_PFRAME(val);
+	else
+		pfn = 0;
+
+	return pfn;
+}
+
 
 /*
  * page flag names
@@ -425,79 +479,53 @@ static void add_page(unsigned long offse
 	total_pages++;
 }
 
+#define KPAGEFLAGS_BATCH	(64 << 10)	/* 64k pages */
 static void walk_pfn(unsigned long index, unsigned long count)
 {
+	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
-	unsigned long n;
+	unsigned long pages;
 	unsigned long i;
 
-	if (index > ULONG_MAX / KPF_BYTES)
-		fatal("index overflow: %lu\n", index);
-
-	lseek(kpageflags_fd, index * KPF_BYTES, SEEK_SET);
-
 	while (count) {
-		uint64_t kpageflags_buf[KPF_BYTES * PAGES_BATCH];
-
-		batch = min_t(unsigned long, count, PAGES_BATCH);
-		n = read(kpageflags_fd, kpageflags_buf, batch * KPF_BYTES);
-		if (n == 0)
-			break;
-		if (n < 0) {
-			perror(PROC_KPAGEFLAGS);
-			exit(EXIT_FAILURE);
-		}
-
-		if (n % KPF_BYTES != 0)
-			fatal("partial read: %lu bytes\n", n);
-		n = n / KPF_BYTES;
+		batch = min_t(unsigned long, count, KPAGEFLAGS_BATCH);
+		pages = kpageflags_read(buf, index, batch);
+		if (pages == 0)
+			break;
 
-		for (i = 0; i < n; i++)
-			add_page(index + i, kpageflags_buf[i]);
+		for (i = 0; i < pages; i++)
+			add_page(index + i, buf[i]);
 
-		index += batch;
-		count -= batch;
+		index += pages;
+		count -= pages;
 	}
 }
 
-
-#define PAGEMAP_BATCH	4096
-static unsigned long task_pfn(unsigned long pgoff)
+#define PAGEMAP_BATCH	(64 << 10)
+static void walk_vma(unsigned long index, unsigned long count)
 {
-	static uint64_t buf[PAGEMAP_BATCH];
-	static unsigned long start;
-	static long count;
-	uint64_t pfn;
+	uint64_t buf[PAGEMAP_BATCH];
+	unsigned long batch;
+	unsigned long pages;
+	unsigned long pfn;
+	unsigned long i;
 
-	if (pgoff < start || pgoff >= start + count) {
-		if (lseek64(pagemap_fd,
-			    (uint64_t)pgoff * PM_ENTRY_BYTES,
-			    SEEK_SET) < 0) {
-			perror("pagemap seek");
-			exit(EXIT_FAILURE);
-		}
-		count = read(pagemap_fd, buf, sizeof(buf));
-		if (count == 0)
-			return 0;
-		if (count < 0) {
-			perror("pagemap read");
-			exit(EXIT_FAILURE);
-		}
-		if (count % PM_ENTRY_BYTES) {
-			fatal("pagemap read not aligned.\n");
-			exit(EXIT_FAILURE);
-		}
-		count /= PM_ENTRY_BYTES;
-		start = pgoff;
-	}
+	while (count) {
+		batch = min_t(unsigned long, count, PAGEMAP_BATCH);
+		pages = pagemap_read(buf, index, batch);
+		if (pages == 0)
+			break;
 
-	pfn = buf[pgoff - start];
-	if (pfn & PM_PRESENT)
-		pfn = PM_PFRAME(pfn);
-	else
-		pfn = 0;
+		for (i = 0; i < pages; i++) {
+			pfn = pagemap_pfn(buf[i]);
+			voffset = index + i;
+			if (pfn)
+				walk_pfn(pfn, 1);
+		}
 
-	return pfn;
+		index += pages;
+		count -= pages;
+	}
 }
 
 static void walk_task(unsigned long index, unsigned long count)
@@ -517,11 +545,7 @@ static void walk_task(unsigned long inde
 		index   = min_t(unsigned long, pg_end[i], end);
 
 		assert(voffset < index);
-		for (; voffset < index; voffset++) {
-			unsigned long pfn = task_pfn(voffset);
-			if (pfn)
-				walk_pfn(pfn, 1);
-		}
+		walk_vma(voffset, index - voffset);
 	}
 }
 

-- 

