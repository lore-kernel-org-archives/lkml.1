Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbZLGDyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbZLGDyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934635AbZLGDys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:54:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51500 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934659AbZLGDyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:54:45 -0500
Date: Mon, 07 Dec 2009 03:54:51 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 18/19] Get rid of open-coding in ia64_brk()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUgV-0007zH-2z@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The comment in there used to be true, but these days do_brk() does
the arch-specific check that covers what we open-coded here.  So we
can use sys_brk() just fine, only need to do force_successful_syscall_return()
after it.

See commit 3a459756810912d2c2bf188cef566af255936b4d - that's when the
checks in do_brk() had been originally added.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/sys_ia64.c |   46 +------------------------------------------
 1 files changed, 1 insertions(+), 45 deletions(-)

diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index ae384a2..609d500 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -100,51 +100,7 @@ sys_getpagesize (void)
 asmlinkage unsigned long
 ia64_brk (unsigned long brk)
 {
-	unsigned long rlim, retval, newbrk, oldbrk;
-	struct mm_struct *mm = current->mm;
-
-	/*
-	 * Most of this replicates the code in sys_brk() except for an additional safety
-	 * check and the clearing of r8.  However, we can't call sys_brk() because we need
-	 * to acquire the mmap_sem before we can do the test...
-	 */
-	down_write(&mm->mmap_sem);
-
-	if (brk < mm->end_code)
-		goto out;
-	newbrk = PAGE_ALIGN(brk);
-	oldbrk = PAGE_ALIGN(mm->brk);
-	if (oldbrk == newbrk)
-		goto set_brk;
-
-	/* Always allow shrinking brk. */
-	if (brk <= mm->brk) {
-		if (!do_munmap(mm, newbrk, oldbrk-newbrk))
-			goto set_brk;
-		goto out;
-	}
-
-	/* Check against unimplemented/unmapped addresses: */
-	if ((newbrk - oldbrk) > RGN_MAP_LIMIT || REGION_OFFSET(newbrk) > RGN_MAP_LIMIT)
-		goto out;
-
-	/* Check against rlimit.. */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
-	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
-		goto out;
-
-	/* Check against existing mmap mappings. */
-	if (find_vma_intersection(mm, oldbrk, newbrk+PAGE_SIZE))
-		goto out;
-
-	/* Ok, looks good - let it rip. */
-	if (do_brk(oldbrk, newbrk-oldbrk) != oldbrk)
-		goto out;
-set_brk:
-	mm->brk = brk;
-out:
-	retval = mm->brk;
-	up_write(&mm->mmap_sem);
+	unsigned long retval = sys_brk(brk);
 	force_successful_syscall_return();
 	return retval;
 }
-- 
1.5.6.5


