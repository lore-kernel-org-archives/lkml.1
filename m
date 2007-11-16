Return-Path: <linux-kernel-owner+w=401wt.eu-S935573AbXKPXRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573AbXKPXRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934856AbXKPXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51810 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761575AbXKPXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:05 -0500
Message-Id: <20071116231105.230572764@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:33 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 13/30] cpu alloc: genhd statistics conversion
Content-Disposition: inline; filename=0023-cpu-alloc-genhd-statistics-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/genhd.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h	2007-11-15 21:18:07.967654575 -0800
+++ linux-2.6/include/linux/genhd.h	2007-11-15 21:25:31.066904143 -0800
@@ -158,21 +158,21 @@ struct disk_attribute {
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
 				
@@ -209,7 +209,7 @@ static inline void disk_stat_set_all(str
 #ifdef  CONFIG_SMP
 static inline int init_disk_stats(struct gendisk *disk)
 {
-	disk->dkstats = alloc_percpu(struct disk_stats);
+	disk->dkstats = CPU_ALLOC(struct disk_stats, GFP_KERNEL | __GFP_ZERO);
 	if (!disk->dkstats)
 		return 0;
 	return 1;
@@ -217,7 +217,7 @@ static inline int init_disk_stats(struct
 
 static inline void free_disk_stats(struct gendisk *disk)
 {
-	free_percpu(disk->dkstats);
+	CPU_FREE(disk->dkstats);
 }
 #else	/* CONFIG_SMP */
 static inline int init_disk_stats(struct gendisk *disk)

-- 
