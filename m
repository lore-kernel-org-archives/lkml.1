Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZEKPKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZEKPKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZEKPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:10:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:36211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbZEKPK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:10:28 -0400
Date: Mon, 11 May 2009 15:09:40 GMT
From: tip-bot for Alexey Dobriyan <adobriyan@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, adobriyan@gmail.com, mingo@elte.hu
In-Reply-To: <20090503233015.GJ16631@x200.localdomain>
References: <20090503233015.GJ16631@x200.localdomain>
Subject: [tip:x86/asm] x86, 64-bit: ifdef out struct thread_struct::ip
Message-ID: <tip-0c23590f00f85467b318ad0c20c36796a5bd4c60@git.kernel.org>
Git-Commit-ID: 0c23590f00f85467b318ad0c20c36796a5bd4c60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 15:09:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c23590f00f85467b318ad0c20c36796a5bd4c60
Gitweb:     http://git.kernel.org/tip/0c23590f00f85467b318ad0c20c36796a5bd4c60
Author:     Alexey Dobriyan <adobriyan@gmail.com>
AuthorDate: Mon, 4 May 2009 03:30:15 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 16:23:54 +0200

x86, 64-bit: ifdef out struct thread_struct::ip

struct thread_struct::ip isn't used on x86_64, struct pt_regs::ip is used
instead.

kgdb should be reading 0 always, but I can't check it.

[ Impact: (potentially) reduce thread_struct size on 64-bit ]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: containers@lists.linux-foundation.org
LKML-Reference: <20090503233015.GJ16631@x200.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/kgdb.c           |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a6732ff..a9ba743 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -427,7 +427,9 @@ struct thread_struct {
 	unsigned short		fsindex;
 	unsigned short		gsindex;
 #endif
+#ifdef CONFIG_X86_32
 	unsigned long		ip;
+#endif
 #ifdef CONFIG_X86_64
 	unsigned long		fs;
 #endif
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index eedfaeb..d07706f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -141,7 +141,7 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs32[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
 	gdb_regs32[GDB_CS]	= __KERNEL_CS;
 	gdb_regs32[GDB_SS]	= __KERNEL_DS;
-	gdb_regs[GDB_PC]	= p->thread.ip;
+	gdb_regs[GDB_PC]	= 0;
 	gdb_regs[GDB_R8]	= 0;
 	gdb_regs[GDB_R9]	= 0;
 	gdb_regs[GDB_R10]	= 0;
