Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbZEHVZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbZEHVZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbZEHVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:44756 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbZEHVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 06/13] kgdb: remove post_primary_code references
Date: Fri,  8 May 2009 16:23:13 -0500
Message-Id: <1241817800-9320-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:28.0731 (UTC) FILETIME=[3AE552B0:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the references to the kgdb_post_primary_code.  This
function serves no useful purpose because you can obtain the same
information from the "struct kgdb_state *ks" from with in the
debugger, if for some reason you want the data.

Also remove the unintentional duplicate assignment for ks->ex_vector.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   29 -----------------------------
 include/linux/kgdb.h   |   14 --------------
 kernel/kgdb.c          |    8 --------
 3 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 6d2503d..a61a138 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -45,20 +45,8 @@
 
 #include <asm/apicdef.h>
 #include <asm/system.h>
-
 #include <asm/apic.h>
 
-/*
- * Put the error code here just in case the user cares:
- */
-static int gdb_x86errcode;
-
-/*
- * Likewise, the vector number here (since GDB only gets the signal
- * number through the usual means, and that's not very specific):
- */
-static int gdb_x86vector = -1;
-
 /**
  *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
  *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
@@ -311,23 +299,6 @@ void kgdb_disable_hw_debug(struct pt_regs *regs)
 	set_debugreg(0UL, 7);
 }
 
-/**
- *	kgdb_post_primary_code - Save error vector/code numbers.
- *	@regs: Original pt_regs.
- *	@e_vector: Original error vector.
- *	@err_code: Original error code.
- *
- *	This is needed on architectures which support SMP and KGDB.
- *	This function is called after all the slave cpus have been put
- *	to a know spin state and the primary CPU has control over KGDB.
- */
-void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
-{
-	/* primary processor is completely in the debugger */
-	gdb_x86vector = e_vector;
-	gdb_x86errcode = err_code;
-}
-
 #ifdef CONFIG_SMP
 /**
  *	kgdb_roundup_cpus - Get other CPUs into a holding pattern
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 0299b79..8ecf20f 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -35,20 +35,6 @@ struct pt_regs;
 extern int kgdb_skipexception(int exception, struct pt_regs *regs);
 
 /**
- *	kgdb_post_primary_code - (optional) Save error vector/code numbers.
- *	@regs: Original pt_regs.
- *	@e_vector: Original error vector.
- *	@err_code: Original error code.
- *
- *	This is usually needed on architectures which support SMP and
- *	KGDB.  This function is called after all the secondary cpus have
- *	been put to a know spin state and the primary CPU has control over
- *	KGDB.
- */
-extern void kgdb_post_primary_code(struct pt_regs *regs, int e_vector,
-				  int err_code);
-
-/**
  *	kgdb_disable_hw_debug - (optional) Disable hardware debugging hook
  *	@regs: Current &struct pt_regs.
  *
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 484f106..6d31c0c 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -233,12 +233,6 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
 	return 0;
 }
 
-void __weak
-kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
-{
-	return;
-}
-
 /**
  *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
  *	@regs: Current &struct pt_regs.
@@ -1632,7 +1626,6 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
 	ks->signo		= signo;
-	ks->ex_vector		= evector;
 	ks->err_code		= ecode;
 	ks->kgdb_usethreadid	= 0;
 	ks->linux_regs		= regs;
@@ -1724,7 +1717,6 @@ acquirelock:
 	 * At this point the primary processor is completely
 	 * in the debugger and all secondary CPUs are quiescent
 	 */
-	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	kgdb_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
-- 
1.6.3.rc0.1.gf800

