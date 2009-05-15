Return-Path: <linux-kernel-owner+w=401wt.eu-S1762971AbZEONTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971AbZEONTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762250AbZEONS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:18:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:34691 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762139AbZEONSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:18:55 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] kgdb,i386: use address that SP register points to in the exception frame
Date: Fri, 15 May 2009 08:17:58 -0500
Message-Id: <1242393479-19351-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1242393479-19351-2-git-send-email-jason.wessel@windriver.com>
References: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com>
 <1242393479-19351-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 May 2009 13:18:12.0158 (UTC) FILETIME=[98F51DE0:01C9D55F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The treatment of the SP register is different on x86_64 and i386.
This is a regression fix that lived outside the mainline kernel from
2.6.27 to now.  The regression was a result of the original merge
consolidation of the i386 and x86_64 archs to x86.

The incorrectly reported SP on i386 prevented stack tracebacks from
working correctly in gdb.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index eedfaeb..b1f4dff 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -88,6 +88,7 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs[GDB_SS]	= __KERNEL_DS;
 	gdb_regs[GDB_FS]	= 0xFFFF;
 	gdb_regs[GDB_GS]	= 0xFFFF;
+	gdb_regs[GDB_SP]	= (int)&regs->sp;
 #else
 	gdb_regs[GDB_R8]	= regs->r8;
 	gdb_regs[GDB_R9]	= regs->r9;
@@ -100,8 +101,8 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs32[GDB_PS]	= regs->flags;
 	gdb_regs32[GDB_CS]	= regs->cs;
 	gdb_regs32[GDB_SS]	= regs->ss;
-#endif
 	gdb_regs[GDB_SP]	= regs->sp;
+#endif
 }
 
 /**
-- 
1.6.3.1.9.g95405b

