Return-Path: <linux-kernel-owner+w=401wt.eu-S1751195AbZIBJpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbZIBJpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZIBJpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:45:01 -0400
Received: from server1.wserver.cz ([82.113.45.157]:33034 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZIBJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:45:00 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] core: add lockless update_rlimit_cpu
Date: Wed,  2 Sep 2009 11:45:02 +0200
Message-Id: <1251884703-14523-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> But I dislike the fact the patch uses tasklist_lock. Can't
> lock_task_sighand() work for you? (of course, in this case
> update_rlimit_cpu() should be updated too).

Yeah, I think so. I didn't know about that, sorry.

Something like these two?
--

Rename update_rlimit_cpu to __update_rlimit_cpu and create
update_rlimit_cpu wrapper with sighand lock.

The former is to be used by users who already hold the lock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/posix-timers.h |    1 +
 kernel/posix-cpu-timers.c    |   14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844..d0bac29 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -117,6 +117,7 @@ void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 
 long clock_nanosleep_restart(struct restart_block *restart_block);
 
+void __update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
 #endif
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a61c625..56eb1d5 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -12,17 +12,21 @@
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
-void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
+void __update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
 {
 	cputime_t cputime = secs_to_cputime(rlim_new);
 	struct signal_struct *const sig = task->signal;
 
 	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
-	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
-		spin_lock_irq(&task->sighand->siglock);
+	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime))
 		set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&task->sighand->siglock);
-	}
+}
+
+void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
+{
+	spin_lock_irq(&task->sighand->siglock);
+	__update_rlimit_cpu(task, rlim_new);
+	spin_unlock_irq(&task->sighand->siglock);
 }
 
 static int check_clock(const clockid_t which_clock)
-- 
1.6.3.3

