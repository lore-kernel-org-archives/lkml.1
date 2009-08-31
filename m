Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZHaS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZHaS4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZHaS4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:56:12 -0400
Received: from server1.wserver.cz ([82.113.45.157]:36622 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZHaS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:56:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/6] core: add task_struct to update_rlimit_cpu
Date: Mon, 31 Aug 2009 20:56:11 +0200
Message-Id: <1251744974-29398-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add task_struct as a parameter to update_rlimit_cpu to be able to set
rlimit_cpu of different task than current.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
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
index 12161f7..a61c625 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -12,16 +12,16 @@
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
index ae7be2e..d501f60 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1284,7 +1284,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	if (new_rlim.rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(new_rlim.rlim_cur);
+	update_rlimit_cpu(current, new_rlim.rlim_cur);
 out:
 	return 0;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 839622a..6903784 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2360,7 +2360,8 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
+		update_rlimit_cpu(current,
+				current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.6.3.3

