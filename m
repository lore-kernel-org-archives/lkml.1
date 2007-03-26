Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXCZAgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXCZAgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933258AbXCZAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:36:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbXCZAgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:36:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=t+rMMYJns24GkvA0pFGWXStqBAS3BEwDWx//yggV+hReAC3WDZV/pqIqpicA6O4kL
	7tmExn6lh1WgALIz3mtlg==
Date: Sun, 25 Mar 2007 17:35:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: [patch -mm 2/2] smaps: use ptep_test_and_clear_young
In-Reply-To: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0703251733080.19025@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use arch-specified ptep_test_and_clear_young() to clear the pte accessed
bits for /proc/pid/clear_refs.  This avoids a race condition if a pte is
modified between pte_mkold() and set_pte_at().

Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/task_mmu.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -277,10 +277,7 @@ static void clear_refs_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			continue;
 
 		/* Clear accessed and referenced bits. */
-		if (pte_young(ptent)) {
-			ptent = pte_mkold(ptent);
-			set_pte_at(vma->vm_mm, addr, pte, ptent);
-		}
+		ptep_test_and_clear_young(vma, addr, pte);
 		ClearPageReferenced(page);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
