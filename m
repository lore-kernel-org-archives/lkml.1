Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZDDKR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZDDKR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 06:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZDDKRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 06:17:16 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:38537 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZDDKRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 06:17:14 -0400
Date: Sat, 4 Apr 2009 12:17:09 +0200
From: Renzo Davoli <renzo@cs.unibo.it>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090404101708.GG4203@cs.unibo.it>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it> <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it> <20090329163228.GE7671@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090329163228.GE7671@hack>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Cong,

On Mon, Mar 30, 2009 at 12:32:28AM +0800, Américo Wang wrote:
> On Wed, Mar 25, 2009 at 12:47:53AM +0100, Renzo Davoli wrote:
> >1- the code is now extremely simple 
> Why adding a new request for ptrace is harder? I don't think so. :)
> >2- if we define a different tag for syscall (e.g. PTRACE_VM), we need also
> >different tags for PTRACE_VM_SINGLESTEP, PTRACE_VM_SINGLEBLOCK and maybe
> >others in the future.
> >Using the addr field we don't need this multiplication of tags
> >(and we could soon delete PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP).
> Yes? We could also remove PTRACE_SYSEMU* if we had PTRACE_VM to replace
> it. I would like to hear more from you on this point.

I am sorry for the delay of this reply.
I am having a quite busy time and I like to analyze problems before
giving answers.

Let me point out that the primary issue is the following one:
PTRACE_SYSEMU is a limited feature. It is twofold limited:
- it is supported only for x86
- it provides support for "total" virtual machines like User-Mode Linux
and it is useless for "partial" virtual machine like fakeroot-ng, umview
or others.
I have published a proposal for a new support that is able to overpass
these limits. PTRACE_SYSEMU/SYSEMU_SINGLESTEP could be deprecated.
There will be some cleaning up of the kernel code when the deprecated
tags are eliminated.

Whether it is nicer to use the existing tags or defining new tags is a
secondary issue. I support the hypothesis of reusing the existing tags and use
values in the addr field but if the community says that it is nicer/better to
have separate tags it is quite easy to update my patches (and umview).

Let us discuss this latter point.

PTRACE has a number of "resume" tags:
PTRACE_SYSCALL, PTRACE_SINGLESTEP, PTRACE_SINGLEBLOCK and currently
PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP.
all these call are managed in the code by the ptrace_resume function.

My patch #1 (kernel/ptrace.c function ptrace_request) forwards the addr 
parameter to ptrace_resume which saves the VM bits in some bits inside 
task_struct's ptrace field.

If we want to use different tags like:
PTRACE_VM PTRACE_VM_SINGLESTEP PTRACE_VM_SINGLEBLOCK:
the better implementation I can envision, adds another group of switch cases
as follows (kernel/ptrace.c function ptrace_request):
 ....
 #ifdef PTRACE_SINGLESTEP
   case PTRACE_SINGLESTEP:
 #endif
 #ifdef PTRACE_SINGLEBLOCK
   case PTRACE_SINGLEBLOCK:
 #endif
 #ifdef PTRACE_SYSEMU
   case PTRACE_SYSEMU:
   case PTRACE_SYSEMU_SINGLESTEP:
 #endif
   case PTRACE_SYSCALL:
   case PTRACE_CONT:
     return ptrace_resume(child, request, 0, data);
+/* statements added for PTRACE_VM management */
+#ifdef PTRACE_VM
+  case PTRACE_VM:
+#ifdef PTRACE_VM_SINGLESTEP
+  case PTRACE_VM_SINGLESTEP:
+#endif
+#ifdef PTRACE_VM_SINGLEBLOCK
+  case PTRACE_VM_SINGLEBLOCK:
+#endif
+    return ptrace_resume(child, PTRACE_VM_TAGS_MAPPING(request), addr, data);
+#endif
....
  
where PTRACE_VM_TAGS_MAPPING is a macro that maps each VM tag to the
corresponding one (PTRACE_VM->PTRACE_SYSCALL, 
PTRACE_VM_SINGLESTEP->PTRACE_SINGLESTEP, and so on).

Other implementations inside ptrace_resume would end up in a nightmare of
definitions like is_vm, is_vm_singlestep ... similar to is_singlestep,
is_sysemu_singlestep and a lot of cases and subcases in ptrace_resume: more
lines of code and more cases during the execution.

This is my position:
There are three points in favour of reusing the existing tags and 
one against.

In favour #1: Do we really want to add some tags to the jungle of PTRACE tags?
at the end of this message I have attached a list of the tags defined in
2.6.29.  I know that the set of integers although limited is quite large, but
the idea to have a slalom between already defined constant is not nice.  (Note
that some globally defined tags like PTRACE_ATTACH have been redefined in some
architectures. PTRACE_SYSEMU value itself has been redefined in frv, blackfin,
sh). Of course, each architecture uses its own constants but this is not an 
example of good design.

We could use a high order bit to map VM calls to make things simpler.
e.g.
#define PTRACE_VM_BIT 0x80000000
#define PTRACE_VM (PTRACE_VM_BIT | PTRACE_SYSCALL)
#define PTRACE_VM_SINGLESTEP (PTRACE_VM_BIT | PTRACE_SINGLESTEP)
...
in this way:
#define PTRACE_VM_TAGS_MAPPING(REQ) ((REQ) & ~PTRACE_VM_BIT)

In favour#2: Using specific PTRACE_VM* tags the definitions above should be
added in the specific ptrace.h files for each architecture supporting PTRACE_VM
(those supporting tracehook), skipping the others, thus adding a number of
lines.  When a new "resume" tag is added, all these ptrace.h files will need
to be patched.  
If we use the addr field, it is simply ignored for architectures where
the new feature is not supported, there is no need of architecure dependent
definitions and new tags are managed automagically.
Summing up "in favour" #1 and #2 the saving in terms of lines of code is
higher with the current patch than by using specific tags.

In favour#3: The more cases in a switch the more code is generated.
Using specific PTRACE_VM* tags there are some more instruction to be executed
twice for each system call.  The loss of performance is very low, but not null.
When dealing with virtual machines speed is a must, and when possible, the
single useless machine instruction should be avoided.

Against #1: Using the patch I proposed which encodes PTRACE_VM tags in the
addr field, there is a remote possibility to break some existing code.
gdb, fakeroot_ng, UML uses addr = 0. strace for some unknown reasons
uses addr = (char *) 1. 
The addr tags in my patches do not use the less significant bit.
The tools I tested on a kernel with my patch installed worked like a charm.

I'd summarize this discussion as follows. I have a strong position about
the need of a more powerful/portable support for virtual machines based
in system call emulation (and partial emulation).
I have a weak preference about the interface, it is my opinion that the one 
I proposed is better for some reasons:
- less lines of code/more lines of code will be saved when SYSEMU is eliminated
- a bit faster
- no need for arch dependent definitions.

I have in my todo file to update the ptrace(2) man page for this new feature.
I'll do it as soon as we decide for the best interface.

Thank you to have read my posting up to here ;-)

	renzo

-----
Summary of ptrace tags. 
Entries without leading path are globally defined in include/linux/ptrace.h.

#define PTRACE_TRACEME		   0
#define PTRACE_PEEKTEXT		   1
#define PTRACE_PEEKDATA		   2
#define PTRACE_PEEKUSR		   3
#define PTRACE_POKETEXT		   4
#define PTRACE_POKEDATA		   5
#define PTRACE_POKEUSR		   6
#define PTRACE_CONT		   7
#define PTRACE_KILL		   8
#define PTRACE_SINGLESTEP	   9
arch/sparc/include/asm/ptrace.h:#define PTRACE_SPARC_DETACH       11
include/asm-frv/ptrace.h:#define PTRACE_GETREGS		12
include/asm-m32r/ptrace.h:#define PTRACE_GETREGS		12
include/asm-mn10300/ptrace.h:#define PTRACE_GETREGS            12
arch/arm/include/asm/ptrace.h:#define PTRACE_GETREGS		12
arch/avr32/include/asm/ptrace.h:#define PTRACE_GETREGS		12
arch/blackfin/include/asm/ptrace.h:#define PTRACE_GETREGS            12
arch/cris/include/asm/ptrace.h:#define PTRACE_GETREGS            12
arch/h8300/include/asm/ptrace.h:#define PTRACE_GETREGS            12
arch/ia64/include/asm/ptrace.h:#define PTRACE_SINGLEBLOCK	12	/* resume execution until next branch */
arch/m68k/include/asm/ptrace.h:#define PTRACE_GETREGS            12
arch/mips/include/asm/ptrace.h:#define PTRACE_GETREGS		12
arch/parisc/include/asm/ptrace.h:#define PTRACE_SINGLEBLOCK	12	/* resume execution until next branch */
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GETREGS            12
arch/sparc/include/asm/ptrace.h:#define PTRACE_GETREGS            12
arch/sh/include/asm/ptrace.h:#define PTRACE_GETREGS		12	/* General registers */
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_GETREGS            12
arch/xtensa/include/asm/ptrace.h:#define PTRACE_GETREGS		12
include/asm-frv/ptrace.h:#define PTRACE_SETREGS		13
include/asm-m32r/ptrace.h:#define PTRACE_SETREGS		13
include/asm-mn10300/ptrace.h:#define PTRACE_SETREGS            13
arch/arm/include/asm/ptrace.h:#define PTRACE_SETREGS		13
arch/avr32/include/asm/ptrace.h:#define PTRACE_SETREGS		13
arch/blackfin/include/asm/ptrace.h:#define PTRACE_SETREGS            13	/* ptrace signal  */
arch/cris/include/asm/ptrace.h:#define PTRACE_SETREGS            13
arch/h8300/include/asm/ptrace.h:#define PTRACE_SETREGS            13
arch/ia64/include/asm/ptrace.h:#define PTRACE_OLD_GETSIGINFO	13	/* (replaced by PTRACE_GETSIGINFO in <linux/ptrace.h>)  */
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SETREGS            13
arch/m68k/include/asm/ptrace.h:#define PTRACE_SETREGS            13
arch/mips/include/asm/ptrace.h:#define PTRACE_SETREGS		13
arch/sparc/include/asm/ptrace.h:#define PTRACE_SETREGS            13
arch/sh/include/asm/ptrace.h:#define PTRACE_SETREGS		13
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SETREGS            13
arch/xtensa/include/asm/ptrace.h:#define PTRACE_SETREGS		13
include/asm-frv/ptrace.h:#define PTRACE_GETFPREGS	14
include/asm-mn10300/ptrace.h:#define PTRACE_GETFPREGS          14
arch/arm/include/asm/ptrace.h:#define PTRACE_GETFPREGS	14
arch/ia64/include/asm/ptrace.h:#define PTRACE_OLD_SETSIGINFO	14	/* (replaced by PTRACE_SETSIGINFO in <linux/ptrace.h>)  */
arch/m68k/include/asm/ptrace.h:#define PTRACE_GETFPREGS          14
arch/mips/include/asm/ptrace.h:#define PTRACE_GETFPREGS		14
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GETFPREGS          14
arch/sparc/include/asm/ptrace.h:#define PTRACE_GETFPREGS          14
arch/sh/include/asm/ptrace.h:#define PTRACE_GETFPREGS	14	/* FPU registers */
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_GETFPREGS          14
include/asm-frv/ptrace.h:#define PTRACE_SETFPREGS	15
include/asm-mn10300/ptrace.h:#define PTRACE_SETFPREGS          15
arch/arm/include/asm/ptrace.h:#define PTRACE_SETFPREGS	15
arch/m68k/include/asm/ptrace.h:#define PTRACE_SETFPREGS          15
arch/mips/include/asm/ptrace.h:#define PTRACE_SETFPREGS		15
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SETFPREGS          15
arch/sparc/include/asm/ptrace.h:#define PTRACE_SETFPREGS          15
arch/sh/include/asm/ptrace.h:#define PTRACE_SETFPREGS	15
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SETFPREGS          15
#define PTRACE_ATTACH		  16
arch/sparc/include/asm/ptrace.h:#define PTRACE_READDATA           16
#define PTRACE_DETACH		  17
arch/sparc/include/asm/ptrace.h:#define PTRACE_WRITEDATA          17
arch/arm/include/asm/ptrace.h:#define PTRACE_GETWMMXREGS	18
arch/ia64/include/asm/ptrace.h:#define PTRACE_GETREGS		18	/* get all registers (pt_all_user_regs) in one shot */
arch/mips/include/asm/ptrace.h:/* #define PTRACE_GETFPXREGS		18 */
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GETVRREGS	18
arch/sparc/include/asm/ptrace.h:#define PTRACE_READTEXT           18
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_GETFPXREGS         18
arch/xtensa/include/asm/ptrace.h:#define PTRACE_GETXTREGS	18
arch/arm/include/asm/ptrace.h:#define PTRACE_SETWMMXREGS	19
arch/ia64/include/asm/ptrace.h:#define PTRACE_SETREGS		19	/* set all registers (pt_all_user_regs) in one shot */
arch/mips/include/asm/ptrace.h:/* #define PTRACE_SETFPXREGS		19 */
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SETVRREGS	19
arch/sparc/include/asm/ptrace.h:#define PTRACE_WRITETEXT          19
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SETFPXREGS         19
arch/xtensa/include/asm/ptrace.h:#define PTRACE_SETXTREGS	19
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GETEVRREGS	20
arch/sparc/include/asm/ptrace.h:#define PTRACE_GETFPAREGS         20
include/asm-m32r/ptrace.h:#define PTRACE_OLDSETOPTIONS	21
arch/arm/include/asm/ptrace.h:#define PTRACE_OLDSETOPTIONS	21
arch/ia64/include/asm/ptrace.h:#define PTRACE_OLDSETOPTIONS	21
arch/mips/include/asm/ptrace.h:#define PTRACE_OLDSETOPTIONS	21
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SETEVRREGS	21
arch/s390/include/asm/ptrace.h:#define PTRACE_OLDSETOPTIONS         21
arch/s390/include/asm/ptrace.h:#define PTRACE_PROT                       21
arch/sparc/include/asm/ptrace.h:#define PTRACE_SETFPAREGS         21
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_OLDSETOPTIONS      21
arch/arm/include/asm/ptrace.h:#define PTRACE_GET_THREAD_AREA	22
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GETREGS64	  22
arch/sparc/include/asm/ptrace.h:#define PTRACE_GETREGS64	  22
arch/arm/include/asm/ptrace.h:#define PTRACE_SET_SYSCALL	23
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SETREGS64	  23
arch/sparc/include/asm/ptrace.h:#define PTRACE_SETREGS64	  23
#define PTRACE_SYSCALL		  24
arch/arm/include/asm/ptrace.h:#define PTRACE_GETCRUNCHREGS	25
arch/mips/include/asm/ptrace.h:#define PTRACE_GET_THREAD_AREA	25
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GET_DEBUGREG	25
arch/sparc/include/asm/ptrace.h:#define PTRACE_GETFPREGS64	  25
arch/arm/include/asm/ptrace.h:#define PTRACE_SETCRUNCHREGS	26
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_GET_THREAD_AREA    25
arch/mips/include/asm/ptrace.h:#define PTRACE_SET_THREAD_AREA	26
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SET_DEBUGREG	26
arch/sparc/include/asm/ptrace.h:#define PTRACE_SETFPREGS64	  26
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SET_THREAD_AREA    26
arch/powerpc/include/asm/ptrace.h:#define PTRACE_GETVSRREGS	27
arch/powerpc/include/asm/ptrace.h:#define PTRACE_SETVSRREGS	28
arch/x86/include/asm/ptrace-abi.h:# define PTRACE_ARCH_PRCTL	  30
arch/um/include/shared/ptrace_user.h:#define PTRACE_SYSEMU 31
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SYSEMU		  31
include/asm-frv/ptrace.h:#define PTRACE_GETFDPIC		31	/* get the ELF fdpic loadmap address */
arch/blackfin/include/asm/ptrace.h:#define PTRACE_GETFDPIC           31
arch/sh/include/asm/ptrace.h:#define PTRACE_GETFDPIC		31	/* get the ELF fdpic loadmap address */
arch/um/include/shared/ptrace_user.h:#define PTRACE_SYSEMU_SINGLESTEP 32
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SYSEMU_SINGLESTEP  32
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_BTS_CONFIG	40
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_BTS_STATUS	41
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_BTS_SIZE		42
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_BTS_GET		43
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_BTS_CLEAR	44
arch/x86/include/asm/ptrace-abi.h:#define PTRACE_BTS_DRAIN	45
arch/sh/include/asm/ptrace.h:#define	PTRACE_GETDSPREGS	55	/* DSP registers */
arch/sh/include/asm/ptrace.h:#define	PTRACE_SETDSPREGS	56
arch/mips/include/asm/ptrace.h:#define PTRACE_PEEKTEXT_3264	0xc0
arch/mips/include/asm/ptrace.h:#define PTRACE_PEEKDATA_3264	0xc1
arch/mips/include/asm/ptrace.h:#define PTRACE_POKETEXT_3264	0xc2
arch/mips/include/asm/ptrace.h:#define PTRACE_POKEDATA_3264	0xc3
arch/mips/include/asm/ptrace.h:#define PTRACE_GET_THREAD_AREA_3264	0xc4
arch/mips/include/asm/ptrace.h:#define PTRACE_GET_WATCH_REGS	0xd0
arch/mips/include/asm/ptrace.h:#define PTRACE_SET_WATCH_REGS	0xd1
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_POKEUSR_3264  0x90
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_PEEKUSR_3264  0x91
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_POKEDATA_3264 0x92
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_POKETEXT_3264 0x93
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_PEEKDATA_3264 0x94
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_PEEKTEXT_3264 0x95
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_SETFPREGS	0x96	/* Set FPRs 0 - 31 */
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_GETFPREGS	0x97	/* Get FPRs 0 - 31 */
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_SETREGS	0x98	/* Set GPRs 0 - 31 */
arch/powerpc/include/asm/ptrace.h:#define PPC_PTRACE_GETREGS	0x99	/* Get GPRs 0 - 31 */
#define PTRACE_SETOPTIONS	0x4200
#define PTRACE_GETEVENTMSG	0x4201
#define PTRACE_GETSIGINFO	0x4202
#define PTRACE_SETSIGINFO	0x4203
arch/s390/include/asm/ptrace.h:#define PTRACE_PEEKUSR_AREA           0x5000
arch/s390/include/asm/ptrace.h:#define PTRACE_POKEUSR_AREA           0x5001
arch/s390/include/asm/ptrace.h:#define PTRACE_PEEKTEXT_AREA	      0x5002
arch/s390/include/asm/ptrace.h:#define PTRACE_PEEKDATA_AREA	      0x5003
arch/s390/include/asm/ptrace.h:#define PTRACE_POKETEXT_AREA	      0x5004
arch/s390/include/asm/ptrace.h:#define PTRACE_POKEDATA_AREA 	      0x5005
