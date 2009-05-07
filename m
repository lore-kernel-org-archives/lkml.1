Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbZEGJ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbZEGJ2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761608AbZEGJYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:24:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:40558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761579AbZEGJYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:24:33 -0400
Date: Thu, 7 May 2009 09:24:00 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144601.254472000@intel.com>
References: <20090403144601.254472000@intel.com>
Subject: [tip:tracing/core] x86, ds: add leakage warning
Message-ID: <tip-2311f0de21c17b2a8b960677a9cccfbfa52beb35@git.kernel.org>
Git-Commit-ID: 2311f0de21c17b2a8b960677a9cccfbfa52beb35
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:24:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2311f0de21c17b2a8b960677a9cccfbfa52beb35
Gitweb:     http://git.kernel.org/tip/2311f0de21c17b2a8b960677a9cccfbfa52beb35
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:28 +0200

x86, ds: add leakage warning

Add a warning in case a debug store context is not removed before
the task it is attached to is freed.

Remove the old warning at thread exit. It is too early.

Declare the debug store context field in thread_struct unconditionally.

Remove ds_copy_thread() and ds_exit_thread() and do the work directly
in process*.c.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144601.254472000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/ds.h        |    9 ---------
 arch/x86/include/asm/processor.h |    4 +---
 arch/x86/kernel/ds.c             |   10 ----------
 arch/x86/kernel/process.c        |    5 +++--
 arch/x86/kernel/process_32.c     |    3 ++-
 arch/x86/kernel/process_64.c     |    3 ++-
 6 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/ds.h b/arch/x86/include/asm/ds.h
index 413e127..149e520 100644
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -285,21 +285,12 @@ extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *);
  */
 extern void ds_switch_to(struct task_struct *prev, struct task_struct *next);
 
-/*
- * Task clone/init and cleanup work
- */
-extern void ds_copy_thread(struct task_struct *tsk, struct task_struct *father);
-extern void ds_exit_thread(struct task_struct *tsk);
-
 #else /* CONFIG_X86_DS */
 
 struct cpuinfo_x86;
 static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
 static inline void ds_switch_to(struct task_struct *prev,
 				struct task_struct *next) {}
-static inline void ds_copy_thread(struct task_struct *tsk,
-				  struct task_struct *father) {}
-static inline void ds_exit_thread(struct task_struct *tsk) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 1efeb49..7c39de7 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -454,10 +454,8 @@ struct thread_struct {
 	unsigned		io_bitmap_max;
 /* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
 	unsigned long	debugctlmsr;
-#ifdef CONFIG_X86_DS
-/* Debug Store context; see include/asm-x86/ds.h; goes into MSR_IA32_DS_AREA */
+	/* Debug Store context; see asm/ds.h */
 	struct ds_context	*ds_ctx;
-#endif /* CONFIG_X86_DS */
 };
 
 static inline unsigned long native_get_debugreg(int regno)
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 21a3852..71cab3b 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1352,16 +1352,6 @@ void ds_switch_to(struct task_struct *prev, struct task_struct *next)
 	update_debugctlmsr(debugctlmsr);
 }
 
-void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)
-{
-	clear_tsk_thread_flag(tsk, TIF_DS_AREA_MSR);
-	tsk->thread.ds_ctx = NULL;
-}
-
-void ds_exit_thread(struct task_struct *tsk)
-{
-}
-
 static __init int ds_selftest(void)
 {
 	if (ds_cfg.sizeof_rec[ds_bts]) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..fb5dfb8 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -14,6 +14,7 @@
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/ds.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -45,6 +46,8 @@ void free_thread_xstate(struct task_struct *tsk)
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+
+	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
 
 void free_thread_info(struct thread_info *ti)
@@ -83,8 +86,6 @@ void exit_thread(void)
 		put_cpu();
 		kfree(bp);
 	}
-
-	ds_exit_thread(current);
 }
 
 void flush_thread(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 76f8f84..b5e4bfe 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -290,7 +290,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		p->thread.io_bitmap_max = 0;
 	}
 
-	ds_copy_thread(p, current);
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
 
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..5a1a1de 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -335,7 +335,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 			goto out;
 	}
 
-	ds_copy_thread(p, me);
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
 
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
