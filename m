Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZGBMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZGBMBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZGBMBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:01:01 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:35652 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZGBMBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:01:00 -0400
Message-ID: <4A4CA0D5.6010103@linux.vnet.ibm.com>
Date: Thu, 02 Jul 2009 13:58:13 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] gcov causes vread_tsc to increment kernel memory
References: <alpine.DEB.2.00.0907011245230.22887@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907011245230.22887@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On bootup of the latest kernel my init segfaults. Debugging it, I found 
> that vread_tsc (a vsyscall) increments some strange kernel memory:
> 
> 0000000000000000 <vread_tsc>:
>    0:   55                      push   %rbp
>    1:   48 ff 05 00 00 00 00    incq   0(%rip)        # 8 <vread_tsc+0x8>
>                         4: R_X86_64_PC32        .bss+0x3c
>    8:   48 89 e5                mov    %rsp,%rbp
>    b:   66 66 90                xchg   %ax,%ax
>    e:   48 ff 05 00 00 00 00    incq   0(%rip)        # 15 <vread_tsc+0x15>
>                         11: R_X86_64_PC32       .bss+0x44
>   15:   66 66 90                xchg   %ax,%ax
>   18:   48 ff 05 00 00 00 00    incq   0(%rip)        # 1f <vread_tsc+0x1f>
>                         1b: R_X86_64_PC32       .bss+0x4c
>   1f:   0f 31                   rdtsc  
> 	
> 
> Those "incq" is very bad to happen in vsyscall memory, since userspace can 
> not modify it. You need to make something prevent profiling of vsyscall 
> memory (like I do with ftrace).
> 
> -- Steve

You're right, I missed that file. This should be fixed with the patch
below. As the problem didn't occur on my test machine, please retest
with the patch applied. Thanks!

Also seeing as function tracer and gcov work on a similar basis and
require similar files to be excluded from profiling, it would be nice
if we wouldn't need to mark those files separately. Instead it would
be great if the Makefile could be used to specify that a certain
object file has a certain property (e.g. PROPERTY_USERPACE_file.o := y)
and the mechanism (e.g. function tracer) would only need to specify
that the extra gcc options should not be applied when that property is
set. What do you think?

=================
Subject: [PATCH] gcov: exclude code operating in userspace from profiling

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Fix for this issue on x86_64:

rostedt@goodmis.org wrote:
> On bootup of the latest kernel my init segfaults. Debugging it,
> I found  that vread_tsc (a vsyscall) increments some strange
> kernel memory:
> 
> 0000000000000000 <vread_tsc>:
>    0:   55                      push   %rbp
>    1:   48 ff 05 00 00 00 00    incq   0(%rip)
>                         # 8 <vread_tsc+0x8>
>                         4: R_X86_64_PC32        .bss+0x3c
>    8:   48 89 e5                mov    %rsp,%rbp
>    b:   66 66 90                xchg   %ax,%ax
>    e:   48 ff 05 00 00 00 00    incq   0(%rip)
>                         # 15 <vread_tsc+0x15>
>                         11: R_X86_64_PC32       .bss+0x44
>   15:   66 66 90                xchg   %ax,%ax
>   18:   48 ff 05 00 00 00 00    incq   0(%rip)
>                         # 1f <vread_tsc+0x1f>
>                         1b: R_X86_64_PC32       .bss+0x4c
>   1f:   0f 31                   rdtsc  
>
>
> Those "incq" is very bad to happen in vsyscall memory, since
> userspace can not modify it. You need to make something prevent
> profiling of vsyscall  memory (like I do with ftrace).

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 arch/x86/kernel/Makefile |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.31-rc1/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.31-rc1.orig/arch/x86/kernel/Makefile
+++ linux-2.6.31-rc1/arch/x86/kernel/Makefile
@@ -26,6 +26,8 @@ CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
+GCOV_PROFILE_tsc.o		:= n
+GCOV_PROFILE_paravirt.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o

