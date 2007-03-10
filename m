Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbXCJIIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbXCJIIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933529AbXCJIIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:08:47 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:38450 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933526AbXCJIIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:08:46 -0500
Date: Sat, 10 Mar 2007 03:08:44 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, sparclinux@vger.kernel.org
Subject: [PATCH] Fix atomicity of TIF update in flush_thread() for sparc64
Message-ID: <20070310080844.GA23144@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix atomicity of TIF update in flush_thread() for sparc64

Fixes correctly the race by using *_ti_thread_flag.

Race :

parent process executing :
sys_ptrace()
 (lock_kernel())
 (ptrace_get_task_struct(pid))
 arch_ptrace()
   ptrace_detach()
     ptrace_disable(child);
       clear_singlestep(child);
         clear_tsk_thread_flag(child, TIF_SINGLESTEP);
         (which clears the TIF_SINGLESTEP flag atomically from a different
          process)
 (put_task_struct(child))
 (unlock_kernel())

And at the same time, in the child process :
sys_execve()
 do_execve()
   search_binary_handler()
     load_elf_binary()
       flush_old_exec()
         flush_thread()
           doing a non-atomic thread flag update

It applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -413,8 +413,13 @@ void flush_thread(void)
 	struct thread_info *t = current_thread_info();
 	struct mm_struct *mm;
 
-	if (t->flags & _TIF_ABI_PENDING)
-		t->flags ^= (_TIF_ABI_PENDING | _TIF_32BIT);
+	if (test_ti_thread_flag(t, TIF_ABI_PENDING)) {
+		clear_ti_thread_flag(t, TIF_ABI_PENDING);
+		if (test_ti_thread_flag(t, TIF_32BIT))
+			clear_ti_thread_flag(t, TIF_32BIT);
+		else
+			set_ti_thread_flag(t, TIF_32BIT);
+	}
 
 	mm = t->task->mm;
 	if (mm)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
