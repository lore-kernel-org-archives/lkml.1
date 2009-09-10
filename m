Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZIJGEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZIJGEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZIJGEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:04:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58752 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263AbZIJGEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:04:33 -0400
Date: Wed, 9 Sep 2009 23:09:19 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       container@us.ibm.com, sukadev@us.ibm.com
Subject: [RFC][v6][PATCH 2/9]: Have alloc_pidmap() return actual error code
Message-ID: <20090910060919.GA25883@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910060627.GA24343@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v6][PATCH 2/9]: Have alloc_pidmap() return actual error code

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
 kernel/pid.c  |   14 +++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2009-09-09 19:06:21.000000000 -0700
+++ linux-2.6/kernel/fork.c	2009-09-09 19:06:46.000000000 -0700
@@ -1110,10 +1110,11 @@ static struct task_struct *copy_process(
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
Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-09 19:06:25.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-09 19:06:46.000000000 -0700
@@ -150,7 +150,7 @@ static int alloc_pidmap_page(struct pidm
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
-	int rc;
+	int rc = -EAGAIN;
 	struct pidmap *map;
 
 	pid = last + 1;
@@ -189,12 +189,14 @@ static int alloc_pidmap(struct pid_names
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
@@ -263,8 +265,10 @@ struct pid *alloc_pid(struct pid_namespa
 	struct upid *upid;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
-	if (!pid)
+	if (!pid) {
+		pid = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
@@ -299,7 +303,7 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
+	pid = ERR_PTR(nr);
 	goto out;
 }
 
