Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZIWX6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZIWX6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZIWX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:58:43 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:34745 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZIWX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:57:57 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 19:57:55 EDT
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [PATCH v18 12/80] pids 2/7: Have alloc_pidmap() return actual error code
Date: Wed, 23 Sep 2009 19:50:52 -0400
Message-Id: <1253749920-18673-13-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

alloc_pidmap() can fail either because all pid numbers are in use or
because memory allocation failed.  With support for setting a specific
pid number, alloc_pidmap() would also fail if either the given pid
number is invalid or in use.

Rather than have callers assume -ENOMEM, have alloc_pidmap() return
the actual error.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    5 +++--
 kernel/pid.c  |    9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e6c04d4..851ccd1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1110,10 +1110,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns);
-		if (!pid)
+		if (IS_ERR(pid)) {
+			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
+		}
 
 		if (clone_flags & CLONE_NEWPID) {
 			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
diff --git a/kernel/pid.c b/kernel/pid.c
index f618096..9c678ce 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -158,6 +158,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
 	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	rc = -EAGAIN;
 	for (i = 0; i <= max_scan; ++i) {
 		rc = alloc_pidmap_page(map);
 		if (rc)
@@ -188,12 +189,14 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 		} else {
 			map = &pid_ns->pidmap[0];
 			offset = RESERVED_PIDS;
-			if (unlikely(last == offset))
+			if (unlikely(last == offset)) {
+				rc = -EAGAIN;
 				break;
+			}
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
-	return -1;
+	return rc;
 }
 
 int next_pidmap(struct pid_namespace *pid_ns, int last)
@@ -298,7 +301,7 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
+	pid = ERR_PTR(nr);
 	goto out;
 }
 
-- 
1.6.0.4

