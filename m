Return-Path: <linux-kernel-owner+w=401wt.eu-S1763821AbXHWN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763821AbXHWN2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763245AbXHWN15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:27:57 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:16438 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763050AbXHWN1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:27:55 -0400
Date: Thu, 23 Aug 2007 17:27:35 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: mingo@elte.hu
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Shrink task_struct if CONFIG_FUTEX=n
Message-ID: <20070823132735.GE31289@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

robust_list, compat_robust_list, pi_state_list, pi_state_cache are
really used if futexes are on.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/linux/sched.h |    3 ++-
 kernel/exit.c         |    6 +++++-
 kernel/fork.c         |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1174,13 +1174,14 @@ struct task_struct {
 	int cpuset_mems_generation;
 	int cpuset_mem_spread_rotor;
 #endif
+#ifdef CONFIG_FUTEX
 	struct robust_list_head __user *robust_list;
 #ifdef CONFIG_COMPAT
 	struct compat_robust_list_head __user *compat_robust_list;
 #endif
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
-
+#endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -964,12 +964,14 @@ fastcall NORET_TYPE void do_exit(long code)
 		exit_itimers(tsk->signal);
 	}
 	acct_collect(code, group_dead);
+#ifdef CONFIG_FUTEX
 	if (unlikely(tsk->robust_list))
 		exit_robust_list(tsk);
-#if defined(CONFIG_FUTEX) && defined(CONFIG_COMPAT)
+#ifdef CONFIG_COMPAT
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
+#endif
 	if (group_dead)
 		tty_audit_exit();
 	if (unlikely(tsk->audit_context))
@@ -1004,6 +1006,7 @@ fastcall NORET_TYPE void do_exit(long code)
 	mpol_free(tsk->mempolicy);
 	tsk->mempolicy = NULL;
 #endif
+#ifdef CONFIG_FUTEX
 	/*
 	 * This must happen late, after the PID is not
 	 * hashed anymore:
@@ -1012,6 +1015,7 @@ fastcall NORET_TYPE void do_exit(long code)
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
+#endif
 	/*
 	 * Make sure we are holding no locks:
 	 */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1143,13 +1143,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * Clear TID on mm_release()?
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr: NULL;
+#ifdef CONFIG_FUTEX
 	p->robust_list = NULL;
 #ifdef CONFIG_COMPAT
 	p->compat_robust_list = NULL;
 #endif
 	INIT_LIST_HEAD(&p->pi_state_list);
 	p->pi_state_cache = NULL;
-
+#endif
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */

