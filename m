Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXKTBSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXKTBSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXKTBNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:50 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49848 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754068AbXKTBNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:35 -0500
Message-Id: <20071120011335.271090379@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:47 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 15/45] cpu alloc: genhd statistics conversion
Content-Disposition: inline; filename=0023-cpu-alloc-genhd-statistics-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/genhd.h |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h	2007-11-18 14:38:24.285456612 -0800
+++ linux-2.6/include/linux/genhd.h	2007-11-18 22:04:47.428523761 -0800
@@ -158,21 +158,21 @@ struct disk_attribute {
  */
 #ifdef	CONFIG_SMP
 #define __disk_stat_add(gendiskp, field, addnd) 	\
-	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
+	__CPU_ADD(gendiskp->dkstats->field, addnd)
 
 #define disk_stat_read(gendiskp, field)					\
 ({									\
 	typeof(gendiskp->dkstats->field) res = 0;			\
 	int i;								\
 	for_each_possible_cpu(i)					\
-		res += per_cpu_ptr(gendiskp->dkstats, i)->field;	\
+		res += CPU_PTR(gendiskp->dkstats, i)->field;	\
 	res;								\
 })
 
 static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
 	int i;
 	for_each_possible_cpu(i)
-		memset(per_cpu_ptr(gendiskp->dkstats, i), value,
+		memset(CPU_PTR(gendiskp->dkstats, i), value,
 				sizeof (struct disk_stats));
 }		
 				
@@ -187,11 +187,7 @@ static inline void disk_stat_set_all(str
 #endif
 
 #define disk_stat_add(gendiskp, field, addnd)			\
-	do {							\
-		preempt_disable();				\
-		__disk_stat_add(gendiskp, field, addnd);	\
-		preempt_enable();				\
-	} while (0)
+	_CPU_ADD(gendiskp->dkstats->field, addnd);
 
 #define __disk_stat_dec(gendiskp, field) __disk_stat_add(gendiskp, field, -1)
 #define disk_stat_dec(gendiskp, field) disk_stat_add(gendiskp, field, -1)
@@ -209,7 +205,7 @@ static inline void disk_stat_set_all(str
 #ifdef  CONFIG_SMP
 static inline int init_disk_stats(struct gendisk *disk)
 {
-	disk->dkstats = alloc_percpu(struct disk_stats);
+	disk->dkstats = CPU_ALLOC(struct disk_stats, GFP_KERNEL | __GFP_ZERO);
 	if (!disk->dkstats)
 		return 0;
 	return 1;
@@ -217,7 +213,7 @@ static inline int init_disk_stats(struct
 
 static inline void free_disk_stats(struct gendisk *disk)
 {
-	free_percpu(disk->dkstats);
+	CPU_FREE(disk->dkstats);
 }
 #else	/* CONFIG_SMP */
 static inline int init_disk_stats(struct gendisk *disk)

-- 
