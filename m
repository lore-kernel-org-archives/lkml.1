Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXJaVPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXJaVPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825AbXJaVOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:14:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbXJaVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:14:17 -0400
Date: Wed, 31 Oct 2007 14:10:26 -0700
Message-Id: <200710312110.l9VLAQP1026675@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1193845777-2007-3-git-send-email-k.shutemov@gmail.com>
Subject: [PATCH] Sanitize the type of struct user.u_ar0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct user.u_ar0 is defined to contain a pointer offset on all
architectures in which it is defined (all architectures which define
an a.out format except SPARC.)  However, it has a pointer type in the
headers, which is pointless -- <asm/user.h> is not exported to
userspace, and it just makes the code messy.

Redefine the field as "unsigned long" (which is the same size as a
pointer on all Linux architectures) and change the setting code to
user offsetof() instead of hand-coded arithmetic.

Cc: Linux Arch Mailing List <linux-arch@vger.kernel.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Håvard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/blackfin/kernel/process.c |    2 +-
 arch/m68k/kernel/process.c     |    2 +-
 arch/x86/ia32/ia32_aout.c      |    2 +-
 fs/binfmt_aout.c               |    2 +-
 include/asm-alpha/user.h       |    2 +-
 include/asm-arm/user.h         |    2 +-
 include/asm-avr32/user.h       |    2 +-
 include/asm-blackfin/user.h    |    2 +-
 include/asm-cris/user.h        |    2 +-
 include/asm-h8300/user.h       |    3 +--
 include/asm-ia64/user.h        |    2 +-
 include/asm-m32r/user.h        |    2 +-
 include/asm-m68k/user.h        |    3 +--
 include/asm-mips/user.h        |    2 +-
 include/asm-powerpc/user.h     |    2 +-
 include/asm-s390/user.h        |    3 +--
 include/asm-sh/user.h          |    2 +-
 include/asm-sh64/user.h        |    2 +-
 include/asm-v850/user.h        |    2 +-
 include/asm-x86/user_32.h      |    2 +-
 include/asm-x86/user_64.h      |    2 +-
 21 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9124467..5c08004 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -257,7 +257,7 @@ void dump_thread(struct pt_regs *regs, struct user *dump)
 		    ((unsigned long)(TASK_SIZE -
 				     dump->start_stack)) >> PAGE_SHIFT;
 
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
+	dump->u_ar0 = offsetof(struct user, regs);
 
 	dump->regs.r0 = regs->r0;
 	dump->regs.r1 = regs->r1;
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 3ee9186..f85b928 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -335,7 +335,7 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
 
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
+	dump->u_ar0 = offsetof(struct user, regs);
 	sw = ((struct switch_stack *)regs) - 1;
 	dump->regs.d1 = regs->d1;
 	dump->regs.d2 = regs->d2;
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 731aac1..c489fee 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -162,7 +162,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
-	dump.u_ar0 = (u32)(((unsigned long)(&dump.regs)) - ((unsigned long)(&dump)));
+	dump.u_ar0 = offsetof(struct user32, regs);
 	dump.signal = signr;
 	dump_thread32(regs, &dump);
 
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index e176d19..9a00063 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -115,7 +115,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 #ifndef __sparc__
-	dump.u_ar0 = (void *)(((unsigned long)(&dump.regs)) - ((unsigned long)(&dump)));
+	dump.u_ar0 = offsetof(struct user, regs);
 #endif
 	dump.signal = signr;
 	dump_thread(regs, &dump);
diff --git a/include/asm-alpha/user.h b/include/asm-alpha/user.h
index 7e417fc..a4eb6a4 100644
--- a/include/asm-alpha/user.h
+++ b/include/asm-alpha/user.h
@@ -39,7 +39,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-arm/user.h b/include/asm-arm/user.h
index 3e8b0f8..825c1e7 100644
--- a/include/asm-arm/user.h
+++ b/include/asm-arm/user.h
@@ -67,7 +67,7 @@ struct user{
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct pt_regs * u_ar0;	/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
diff --git a/include/asm-avr32/user.h b/include/asm-avr32/user.h
index 060fb3a..7e9152f 100644
--- a/include/asm-avr32/user.h
+++ b/include/asm-avr32/user.h
@@ -51,7 +51,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-blackfin/user.h b/include/asm-blackfin/user.h
index abc3462..afe6a0e 100644
--- a/include/asm-blackfin/user.h
+++ b/include/asm-blackfin/user.h
@@ -75,7 +75,7 @@ struct user {
 					   esp register.  */
 	long int signal;	/* Signal that caused the core dump. */
 	int reserved;		/* No longer used */
-	struct user_regs_struct *u_ar0;
+	unsigned long u_ar0;
 	/* Used by gdb to help find the values for */
 	/* the registers. */
 	unsigned long magic;	/* To uniquely identify a core file */
diff --git a/include/asm-cris/user.h b/include/asm-cris/user.h
index 2538e2a..73e60fc 100644
--- a/include/asm-cris/user.h
+++ b/include/asm-cris/user.h
@@ -38,7 +38,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-h8300/user.h b/include/asm-h8300/user.h
index 6c64f99..14a9e18 100644
--- a/include/asm-h8300/user.h
+++ b/include/asm-h8300/user.h
@@ -62,8 +62,7 @@ struct user{
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct user_regs_struct *u_ar0;
-				/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
diff --git a/include/asm-ia64/user.h b/include/asm-ia64/user.h
index 78e5a20..8b98211 100644
--- a/include/asm-ia64/user.h
+++ b/include/asm-ia64/user.h
@@ -44,7 +44,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-m32r/user.h b/include/asm-m32r/user.h
index 035258d..03b3c11 100644
--- a/include/asm-m32r/user.h
+++ b/include/asm-m32r/user.h
@@ -38,7 +38,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-m68k/user.h b/include/asm-m68k/user.h
index 8c56cca..f1f478d 100644
--- a/include/asm-m68k/user.h
+++ b/include/asm-m68k/user.h
@@ -72,8 +72,7 @@ struct user{
 				   esp register.  */
   long int signal;		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct user_regs_struct *u_ar0;
-				/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   struct user_m68kfp_struct* u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
diff --git a/include/asm-mips/user.h b/include/asm-mips/user.h
index 61f2a09..e8ca4d9 100644
--- a/include/asm-mips/user.h
+++ b/include/asm-mips/user.h
@@ -46,7 +46,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-powerpc/user.h b/include/asm-powerpc/user.h
index e59ade4..2f0223c 100644
--- a/include/asm-powerpc/user.h
+++ b/include/asm-powerpc/user.h
@@ -40,7 +40,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-s390/user.h b/include/asm-s390/user.h
index 1dc74ba..1b050e3 100644
--- a/include/asm-s390/user.h
+++ b/include/asm-s390/user.h
@@ -63,8 +63,7 @@ struct user {
 				   the top of the stack is always found in the
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
-  struct user_regs_struct *u_ar0;
-				/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
diff --git a/include/asm-sh/user.h b/include/asm-sh/user.h
index d1b8511..a1908c1 100644
--- a/include/asm-sh/user.h
+++ b/include/asm-sh/user.h
@@ -45,7 +45,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	struct user_fpu_struct* u_fpstate;	/* Math Co-processor pointer */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
diff --git a/include/asm-sh64/user.h b/include/asm-sh64/user.h
index eb3b33e..69b6cb6 100644
--- a/include/asm-sh64/user.h
+++ b/include/asm-sh64/user.h
@@ -55,7 +55,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	struct user_fpu_struct* u_fpstate;	/* Math Co-processor pointer */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
diff --git a/include/asm-v850/user.h b/include/asm-v850/user.h
index ccf4cea..a915d29 100644
--- a/include/asm-v850/user.h
+++ b/include/asm-v850/user.h
@@ -40,7 +40,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff --git a/include/asm-x86/user_32.h b/include/asm-x86/user_32.h
index 0e85d2a..2373f73 100644
--- a/include/asm-x86/user_32.h
+++ b/include/asm-x86/user_32.h
@@ -106,7 +106,7 @@ struct user{
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct user_pt_regs * u_ar0;	/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   struct user_i387_struct* u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
diff --git a/include/asm-x86/user_64.h b/include/asm-x86/user_64.h
index 12785c6..d7d0e1d 100644
--- a/include/asm-x86/user_64.h
+++ b/include/asm-x86/user_64.h
@@ -97,7 +97,7 @@ struct user{
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
   int pad1;
-  struct user_pt_regs * u_ar0;	/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   struct user_i387_struct* u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
-- 
1.5.3.4

