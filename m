Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbZCaOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbZCaOea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbZCaOdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:33:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:11071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551AbZCaOde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:33:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677497656"
Date: Tue, 31 Mar 2009 15:36:18 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 16/21] x86, ds: add leakage warning
Message-ID: <20090331153618.A13311@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a warning in case a debug store context is not removed before
the task it is attached to is freed.

Remove the old warning at thread exit. It is too early for deferred
branch trace stopping.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-31 08:36:18.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-31 08:37:29.000000000 +0200
@@ -1383,10 +1383,6 @@ void ds_copy_thread(struct task_struct *
 	tsk->thread.ds_ctx = NULL;
 }
 
-void ds_exit_thread(struct task_struct *tsk)
-{
-}
-
 static __init int ds_selftest(void)
 {
 	if (ds_cfg.sizeof_rec[ds_bts]) {
Index: git-tip/arch/x86/include/asm/ds.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/ds.h	2009-03-31 08:36:18.000000000 +0200
+++ git-tip/arch/x86/include/asm/ds.h	2009-03-31 08:37:27.000000000 +0200
@@ -289,7 +289,6 @@ extern void ds_switch_to(struct task_str
  * Task clone/init and cleanup work
  */
 extern void ds_copy_thread(struct task_struct *tsk, struct task_struct *father);
-extern void ds_exit_thread(struct task_struct *tsk);
 
 #else /* CONFIG_X86_DS */
 
@@ -299,7 +298,6 @@ static inline void ds_switch_to(struct t
 				struct task_struct *next) {}
 static inline void ds_copy_thread(struct task_struct *tsk,
 				  struct task_struct *father) {}
-static inline void ds_exit_thread(struct task_struct *tsk) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
Index: git-tip/arch/x86/kernel/process.c
===================================================================
--- git-tip.orig/arch/x86/kernel/process.c	2009-03-31 08:36:18.000000000 +0200
+++ git-tip/arch/x86/kernel/process.c	2009-03-31 08:38:07.000000000 +0200
@@ -45,6 +45,8 @@ void free_thread_xstate(struct task_stru
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+
+	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
 
 void free_thread_info(struct thread_info *ti)
@@ -82,8 +84,6 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
-
-	ds_exit_thread(current);
 }
 
 void flush_thread(void)
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

