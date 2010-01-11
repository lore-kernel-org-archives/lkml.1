Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392Ab0AKVcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0AKVcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032Ab0AKV1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:20 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35385 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0AKV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ibIbzrHKOJCUuGChuMu8iBPeFYNbuZaxSztW4qDYOQOVwS6etEOvMmQRadbZuzvp+l
         ZblurnbY3l4BlVFEtmhDtAU7Et232JPwpHfFt3DrPF++Mf4u0i0XAaPclf+rbtjk1GQV
         cJ6FRdkQYqzonJ1UCQCZaUA/2FI7Ef3IPt5S8=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 04/26] sched: Convert thread_group_cputimer lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:34 +0100
Message-Id: <1263245216-14754-5-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-4-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks.

See also a3f22fd7ae186a29b413ad959184f9b4c1d32173

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    4 ++--
 kernel/posix-cpu-timers.c |    8 ++++----
 kernel/sched_stats.h      |   12 ++++++------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index abec69b..e93b8cd 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -27,7 +27,7 @@ extern struct fs_struct init_fs;
 	.cputimer	= { 						\
 		.cputime = INIT_CPUTIME,				\
 		.running = 0,						\
-		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
+		.lock = __RAW_SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8d4991b..ed5029e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -552,7 +552,7 @@ struct task_cputime {
 struct thread_group_cputimer {
 	struct task_cputime cputime;
 	int running;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 /*
@@ -2447,7 +2447,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
 	sig->cputimer.cputime = INIT_CPUTIME;
-	spin_lock_init(&sig->cputimer.lock);
+	raw_spin_lock_init(&sig->cputimer.lock);
 	sig->cputimer.running = 0;
 }
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 438ff45..359cc24 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -280,7 +280,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 	struct task_cputime sum;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
+	raw_spin_lock_irqsave(&cputimer->lock, flags);
 	if (!cputimer->running) {
 		cputimer->running = 1;
 		/*
@@ -293,7 +293,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		update_gt_cputime(&cputimer->cputime, &sum);
 	}
 	*times = cputimer->cputime;
-	spin_unlock_irqrestore(&cputimer->lock, flags);
+	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
 /*
@@ -1068,9 +1068,9 @@ static void stop_process_timers(struct task_struct *tsk)
 	if (!cputimer->running)
 		return;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
+	raw_spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
-	spin_unlock_irqrestore(&cputimer->lock, flags);
+	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
 static u32 onecputick;
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 32d2bd4..9ecca2f 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -306,10 +306,10 @@ static inline void account_group_user_time(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.utime =
 		cputime_add(cputimer->cputime.utime, cputime);
-	spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->lock);
 }
 
 /**
@@ -336,10 +336,10 @@ static inline void account_group_system_time(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.stime =
 		cputime_add(cputimer->cputime.stime, cputime);
-	spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->lock);
 }
 
 /**
@@ -369,7 +369,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.sum_exec_runtime += ns;
-	spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->lock);
 }
-- 
1.6.5.2

