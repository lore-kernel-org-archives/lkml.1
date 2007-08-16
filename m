Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXHPI3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXHPI3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbXHPI2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:28:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764188AbXHPI2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:28:43 -0400
Message-Id: <20070816074628.520798000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 16/23] mm: scalable bdi statistics counters.
Content-Disposition: inline; filename=bdi_stat.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide scalable per backing_dev_info statistics counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/backing-dev.h |   85 ++++++++++++++++++++++++++++++++++++++++++--
 mm/backing-dev.c            |   27 +++++++++++++
 2 files changed, 109 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_BACKING_DEV_H
 #define _LINUX_BACKING_DEV_H
 
+#include <linux/percpu_counter.h>
+#include <linux/log2.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -24,6 +26,12 @@ enum bdi_state {
 
 typedef int (congested_fn)(void *, int);
 
+enum bdi_stat_item {
+	NR_BDI_STAT_ITEMS
+};
+
+#define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
+
 struct backing_dev_info {
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
@@ -32,15 +40,86 @@ struct backing_dev_info {
 	void *congested_data;	/* Pointer to aux data for congested func */
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
+
+	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 };
 
-static inline int bdi_init(struct backing_dev_info *bdi)
+int bdi_init(struct backing_dev_info *bdi);
+void bdi_destroy(struct backing_dev_info *bdi);
+
+static inline void __add_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item, s64 amount)
 {
-	return 0;
+	__percpu_counter_add(&bdi->bdi_stat[item], amount, BDI_STAT_BATCH);
 }
 
-static inline void bdi_destroy(struct backing_dev_info *bdi)
+static inline void __inc_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
 {
+	__add_bdi_stat(bdi, item, 1);
+}
+
+static inline void inc_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__inc_bdi_stat(bdi, item);
+	local_irq_restore(flags);
+}
+
+static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	__add_bdi_stat(bdi, item, -1);
+}
+
+static inline void dec_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__dec_bdi_stat(bdi, item);
+	local_irq_restore(flags);
+}
+
+static inline s64 bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	return percpu_counter_read_positive(&bdi->bdi_stat[item]);
+}
+
+static inline s64 __bdi_stat_sum(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	return percpu_counter_sum_positive(&bdi->bdi_stat[item]);
+}
+
+static inline s64 bdi_stat_sum(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	s64 sum;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	sum = __bdi_stat_sum(bdi, item);
+	local_irq_restore(flags);
+
+	return sum;
+}
+
+/*
+ * maximal error of a stat counter.
+ */
+static inline unsigned long bdi_stat_error(struct backing_dev_info *bdi)
+{
+#ifdef CONFIG_SMP
+	return nr_cpu_ids * BDI_STAT_BATCH;
+#else
+	return 1;
+#endif
 }
 
 /*
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -5,6 +5,33 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 
+int bdi_init(struct backing_dev_info *bdi)
+{
+	int i, j;
+	int err;
+
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
+		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
+		if (err) {
+			for (j = 0; j < i; j++)
+				percpu_counter_destroy(&bdi->bdi_stat[i]);
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(bdi_init);
+
+void bdi_destroy(struct backing_dev_info *bdi)
+{
+	int i;
+
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
+		percpu_counter_destroy(&bdi->bdi_stat[i]);
+}
+EXPORT_SYMBOL(bdi_destroy);
+
 static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])

--

