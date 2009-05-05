Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbZEEA2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbZEEA2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbZEEA1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:27:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbZEEA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:27:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SKE9Y/IJ+s5UlZSu58DcbK16/tN9i24SKymXFSOuVLhAEF+kHn+FJgvgbUz/Vc6Pr
	WwG8+1XrDUoWMHHPijaFA==
Date: Mon, 4 May 2009 17:27:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
cc: Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 5/7] oom: fix possible oom_dump_tasks NULL pointer
In-Reply-To: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905041725330.11756@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
pointer for tasks that have detached mm's since task_lock() is not held
during the tasklist scan.

Cc: Nick Piggin <npiggin@suse.de>
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
