Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbYE3EQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbYE3EQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYE3EI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:08:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42202 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760564AbYE3EIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:08:24 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3341885"
Message-ID: <483F7DC3.9080705@qualcomm.com>
Date: Thu, 29 May 2008 21:08:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Move cpu masks from kernel/sched.c into kernel/cpu.c
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>	<1212085023-22284-2-git-send-email-maxk@qualcomm.com> <20080529182634.e9146033.pj@sgi.com>
In-Reply-To: <20080529182634.e9146033.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max wrote:
>> kernel/cpu.c is now built for the UP kernel too, but it does not
>> affect the size the kernel sections.
> 
> I don't think this is possible.  It must affect the size.
> 
> The patch moves kernel/cpu.o from being included only if CONFIG_SMP,
> to being included always:
> 
>      obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
>     -	    exit.o itimer.o time.o softirq.o resource.o \
>     +	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
> 		sysctl.o capability.o ptrace.o timer.o user.o \
> 		signal.o sys.o kmod.o workqueue.o pid.o \
> 		rcupdate.o extable.o params.o posix-timers.o \
>     @@ -27,7 +27,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
>      obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
>      obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
>      obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
>     -obj-$(CONFIG_SMP) += cpu.o spinlock.o
>     +obj-$(CONFIG_SMP) += spinlock.o
> 
> The kernel/cpu.o object file is non-empty; it has size,
> perhaps 1 or 2 kbytes of text, and a little bit of data.
> 
> So adding it to builds which disabled SMP must add to the
> size of the resultant kernel, by my thinking anyway.

All the code is ifdefed under CONFIG_SMP. So there is no code in the !SMP
case, just three masks. When you mentioned it first time I went back and
rebuilt the !SMP kernel with and without the patch. Luckily I have a
ridiculously fast 8way box here so I went ahead and verified it again.

Before:
size vmlinux
   text	   data	    bss	    dec	    hex	filename
3305622	 306420	 310352	3922393	 3bd9d9	vmlinux

size kernel/cpu.o
size: 'kernel/cpu.o': No such file

After:
size vmlinux
   text	   data	    bss	    dec	    hex	filename
3305621	 306420	 310352	3922393	 3bd9d9	vmlinux

size kernel/cpu.o
   text	   data	    bss	    dec	    hex	filename
     96	     24	      0	    120	     78	kernel/cpu.o

Max
