Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbZDBPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbZDBPBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761342AbZDBO5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:17664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761530AbZDBO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:33 -0400
Content-Type: multipart/mixed; boundary="===============0574496242=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="399764710"
Message-Id: <20090402145726.223198000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:55:08 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 13/18] x86, ds: add leakage warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0574496242==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.warn_on_exit.patch

Add a warning in case a debug store context is not removed before
the task it is attached to is freed.

Remove the old warning at thread exit. It is too early.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ds.h        |    8 	6 +	2 -	0 !
 arch/x86/include/asm/processor.h |    2 	1 +	1 -	0 !
 arch/x86/kernel/ds.c             |    4 	0 +	4 -	0 !
 arch/x86/kernel/process.c        |    5 	3 +	2 -	0 !
 4 files changed, 10 insertions(+), 9 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1380,10 +1380,6 @@ void ds_copy_thread(struct task_struct *
 	tsk->thread.ds_ctx = NULL;
 }
 
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
@@ -23,6 +23,7 @@
 #define _ASM_X86_DS_H
 
 
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/err.h>
@@ -289,7 +290,10 @@ extern void ds_switch_to(struct task_str
  * Task clone/init and cleanup work
  */
 extern void ds_copy_thread(struct task_struct *tsk, struct task_struct *father);
-extern void ds_exit_thread(struct task_struct *tsk);
+static inline void ds_warn_leak(struct task_struct *tsk)
+{
+	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
+}
 
 #else /* CONFIG_X86_DS */
 
@@ -299,7 +303,7 @@ static inline void ds_switch_to(struct t
 				struct task_struct *next) {}
 static inline void ds_copy_thread(struct task_struct *tsk,
 				  struct task_struct *father) {}
-static inline void ds_exit_thread(struct task_struct *tsk) {}
+static inline void ds_warn_leak(struct task_struct *tsk) {}
 
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
+	ds_warn_leak(tsk);
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
@@ -6,6 +6,7 @@
 /* Forward declaration, a strange C thing */
 struct task_struct;
 struct mm_struct;
+struct ds_context;
 
 #include <asm/vm86.h>
 #include <asm/math_emu.h>
@@ -21,7 +22,6 @@ struct mm_struct;
 #include <asm/msr.h>
 #include <asm/desc_defs.h>
 #include <asm/nops.h>
-#include <asm/ds.h>
 
 #include <linux/personality.h>
 #include <linux/cpumask.h>

-- 

--===============0574496242==
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

--===============0574496242==--
