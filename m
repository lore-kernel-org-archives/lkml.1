Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZLWVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZLWVXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZLWVVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:45308 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbZLWVVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 18/37] kgdb: remove post_primary_code references
Date: Wed, 23 Dec 2009 15:19:31 -0600
Message-Id: <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:17.0911 (UTC) FILETIME=[B9C14070:01CA8415]
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
 arch/x86/kernel/kgdb.c    |   29 -----------------------------
 include/linux/kgdb.h      |   14 --------------
 kernel/debug/debug_core.c |    8 --------
 3 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 135c3ec..ce35f72 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -47,20 +47,8 @@
 #include <asm/debugreg.h>
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
@@ -346,23 +334,6 @@ void kgdb_disable_hw_debug(struct pt_regs *regs)
 	}
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
index b0f5649..97ff1c5 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -34,20 +34,6 @@ struct pt_regs;
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
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 502e488..6a70e46 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -201,12 +201,6 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
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
@@ -584,7 +578,6 @@ return_normal:
 	 * At this point the primary processor is completely
 	 * in the debugger and all secondary CPUs are quiescent
 	 */
-	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	dbg_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
@@ -666,7 +659,6 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
 	ks->signo		= signo;
-	ks->ex_vector		= evector;
 	ks->err_code		= ecode;
 	ks->kgdb_usethreadid	= 0;
 	ks->linux_regs		= regs;
-- 
1.6.4.rc1

