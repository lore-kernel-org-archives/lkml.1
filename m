Return-Path: <linux-kernel-owner+w=401wt.eu-S934155AbXC0Sa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbXC0Sa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934157AbXC0Sa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:30:56 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45429 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934155AbXC0Say (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:30:54 -0400
Date: Tue, 27 Mar 2007 14:27:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] UML - fix compilation problems
Message-ID: <20070327182747.GA8400@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few miscellaneous compilation problems -
	an assignment with mismatched types in ldt.c
	a missing include in mconsole.h which needs a definition of uml_pt_regs
	when auditing is configured there are some mismatched types in ptrace.c
	I missed removing an include of user_util.h in hostfs	

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/mconsole.h |    2 ++
 arch/um/kernel/ptrace.c    |   14 +++++++-------
 arch/um/sys-i386/ldt.c     |    3 ++-
 fs/hostfs/hostfs_kern.c    |    1 -
 4 files changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6.21-mm/arch/um/sys-i386/ldt.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/ldt.c	2007-03-27 12:25:16.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/ldt.c	2007-03-27 12:28:26.000000000 -0400
@@ -394,7 +394,8 @@ static short * host_ldt_entries = NULL;
 static void ldt_get_host_info(void)
 {
 	long ret;
-	struct ldt_entry * ldt, *tmp;
+	struct ldt_entry * ldt;
+	short *tmp;
 	int i, size, k, order;
 
 	spin_lock(&host_ldt_lock);
Index: linux-2.6.21-mm/arch/um/include/mconsole.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/mconsole.h	2007-03-27 12:25:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/mconsole.h	2007-03-27 12:29:28.000000000 -0400
@@ -12,6 +12,8 @@
 #define u32 uint32_t
 #endif
 
+#include "sysdep/ptrace.h"
+
 #define MCONSOLE_MAGIC (0xcafebabe)
 #define MCONSOLE_MAX_DATA (512)
 #define MCONSOLE_VERSION 2
Index: linux-2.6.21-mm/arch/um/kernel/ptrace.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/ptrace.c	2007-03-27 12:25:18.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/ptrace.c	2007-03-27 12:34:43.000000000 -0400
@@ -53,8 +53,8 @@ void do_syscall_trace(struct pt_regs *re
 		secure_computing(PT_REGS_SYSCALL_NR(regs));
 
 	if (unlikely(current->audit_context) && entryexit)
-		audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(regs)),
-				   UPT_SYSCALL_RET(regs));
+		audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(&regs->regs)),
+				   UPT_SYSCALL_RET(&regs->regs));
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, entryexit);
@@ -66,9 +66,9 @@ void do_syscall_trace(struct pt_regs *re
 
 	if (unlikely(current->audit_context) && !entryexit)
 		audit_syscall_entry(HOST_AUDIT_ARCH,
-					    UPT_SYSCALL_NR(regs),
-					    UPT_SYSCALL_ARG1(regs),
-					    UPT_SYSCALL_ARG2(regs),
-					    UPT_SYSCALL_ARG3(regs),
-					    UPT_SYSCALL_ARG4(regs));
+				    UPT_SYSCALL_NR(&regs->regs),
+				    UPT_SYSCALL_ARG1(&regs->regs),
+				    UPT_SYSCALL_ARG2(&regs->regs),
+				    UPT_SYSCALL_ARG3(&regs->regs),
+				    UPT_SYSCALL_ARG4(&regs->regs));
 }
Index: linux-2.6.21-mm/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.21-mm.orig/fs/hostfs/hostfs_kern.c	2007-03-27 12:25:11.000000000 -0400
+++ linux-2.6.21-mm/fs/hostfs/hostfs_kern.c	2007-03-27 12:34:31.000000000 -0400
@@ -20,7 +20,6 @@
 #include "hostfs.h"
 #include "kern_util.h"
 #include "kern.h"
-#include "user_util.h"
 #include "init.h"
 
 struct hostfs_inode_info {
