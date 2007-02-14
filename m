Return-Path: <linux-kernel-owner+w=401wt.eu-S1751177AbXBNEaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbXBNEaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 23:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXBNEaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 23:30:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbXBNEaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 23:30:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=dUAU6m0orsxdoB1rVk2fAJFArzwKd0GuSDtSi/FZUaLd4fyA81QsRtkyTZJTmxNni
	IQdo9xSETVNqykSMF9E4g==
Date: Tue, 13 Feb 2007 20:29:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Paul Mundt <lethal@linux-sh.org>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm] smaps: flush tlb only once for each vma 
Message-ID: <Pine.LNX.4.64.0702132025310.11450@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Flush the entire user address space from the TLB for each VMA in the 
task_struct list when clearing reference bits with /proc/pid/clear_refs.  
It's more efficient than flushing each page individually depending on 
pte_young().

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -276,7 +276,6 @@ static void clear_refs_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		if (pte_young(ptent)) {
 			ptent = pte_mkold(ptent);
 			set_pte_at(vma->vm_mm, addr, pte, ptent);
-			flush_tlb_page(vma, addr);
 		}
 		ClearPageReferenced(page);
 	}
@@ -358,6 +357,7 @@ void clear_refs_smap(struct mm_struct *mm)
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }
 
