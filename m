Return-Path: <linux-kernel-owner+w=401wt.eu-S1764358AbZFQDl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764358AbZFQDl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763619AbZFQDln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:41:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57210 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764313AbZFQDll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:41:41 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH 1/9] percpu: fix too lazy vunmap cache flushing
Date: Wed, 17 Jun 2009 12:40:52 +0900
Message-Id: <1245210060-24344-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245210060-24344-1-git-send-email-tj@kernel.org>
References: <1245210060-24344-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 03:41:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pcpu_unmap(), flushing virtual cache on vunmap can't be delayed as
the page is going to be returned to the page allocator.  Only TLB
flushing can be put off such that vmalloc code can handle it lazily.
Fix it.

[ Impact: fix subtle virtual cache flush bug ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/percpu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index c0b2c1a..d06f474 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -549,14 +549,14 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
  * @chunk: chunk of interest
  * @page_start: page index of the first page to unmap
  * @page_end: page index of the last page to unmap + 1
- * @flush: whether to flush cache and tlb or not
+ * @flush_tlb: whether to flush tlb or not
  *
  * For each cpu, unmap pages [@page_start,@page_end) out of @chunk.
  * If @flush is true, vcache is flushed before unmapping and tlb
  * after.
  */
 static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
-		       bool flush)
+		       bool flush_tlb)
 {
 	unsigned int last = num_possible_cpus() - 1;
 	unsigned int cpu;
@@ -569,9 +569,8 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 	 * the whole region at once rather than doing it for each cpu.
 	 * This could be an overkill but is more scalable.
 	 */
-	if (flush)
-		flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
-				   pcpu_chunk_addr(chunk, last, page_end));
+	flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
+			   pcpu_chunk_addr(chunk, last, page_end));
 
 	for_each_possible_cpu(cpu)
 		unmap_kernel_range_noflush(
@@ -579,7 +578,7 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 				(page_end - page_start) << PAGE_SHIFT);
 
 	/* ditto as flush_cache_vunmap() */
-	if (flush)
+	if (flush_tlb)
 		flush_tlb_kernel_range(pcpu_chunk_addr(chunk, 0, page_start),
 				       pcpu_chunk_addr(chunk, last, page_end));
 }
-- 
1.6.0.2

