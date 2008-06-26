Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYFZJ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYFZJ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYFZJ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:29:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34919 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbYFZJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:29:00 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Jun 2008 14:58:55 +0530
Message-Id: <20080626092855.16841.52723.sendpatchset@balbir-laptop>
In-Reply-To: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
References: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
Subject: [3/5] memrlimit fix sleep inside sleeplock in mm_update_next_owner()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



We have a sleep inside a spinlock (read side locking of tasklist_lock). We
try to acquire mmap_sem without releasing the read_lock. Since we have
the task_struct of the new process, we can release the read_lock, before
acquiring the task_lock of the chosen one.

Reported-by: Hugh Dickins <hugh@veritas.com>



Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/exit.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN kernel/exit.c~memrlimit-fix-sleep-in-spinlock-bug kernel/exit.c
--- linux-2.6.26-rc5/kernel/exit.c~memrlimit-fix-sleep-in-spinlock-bug	2008-06-26 14:48:21.000000000 +0530
+++ linux-2.6.26-rc5-balbir/kernel/exit.c	2008-06-26 14:48:21.000000000 +0530
@@ -636,28 +636,24 @@ retry:
 assign_new_owner:
 	BUG_ON(c == p);
 	get_task_struct(c);
+	read_unlock(&tasklist_lock);
 	down_write(&mm->mmap_sem);
 	/*
 	 * The task_lock protects c->mm from changing.
 	 * We always want mm->owner->mm == mm
 	 */
 	task_lock(c);
-	/*
-	 * Delay read_unlock() till we have the task_lock()
-	 * to ensure that c does not slip away underneath us
-	 */
-	read_unlock(&tasklist_lock);
 	if (c->mm != mm) {
 		task_unlock(c);
-		put_task_struct(c);
 		up_write(&mm->mmap_sem);
+		put_task_struct(c);
 		goto retry;
 	}
 	cgroup_mm_owner_callbacks(mm->owner, c);
 	mm->owner = c;
 	task_unlock(c);
-	put_task_struct(c);
 	up_write(&mm->mmap_sem);
+	put_task_struct(c);
 }
 #endif /* CONFIG_MM_OWNER */
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
