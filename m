Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZJAGL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZJAGL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZJAGLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:11:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbZJAGLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:11:25 -0400
Date: Thu, 1 Oct 2009 08:11:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20091001061109.GA21488@elte.hu>
References: <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu> <20090930220342.GA2118@elte.hu> <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain> <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain> <4AC43E7E.1000600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC43E7E.1000600@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> [PATCH] x86: Dont generate cmpxchg8b_emu if CONFIG_X86_CMPXCHG64=y
> 
> cmpxchg8b_emu helper wont be used if CONFIG_X86_CMPXCHG64=y
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  arch/x86/kernel/i386_ksyms_32.c |    2 ++
>  arch/x86/lib/Makefile           |    6 ++++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
> index 1736c5a..9c3bd4a 100644
> --- a/arch/x86/kernel/i386_ksyms_32.c
> +++ b/arch/x86/kernel/i386_ksyms_32.c
> @@ -15,8 +15,10 @@ EXPORT_SYMBOL(mcount);
>   * the export, but dont use it from C code, it is used
>   * by assembly code and is not using C calling convention!
>   */
> +#ifndef CONFIG_X86_CMPXCHG64
>  extern void cmpxchg8b_emu(void);
>  EXPORT_SYMBOL(cmpxchg8b_emu);
> +#endif
>  
>  /* Networking helper routines. */
>  EXPORT_SYMBOL(csum_partial_copy_generic);
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index 3e549b8..c309b82 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -15,8 +15,10 @@ ifeq ($(CONFIG_X86_32),y)
>          obj-y += atomic64_32.o
>          lib-y += checksum_32.o
>          lib-y += strstr_32.o
> -        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
> -
> +        lib-y += semaphore_32.o string_32.o
> +ifeq ($(CONFIG_X86_CMPXCHG64),n)
> +        lib-y += cmpxchg8b_emu.o
> +endif
>          lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
>  else
>          obj-y += io_64.o iomap_copy_64.o

That's not enough - the inline assembly code in 
arch/x86/include/asm/cmpxchg_32.h should also not reference 
cmpxchg8b_emu in that case.

	Ingo
