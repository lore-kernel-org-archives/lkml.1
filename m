Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZIXM5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZIXM5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZIXM5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:57:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:49627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZIXM5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:57:23 -0400
Message-ID: <4ABB6CA0.7040408@kernel.org>
Date: Thu, 24 Sep 2009 21:57:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] percpu: make embedding first chunk allocator check vmalloc
 space size
References: <4ABB6C3A.8070109@kernel.org> <4ABB6C80.20109@kernel.org>
In-Reply-To: <4ABB6C80.20109@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 12:57:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Embedding first chunk allocator maintains the distances between units
in the vmalloc area and thus needs vmalloc space to be larger than the
maximum distances between units; otherwise, it wouldn't be able to
create any dynamic chunks.  This patch makes the embedding first chunk
allocator check vmalloc space size and if the maximum distance between
units is larger than 75% of it, print warning and, if page mapping
allocator is available, fail initialization so that the system falls
back onto it.

This should work around percpu allocation failure problems on certain
sparc64 configurations where distances between NUMA nodes are larger
than the vmalloc area and makes percpu allocator more robust for
future configurations.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -1786,7 +1786,7 @@ int __init pcpu_embed_first_chunk(size_t
 	void *base = (void *)ULONG_MAX;
 	void **areas = NULL;
 	struct pcpu_alloc_info *ai;
-	size_t size_sum, areas_size;
+	size_t size_sum, areas_size, max_distance;
 	int group, i, rc;

 	ai = pcpu_build_alloc_info(reserved_size, dyn_size, atom_size,
@@ -1836,8 +1836,24 @@ int __init pcpu_embed_first_chunk(size_t
 	}

 	/* base address is now known, determine group base offsets */
-	for (group = 0; group < ai->nr_groups; group++)
+	max_distance = 0;
+	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
+		max_distance = max(max_distance, ai->groups[group].base_offset);
+	}
+	max_distance += ai->unit_size;
+
+	/* warn if maximum distance is further than 75% of vmalloc space */
+	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
+		pr_warning("PERCPU: max_distance=0x%lx too large for vmalloc "
+			   "space 0x%lx\n",
+			   max_distance, VMALLOC_END - VMALLOC_START);
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+		/* and fail if we have fallback */
+		rc = -EINVAL;
+		goto out_free;
+#endif
+	}

 	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
 		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
