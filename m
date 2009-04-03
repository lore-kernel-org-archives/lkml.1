Return-Path: <linux-kernel-owner+w=401wt.eu-S934046AbZDCOwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbZDCOwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765917AbZDCOqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:2422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765886AbZDCOqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:07 -0400
Content-Type: multipart/mixed; boundary="===============0388129146=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328367"
Message-Id: <20090403144601.254472000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:46 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 14/20] x86, ds: add leakage warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0388129146==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.warn_on_exit.patch

Add a warning in case a debug store context is not removed before
the task it is attached to is freed.

Remove the old warning at thread exit. It is too early.

Declare the debug store context field in thread_struct unconditionally.

Remove ds_copy_thread() and ds_exit_thread() and do the work directly
in process*.c.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ds.h        |    9 	0 +	9 -	0 !
 arch/x86/include/asm/processor.h |    4 	1 +	3 -	0 !
 arch/x86/kernel/ds.c             |   10 	0 +	10 -	0 !
 arch/x86/kernel/process.c        |    5 	3 +	2 -	0 !
 arch/x86/kernel/process_32.c     |    3 	2 +	1 -	0 !
 arch/x86/kernel/process_64.c     |    3 	2 +	1 -	0 !
 6 files changed, 8 insertions(+), 26 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1352,16 +1352,6 @@ void ds_switch_to(struct task_struct *pr
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
Index: b/arch/x86/include/asm/ds.h
===================================================================
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -285,21 +285,12 @@ extern void __cpuinit ds_init_intel(stru
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
Index: b/arch/x86/kernel/process.c
===================================================================
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -14,6 +14,7 @@
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/ds.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -45,6 +46,8 @@ void free_thread_xstate(struct task_stru
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+
+	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
 
 void free_thread_info(struct thread_info *ti)
@@ -82,8 +85,6 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
-
-	ds_exit_thread(current);
 }
 
 void flush_thread(void)
Index: b/arch/x86/include/asm/processor.h
===================================================================
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -451,10 +451,8 @@ struct thread_struct {
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
Index: b/arch/x86/kernel/process_32.c
===================================================================
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -290,7 +290,8 @@ int copy_thread(int nr, unsigned long cl
 		p->thread.io_bitmap_max = 0;
 	}
 
-	ds_copy_thread(p, current);
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
 
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
Index: b/arch/x86/kernel/process_64.c
===================================================================
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -335,7 +335,8 @@ int copy_thread(int nr, unsigned long cl
 			goto out;
 	}
 
-	ds_copy_thread(p, me);
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
 
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;

-- 

--===============0388129146==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============0388129146==--
