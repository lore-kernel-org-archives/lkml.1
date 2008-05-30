Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYE3EOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYE3EOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYE3EBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40517 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752223AbYE3EAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:20 -0400
Message-Id: <20080530040013.137338958@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:29 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 09/41] cpu alloc: Genhd statistics conversion
Content-Disposition: inline; filename=cpu_alloc_genhd_statistics_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert genhd statistics to cpu alloc. The patch also drops the UP special
casing of the statistics.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/genhd.h |  113 +++++++++++---------------------------------------
 1 file changed, 25 insertions(+), 88 deletions(-)

Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h	2008-05-26 09:35:31.626487665 -0700
+++ linux-2.6/include/linux/genhd.h	2008-05-26 11:09:00.740248203 -0700
@@ -95,11 +95,7 @@ struct hd_struct {
 #endif
 	unsigned long stamp;
 	int in_flight;
-#ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
-#else
-	struct disk_stats dkstats;
-#endif
 };
 
 #define GENHD_FL_REMOVABLE			1
@@ -135,11 +131,7 @@ struct gendisk {
 	atomic_t sync_io;		/* RAID */
 	unsigned long stamp;
 	int in_flight;
-#ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
-#else
-	struct disk_stats dkstats;
-#endif
 	struct work_struct async_notify;
 };
 
@@ -163,16 +155,15 @@ static inline struct hd_struct *get_part
 	return NULL;
 }
 
-#ifdef	CONFIG_SMP
 #define __disk_stat_add(gendiskp, field, addnd) 	\
-	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
+	__CPU_ADD(gendiskp->dkstats->field, addnd)
 
 #define disk_stat_read(gendiskp, field)					\
 ({									\
 	typeof(gendiskp->dkstats->field) res = 0;			\
 	int i;								\
 	for_each_possible_cpu(i)					\
-		res += per_cpu_ptr(gendiskp->dkstats, i)->field;	\
+		res += CPU_PTR(gendiskp->dkstats, i)->field;		\
 	res;								\
 })
 
@@ -180,12 +171,12 @@ static inline void disk_stat_set_all(str
 	int i;
 
 	for_each_possible_cpu(i)
-		memset(per_cpu_ptr(gendiskp->dkstats, i), value,
+		memset(CPU_PTR(gendiskp->dkstats, i), value,
 				sizeof(struct disk_stats));
-}		
+}
 
-#define __part_stat_add(part, field, addnd)				\
-	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
+#define __part_stat_add(part, field, addnd)			\
+	__CPU_ADD(part->dkstats->field, addnd)
 
 #define __all_stat_add(gendiskp, part, field, addnd, sector)	\
 ({								\
@@ -199,7 +190,7 @@ static inline void disk_stat_set_all(str
 	typeof(part->dkstats->field) res = 0;				\
 	int i;								\
 	for_each_possible_cpu(i)					\
-		res += per_cpu_ptr(part->dkstats, i)->field;		\
+		res += CPU_PTR(part->dkstats, i)->field;		\
 	res;								\
 })
 
@@ -208,56 +199,23 @@ static inline void part_stat_set_all(str
 	int i;
 
 	for_each_possible_cpu(i)
-		memset(per_cpu_ptr(part->dkstats, i), value,
+		memset(CPU_PTR(part->dkstats, i), value,
 				sizeof(struct disk_stats));
 }
-				
-#else /* !CONFIG_SMP */
-#define __disk_stat_add(gendiskp, field, addnd) \
-				(gendiskp->dkstats.field += addnd)
-#define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
-
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
-{
-	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
-}
-
-#define __part_stat_add(part, field, addnd) \
-	(part->dkstats.field += addnd)
-
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
-({								\
-	if (part)						\
-		part->dkstats.field += addnd;			\
-	__disk_stat_add(gendiskp, field, addnd);		\
-})
-
-#define part_stat_read(part, field)	(part->dkstats.field)
-
-static inline void part_stat_set_all(struct hd_struct *part, int value)
-{
-	memset(&part->dkstats, value, sizeof(struct disk_stats));
-}
-
-#endif /* CONFIG_SMP */
 
 #define disk_stat_add(gendiskp, field, addnd)			\
-	do {							\
-		preempt_disable();				\
-		__disk_stat_add(gendiskp, field, addnd);	\
-		preempt_enable();				\
-	} while (0)
+	_CPU_ADD(gendiskp->dkstats->field, addnd)
 
-#define __disk_stat_dec(gendiskp, field) __disk_stat_add(gendiskp, field, -1)
-#define disk_stat_dec(gendiskp, field) disk_stat_add(gendiskp, field, -1)
+#define __disk_stat_dec(gendiskp, field) __CPU_DEC(gendiskp->dkstats->field)
+#define disk_stat_dec(gendiskp, field) _CPU_DEC(gendiskp->dkstats->field)
 
-#define __disk_stat_inc(gendiskp, field) __disk_stat_add(gendiskp, field, 1)
-#define disk_stat_inc(gendiskp, field) disk_stat_add(gendiskp, field, 1)
+#define __disk_stat_inc(gendiskp, field) __CPU_INC(gendiskp->dkstats->field)
+#define disk_stat_inc(gendiskp, field) _CPU_INC(gendiskp->dkstats->field)
 
 #define __disk_stat_sub(gendiskp, field, subnd) \
-		__disk_stat_add(gendiskp, field, -subnd)
+		__CPU_SUB(gendisk->dkstats->field, subnd)
 #define disk_stat_sub(gendiskp, field, subnd) \
-		disk_stat_add(gendiskp, field, -subnd)
+		_CPU_SUB(gendisk->dkstats->field, subnd)
 
 #define part_stat_add(gendiskp, field, addnd)		\
 	do {						\
@@ -266,16 +224,16 @@ static inline void part_stat_set_all(str
 		preempt_enable();			\
 	} while (0)
 
-#define __part_stat_dec(gendiskp, field) __part_stat_add(gendiskp, field, -1)
-#define part_stat_dec(gendiskp, field) part_stat_add(gendiskp, field, -1)
+#define __part_stat_dec(gendiskp, field) __CPU_DEC(gendiskp->dkstats->field)
+#define part_stat_dec(gendiskp, field) _CPU_DEC(gendiskp->dkstats->field)
 
-#define __part_stat_inc(gendiskp, field) __part_stat_add(gendiskp, field, 1)
-#define part_stat_inc(gendiskp, field) part_stat_add(gendiskp, field, 1)
+#define __part_stat_inc(gendiskp, field) __CPU_INC(gendiskp->dkstats->field)
+#define part_stat_inc(gendiskp, field) _CPU_INC(gendiskp->dkstats->field)
 
 #define __part_stat_sub(gendiskp, field, subnd) \
-		__part_stat_add(gendiskp, field, -subnd)
+		__CPU_SUB(gendiskp->dkstats->field, subnd)
 #define part_stat_sub(gendiskp, field, subnd) \
-		part_stat_add(gendiskp, field, -subnd)
+		_CPU_SUB(gendiskp->dkstats->field, subnd)
 
 #define all_stat_add(gendiskp, part, field, addnd, sector)	\
 	do {							\
@@ -300,10 +258,9 @@ static inline void part_stat_set_all(str
 		all_stat_add(gendiskp, part, field, -subnd, sector)
 
 /* Inlines to alloc and free disk stats in struct gendisk */
-#ifdef  CONFIG_SMP
 static inline int init_disk_stats(struct gendisk *disk)
 {
-	disk->dkstats = alloc_percpu(struct disk_stats);
+	disk->dkstats = CPU_ALLOC(struct disk_stats, GFP_KERNEL | __GFP_ZERO);
 	if (!disk->dkstats)
 		return 0;
 	return 1;
@@ -311,12 +268,12 @@ static inline int init_disk_stats(struct
 
 static inline void free_disk_stats(struct gendisk *disk)
 {
-	free_percpu(disk->dkstats);
+	CPU_FREE(disk->dkstats);
 }
 
 static inline int init_part_stats(struct hd_struct *part)
 {
-	part->dkstats = alloc_percpu(struct disk_stats);
+	part->dkstats = CPU_ALLOC(struct disk_stats, GFP_KERNEL|__GFP_ZERO);
 	if (!part->dkstats)
 		return 0;
 	return 1;
@@ -324,28 +281,8 @@ static inline int init_part_stats(struct
 
 static inline void free_part_stats(struct hd_struct *part)
 {
-	free_percpu(part->dkstats);
-}
-
-#else	/* CONFIG_SMP */
-static inline int init_disk_stats(struct gendisk *disk)
-{
-	return 1;
-}
-
-static inline void free_disk_stats(struct gendisk *disk)
-{
-}
-
-static inline int init_part_stats(struct hd_struct *part)
-{
-	return 1;
-}
-
-static inline void free_part_stats(struct hd_struct *part)
-{
+	CPU_FREE(part->dkstats);
 }
-#endif	/* CONFIG_SMP */
 
 /* drivers/block/ll_rw_blk.c */
 extern void disk_round_stats(struct gendisk *disk);

-- 
