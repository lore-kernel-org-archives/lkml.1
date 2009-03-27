Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbZC0J11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbZC0J11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZC0J1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:27:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:34049 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZC0J1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="124825277"
Date: Fri, 27 Mar 2009 10:27:08 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 12/14] x86, ds: re-add exit warning
Message-ID: <20090327102708.A11708@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-add a warning that had been removed with an earlier patch.
Patch 3 does bts cleanup earlier, so the warning makes sense, again.

Move the warning from exit to release.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-27 08:04:39.000000000 +0100
+++ git-tip/arch/x86/kernel/ds.c	2009-03-27 08:04:53.000000000 +0100
@@ -1309,10 +1309,6 @@ void ds_copy_thread(struct task_struct *
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
--- git-tip.orig/arch/x86/include/asm/ds.h	2009-03-27 08:01:13.000000000 +0100
+++ git-tip/arch/x86/include/asm/ds.h	2009-03-27 08:04:53.000000000 +0100
@@ -292,7 +292,6 @@ extern void ds_switch_to(struct task_str
  * Task clone/init and cleanup work
  */
 extern void ds_copy_thread(struct task_struct *tsk, struct task_struct *father);
-extern void ds_exit_thread(struct task_struct *tsk);
 
 #else /* CONFIG_X86_DS */
 
@@ -302,7 +301,6 @@ static inline void ds_switch_to(struct t
 				struct task_struct *next) {}
 static inline void ds_copy_thread(struct task_struct *tsk,
 				  struct task_struct *father) {}
-static inline void ds_exit_thread(struct task_struct *tsk) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
Index: git-tip/arch/x86/kernel/process.c
===================================================================
--- git-tip.orig/arch/x86/kernel/process.c	2009-03-27 07:59:21.000000000 +0100
+++ git-tip/arch/x86/kernel/process.c	2009-03-27 08:04:53.000000000 +0100
@@ -82,8 +82,6 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
-
-	ds_exit_thread(current);
 }
 
 void flush_thread(void)
Index: git-tip/arch/x86/kernel/process_32.c
===================================================================
--- git-tip.orig/arch/x86/kernel/process_32.c	2009-03-27 07:59:21.000000000 +0100
+++ git-tip/arch/x86/kernel/process_32.c	2009-03-27 08:04:53.000000000 +0100
@@ -234,6 +234,8 @@ void release_thread(struct task_struct *
 {
 	BUG_ON(dead_task->mm);
 	release_vm86_irqs(dead_task);
+
+	WARN(dead_task->thread.ds_ctx, "leaking DS context\n");
 }
 
 /*
Index: git-tip/arch/x86/kernel/process_64.c
===================================================================
--- git-tip.orig/arch/x86/kernel/process_64.c	2009-03-27 07:59:21.000000000 +0100
+++ git-tip/arch/x86/kernel/process_64.c	2009-03-27 08:04:53.000000000 +0100
@@ -248,6 +248,8 @@ void release_thread(struct task_struct *
 			BUG();
 		}
 	}
+
+	WARN(dead_task->thread.ds_ctx, "leaking DS context\n");
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
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

