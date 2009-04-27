Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZD0SJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZD0SJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZD0SIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:08:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36978 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZD0SIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:08:48 -0400
Date: Mon, 27 Apr 2009 20:04:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-kernel@vger.kernel.org
Subject: arch/ && tracehook_report_syscall_xxx()
Message-ID: <20090427180455.GA32509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a lot of code like arch/alpha/kernel/ptrace.c:syscall_trace()
in arch/ and I can't see how to convert them to use tracehooks.

The first problem, we don't know which hook should be called, there is
no entry/exit argument.

Still, I think it is better to change this code right now, and call
ptrace_report_syscall() directly.

But, the second problem, there is no "struct pt_regs *". What do you
think about the patch below?

However. I can't imagine how ptrace_report_syscall(regs) can actually
use "regs". Perhaps we can remove this argument?

Or what else do you think?

Hmm... and I can't understand how to change
arch/mn10300/kernel/ptrace.c:do_syscall_trace(), it does something
strange with TIF_SINGLESTEP. (maintainers cc'ed).

Oleg.

--- PTRACE/arch/alpha/kernel/ptrace.c~1_alpha	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/alpha/kernel/ptrace.c	2009-04-27 19:11:50.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/user.h>
 #include <linux/slab.h>
 #include <linux/security.h>
@@ -354,20 +355,6 @@ syscall_trace(void)
 {
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-	/* The 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
 
-	/*
-	 * This isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+	ptrace_report_syscall(NULL);
 }

