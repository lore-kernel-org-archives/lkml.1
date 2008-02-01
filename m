Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYBASQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYBASQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYBASQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:16:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYBASQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:16:08 -0500
Message-ID: <47A36174.7040600@redhat.com>
Date: Fri, 01 Feb 2008 19:14:12 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, "Ed L. Cashin" <ecashin@coraid.com>
Subject: [Patch 1/6] Enhanced partition statistics: core statistics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contain the core infrastructure of enhanced partition
statistics. It adds to struct hd_struct the same stats data as struct
gendisk and define basics function to manipulate them.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 include/linux/genhd.h |  132 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 131 insertions(+), 1 deletion(-)
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/include/linux/genhd.h linux-2.6/include/linux/genhd.h
--- linux-2.6.orig/include/linux/genhd.h	2008-01-31 16:43:28.000000000 +0100
+++ linux-2.6/include/linux/genhd.h	2008-01-31 16:47:12.000000000 +0100
@@ -101,6 +101,13 @@ struct hd_struct {
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;
 #endif
+	unsigned long stamp;
+	int in_flight;
+#ifdef	CONFIG_SMP
+	struct disk_stats *dkstats;
+#else
+	struct disk_stats dkstats;
+#endif
 };
 
 #define GENHD_FL_REMOVABLE			1
@@ -158,6 +165,20 @@ struct gendisk {
  * The __ variants should only be called in critical sections. The full
  * variants disable/enable preemption.
  */
+static inline struct hd_struct *get_part(struct gendisk *gendiskp,
+					 sector_t sector)
+{
+	struct hd_struct *part;
+	int i;
+	for (i = 0; i < gendiskp->minors - 1; i++) {
+		part = gendiskp->part[i];
+		if (part && part->start_sect <= sector
+		    && sector < part->start_sect + part->nr_sects)
+			return part;
+	}
+	return NULL;
+}
+
 #ifdef	CONFIG_SMP
 #define __disk_stat_add(gendiskp, field, addnd) 	\
 	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
@@ -177,15 +198,62 @@ static inline void disk_stat_set_all(str
 		memset(per_cpu_ptr(gendiskp->dkstats, i), value,
 				sizeof (struct disk_stats));
 }		
+
+#define __part_stat_add(part, field, addnd)				\
+	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
+
+#define __all_stat_add(gendiskp, field, addnd, sector)		\
+({								\
+	struct hd_struct *part = get_part(gendiskp, sector);	\
+	if (part)						\
+		__part_stat_add(part, field, addnd);		\
+	__disk_stat_add(gendiskp, field, addnd);		\
+})
+
+#define part_stat_read(part, field)					\
+({									\
+	typeof(part->dkstats->field) res = 0;				\
+	int i;								\
+	for_each_possible_cpu(i)					\
+		res += per_cpu_ptr(part->dkstats, i)->field;		\
+	res;								\
+})
+
+static inline void part_stat_set_all(struct hd_struct *part, int value)	{
+	int i;
+	for_each_possible_cpu(i)
+		memset(per_cpu_ptr(part->dkstats, i), value,
+		       sizeof(struct disk_stats));
+}
 				
 #else
 #define __disk_stat_add(gendiskp, field, addnd) \
 				(gendiskp->dkstats.field += addnd)
 #define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
 
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
+static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
+{
 	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
 }
+
+#define __part_stat_add(part, field, addnd) \
+	(part->dkstats.field += addnd)
+
+#define __all_stat_add(gendiskp, field, addnd, sector)		\
+({								\
+	struct hd_struct *part = get_part(gendiskp, sector);	\
+	if (part)						\
+		part->dkstats.field += addnd;			\
+	__disk_stat_add(gendiskp, field, addnd);		\
+})
+
+#define part_stat_read(part, field)	(part->dkstats.field)
+
+static inline void part_stat_set_all(struct hd_struct *part, int value)
+{
+	memset(&part->dkstats, value, sizeof(struct disk_stats));
+}
+
 #endif
 
 #define disk_stat_add(gendiskp, field, addnd)			\
@@ -206,6 +274,45 @@ static inline void disk_stat_set_all(str
 #define disk_stat_sub(gendiskp, field, subnd) \
 		disk_stat_add(gendiskp, field, -subnd)
 
+#define part_stat_add(gendiskp, field, addnd)		\
+	do {						\
+		preempt_disable();			\
+		__part_stat_add(gendiskp, field, addnd);\
+		preempt_enable();			\
+	} while (0)
+
+#define __part_stat_dec(gendiskp, field) __part_stat_add(gendiskp, field, -1)
+#define part_stat_dec(gendiskp, field) part_stat_add(gendiskp, field, -1)
+
+#define __part_stat_inc(gendiskp, field) __part_stat_add(gendiskp, field, 1)
+#define part_stat_inc(gendiskp, field) part_stat_add(gendiskp, field, 1)
+
+#define __part_stat_sub(gendiskp, field, subnd) \
+		__part_stat_add(gendiskp, field, -subnd)
+#define part_stat_sub(gendiskp, field, subnd) \
+		part_stat_add(gendiskp, field, -subnd)
+
+#define all_stat_add(gendiskp, field, addnd, sector)		\
+	do {							\
+		preempt_disable();				\
+		__all_stat_add(gendiskp, field, addnd, sector);	\
+		preempt_enable();				\
+	} while (0)
+
+#define __all_stat_dec(gendiskp, field, sector) \
+		__all_stat_add(gendiskp, field, -1, sector)
+#define all_stat_dec(gendiskp, field, sector) \
+		all_stat_add(gendiskp, field, -1, sector)
+
+#define __all_stat_inc(gendiskp, field, sector) \
+		__all_stat_add(gendiskp, field, 1, sector)
+#define all_stat_inc(gendiskp, field, sector) \
+		all_stat_add(gendiskp, field, 1, sector)
+
+#define __all_stat_sub(gendiskp, field, subnd, sector) \
+		__all_stat_add(gendiskp, field, -subnd, sector)
+#define all_stat_sub(gendiskp, field, subnd, sector) \
+		all_stat_add(gendiskp, field, -subnd, sector)
 
 /* Inlines to alloc and free disk stats in struct gendisk */
 #ifdef  CONFIG_SMP
@@ -221,6 +328,20 @@ static inline void free_disk_stats(struc
 {
 	free_percpu(disk->dkstats);
 }
+
+static inline int init_part_stats(struct hd_struct *part)
+{
+	part->dkstats = alloc_percpu(struct disk_stats);
+	if (!part->dkstats)
+		return 0;
+	return 1;
+}
+
+static inline void free_part_stats(struct hd_struct *part)
+{
+	free_percpu(part->dkstats);
+}
+
 #else	/* CONFIG_SMP */
 static inline int init_disk_stats(struct gendisk *disk)
 {
@@ -230,6 +351,15 @@ static inline int init_disk_stats(struct
 static inline void free_disk_stats(struct gendisk *disk)
 {
 }
+
+static inline int init_part_stats(struct hd_struct *part)
+{
+	return 1;
+}
+
+static inline void free_part_stats(struct hd_struct *part)
+{
+}
 #endif	/* CONFIG_SMP */
 
 /* drivers/block/ll_rw_blk.c */

