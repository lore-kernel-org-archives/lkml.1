Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbXKUHar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbXKUHar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbXKUH30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:29:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758605AbXKUH3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:29:25 -0500
Date: Wed, 21 Nov 2007 02:28:50 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711210728.lAL7SoUM015040@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv5 0/5] sys_indirect system call
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide an alternative implementation of the
sys_indirect system call which has been discussed a few times.
This is a system call that allows us to extend existing system call
interfaces by adding more system call parameters.

Davide's previous implementation is IMO far more complex than
warranted.  This code here is trivial, as you can see.  I've
discussed this approach with Linus recently and for a brief moment
we actually agreed on something.

We pass an additional block of data to the kernel, it is copied into
the task_struct, and then it is up to the function implementing the system
call to interpret the data.  Each system call, which is meant to be
extended this way, has to be white-listed in sys_indirect.  The
alternative is to filter out those system calls which absolutely cannot
be handled using sys_indirect (like clone, execve) since they require
the stack layout of an ordinary system call.  This is more dangerous
since it is too easy to miss a call.

Note that the sys_indirect system call takes an additional parameter which
is for now forced to be zero.  This parameter is meant to enable the use
of sys_indirect to create syslets, asynchronously executed system calls.
This syslet approach is also the main reason for the interface in the form
proposed here.

The code for x86 and x86-64 gets by without a single line of assembly
code.  This is likely to be true for many other archs as well.
There is architecture-dependent code, though.

The last three patches show the first application of the functionality.
They also show a complication: we need the test for valid sub-syscalls in the
main implementation and in the compatibility code.  And more: the actual
sources and generated binary for the test are very different (the numbers
differ).  Duplicating the information is a big problem, though.  I've used
some macro tricks to avoid this.  All the information about the flags and
the system calls using them is concentrated in one header.  This should
keep maintenance bearable.

This patch to use sys_indirect is just the beginning.  More will follow,
but I want to see how these patches are received before I spend more time
on it.  This code is enough to test the implementation with the following
test program.  Adjust it for architectures other than x86 and x86-64.

What is not addressed are differences in opinion about the whole approach.
Maybe Linus can chime in a defend what is basically his design.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/syscall.h>

typedef uint32_t __u32;
typedef uint64_t __u64;

union indirect_params {
  struct {
    int flags;
  } file_flags;
};

#ifdef __x86_64__
# define __NR_indirect 286
struct indirect_registers {
  __u64 rax;
  __u64 rdi;
  __u64 rsi;
  __u64 rdx;
  __u64 r10;
  __u64 r8;
  __u64 r9;
};
#elif defined __i386__
# define __NR_indirect 325
struct indirect_registers {
  __u32 eax;
  __u32 ebx;
  __u32 ecx;
  __u32 edx;
  __u32 esi;
  __u32 edi;
  __u32 ebp;
};
#else
# error "need to define __NR_indirect and struct indirect_params"
#endif

#define FILL_IN(var, values...) \
  var = (struct indirect_registers) { values }

int
main (void)
{
  int fd = socket (AF_INET, SOCK_DGRAM, IPPROTO_IP);
  int s1 = fcntl (fd, F_GETFD);
  int t1 = fcntl (fd, F_GETFL);
  printf ("old: FD_CLOEXEC %s set, NONBLOCK %s set\n",
	  s1 == 0 ? "not" : "is", (t1 & O_NONBLOCK) ? "is" : "not");
  close (fd);

  union indirect_params i;
  memset(&i, '\0', sizeof(i));
  i.file_flags.flags = O_CLOEXEC|O_NONBLOCK;

  struct indirect_registers r;
#ifdef __NR_socketcall
# define SOCKOP_socket           1
  long args[3] = { AF_INET, SOCK_DGRAM, IPPROTO_IP };
  FILL_IN (r, __NR_socketcall, SOCKOP_socket, (long) args);
#else
  FILL_IN (r, __NR_socket, AF_INET, SOCK_DGRAM, IPPROTO_IP);
#endif

  fd = syscall (__NR_indirect, &r, &i, sizeof (i), 0);
  int s2 = fcntl (fd, F_GETFD);
  int t2 = fcntl (fd, F_GETFL);
  printf ("new: FD_CLOEXEC %s set, NONBLOCK %s set\n",
	  s2 == 0 ? "not" : "is", (t2 & O_NONBLOCK) ? "is" : "not");
  close (fd);

  i.file_flags.flags = O_CLOEXEC;
  sigset_t ss;
  sigemptyset(&ss);
  FILL_IN(r, __NR_signalfd, -1, (long) &ss, 8);
  fd = syscall (__NR_indirect, &r, &i, sizeof (i), 0);
  int s3 = fcntl (fd, F_GETFD);
  printf ("signalfd: FD_CLOEXEC %s set\n", s3 == 0 ? "not" : "is");
  close (fd);

  FILL_IN(r, __NR_eventfd, 8);
  fd = syscall (__NR_indirect, &r, &i, sizeof (i), 0);
  int s4 = fcntl (fd, F_GETFD);
  printf ("eventfd: FD_CLOEXEC %s set\n", s4 == 0 ? "not" : "is");
  close (fd);

  return s1 != 0 || s2 == 0 || t1 != 0 || t2 == 0 || s3 == 0 || s4 == 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>


 arch/x86/Kconfig                   |    3 ++
 arch/x86/ia32/Makefile             |    1 
 arch/x86/ia32/ia32entry.S          |    2 +
 arch/x86/ia32/sys_ia32.c           |   38 +++++++++++++++++++++++++++++
 arch/x86/kernel/syscall_table_32.S |    1 
 fs/anon_inodes.c                   |   15 ++++++++---
 fs/eventfd.c                       |    5 ++-
 fs/signalfd.c                      |    6 +++-
 fs/timerfd.c                       |    6 +++-
 include/asm-x86/ia32_unistd.h      |    4 +++
 include/asm-x86/indirect.h         |    5 +++
 include/asm-x86/indirect_32.h      |   25 +++++++++++++++++++
 include/asm-x86/indirect_64.h      |   36 ++++++++++++++++++++++++++++
 include/asm-x86/unistd_32.h        |    3 +-
 include/asm-x86/unistd_64.h        |    2 +
 include/linux/anon_inodes.h        |    3 ++
 include/linux/indirect.h           |   47 +++++++++++++++++++++++++++++++++++++
 include/linux/sched.h              |    4 +++
 include/linux/syscalls.h           |    4 +++
 kernel/Makefile                    |    3 ++
 kernel/indirect.c                  |   40 +++++++++++++++++++++++++++++++
 net/socket.c                       |   36 +++++++++++++++++-----------
 22 files changed, 264 insertions(+), 25 deletions(-)
