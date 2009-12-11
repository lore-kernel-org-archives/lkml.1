Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbZLKPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbZLKPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbZLKPiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:38:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:57530 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbZLKPhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/9] kgdb,i386: Fix corner case access to ss with NMI watch dog exception
Date: Fri, 11 Dec 2009 09:36:13 -0600
Message-Id: <1260545777-8089-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:33.0582 (UTC) FILETIME=[B7BD64E0:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for the user_mode_vm(regs) check to return true on the
i368 arch for a non master kgdb cpu or when the master kgdb cpu
handles the NMI watch dog exception.

The solution is simply to select the correct gdb_ss location
based on the check to user_mode_vm(regs).

CC: Ingo Molnar <mingo@elte.hu>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index f93d015..aefae46 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -86,9 +86,15 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs[GDB_DS]	= regs->ds;
 	gdb_regs[GDB_ES]	= regs->es;
 	gdb_regs[GDB_CS]	= regs->cs;
-	gdb_regs[GDB_SS]	= __KERNEL_DS;
 	gdb_regs[GDB_FS]	= 0xFFFF;
 	gdb_regs[GDB_GS]	= 0xFFFF;
+	if (user_mode_vm(regs)) {
+		gdb_regs[GDB_SS] = regs->ss;
+		gdb_regs[GDB_SP] = regs->sp;
+	} else {
+		gdb_regs[GDB_SS] = __KERNEL_DS;
+		gdb_regs[GDB_SP] = kernel_stack_pointer(regs);
+	}
 #else
 	gdb_regs[GDB_R8]	= regs->r8;
 	gdb_regs[GDB_R9]	= regs->r9;
@@ -101,8 +107,8 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs32[GDB_PS]	= regs->flags;
 	gdb_regs32[GDB_CS]	= regs->cs;
 	gdb_regs32[GDB_SS]	= regs->ss;
-#endif
 	gdb_regs[GDB_SP]	= kernel_stack_pointer(regs);
+#endif
 }
 
 /**
-- 
1.6.4.rc1

