Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040Ab0A0VXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0A0VXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025Ab0A0VXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:23:06 -0500
Received: from ngc224.gerwinski.de ([213.133.98.203]:41565 "EHLO
	ngc224.gerwinski.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0A0VXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:23:01 -0500
X-Greylist: delayed 2080 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 16:23:01 EST
Date: Wed, 27 Jan 2010 21:48:18 +0100
Message-ID: <1264625298.4591.700948@ngc224.gerwinski.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=us-ascii
Subject: CLONE_VM: parent terminates silently when
	child segfaults
To: linux-kernel@vger.kernel.org
From: Frank Heckenbach <f.heckenbach@fh-soft.de>
User-Agent: semail 20060101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a process cloned with CLONE_VM is killed by SIGSEGV, the parent
process is terminated silently. I don't know if this is known or
intended behaviour, but I didn't find anything about it.

The test program below demonstrates the problem. It forks a process
which in turn clones another process which kills itself with
SIGSEGV.

When I remove the CLONE_VM flag, the program runs as expected:

  fork_pid = ...
  clone_pid = ...
  (1 second delay)
  cloned process status = 11
  forked process status = 0

However, with CLONE_VM I get:

  fork_pid = ...
  clone_pid = ...
  (1 second delay)
  forked process status = 0

i.e., no output from the first forked process after its waitpid(),
and no error indication in its status as seen by the main process.

Note: The fork() before clone() is not essential to cause this
behaviour, just to see its effects (in the 2nd waitpid()). You can
see the same by calling the program without fork from the shell and
looking at $?. I just put in fork to make sure it's not a shell
problem or something.

The problem only occurs with signals such as SIGSEGV or SIGILL, not
with SIGINT, SIGUSR1, etc. Since CLONE_VM and SIGSEGV both have to
do with the shared memory space, I'd understand if the parent
process was also killed by SIGSEGV or so. But having it return with
status 0 seems strange -- how is one supposed to detect a SIGSEGV in
the child? The parent can't do it when it's terminated, and the
parent's parent only sees it terminate with 0.

BTW, maybe not relevant, but if I run the program (with CLONE_VM)
under "strace -f", I see the following message which might indicate
that also strace thinks something's wrong here:

  PANIC: attached pid <fork_pid> exited

System information:

Linux odh 2.6.25-2-686 #1 SMP Sat Jun 28 13:44:14 UTC 2008 i686 GNU/Linux
glibc 2.3.6.ds1-13
gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
strace -- version 4.5.14

(i.e., Debian etch, with updated kernel from etch-backports)

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sched.h>
#include <wait.h>

int foo (void *dummy)
{
  sleep (1);
  kill (getpid (), SIGSEGV);
  while (1)
    pause ();
}

int main ()
{
  int fork_pid = fork ();
  if (fork_pid == 0)
    {
      static char stack[0x4000];
      int clone_pid = clone (foo, stack + 0x2000, SIGCHLD | CLONE_VM, NULL);
      printf ("clone_pid = %i\n", clone_pid);
      int s;
      waitpid (clone_pid, &s, 0);
      printf ("cloned process status = %i\n", s);
    }
  else if (fork_pid > 0)
    {
      printf ("fork_pid = %i\n", fork_pid);
      int s;
      waitpid (fork_pid, &s, 0);
      printf ("forked process status = %i\n", s);
    }
  return 0;
}
