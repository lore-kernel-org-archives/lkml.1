Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZIUOUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZIUOUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZIUOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:20:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZIUOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:20:09 -0400
Message-Id: <20090921141751.310933291@chello.nl>
References: <20090921140848.444528343@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 21 Sep 2009 16:08:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/2] perf,sparc: Use vmalloc to back the mmap() array
Content-Disposition: inline; filename=perf-sparc-mmap-vmalloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement vmalloc() backed storage for perf_mmap().

Alternatively we could put this code in kernel/perf_counter_vmalloc.c
and conditionally compile that or something, since there really isn't
anything Sparc specific about it.

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/sparc/kernel/perf_counter.c |   72 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

Index: linux-2.6/arch/sparc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_counter.c
+++ linux-2.6/arch/sparc/kernel/perf_counter.c
@@ -14,6 +14,7 @@
 
 #include <linux/perf_counter.h>
 #include <linux/kprobes.h>
+#include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/kdebug.h>
 #include <linux/mutex.h>
@@ -554,3 +555,74 @@ void __init init_hw_perf_counters(void)
 
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
+
+struct page *perf_mmap_to_page(void *addr)
+{
+	return vmalloc_to_page(addr);
+}
+
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void perf_mmap_data_free_work(struct work_struct *work)
+{
+	struct perf_mmap_data *data;
+	void *base;
+	int i;
+
+	data = container_of(work, struct perf_mmap_data, work);
+
+	base = data->user_page;
+	for (i = 0; i < data->nr_pages + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+}
+
+void perf_mmap_data_free(struct perf_mmap_data *data)
+{
+	schedule_work(&data->work);
+}
+
+struct perf_mmap_data *
+perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
+{
+	struct perf_mmap_data *data;
+	unsigned long size;
+	void *all_buf;
+	int i;
+
+	WARN_ON(atomic_read(&counter->mmap_count));
+
+	size = sizeof(struct perf_mmap_data);
+	size += nr_pages * sizeof(void *);
+
+	data = kzalloc(size, GFP_KERNEL);
+	if (!data)
+		goto fail;
+
+	INIT_WORK(&data->work, perf_mmap_data_free_work);
+
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	data->user_page = all_buf;
+
+	for (i = 0; i < nr_pages; i++)
+		data->data_pages[i] = all_buf + ((i + 1) * PAGE_SIZE);
+
+	data->nr_pages = nr_pages;
+
+	return data;
+
+fail_all_buf:
+	kfree(data);
+
+fail:
+	return NULL;
+}

-- 

