Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZFLKvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZFLKvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZFLKu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:50:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56413 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZFLKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:50:57 -0400
Date: Fri, 12 Jun 2009 12:50:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Magnus Damm <damm@igel.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sergio Luis <sergio@larces.uece.br>,
       Lauro Salmito <laurosalmito@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 07/19] x86: unify power/cpu_(32|64).c
Message-ID: <20090612105049.GI18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.DG.2cYMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.DG.2cYMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 22:35:11, Rafael J. Wysocki wrote:
> From: Sergio Luis <sergio@larces.uece.br>
> 
> This is the last unification step. Here we do remove one of the files
> and rename the left one as cpu.c, as both are now the same.
> Also update power/Makefile, telling it to build cpu.o, instead of
> cpu_(32|64).o
> 
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>


> +#ifdef CONFIG_X86_32
> +	store_gdt(&ctxt->gdt);
> +	store_idt(&ctxt->idt);
> +#else
> +/* CONFIG_X86_64 */
> +	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
> +	store_idt((struct desc_ptr *)&ctxt->idt_limit);
> +#endif

I'd slightly prefer /* CONFIG_X86_64 */ to be moved to line above, or
dropped at all. it seems unneccessarily verbose.


> +	store_tr(ctxt->tr);
> +
> +	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
> +	/*
> +	 * segment registers
> +	 */
> +#ifdef CONFIG_X86_32
> +	savesegment(es, ctxt->es);
> +	savesegment(fs, ctxt->fs);
> +	savesegment(gs, ctxt->gs);
> +	savesegment(ss, ctxt->ss);
> +#else
> +/* CONFIG_X86_64 */
> +	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
> +	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
> +	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
> +	asm volatile ("movw %%gs, %0" : "=m" (ctxt->gs));
> +	asm volatile ("movw %%ss, %0" : "=m" (ctxt->ss));
> +
> +	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
> +	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
> +	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
> +	mtrr_save_fixed_ranges(NULL);
> +
> +	rdmsrl(MSR_EFER, ctxt->efer);
> +#endif

Can i386's mtrr_save_fixed_ranges() be moved to similar place?

> +	/*
> +	 * control registers
> +	 */
> +	ctxt->cr0 = read_cr0();
> +	ctxt->cr2 = read_cr2();
> +	ctxt->cr3 = read_cr3();
> +#ifdef CONFIG_X86_32
> +	ctxt->cr4 = read_cr4_safe();
> +#else
> +/* CONFIG_X86_64 */
> +	ctxt->cr4 = read_cr4();
> +	ctxt->cr8 = read_cr8();
> +#endif

Could we use read_cr4_safe on x86-64, too? Why the difference?

Should we be saving cr8 on 32-bit machines that have it? (That was
interrupt priority, IIRC?)

> +	/* cr4 was introduced in the Pentium CPU */
> +#ifdef CONFIG_X86_32
> +	if (ctxt->cr4)
> +		write_cr4(ctxt->cr4);
> +#else

Aha, is read_cr4_safe() needed because i486 does not have cr4?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
