Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGBNao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGBNao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZGBNah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:30:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZGBNag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:30:36 -0400
Date: Thu, 2 Jul 2009 09:30:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] gcov causes vread_tsc to increment kernel memory
In-Reply-To: <4A4CA0D5.6010103@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.0907020929160.26256@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907011245230.22887@gandalf.stny.rr.com> <4A4CA0D5.6010103@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Jul 2009, Peter Oberparleiter wrote:
> You're right, I missed that file. This should be fixed with the patch
> below. As the problem didn't occur on my test machine, please retest
> with the patch applied. Thanks!
> 
> Also seeing as function tracer and gcov work on a similar basis and
> require similar files to be excluded from profiling, it would be nice
> if we wouldn't need to mark those files separately. Instead it would
> be great if the Makefile could be used to specify that a certain
> object file has a certain property (e.g. PROPERTY_USERPACE_file.o := y)
> and the mechanism (e.g. function tracer) would only need to specify
> that the extra gcc options should not be applied when that property is
> set. What do you think?

I think a property for vsyscall would be nice. Then you can add your 
restrictions there. But ftrace also has to deal with other issues as well, 
not just vsyscall.

> 
> =================
> Subject: [PATCH] gcov: exclude code operating in userspace from profiling
> 
> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Fix for this issue on x86_64:
> 
> rostedt@goodmis.org wrote:
> > On bootup of the latest kernel my init segfaults. Debugging it,
> > I found  that vread_tsc (a vsyscall) increments some strange
> > kernel memory:
> > 
> > 0000000000000000 <vread_tsc>:
> >    0:   55                      push   %rbp
> >    1:   48 ff 05 00 00 00 00    incq   0(%rip)
> >                         # 8 <vread_tsc+0x8>
> >                         4: R_X86_64_PC32        .bss+0x3c
> >    8:   48 89 e5                mov    %rsp,%rbp
> >    b:   66 66 90                xchg   %ax,%ax
> >    e:   48 ff 05 00 00 00 00    incq   0(%rip)
> >                         # 15 <vread_tsc+0x15>
> >                         11: R_X86_64_PC32       .bss+0x44
> >   15:   66 66 90                xchg   %ax,%ax
> >   18:   48 ff 05 00 00 00 00    incq   0(%rip)
> >                         # 1f <vread_tsc+0x1f>
> >                         1b: R_X86_64_PC32       .bss+0x4c
> >   1f:   0f 31                   rdtsc  
> >
> >
> > Those "incq" is very bad to happen in vsyscall memory, since
> > userspace can not modify it. You need to make something prevent
> > profiling of vsyscall  memory (like I do with ftrace).
> 

Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!

-- Steve

> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/Makefile |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.31-rc1/arch/x86/kernel/Makefile
> ===================================================================
> --- linux-2.6.31-rc1.orig/arch/x86/kernel/Makefile
> +++ linux-2.6.31-rc1/arch/x86/kernel/Makefile
> @@ -26,6 +26,8 @@ CFLAGS_tsc.o		:= $(nostackp)
>  CFLAGS_paravirt.o	:= $(nostackp)
>  GCOV_PROFILE_vsyscall_64.o	:= n
>  GCOV_PROFILE_hpet.o		:= n
> +GCOV_PROFILE_tsc.o		:= n
> +GCOV_PROFILE_paravirt.o		:= n
>  
>  obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
>  obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
> 
> 
