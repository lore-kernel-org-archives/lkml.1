Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYFZJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYFZJaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYFZJ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:29:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45531 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbYFZJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:29:11 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Jun 2008 14:59:06 +0530
Message-Id: <20080626092906.16841.98723.sendpatchset@balbir-laptop>
In-Reply-To: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
References: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
Subject: [4/5] memrlimit improve fork and error handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The fork path of the memrlimit patches adds an additional down_write() of
mmap_sem. Ideally memrlimit should be zero overhead for non users and the
error handling path also needed improvement. This patch fixes both problems.

The accounting has now been moved from copy_mm() to dup_mmap()

Reported-by: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/fork.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN kernel/fork.c~memrlimit-improve-fork-error-handling kernel/fork.c
--- linux-2.6.26-rc5/kernel/fork.c~memrlimit-improve-fork-error-handling	2008-06-26 14:48:23.000000000 +0530
+++ linux-2.6.26-rc5-balbir/kernel/fork.c	2008-06-26 14:48:23.000000000 +0530
@@ -261,7 +261,7 @@ static int dup_mmap(struct mm_struct *mm
 	struct vm_area_struct *mpnt, *tmp, **pprev;
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
-	unsigned long charge;
+	unsigned long charge, uncharged = 0;
 	struct mempolicy *pol;
 
 	down_write(&oldmm->mmap_sem);
@@ -271,6 +271,15 @@ static int dup_mmap(struct mm_struct *mm
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
+	/*
+	 * Uncharging as a result of failure is done by mmput()
+	 * in dup_mm()
+	 */
+	if (memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm)) {
+		retval = -ENOMEM;
+		goto out;
+	}
+
 	mm->locked_vm = 0;
 	mm->mmap = NULL;
 	mm->mmap_cache = NULL;
@@ -292,6 +301,7 @@ static int dup_mmap(struct mm_struct *mm
 			vm_stat_account(mm, mpnt->vm_flags, mpnt->vm_file,
 								-pages);
 			memrlimit_cgroup_uncharge_as(mm, pages);
+			uncharged += pages;
 			continue;
 		}
 		charge = 0;
@@ -629,12 +639,6 @@ static int copy_mm(unsigned long clone_f
 		atomic_inc(&oldmm->mm_users);
 		mm = oldmm;
 		goto good_mm;
-	} else {
-		down_write(&oldmm->mmap_sem);
-		retval = memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm);
-		up_write(&oldmm->mmap_sem);
-		if (retval)
-			goto fail_nomem;
 	}
 
 	retval = -ENOMEM;
diff -puN kernel/exit.c~memrlimit-improve-fork-error-handling kernel/exit.c
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
