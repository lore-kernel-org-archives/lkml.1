Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZC2CFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZC2CFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZC2CEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:11 -0400
Received: from ozlabs.org ([203.10.76.45]:46564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbZC2CEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:06 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 1/10] cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090329020404.1B0A4DDECA@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

(Thanks to Al Viro for reminding me of this, via Ingo)

CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:

	#define CPU_MASK_ALL (cpumask_t) { { ... } }

Taking the address of such a temporary is questionable at best,
unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
CPU_MASK_ALL_PTR:

	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)

Which formalizes this practice.  One day gcc could bite us over this
usage (though we seem to have gotten away with it so far).

So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
with the modern "cpu_all_mask" (a real const struct cpumask *).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
---
 init/main.c      |    2 +-
 kernel/kmod.c    |    2 +-
 kernel/kthread.c |    4 ++--
 mm/pdflush.c     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -834,7 +829,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
diff --git a/kernel/kmod.c b/kernel/kmod.c
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -167,7 +167,7 @@ static int ____call_usermodehelper(void 
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
diff --git a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -110,7 +110,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed_ptr(create->result, cpu_all_mask);
 	}
 	complete(&create->done);
 }
@@ -240,7 +240,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
diff --git a/mm/pdflush.c b/mm/pdflush.c
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -191,7 +191,7 @@ static int pdflush(void *dummy)
 
 	/*
 	 * Some configs put our parent kthread in a limited cpuset,
-	 * which kthread() overrides, forcing cpus_allowed == CPU_MASK_ALL.
+	 * which kthread() overrides, forcing cpus_allowed == cpu_all_mask.
 	 * Our needs are more modest - cut back to our cpusets cpus_allowed.
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.

