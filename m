Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZCPIOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZCPIOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZCPIOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:14:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:5336 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZCPIOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hP1CIK2ELZOvIitfEToTgVTxL0sv7AK0+U/2JMQyuZvzNKuk1kY9OzgHxdbTjGBo8S
         XLThr76EYXWzL3EodL1m8SLUsjbH+V8gYKEEDRS6dfEk8NGJp3ppSJ/IMEF8E6s5ELYl
         7IxpOzHyOUN0UD0yE2dm1jtQ35HQLL+NMod+s=
Date: Mon, 16 Mar 2009 16:15:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Ingo Molnar <mingo@elte.hu>, Am??rico Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090316081508.GE3360@hack>
References: <20090204080256.GC17452@cs.unibo.it> <20090310214456.GE5213@cs.unibo.it> <20090310220241.GC30475@elte.hu> <20090311134138.GD12753@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311134138.GD12753@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 02:41:38PM +0100, Renzo Davoli wrote:
>> Please check Documentation/CodingStyle. Every second line above 
>> violates it. scripts/checkpatch.pl can help out with the more 
>> obvious ones.
>Ingo, 
>
>Thank you for your comment.
>You are right, I beg your pardon.
>I have updated the patch, now it should be (more) consistent
>with the Coding Style specifications.

You can use scripts/checkpatch.pl to check it before sending.

>
>This patch adds the new PTRACE_VM_SKIPCALL and PTRACE_VM_SKIPEXIT
>tags for ptrace's addr parameter.
>In this way it is possible to (eventually) get rid of PTRACE_SYSEMU
>PTRACE_SYSEMU_SINGLESTEP, while providing not only the same features
>but a more general support for Virtual Machines.
>Part#2: user-mode Linux support.
>User-mode Linux by this patch uses PTRACE_VM of the hosting operating system
>and provides PTRACE_VM to its processes.
>UML tests at startup which features are provided and uses PTRACE_VM or
>PTRACE_SYSEMU (or nothing). PTRACE_VM and/or PTRACE_SYSEMU support can be
>disabled by command line flags.
>

So what? PTRACE_VM is only supported in UML with this patch,
UML still has to use PTRACE_SYSEMU on x86_32.

Am I missing something? :)


>
>Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>


Minor comments below.

>----
>diff -Naur linux-2.6.29-rc7-git4/arch/um/include/shared/kern_util.h linux-2.6.29-rc7-git4.vm2/arch/um/include/shared/kern_util.h
>--- linux-2.6.29-rc7-git4/arch/um/include/shared/kern_util.h	2009-03-11 09:25:27.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/include/shared/kern_util.h	2009-03-11 09:35:23.000000000 +0100
>@@ -57,7 +57,7 @@
> extern unsigned long to_irq_stack(unsigned long *mask_out);
> extern unsigned long from_irq_stack(int nested);
> 
>-extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
>+extern int syscall_trace(struct uml_pt_regs *regs, int entryexit);
> extern int singlestepping(void *t);
> 
> extern void segv_handler(int sig, struct uml_pt_regs *regs);
>diff -Naur linux-2.6.29-rc7-git4/arch/um/include/shared/ptrace_user.h linux-2.6.29-rc7-git4.vm2/arch/um/include/shared/ptrace_user.h
>--- linux-2.6.29-rc7-git4/arch/um/include/shared/ptrace_user.h	2009-03-11 09:25:27.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/include/shared/ptrace_user.h	2009-03-11 09:35:23.000000000 +0100
>@@ -40,9 +40,20 @@
> #define PTRACE_OLDSETOPTIONS PTRACE_SETOPTIONS
> #endif
> 
>+/* these constant should eventually enter in sys/ptrace.h */
>+#ifndef PTRACE_SYSCALL_SKIPCALL
>+#define PTRACE_SYSCALL_SKIPCALL      0x6
>+#endif
>+#ifndef PTRACE_SYSCALL_SKIPEXIT
>+#define PTRACE_SYSCALL_SKIPEXIT      0x2
>+#endif
>+
> void set_using_sysemu(int value);
> int get_using_sysemu(void);
> extern int sysemu_supported;
>+void set_using_sysptvm(int value);
>+int get_using_sysptvm(void);
>+extern int sysptvm_supported;
> 
> #define SELECT_PTRACE_OPERATION(sysemu_mode, singlestep_mode) \
> 	(((int[3][3] ) { \
>diff -Naur linux-2.6.29-rc7-git4/arch/um/kernel/process.c linux-2.6.29-rc7-git4.vm2/arch/um/kernel/process.c
>--- linux-2.6.29-rc7-git4/arch/um/kernel/process.c	2009-03-11 09:25:27.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/kernel/process.c	2009-03-11 10:03:05.000000000 +0100
>@@ -322,7 +322,9 @@
> }
> 
> static atomic_t using_sysemu = ATOMIC_INIT(0);
>+static atomic_t using_sysptvm = ATOMIC_INIT(0);
> int sysemu_supported;
>+int sysptvm_supported;
> 
> void set_using_sysemu(int value)
> {
>@@ -336,7 +338,18 @@
> 	return atomic_read(&using_sysemu);
> }
> 
>-static int proc_read_sysemu(char *buf, char **start, off_t offset, int size,int *eof, void *data)
>+void set_using_sysptvm(int value)
>+{
>+	atomic_set(&using_sysptvm, value);
>+}
>+
>+int get_using_sysptvm(void)
>+{
>+	return atomic_read(&using_sysptvm);
>+}


How about making it boolean? AFAIK, you use it as a boolean.


>+
>+static int proc_read_sysemu(char *buf, char **start, off_t offset,
>+		int size, int *eof, void *data)
> {
> 	if (snprintf(buf, size, "%d\n", get_using_sysemu()) < size)
> 		/* No overflow */
>@@ -345,7 +358,8 @@
> 	return strlen(buf);
> }
> 
>-static int proc_write_sysemu(struct file *file,const char __user *buf, unsigned long count,void *data)
>+static int proc_write_sysemu(struct file *file, const char __user *buf,
>+		unsigned long count, void *data)
> {
> 	char tmp[2];
> 
>@@ -358,27 +372,63 @@
> 	return count;
> }
> 
>-int __init make_proc_sysemu(void)
>+
>+static int proc_read_sysptvm(char *buf, char **start, off_t offset,
>+		int size, int *eof, void *data)
> {
>-	struct proc_dir_entry *ent;
>-	if (!sysemu_supported)
>-		return 0;
>+	int sysptvm = (get_using_sysptvm() != 0);
>+	if (snprintf(buf, size, "%d\n", sysptvm) < size)
>+		/* No overflow */
>+		*eof = 1;
> 
>-	ent = create_proc_entry("sysemu", 0600, NULL);
>+	return strlen(buf);
>+}
> 
>-	if (ent == NULL)
>-	{
>-		printk(KERN_WARNING "Failed to register /proc/sysemu\n");
>-		return 0;
>-	}
>+static int proc_write_sysptvm(struct file *file, const char __user *buf,
>+		unsigned long count, void *data)
>+{
>+	char tmp[2];
>+
>+	if (copy_from_user(tmp, buf, 1))
>+		return -EFAULT;
>+
>+	if (tmp[0] == '0')
>+		set_using_sysptvm(0);
>+	if (tmp[0] == '1')
>+		set_using_sysemu(/* XXX */ 6);
>+	/* We use the first char, but pretend to write everything */
>+	return count;
>+}
> 
>-	ent->read_proc  = proc_read_sysemu;
>-	ent->write_proc = proc_write_sysemu;
>+int __init make_proc_sysemu_or_sysptvm(void)
>+{
>+	struct proc_dir_entry *ent;
> 
>+	if (sysptvm_supported) {
>+		ent = create_proc_entry("sysptvm", 0600, NULL);
>+
>+		if (ent == NULL) {
>+			printk(KERN_WARNING "Failed to register /proc/sysptvm\n");
>+			return 0;
>+		}
>+
>+		ent->read_proc  = proc_read_sysptvm;
>+		ent->write_proc = proc_write_sysptvm;
>+	} else if (sysemu_supported) {
>+		ent = create_proc_entry("sysemu", 0600, NULL);
>+
>+		if (ent == NULL) {
>+			printk(KERN_WARNING "Failed to register /proc/sysemu\n");
>+			return 0;
>+		}
>+
>+		ent->read_proc  = proc_read_sysemu;
>+		ent->write_proc = proc_write_sysemu;
>+	}
> 	return 0;
> }
> 
>-late_initcall(make_proc_sysemu);
>+late_initcall(make_proc_sysemu_or_sysptvm);
> 
> int singlestepping(void * t)
> {
>diff -Naur linux-2.6.29-rc7-git4/arch/um/kernel/ptrace.c linux-2.6.29-rc7-git4.vm2/arch/um/kernel/ptrace.c
>--- linux-2.6.29-rc7-git4/arch/um/kernel/ptrace.c	2009-03-11 09:30:19.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/kernel/ptrace.c	2009-03-11 09:35:23.000000000 +0100
>@@ -81,6 +81,8 @@
> 		if (request == PTRACE_SYSCALL)
> 			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> 		else clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
>+		child->ptrace &= ~PT_SYSCALL_MASK;
>+		child->ptrace |= (addr & PTRACE_SYSCALL_MASK) << 28;

28, ditto.

> 		child->exit_code = data;
> 		wake_up_process(child);
> 		ret = 0;
>@@ -107,7 +109,9 @@
> 		ret = -EIO;
> 		if (!valid_signal(data))
> 			break;
>+		child->ptrace &= ~PT_SYSCALL_MASK;
> 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
>+		child->ptrace |= (addr & PTRACE_SYSCALL_MASK) << 28;
> 		set_singlestepping(child, 1);
> 		child->exit_code = data;
> 		/* give it a chance to run. */
>@@ -250,7 +254,7 @@
>  * XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
>  * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
>  */
>-void syscall_trace(struct uml_pt_regs *regs, int entryexit)
>+int syscall_trace(struct uml_pt_regs *regs, int entryexit)
> {
> 	int is_singlestep = (current->ptrace & PT_DTRACE) && entryexit;
> 	int tracesysgood;
>@@ -272,10 +276,13 @@
> 		send_sigtrap(current, regs, 0);
> 
> 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
>-		return;
>+		return 0;
> 
> 	if (!(current->ptrace & PT_PTRACED))
>-		return;
>+		return 0;
>+
>+	if (entryexit && (current->ptrace & PT_SYSCALL_SKIPEXIT))
>+		return 0;
> 
> 	/*
> 	 * the 0x80 provides a way for the tracing parent to distinguish
>@@ -296,4 +303,8 @@
> 		send_sig(current->exit_code, current, 1);
> 		current->exit_code = 0;
> 	}
>+	if (!entryexit && (current->ptrace & PT_SYSCALL_SKIPCALL))
>+		return 1;
>+	else
>+		return 0;
> }
>diff -Naur linux-2.6.29-rc7-git4/arch/um/kernel/skas/syscall.c linux-2.6.29-rc7-git4.vm2/arch/um/kernel/skas/syscall.c
>--- linux-2.6.29-rc7-git4/arch/um/kernel/skas/syscall.c	2009-03-11 09:25:27.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/kernel/skas/syscall.c	2009-03-11 09:41:29.000000000 +0100
>@@ -17,8 +17,9 @@
> 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
> 	long result;
> 	int syscall;
>+	int skip_call;
> 
>-	syscall_trace(r, 0);
>+	skip_call = syscall_trace(r, 0);
> 
> 	/*
> 	 * This should go in the declaration of syscall, but when I do that,
>@@ -29,12 +30,15 @@
> 	 *     gcc version 4.0.1 20050727 (Red Hat 4.0.1-5)
> 	 * in case it's a compiler bug.
> 	 */
>-	syscall = UPT_SYSCALL_NR(r);
>-	if ((syscall >= NR_syscalls) || (syscall < 0))
>-		result = -ENOSYS;
>-	else result = EXECUTE_SYSCALL(syscall, regs);
>+	if (skip_call == 0) {
>+		syscall = UPT_SYSCALL_NR(r);
>+		if ((syscall >= NR_syscalls) || (syscall < 0))
>+			result = -ENOSYS;
>+		else
>+			result = EXECUTE_SYSCALL(syscall, regs);
> 
>-	REGS_SET_SYSCALL_RETURN(r->gp, result);
>+		REGS_SET_SYSCALL_RETURN(r->gp, result);
>+	}
> 
> 	syscall_trace(r, 1);
> }
>diff -Naur linux-2.6.29-rc7-git4/arch/um/os-Linux/skas/process.c linux-2.6.29-rc7-git4.vm2/arch/um/os-Linux/skas/process.c
>--- linux-2.6.29-rc7-git4/arch/um/os-Linux/skas/process.c	2009-03-11 09:25:27.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/os-Linux/skas/process.c	2009-03-11 09:35:23.000000000 +0100
>@@ -157,7 +157,7 @@
>  * (in local_using_sysemu
>  */
> static void handle_trap(int pid, struct uml_pt_regs *regs,
>-			int local_using_sysemu)
>+			int local_using_sysptvm_or_sysemu)


This argument name is too long. :)


> {
> 	int err, status;
> 
>@@ -167,7 +167,7 @@
> 	/* Mark this as a syscall */
> 	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->gp);
> 
>-	if (!local_using_sysemu)
>+	if (!local_using_sysptvm_or_sysemu)
> 	{
> 		err = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
> 			     __NR_getpid);
>@@ -354,6 +354,7 @@
> 	int err, status, op, pid = userspace_pid[0];
> 	/* To prevent races if using_sysemu changes under us.*/
> 	int local_using_sysemu;
>+	int local_using_sysptvm;
> 
> 	if (getitimer(ITIMER_VIRTUAL, &timer))
> 		printk(UM_KERN_ERR "Failed to get itimer, errno = %d\n", errno);
>@@ -375,11 +376,12 @@
> 
> 		/* Now we set local_using_sysemu to be used for one loop */
> 		local_using_sysemu = get_using_sysemu();
>+		local_using_sysptvm = get_using_sysptvm();
> 
> 		op = SELECT_PTRACE_OPERATION(local_using_sysemu,
> 					     singlestepping(NULL));
> 
>-		if (ptrace(op, pid, 0, 0)) {
>+		if (ptrace(op, pid, local_using_sysptvm, 0)) {
> 			printk(UM_KERN_ERR "userspace - ptrace continue "
> 			       "failed, op = %d, errno = %d\n", op, errno);
> 			fatal_sigsegv();
>diff -Naur linux-2.6.29-rc7-git4/arch/um/os-Linux/start_up.c linux-2.6.29-rc7-git4.vm2/arch/um/os-Linux/start_up.c
>--- linux-2.6.29-rc7-git4/arch/um/os-Linux/start_up.c	2009-03-11 09:25:27.000000000 +0100
>+++ linux-2.6.29-rc7-git4.vm2/arch/um/os-Linux/start_up.c	2009-03-11 09:58:40.000000000 +0100
>@@ -198,6 +198,34 @@
> "    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
> "    information.\n\n");
> 
>+/* Changed only during early boot */
>+static int force_sysptvm_disabled;
>+
>+static int __init nosysptvm_cmd_param(char *str, int* add)
>+{
>+	force_sysptvm_disabled = 1;
>+	return 0;
>+}
>+
>+__uml_setup("nosysptvm", nosysptvm_cmd_param,
>+"nosysptvm\n"
>+"    Turns off syscall emulation tags for ptrace (ptrace_vm) on.\n"
>+"    Ptrace_vm is a feature introduced by Renzo Davoli. It changes\n"
>+"    behaviour of ptrace() and helps reducing host context switch rate.\n\n");
>+
>+static int use_sysemu;
>+
>+static int __init usesysemu_cmd_param(char *str, int* add)

I don't like this function name either. :(

>+{
>+	use_sysemu = 1;
>+	return 0;
>+}
>+
>+__uml_setup("usesysemu", usesysemu_cmd_param,
>+"usesysemu\n"
>+"    Use sysemu instead of sysptvm even when the kernel supports it.\n\n"
>+);
>+
> static void __init check_sysemu(void)
> {
> 	unsigned long regs[MAX_REG_NR];
>@@ -293,6 +321,114 @@
> 	non_fatal("missing\n");
> }
> 
>+/*
>+ * test thread code. This thread is started only to test
>+ * which features are provided by the linux kernel
>+ */
>+static int sysptvm_child(void *arg)
>+{
>+	int *featurep = arg;
>+	int p[2] = {-1, -1};
>+	pid_t pid = os_getpid();
>+	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
>+		perror("ptrace test_ptracemulti");
>+		kill(pid, SIGKILL);
>+	}
>+	kill(pid, SIGSTOP);
>+	*featurep = 0;
>+	os_getpid();
>+	/*
>+	 * if it reaches this point in 1 stop it means that
>+	 * PTRACE_SYSCALL_SKIPEXIT works
>+	 */
>+	*featurep = PTRACE_SYSCALL_SKIPEXIT;
>+	pipe(p);
>+	/*
>+	 * if after a PTRACE_SYSCALL_SKIPCALL p[0] is already <0
>+	 * pipe has been really skipped
>+	 */
>+	if (p[0] < 0)
>+		*featurep = PTRACE_SYSCALL_SKIPCALL;
>+	else { /* clean up everything */
>+		close(p[0]);
>+		close(p[1]);
>+	}
>+	return 0;
>+}
>+
>+/*
>+ * kernel feature test:
>+ * it returns:
>+ *   -1 error
>+ *   0 old PTRACE_SYSCALL (addr is ignored)
>+ *   PTRACE_SYSCALL_SKIPEXIT: just skip_exit is provided
>+ *   PTRACE_SYSCALL_SKIPCALL: the entire syntax is implemented
>+ *   by the running kernel
>+ */
>+static int __init test_ptrace_sysptvm(void)

How about check_ptrace_sysptvm? Since it is consistent with
other check_XXX functions.

>+{
>+	int pid, status, rv, feature;
>+	static char stack[1024];
>+	feature = 0;
>+
>+	pid = clone(sysptvm_child, &stack[1020], SIGCHLD | CLONE_VM, &feature);
>+	if (pid < 0)
>+		return 0;
>+	if (waitpid(pid, &status, WUNTRACED) < 0) {
>+		kill(pid, SIGKILL);
>+		return 0;
>+	}
>+	/* restart and wait for the next syscall (getpid)*/
>+	rv = ptrace(PTRACE_SYSCALL, pid, 0, 0);
>+	if (waitpid(pid, &status, WUNTRACED) < 0)
>+		goto out;
>+	/* try to skip the exit call */
>+	rv = ptrace(PTRACE_SYSCALL, pid, PTRACE_SYSCALL_SKIPEXIT, 0);
>+	if (rv < 0)
>+		goto out;
>+	/* wait for the next stop */
>+	if (waitpid(pid, &status, WUNTRACED) < 0)
>+		goto out;
>+	/*
>+	 * if feature is already 0 it means that this is the exit call,
>+	 * and it has not been skipped, otherwise this is the
>+	 * entry call for the system call "time"
>+	 */
>+	if (feature < PTRACE_SYSCALL_SKIPEXIT)
>+		goto out;
>+	/* restart (time) and and try to skip the entire call */
>+	rv = ptrace(PTRACE_SYSCALL, pid, PTRACE_SYSCALL_SKIPCALL, 0);
>+	if (waitpid(pid, &status, WUNTRACED) < 0)
>+		return 0;
>+out:
>+	ptrace(PTRACE_KILL, pid, 0, 0);
>+	/* eliminate zombie */
>+	if (waitpid(pid, &status, WUNTRACED) < 0)
>+		return 0;
>+	return feature;
>+}
>+
>+static int  __init check_sysptvm(void)
>+{
>+	int feature = test_ptrace_sysptvm();
>+
>+	non_fatal("Checking ptrace new tags for syscall emulation...");
>+	if (feature == PTRACE_SYSCALL_SKIPCALL) {
>+		sysptvm_supported = 1;
>+		non_fatal("OK");
>+		if (!force_sysptvm_disabled) {
>+			set_using_sysptvm(PTRACE_SYSCALL_SKIPCALL);
>+			non_fatal("\n");
>+			return 1;
>+		} else {
>+			non_fatal(" (disabled)\n");
>+			return 0;
>+		}
>+	} else
>+		non_fatal("unsupported\n");
>+	return 0;
>+}
>+
> static void __init check_ptrace(void)
> {
> 	int pid, syscall, n, status;
>@@ -330,7 +466,8 @@
> 	}
> 	stop_ptraced_child(pid, 0, 1);
> 	non_fatal("OK\n");
>-	check_sysemu();
>+	if (use_sysemu || !check_sysptvm())
>+		check_sysemu();
> }
> 
> extern void check_tmpexec(void);

-- 
Do what you love, f**k the rest! F**k the regulations!
 
