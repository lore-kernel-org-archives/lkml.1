Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXGFTnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXGFTnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760499AbXGFTnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:43:05 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51348 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760277AbXGFTnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:43:02 -0400
Date: Fri, 6 Jul 2007 15:42:52 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Dan Kegel <dank@kegel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
Message-ID: <20070706194252.GA12311@c2.user-mode-linux.org>
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com> <468DD6A5.4020705@goop.org> <20070706172513.GD10670@c2.user-mode-linux.org> <a71bd89a0707061030s15572cj49cb748bf274593b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a71bd89a0707061030s15572cj49cb748bf274593b@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 10:30:19AM -0700, Dan Kegel wrote:
> Could you give it a shot?

OK, after ripping out the code that broke valgrind last time (patch
below), I get this:

==27590== Warning: set address range perms: large range 516194304, a 0, v 0
vex x86->IR: unhandled instruction bytes: 0xF3 0xAF 0x74 0x9
==27590== Your program just tried to execute an instruction that Valgrind
==27590== did not recognise.  There are two possible reasons for this.
==27590== 1. Your program has a bug and erroneously jumped to a non-code
==27590==    location.  If you are running Memcheck and you just saw a
==27590==    warning about a bad jump, it's probably your program's fault.
==27590== 2. The instruction is legitimate but Valgrind doesn't handle it,
==27590==    i.e. it's Valgrind's fault.  If you think this is the case or
==27590==    you are not sure, please let us know.
==27590== Either way, Valgrind will now raise a SIGILL signal which will
==27590== probably kill your program.
==27590== 

> Maybe the problems after that will be more pedestrian.

Doesn't look like it.

FWIW, that instruction is repz scas.  In an earlier valgrind effort in
2002, I hit repe scas
(http://www.goop.org/~jeremy/valgrind/76-repe-scas.patch), so maybe
something similar is needed here.

> I'm willing to focus a little effort on this.

I guess you'll have to fix valgrind's various bugs.  See, simple :)

				Jeff

-- 
Work email - jdike at linux dot intel dot com


Index: linux-2.6.21-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/start_up.c	2007-07-02 21:11:33.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/start_up.c	2007-07-06 15:16:47.000000000 -0400
@@ -43,54 +43,6 @@
 #include "registers.h"
 #endif
 
-static int ptrace_child(void *arg)
-{
-	int ret;
-	int pid = os_getpid(), ppid = getppid();
-	int sc_result;
-
-	change_sig(SIGWINCH, 0);
-	if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
-		perror("ptrace");
-		os_kill_process(pid, 0);
-	}
-	kill(pid, SIGSTOP);
-
-	/*This syscall will be intercepted by the parent. Don't call more than
-	 * once, please.*/
-	sc_result = os_getpid();
-
-	if (sc_result == pid)
-		ret = 1; /*Nothing modified by the parent, we are running
-			   normally.*/
-	else if (sc_result == ppid)
-		ret = 0; /*Expected in check_ptrace and check_sysemu when they
-			   succeed in modifying the stack frame*/
-	else
-		ret = 2; /*Serious trouble! This could be caused by a bug in
-			   host 2.6 SKAS3/2.6 patch before release -V6, together
-			   with a bug in the UML code itself.*/
-	_exit(ret);
-}
-
-static void fatal_perror(char *str)
-{
-	perror(str);
-	exit(1);
-}
-
-static void fatal(char *fmt, ...)
-{
-	va_list list;
-
-	va_start(list, fmt);
-	vprintf(fmt, list);
-	va_end(list);
-	fflush(stdout);
-
-	exit(1);
-}
-
 static void non_fatal(char *fmt, ...)
 {
 	va_list list;
@@ -101,64 +53,6 @@ static void non_fatal(char *fmt, ...)
 	fflush(stdout);
 }
 
-static int start_ptraced_child(void **stack_out)
-{
-	void *stack;
-	unsigned long sp;
-	int pid, n, status;
-
-	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
-		     PROT_READ | PROT_WRITE | PROT_EXEC,
-		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if(stack == MAP_FAILED)
-		fatal_perror("check_ptrace : mmap failed");
-	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
-	pid = clone(ptrace_child, (void *) sp, SIGCHLD, NULL);
-	if(pid < 0)
-		fatal_perror("start_ptraced_child : clone failed");
-	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-	if(n < 0)
-		fatal_perror("check_ptrace : clone failed");
-	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
-		fatal("check_ptrace : expected SIGSTOP, got status = %d",
-		      status);
-
-	*stack_out = stack;
-	return pid;
-}
-
-/* When testing for SYSEMU support, if it is one of the broken versions, we
- * must just avoid using sysemu, not panic, but only if SYSEMU features are
- * broken.
- * So only for SYSEMU features we test mustpanic, while normal host features
- * must work anyway!
- */
-static int stop_ptraced_child(int pid, void *stack, int exitcode,
-			      int mustexit)
-{
-	int status, n, ret = 0;
-
-	if(ptrace(PTRACE_CONT, pid, 0, 0) < 0)
-		fatal_perror("stop_ptraced_child : ptrace failed");
-	CATCH_EINTR(n = waitpid(pid, &status, 0));
-	if(!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
-		int exit_with = WEXITSTATUS(status);
-		if (exit_with == 2)
-			non_fatal("check_ptrace : child exited with status 2. "
-				  "\nDisabling SYSEMU support.\n");
-		non_fatal("check_ptrace : child exited with exitcode %d, while "
-			  "expecting %d; status 0x%x\n", exit_with,
-			  exitcode, status);
-		if (mustexit)
-			exit(1);
-		ret = -1;
-	}
-
-	if(munmap(stack, UM_KERN_PAGE_SIZE) < 0)
-		fatal_perror("check_ptrace : munmap failed");
-	return ret;
-}
-
 /* Changed only during early boot */
 int ptrace_faultinfo = 1;
 int ptrace_ldt = 1;
@@ -207,131 +101,23 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 
 static void __init check_sysemu(void)
 {
-	void *stack;
-	unsigned long regs[MAX_REG_NR];
-	int pid, n, status, count=0;
-
 	non_fatal("Checking syscall emulation patch for ptrace...");
-	sysemu_supported = 0;
-	pid = start_ptraced_child(&stack);
-
-	if(ptrace(PTRACE_SYSEMU, pid, 0, 0) < 0)
-		goto fail;
-
-	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-	if (n < 0)
-		fatal_perror("check_sysemu : wait failed");
-	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGTRAP))
-		fatal("check_sysemu : expected SIGTRAP, got status = %d",
-		      status);
-
-	if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
-		fatal_perror("check_sysemu : PTRACE_GETREGS failed");
-	if(PT_SYSCALL_NR(regs) != __NR_getpid){
-		non_fatal("check_sysemu got system call number %d, "
-			  "expected %d...", PT_SYSCALL_NR(regs), __NR_getpid);
-		goto fail;
-	}
-
-	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, os_getpid());
-	if(n < 0){
-		non_fatal("check_sysemu : failed to modify system call "
-			  "return");
-		goto fail;
-	}
-
-	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
-		goto fail_stopped;
-
 	sysemu_supported = 1;
 	non_fatal("OK\n");
 	set_using_sysemu(!force_sysemu_disabled);
 
 	non_fatal("Checking advanced syscall emulation patch for ptrace...");
-	pid = start_ptraced_child(&stack);
-
-	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
-		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
-		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
-
-	while(1){
-		count++;
-		if(ptrace(PTRACE_SYSEMU_SINGLESTEP, pid, 0, 0) < 0)
-			goto fail;
-		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if(n < 0)
-			fatal_perror("check_ptrace : wait failed");
-
-		if(WIFSTOPPED(status) && (WSTOPSIG(status) == (SIGTRAP|0x80))){
-			if (!count)
-				fatal("check_ptrace : SYSEMU_SINGLESTEP "
-				      "doesn't singlestep");
-			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
-				   os_getpid());
-			if(n < 0)
-				fatal_perror("check_sysemu : failed to modify "
-					     "system call return");
-			break;
-		}
-		else if(WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
-			count++;
-		else
-			fatal("check_ptrace : expected SIGTRAP or "
-			      "(SIGTRAP | 0x80), got status = %d", status);
-	}
-	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
-		goto fail_stopped;
-
 	sysemu_supported = 2;
 	non_fatal("OK\n");
 
 	if ( !force_sysemu_disabled )
 		set_using_sysemu(sysemu_supported);
 	return;
-
-fail:
-	stop_ptraced_child(pid, stack, 1, 0);
-fail_stopped:
-	non_fatal("missing\n");
 }
 
 static void __init check_ptrace(void)
 {
-	void *stack;
-	int pid, syscall, n, status;
-
 	non_fatal("Checking that ptrace can change system call numbers...");
-	pid = start_ptraced_child(&stack);
-
-	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
-		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
-		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
-
-	while(1){
-		if(ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0)
-			fatal_perror("check_ptrace : ptrace failed");
-
-		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if(n < 0)
-			fatal_perror("check_ptrace : wait failed");
-
-		if(!WIFSTOPPED(status) ||
-		   (WSTOPSIG(status) != (SIGTRAP | 0x80)))
-			fatal("check_ptrace : expected (SIGTRAP|0x80), "
-			       "got status = %d", status);
-
-		syscall = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_NR_OFFSET,
-				 0);
-		if(syscall == __NR_getpid){
-			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
-				   __NR_getppid);
-			if(n < 0)
-				fatal_perror("check_ptrace : failed to modify "
-					     "system call");
-			break;
-		}
-	}
-	stop_ptraced_child(pid, stack, 0, 1);
 	non_fatal("OK\n");
 	check_sysemu();
 }
@@ -411,63 +197,15 @@ __uml_setup("noptraceldt", noptraceldt_c
 #ifdef UML_CONFIG_MODE_SKAS
 static inline void check_skas3_ptrace_faultinfo(void)
 {
-	struct ptrace_faultinfo fi;
-	void *stack;
-	int pid, n;
-
 	non_fatal("  - PTRACE_FAULTINFO...");
-	pid = start_ptraced_child(&stack);
-
-	n = ptrace(PTRACE_FAULTINFO, pid, 0, &fi);
-	if (n < 0) {
-		ptrace_faultinfo = 0;
-		if(errno == EIO)
-			non_fatal("not found\n");
-		else
-			perror("not found");
-	}
-	else {
-		if (!ptrace_faultinfo)
-			non_fatal("found but disabled on command line\n");
-		else
-			non_fatal("found\n");
-	}
-
-	init_registers(pid);
-	stop_ptraced_child(pid, stack, 1, 1);
+	non_fatal("not found\n");
 }
 
 static inline void check_skas3_ptrace_ldt(void)
 {
 #ifdef PTRACE_LDT
-	void *stack;
-	int pid, n;
-	unsigned char ldtbuf[40];
-	struct ptrace_ldt ldt_op = (struct ptrace_ldt) {
-		.func = 2, /* read default ldt */
-		.ptr = ldtbuf,
-		.bytecount = sizeof(ldtbuf)};
-
 	non_fatal("  - PTRACE_LDT...");
-	pid = start_ptraced_child(&stack);
-
-	n = ptrace(PTRACE_LDT, pid, 0, (unsigned long) &ldt_op);
-	if (n < 0) {
-		if(errno == EIO)
-			non_fatal("not found\n");
-		else {
-			perror("not found");
-		}
-		ptrace_ldt = 0;
-	}
-	else {
-		if(ptrace_ldt)
-			non_fatal("found\n");
-		else
-			non_fatal("found, but use is disabled\n");
-	}
-
-	stop_ptraced_child(pid, stack, 1, 1);
+	non_fatal("not found\n");
 #else
 	/* PTRACE_LDT might be disabled via cmdline option.
 	 * We want to override this, else we might use the stub
