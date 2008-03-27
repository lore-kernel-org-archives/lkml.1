Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYC0XHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYC0XHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYC0XHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:07:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYC0XHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:07:33 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH] ptrace: arch_ptrace cleanup
X-Fcc: ~/Mail/linus
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Message-Id: <20080327230623.969FF26FA1C@magilla.localdomain>
Date: Thu, 27 Mar 2008 16:06:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This intends to remove the last bit of entanglement with core ptrace
implementation details in arch code's arch_ptrace and arch_compat_ptrace.
Those functions should be responsible for handling arch-specific requests,
and nothing else.  After this any future churn in the core ptrace internals
need not translate into any churn in the arch code.

This changes the signature of the arch_ptrace and compat_arch_ptrace
functions.  They now return int and take a new long *retval argument.
On most machines, arch_ptrace only returns 0 or -error; there no change
is required except ignoring the new argument.  A few machines return a
nonzero success value by calling force_successful_syscall_return().
Those machines must change to instead return 0 and set *retval to the
user return value.

arch_ptrace and compat_arch_ptrace can now return 1 instead of calling
ptrace_request and compat_ptrace_request.  This leaves more latitude
for the machine-independent ptrace implementation code to change
without requiring any more updates in the arch code.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/alpha/kernel/ptrace.c     |   15 ++++++-----
 arch/arm/kernel/ptrace.c       |    5 ++-
 arch/avr32/kernel/ptrace.c     |    5 ++-
 arch/blackfin/kernel/ptrace.c  |    5 ++-
 arch/frv/kernel/ptrace.c       |    3 +-
 arch/h8300/kernel/ptrace.c     |    3 +-
 arch/ia64/kernel/ptrace.c      |   17 ++++++-------
 arch/m32r/kernel/ptrace.c      |    7 +++--
 arch/m68k/kernel/ptrace.c      |    5 ++-
 arch/m68knommu/kernel/ptrace.c |    3 +-
 arch/mips/kernel/ptrace.c      |    5 ++-
 arch/mn10300/kernel/ptrace.c   |    3 +-
 arch/parisc/kernel/ptrace.c    |    7 +++--
 arch/powerpc/kernel/ptrace.c   |    5 ++-
 arch/powerpc/kernel/ptrace32.c |    8 +++---
 arch/sh/kernel/ptrace_32.c     |    5 ++-
 arch/sh/kernel/ptrace_64.c     |    5 ++-
 arch/sparc/kernel/ptrace.c     |    5 ++-
 arch/sparc64/kernel/ptrace.c   |   11 +++++----
 arch/um/kernel/ptrace.c        |    3 +-
 arch/v850/kernel/ptrace.c      |    3 +-
 arch/x86/kernel/ptrace.c       |   13 +++++-----
 arch/xtensa/kernel/ptrace.c    |    6 ++--
 include/linux/compat.h         |    5 ++-
 include/linux/ptrace.h         |    3 +-
 kernel/ptrace.c                |   49 +++++++++++++++++++++++++++-------------
 26 files changed, 121 insertions(+), 83 deletions(-)

diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index 1e9ad52..7dc30f5 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -260,11 +260,12 @@ void ptrace_disable(struct task_struct *child)
 	ptrace_cancel_bpt(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	unsigned long tmp;
 	size_t copied;
-	long ret;
+	int ret;
 
 	switch (request) {
 	/* When I and D space are separate, these will need to be fixed.  */
@@ -275,14 +276,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (copied != sizeof(tmp))
 			break;
 		
-		force_successful_syscall_return();
-		ret = tmp;
+		ret = 0;
+		*retval = tmp;
 		break;
 
 	/* Read register number ADDR. */
 	case PTRACE_PEEKUSR:
-		force_successful_syscall_return();
-		ret = get_reg(child, addr);
+		ret = 0;
+		*retval = get_reg(child, addr);
 		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
 		break;
 
@@ -343,7 +344,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 	return ret;
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 4b05dc5..938be29 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -655,7 +655,8 @@ static int ptrace_setcrunchregs(struct task_struct *tsk, void __user *ufp)
 }
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 
@@ -778,7 +779,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 #endif
 
 		default:
-			ret = ptrace_request(child, request, addr, data);
+			ret = 1;
 			break;
 	}
 
diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index 1fed38f..5ce2ff7 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -141,7 +141,8 @@ static int ptrace_setregs(struct task_struct *tsk, const void __user *uregs)
 	return ret;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 
@@ -220,7 +221,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 85caf9b..bb679a8 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -189,7 +189,8 @@ void ptrace_disable(struct task_struct *child)
 	put_reg(child, PT_SR, tmp);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 	int add = 0;
@@ -402,7 +403,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		}
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 709e9bd..f948f81 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -104,7 +104,8 @@ void ptrace_enable(struct task_struct *child)
 	child->thread.frame0->__status |= REG__STATUS_STEP;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	unsigned long tmp;
 	int ret;
diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index d32bbf0..fd7ad00 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -55,7 +55,8 @@ void ptrace_disable(struct task_struct *child)
 	h8300_disable_trace(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index ab784ec..f75df7e 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1494,8 +1494,9 @@ ptrace_disable (struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long
-arch_ptrace (struct task_struct *child, long request, long addr, long data)
+int
+arch_ptrace (struct task_struct *child, long request, long addr, long data,
+	     long *retval)
 {
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -1504,9 +1505,8 @@ arch_ptrace (struct task_struct *child, long request, long addr, long data)
 		if (access_process_vm(child, addr, &data, sizeof(data), 0)
 		    != sizeof(data))
 			return -EIO;
-		/* ensure return value is not mistaken for error code */
-		force_successful_syscall_return();
-		return data;
+		*retval = data;
+		return 0;
 
 	/* PTRACE_POKETEXT and PTRACE_POKEDATA is handled
 	 * by the generic ptrace_request().
@@ -1516,9 +1516,8 @@ arch_ptrace (struct task_struct *child, long request, long addr, long data)
 		/* read the word at addr in the USER area */
 		if (access_uarea(child, addr, &data, 0) < 0)
 			return -EIO;
-		/* ensure return value is not mistaken for error code */
-		force_successful_syscall_return();
-		return data;
+		*retval = data;
+		return 0;
 
 	case PTRACE_POKEUSR:
 		/* write the word at addr in the USER area */
@@ -1543,7 +1542,7 @@ arch_ptrace (struct task_struct *child, long request, long addr, long data)
 				      (struct pt_all_user_regs __user *) data);
 
 	default:
-		return ptrace_request(child, request, addr, data);
+		return 1;
 	}
 }
 
diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 9aa615d..7934fbb 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -593,8 +593,9 @@ void ptrace_disable(struct task_struct *child)
 	/* nothing to do.. */
 }
 
-long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int
+arch_ptrace(struct task_struct *child, long request, long addr, long data,
+	    long *retval)
 {
 	int ret;
 
@@ -713,7 +714,7 @@ arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 2075543..6aadb9b 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -118,7 +118,8 @@ void ptrace_disable(struct task_struct *child)
 	singlestep_disable(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	unsigned long tmp;
 	int i, ret = 0;
@@ -266,7 +267,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index ef70ca0..42ebe24 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -99,7 +99,8 @@ void ptrace_disable(struct task_struct *child)
 	put_reg(child, PT_SR, tmp);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 35234b9..cf9d9c1 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -167,7 +167,8 @@ int ptrace_setfpregs(struct task_struct *child, __u32 __user *data)
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 
@@ -441,7 +442,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
  out:
diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index d6d6cdc..73e7ebe 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -132,7 +132,8 @@ void ptrace_enable(struct task_struct *child)
 /*
  * handle the arch-specific side of process tracing
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	struct fpu_state_struct fpu_state;
 	int i, ret;
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 49c6379..163df4b 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -77,9 +77,10 @@ void ptrace_disable(struct task_struct *child)
 	pa_psw(child)->l = 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
-	long ret;
+	int ret;
 #ifdef DEBUG_PTRACE
 	long oaddr=addr, odata=data;
 #endif
@@ -334,7 +335,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		goto out_tsk;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		goto out_tsk;
 	}
 
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 2a9fe97..c7db924 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -702,7 +702,8 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
 	return -EPERM;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret = -EPERM;
 
@@ -843,7 +844,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 	return ret;
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 4c1de6a..125e8e7 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -64,8 +64,8 @@ static long compat_ptrace_old(struct task_struct *child, long request,
 	return -EPERM;
 }
 
-long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
-			compat_ulong_t caddr, compat_ulong_t cdata)
+int compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+		       compat_ulong_t caddr, compat_ulong_t cdata, long *retval)
 {
 	unsigned long addr = caddr;
 	unsigned long data = cdata;
@@ -296,7 +296,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 	case PTRACE_SET_DEBUGREG:
 	case PTRACE_SYSCALL:
 	case PTRACE_CONT:
-		ret = arch_ptrace(child, request, addr, data);
+		ret = arch_ptrace(child, request, addr, data, retval);
 		break;
 
 	/* Old reverse args ptrace callss */
@@ -306,7 +306,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		break;
 
 	default:
-		ret = compat_ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index fddb547..6f0447a 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -84,7 +84,8 @@ void ptrace_disable(struct task_struct *child)
 	ptrace_disable_singlestep(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	struct user * dummy = NULL;
 	int ret;
@@ -242,7 +243,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	}
 #endif
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index f6fbdfa..1fcc2f2 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -120,7 +120,8 @@ put_fpu_long(struct task_struct *task, unsigned long addr, unsigned long data)
 }
 
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 
@@ -243,7 +244,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	}
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 	return ret;
diff --git a/arch/sparc/kernel/ptrace.c b/arch/sparc/kernel/ptrace.c
index 5b54f11..869ef43 100644
--- a/arch/sparc/kernel/ptrace.c
+++ b/arch/sparc/kernel/ptrace.c
@@ -319,7 +319,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sparc32_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	unsigned long addr2 = current->thread.kregs->u_regs[UREG_I4];
 	const struct user_regset_view *view;
@@ -441,7 +442,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/sparc64/kernel/ptrace.c b/arch/sparc64/kernel/ptrace.c
index aaae865..dbd900b 100644
--- a/arch/sparc64/kernel/ptrace.c
+++ b/arch/sparc64/kernel/ptrace.c
@@ -708,8 +708,8 @@ struct compat_fps {
 	} fpq[16];
 };
 
-long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
-			compat_ulong_t caddr, compat_ulong_t cdata)
+int compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+		       compat_ulong_t caddr, compat_ulong_t cdata, long *retval)
 {
 	const struct user_regset_view *view = task_user_regset_view(child);
 	compat_ulong_t caddr2 = task_pt_regs(current)->u_regs[UREG_I4];
@@ -804,7 +804,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		break;
 
 	default:
-		ret = compat_ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
@@ -817,7 +817,8 @@ struct fps {
 	unsigned long fsr;
 };
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	const struct user_regset_view *view = task_user_regset_view(child);
 	unsigned long addr2 = task_pt_regs(current)->u_regs[UREG_I4];
@@ -896,7 +897,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 47b57b4..ac4490c 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -36,7 +36,8 @@ void ptrace_disable(struct task_struct *child)
 extern int peek_user(struct task_struct * child, long addr, long data);
 extern int poke_user(struct task_struct * child, long addr, long data);
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int i, ret;
 	unsigned long __user *p = (void __user *)(unsigned long)data;
diff --git a/arch/v850/kernel/ptrace.c b/arch/v850/kernel/ptrace.c
index a458ac9..f44ab21 100644
--- a/arch/v850/kernel/ptrace.c
+++ b/arch/v850/kernel/ptrace.c
@@ -112,7 +112,8 @@ static int set_single_step (struct task_struct *t, int val)
 	return 1;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int rval;
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 2c5134e..c6a9092 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -867,7 +867,8 @@ void ptrace_disable(struct task_struct *child)
 static const struct user_regset_view user_x86_32_view; /* Initialized below. */
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -1011,7 +1012,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 #endif
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
@@ -1207,8 +1208,8 @@ static int genregs32_set(struct task_struct *target,
 	return ret;
 }
 
-long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
-			compat_ulong_t caddr, compat_ulong_t cdata)
+int compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+		       compat_ulong_t caddr, compat_ulong_t cdata, long *retval)
 {
 	unsigned long addr = caddr;
 	unsigned long data = cdata;
@@ -1264,10 +1265,10 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 	case PTRACE_GET_THREAD_AREA:
 	case PTRACE_SET_THREAD_AREA:
-		return arch_ptrace(child, request, addr, data);
+		return arch_ptrace(child, request, addr, data, retval);
 
 	default:
-		return compat_ptrace_request(child, request, addr, data);
+		return 1;
 	}
 
 	return ret;
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 9486882..8874627 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -245,7 +245,8 @@ int ptrace_pokeusr(struct task_struct *child, long regno, long val)
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+int arch_ptrace(struct task_struct *child, long request, long addr, long data,
+		long *retval)
 {
 	int ret = -EPERM;
 
@@ -330,7 +331,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = 1;
 		break;
 	}
 
@@ -374,4 +375,3 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 			&& (current->ptrace & PT_PTRACED))
 		do_syscall_trace();
 }
-
diff --git a/include/linux/compat.h b/include/linux/compat.h
index a671dbf..a8cb887 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -248,8 +248,9 @@ extern int compat_ptrace_request(struct task_struct *child,
 				 compat_ulong_t addr, compat_ulong_t data);
 
 #ifdef __ARCH_WANT_COMPAT_SYS_PTRACE
-extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
-			       compat_ulong_t addr, compat_ulong_t data);
+extern int compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			      compat_ulong_t addr, compat_ulong_t data,
+			      long *retval);
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
 #endif	/* __ARCH_WANT_COMPAT_SYS_PTRACE */
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ebe0c17..dc31063 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -80,7 +80,8 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
+extern int arch_ptrace(struct task_struct *child,
+		       long request, long addr, long data, long *retval);
 extern struct task_struct *ptrace_get_task_struct(pid_t pid);
 extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 67e392e..a56a95b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -574,18 +574,24 @@ asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 		 */
 		if (!ret)
 			arch_ptrace_attach(child);
-		goto out_put_task_struct;
+	} else {
+		ret = ptrace_check_attach(child, request == PTRACE_KILL);
+		/*
+		 * Let the arch handler inspect it first.
+		 * It returns > 0 if this is not an arch-specific request.
+		 */
+		if (!ret) {
+			int rc = arch_ptrace(child, request, addr, data, &ret);
+			if (rc > 0)
+				ret = ptrace_request(child, request,
+						     addr, data);
+			else if (rc < 0)
+				ret = rc;
+			else
+				force_successful_syscall_return();
+		}
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out_put_task_struct;
-
-	ret = arch_ptrace(child, request, addr, data);
-	if (ret < 0)
-		goto out_put_task_struct;
-
- out_put_task_struct:
 	put_task_struct(child);
  out:
 	unlock_kernel();
@@ -697,14 +703,25 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		 */
 		if (!ret)
 			arch_ptrace_attach(child);
-		goto out_put_task_struct;
+	} else {
+		ret = ptrace_check_attach(child, request == PTRACE_KILL);
+		/*
+		 * Let the arch handler inspect it first.
+		 * It returns > 0 if this is not an arch-specific request.
+		 */
+		if (!ret) {
+			int rc = compat_arch_ptrace(child, request, addr, data,
+						    &ret);
+			if (rc > 0)
+				ret = compat_ptrace_request(child, request,
+							    addr, data);
+			else if (rc < 0)
+				ret = rc;
+			else
+				force_successful_syscall_return();
+		}
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (!ret)
-		ret = compat_arch_ptrace(child, request, addr, data);
-
- out_put_task_struct:
 	put_task_struct(child);
  out:
 	unlock_kernel();
