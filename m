Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYISTjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYISTjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYISTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:39:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:60396 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:39:04 -0400
Message-ID: <48D3FFC9.5080701@windriver.com>
Date: Fri, 19 Sep 2008 14:38:49 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Denis Joseph Barrow <D.Barow@option.com>
CC: KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, gareth@valinux.com,
       markus.t.metzger@intel.com
Subject: Re: getting false SIGTRAP breakpoints in kernel i.e. kernel hung
 unless gdb remotely attached on x86 & cont is issued
References: <48D10A70.8050202@option.com> <48D10C43.90605@windriver.com> <48D1122F.6080101@option.com> <48D26B64.5080605@windriver.com> <48D39B9F.8010404@option.com> <48D3A1B4.8000505@windriver.com> <48D3AAB0.3010504@option.com>
In-Reply-To: <48D3AAB0.3010504@option.com>
Content-Type: multipart/mixed;
 boundary="------------010808030701020503020906"
X-OriginalArrivalTime: 19 Sep 2008 19:38:49.0637 (UTC) FILETIME=[56D75D50:01C91A8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010808030701020503020906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Denis Joseph Barrow wrote:
>
> The patch gets my full blessing even if my blessing is unimportant.
>

Full regression testing has turned up another problem.  If you single
step a system call with kgdb which is the same system call that ptrace
is stepping kgdb silently fails.

The complete fix to both problems is implemented in this patch, and it
has been regression tested across all the architectures.

This patch will be queued to the 2.6.27 fixes.

Jason.


--------------010808030701020503020906
Content-Type: text/x-diff;
 name="user_space_single_step_check_v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="user_space_single_step_check_v2.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kgdb, x86, arm, mips, powerpc: ignore user space single stepping

On the x86 arch, user space single step exceptions should be ignored
if they occur in the kernel space, such as ptrace stepping through a
system call.

First check if it is kgdb that is executing a single step, then ensure
it is not an accidental traversal into the user space, while in kgdb,
any other time the TIF_SINGLESTEP is set, kgdb should ignore the
exception.

On x86, arm, mips and powerpc, the kgdb_contthread usage was
inconsistent with the way single stepping is implemented in the kgdb
core.  The arch specific stub should always set the
kgdb_cpu_doing_single_step correctly if it is single stepping.  This
allows kgdb to correctly process an instruction steps if ptrace
happens to be requesting an instruction step over a system call.


Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/arm/kernel/kgdb.c     |    2 --
 arch/mips/kernel/kgdb.c    |    3 +--
 arch/powerpc/kernel/kgdb.c |    5 ++---
 arch/x86/kernel/kgdb.c     |   18 +++++++++++-------
 kernel/kgdb.c              |    8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -378,10 +378,8 @@ int kgdb_arch_handle_exception(int e_vec
 		if (remcomInBuffer[0] == 's') {
 			linux_regs->flags |= X86_EFLAGS_TF;
 			kgdb_single_step = 1;
-			if (kgdb_contthread) {
-				atomic_set(&kgdb_cpu_doing_single_step,
-					   raw_smp_processor_id());
-			}
+			atomic_set(&kgdb_cpu_doing_single_step,
+				   raw_smp_processor_id());
 		}
 
 		get_debugreg(dr6, 6);
@@ -466,9 +464,15 @@ static int __kgdb_notify(struct die_args
 
 	case DIE_DEBUG:
 		if (atomic_read(&kgdb_cpu_doing_single_step) ==
-			raw_smp_processor_id() &&
-			user_mode(regs))
-			return single_step_cont(regs, args);
+		    raw_smp_processor_id()) {
+			if (user_mode(regs))
+				return single_step_cont(regs, args);
+			break;
+		} else if (test_thread_flag(TIF_SINGLESTEP))
+			/* This means a user thread is single stepping
+			 * a system call which should be ignored
+			 */
+			return NOTIFY_DONE;
 		/* fall through */
 	default:
 		if (user_mode(regs))
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1462,7 +1462,7 @@ acquirelock:
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
 	 */
-	if (!kgdb_single_step || !kgdb_contthread) {
+	if (!kgdb_single_step) {
 		for (i = 0; i < NR_CPUS; i++)
 			atomic_set(&passive_cpu_wait[i], 1);
 	}
@@ -1475,7 +1475,7 @@ acquirelock:
 
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
-	if ((!kgdb_single_step || !kgdb_contthread) && kgdb_do_roundup)
+	if ((!kgdb_single_step) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif
 
@@ -1494,7 +1494,7 @@ acquirelock:
 	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	kgdb_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
-	kgdb_contthread = NULL;
+	kgdb_contthread = current;
 	exception_level = 0;
 
 	/* Talk to debugger with gdbserial protocol */
@@ -1508,7 +1508,7 @@ acquirelock:
 	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
 
-	if (!kgdb_single_step || !kgdb_contthread) {
+	if (!kgdb_single_step) {
 		for (i = NR_CPUS-1; i >= 0; i--)
 			atomic_set(&passive_cpu_wait[i], 0);
 		/*
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -111,8 +111,6 @@ int kgdb_arch_handle_exception(int excep
 	case 'D':
 	case 'k':
 	case 'c':
-		kgdb_contthread = NULL;
-
 		/*
 		 * Try to read optional parameter, pc unchanged if no parm.
 		 * If this was a compiled breakpoint, we need to move
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -236,8 +236,7 @@ int kgdb_arch_handle_exception(int vecto
 
 		atomic_set(&kgdb_cpu_doing_single_step, -1);
 		if (remcom_in_buffer[0] == 's')
-			if (kgdb_contthread)
-				atomic_set(&kgdb_cpu_doing_single_step, cpu);
+			atomic_set(&kgdb_cpu_doing_single_step, cpu);
 
 		return 0;
 	}
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -347,9 +347,8 @@ int kgdb_arch_handle_exception(int vecto
 			linux_regs->msr |= MSR_SE;
 #endif
 			kgdb_single_step = 1;
-			if (kgdb_contthread)
-				atomic_set(&kgdb_cpu_doing_single_step,
-					   raw_smp_processor_id());
+			atomic_set(&kgdb_cpu_doing_single_step,
+				   raw_smp_processor_id());
 		}
 		return 0;
 	}

--------------010808030701020503020906--
