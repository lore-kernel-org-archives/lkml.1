Return-Path: <linux-kernel-owner+w=401wt.eu-S2992887AbXCICP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992887AbXCICP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992888AbXCICP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:15:56 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:62844 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992887AbXCICPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:15:55 -0500
Date: Thu, 8 Mar 2007 21:15:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rebecca Schultz <rschultz@google.com>
Cc: Andi Kleen <ak@suse.de>, "Martin J. Bligh" <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix atomicity of TIF update in flush_thread() for x86_64
Message-ID: <20070309021553.GA8387@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 21:13:03 up 34 days, 16:20,  5 users,  load average: 1.27, 1.44, 1.52
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix atomicity of TIF update in flush_thread() for x86_64

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

Signed-off-by: Rebecca Schultz <rschultz@google.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -385,14 +385,17 @@ void exit_thread(void)
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
-	struct thread_info *t = current_thread_info();
 
-	if (t->flags & _TIF_ABI_PENDING) {
-		t->flags ^= (_TIF_ABI_PENDING | _TIF_IA32);
-		if (t->flags & _TIF_IA32)
+	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
+		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
+		if (test_tsk_thread_flag(tsk, TIF_IA32)) {
+			clear_tsk_thread_flag(tsk, TIF_IA32);
+		} else {
+			set_tsk_thread_flag(tsk, TIF_IA32);
 			current_thread_info()->status |= TS_COMPAT;
+		}
 	}
-	t->flags &= ~_TIF_DEBUG;
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
 	tsk->thread.debugreg0 = 0;
 	tsk->thread.debugreg1 = 0;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
