Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXDYOVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXDYOVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXDYOV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:21:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:6435 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXDYOV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BJNri/IYZHCJWPsvid6D+3dH+8/edUD6TQV38CF/gDNFtCRvtEY/F50E4S7lpSWJLo88xLwONMcvmNaCc4Ke2+feG9G6Msgb0J5Ak+NApcrJYq1cHmbOvYla0y//+/4ODIgNKuVJGKmVLV+9xbCQbadrp72iHAhxL5kqcj5Tq2E=
Message-ID: <f9eabcda0704250721k20ba8a6bl50b8b0494caf5531@mail.gmail.com>
Date: Wed, 25 Apr 2007 11:21:27 -0300
From: "Miguel Freitas" <mfreitas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Advice on debuging the fork syscall hanging forever
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

making a long story short: i'm trying to debug a problem with the fork
syscall as called from glibc's popen() function. it seems that a given
process (in case Xorg) get stuck inside a syscall that never returns.
while stuck it keeps using 100% of cpu.

I can confirm the problem with kernel 2.6.18.8 / x86_64 / SMP (my
system) but i can't yet tell who is to blame here (Xorg, glibc or the
kernel itself?). it has also been reported with kernel 2.6.17 and
IA32.

the full bug report for Xorg is available at:

https://bugs.freedesktop.org/show_bug.cgi?id=10525

below i will quote only the relevant gdb session (comment #16) so
kernel hackers should be able to immediately spot something obvious
that i must be missing...

# gdb Xorg <pid>
(...)
Program received signal SIGINT, Interrupt.
0x00002b2e77d6d5bd in fork () from /lib64/libc.so.6

(gdb) disass
Dump of assembler code for function fork:
0x00002b2e77d6d530 <fork+0>:    push   %rbp
0x00002b2e77d6d531 <fork+1>:    mov    %rsp,%rbp
0x00002b2e77d6d534 <fork+4>:    push   %r14
0x00002b2e77d6d536 <fork+6>:    push   %r13
0x00002b2e77d6d538 <fork+8>:    push   %r12
0x00002b2e77d6d53a <fork+10>:   push   %rbx
0x00002b2e77d6d53b <fork+11>:   sub    $0x30,%rsp
0x00002b2e77d6d53f <fork+15>:   mov    2807650(%rip),%rcx        #
0x2b2e7801aca8 <__fork_handlers>
0x00002b2e77d6d546 <fork+22>:   test   %rcx,%rcx
0x00002b2e77d6d549 <fork+25>:   mov    %rcx,%rbx
0x00002b2e77d6d54c <fork+28>:   je     0x2b2e77d6d576 <fork+70>
0x00002b2e77d6d54e <fork+30>:   mov    0x28(%rcx),%edx
0x00002b2e77d6d551 <fork+33>:   test   %edx,%edx
0x00002b2e77d6d553 <fork+35>:   je     0x2b2e77d6d546 <fork+22>
0x00002b2e77d6d555 <fork+37>:   lea    0x1(%rdx),%esi
0x00002b2e77d6d558 <fork+40>:   mov    %edx,%eax
0x00002b2e77d6d55a <fork+42>:   lock cmpxchg %esi,0x28(%rcx)
0x00002b2e77d6d55f <fork+47>:   cmp    %eax,%edx
0x00002b2e77d6d561 <fork+49>:   je     0x2b2e77d6d7c2 <fork+658>
0x00002b2e77d6d567 <fork+55>:   mov    2807610(%rip),%rcx        #
0x2b2e7801aca8 <__fork_handlers>
0x00002b2e77d6d56e <fork+62>:   test   %rcx,%rcx
0x00002b2e77d6d571 <fork+65>:   mov    %rcx,%rbx
0x00002b2e77d6d574 <fork+68>:   jne    0x2b2e77d6d54e <fork+30>
0x00002b2e77d6d576 <fork+70>:   xor    %r12d,%r12d
0x00002b2e77d6d579 <fork+73>:   callq  0x2b2e77d44e30 <__GI__IO_list_lock>
0x00002b2e77d6d57e <fork+78>:   mov    %fs:0x90,%r9d
0x00002b2e77d6d587 <fork+87>:   mov    %fs:0x94,%r8d
0x00002b2e77d6d590 <fork+96>:   mov    %r8d,%eax
0x00002b2e77d6d593 <fork+99>:   neg    %eax
0x00002b2e77d6d595 <fork+101>:  mov    %eax,%fs:0x94
0x00002b2e77d6d59d <fork+109>:  mov    %fs:0x10,%r10
0x00002b2e77d6d5a6 <fork+118>:  xor    %edx,%edx
0x00002b2e77d6d5a8 <fork+120>:  add    $0x90,%r10
0x00002b2e77d6d5af <fork+127>:  xor    %esi,%esi
0x00002b2e77d6d5b1 <fork+129>:  mov    $0x1200011,%edi
0x00002b2e77d6d5b6 <fork+134>:  mov    $0x38,%eax
0x00002b2e77d6d5bb <fork+139>:  syscall
0x00002b2e77d6d5bd <fork+141>:  cmp    $0xfffffffffffff000,%rax
0x00002b2e77d6d5c3 <fork+147>:  ja     0x2b2e77d6d720 <fork+496>
0x00002b2e77d6d5c9 <fork+153>:  test   %eax,%eax
0x00002b2e77d6d5cb <fork+155>:  mov    %eax,%r14d

note the PC is pointing to <fork+141>, so i'm assuming it must be hanging
inside the kernel (syscall).

i believe the relevant code from glibc is the following:

pid_t
__libc_fork (void)
{
  (... stripped ...)
  _IO_list_lock (); <- note __GI__IO_list_lock in disass above!

#ifndef NDEBUG
  pid_t ppid = THREAD_GETMEM (THREAD_SELF, tid);
#endif

  /* We need to prevent the getpid() code to update the PID field so
     that, if a signal arrives in the child very early and the signal
     handler uses getpid(), the value returned is correct.  */
  pid_t parentpid = THREAD_GETMEM (THREAD_SELF, pid);
  THREAD_SETMEM (THREAD_SELF, pid, -parentpid);

#ifdef ARCH_FORK
  pid = ARCH_FORK ();
#else
# error "ARCH_FORK must be defined so that the CLONE_SETTID flag is used"
  pid = INLINE_SYSCALL (fork, 0);
#endif

---

i think the syscall in disass above must be either ARCH_FORK or INLINE_SYSCALL.

using x86_64's unistd.h and converting eax 0x38 => 56 => __NR_clone. this is
funny because __NR_fork is 57 which is what i would expect. i386's unistd.h
yields even stranger syscall: __NR_mpx.

still, this is not the value currently loaded on rax:
(gdb) info reg
rax            0xfffffffffffffdff       -513
rbx            0x0      0
rcx            0xffffffffffffffff       -1
rdx            0x0      0
rsi            0x0      0
rdi            0x1200011        18874385
(...)

now the great trick:

(gdb) set $rax = 0x38
(gdb) quit
The program is running.  Quit anyway (and detach it)? (y or n) y

-> done. xorg is good again.

do anybody have any idea on what is going on here?

please CC me if you have any comments...

thanks,

Miguel
