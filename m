Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXCARuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXCARuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965462AbXCARuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:50:01 -0500
Received: from mail.screens.ru ([213.234.233.54]:36402 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXCARuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:50:00 -0500
Date: Thu, 1 Mar 2007 20:52:07 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: John Reiser <jreiser@BitWagon.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070301175207.GA849@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser wrote:
>
> --- a/arch/i386/kernel/sysenter.c~fully-honor-vdso_enabled
> +++ a/arch/i386/kernel/sysenter.c
> @@ -22,6 +22,8 @@
>  #include <asm/msr.h>
>  #include <asm/pgtable.h>
>  #include <asm/unistd.h>
> +#include <asm/a.out.h>
> +#include <asm/mman.h>
>
>  /*
>   * Should the kernel map a VDSO page into processes and pass its
> @@ -105,10 +107,25 @@ int arch_setup_additional_pages(struct l
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long addr;
> +	unsigned long flags;
>  	int ret;
>
> +	switch (vdso_enabled) {
> +	case 0:  /* none */
> +		return 0;

This means we don't initialize mm->context.vdso and ->sysenter_return.

Is it ok? For example, setup_rt_frame() uses VDSO_SYM(&__kernel_rt_sigreturn),
sysenter_past_esp pushes ->sysenter_return on stack.

Note also that load_elf_binary does

	arch_setup_additional_pages()
	create_elf_tables()

, looks like application can crash after exec if vdso_enabled changes from 0
to 1 in between.

Could you please explain if I missed something?

Oleg.

