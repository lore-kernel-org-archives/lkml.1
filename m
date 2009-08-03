Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZHCEj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZHCEj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 00:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZHCEj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 00:39:26 -0400
Received: from nexus.x256.com ([8.10.77.184]:60011 "EHLO nexus.x256.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbZHCEjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 00:39:25 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 00:39:25 EDT
Message-ID: <4A766864.40703@x256.org>
Date: Mon, 03 Aug 2009 14:32:36 +1000
From: Nicholas Vinen <hb@x256.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090712)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possible kernel bug with SYS_clone / CLONE_PARENT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a program where process A forks process B and process B forks
process C. I want process A to be notified if/when process C terminates.
(Process B terminates almost immediately after forking process C and a
number of other siblings.)

According to the manual page for clone() I should be able to do this
with CLONE_PARENT:

-----------------
    CLONE_PARENT (since Linux 2.3.12)
    If CLONE_PARENT is set, then the parent of the new child (as
returned by getppid(2)) will be the same as that of the calling process.
    If CLONE_PARENT is not set, then (as with fork(2)) the child's
parent is the calling process.
    Note that it is the parent process, as returned by getppid(2), which
is signaled when the child terminates, so that if CLONE_PARENT is set,
then the parent of the calling process, rather than the calling process
itself, will be signaled.
-----------------


I am using kernel 2.6.29-gentoo-r5 (not the most recent, I know, but
relatively new), glibc 2.9_p20081201-r2 and gcc 4.3.2-r3. Here is my
test program:

-----------------
#include <asm/unistd.h>
#include <sys/syscall.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int fork_but_keep_ppid() {
  return syscall(SYS_clone, CLONE_PARENT, (void*)0);
}

void sigchld_handler(int signum, siginfo_t* info, void* ucontext) {
  fprintf(stderr, "SIGCHLD (PID=%d)\n", info->si_pid);
}

int main(void) {
  struct sigaction act;
  memset(&act, 0, sizeof(act));
  act.sa_sigaction = sigchld_handler;
  act.sa_flags = SA_NOCLDSTOP|SA_NOCLDWAIT|SA_SIGINFO;
  sigaction(SIGCHLD, &act, 0);

  fprintf(stderr, "Main PID = %d\n", syscall(SYS_getpid));

  pid_t a = fork();
  if( a == 0 ) {
    fprintf(stderr, "first fork PID = %d, PPID = %d\n",
syscall(SYS_getpid), syscall(SYS_getppid));
    pid_t b = fork_but_keep_ppid();
    if( b == 0 ) {
      fprintf(stderr, "second fork PID = %d, PPID = %d\n",
syscall(SYS_getpid), syscall(SYS_getppid));
      exit(-2);
    } else {
      fprintf(stderr, "second fork returned %d\n", b);
    }
    exit(-1);
  } else {
    fprintf(stderr, "first fork returned %d\n", a);
  }
  sleep(1);
  fprintf(stderr, "Creating & terminating another child to check
SIGCHILD still works...\n");
  pid_t c = fork();
  if( c == 0 ) {
    fprintf(stderr, "Child's PID is %d\n", syscall(SYS_getpid));
    exit(-3);
  }
  sleep(1);

  return 0;
}
-----------------

Note that I am making the syscall directly because I want fork-like
semantics and these are not provided by the clone() call. I also don't
want to have to provide a separate stack for the child and it seems that
(at least according to the man page) for clone() you have to, even if
you don't use CLONE_VM.

The output from this program is:

-----------------
Main PID = 13125
first fork returned 13126
first fork PID = 13126, PPID = 13125
second fork PID = 13127, PPID = 13125
second fork returned 13127
SIGCHLD (PID=13126)
Creating & terminating another child to check SIGCHILD still works...
Child's PID is 13128
SIGCHLD (PID=13128)
-----------------


There should be a SIGCHLD for the second fork's child PID but there
isn't. ps shows the process is a zombie with PPID=13125 (in this case)
while the test program is still running, yet the "parent" does not seem
to receive the SIGCHLD.

I could be doing something wrong but I can't see what it might be. Any
suggestions? Please CC me on any reply as I am not currently subscribed
to LKML.



Thanks,

Nicholas.


