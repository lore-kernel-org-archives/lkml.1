Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYH0NOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYH0NOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYH0NOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:14:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYH0NOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:14:43 -0400
Date: Wed, 27 Aug 2008 09:14:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Pavel Machek <pavel@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: disable tracing for suspend to ram
In-Reply-To: <alpine.DEB.1.10.0808221651350.15941@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822104610.GA3482@elf.ucw.cz> <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com> <200808222252.12547.rjw@sisk.pl> <alpine.DEB.1.10.0808221651350.15941@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been painstakingly debugging the issue with suspend to ram and 
ftraced. The 2.6.28 code does not have this issue, but since the mcount 
recording is not going to be in 27, this must be solved for the ftrace 
daemon version.

The resume from suspend to ram would reboot because it was triple 
faulting. Debugging further, I found that calling the mcount function 
itself was not an issue, but it would fault when it incremented 
preempt_count. preempt_count is on the tasks info structure that is on the 
low memory address of the task's stack.  For some reason, it could not 
write to it. Resuming out of suspend to ram does quite a lot of funny 
tricks to get to work, so it is not surprising at all that simply doing a 
preempt_disable() would cause a fault.

Thanks to Rafael for suggesting to add a "while (1);" to find the place in 
resuming that is causing the fault. I would place the loop somewhere in 
the code, compile and reboot and see if it would either reboot (hit the 
fault) or simply hang (hit the loop).  Doing this over and over again, I 
narrowed it down that it was happening in enable_nonboot_cpus.

At this point, I found that it is easier to simply disable tracing around 
the suspend code, instead of searching for the particular function that 
can not handle doing a preempt_disable.

This patch disables the tracer as it suspends and reenables it on resume.

I tested this patch on my Laptop, and it can resume fine with the patch.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/power/main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-compile.git/kernel/power/main.c
===================================================================
--- linux-compile.git.orig/kernel/power/main.c	2008-08-27 08:53:11.000000000 -0400
+++ linux-compile.git/kernel/power/main.c	2008-08-27 08:53:58.000000000 -0400
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
+#include <linux/ftrace.h>
 
 #include "power.h"
 
@@ -310,7 +311,7 @@ static int suspend_enter(suspend_state_t
  */
 int suspend_devices_and_enter(suspend_state_t state)
 {
-	int error;
+	int error, ftrace_save;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -321,6 +322,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	ftrace_save = __ftrace_enabled_save();
 	suspend_test_start();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
@@ -352,6 +354,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	device_resume(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	if (suspend_ops->end)


