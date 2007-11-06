Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXKFUAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXKFUAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXKFTwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45399 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756009AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195201.313555062@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:00 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 16/28] cpu alloc: NFS statistics
Content-Disposition: inline; filename=cpu_alloc_nfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/nfs/iostat.h           |    9 +++++----
 fs/nfs/super.c            |    2 +-
 include/linux/neighbour.h |    1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h	2007-11-04 20:13:52.000000000 -0800
+++ linux-2.6/fs/nfs/iostat.h	2007-11-04 20:16:48.000000000 -0800
@@ -20,6 +20,7 @@
 
 #ifndef _NFS_IOSTAT
 #define _NFS_IOSTAT
+#include <linux/cpu_alloc.h>
 
 #define NFS_IOSTAT_VERS		"1.0"
 
@@ -123,7 +124,7 @@ static inline void nfs_inc_server_stats(
 	int cpu;
 
 	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
+	iostats = CPU_PTR(server->io_stats, cpu);
 	iostats->events[stat] ++;
 	put_cpu_no_resched();
 }
@@ -139,7 +140,7 @@ static inline void nfs_add_server_stats(
 	int cpu;
 
 	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
+	iostats = CPU_PTR(server->io_stats, cpu);
 	iostats->bytes[stat] += addend;
 	put_cpu_no_resched();
 }
@@ -151,13 +152,13 @@ static inline void nfs_add_stats(struct 
 
 static inline struct nfs_iostats *nfs_alloc_iostats(void)
 {
-	return alloc_percpu(struct nfs_iostats);
+	return CPU_ALLOC(struct nfs_iostats, GFP_KERNEL | __GFP_ZERO);
 }
 
 static inline void nfs_free_iostats(struct nfs_iostats *stats)
 {
 	if (stats != NULL)
-		free_percpu(stats);
+		CPU_FREE(stats);
 }
 
 #endif
Index: linux-2.6/include/linux/neighbour.h
===================================================================
--- linux-2.6.orig/include/linux/neighbour.h	2007-11-04 20:13:52.000000000 -0800
+++ linux-2.6/include/linux/neighbour.h	2007-11-04 20:16:48.000000000 -0800
@@ -2,6 +2,7 @@
 #define __LINUX_NEIGHBOUR_H
 
 #include <linux/netlink.h>
+#include <linux/cpu_alloc.h>
 
 struct ndmsg
 {
Index: linux-2.6/fs/nfs/super.c
===================================================================
--- linux-2.6.orig/fs/nfs/super.c	2007-11-04 20:15:41.000000000 -0800
+++ linux-2.6/fs/nfs/super.c	2007-11-04 20:16:51.000000000 -0800
@@ -529,7 +529,7 @@ static int nfs_show_stats(struct seq_fil
 		struct nfs_iostats *stats;
 
 		preempt_disable();
-		stats = per_cpu_ptr(nfss->io_stats, cpu);
+		stats = CPU_PTR(nfss->io_stats, cpu);
 
 		for (i = 0; i < __NFSIOS_COUNTSMAX; i++)
 			totals.events[i] += stats->events[i];

-- 
