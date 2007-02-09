Return-Path: <linux-kernel-owner+w=401wt.eu-S2992783AbXBITgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992783AbXBITgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992781AbXBITgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:36:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16880 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992780AbXBITgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:36:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=umo366W37ViF9Ym/Mw04XWWl4qTLyvp612OnyOZMxsnj1z2Ka4k3f7UMiinnNDszD
	H4ghdMGQNQ61ahsKOgxog==
Date: Fri, 9 Feb 2007 11:36:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/3] smaps: add pages referenced count to smaps
In-Reply-To: <Pine.LNX.4.64.0702082208270.10206@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702082209440.10206@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702082208270.10206@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an additional unsigned long field to struct mem_size_stats called
'referenced'.  For each pte walked in the smaps code, this field is
incremented by PAGE_SIZE if it has pte-reference bits.

An additional line was added to the /proc/pid/smaps output for each VMA
to indicate how many pages within it are currently marked as referenced
or accessed.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/task_mmu.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -120,6 +120,7 @@ struct mem_size_stats
 	unsigned long shared_dirty;
 	unsigned long private_clean;
 	unsigned long private_dirty;
+	unsigned long referenced;
 };
 
 struct pmd_walker {
@@ -188,18 +189,20 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 
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
+			   "Pgs_Referenced: %8lu kB\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
 			   mss->shared_clean  >> 10,
 			   mss->shared_dirty  >> 10,
 			   mss->private_clean >> 10,
-			   mss->private_dirty >> 10);
+			   mss->private_dirty >> 10,
+			   mss->referenced >> 10);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
@@ -232,6 +235,9 @@ static void smaps_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		if (!page)
 			continue;
 
+		/* Accumulate the size in pages that have been accessed. */
+		if (pte_young(ptent) || PageReferenced(page))
+			mss->referenced += PAGE_SIZE;
 		if (page_mapcount(page) >= 2) {
 			if (pte_dirty(ptent))
 				mss->shared_dirty += PAGE_SIZE;
