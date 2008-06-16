Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYFPIUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYFPIUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYFPIUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:20:22 -0400
Received: from lec.cs.unibo.it ([130.136.1.103]:33418 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYFPIUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:20:19 -0400
Date: Mon, 16 Jun 2008 09:58:20 +0200
To: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 0/2] ptrace_multi: speedup for virtual machines (and debuggers) running on ptrace
Message-ID: <20080616075820.GC6950@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes/implements a new tag for ptrace: PTRACE_MULTI.

The patch is against linux-2.6.26-rc6, it applies with some line offset
warnings to git2, too.

ptrace's PTRACE_MULTI tag sends multiple ptrace requests with a 
single system call. In fact, a process that uses ptrace() often needs
to send several ptrace requests in a row, for example PTRACE_PEEKDATA 
for getting/setting some useful, even small pieces of data, or several 
registers or other ptrace commands.

You can see this fact using the following commands:
	strace -o /tmp/trace strace ls
or
	strace -o /tmp/trace linux ubd0=linux.img
(where linux is a UML kernel).

Looking into /tmp/trace you'll see runs of ptrace syscalls like:
(strace example) ...
ptrace(PTRACE_PEEKUSER, 27177, 4*ORIG_EAX, [0xb]) = 0
ptrace(PTRACE_PEEKUSER, 27177, 4*EAX, [0xffffffda]) = 0
ptrace(PTRACE_PEEKUSER, 27177, 4*EBX, [0xbfe2d4b0]) = 0
ptrace(PTRACE_PEEKUSER, 27177, 4*ECX, [0xbfe2e698]) = 0
ptrace(PTRACE_PEEKUSER, 27177, 4*EDX, [0xbfe2e6a0]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2d4b0, [0x6e69622f]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2d4b4, [0x736c2f]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2e698, [0xbfe2f992]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2f990, [0x736c0065]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2f994, [0x45485300]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2e69c, [0]) = 0
ptrace(PTRACE_PEEKDATA, 27177, 0xbfe2e6a0, [0xbfe2f995]) = 0
...
(uml example)
ptrace(PTRACE_SETREGS, 27086, 0, 0x82f16bc) = 0
ptrace(PTRACE_CONT, 27086, 0, SIG_0)    = 0
...

It is useful for these programs to run several ptrace
operations while limiting the number of context switches.
For Virtual Machines limiting the number of context switches is a must,
while a speed up for debuggers is not so crucial but it helps.
Having a faster debugger should not be a problem, expecially when you've
to fix large complex programs...
For User Mode Linux the number of context switches due to ptrace should be
reduced 33% (2 ptraces each 3). 
(look at the trace above, all the sequences PTRACE_SETREGS followed by
PTRACE_CONT or PTRACE_SYSCALL or PTRACE_SYSEMU collapse in a single
PTRACE_MULTI call).

Ptrace-multi gets a "struct ptrace_multi" array parameter (together with its 
number of elements). It is a similar concept/syntax to the management of buffers
for readv or writev.
struct ptrace_multi {
	long request;
	long addr;
	void *localaddr;
	long length;
};
Each "struct ptrace_multi" specifies a single standard ptrace request. 
So you can join several requests into one request array that will
be passed through the "void* addr" parameter (the third) of ptrace().
request, addr and localaddr have the same meaning of ptrace's request, addr
and data field for a single request.
Here is an example of PTRACE_MULTI call:
	struct ptrace_multi req[] = {
		{PTRACE_SETREGS, 0, regs, 0},
		{PTRACE_SYSCALL, 0, 0, 0}};
	if (ptrace(PTRACE_MULTI,pid,req,2)) 
		/*ERROR*/

The last field in the struct (length) specifies the numbers of requests to be 
accomplished by ptrace on a sequence of words/bytes.
- PTRACE_PEEKTEXT, PTRACE_PEEKDATA, PTRACE_PEEKUSR, PTRACE_POKETEXT,
  PTRACE_POKEDATA, PTRACE_POKEUSR requests load/store chunks 
  of registers, data, text code. "length" is the number of memory words to 
  exchange.  field==0 has the same meaning as field=1.

While normal ptrace requests can get a word at a time, I have added some other
request for simplify the interface between kernel and applications that use 
ptrace(); these requests can get from user space more than one word at a time: 
- PTRACE_PEEKCHARDATA and PTRACE_POKECHARDATA is used for transferring general
  data, like structure, buffer, and so on... lenth is in bytes.
- PTRACE_PEEKSTRINGDATA get strings from user space  (using the new mm function:
  access_process_vm_user) stopping the transfer if the '\0' string termination
  occur. length is in bytes.

Debuggers and virtual machines (like User Mode Linux, or Virtual Square's 
umview) and many other applications that are based on ptrace can get 
performance improvements by PTRACE_MULTI: the number of system
calls (and context switches) decreases significantly.

This patch is architecture independent.
This patch is logically independent with ptrace_vm: applying this patch 
after ptrace_vm (and viceversa) generates just some warnings about line 
offsets.
I am submitting also a "proof of concept" patch that adds PTRACE_MULTI
support for UML clients (this must be applied after ptrace_vm, otherwise
there are some code patching rejection). I have optimized the code of UML
in three ptrace interactions. In the tests I have done UML reduces the 
overall number of syscalls by about 15% and the perfomance increases around 5%.
There are however other further optimizations that could be already applied.
This latter patch /proof of concept is not complete, I have not coded the 
ppc support yet, where PTRACE_MULTI could have a sensible impact on speedup: 
ptrace_{get,set}regs in arch/um/sys-ppc/ptrace_user.c function call tens 
of ptrace in a row.

The same feature has been implemented also for the new ptrace running on
McGrath's utrace support.  This specific patch can be found here:
http://view-os.svn.sourceforge.net/viewvc/view-os/trunk/kmview-kernel-module/kernel_patches/

		renzo
