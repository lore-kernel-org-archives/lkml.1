Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXE3UfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXE3UfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbXE3Uej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:34:39 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758249AbXE3Uei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:34:38 -0400
Date: Wed, 30 May 2007 13:33:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Message-Id: <20070530133359.5a553e0c.akpm@linux-foundation.org>
In-Reply-To: <20070530140229.491376274@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140229.491376274@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:00:33 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Use the faster conditional calls for F00F bug handling in do_page_fault.
> 

I guess this means that CONDCALL will be enabled on pretty much all i386,
in which case making the whole feature Kconfigurable is starting to look
marginal.

Perhaps a better approach would have to made this change dependent upon
CONDCALL, rather than forcing it on.

> @@ -1084,6 +1085,7 @@
>  	 */
>  	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
>  	load_idt(&idt_descr);
> +	BUG_ON(cond_call_arm("fix_f00f"));

It is generally poor C style to do

	assert(something_which_has_side_effects())

because people can legitimately expect to do

#define assert() /*nothing*/

for production code.

The kernel doesn't actually do the right thing here when CONFIG_BUG=n,
sadly.  But still, children might be watching, so the better and preferred
style is

	if (cond_call_arm("fix_f00f"))
		BUG();

>  }
>  #endif
>  
> Index: linux-2.6-lttng/arch/i386/mm/fault.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/mm/fault.c	2007-05-29 11:05:48.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/mm/fault.c	2007-05-29 11:13:16.000000000 -0400
> @@ -25,6 +25,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/uaccess.h>
>  #include <linux/kdebug.h>
> +#include <linux/condcall.h>
>  
>  #include <asm/system.h>
>  #include <asm/desc.h>
> @@ -221,6 +222,25 @@
>  
>  fastcall void do_invalid_op(struct pt_regs *, unsigned long);
>  
> +#ifdef CONFIG_X86_F00F_BUG
> +/*
> + * Pentium F0 0F C7 C8 bug workaround.
> + */
> +static inline int do_f00f_workaround(struct pt_regs *regs,
> +		unsigned long address)
> +{
> +	unsigned long nr;
> +
> +	nr = (address - idt_descr.address) >> 3;
> +
> +	if (nr == 6) {
> +		do_invalid_op(regs, 0);
> +		return 1;
> +	}
> +	return 0;
> +}
> +#endif
> +
>  static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
>  {
>  	unsigned index = pgd_index(address);
> @@ -474,19 +494,8 @@
>  	}
>  
>  #ifdef CONFIG_X86_F00F_BUG
> -	/*
> -	 * Pentium F0 0F C7 C8 bug workaround.
> -	 */
> -	if (boot_cpu_data.f00f_bug) {
> -		unsigned long nr;
> -		
> -		nr = (address - idt_descr.address) >> 3;
> -
> -		if (nr == 6) {
> -			do_invalid_op(regs, 0);
> -			return;
> -		}
> -	}
> +	if (cond_call(fix_f00f, do_f00f_workaround(regs, address)))
> +		return;

We do a cond_call() to an inlined function?  That's a bit weird, isn't it?

>  #endif
>  
>  no_context:
> Index: linux-2.6-lttng/arch/i386/Kconfig.cpu
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/Kconfig.cpu	2007-05-29 11:51:46.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/Kconfig.cpu	2007-05-29 11:52:08.000000000 -0400
> @@ -275,6 +275,7 @@
>  config X86_F00F_BUG
>  	bool
>  	depends on M586MMX || M586TSC || M586 || M486 || M386
> +	select COND_CALL

That hurts.
