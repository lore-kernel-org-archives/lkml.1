Return-Path: <linux-kernel-owner+w=401wt.eu-S2992906AbXCICud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992906AbXCICud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992907AbXCICud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:50:33 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:42618 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992906AbXCICub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:50:31 -0500
Date: Thu, 8 Mar 2007 21:45:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: [PATCH] Fix atomicity of TIF update in flush_thread() for powerpc
Message-ID: <20070309024525.GB9462@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 21:42:37 up 34 days, 16:50,  6 users,  load average: 1.05, 1.11, 1.16
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix atomicity of TIF update in flush_thread() for powerpc

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

Applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -476,8 +476,13 @@ void flush_thread(void)
 #ifdef CONFIG_PPC64
 	struct thread_info *t = current_thread_info();
 
-	if (t->flags & _TIF_ABI_PENDING)
-		t->flags ^= (_TIF_ABI_PENDING | _TIF_32BIT);
+	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
+		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
+		if (test_tsk_thread_flag(tsk, TIF_32BIT))
+			clear_tsk_thread_flag(tsk, TIF_32BIT);
+		else
+			set_tsk_thread_flag(tsk, TIF_32BIT);
+	}
 #endif
 
 	discard_lazy_cpu_state();
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
