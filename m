Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYLZGjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYLZGjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYLZGi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:38:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYLZGi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:38:58 -0500
Message-ID: <49547B93.5090905@cn.fujitsu.com>
Date: Fri, 26 Dec 2008 14:37:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: [PATCH] cpuset,mm: fix allocating page cache/slab object on the unallowed
 node when memory spread is set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task still allocated the page caches on old node after modifying its
cpuset's mems when 'memory_spread_page' was set, it is caused by the old
mem_allowed_list of the task. Slab has the same problem.

This patch fixes this bug.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 mm/filemap.c |    3 +++
 mm/slab.c    |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index f3e5f89..d978983 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -517,6 +517,9 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 #ifdef CONFIG_NUMA
 struct page *__page_cache_alloc(gfp_t gfp)
 {
+	if ((gfp & __GFP_WAIT) && !in_interrupt())
+		cpuset_update_task_memory_state();
+
 	if (cpuset_do_page_mem_spread()) {
 		int n = cpuset_mem_spread_node();
 		return alloc_pages_node(n, gfp, 0);
diff --git a/mm/slab.c b/mm/slab.c
index 0918751..3b6e3d7 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3460,6 +3460,9 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	if (should_failslab(cachep, flags))
 		return NULL;
 
+	if ((flags & __GFP_WAIT) && !in_interrupt())
+		cpuset_update_task_memory_state();
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
-- 
1.5.4.rc3


