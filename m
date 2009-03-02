Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZCBGrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZCBGrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZCBGrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:47:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:34437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbZCBGri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:47:38 -0500
Date: Mon, 2 Mar 2009 07:47:36 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Subject: [patch 1/2] slqb: fix deadlock
Message-ID: <20090302064735.GA1257@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the lockdep error reported by Fengguang where down_read slqb_lock
is taken twice when reading /proc/slabinfo, with the possibility for a
deadlock.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/slqb.c
===================================================================
--- linux-2.6.orig/mm/slqb.c	2009-03-02 17:42:09.000000000 +1100
+++ linux-2.6/mm/slqb.c	2009-03-02 17:44:10.000000000 +1100
@@ -3075,7 +3075,9 @@ static void __gather_stats(void *arg)
 	spin_unlock(&gather->lock);
 }
 
-static void gather_stats(struct kmem_cache *s, struct stats_gather *stats)
+/* must be called with slqb_lock held */
+static void gather_stats_locked(struct kmem_cache *s,
+				struct stats_gather *stats)
 {
 #ifdef CONFIG_NUMA
 	int node;
@@ -3085,8 +3087,6 @@ static void gather_stats(struct kmem_cac
 	stats->s = s;
 	spin_lock_init(&stats->lock);
 
-	down_read(&slqb_lock); /* hold off hotplug */
-
 	on_each_cpu(__gather_stats, stats, 1);
 
 #ifdef CONFIG_NUMA
@@ -3115,10 +3115,15 @@ static void gather_stats(struct kmem_cac
 	}
 #endif
 
-	up_read(&slqb_lock);
-
 	stats->nr_objects = stats->nr_slabs * s->objects;
 }
+
+static void gather_stats(struct kmem_cache *s, struct stats_gather *stats)
+{
+	down_read(&slqb_lock); /* hold off hotplug */
+	gather_stats_locked(s, stats);
+	up_read(&slqb_lock);
+}
 #endif
 
 /*
@@ -3171,7 +3176,7 @@ static int s_show(struct seq_file *m, vo
 
 	s = list_entry(p, struct kmem_cache, list);
 
-	gather_stats(s, &stats);
+	gather_stats_locked(s, &stats);
 
 	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d", s->name, stats.nr_inuse,
 			stats.nr_objects, s->size, s->objects, (1 << s->order));
