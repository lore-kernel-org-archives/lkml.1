Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYGDX5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYGDX5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYGDXzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42517 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbYGDXzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:13 -0400
Message-Id: <20080704235428.930802653@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 11/12] LTTng instrumentation mm tracepoint probes
Content-Disposition: inline; filename=lttng-instrumentation-mm-tracepoints-probes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module which declares mm tracepoint probes, using markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/swapops.h |    8 ++
 mm/Makefile             |    1 
 mm/mm-trace.c           |  150 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)

Index: linux-2.6-lttng/mm/Makefile
===================================================================
--- linux-2.6-lttng.orig/mm/Makefile	2008-07-04 18:26:42.000000000 -0400
+++ linux-2.6-lttng/mm/Makefile	2008-07-04 18:27:00.000000000 -0400
@@ -33,4 +33,5 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_TRACEPROBES) += mm-trace.o
 
Index: linux-2.6-lttng/mm/mm-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/mm/mm-trace.c	2008-07-04 18:27:00.000000000 -0400
@@ -0,0 +1,150 @@
+/*
+ * mm/mm-trace.c
+ *
+ * MM tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <linux/swapops.h>
+#include "mm-trace.h"
+
+static void probe_mm_filemap_wait_start(struct page *page, int bit_nr)
+{
+	trace_mark(mm_filemap_wait_start, "pfn %lu bit_nr %d",
+		page_to_pfn(page), bit_nr);
+}
+
+static void probe_mm_filemap_wait_end(struct page *page, int bit_nr)
+{
+	trace_mark(mm_filemap_wait_end, "pfn %lu bit_nr %d",
+		page_to_pfn(page), bit_nr);
+}
+
+static void probe_mm_huge_page_free(struct page *page)
+{
+	trace_mark(mm_huge_page_free, "pfn %lu", page_to_pfn(page));
+}
+
+static void probe_mm_huge_page_alloc(struct page *page)
+{
+	trace_mark(mm_huge_page_alloc, "pfn %lu", page_to_pfn(page));
+}
+
+#ifdef CONFIG_SWAP
+static void probe_mm_swap_in(struct page *page, swp_entry_t entry)
+{
+	trace_mark(mm_swap_in, "pfn %lu filp %p offset %lu",
+		page_to_pfn(page),
+		get_swap_info_struct(swp_type(entry))->swap_file,
+		swp_offset(entry));
+}
+#endif
+
+static void probe_mm_handle_fault_entry(unsigned long address, int write_access)
+{
+	trace_mark(mm_handle_fault_entry,
+		"address %lu ip #p%ld write_access %d",
+		address, KSTK_EIP(current), write_access);
+}
+
+static void probe_mm_handle_fault_exit(void)
+{
+	trace_mark(mm_handle_fault_exit, MARK_NOARGS);
+}
+
+static void probe_mm_page_free(struct page *page, unsigned int order)
+{
+	trace_mark(mm_page_free, "order %u pfn %lu", order, page_to_pfn(page));
+}
+
+static void probe_mm_page_alloc(struct page *page, unsigned int order)
+{
+	if (page)
+		trace_mark(mm_page_alloc, "order %u pfn %lu", order,
+			page_to_pfn(page));
+}
+
+static void probe_mm_swap_out(struct page *page)
+{
+	trace_mark(mm_swap_out, "pfn %lu filp %p offset %lu",
+		page_to_pfn(page),
+		get_swap_info_struct(swp_type(
+			page_swp_entry(page)))->swap_file,
+		swp_offset(page_swp_entry(page)));
+}
+
+static void probe_mm_swap_file_close(struct file *file)
+{
+	trace_mark(mm_swap_file_close, "filp %p", file);
+}
+
+static void probe_mm_swap_file_open(struct file *file, char *filename)
+{
+	trace_mark(mm_swap_file_open, "filp %p filename %s",
+		file, filename);
+}
+
+int __init mm_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_mm_filemap_wait_start(probe_mm_filemap_wait_start);
+	WARN_ON(ret);
+	ret = register_trace_mm_filemap_wait_end(probe_mm_filemap_wait_end);
+	WARN_ON(ret);
+	ret = register_trace_mm_huge_page_free(probe_mm_huge_page_free);
+	WARN_ON(ret);
+	ret = register_trace_mm_huge_page_alloc(probe_mm_huge_page_alloc);
+	WARN_ON(ret);
+#ifdef CONFIG_SWAP
+	ret = register_trace_mm_swap_in(probe_mm_swap_in);
+	WARN_ON(ret);
+#endif
+	ret = register_trace_mm_handle_fault_entry(probe_mm_handle_fault_entry);
+	WARN_ON(ret);
+	ret = register_trace_mm_handle_fault_exit(probe_mm_handle_fault_exit);
+	WARN_ON(ret);
+	ret = register_trace_mm_page_free(probe_mm_page_free);
+	WARN_ON(ret);
+	ret = register_trace_mm_page_alloc(probe_mm_page_alloc);
+	WARN_ON(ret);
+	ret = register_trace_mm_swap_out(probe_mm_swap_out);
+	WARN_ON(ret);
+	ret = register_trace_mm_swap_file_close(probe_mm_swap_file_close);
+	WARN_ON(ret);
+	ret = register_trace_mm_swap_file_open(probe_mm_swap_file_open);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(mm_trace_init);
+
+void __exit mm_trace_exit(void)
+{
+	unregister_trace_mm_swap_file_open(probe_mm_swap_file_open);
+	unregister_trace_mm_swap_file_close(probe_mm_swap_file_close);
+	unregister_trace_mm_swap_out(probe_mm_swap_out);
+	unregister_trace_mm_page_alloc(probe_mm_page_alloc);
+	unregister_trace_mm_page_free(probe_mm_page_free);
+	unregister_trace_mm_handle_fault_exit(probe_mm_handle_fault_exit);
+	unregister_trace_mm_handle_fault_entry(probe_mm_handle_fault_entry);
+#ifdef CONFIG_SWAP
+	unregister_trace_mm_swap_in(probe_mm_swap_in);
+#endif
+	unregister_trace_mm_huge_page_alloc(probe_mm_huge_page_alloc);
+	unregister_trace_mm_huge_page_free(probe_mm_huge_page_free);
+	unregister_trace_mm_filemap_wait_end(probe_mm_filemap_wait_end);
+	unregister_trace_mm_filemap_wait_start(probe_mm_filemap_wait_start);
+}
+
+module_exit(mm_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("MM Tracepoint Probes");
Index: linux-2.6-lttng/include/linux/swapops.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/swapops.h	2008-07-04 18:26:02.000000000 -0400
+++ linux-2.6-lttng/include/linux/swapops.h	2008-07-04 18:27:00.000000000 -0400
@@ -76,6 +76,14 @@ static inline pte_t swp_entry_to_pte(swp
 	return __swp_entry_to_pte(arch_entry);
 }
 
+static inline swp_entry_t page_swp_entry(struct page *page)
+{
+	swp_entry_t entry;
+	VM_BUG_ON(!PageSwapCache(page));
+	entry.val = page_private(page);
+	return entry;
+}
+
 #ifdef CONFIG_MIGRATION
 static inline swp_entry_t make_migration_entry(struct page *page, int write)
 {

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
