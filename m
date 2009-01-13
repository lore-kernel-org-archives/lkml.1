Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbZAMSfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbZAMSfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbZAMSfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:35:00 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:55436 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbZAMSe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v6ysIICV0J7AKqrhK3hreQk+dJEU6y1QWeAm2Y/1CSPE/3H5qDvmvQhQ+y/zlPvepD
         EeK2WC5PGqeDtwTfrs7T2xWgzewTsLwPvAzSwuMje6RXDMprIFoO+fTl4FVVg+MolheE
         JxbLK8P0EXro5WxaZya+bN3nocW5atnuqBd6o=
Date: Tue, 13 Jan 2009 21:34:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: [PATCH -tip] x86: headers - fix export private data to userspace
Message-ID: <20090113183456.GA14470@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warn us about leaking of kernel private
(mostly compile time vars) data to userspace in headers. Fix it.

More detailed report for easier reviewing:

1) boot.h - neither BOOT_HEAP_SIZE, BOOT_STACK_SIZE refs
   was found by searching thru net (ie in user-space area).

2) prctl.h - sys_arch_prctl is completely removed from
   header since frankly I don't even understand why we
   describe it here. It is described like
    __SYSCALL(__NR_arch_prctl, sys_arch_prctl) in unistd_64.h
   and implemented in process_64.c. User-mode linux involved?
   So this one in fact is suspicious.

3) ptrace-abi.h - ptrace_bts_config struct is wrapped
   by __KERNEL__ -- not sure if it was ever proposed for
   userland.

4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
   could use it.

5) sigcontext32.h - we really need linux/types.h here
   since we use __u... types.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I should probably write "Impact: break the kernel" :)

It requires _STRONG_ review, randconfig and so on. It's
really fragile -- having NAK on response will be fine.

 arch/x86/include/asm/boot.h         |   10 +++++++---
 arch/x86/include/asm/prctl.h        |    4 ----
 arch/x86/include/asm/ptrace-abi.h   |    4 +++-
 arch/x86/include/asm/setup.h        |    4 ++--
 arch/x86/include/asm/sigcontext32.h |    2 ++
 5 files changed, 14 insertions(+), 10 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/boot.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/boot.h
+++ linux-2.6.git/arch/x86/include/asm/boot.h
@@ -10,14 +10,16 @@
 #define EXTENDED_VGA	0xfffe		/* 80x50 mode */
 #define ASK_VGA		0xfffd		/* ask for it at bootup */
 
+#ifdef __KERNEL__
+
 /* Physical address where kernel should be loaded. */
 #define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
-#if (defined CONFIG_KERNEL_BZIP2)
+#ifdef CONFIG_KERNEL_BZIP2
 #define BOOT_HEAP_SIZE             0x400000
-#else
+#else /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
 #define BOOT_HEAP_SIZE	0x7000
@@ -25,7 +27,7 @@
 #define BOOT_HEAP_SIZE	0x4000
 #endif
 
-#endif
+#endif /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
 #define BOOT_STACK_SIZE	0x4000
@@ -33,4 +35,6 @@
 #define BOOT_STACK_SIZE	0x1000
 #endif
 
+#endif /* __KERNEL__ */
+
 #endif /* _ASM_X86_BOOT_H */
Index: linux-2.6.git/arch/x86/include/asm/prctl.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/prctl.h
+++ linux-2.6.git/arch/x86/include/asm/prctl.h
@@ -6,8 +6,4 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
-#ifdef CONFIG_X86_64
-extern long sys_arch_prctl(int, unsigned long);
-#endif /* CONFIG_X86_64 */
-
 #endif /* _ASM_X86_PRCTL_H */
Index: linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ptrace-abi.h
+++ linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
@@ -50,7 +50,7 @@
 #define RSP 152
 #define SS 160
 #define ARGOFFSET R11
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ || __FRAME_OFFSETS */
 
 /* top of stack page */
 #define FRAME_SIZE 168
@@ -80,6 +80,7 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
+#ifdef __KERNEL__
 #ifdef CONFIG_X86_PTRACE_BTS
 
 #ifndef __ASSEMBLY__
@@ -141,5 +142,6 @@ struct ptrace_bts_config {
    Returns number of BTS records drained.
 */
 #endif /* CONFIG_X86_PTRACE_BTS */
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PTRACE_ABI_H */
Index: linux-2.6.git/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/setup.h
+++ linux-2.6.git/arch/x86/include/asm/setup.h
@@ -3,6 +3,8 @@
 
 #define COMMAND_LINE_SIZE 2048
 
+#ifdef __KERNEL__
+
 #ifndef __ASSEMBLY__
 
 /* Interrupt control for vSMPowered x86_64 systems */
@@ -56,8 +58,6 @@ extern unsigned long saved_video_mode;
 #endif
 #endif /* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
-
 #ifdef __i386__
 
 #include <linux/pfn.h>
Index: linux-2.6.git/arch/x86/include/asm/sigcontext32.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/sigcontext32.h
+++ linux-2.6.git/arch/x86/include/asm/sigcontext32.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_SIGCONTEXT32_H
 #define _ASM_X86_SIGCONTEXT32_H
 
+#include <linux/types.h>
+
 /* signal context for 32bit programs. */
 
 #define X86_FXSR_MAGIC		0x0000
