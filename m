Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZCJVoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZCJVoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZCJVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:44:44 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:52109 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZCJVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:44:43 -0400
Date: Tue, 10 Mar 2009 22:44:36 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090310214436.GC5213@cs.unibo.it>
References: <20090204080236.GA17452@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204080236.GA17452@cs.unibo.it>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong,

I have updated the PTRACE_VM patches.
The patches have been rebased to linux-2.6.29-rc7 but apply to linux-2.6.29-rc7-git3.

The set is composed by two patches.
The first one is for all those architectures where PTRACE_SYSCALL is
managed via tracehook (x86, powerpc etc).
Given the wonderful work by Roland McGrath this patch is now
architecture independent and straightforward simple.

The second one is the support of PTRACE_VM for user-mode-linux.
It provides PTRACE_VM for UML processes and uses PTRACE_VM of the hosting 
kernel.


The description and motivation follows.
-----
Proposal: let us simplify
PTRACE_SYSCALL/PTRACE_SINGLESTEP/PTRACE_SYSEMU/PTRACE_SYSEMU_SINGLESTEP,
and now PTRACE_BLOCKSTEP (which will require soon a PTRACE_SYSEMU_BLOCKSTEP),
my PTRACE_SYSVM...etc. etc.

Summary of the solution:
Use tags in the "addr" parameter of existing
PTRACE_SYSCALL/PTRACE_SINGLESTEP/PTRACE_CONT/PTRACE_BLOCKSTEP calls
to skip the current call (PTRACE_VM_SKIPCALL) or skip the second upcall to 
the VM/debugger after the syscall execution (PTRACE_VM_SKIPEXIT).

Motivation:

The ptrace tag PTRACE_SYSEMU is a feature mainly used for User-Mode Linux,
or at most for other virtual machines aiming to virtualize *all* the syscalls
(total virtual machines).

In fact:
ptrace(PTRACE_SYSEMU, pid, 0, 0)
means that the *next* system call will not be executed.
PTRACE_SYSEMU AFAIK has been implemented only for x86_32.

I already proposed some time ago a different tag: PTRACE_SYSVM 
(and I maintain a patch for it) where:
ptrace(PTRACE_SYSVM, pid, XXX, 0)
1* is the same as PTRACE_SYSCALL when XXX==0,
2* skips the call (and stops before entering the next syscall) when
  PTRACE_VM_SKIPCALL | PTRACE_VM_SKIPEXIT
3* skips the ptrace call after the system call if PTRACE_VM_SKIPEXIT.
  PTRACE_SYSVM has been implemented for x86_32, powerpc_32, um+x86_32.
(x86_64 and ppc64 exist too, but are less tested).

The main difference between SYSEMU and SYSVM is that with SYSVM it is possible
to decide if *this* system call should be executed or not (instead of the next
one).
SYSVM can be used also for partial virtual machines (some syscall gets
virtualized and some others do not), like our umview.

PTRACE_SYSVM above can be used instead of PTRACE_SYSEMU in user-mode linux
and in all the others total virtual machines. In fact, provided user-mode linux
skips *all* the syscalls it does not matter if the upcall happens just after
(SYSEMU) or just before (SYSVM) having skipped the syscall.

Briefly I would like to unify SYSCALL, SYSEMU and SYSVM.
We don't need three different tags (and all their "variations", 
SINGLESTEP->SYSEMU_SINGLESTEP etc).

We could keep PTRACE_SYSCALL, using the addr parameter as in PTRACE_SYSVM.
In this case all the code I have seen (user-mode linux, strace, umview
and googling around) use 0 or 1 for addr (being defined unused).
defining PTRACE_VM_SKIPCALL=4 and PTRACE_VM_SKIPEXIT=2 (i.e. by ignoring
the lsb) everything previously coded using PTRACE_SYSCALL should continue 
to work.
In the same way PTRACE_SINGLESTEP, PTRACE_CONT and PTRACE_BLOCKSTEP can use 
the same tags restarting after a SYSCALL.

This change would eventually simplify both the kernel code
(reducing tags and exceptions) and even user-mode linux and umview.

The skip-exit feature can be implemented in a arch-independent
manner, while for skip_call some simple changes are needed
(the entry assembly code should process the return value of the syscall
tracing function call, like in arch/x86/kernel/Entry_32.S).

Motivation summary:
1) (eventually) Reduce the number of PTRACE tags. The proposed patch
does not add any tag. On the contrary after a period of deprecation
SYSEMU* tags can be eliminated.
2) Backward compatible with existing software (existing UML kernels,
strace already tested). Only software using strange "addr" values
(the addr parameter is currently ignored) could have portability problems.
3) (eventually) simplify kernel code. SYSEMU support is a bit messy and
x86/32 only. These new PTRACE_VM tags for the addr parameter will allow to
get rid of SYSEMU code.
4) It is simple to be ported across the architecture.
It is directly supported by the tracehook mechanism.
5) It is more powerful than PTRACE_SYSEMU. It provides an optimized support for
partial virtualization (some syscalls gets virtualized some other do
not) while keeping support for total virtualization a' la UML.
6) Software currently using PTRACE_SYSEMU can be easily ported to this
new support. The porting for UML (client side) is already in the patch.
All the calls like:
ptrace(PTRACE_SYSEMU, pid, 0, 0)
can be converted into
ptrace(PTRACE_SYSCALL, pid, PTRACE_VM_SKIPCALL, 0)
(but the first PTRACE_SYSCALL, the one which starts up the emulation.
In practice it is possible to set PTRACE_VM_SKIPCALL for the first call,
too. The "addr" tag is ignored being no syscalls pending).

		renzo
