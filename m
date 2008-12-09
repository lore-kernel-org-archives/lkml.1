Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYLIOg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYLIOg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYLIOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:36:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYLIOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:36:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Ulrich Weigand <ulrich.weigand@de.ibm.com>
Subject: [PATCH, RFC] revert breakage from "tracehook: exec"
Date: Tue, 9 Dec 2008 15:33:09 +0100
User-Agent: KMail/1.9.9
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091533.10628.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Xzpuaum08h5hOrqSAf15B/tF4gdvi3wAltk8
 7DMyXkn7UKqHk/+GzhGSkTPY/kQrOdmYj02grgVoVQa53BP3zU
 i5bcJTGYNyn+uyBX51jZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 6341c39 "tracehook: exec" introduced a small regression in
2.6.27 regarding binfmt_misc exec event reporting. Since the reporting
is now done in the common search_binary_handler() function, an exec
of a misc binary will result in two (or possibly multiple) exec events
being reported, instead of just a single one, because the misc handler
contains a recursive call to search_binary_handler.

To add to the confusion, if ptrace event reporting (PTRACE_O_TRACEEVENT)
is not active, the multiple instances of send_sig (SIGTRAP) will in fact
cause only a single ptrace intercept, as the signals are not queued.
However, if PTRACE_O_TRACEEVENT is on, the debugger will actually see
multiple ptrace intercepts.

This (untested) patch moves the reporting back to the original location
and outside of the binfmt_misc path.

Signed-off-by: Ulrich Weigand <ulrich.weigand@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

 arch/x86/ia32/ia32_aout.c |    1 +
 fs/binfmt_aout.c          |    1 +
 fs/binfmt_elf.c           |    1 +
 fs/binfmt_elf_fdpic.c     |    2 ++
 fs/binfmt_flat.c          |    2 ++
 fs/binfmt_som.c           |    1 +
 fs/exec.c                 |    1 -
 7 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 127ec3f..f5b829a 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -444,6 +444,7 @@ beyond_if:
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 =
 	regs->r12 = regs->r13 = regs->r14 = regs->r15 = 0;
 	set_fs(USER_DS);
+	tracehook_report_exec(&aout_format, bprm, regs);
 	return 0;
 }
 
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 204cfd1..6979226 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -444,6 +444,7 @@ beyond_if:
 	regs->gp = ex.a_gpvalue;
 #endif
 	start_thread(regs, ex.a_entry, current->mm->start_stack);
+	tracehook_report_exec(&aout_format, bprm, regs);
 	return 0;
 }
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8fcfa39..a7403cc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1003,6 +1003,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 #endif
 
 	start_thread(regs, elf_entry, bprm->p);
+	tracehook_report_exec(&elf_format, bprm, regs);
 	retval = 0;
 out:
 	kfree(loc);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 5b5424c..d28052d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -434,6 +434,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	entryaddr = interp_params.entry_addr ?: exec_params.entry_addr;
 	start_thread(regs, entryaddr, current->mm->start_stack);
 
+	tracehook_report_exec(&elf_fdpic_format, bprm, regs);
+
 	retval = 0;
 
 error:
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index ccb781a..ed7aed3 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -922,6 +922,8 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	
 	start_thread(regs, start_addr, current->mm->start_stack);
 
+	tracehook_report_exec(&flat_format, bprm, regs);
+
 	return 0;
 }
 
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index 74e587a..40d88df 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -274,6 +274,7 @@ load_som_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	map_hpux_gateway_page(current,current->mm);
 
 	start_thread_som(regs, som_entry, bprm->p);
+	tracehook_report_exec(&som_format, bprm, regs);
 	return 0;
 
 	/* error cleanup */
diff --git a/fs/exec.c b/fs/exec.c
index 67120ec..700edae 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1225,7 +1225,6 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			read_unlock(&binfmt_lock);
 			retval = fn(bprm, regs);
 			if (retval >= 0) {
-				tracehook_report_exec(fmt, bprm, regs);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
