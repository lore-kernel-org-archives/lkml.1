Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZJQVVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZJQVVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZJQVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:21:23 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60864 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbZJQVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:21:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -repost 3/8] core: add task_struct to update_rlimit_cpu
Date: Sat, 17 Oct 2009 23:21:17 +0200
Message-Id: <1255814482-13994-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
References: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add task_struct as a parameter to update_rlimit_cpu to be able to set
rlimit_cpu of different task than current.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
---
 include/linux/posix-timers.h |    2 +-
 kernel/posix-cpu-timers.c    |   10 +++++-----
 kernel/sys.c                 |    2 +-
 security/selinux/hooks.c     |    3 ++-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..3e23844 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -117,6 +117,6 @@ void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 
 long clock_nanosleep_restart(struct restart_block *restart_block);
 
-void update_rlimit_cpu(unsigned long rlim_new);
+void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
 #endif
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 438ff45..d8e543c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -13,16 +13,16 @@
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
-void update_rlimit_cpu(unsigned long rlim_new)
+void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
 {
 	cputime_t cputime = secs_to_cputime(rlim_new);
-	struct signal_struct *const sig = current->signal;
+	struct signal_struct *const sig = task->signal;
 
 	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
 	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
-		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_lock_irq(&task->sighand->siglock);
+		set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
+		spin_unlock_irq(&task->sighand->siglock);
 	}
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 57ffd4c..b8f9f13 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1286,7 +1286,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	if (new_rlim.rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(new_rlim.rlim_cur);
+	update_rlimit_cpu(current, new_rlim.rlim_cur);
 out:
 	return 0;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1a4c113..0c0c1bf 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2365,7 +2365,8 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
+		update_rlimit_cpu(current,
+				current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.6.4.2

