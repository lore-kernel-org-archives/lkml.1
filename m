Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbYLKTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbYLKTqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbYLKTTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:35 -0500
Received: from kroah.org ([198.145.64.141]:56834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757409AbYLKTTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:34 -0500
Date: Thu, 11 Dec 2008 11:16:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ulrich Weigand <ulrich.weigand@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch 79/83] tracehook: exec double-reporting fix
Message-ID: <20081211191646.GA5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tracehook-exec-double-reporting-fix.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit 85f334666a771680472722eee43ae0fc8730a619 upstream.

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
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1164,6 +1164,7 @@ EXPORT_SYMBOL(remove_arg_zero);
  */
 int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
+	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
 #ifdef __alpha__
@@ -1224,8 +1225,15 @@ int search_binary_handler(struct linux_b
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

