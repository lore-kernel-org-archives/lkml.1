Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYFPIYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYFPIYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYFPIY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:24:29 -0400
Received: from lea.cs.unibo.it ([130.136.1.101]:59813 "EHLO lea.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbYFPIY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:24:27 -0400
Date: Mon, 16 Jun 2008 09:58:32 +0200
To: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/2] ptrace_multi: speedup for virtual machines (and debuggers) running on ptrace
Message-ID: <20080616075832.GE6950@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning:
This is a proof-of-concept. It shows the effectiveness of PTRACE_MULTI
(PATCH 1/2). It is incomplete, not to be included at this stage.

This patch adds some PTRACE_MULTI optimizations to User-Mode Linux client
code. With these optimization UML decreases the overall number of
syscalls (around 15% in my preliminary tests) and shows some speedup
(5%).

I expect better figures when all the UML client code will take advantage
of PTRACE_MULTI and on other architectures (e.g. on powerpc, still
unsupported, where tens of ptrace in a row are needed to get/set
registers).

This patch is against 2.6.26-rc6 (or git2) + ptrace_multi + ptrace_vm

	renzo

Signed-off-by: Renzo Davoli
---
diff -Naur linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/include/ptrace_user.h linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/include/ptrace_user.h
--- linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/include/ptrace_user.h	2008-06-14 20:07:04.000000000 +0200
+++ linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/include/ptrace_user.h	2008-06-15 18:35:28.000000000 +0200
@@ -20,6 +20,18 @@
 #define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
+#define PTRACE_MULTI            0x4300
+#define PTRACE_PEEKCHARDATA     0x4301
+#define PTRACE_POKECHARDATA     0x4302
+#define PTRACE_PEEKSTRINGDATA   0x4303
+
+struct ptrace_multi {
+	long request;
+	long addr;
+	void *localaddr;
+	long length;
+};
+
 /* On architectures, that started to support PTRACE_O_TRACESYSGOOD
  * in linux 2.4, there are two different definitions of
  * PTRACE_SETOPTIONS: linux 2.4 uses 21 while linux 2.6 uses 0x4200.
@@ -54,6 +66,9 @@
 void set_using_sysptvm(int value);
 int get_using_sysptvm(void);
 extern int sysptvm_supported;
+void set_using_sysptmulti(int value);
+int get_using_sysptmulti(void);
+extern int sysptmulti_supported;
 
 #define SELECT_PTRACE_OPERATION(sysemu_mode, singlestep_mode) \
 	(((int[3][3] ) { \
diff -Naur linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/kernel/process.c linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/kernel/process.c
--- linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/kernel/process.c	2008-06-14 20:07:04.000000000 +0200
+++ linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/kernel/process.c	2008-06-15 18:35:28.000000000 +0200
@@ -323,8 +323,10 @@
 
 static atomic_t using_sysemu = ATOMIC_INIT(0);
 static atomic_t using_sysptvm = ATOMIC_INIT(0);
+static atomic_t using_sysptmulti = ATOMIC_INIT(0);
 int sysemu_supported;
 int sysptvm_supported;
+int sysptmulti_supported;
 
 void set_using_sysemu(int value)
 {
@@ -348,6 +350,16 @@
 	return atomic_read(&using_sysptvm);
 }
 
+void set_using_sysptmulti(int value)
+{
+	atomic_set(&using_sysptmulti, value);
+}
+
+int get_using_sysptmulti(void)
+{
+	return atomic_read(&using_sysptmulti);
+}
+
 static int proc_read_sysemu(char *buf, char **start, off_t offset, int size,int *eof, void *data)
 {
 	if (snprintf(buf, size, "%d\n", get_using_sysemu()) < size)
@@ -395,6 +407,28 @@
 	return count;
 }
 
+static int proc_read_sysptmulti(char *buf, char **start, off_t offset, int size,int *eof, void *data)
+{
+	if (snprintf(buf, size, "%d\n", get_using_sysptmulti()) < size)
+		/* No overflow */
+		*eof = 1;
+
+	return strlen(buf);
+}
+
+static int proc_write_sysptmulti(struct file *file,const char __user *buf, unsigned long count,void *data)
+{
+	char tmp[2];
+
+	if (copy_from_user(tmp, buf, 1))
+		return -EFAULT;
+
+	if (tmp[0] >= '0' && tmp[0] <= '2')
+		set_using_sysptmulti(tmp[0] - '0');
+	/* We use the first char, but pretend to write everything */
+	return count;
+}
+
 int __init make_proc_sysemu_or_sysptvm(void)
 {
 	struct proc_dir_entry *ent;
@@ -422,6 +456,18 @@
 		ent->read_proc  = proc_read_sysemu;
 		ent->write_proc = proc_write_sysemu;
 	}
+	if (sysptmulti_supported) {
+		ent = create_proc_entry("sysptmulti", 0600, NULL);
+
+		if (ent == NULL)
+		{
+			printk(KERN_WARNING "Failed to register /proc/sysptmulti\n");
+			return 0;
+		}
+
+		ent->read_proc  = proc_read_sysptmulti;
+		ent->write_proc = proc_write_sysptmulti;
+	}
 	return 0;
 }
 
diff -Naur linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/os-Linux/skas/mem.c linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/os-Linux/skas/mem.c
--- linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/os-Linux/skas/mem.c	2008-06-14 20:06:12.000000000 +0200
+++ linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/os-Linux/skas/mem.c	2008-06-16 01:47:34.000000000 +0200
@@ -69,19 +69,32 @@
 
 	multi_count++;
 
-	n = ptrace_setregs(pid, syscall_regs);
-	if (n < 0) {
-		printk(UM_KERN_ERR "Registers - \n");
-		for (i = 0; i < MAX_REG_NR; i++)
-			printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
-		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
-		      -n);
-	}
+	if (get_using_sysptmulti()) {
+		struct ptrace_multi req[] = {
+			{PTRACE_SETREGS, 0, syscall_regs, 0},
+			{PTRACE_CONT, 0, 0, 0}};
+		err=ptrace(PTRACE_MULTI,pid,req,2);
+		if (err<0) {
+			err = -errno;
+			printk(UM_KERN_ERR "do_syscall_stub: failed ptrace_multi "
+					"failed, pid = %d, errno = %d\n", pid, -err);
+			return err;
+		}
+	} else {
+		n = ptrace_setregs(pid, syscall_regs);
+		if (n < 0) {
+			printk(UM_KERN_ERR "Registers - \n");
+			for (i = 0; i < MAX_REG_NR; i++)
+				printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
+			panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
+					-n);
+		}
 
-	err = ptrace(PTRACE_CONT, pid, 0, 0);
-	if (err)
-		panic("Failed to continue stub, pid = %d, errno = %d\n", pid,
-		      errno);
+		err = ptrace(PTRACE_CONT, pid, 0, 0);
+		if (err)
+			panic("Failed to continue stub, pid = %d, errno = %d\n", pid,
+					errno);
+	}
 
 	wait_stub_done(pid);
 
diff -Naur linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/os-Linux/skas/process.c linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/os-Linux/skas/process.c
--- linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/os-Linux/skas/process.c	2008-06-14 20:07:04.000000000 +0200
+++ linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/os-Linux/skas/process.c	2008-06-16 01:35:35.000000000 +0200
@@ -355,6 +355,7 @@
 	/* To prevent races if using_sysemu changes under us.*/
 	int local_using_sysemu;
 	int local_using_sysptvm;
+	int local_using_sysptmulti;
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
 		printk(UM_KERN_ERR "Failed to get itimer, errno = %d\n", errno);
@@ -363,41 +364,53 @@
 	nsecs += os_nsecs();
 
 	while (1) {
-		/*
-		 * This can legitimately fail if the process loads a
-		 * bogus value into a segment register.  It will
-		 * segfault and PTRACE_GETREGS will read that value
-		 * out of the process.  However, PTRACE_SETREGS will
-		 * fail.  In this case, there is nothing to do but
-		 * just kill the process.
-		 */
-		if (ptrace(PTRACE_SETREGS, pid, 0, regs->gp))
-			fatal_sigsegv();
-
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
 		local_using_sysptvm = get_using_sysptvm();
+		local_using_sysptmulti = get_using_sysptmulti();
 
 		op = SELECT_PTRACE_OPERATION(local_using_sysemu,
-					     singlestepping(NULL));
+				singlestepping(NULL));
 
-		if (ptrace(op, pid, local_using_sysptvm, 0)) {
-			printk(UM_KERN_ERR "userspace - ptrace continue "
-			       "failed, op = %d, errno = %d\n", op, errno);
-			fatal_sigsegv();
+		if (local_using_sysptmulti) {
+			struct ptrace_multi req[] = {
+				{PTRACE_SETREGS, 0, regs->gp, 0},
+				{op, local_using_sysptvm, 0, 0}};
+			if (ptrace(PTRACE_MULTI,pid,req,2)) {
+				printk(UM_KERN_ERR "userspace - ptrace multi continue "
+						"failed, op = %d, errno = %d\n", op, errno);
+				fatal_sigsegv();
+			}
+		} else {
+			/*
+			 * This can legitimately fail if the process loads a
+			 * bogus value into a segment register.  It will
+			 * segfault and PTRACE_GETREGS will read that value
+			 * out of the process.  However, PTRACE_SETREGS will
+			 * fail.  In this case, there is nothing to do but
+			 * just kill the process.
+			 */
+			if (ptrace(PTRACE_SETREGS, pid, 0, regs->gp))
+				fatal_sigsegv();
+
+			if (ptrace(op, pid, local_using_sysptvm, 0)) {
+				printk(UM_KERN_ERR "userspace - ptrace continue "
+						"failed, op = %d, errno = %d\n", op, errno);
+				fatal_sigsegv();
+			}
 		}
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (err < 0) {
 			printk(UM_KERN_ERR "userspace - wait failed, "
-			       "errno = %d\n", errno);
+					"errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		regs->is_user = 1;
 		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp)) {
 			printk(UM_KERN_ERR "userspace - PTRACE_GETREGS failed, "
-			       "errno = %d\n", errno);
+					"errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
@@ -497,27 +510,40 @@
 					           { .it_value = tv,
 						     .it_interval = tv }) });
 
-	err = ptrace_setregs(pid, thread_regs);
-	if (err < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
-		       "failed, pid = %d, errno = %d\n", pid, -err);
-		return err;
-	}
-
 	/* set a well known return code for detection of child write failure */
 	child_data->err = 12345678;
 
-	/*
-	 * Wait, until parent has finished its work: read child's pid from
-	 * parent's stack, and check, if bad result.
-	 */
-	err = ptrace(PTRACE_CONT, pid, 0, 0);
-	if (err) {
-		err = -errno;
-		printk(UM_KERN_ERR "Failed to continue new process, pid = %d, "
-		       "errno = %d\n", pid, errno);
-		return err;
+	if (get_using_sysptmulti()) {
+		struct ptrace_multi req[] = {
+			{PTRACE_SETREGS, 0, thread_regs, 0},
+			{PTRACE_CONT, 0, 0, 0}};
+		err=ptrace(PTRACE_MULTI,pid,req,2);
+		if (err<0) {
+			err = -errno;
+			printk(UM_KERN_ERR "copy_context_skas0: failed ptrace_multi "
+					 "failed, pid = %d, errno = %d\n", pid, -err);
+			return err;
+		}
+	} else {
+		err = ptrace_setregs(pid, thread_regs);
+		if (err < 0) {
+			err = -errno;
+			printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
+					"failed, pid = %d, errno = %d\n", pid, -err);
+			return err;
+		}
+
+		/*
+		 * Wait, until parent has finished its work: read child's pid from
+		 * parent's stack, and check, if bad result.
+		 */
+		err = ptrace(PTRACE_CONT, pid, 0, 0);
+		if (err) {
+			err = -errno;
+			printk(UM_KERN_ERR "Failed to continue new process, pid = %d, "
+					"errno = %d\n", pid, errno);
+			return err;
+		}
 	}
 
 	wait_stub_done(pid);
diff -Naur linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/os-Linux/start_up.c linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/os-Linux/start_up.c
--- linux-2.6.26-rc6-ptrace_multi-ptrace_vm/arch/um/os-Linux/start_up.c	2008-06-14 20:07:04.000000000 +0200
+++ linux-2.6.26-rc6-ptrace_multi-ptrace_vm-umlmulti/arch/um/os-Linux/start_up.c	2008-06-15 18:35:28.000000000 +0200
@@ -225,6 +225,21 @@
 "    Use sysemu instead of sysptvm even when the kernel supports it.\n\n"
 );
 
+static int force_sysptmulti_disabled = 0;
+
+static int __init nosysptmulti_cmd_param(char *str, int* add)
+{
+	  force_sysptmulti_disabled = 1;
+		  return 0;
+}
+
+__uml_setup("nosysptmulti", nosysptmulti_cmd_param,
+		"nosysptmulti\n"
+		"    Turns off syscall multi for ptrace (ptrace_vm) on.\n"
+		"    Ptrace_vm is a feature introduced by Renzo Davoli: several\n"
+		"    ptrace() requests can be evaluated using one system call.\n"
+		"\n");
+
 static void __init check_sysemu(void)
 {
 	unsigned long regs[MAX_REG_NR];
@@ -344,6 +359,7 @@
 	return 0;
 }
 
+#define PTRACE_SUPPORTS_PTMULTI 0x80000000
 /* kernel feature test: 
  * it returns:
  *   -1 error 
@@ -351,7 +367,7 @@
  *   PTRACE_SYSCALL_SKIPEXIT: just skip_exit is provided
  *   PTRACE_SYSCALL_SKIPCALL: the entire syntax is implemented
  *   by the running kernel */
-static int __init test_ptrace_sysptvm(void) {
+static int __init test_ptrace_sysptvm_and_ptmulti(void) {
 	int pid, status, rv, feature;
 	static char stack[1024];
 	feature=0;
@@ -383,6 +399,8 @@
 	if(waitpid(pid, &status, WUNTRACED) < 0)
 		return 0;
 out:
+	if (ptrace(PTRACE_MULTI, pid, stack, 0) >= 0)
+		feature |= PTRACE_SUPPORTS_PTMULTI;
 	ptrace(PTRACE_KILL,pid,0,0);
 	/* eliminate zombie */
 	if(waitpid(pid, &status, WUNTRACED) < 0)
@@ -392,10 +410,11 @@
 
 static int  __init check_sysptvm(void)
 {
-	int feature=test_ptrace_sysptvm();
+	int feature=test_ptrace_sysptvm_and_ptmulti();
+	int rv=0;
   
 	non_fatal("Checking ptrace new tags for syscall emulation...");
-	if (feature==PTRACE_SYSCALL_SKIPCALL) {
+	if ((feature & ~PTRACE_SUPPORTS_PTMULTI)==PTRACE_SYSCALL_SKIPCALL) {
 		sysptvm_supported=1;
 		non_fatal("OK");
 		if (!force_sysptvm_disabled) 
@@ -403,10 +422,21 @@
 		else
 			non_fatal(" (disabled)");
 		non_fatal("\n");
-		return 1;
+		rv=1;
 	} else
 		non_fatal("unsupported\n");
-	return 0;
+	non_fatal("Checking ptrace multi speedup...");
+	if (feature & PTRACE_SUPPORTS_PTMULTI) {
+		sysptmulti_supported=1;
+		non_fatal("OK");
+		if (force_sysptmulti_disabled)
+			non_fatal(" (disabled)");
+		else
+			set_using_sysptmulti(1);
+		non_fatal("\n");
+	} else
+		non_fatal("unsupported\n");
+	return rv;
 }
 
 static void __init check_ptrace(void)
