Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXK1TBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXK1TBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXK1TAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:00:54 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60037 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXK1TAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:00:54 -0500
Date: Wed, 28 Nov 2007 18:59:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ethan Solomita <solo@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] don't waste swap on locked pages
Message-ID: <Pine.LNX.4.64.0711281857180.25292@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_unmap always fails on a page found in a VM_LOCKED vma (unless
migrating), and recycles it back to the active list.  But if it's an
anonymous page, we've already allocated swap to it: just wasting swap.
Spot locked pages in page_referenced_one and treat them as referenced.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---

 mm/rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 2.6.24-rc3-git/mm/rmap.c	2007-11-27 05:00:22.000000000 +0000
+++ linux/mm/rmap.c	2007-11-28 17:01:20.000000000 +0000
@@ -284,7 +284,10 @@ static int page_referenced_one(struct pa
 	if (!pte)
 		goto out;
 
-	if (ptep_clear_flush_young(vma, address, pte))
+	if (vma->vm_flags & VM_LOCKED) {
+		referenced++;
+		*mapcount = 1;	/* break early from loop */
+	} else if (ptep_clear_flush_young(vma, address, pte))
 		referenced++;
 
 	/* Pretend the page is referenced if the task has the
