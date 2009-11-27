Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZK0XGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZK0XGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZK0XGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:04 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60418 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZK0XGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 04/27] sys_setrlimit: make sure ->rlim_max never grows
Date: Sat, 28 Nov 2009 00:05:44 +0100
Message-Id: <1259363167-9347-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
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
index 71e4eb1..4377cb3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1249,10 +1249,6 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 		return -EFAULT;
 	if (new_rlim.rlim_cur > new_rlim.rlim_max)
 		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
-	    !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
@@ -1270,11 +1266,16 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
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
@@ -1288,7 +1289,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 
 	update_rlimit_cpu(current, new_rlim.rlim_cur);
 out:
-	return 0;
+	return retval;
 }
 
 /*
-- 
1.6.5.3

