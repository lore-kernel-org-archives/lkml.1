Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYFWRuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYFWRuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYFWRuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:50:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48356 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYFWRuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:50:06 -0400
Date: Mon, 23 Jun 2008 20:48:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, cooloney@kernel.org,
       dev-etrax@axis.com, dhowells@redhat.com, gerg@uclinux.org,
       yasutake.koichi@jp.panasonic.com, linux-parisc@vger.kernel.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org, linux-sh@vger.kernel.org,
       chris@zankel.net, linux-mips@linux-mips.org, ysato@users.sourceforge.jp,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] asm/ptrace.h userspace headers cleanup
Message-ID: <20080623174809.GE4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups for the asm/ptrace.h 
userspace headers:
- include/asm-generic/Kbuild.asm already lists ptrace.h, remove
  the superfluous listings in the Kbuild files of the following
  architectures:
  - cris
  - frv
  - powerpc
  - x86
- don't expose function prototypes and macros to userspace:
  - arm
  - blackfin
  - cris
  - mn10300
  - parisc
- remove #ifdef CONFIG_'s around #define's:
  - blackfin
  - m68knommu
- sh: AFAIK __SH5__ should work in both kernel and userspace,
      no need to leak CONFIG_SUPERH64 to userspace
- xtensa: cosmetical change to remove empty
            #ifndef __ASSEMBLY__ #else #endif
          from the userspace headers

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

Not changed by this patch is the fact that the following architectures 
have a different struct pt_regs depending on CONFIG_ variables:
- h8300
- m68knommu
- mips

This does not work in userspace.


 include/asm-arm/ptrace.h           |    6 ++----
 include/asm-blackfin/ptrace.h      |    6 ++++--
 include/asm-cris/arch-v10/Kbuild   |    1 -
 include/asm-cris/arch-v10/ptrace.h |    4 ++++
 include/asm-cris/arch-v32/Kbuild   |    1 -
 include/asm-cris/arch-v32/ptrace.h |    4 ++++
 include/asm-cris/ptrace.h          |    4 +++-
 include/asm-frv/Kbuild             |    1 -
 include/asm-m68knommu/ptrace.h     |    2 --
 include/asm-mn10300/ptrace.h       |    8 ++++++--
 include/asm-parisc/ptrace.h        |    4 +++-
 include/asm-powerpc/Kbuild         |    1 -
 include/asm-sh/ptrace.h            |    2 +-
 include/asm-x86/Kbuild             |    1 -
 include/asm-xtensa/ptrace.h        |   10 +++++-----
 15 files changed, 32 insertions(+), 23 deletions(-)

fc14755b77cff7af5ff00e938a4c493a669e25cd diff --git a/include/asm-arm/ptrace.h b/include/asm-arm/ptrace.h
index 7aaa206..8382b75 100644
--- a/include/asm-arm/ptrace.h
+++ b/include/asm-arm/ptrace.h
@@ -139,8 +139,6 @@ static inline int valid_user_regs(struct pt_regs *regs)
 	return 0;
 }
 
-#endif	/* __KERNEL__ */
-
 #define pc_pointer(v) \
 	((v) & ~PCMASK)
 
@@ -153,10 +151,10 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 #define profile_pc(regs) instruction_pointer(regs)
 #endif
 
-#ifdef __KERNEL__
 #define predicate(x)		((x) & 0xf0000000)
 #define PREDICATE_ALWAYS	0xe0000000
-#endif
+
+#endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/include/asm-blackfin/ptrace.h b/include/asm-blackfin/ptrace.h
index b8346cd..a45a80e 100644
--- a/include/asm-blackfin/ptrace.h
+++ b/include/asm-blackfin/ptrace.h
@@ -83,14 +83,14 @@ struct pt_regs {
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13	/* ptrace signal  */
 
-#ifdef CONFIG_BINFMT_ELF_FDPIC
 #define PTRACE_GETFDPIC           31
 #define PTRACE_GETFDPIC_EXEC      0
 #define PTRACE_GETFDPIC_INTERP    1
-#endif
 
 #define PS_S  (0x0002)
 
+#ifdef __KERNEL__
+
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
@@ -98,6 +98,8 @@ struct pt_regs {
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+#endif  /*  __KERNEL__  */
+
 #endif				/* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-cris/arch-v10/Kbuild b/include/asm-cris/arch-v10/Kbuild
index 60e7e1b..7a192e1 100644
--- a/include/asm-cris/arch-v10/Kbuild
+++ b/include/asm-cris/arch-v10/Kbuild
@@ -1,4 +1,3 @@
-header-y += ptrace.h
 header-y += user.h
 header-y += svinto.h
 header-y += sv_addr_ag.h
diff --git a/include/asm-cris/arch-v10/ptrace.h b/include/asm-cris/arch-v10/ptrace.h
index fb14c5e..2f464ea 100644
--- a/include/asm-cris/arch-v10/ptrace.h
+++ b/include/asm-cris/arch-v10/ptrace.h
@@ -106,10 +106,14 @@ struct switch_stack {
 	unsigned long return_ip; /* ip that _resume will return to */
 };
 
+#ifdef __KERNEL__
+
 /* bit 8 is user-mode flag */
 #define user_mode(regs) (((regs)->dccr & 0x100) != 0)
 #define instruction_pointer(regs) ((regs)->irp)
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+#endif  /*  __KERNEL__  */
+
 #endif
diff --git a/include/asm-cris/arch-v32/Kbuild b/include/asm-cris/arch-v32/Kbuild
index a0ec545..35f2fc4 100644
--- a/include/asm-cris/arch-v32/Kbuild
+++ b/include/asm-cris/arch-v32/Kbuild
@@ -1,3 +1,2 @@
-header-y += ptrace.h
 header-y += user.h
 header-y += cryptocop.h
diff --git a/include/asm-cris/arch-v32/ptrace.h b/include/asm-cris/arch-v32/ptrace.h
index 516cc70..41f4e86 100644
--- a/include/asm-cris/arch-v32/ptrace.h
+++ b/include/asm-cris/arch-v32/ptrace.h
@@ -106,9 +106,13 @@ struct switch_stack {
 	unsigned long return_ip; /* ip that _resume will return to */
 };
 
+#ifdef __KERNEL__
+
 #define user_mode(regs) (((regs)->ccs & (1 << (U_CCS_BITNR + CCS_SHIFT))) != 0)
 #define instruction_pointer(regs) ((regs)->erp)
 extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) instruction_pointer(regs)
 
+#endif  /*  __KERNEL__  */
+
 #endif
diff --git a/include/asm-cris/ptrace.h b/include/asm-cris/ptrace.h
index 1ec69a7..d910925 100644
--- a/include/asm-cris/ptrace.h
+++ b/include/asm-cris/ptrace.h
@@ -4,11 +4,13 @@
 #include <asm/arch/ptrace.h>
 
 #ifdef __KERNEL__
+
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
-#endif
 
 #define profile_pc(regs) instruction_pointer(regs)
 
+#endif /* __KERNEL__ */
+
 #endif /* _CRIS_PTRACE_H */
diff --git a/include/asm-frv/Kbuild b/include/asm-frv/Kbuild
index bc3f12c..0f8956d 100644
--- a/include/asm-frv/Kbuild
+++ b/include/asm-frv/Kbuild
@@ -3,4 +3,3 @@ include include/asm-generic/Kbuild.asm
 header-y += registers.h
 
 unifdef-y += termios.h
-unifdef-y += ptrace.h
diff --git a/include/asm-m68knommu/ptrace.h b/include/asm-m68knommu/ptrace.h
index 47258e8..8c9194b 100644
--- a/include/asm-m68knommu/ptrace.h
+++ b/include/asm-m68knommu/ptrace.h
@@ -68,10 +68,8 @@ struct switch_stack {
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
-#ifdef CONFIG_FPU
 #define PTRACE_GETFPREGS          14
 #define PTRACE_SETFPREGS          15
-#endif
 
 #ifdef __KERNEL__
 
diff --git a/include/asm-mn10300/ptrace.h b/include/asm-mn10300/ptrace.h
index b368468..7b06cc6 100644
--- a/include/asm-mn10300/ptrace.h
+++ b/include/asm-mn10300/ptrace.h
@@ -88,12 +88,16 @@ extern struct pt_regs *__frame; /* current frame pointer */
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD     0x00000001
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#if defined(__KERNEL__)
+
+#if !defined(__ASSEMBLY__)
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
 extern void show_regs(struct pt_regs *);
-#endif
+#endif  /*  !__ASSEMBLY  */
 
 #define profile_pc(regs) ((regs)->pc)
 
+#endif  /*  __KERNEL__  */
+
 #endif /* _ASM_PTRACE_H */
diff --git a/include/asm-parisc/ptrace.h b/include/asm-parisc/ptrace.h
index 93f990e..3e94c5d 100644
--- a/include/asm-parisc/ptrace.h
+++ b/include/asm-parisc/ptrace.h
@@ -33,7 +33,6 @@ struct pt_regs {
 	unsigned long ipsw;	/* CR22 */
 };
 
-#define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
 /*
  * The numbers chosen here are somewhat arbitrary but absolutely MUST
  * not overlap with any of the number assigned in <linux/ptrace.h>.
@@ -43,8 +42,11 @@ struct pt_regs {
  * since we have taken branch traps too)
  */
 #define PTRACE_SINGLEBLOCK	12	/* resume execution until next branch */
+
 #ifdef __KERNEL__
 
+#define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
+
 /* XXX should we use iaoq[1] or iaoq[0] ? */
 #define user_mode(regs)			(((regs)->iaoq[0] & 3) ? 1 : 0)
 #define user_space(regs)		(((regs)->iasq[1] != 0) ? 1 : 0)
diff --git a/include/asm-powerpc/Kbuild b/include/asm-powerpc/Kbuild
index 7381916..6920904 100644
--- a/include/asm-powerpc/Kbuild
+++ b/include/asm-powerpc/Kbuild
@@ -32,7 +32,6 @@ unifdef-y += elf.h
 unifdef-y += nvram.h
 unifdef-y += param.h
 unifdef-y += posix_types.h
-unifdef-y += ptrace.h
 unifdef-y += seccomp.h
 unifdef-y += signal.h
 unifdef-y += spu_info.h
diff --git a/include/asm-sh/ptrace.h b/include/asm-sh/ptrace.h
index 8d6c92b..7d36dc3 100644
--- a/include/asm-sh/ptrace.h
+++ b/include/asm-sh/ptrace.h
@@ -5,7 +5,7 @@
  * Copyright (C) 1999, 2000  Niibe Yutaka
  *
  */
-#if defined(__SH5__) || defined(CONFIG_SUPERH64)
+#if defined(__SH5__)
 struct pt_regs {
 	unsigned long long pc;
 	unsigned long long sr;
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 1e35545..00473f7 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -19,7 +19,6 @@ unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
-unifdef-y += ptrace.h
 unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += vm86.h
diff --git a/include/asm-xtensa/ptrace.h b/include/asm-xtensa/ptrace.h
index 422c73e..089b0db 100644
--- a/include/asm-xtensa/ptrace.h
+++ b/include/asm-xtensa/ptrace.h
@@ -73,10 +73,10 @@
 #define PTRACE_GETXTREGS	18
 #define PTRACE_SETXTREGS	19
 
-#ifndef __ASSEMBLY__
-
 #ifdef __KERNEL__
 
+#ifndef __ASSEMBLY__
+
 /*
  * This struct defines the way the registers are stored on the
  * kernel stack during a system call or other kernel entry.
@@ -122,14 +122,14 @@ extern void show_regs(struct pt_regs *);
 # ifndef CONFIG_SMP
 #  define profile_pc(regs) instruction_pointer(regs)
 # endif
-#endif /* __KERNEL__ */
 
 #else	/* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
 # include <asm/asm-offsets.h>
 #define PT_REGS_OFFSET	  (KERNEL_STACK_SIZE - PT_USER_SIZE)
-#endif
 
 #endif	/* !__ASSEMBLY__ */
+
+#endif  /* __KERNEL__ */
+
 #endif	/* _XTENSA_PTRACE_H */

