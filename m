Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXIVPj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXIVPj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 11:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXIVPju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 11:39:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:38073 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXIVPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=eJZVh4WBk6v5RTlWVNXokPO/aLyZrHa19CzZxNBVkXnBGgslLhmIJ5AtPvCi/UZBX2AX0fSAREn8+6V8hgUbi3Y4MECfHSNxmQrcrekOAr2RDgvHzJc6+Fh+NKAnFZbBw3PRLPHqhgbTzPgYZ/yMl84WVy909sTSe+3pwh7r1Go=
Date: Sat, 22 Sep 2007 23:39:32 +0800
From: lepton <ytht.net@gmail.com>
To: jdike@karaya.com
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] 2.6.22.6 user-mode linux: No need to new a stack for clone without CLONE_VM
Message-ID: <20070922153931.GA31436@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we just call clone without CLONE_VM, it is no need to 
use anoymous mmap to get a new stack frame.
Let's keep codes simple.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6-uml/Documentation/dontdiff -pru linux-2.6.22.6/arch/um/os-Linux/start_up.c linux-2.6.22.6-uml/arch/um/os-Linux/start_up.c
--- linux-2.6.22.6/arch/um/os-Linux/start_up.c	2007-09-14 17:41:10.000000000 +0800
+++ linux-2.6.22.6-uml/arch/um/os-Linux/start_up.c	2007-09-22 23:28:49.000000000 +0800
@@ -101,19 +101,13 @@ static void non_fatal(char *fmt, ...)
 	fflush(stdout);
 }
 
-static int start_ptraced_child(void **stack_out)
+static int start_ptraced_child(void)
 {
-	void *stack;
-	unsigned long sp;
+	unsigned long sp = (((unsigned long) &sp) & ~(UM_KERN_PAGE_SIZE-1))
+		+ UM_KERN_PAGE_SIZE - sizeof(void *);
 	int pid, n, status;
 
-	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
-		     PROT_READ | PROT_WRITE | PROT_EXEC,
-		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if(stack == MAP_FAILED)
-		fatal_perror("check_ptrace : mmap failed");
-	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
-	pid = clone(ptrace_child, (void *) sp, SIGCHLD, NULL);
+	pid = clone(ptrace_child, sp, SIGCHLD, NULL);
 	if(pid < 0)
 		fatal_perror("start_ptraced_child : clone failed");
 	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
@@ -123,7 +117,6 @@ static int start_ptraced_child(void **st
 		fatal("check_ptrace : expected SIGSTOP, got status = %d",
 		      status);
 
-	*stack_out = stack;
 	return pid;
 }
 
@@ -133,7 +126,7 @@ static int start_ptraced_child(void **st
  * So only for SYSEMU features we test mustpanic, while normal host features
  * must work anyway!
  */
-static int stop_ptraced_child(int pid, void *stack, int exitcode,
+static int stop_ptraced_child(int pid, int exitcode,
 			      int mustexit)
 {
 	int status, n, ret = 0;
@@ -154,8 +147,6 @@ static int stop_ptraced_child(int pid, v
 		ret = -1;
 	}
 
-	if(munmap(stack, UM_KERN_PAGE_SIZE) < 0)
-		fatal_perror("check_ptrace : munmap failed");
 	return ret;
 }
 
@@ -207,13 +198,12 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 
 static void __init check_sysemu(void)
 {
-	void *stack;
 	unsigned long regs[MAX_REG_NR];
 	int pid, n, status, count=0;
 
 	non_fatal("Checking syscall emulation patch for ptrace...");
 	sysemu_supported = 0;
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	if(ptrace(PTRACE_SYSEMU, pid, 0, 0) < 0)
 		goto fail;
@@ -240,7 +230,7 @@ static void __init check_sysemu(void)
 		goto fail;
 	}
 
-	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
+	if (stop_ptraced_child(pid, 0, 0) < 0)
 		goto fail_stopped;
 
 	sysemu_supported = 1;
@@ -248,7 +238,7 @@ static void __init check_sysemu(void)
 	set_using_sysemu(!force_sysemu_disabled);
 
 	non_fatal("Checking advanced syscall emulation patch for ptrace...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
@@ -279,7 +269,7 @@ static void __init check_sysemu(void)
 			fatal("check_ptrace : expected SIGTRAP or "
 			      "(SIGTRAP | 0x80), got status = %d", status);
 	}
-	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
+	if (stop_ptraced_child(pid, 0, 0) < 0)
 		goto fail_stopped;
 
 	sysemu_supported = 2;
@@ -290,18 +280,17 @@ static void __init check_sysemu(void)
 	return;
 
 fail:
-	stop_ptraced_child(pid, stack, 1, 0);
+	stop_ptraced_child(pid, 1, 0);
 fail_stopped:
 	non_fatal("missing\n");
 }
 
 static void __init check_ptrace(void)
 {
-	void *stack;
 	int pid, syscall, n, status;
 
 	non_fatal("Checking that ptrace can change system call numbers...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
@@ -331,7 +320,7 @@ static void __init check_ptrace(void)
 			break;
 		}
 	}
-	stop_ptraced_child(pid, stack, 0, 1);
+	stop_ptraced_child(pid, 0, 1);
 	non_fatal("OK\n");
 	check_sysemu();
 }
@@ -412,11 +401,10 @@ __uml_setup("noptraceldt", noptraceldt_c
 static inline void check_skas3_ptrace_faultinfo(void)
 {
 	struct ptrace_faultinfo fi;
-	void *stack;
 	int pid, n;
 
 	non_fatal("  - PTRACE_FAULTINFO...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	n = ptrace(PTRACE_FAULTINFO, pid, 0, &fi);
 	if (n < 0) {
@@ -434,13 +422,12 @@ static inline void check_skas3_ptrace_fa
 	}
 
 	init_registers(pid);
-	stop_ptraced_child(pid, stack, 1, 1);
+	stop_ptraced_child(pid, 1, 1);
 }
 
 static inline void check_skas3_ptrace_ldt(void)
 {
 #ifdef PTRACE_LDT
-	void *stack;
 	int pid, n;
 	unsigned char ldtbuf[40];
 	struct ptrace_ldt ldt_op = (struct ptrace_ldt) {
@@ -449,7 +436,7 @@ static inline void check_skas3_ptrace_ld
 		.bytecount = sizeof(ldtbuf)};
 
 	non_fatal("  - PTRACE_LDT...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	n = ptrace(PTRACE_LDT, pid, 0, (unsigned long) &ldt_op);
 	if (n < 0) {
@@ -467,7 +454,7 @@ static inline void check_skas3_ptrace_ld
 			non_fatal("found, but use is disabled\n");
 	}
 
-	stop_ptraced_child(pid, stack, 1, 1);
+	stop_ptraced_child(pid, 1, 1);
 #else
 	/* PTRACE_LDT might be disabled via cmdline option.
 	 * We want to override this, else we might use the stub
