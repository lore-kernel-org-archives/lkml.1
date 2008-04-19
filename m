Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbYDSDSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbYDSDSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbYDSDRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:17:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbYDSDRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:17:41 -0400
Date: Fri, 18 Apr 2008 23:17:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, sandmann@redhat.com, pq@iki.fi,
       srostedt@redhat.com
Subject: [PATCH 4/5 -v2] ftrace: limit trace entries
In-Reply-To: <20080418131935.67daf8f0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804182312500.19025@gandalf.stny.rr.com>
References: <20080418200538.788522018@goodmis.org> <20080418200850.443055618@goodmis.org>
 <20080418131935.67daf8f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently there is no protection from the root user to use up all of
memory for trace buffers. If the root user allocates too many entries,
the OOM killer might start killing off all tasks.

This patch adds an algorithm to check the following condition:

 pages_requested > (freeable_memory + current_trace_buffer_pages) / 4

If the above is met then the allocation fails. The above prevents more
than 1/4th of freeable memory from being used by trace buffers.

To determine the freeable_memory, I made determine_dirtyable_memory in
mm/page-writeback.c global.

Special thanks goes to Peter Zijlstra for suggesting the above calculation.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/writeback.h |    2 ++
 kernel/trace/trace.c      |   38 ++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c       |   10 +++++++---
 3 files changed, 47 insertions(+), 3 deletions(-)

Index: linux-sched-devel.git/include/linux/writeback.h
===================================================================
--- linux-sched-devel.git.orig/include/linux/writeback.h	2008-04-18 23:01:57.000000000 -0400
+++ linux-sched-devel.git/include/linux/writeback.h	2008-04-18 23:06:43.000000000 -0400
@@ -105,6 +105,8 @@ extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;

+extern unsigned long determine_dirtyable_memory(void);
+
 extern int dirty_ratio_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
 		loff_t *ppos);
Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-18 23:06:40.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-18 23:06:43.000000000 -0400
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <linux/writeback.h>

 #include <linux/stacktrace.h>

@@ -51,6 +52,8 @@ static int trace_free_page(void);

 static int tracing_disabled = 1;

+static unsigned long tracing_pages_allocated;
+
 long
 ns2usecs(cycle_t nsec)
 {
@@ -2477,12 +2480,41 @@ tracing_entries_write(struct file *filp,
 	}

 	if (val > global_trace.entries) {
+		long pages_requested;
+		unsigned long freeable_pages;
+
+		/* make sure we have enough memory before mapping */
+		pages_requested =
+			(val + (ENTRIES_PER_PAGE-1)) / ENTRIES_PER_PAGE;
+
+		/* account for each buffer (and max_tr) */
+		pages_requested *= tracing_nr_buffers * 2;
+
+		/* Check for overflow */
+		if (pages_requested < 0) {
+			cnt = -ENOMEM;
+			goto out;
+		}
+
+		freeable_pages = determine_dirtyable_memory();
+
+		/* we only allow to request 1/4 of useable memory */
+		if (pages_requested >
+		    ((freeable_pages + tracing_pages_allocated) / 4)) {
+			cnt = -ENOMEM;
+			goto out;
+		}
+
 		while (global_trace.entries < val) {
 			if (trace_alloc_page()) {
 				cnt = -ENOMEM;
 				goto out;
 			}
+			/* double check that we don't go over the known pages */
+			if (tracing_pages_allocated > pages_requested)
+				break;
 		}
+
 	} else {
 		/* include the number of entries in val (inc of page entries) */
 		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
@@ -2665,6 +2697,7 @@ static int trace_alloc_page(void)
 	struct page *page, *tmp;
 	LIST_HEAD(pages);
 	void *array;
+	unsigned pages_allocated = 0;
 	int i;

 	/* first allocate a page for each CPU */
@@ -2676,6 +2709,7 @@ static int trace_alloc_page(void)
 			goto free_pages;
 		}

+		pages_allocated++;
 		page = virt_to_page(array);
 		list_add(&page->lru, &pages);

@@ -2687,6 +2721,7 @@ static int trace_alloc_page(void)
 			       "for trace buffer!\n");
 			goto free_pages;
 		}
+		pages_allocated++;
 		page = virt_to_page(array);
 		list_add(&page->lru, &pages);
 #endif
@@ -2708,6 +2743,7 @@ static int trace_alloc_page(void)
 		SetPageLRU(page);
 #endif
 	}
+	tracing_pages_allocated += pages_allocated;
 	global_trace.entries += ENTRIES_PER_PAGE;

 	return 0;
@@ -2742,6 +2778,7 @@ static int trace_free_page(void)
 		page = list_entry(p, struct page, lru);
 		ClearPageLRU(page);
 		list_del(&page->lru);
+		tracing_pages_allocated--;
 		__free_page(page);

 		tracing_reset(data);
@@ -2759,6 +2796,7 @@ static int trace_free_page(void)
 		page = list_entry(p, struct page, lru);
 		ClearPageLRU(page);
 		list_del(&page->lru);
+		tracing_pages_allocated--;
 		__free_page(page);

 		tracing_reset(data);
Index: linux-sched-devel.git/mm/page-writeback.c
===================================================================
--- linux-sched-devel.git.orig/mm/page-writeback.c	2008-04-18 23:01:57.000000000 -0400
+++ linux-sched-devel.git/mm/page-writeback.c	2008-04-18 23:07:52.000000000 -0400
@@ -126,8 +126,6 @@ static void background_writeout(unsigned
 static struct prop_descriptor vm_completions;
 static struct prop_descriptor vm_dirties;

-static unsigned long determine_dirtyable_memory(void);
-
 /*
  * couple the period to the dirty_ratio:
  *
@@ -286,7 +284,13 @@ static unsigned long highmem_dirtyable_m
 #endif
 }

-static unsigned long determine_dirtyable_memory(void)
+/**
+ * determine_dirtyable_memory - amount of memory that may be used
+ *
+ * Returns the numebr of pages that can currently be freed and used
+ * by the kernel for direct mappings.
+ */
+unsigned long determine_dirtyable_memory(void)
 {
 	unsigned long x;



