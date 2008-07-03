Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYGCUvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYGCUvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYGCUvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:51:10 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60814 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYGCUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:51:09 -0400
Date: Thu, 3 Jul 2008 21:50:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 2.6.26-rc8-mm1] memrlimit: fix mmap_sem deadlock
Message-ID: <Pine.LNX.4.64.0807032143110.10641@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ps -f" hung after "killall make" of make -j20 kernel builds.  It's
generally considered bad manners to down_write something you already
have down_read.  exit_mm up_reads before calling mm_update_next_owner,
so I guess exec_mmap can safely do so too.  (And with that repositioning
there's not much point in mm_need_new_owner allowing for NULL mm.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Fix to memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
quite independent of its recent sleeping-inside-spinlock fix; could even
be applied to 2.6.26, though no deadlock there.  Gosh, I see those patches
have spawned "Reviewed-by" tags in my name: sorry, no, just "Bug-found-by".

 fs/exec.c     |    2 +-
 kernel/exit.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- 2.6.26-rc8-mm1/fs/exec.c	2008-07-03 11:35:20.000000000 +0100
+++ linux/fs/exec.c	2008-07-03 20:27:20.000000000 +0100
@@ -738,11 +738,11 @@ static int exec_mmap(struct mm_struct *m
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	mm_update_next_owner(old_mm);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
+		mm_update_next_owner(old_mm);
 		mmput(old_mm);
 		return 0;
 	}
--- 2.6.26-rc8-mm1/kernel/exit.c	2008-07-03 11:35:37.000000000 +0100
+++ linux/kernel/exit.c	2008-07-03 20:28:35.000000000 +0100
@@ -588,8 +588,6 @@ mm_need_new_owner(struct mm_struct *mm, 
 	 * If there are other users of the mm and the owner (us) is exiting
 	 * we need to find a new owner to take on the responsibility.
 	 */
-	if (!mm)
-		return 0;
 	if (atomic_read(&mm->mm_users) <= 1)
 		return 0;
 	if (mm->owner != p)
