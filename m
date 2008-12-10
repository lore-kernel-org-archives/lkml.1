Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYLJVbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYLJVbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbYLJVav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:30:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbYLJVat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:30:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       "Ulrich Weigand <ulrich.weigand@de.ibm.com>Oleg Nesterov" 
	<oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Subject: [PATCH] tracehook: exec double-reporting fix
In-Reply-To: Arnd Bergmann's message of  Tuesday, 9 December 2008 15:33:09 +0100 <200812091533.10628.arnd@arndb.de>
References: <200812091533.10628.arnd@arndb.de>
X-Zippy-Says: HELLO, everybody, I'm a HUMAN!!
Message-Id: <20081210040423.5EE72FC362@magilla.sf.frob.com>
Date: Tue,  9 Dec 2008 20:04:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 437f2f91d6597c67662f847d9ed4c99cb3c440cd:
  Linus Torvalds (1):
        Merge master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git to-linus

Roland McGrath (1):
      tracehook: exec double-reporting fix

 fs/exec.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)


Thanks,
Roland
---
[PATCH] tracehook: exec double-reporting fix

The patch 6341c39 "tracehook: exec" introduced a small regression in
2.6.27 regarding binfmt_misc exec event reporting.  Since the reporting
is now done in the common search_binary_handler() function, an exec
of a misc binary will result in two (or possibly multiple) exec events
being reported, instead of just a single one, because the misc handler
contains a recursive call to search_binary_handler.

To add to the confusion, if PTRACE_O_TRACEEXEC is not active, the multiple
SIGTRAP signals will in fact cause only a single ptrace intercept, as the
signals are not queued.  However, if PTRACE_O_TRACEEXEC is on, the debugger
will actually see multiple ptrace intercepts (PTRACE_EVENT_EXEC).

The test program included below demonstrates the problem.

This change fixes the bug by calling tracehook_report_exec() only in the
outermost search_binary_handler() call (bprm->recursion_depth == 0).

The additional change to restore bprm->recursion_depth after each binfmt
load_binary call is actually superfluous for this bug, since we test the
value saved on entry to search_binary_handler().  But it keeps the use of
of the depth count to its most obvious expected meaning.  Depending on what
binfmt handlers do in certain cases, there could have been false-positive
tests for recursion limits before this change.

    /* Test program using PTRACE_O_TRACEEXEC.
       This forks and exec's the first argument with the rest of the arguments,
       while ptrace'ing.  It expects to see one PTRACE_EVENT_EXEC stop and
       then a successful exit, with no other signals or events in between.

       Test for kernel doing two PTRACE_EVENT_EXEC stops for a binfmt_misc exec:

       $ gcc -g traceexec.c -o traceexec
       $ sudo sh -c 'echo :test:M::foobar::/bin/cat: > /proc/sys/fs/binfmt_misc/register'
       $ echo 'foobar test' > ./foobar
       $ chmod +x ./foobar
       $ ./traceexec ./foobar; echo $?
       ==> good <==
       foobar test
       0
       $
       ==> bad <==
       foobar test
       unexpected status 0x4057f != 0
       3
       $

    */

    #include <stdio.h>
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <sys/ptrace.h>
    #include <unistd.h>
    #include <signal.h>
    #include <stdlib.h>

    static void
    wait_for (pid_t child, int expect)
    {
      int status;
      pid_t p = wait (&status);
      if (p != child)
	{
	  perror ("wait");
	  exit (2);
	}
      if (status != expect)
	{
	  fprintf (stderr, "unexpected status %#x != %#x\n", status, expect);
	  exit (3);
	}
    }

    int
    main (int argc, char **argv)
    {
      pid_t child = fork ();

      if (child < 0)
	{
	  perror ("fork");
	  return 127;
	}
      else if (child == 0)
	{
	  ptrace (PTRACE_TRACEME);
	  raise (SIGUSR1);
	  execv (argv[1], &argv[1]);
	  perror ("execve");
	  _exit (127);
	}

      wait_for (child, W_STOPCODE (SIGUSR1));

      if (ptrace (PTRACE_SETOPTIONS, child,
		  0L, (void *) (long) PTRACE_O_TRACEEXEC) != 0)
	{
	  perror ("PTRACE_SETOPTIONS");
	  return 4;
	}

      if (ptrace (PTRACE_CONT, child, 0L, 0L) != 0)
	{
	  perror ("PTRACE_CONT");
	  return 5;
	}

      wait_for (child, W_STOPCODE (SIGTRAP | (PTRACE_EVENT_EXEC << 8)));

      if (ptrace (PTRACE_CONT, child, 0L, 0L) != 0)
	{
	  perror ("PTRACE_CONT");
	  return 6;
	}

      wait_for (child, W_EXITCODE (0, 0));

      return 0;
    }

Reported-by: Arnd Bergmann <arnd@arndb.de>
CC: Ulrich Weigand <ulrich.weigand@de.ibm.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4e834f1..ec5df9a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1159,6 +1159,7 @@ EXPORT_SYMBOL(remove_arg_zero);
  */
 int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
+	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
 #ifdef __alpha__
@@ -1219,8 +1220,15 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 				continue;
 			read_unlock(&binfmt_lock);
 			retval = fn(bprm, regs);
+			/*
+			 * Restore the depth counter to its starting value
+			 * in this call, so we don't have to rely on every
+			 * load_binary function to restore it on return.
+			 */
+			bprm->recursion_depth = depth;
 			if (retval >= 0) {
-				tracehook_report_exec(fmt, bprm, regs);
+				if (depth == 0)
+					tracehook_report_exec(fmt, bprm, regs);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
