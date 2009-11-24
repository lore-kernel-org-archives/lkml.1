Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbZKXUMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbZKXUMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbZKXUMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:12:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbZKXUMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:12:34 -0500
Date: Tue, 24 Nov 2009 21:01:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 06/14] ptrace: x86: implement user_single_step_siginfo()
Message-ID: <20091124200149.GA5782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(already in mm: ptrace-x86-implement-user_single_step_siginfo.patch)

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

--- V1/arch/x86/include/asm/ptrace.h~6_X86_HELPER	2009-11-24 19:46:48.000000000 +0100
+++ V1/arch/x86/include/asm/ptrace.h	2009-11-24 19:52:11.000000000 +0100
@@ -230,6 +230,8 @@ extern void user_enable_block_step(struc
 #define arch_has_block_step()	(boot_cpu_data.x86 >= 6)
 #endif
 
+#define ARCH_HAS_USER_SINGLE_STEP_INFO
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
--- V1/arch/x86/kernel/ptrace.c~6_X86_HELPER	2009-11-24 19:46:48.000000000 +0100
+++ V1/arch/x86/kernel/ptrace.c	2009-11-24 19:52:11.000000000 +0100
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

