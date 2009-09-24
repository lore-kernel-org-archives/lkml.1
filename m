Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZIXLdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZIXLdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZIXLdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:33:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZIXLdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:33:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] NOMMU: There are no pagetables for walk_page_range() in
	NOMMU mode
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 24 Sep 2009 12:33:37 +0100
Message-ID: <20090924113337.6031.10798.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
References: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

walk_page_range() can't walk the page tables in NOMMU mode, so make it
unavailable in such circumstances.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mm.h |    3 +++
 mm/Makefile        |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 23e7fd6..17dc39f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -750,6 +750,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlb,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
 
+#ifdef CONFIG_MMU
 /**
  * mm_walk - callbacks for walk_page_range
  * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
@@ -772,6 +773,8 @@ struct mm_walk {
 
 int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
+#endif
+
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
diff --git a/mm/Makefile b/mm/Makefile
index 88193d7..5ac31a1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -5,14 +5,14 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o
+			   vmalloc.o pagewalk.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o \
-			   pagewalk.o $(mmu-y)
+			   $(mmu-y)
 obj-y += init-mm.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o

