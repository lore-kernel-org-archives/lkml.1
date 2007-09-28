Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbXI1IEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbXI1IEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbXI1IBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625AbXI1IBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:46 -0400
Message-Id: <20070928080040.893443000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/12] lockdep: syscall exit check
Content-Disposition: inline; filename=lockdep-sys_exit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a check to validate that we do not hold any locks when switching
back to user-space.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    2 ++
 kernel/lockdep.c        |   16 ++++++++++++++++
 2 files changed, 18 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -238,6 +238,7 @@ extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
 extern void lockdep_free_key_range(void *start, unsigned long size);
+extern void lockdep_sys_exit(void);
 
 extern void lockdep_off(void);
 extern void lockdep_on(void);
@@ -317,6 +318,7 @@ static inline void lockdep_on(void)
 # define INIT_LOCKDEP
 # define lockdep_reset()		do { debug_locks = 1; } while (0)
 # define lockdep_free_key_range(start, size)	do { } while (0)
+# define lockdep_sys_exit() 			do { } while (0)
 /*
  * The class key takes no space if lockdep is disabled:
  */
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -3199,3 +3199,19 @@ void debug_show_held_locks(struct task_s
 }
 
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
+
+void lockdep_sys_exit(void)
+{
+	struct task_struct *curr = current;
+
+	if (unlikely(curr->lockdep_depth)) {
+		if (!debug_locks_off())
+			return;
+		printk("\n========================================\n");
+		printk(  "[ BUG: lock held at syscall exit time! ]\n");
+		printk(  "----------------------------------------\n");
+		printk("%s/%d is leaving the kernel with locks still held!\n",
+				curr->comm, curr->pid);
+		lockdep_print_held_locks(curr);
+	}
+}

--

