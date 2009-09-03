Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZICNwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZICNwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZICNwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:52:23 -0400
Received: from server1.wserver.cz ([82.113.45.157]:43976 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbZICNwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:52:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] core: allow setrlimit to non-current tasks
Date: Thu,  3 Sep 2009 15:52:28 +0200
Message-Id: <1251985948-28965-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4A9FC8DA.4090001@gmail.com>
References: <4A9FC8DA.4090001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for clarity. The current patch looks like this:
--
Add locking to allow setrlimit accept task parameter other than
current.

Namely, lock tasklist_lock for read and check whether the task
structure has sighand non-null. Do all the signal processing under
that lock still held. We do this only for non-current tasks.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index ed500c8..85d5d4d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1240,6 +1240,7 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
 	struct rlimit *old_rlim;
+	unsigned int needs_locking = !same_thread_group(tsk, current);
 	int retval;
 
 	if (new_rlim->rlim_cur > new_rlim->rlim_max)
@@ -1247,13 +1248,24 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
+	/* optimization: 'current' doesn't need locking, e.g. setrlimit */
+	if (needs_locking) {
+		/* protect tsk->signal and tsk->sighand from disappearing */
+		read_lock(&tasklist_lock);
+		if (!tsk->sighand) {
+			retval = -ESRCH;
+			goto unlock;
+		}
+	}
 	old_rlim = tsk->signal->rlim + resource;
 	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
-	    !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
+	    !capable(CAP_SYS_RESOURCE)) {
+		retval = -EPERM;
+		goto unlock;
+	}
 	retval = security_task_setrlimit(tsk, resource, new_rlim);
 	if (retval)
-		return retval;
+		goto unlock;
 
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
@@ -1283,7 +1295,11 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
-	return 0;
+	retval = 0;
+unlock:
+	if (needs_locking)
+		read_unlock(&tasklist_lock);
+	return retval;
 }
 
 SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
-- 
1.6.3.3

