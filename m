Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZKCJXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZKCJXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:23:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZKCJXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:23:01 -0500
Received: from www84.your-server.de ([213.133.104.84]:51494 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZKCJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:23:00 -0500
Subject: [PATCH] update v2 fix X86_64 procfs provide stack information for
 threads
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       ThomasGleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 Nov 2009 10:22:40 +0100
Message-ID: <1257240160.4889.24.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix two issues in the procfs stack information on X86_64
linux. 

The 32 bit loader compat_do_execve did not store stack start (this was
figured out by alexey).

The stack information on a X64_64 kernel always show 0 kbyte stack
usage, because of a miss implemented KSTK_ESP macro which always return
-1. The new implementation returns now the right value. 

The patch is against 2.6.32-rc5-git5.

Please apply this patch!

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/process_64.c     |    6 ++++++
 fs/compat.c                      |    2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

--- x/linux-2.6.32-rc5/fs/compat.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/fs/compat.c	2009-11-03 08:38:48.975196941 +0100
@@ -1532,6 +1532,8 @@
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
--- x/linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-11-03 10:15:12.094769885 +0100
@@ -1000,7 +1000,7 @@
 #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
 
 #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
-#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
+extern unsigned long KSTK_ESP(struct task_struct *task);
 #endif /* CONFIG_X86_64 */
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
--- x/linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-11-03 10:11:11.202957393 +0100
@@ -664,3 +664,9 @@
 	return do_arch_prctl(current, code, addr);
 }
 
+unsigned long KSTK_ESP(struct task_struct *task)
+{
+	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
+			(task_pt_regs(task)->sp) : \
+			((task)->thread.usersp);
+}


