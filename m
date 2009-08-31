Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZHaS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZHaS4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZHaS4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:56:13 -0400
Received: from server1.wserver.cz ([82.113.45.157]:36629 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbZHaS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:56:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 5/6] core: allow setrlimit to non-current tasks
Date: Mon, 31 Aug 2009 20:56:13 +0200
Message-Id: <1251744974-29398-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
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
 kernel/sys.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 919cebe..777a152 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1244,16 +1244,27 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
+
+	/* protect tsk->signal and tsk->sighand from disappearing */
+	read_lock_irq(&tasklist_lock);
+	if (!tsk->signal || !tsk->sighand) {
+		retval = -ESRCH;
+		goto unlock;
+	}
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
@@ -1283,7 +1294,10 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
-	return 0;
+	retval = 0;
+unlock:
+	read_unlock_irq(&tasklist_lock);
+	return retval;
 }
 
 SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
-- 
1.6.3.3

