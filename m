Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYBQNwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYBQNwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYBQNvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:51:53 -0500
Received: from www.tglx.de ([62.245.132.106]:55948 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbYBQNvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:51:52 -0500
Date: Sun, 17 Feb 2008 14:51:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8):
 undefined reference to `LGUEST_PAGES_regs_trapnum'
In-Reply-To: <200802040711.11280.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.00.0802171451060.7583@apollo.tec.linutronix.de>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Rusty Russell wrote:

> On Saturday 02 February 2008 04:05:51 Ingo Molnar wrote:
> > looks similar to the previous one so i guess my quick fix attempt was a
> > bit too quick. Will turn lguest off again. And i'm willing to test
> > patches as well :)
> 
> Hi Ingo,
> 
>    OK, this problem was caused by asm-offsets.c only having the offsets when
> lguest *guest* support was set, not lguest host (host support used to imply
> guest support, so now they're separate these bugs come out).
> 
> Can you throw this patch into your tree for testing?
> 
> Thanks,
> Rusty.

Applied. Thanks,

	 tglx
 
> Lguest guest support and host support are separate config options: they used
> to be tied together.  Sort out which parts of asm-offsets are needed for Guest
> and Host.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r 7d5a5c7a4b95 arch/x86/kernel/asm-offsets_32.c
> --- a/arch/x86/kernel/asm-offsets_32.c	Sat Feb 02 23:13:05 2008 +1100
> +++ b/arch/x86/kernel/asm-offsets_32.c	Sun Feb 03 10:13:19 2008 +1100
> @@ -20,10 +20,8 @@
>  
>  #include <xen/interface/xen.h>
>  
> -#ifdef CONFIG_LGUEST_GUEST
>  #include <linux/lguest.h>
>  #include "../../../drivers/lguest/lg.h"
> -#endif
>  
>  #define DEFINE(sym, val) \
>          asm volatile("\n->" #sym " %0 " #val : : "i" (val))
> @@ -134,6 +132,10 @@ void foo(void)
>  	BLANK();
>  	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
>  	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
> +#endif
> +
> +#ifdef CONFIG_LGUEST
> +	BLANK();
>  	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
>  	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
>  	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
> 
