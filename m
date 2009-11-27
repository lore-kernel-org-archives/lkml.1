Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZK0XGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZK0XGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZK0XGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:07 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60405 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZK0XGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 03/27] core: add task_struct to update_rlimit_cpu
Date: Sat, 28 Nov 2009 00:05:43 +0100
Message-Id: <1259363167-9347-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

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
index 5c9dc22..102c345 100644
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
index 9898a8a..71e4eb1 100644
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
index 1167f01..dac6c88 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2366,7 +2366,8 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
+		update_rlimit_cpu(current,
+				current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.6.5.3

