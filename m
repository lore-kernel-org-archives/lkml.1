Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbZFQMMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbZFQMMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbZFQML6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:11:58 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48247 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755769AbZFQML5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:11:57 -0400
Subject: Re: WARNING: at mm/page_alloc.c:1159
	get_page_from_freelist+0x325/0x655()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20090617113120.GA5061@elte.hu>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu>  <20090617113120.GA5061@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Jun 2009 13:11:17 +0100
Message-Id: <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 12:11:18.0251 (UTC) FILETIME=[B81D43B0:01C9EF44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 13:31 +0200, Ingo Molnar wrote:
> a new warning started popping up today, in the new page allocator 
> code. The allocation came from kmemleak:
> 
> WARNING: at mm/page_alloc.c:1159 get_page_from_freelist+0x325/0x655()
> Hardware name: System Product Name
> Modules linked in:
> Pid: 4367, comm: ifup Not tainted 2.6.30-tip-04303-g5ada65e-dirty #54431
> Call Trace:
>  [<ffffffff810dba73>] ? get_page_from_freelist+0x325/0x655
>  [<ffffffff8106f140>] warn_slowpath_common+0x88/0xcb
>  [<ffffffff8106f1a5>] warn_slowpath_null+0x22/0x38
>  [<ffffffff810dba73>] get_page_from_freelist+0x325/0x655
>  [<ffffffff810dc18c>] __alloc_pages_nodemask+0x14c/0x5b0
>  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
>  [<ffffffff8103b1c8>] ? native_sched_clock+0x40/0x79
>  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
>  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
>  [<ffffffff81102417>] alloc_pages_current+0xcc/0xeb
>  [<ffffffff81107a78>] alloc_slab_page+0x2a/0x7e
>  [<ffffffff81107b27>] new_slab+0x5b/0x210
>  [<ffffffff811063fa>] ? deactivate_slab+0xe7/0x16b
>  [<ffffffff81108253>] __slab_alloc+0x214/0x3da
>  [<ffffffff8110f58d>] ? kmemleak_alloc+0x83/0x35a
>  [<ffffffff8110f58d>] ? kmemleak_alloc+0x83/0x35a
>  [<ffffffff8110863c>] kmem_cache_alloc+0xac/0x14e
>  [<ffffffff8110f58d>] kmemleak_alloc+0x83/0x35a
>  [<ffffffff812b6436>] ? cfq_get_queue+0x101/0x231
>  [<ffffffff81108511>] kmem_cache_alloc_node+0xf8/0x177
>  [<ffffffff812b6436>] ? cfq_get_queue+0x101/0x231
>  [<ffffffff812b6436>] cfq_get_queue+0x101/0x231

Kmemleak needs to allocate memory for the pointer tracing and it
currently passes the same gfp flags as those used by the original
caller. In this case cfq_find_alloc_queue uses __GFP_NOFAIL.

The reason for this was to avoid GFP_ATOMIC if the caller wasn't
requiring it. I think the approach below is better:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 58ec86c..46c9c93 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -462,7 +462,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	struct prio_tree_node *node;
 	struct stack_trace trace;
 
-	object = kmem_cache_alloc(object_cache, gfp & ~GFP_SLAB_BUG_MASK);
+	object = kmem_cache_alloc(object_cache, gfp & (GFP_KERNEL | GFP_ATOMIC));
 	if (!object) {
 		kmemleak_panic("kmemleak: Cannot allocate a kmemleak_object "
 			       "structure\n");
@@ -636,7 +636,7 @@ static void add_scan_area(unsigned long ptr, unsigned long offset,
 		return;
 	}
 
-	area = kmem_cache_alloc(scan_area_cache, gfp & ~GFP_SLAB_BUG_MASK);
+	area = kmem_cache_alloc(scan_area_cache, gfp & (GFP_KERNEL | GFP_ATOMIC));
 	if (!area) {
 		kmemleak_warn("kmemleak: Cannot allocate a scan area\n");
 		goto out;

-- 
Catalin

