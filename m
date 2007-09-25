Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbXIYRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbXIYRxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXIYRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:53:40 -0400
Received: from [198.99.130.12] ([198.99.130.12]:54051 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXIYRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:53:39 -0400
Date: Tue, 25 Sep 2007 13:53:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: lepton <ytht.net@gmail.com>
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] 2.6.22.6 user-mode linux: before abort, we make it sure all children quit
Message-ID: <20070925175327.GA9088@c2.user-mode-linux.org>
References: <20070922080124.GA7431@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922080124.GA7431@router.lepton.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 04:01:24PM +0800, lepton wrote:
>   In a stock 2.6.22.6 kernel, poweroff a user mode linux guest
> (2.6.22.6 running in skas0 mode) will halt the host linux. I
> think the reason is the kernel thread abort because of a bug.
> Then the sys_reboot in process of user mode linux guest is
> not trapped by the user mode linux kernel and is executed by host.
>   I think it is better to make sure all of our children process
> to quit when user mode linux kernel abort.

Below is what I currently have for this patch.  As you sent it in, the
kill(0, SIGTERM) would immediately kill the kernel process along with
everything else, before it can dump core.  So, I have the kernel
ignore SIGTERM.

Then, there are still processes which survive.  The one case I think I
understand is that a process is handling an infinite sequence of
SIGSEGVs and never sees the SIGTERM.  So, I added a loop which waits
for all of the current child processes and kills each one as it
returns some sort of status.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

From: Lepton Wu <ytht.net@gmail.com>

  In a stock 2.6.22.6 kernel, poweroff a user mode linux guest
(2.6.22.6 running in skas0 mode) will halt the host linux. I
think the reason is the kernel thread abort because of a bug.
Then the sys_reboot in process of user mode linux guest is
not trapped by the user mode linux kernel and is executed by host.
  I think it is better to make sure all of our children process
to quit when user mode linux kernel abort.

[ jdike - the kernel process needs to ignore SIGTERM, plus the
  waitpid/kill loop is needed to make sure that all of our children
  are dead before the kernel exits ]

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/skas/process.c |    2 +-
 arch/um/os-Linux/util.c         |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/util.c	2007-09-25 13:33:48.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/util.c	2007-09-25 13:45:33.000000000 -0400
@@ -105,6 +105,44 @@ int setjmp_wrapper(void (*proc)(void *, 
 
 void os_dump_core(void)
 {
+	int pid;
+
 	signal(SIGSEGV, SIG_DFL);
+
+	/*
+	 * We are about to SIGTERM this entire process group to ensure that
+	 * nothing is around to run after the kernel exits.  The
+	 * kernel wants to abort, not die through SIGTERM, so we
+	 * ignore it here.
+	 */
+
+	signal(SIGTERM, SIG_IGN);
+	kill(0, SIGTERM);
+	/*
+	 * Most of the other processes associated with this UML are
+	 * likely sTopped, so give them a SIGCONT so they see the
+	 * SIGTERM.
+	 */
+	kill(0, SIGCONT);
+
+	/*
+	 * Now having sent signals to everyone but us, make sure they
+	 * die by ptrace.  Processes can survive what's been done to
+	 * them so far - the mechanism I understand is receiving a
+	 * SIGSEGV and segfaulting immediately upon return.  There is
+	 * always a SIGSEGV pending, and (I'm guessing) signals are
+	 * processed in numeric order so the SIGTERM (signal 15 vs
+	 * SIGSEGV being signal 11) is never handled.
+	 *
+	 * Run a waitpid loop until we get some kind of error.
+	 * Hopefully, it's ECHILD, but there's not a lot we can do if
+	 * it's something else.  Tell os_kill_ptraced_process not to
+	 * wait for the child to report its death because there's
+	 * nothing reasonable to do if that fails.
+	 */
+
+	while ((pid = waitpid(-1, NULL, WNOHANG)) > 0)
+		os_kill_ptraced_process(pid, 0);
+
 	abort();
 }
Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2007-09-25 13:34:17.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2007-09-25 13:45:43.000000000 -0400
@@ -177,7 +177,7 @@ static int userspace_tramp(void *stack)
 
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
-	init_new_thread_signals();
+	signal(SIGTERM, SIG_DFL);
 	err = set_interval();
 	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
