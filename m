Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbYDQBQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbYDQBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYDQBHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:50 -0400
Received: from sous-sol.org ([216.99.217.87]:58880 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbYDQBHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:48 -0400
Message-Id: <20080417010331.416680812@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, snitzer@gmail.com,
       dada1@cosmosbay.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: alloc_percpu() fails to allocate percpu data
Content-Disposition: inline; filename=alloc_percpu-fails-to-allocate-percpu-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Dumazet <dada1@cosmosbay.com>

upstream commit: be852795e1c8d3829ddf3cb1ce806113611fa555

Some oprofile results obtained while using tbench on a 2x2 cpu machine were
very surprising.

For example, loopback_xmit() function was using high number of cpu cycles
to perform the statistic updates, supposed to be real cheap since they use
percpu data

        pcpu_lstats = netdev_priv(dev);
        lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
        lb_stats->packets++;  /* HERE : serious contention */
        lb_stats->bytes += skb->len;

struct pcpu_lstats is a small structure containing two longs.  It appears
that on my 32bits platform, alloc_percpu(8) allocates a single cache line,
instead of giving to each cpu a separate cache line.

Using the following patch gave me impressive boost in various benchmarks
( 6 % in tbench)
(all percpu_counters hit this bug too)

Long term fix (ie >= 2.6.26) would be to let each CPU allocate their own
block of memory, so that we dont need to roudup sizes to L1_CACHE_BYTES, or
merging the SGI stuff of course...

Note : SLUB vs SLAB is important here to *show* the improvement, since they
dont have the same minimum allocation sizes (8 bytes vs 32 bytes).  This
could very well explain regressions some guys reported when they switched
to SLUB.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/allocpercpu.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

This is appropriate for 2.6.24.y

--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -6,6 +6,10 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#ifndef cache_line_size
+#define cache_line_size()	L1_CACHE_BYTES
+#endif
+
 /**
  * percpu_depopulate - depopulate per-cpu data for given cpu
  * @__pdata: per-cpu data to depopulate
@@ -52,6 +56,11 @@ void *percpu_populate(void *__pdata, siz
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
 	int node = cpu_to_node(cpu);
 
+	/*
+	 * We should make sure each CPU gets private memory.
+	 */
+	size = roundup(size, cache_line_size());
+
 	BUG_ON(pdata->ptrs[cpu]);
 	if (node_online(node))
 		pdata->ptrs[cpu] = kmalloc_node(size, gfp|__GFP_ZERO, node);
@@ -98,7 +107,11 @@ EXPORT_SYMBOL_GPL(__percpu_populate_mask
  */
 void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
-	void *pdata = kzalloc(nr_cpu_ids * sizeof(void *), gfp);
+	/*
+	 * We allocate whole cache lines to avoid false sharing
+	 */
+	size_t sz = roundup(nr_cpu_ids * sizeof(void *), cache_line_size());
+	void *pdata = kzalloc(sz, gfp);
 	void *__pdata = __percpu_disguise(pdata);
 
 	if (unlikely(!pdata))

-- 
