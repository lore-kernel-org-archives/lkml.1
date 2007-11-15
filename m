Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXKOSXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXKOSXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765678AbXKOSW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:22:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765666AbXKOSW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:22:57 -0500
Date: Thu, 15 Nov 2007 13:22:31 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151822.lAFIMVJn028584@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/4] sys_indirect system call
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide an alternative implementation of the
sys_indirect system call which has been discussed a few times.
This no system call allows us to extend existing system call
interfaces with adding more system calls.

Davide's previous implementation is IMO far more complex than
warranted.  This code here is trivial, as you can see.  I've
discussed this approach with Linus last week and for a brief moment
we actually agreed on something.

*=*=* CHANGED
We pass an additional block of data to the kernel, it is copied into
the task_struct, and then it is up to the function implementing the system
call to interpret the data.  Each system call, which is meant to be
extended this way, has to be white-listed in sys_indirect.  The
alternative is to filter out those system calls which absolutely cannot
be handled using sys_indirect (like clone, execve) since they require
the stack layout of an ordinary system call.  This is more dangerous
since it is too easy to miss a call.
*=*=* END CHANGED

The code for x86 and x86-64 gets by without a single line of assembly
code.  This is likely to be true for most/all the other archs as well.
There is architecture-dependent code, though.  For x86 and x86-64 I've
also fixed up UML (although only x86-64 is tested, that's my setup).

The last patch shows the first application of the functionality.  It is by
far not complete, more will follow, but I want to see how these patches are
received before I spend more time on it.  This code is enough to test the
implementation with the following test program.  Adjust it for architectures
other than x86 and x86-64.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
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
  printf ("old: FD_CLOEXEC %s set\n", s1 == 0 ? "not" : "is");
  close (fd);

  union indirect_params i;
  i.file_flags.flags = O_CLOEXEC;

  struct indirect_registers r;
  FILL_IN (r, __NR_socket, AF_INET, SOCK_DGRAM, IPPROTO_IP);

  fd = syscall (__NR_indirect, &r, &i, sizeof (i));
  int s2 = fcntl (fd, F_GETFD);
  printf ("new: FD_CLOEXEC %s set\n", s2 == 0 ? "not" : "is");
  close (fd);

  return s1 != 0 || s2 == 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

 arch/x86/ia32/ia32entry.S          |    1 
 arch/x86/kernel/syscall_table_32.S |    1 
 include/asm-um/indirect.h          |    6 ++++
 include/asm-x86/indirect.h         |    5 ++++
 include/asm-x86/indirect_32.h      |   23 ++++++++++++++++++
 include/asm-x86/indirect_64.h      |   24 +++++++++++++++++++
 include/asm-x86/unistd_32.h        |    3 +-
 include/asm-x86/unistd_64.h        |    2 +
 include/linux/indirect.h           |   13 ++++++++++
 include/linux/sched.h              |    4 +++
 include/linux/syscalls.h           |    3 ++
 kernel/Makefile                    |    2 -
 kernel/indirect.c                  |   46 +++++++++++++++++++++++++++++++++++++
 net/socket.c                       |   21 ++++++++++------
 14 files changed, 144 insertions(+), 10 deletions(-)
