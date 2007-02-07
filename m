Return-Path: <linux-kernel-owner+w=401wt.eu-S965639AbXBGF1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbXBGF1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXBGF1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:27:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:63389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965639AbXBGF1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:27:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=kZ7wHfeDR0cWEug28KkY1SEXXlqxc3zYjq7Qin4Q0TE4KmwN18vA+gaQ6n8XDNOCv
	mZrPTubJJSHBW+PxkZrFQ==
Date: Tue, 6 Feb 2007 21:27:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/3] smaps: add pages referenced count to smaps
In-Reply-To: <Pine.LNX.4.64.0702062121160.8623@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062121160.8623@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an additional unsigned long field to struct mem_size_stats:
referenced.  For each page table entry that is walked for the VMA in the
smaps code, this field is incremented if PG_referenced is set.

An additional line was added to the /proc/pid/smaps output for each VMA
to indicate how many pages within it are currently marked as accessed
(referenced).

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/task_mmu.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e87824b..a1f5e87 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -120,6 +120,7 @@ struct mem_size_stats
 	unsigned long shared_dirty;
 	unsigned long private_clean;
 	unsigned long private_dirty;
+	unsigned long referenced;
 };
 
 struct pte_walker {
@@ -190,18 +191,20 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 
 	if (mss)
 		seq_printf(m,
-			   "Size:          %8lu kB\n"
-			   "Rss:           %8lu kB\n"
-			   "Shared_Clean:  %8lu kB\n"
-			   "Shared_Dirty:  %8lu kB\n"
-			   "Private_Clean: %8lu kB\n"
-			   "Private_Dirty: %8lu kB\n",
+			   "Size:           %8lu kB\n"
+			   "Rss:            %8lu kB\n"
+			   "Shared_Clean:   %8lu kB\n"
+			   "Shared_Dirty:   %8lu kB\n"
+			   "Private_Clean:  %8lu kB\n"
+			   "Private_Dirty:  %8lu kB\n"
+			   "Pgs_Referenced: %8li\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
 			   mss->shared_clean  >> 10,
 			   mss->shared_dirty  >> 10,
 			   mss->private_clean >> 10,
-			   mss->private_dirty >> 10);
+			   mss->private_dirty >> 10,
+			   mss->referenced);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
@@ -302,6 +305,9 @@ static void smaps_pte_func(struct pte_walker *walker, pte_t *pte,
 	if (!page)
 		return;
 
+	/* Accumulate the number of pages that have been accessed. */
+	if (PageReferenced(page))
+		mss->referenced++;
 	if (page_mapcount(page) >= 2) {
 		if (pte_dirty(ptent))
 			mss->shared_dirty += PAGE_SIZE;
