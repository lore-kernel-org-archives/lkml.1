Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZJAHAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZJAHAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZJAHAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:00:10 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:41484 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZJAHAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:00:10 -0400
Message-ID: <4AC45360.9020800@gmail.com>
Date: Thu, 01 Oct 2009 08:59:44 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
References: <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu> <20090930220342.GA2118@elte.hu> <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain> <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain> <4AC43E7E.1000600@gmail.com> <20091001061109.GA21488@elte.hu> <4AC449BD.1060003@gmail.com> <20091001064209.GA25189@elte.hu>
In-Reply-To: <20091001064209.GA25189@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 01 Oct 2009 08:59:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :


> The way to check for a disabled option in a Make rule is:
> 
> 	ifneq ($(CONFIG_X86_CMPXCHG64),y)
> 

Ah OK, thanks for the explanation, my test 486-build (before your change) just finished to :

arch/x86/built-in.o:(__ksymtab+0xa8): undefined reference to `cmpxchg8b_emu'
kernel/built-in.o: In function `sched_clock_local':
/opt/src/linux-2.6/kernel/sched_clock.c:130: undefined reference to `cmpxchg8b_emu'
kernel/built-in.o: In function `sched_clock_remote':
/opt/src/linux-2.6/kernel/sched_clock.c:166: undefined reference to `cmpxchg8b_emu'
make: *** [.tmp_vmlinux1] Error 1



> As in the disabled case the config variable will be undefined. (and wont 
> have a value of 'n'). I've done the fix below on your patch.
> 
> 	Ingo
> 
> Index: linux2/arch/x86/lib/Makefile
> ===================================================================
> --- linux2.orig/arch/x86/lib/Makefile
> +++ linux2/arch/x86/lib/Makefile
> @@ -16,7 +16,7 @@ ifeq ($(CONFIG_X86_32),y)
>          lib-y += checksum_32.o
>          lib-y += strstr_32.o
>          lib-y += semaphore_32.o string_32.o
> -ifeq ($(CONFIG_X86_CMPXCHG64),n)
> +ifneq ($(CONFIG_X86_CMPXCHG64),y)
>          lib-y += cmpxchg8b_emu.o
>  endif
>          lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o


Thats perfect this fixed my 486-build, thanks again.

Looking at disassembly I still see atomic64_cmpxchg(),
atomic64_xchg(), atomic64_add_return(),  and friends being
included... (but not used)

I'll check if similar patch could be done as well for atomic64 functions.
