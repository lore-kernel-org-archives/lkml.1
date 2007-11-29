Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXK2MBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXK2MBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762721AbXK2MAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:00:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762762AbXK2MAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:00:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 09/11] x86 ia32 ptrace arch merge
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Shopping-List: (1) Fluent superstitious deriders
   (2) Latent remainders
   (3) Cautious pleasant fiction
   (4) Solicitous toothpick trash
   (5) Magnanimous mystic departure lasers
Message-Id: <20071129120041.8621A26F989@magilla.localdomain>
Date: Thu, 29 Nov 2007 04:00:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This moves the sys32_ptrace code into arch/x86/kernel/ptrace.c,
verbatim except for a few hard-coded sizes replaced with sizeof.
Here this code can use the shared local functions in this file.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |  214 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 214 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index bac5058..b3433e1 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -634,6 +634,10 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 #ifdef CONFIG_IA32_EMULATION
 
+#include <linux/compat.h>
+#include <linux/syscalls.h>
+#include <asm/ia32.h>
+#include <asm/fpu32.h>
 #include <asm/user32.h>
 
 #define R32(l,q)							\
@@ -756,6 +760,216 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 #undef R32
 #undef SEG32
 
+static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
+{
+	siginfo_t __user *si = compat_alloc_user_space(sizeof(siginfo_t));
+	compat_siginfo_t __user *si32 = compat_ptr(data);
+	siginfo_t ssi;
+	int ret;
+
+	if (request == PTRACE_SETSIGINFO) {
+		memset(&ssi, 0, sizeof(siginfo_t));
+		ret = copy_siginfo_from_user32(&ssi, si32);
+		if (ret)
+			return ret;
+		if (copy_to_user(si, &ssi, sizeof(siginfo_t)))
+			return -EFAULT;
+	}
+	ret = sys_ptrace(request, pid, addr, (unsigned long)si);
+	if (ret)
+		return ret;
+	if (request == PTRACE_GETSIGINFO) {
+		if (copy_from_user(&ssi, si, sizeof(siginfo_t)))
+			return -EFAULT;
+		ret = copy_siginfo_to_user32(si32, &ssi);
+	}
+	return ret;
+}
+
+asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
+{
+	struct task_struct *child;
+	struct pt_regs *childregs;
+	void __user *datap = compat_ptr(data);
+	int ret;
+	__u32 val;
+
+	switch (request) {
+	case PTRACE_TRACEME:
+	case PTRACE_ATTACH:
+	case PTRACE_KILL:
+	case PTRACE_CONT:
+	case PTRACE_SINGLESTEP:
+	case PTRACE_SINGLEBLOCK:
+	case PTRACE_DETACH:
+	case PTRACE_SYSCALL:
+	case PTRACE_OLDSETOPTIONS:
+	case PTRACE_SETOPTIONS:
+	case PTRACE_SET_THREAD_AREA:
+	case PTRACE_GET_THREAD_AREA:
+		return sys_ptrace(request, pid, addr, data);
+
+	default:
+		return -EINVAL;
+
+	case PTRACE_PEEKTEXT:
+	case PTRACE_PEEKDATA:
+	case PTRACE_POKEDATA:
+	case PTRACE_POKETEXT:
+	case PTRACE_POKEUSR:
+	case PTRACE_PEEKUSR:
+	case PTRACE_GETREGS:
+	case PTRACE_SETREGS:
+	case PTRACE_SETFPREGS:
+	case PTRACE_GETFPREGS:
+	case PTRACE_SETFPXREGS:
+	case PTRACE_GETFPXREGS:
+	case PTRACE_GETEVENTMSG:
+		break;
+
+	case PTRACE_SETSIGINFO:
+	case PTRACE_GETSIGINFO:
+		return ptrace32_siginfo(request, pid, addr, data);
+	}
+
+	child = ptrace_get_task_struct(pid);
+	if (IS_ERR(child))
+		return PTR_ERR(child);
+
+	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	if (ret < 0)
+		goto out;
+
+	childregs = task_pt_regs(child);
+
+	switch (request) {
+	case PTRACE_PEEKDATA:
+	case PTRACE_PEEKTEXT:
+		ret = 0;
+		if (access_process_vm(child, addr, &val, sizeof(u32), 0) !=
+		    sizeof(u32))
+			ret = -EIO;
+		else
+			ret = put_user(val, (unsigned int __user *)datap);
+		break;
+
+	case PTRACE_POKEDATA:
+	case PTRACE_POKETEXT:
+		ret = 0;
+		if (access_process_vm(child, addr, &data, sizeof(u32), 1) !=
+		    sizeof(u32))
+			ret = -EIO;
+		break;
+
+	case PTRACE_PEEKUSR:
+		ret = getreg32(child, addr, &val);
+		if (ret == 0)
+			ret = put_user(val, (__u32 __user *)datap);
+		break;
+
+	case PTRACE_POKEUSR:
+		ret = putreg32(child, addr, data);
+		break;
+
+	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
+		int i;
+
+		if (!access_ok(VERIFY_WRITE, datap, 16*4)) {
+			ret = -EIO;
+			break;
+		}
+		ret = 0;
+		for (i = 0; i < sizeof(struct user_regs_struct32); i += sizeof(__u32)) {
+			getreg32(child, i, &val);
+			ret |= __put_user(val, (u32 __user *)datap);
+			datap += sizeof(u32);
+		}
+		break;
+	}
+
+	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
+		unsigned long tmp;
+		int i;
+
+		if (!access_ok(VERIFY_READ, datap, 16*4)) {
+			ret = -EIO;
+			break;
+		}
+		ret = 0;
+		for (i = 0; i < sizeof(struct user_regs_struct32); i += sizeof(u32)) {
+			ret |= __get_user(tmp, (u32 __user *)datap);
+			putreg32(child, i, tmp);
+			datap += sizeof(u32);
+		}
+		break;
+	}
+
+	case PTRACE_GETFPREGS:
+		ret = -EIO;
+		if (!access_ok(VERIFY_READ, compat_ptr(data),
+			       sizeof(struct user_i387_struct)))
+			break;
+		save_i387_ia32(child, datap, childregs, 1);
+		ret = 0;
+			break;
+
+	case PTRACE_SETFPREGS:
+		ret = -EIO;
+		if (!access_ok(VERIFY_WRITE, datap,
+			       sizeof(struct user_i387_struct)))
+			break;
+		ret = 0;
+		/* don't check EFAULT to be bug-to-bug compatible to i386 */
+		restore_i387_ia32(child, datap, 1);
+		break;
+
+	case PTRACE_GETFPXREGS: {
+		struct user32_fxsr_struct __user *u = datap;
+
+		init_fpu(child);
+		ret = -EIO;
+		if (!access_ok(VERIFY_WRITE, u, sizeof(*u)))
+			break;
+			ret = -EFAULT;
+		if (__copy_to_user(u, &child->thread.i387.fxsave, sizeof(*u)))
+			break;
+		ret = __put_user(childregs->cs, &u->fcs);
+		ret |= __put_user(child->thread.ds, &u->fos);
+		break;
+	}
+	case PTRACE_SETFPXREGS: {
+		struct user32_fxsr_struct __user *u = datap;
+
+		unlazy_fpu(child);
+		ret = -EIO;
+		if (!access_ok(VERIFY_READ, u, sizeof(*u)))
+			break;
+		/*
+		 * no checking to be bug-to-bug compatible with i386.
+		 * but silence warning
+		 */
+		if (__copy_from_user(&child->thread.i387.fxsave, u, sizeof(*u)))
+			;
+		set_stopped_child_used_math(child);
+		child->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+		ret = 0;
+		break;
+	}
+
+	case PTRACE_GETEVENTMSG:
+		ret = put_user(child->ptrace_message,
+			       (unsigned int __user *)compat_ptr(data));
+		break;
+
+	default:
+		BUG();
+	}
+
+ out:
+	put_task_struct(child);
+	return ret;
+}
+
 #endif	/* CONFIG_IA32_EMULATION */
 
 #ifdef CONFIG_X86_32
