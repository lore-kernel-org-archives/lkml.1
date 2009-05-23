Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZEWWo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZEWWo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEWWow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:44:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45966 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZEWWov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:44:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=eIaXm54u+Bdwld5XU8nToXsLBDqu78aYomblgt92lMM4Bqgi/gJmfJsrraIbxTMa4
	iow/GIGKvYnloCi+s4h9Q==
Date: Sat, 23 May 2009 15:44:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: [patch] oom: fix possible oom_dump_tasks NULL pointer
Message-ID: <alpine.DEB.2.00.0905231543400.19231@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
pointer for tasks that have detached mm's since task_lock() is not held
during the tasklist scan.  Add the task_lock().

Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -284,22 +284,28 @@ static void dump_tasks(const struct mem_cgroup *mem)
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
 	do_each_thread(g, p) {
-		/*
-		 * total_vm and rss sizes do not exist for tasks with a
-		 * detached mm so there's no need to report them.
-		 */
-		if (!p->mm)
-			continue;
+		struct mm_struct *mm;
+
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 		if (!thread_group_leader(p))
 			continue;
 
 		task_lock(p);
+		mm = p->mm;
+		if (!mm) {
+			/*
+			 * total_vm and rss sizes do not exist for tasks with no
+			 * mm so there's no need to report them; they can't be
+			 * oom killed anyway.
+			 */
+			task_unlock(p);
+			continue;
+		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, __task_cred(p)->uid, p->tgid,
-		       p->mm->total_vm, get_mm_rss(p->mm), (int)task_cpu(p),
-		       p->oomkilladj, p->comm);
+		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
+		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
+		       p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
 }
