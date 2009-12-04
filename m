Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZLDImt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZLDImt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZLDIms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:42:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58918 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZLDImr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:42:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] VM_LOCKED check don't need pte lock
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091204173233.5891.A69D9226@jp.fujitsu.com>
References: <20091204173233.5891.A69D9226@jp.fujitsu.com>
Message-Id: <20091204174217.589A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Dec 2009 17:42:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 24f910b1ac966c21ea5aab825d1f26815b760304 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 3 Dec 2009 16:06:47 +0900
Subject: [PATCH 3/7] VM_LOCKED check don't need pte lock

Currently, page_referenced_one() check VM_LOCKED after taking ptelock.
But it's unnecessary. We can check VM_LOCKED before to take lock.

This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/rmap.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1b50425..fb0983a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -383,21 +383,21 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	int referenced = 0;
 
-	pte = page_check_address(page, mm, address, &ptl, 0);
-	if (!pte)
-		goto out;
-
 	/*
 	 * Don't want to elevate referenced for mlocked page that gets this far,
 	 * in order that it progresses to try_to_unmap and is moved to the
 	 * unevictable list.
 	 */
 	if (vma->vm_flags & VM_LOCKED) {
-		*mapcount = 1;	/* break early from loop */
+		*mapcount = 0;	/* break early from loop */
 		*vm_flags |= VM_LOCKED;
-		goto out_unmap;
+		goto out;
 	}
 
+	pte = page_check_address(page, mm, address, &ptl, 0);
+	if (!pte)
+		goto out;
+
 	if (ptep_clear_flush_young_notify(vma, address, pte)) {
 		/*
 		 * Don't treat a reference through a sequentially read
@@ -416,7 +416,6 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 			rwsem_is_locked(&mm->mmap_sem))
 		referenced++;
 
-out_unmap:
 	(*mapcount)--;
 	pte_unmap_unlock(pte, ptl);
 
-- 
1.6.5.2



