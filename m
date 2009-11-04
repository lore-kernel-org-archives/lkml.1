Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZKDP2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZKDP2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZKDP2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:28:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:57472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392AbZKDP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:28:13 -0500
Date: Wed, 4 Nov 2009 15:27:06 GMT
From: tip-bot for Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stefani@seibold.net, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stefani@seibold.net, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, adobriyan@gmail.com,
       mingo@elte.hu
In-Reply-To: <1257240160.4889.24.camel@wall-e>
References: <1257240160.4889.24.camel@wall-e>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, fs: Fix x86 procfs stack information for threads on 64-bit
Message-ID: <tip-89240ba059ca468ae7a8346edf7f95082458c2fc@git.kernel.org>
Git-Commit-ID: 89240ba059ca468ae7a8346edf7f95082458c2fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89240ba059ca468ae7a8346edf7f95082458c2fc
Gitweb:     http://git.kernel.org/tip/89240ba059ca468ae7a8346edf7f95082458c2fc
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Tue, 3 Nov 2009 10:22:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:25:03 +0100

x86, fs: Fix x86 procfs stack information for threads on 64-bit

This patch fixes two issues in the procfs stack information on
x86-64 linux.

The 32 bit loader compat_do_execve did not store stack
start. (this was figured out by Alexey Dobriyan).

The stack information on a x64_64 kernel always shows 0 kbyte
stack usage, because of a missing implementation of the KSTK_ESP
macro which always returned -1.

The new implementation now returns the right value.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1257240160.4889.24.camel@wall-e>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/process_64.c     |    5 +++++
 fs/compat.c                      |    2 ++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c3429e8..c978648 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1000,7 +1000,7 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
 
 #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
-#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
+extern unsigned long KSTK_ESP(struct task_struct *task);
 #endif /* CONFIG_X86_64 */
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..eb62cbc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -664,3 +664,8 @@ long sys_arch_prctl(int code, unsigned long addr)
 	return do_arch_prctl(current, code, addr);
 }
 
+unsigned long KSTK_ESP(struct task_struct *task)
+{
+	return (test_tsk_thread_flag(task, TIF_IA32)) ?
+			(task_pt_regs(task)->sp) : ((task)->thread.usersp);
+}
diff --git a/fs/compat.c b/fs/compat.c
index d576b55..6c19040 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1532,6 +1532,8 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
