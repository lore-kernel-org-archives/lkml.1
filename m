Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZL1CqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZL1CqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZL1CqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:46:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34196 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZL1CqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:46:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [cleanup][PATCH 1/2] mlock_vma_pages_range() never return negative value
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091228114519.A678.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Dec 2009 11:45:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, mlock_vma_pages_range() never return negative value. Then, we can
remove some worthless error check.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mmap.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 64e0b04..826b0ec 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1247,12 +1247,7 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		/*
-		 * makes pages present; downgrades, drops, reacquires mmap_sem
-		 */
 		long nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
-		if (nr_pages < 0)
-			return nr_pages;	/* vma gone! */
 		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
@@ -1730,8 +1725,7 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
-		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
-			return NULL;	/* vma gone! */
+		mlock_vma_pages_range(prev, addr, prev->vm_end);
 	}
 	return prev;
 }
@@ -1759,8 +1753,7 @@ find_extend_vma(struct mm_struct * mm, unsigned long addr)
 	if (expand_stack(vma, addr))
 		return NULL;
 	if (vma->vm_flags & VM_LOCKED) {
-		if (mlock_vma_pages_range(vma, addr, start) < 0)
-			return NULL;	/* vma gone! */
+		mlock_vma_pages_range(vma, addr, start);
 	}
 	return vma;
 }
-- 
1.6.5.2



