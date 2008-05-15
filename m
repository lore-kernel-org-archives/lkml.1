Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbYEOLTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbYEOLTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYEOLTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:19:35 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:4483 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbYEOLTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:19:34 -0400
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 07:19:34 EDT
Subject: [PATCH] scheduler: reorder task_struct to reduce padding on 64bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: mingo@elte.hu
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 12:09:15 +0100
Message-Id: <1210849755.3274.11.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder task_struct to reduce padding on 64bit builds
    
    removes 24 bytes on my config and /proc/slabinfo reports +1 objects per slab
    
    Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
This patch removes 24 bytes of padding and allows 1 extra object per
slab on my fedora based config. 
Patch against 2.6.26-rc2 & running successfully on my AMD 64 desktop
machine.

Richard



diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5395a61..386e154 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1040,6 +1040,7 @@ struct task_struct {
 #endif
 
 	int prio, static_prio, normal_prio;
+	unsigned int rt_priority;
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
@@ -1123,7 +1124,6 @@ struct task_struct {
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	unsigned int rt_priority;
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 	cputime_t prev_utime, prev_stime;
@@ -1142,12 +1142,12 @@ struct task_struct {
 	gid_t gid,egid,sgid,fsgid;
 	struct group_info *group_info;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted, cap_bset;
-	unsigned securebits;
 	struct user_struct *user;
+	unsigned securebits;
 #ifdef CONFIG_KEYS
+	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
 	struct key *request_key_auth;	/* assumed request_key authority */
 	struct key *thread_keyring;	/* keyring private to this thread */
-	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
 #endif
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
@@ -1234,8 +1234,8 @@ struct task_struct {
 # define MAX_LOCK_DEPTH 48UL
 	u64 curr_chain_key;
 	int lockdep_depth;
-	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	unsigned int lockdep_recursion;
+	struct held_lock held_locks[MAX_LOCK_DEPTH];
 #endif
 
 /* journalling filesystem info */
@@ -1263,10 +1263,6 @@ struct task_struct {
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
 	cputime_t acct_stimexpd;/* stime since last update */
 #endif
-#ifdef CONFIG_NUMA
-  	struct mempolicy *mempolicy;
-	short il_next;
-#endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;
 	int cpuset_mems_generation;
@@ -1286,6 +1282,10 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *mempolicy;
+	short il_next;
+#endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 


