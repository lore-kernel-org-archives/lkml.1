Return-Path: <linux-kernel-owner+w=401wt.eu-S1765594AbXKOQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765594AbXKOQmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbXKOQlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:41:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758921AbXKOQla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:41:30 -0500
Date: Thu, 15 Nov 2007 11:41:22 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151641.lAFGfM8R024330@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] sys_indirect system call
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
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

We pass an additional block of data to the kernel, it is copied into
the task_struct, and then it is up to the function implementing the system
call to interpret the data.  No attempt is made to catch invalid calls.
This is really the same issue as with invalid system call parameters.
The proposed code only rejects:

- recursive calls to sys_indirect
- too large additional blocks

It is debatable whether we should check whether the indirectly called
system call actually needs or supports additional parameters.  This would
require a new table for each architecture or a switch statement in
sys_indirect.  Linus expressed concerns about cache pollution and I don't
see how making the indirect call without a test can cause problems so
I decided against such checks.

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

 arch/um/Makefile                   |    2 +-
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/asm-um/indirect-i386.h     |    6 ++++++
 include/asm-um/indirect-x86_64.h   |   10 ++++++++++
 include/asm-x86/indirect.h         |    5 +++++
 include/asm-x86/indirect_32.h      |   27 +++++++++++++++++++++++++++
 include/asm-x86/indirect_64.h      |   30 ++++++++++++++++++++++++++++++
 include/asm-x86/unistd_32.h        |    3 ++-
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/indirect.h           |   13 +++++++++++++
 include/linux/sched.h              |    4 ++++
 include/linux/syscalls.h           |    3 +++
 kernel/Makefile                    |    2 +-
 kernel/indirect.c                  |   25 +++++++++++++++++++++++++
 net/socket.c                       |   21 +++++++++++++--------
 16 files changed, 144 insertions(+), 11 deletions(-)
