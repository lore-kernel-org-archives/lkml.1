Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZICUIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZICUIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZICUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:08:39 -0400
Received: from server1.wserver.cz ([82.113.45.157]:51030 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbZICUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:08:38 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2 4/8] sys_setrlimit: make sure ->rlim_max never grows
Date: Thu,  3 Sep 2009 22:08:40 +0200
Message-Id: <1252008524-5376-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090903174106.GC27161@redhat.com>
References: <20090903174106.GC27161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Mostly preparation for Jiri's changes, but probably makes sense anyway.

sys_setrlimit() checks new_rlim.rlim_max <= old_rlim->rlim_max, but when
it takes task_lock() old_rlim->rlim_max can be already lowered. Move this
check under task_lock().

Currently this is not important, we can only race with our sub-thread,
this means the application is stupid. But when we change the code to allow
the update of !current task's limits, it becomes important to make sure
->rlim_max can be lowered "reliably" even if we race with the application
doing sys_setrlimit().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/sys.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index d501f60..600d3e2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1247,10 +1247,6 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 		return -EFAULT;
 	if (new_rlim.rlim_cur > new_rlim.rlim_max)
 		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
-	    !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
@@ -1268,11 +1264,16 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 		new_rlim.rlim_cur = 1;
 	}
 
+	old_rlim = current->signal->rlim + resource;
 	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
+	if ((new_rlim.rlim_max <= old_rlim->rlim_max) ||
+				capable(CAP_SYS_RESOURCE))
+		*old_rlim = new_rlim;
+	else
+		retval = -EPERM;
 	task_unlock(current->group_leader);
 
-	if (resource != RLIMIT_CPU)
+	if (retval || resource != RLIMIT_CPU)
 		goto out;
 
 	/*
@@ -1286,7 +1287,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 
 	update_rlimit_cpu(current, new_rlim.rlim_cur);
 out:
-	return 0;
+	return retval;
 }
 
 /*
-- 
1.6.3.3

