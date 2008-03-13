Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYCMIeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYCMIeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYCMIeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:34:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYCMIee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:34:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH -mm 4/4] x86_64 ia32 ptrace: convert to compat_arch_ptrace
In-Reply-To: Roland McGrath's message of  Thursday, 13 March 2008 01:31:07 -0700 <20080313083107.8BDE926F992@magilla.localdomain>
References: <20080313083107.8BDE926F992@magilla.localdomain>
X-Zippy-Says: With this weapon I can expose fictional characters and bring about
    sweeping reforms!!
Message-Id: <20080313083430.30EA126F992@magilla.localdomain>
Date: Thu, 13 Mar 2008 01:34:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that there are no more special cases in sys32_ptrace, we
can convert to using the generic compat_sys_ptrace entry point.
The sys32_ptrace function gets simpler and becomes compat_arch_ptrace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S |    2 +-
 arch/x86/kernel/ptrace.c  |   65 +++++---------------------------------------
 include/asm-x86/ptrace.h  |    2 +
 3 files changed, 11 insertions(+), 58 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 8022d3c..b42d009 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -426,7 +426,7 @@ ia32_sys_call_table:
 	.quad sys_setuid16
 	.quad sys_getuid16
 	.quad compat_sys_stime	/* stime */		/* 25 */
-	.quad sys32_ptrace	/* ptrace */
+	.quad compat_sys_ptrace	/* ptrace */
 	.quad sys_alarm
 	.quad sys_fstat	/* (old)fstat */
 	.quad sys_pause
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 42305fa..e36c0f3 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1184,67 +1184,16 @@ static int genregs32_set(struct task_struct *target,
 	return ret;
 }
 
-asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
 {
-	struct task_struct *child;
-	struct pt_regs *childregs;
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
 	void __user *datap = compat_ptr(data);
 	int ret;
 	__u32 val;
 
 	switch (request) {
-	case PTRACE_TRACEME:
-	case PTRACE_ATTACH:
-	case PTRACE_KILL:
-	case PTRACE_CONT:
-	case PTRACE_SINGLESTEP:
-	case PTRACE_SINGLEBLOCK:
-	case PTRACE_DETACH:
-	case PTRACE_SYSCALL:
-	case PTRACE_OLDSETOPTIONS:
-	case PTRACE_SETOPTIONS:
-	case PTRACE_SET_THREAD_AREA:
-	case PTRACE_GET_THREAD_AREA:
-	case PTRACE_BTS_CONFIG:
-	case PTRACE_BTS_STATUS:
-	case PTRACE_BTS_SIZE:
-	case PTRACE_BTS_GET:
-	case PTRACE_BTS_CLEAR:
-	case PTRACE_BTS_DRAIN:
-		return sys_ptrace(request, pid, addr, data);
-
-	default:
-		return -EINVAL;
-
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-	case PTRACE_POKEDATA:
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEUSR:
-	case PTRACE_PEEKUSR:
-	case PTRACE_GETREGS:
-	case PTRACE_SETREGS:
-	case PTRACE_SETFPREGS:
-	case PTRACE_GETFPREGS:
-	case PTRACE_SETFPXREGS:
-	case PTRACE_GETFPXREGS:
-	case PTRACE_GETEVENTMSG:
-	case PTRACE_SETSIGINFO:
-	case PTRACE_GETSIGINFO:
-		break;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child))
-		return PTR_ERR(child);
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out;
-
-	childregs = task_pt_regs(child);
-
-	switch (request) {
 	case PTRACE_PEEKUSR:
 		ret = getreg32(child, addr, &val);
 		if (ret == 0)
@@ -1290,12 +1239,14 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
 
+	case PTRACE_GET_THREAD_AREA:
+	case PTRACE_SET_THREAD_AREA:
+		return arch_ptrace(child, request, addr, data);
+
 	default:
 		return compat_ptrace_request(child, request, addr, data);
 	}
 
- out:
-	put_task_struct(child);
 	return ret;
 }
 
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index bc44246..b57dc69 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -230,6 +230,8 @@ extern int do_get_thread_area(struct task_struct *p, int idx,
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
+#define __ARCH_WANT_COMPAT_SYS_PTRACE
+
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
