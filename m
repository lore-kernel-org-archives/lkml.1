Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbXKFTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbXKFTyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbXKFTwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:16 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45379 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755520AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195200.397618090@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:56 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/28] cpu alloc: genhd statistics conversion
Content-Disposition: inline; filename=cpu_alloc_genhd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/genhd.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h	2007-11-04 19:32:40.000000000 -0800
+++ linux-2.6/include/linux/genhd.h	2007-11-04 19:35:51.000000000 -0800
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 
 #ifdef CONFIG_BLOCK
+#include <linux/cpu_alloc.h>
 
 enum {
 /* These three have identical behaviour; use the second one if DOS FDISK gets
@@ -158,21 +159,21 @@ struct disk_attribute {
  */
 #ifdef	CONFIG_SMP
 #define __disk_stat_add(gendiskp, field, addnd) 	\
-	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
+	(THIS_CPU(gendiskp->dkstats)->field += addnd)
 
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
 				
@@ -209,7 +210,7 @@ static inline void disk_stat_set_all(str
 #ifdef  CONFIG_SMP
 static inline int init_disk_stats(struct gendisk *disk)
 {
-	disk->dkstats = alloc_percpu(struct disk_stats);
+	disk->dkstats = CPU_ALLOC(struct disk_stats, GFP_KERNEL | __GFP_ZERO);
 	if (!disk->dkstats)
 		return 0;
 	return 1;
@@ -217,7 +218,7 @@ static inline int init_disk_stats(struct
 
 static inline void free_disk_stats(struct gendisk *disk)
 {
-	free_percpu(disk->dkstats);
+	CPU_FREE(disk->dkstats);
 }
 #else	/* CONFIG_SMP */
 static inline int init_disk_stats(struct gendisk *disk)

-- 
