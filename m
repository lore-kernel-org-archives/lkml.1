Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZIBJpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZIBJpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZIBJpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:45:01 -0400
Received: from server1.wserver.cz ([82.113.45.157]:33035 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZIBJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:45:00 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] core: allow setrlimit to non-current tasks
Date: Wed,  2 Sep 2009 11:45:03 +0200
Message-Id: <1251884703-14523-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251884703-14523-1-git-send-email-jirislaby@gmail.com>
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add locking to allow setrlimit accept task parameter other than
current.

Namely, lock tasklist_lock for read and check whether the task
structure has signal and sighand non-null. Do all the signal
processing under that lock still held.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 919cebe..4a55bef 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1240,20 +1240,28 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
 	struct rlimit *old_rlim;
+	unsigned long flags;
 	int retval;
 
 	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
+
+	if (lock_task_sighand(tsk, &flags) == NULL)
+		return -ESRCH;
 	old_rlim = tsk->signal->rlim + resource;
 	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
-	    !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
-		return -EPERM;
+	    !capable(CAP_SYS_RESOURCE)) {
+		retval = -EPERM;
+		goto unlock;
+	}
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open) {
+		retval = -EPERM;
+		goto unlock;
+	}
 
 	retval = security_task_setrlimit(tsk, resource, new_rlim);
 	if (retval)
-		return retval;
+		goto unlock;
 
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
@@ -1281,9 +1289,12 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
+	__update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
-	return 0;
+	retval = 0;
+unlock:
+	unlock_task_sighand(tsk, &flags);
+	return retval;
 }
 
 SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
-- 
1.6.3.3

