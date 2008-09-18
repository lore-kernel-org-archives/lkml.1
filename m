Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYIROxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYIROxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYIROxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:53:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:63371 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYIROxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:53:36 -0400
Message-ID: <48D26B64.5080605@windriver.com>
Date: Thu, 18 Sep 2008 09:53:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Denis Joseph Barrow <D.Barow@option.com>
CC: KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: getting false SIGTRAP breakpoints in kernel i.e. kernel hung
 unless gdb remotely attached on x86 & cont is issued
References: <48D10A70.8050202@option.com> <48D10C43.90605@windriver.com> <48D1122F.6080101@option.com>
In-Reply-To: <48D1122F.6080101@option.com>
Content-Type: multipart/mixed;
 boundary="------------000203020209080600010609"
X-OriginalArrivalTime: 18 Sep 2008 14:53:22.0560 (UTC) FILETIME=[4BE51000:01C9199E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000203020209080600010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Denis Joseph Barrow wrote:
> Hi Jason,
> The problem I believe is very reproducable.

It can be reproduced quite easily as it is a generic problem that
appears to have existed for quite a long time.

> I'm doing nothing special with kgdb just using it to help me with 3g
> modem driver development & my driver wasn't loaded when the problem
> occured.  I have the following command in my /boot/grub/menu.lst
> kernel parameter to enable gdb.
>
> kgdboc=/dev/ttyS0,115200 maxcpus=1


This was the key detail that was missing.  Along with the program and
other gdb details provided the source of the problem was not too hard
to track down.

When you attach to the running program with ptrace (via gdb), it
interrupts the system call and executing the high level "step" will
result in gdb executing a number of instruction step operations to try
to get back to an instruction which corresponds to the next valid line
of high level source code.

It was the 3rd or 4th instruction step that jumped back into the
kernel space because gdb ultimately tries to single step a system call
in your example.  For the kernel, single stepping a system call is a
special operation in that the system call must appear to complete
atomically and the user space ends up on the next user space assembly
instruction after the system call.  Behind the scenes the kernel
executes the system call and tracks this condition.

It appears kgdb needs to account for this condition as well, by simply
ignoring it when it occurs.

Please try the attached patch, as it will hopefully address the
problem.

Jason.

--------------000203020209080600010609
Content-Type: text/x-diff;
 name="user_space_single_step_check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="user_space_single_step_check.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subjct: [PATCH] kgdb,x86: ignore user space single stepping

On the x86 arch, user space single step exceptions should be ignored
if they occur in the kernel space, such as ptrace stepping through a
system call.

First check if it is kgdb that is executing a single step, then ensure
it is not an accidental traversal into the user space, while in kgdb,
any other time the TIF_SINGLESTEP is set, kgdb should ignore the
exception.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/x86/kernel/kgdb.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -466,9 +466,15 @@ static int __kgdb_notify(struct die_args
 
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

--------------000203020209080600010609--
