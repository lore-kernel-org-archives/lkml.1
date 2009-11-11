Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZKKVhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZKKVhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759336AbZKKVhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:37:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759246AbZKKVhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:37:03 -0500
Date: Wed, 11 Nov 2009 22:32:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ptrace: x86: implement user_single_step_siginfo()
Message-ID: <20091111213203.GA10660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland.

Implement user_single_step_siginfo() for x86. Extract this code
from send_sigtrap().

Since x86 calls tracehook_report_syscall_exit(step => 0) the new
helper is not used yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 arch/x86/include/asm/ptrace.h |    2 ++
 arch/x86/kernel/ptrace.c      |   30 +++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

--- TH/arch/x86/include/asm/ptrace.h~4_X86_HELPER	2009-11-09 21:00:17.000000000 +0100
+++ TH/arch/x86/include/asm/ptrace.h	2009-11-10 22:16:28.000000000 +0100
@@ -230,6 +230,8 @@ extern void user_enable_block_step(struc
 #define arch_has_block_step()	(boot_cpu_data.x86 >= 6)
 #endif
 
+#define ARCH_HAS_USER_SINGLE_STEP_INFO
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
--- TH/arch/x86/kernel/ptrace.c~4_X86_HELPER	2009-11-09 21:00:17.000000000 +0100
+++ TH/arch/x86/kernel/ptrace.c	2009-11-10 22:21:42.000000000 +0100
@@ -1437,21 +1437,33 @@ const struct user_regset_view *task_user
 #endif
 }
 
-void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
-					 int error_code, int si_code)
+static void fill_sigtrap_info(struct task_struct *tsk,
+				struct pt_regs *regs,
+				int error_code, int si_code,
+				struct siginfo *info)
 {
-	struct siginfo info;
-
 	tsk->thread.trap_no = 1;
 	tsk->thread.error_code = error_code;
 
-	memset(&info, 0, sizeof(info));
-	info.si_signo = SIGTRAP;
-	info.si_code = si_code;
+	memset(info, 0, sizeof(*info));
+	info->si_signo = SIGTRAP;
+	info->si_code = si_code;
+	info->si_addr = user_mode_vm(regs) ? (void __user *)regs->ip : NULL;
+}
 
-	/* User-mode ip? */
-	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
+void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs,
+				struct siginfo *info)
+{
+	fill_sigtrap_info(tsk, regs, 0, TRAP_BRKPT, info);
+}
 
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+					 int error_code, int si_code)
+{
+	struct siginfo info;
+
+	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
 	/* Send us the fake SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
 }

