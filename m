Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXKGDHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXKGDHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXKGDHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:07:09 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:18418 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXKGDHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SlBIP55P/5n+AeD+GzDnyBP7uQBHJADBH5upGNqcKW3X5fTPyxRYk5A8g6PaWobpYhbqLgzMsg21fErQyRuci/Wf+bY2JPTqd4Q2l3sPZsq1nLkoOYnoarVtnCQHqNU1BCkDaLO7K4pRmjS7JL8JjdAzJPWYkodiRzIv3nJejnk=
Message-ID: <386072610711061907q7809db9ct51d00fe2d6ec6c6b@mail.gmail.com>
Date: Wed, 7 Nov 2007 11:07:06 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] blackfin: remove dump_thread()
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071105170750.GW12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071105170750.GW12045@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes the unused dump_thread().
>

Why only remove it from Blackfin? any more reason?
I found this in latest 2.6.24-rc2:

--
Cscope tag: dump_thread
   #   line  filename / context / line
   1    324  arch/alpha/kernel/process.c <<dump_thread>>
             dump_thread(struct pt_regs * pt, struct user * dump)
   2    373  arch/arm/kernel/process.c <<dump_thread>>
             void dump_thread(struct pt_regs * regs, struct user * dump)
   3    244  arch/blackfin/kernel/process.c <<dump_thread>>
             void dump_thread(struct pt_regs *regs, struct user *dump)
   4    321  arch/m68k/kernel/process.c <<dump_thread>>
             void dump_thread(struct pt_regs * regs, struct user * dump)
   5    572  arch/sparc/kernel/process.c <<dump_thread>>
             void dump_thread(struct pt_regs * regs, struct user * dump)
   6    731  arch/sparc64/kernel/process.c <<dump_thread>>
             void dump_thread(struct pt_regs * regs, struct user * dump)
   7    306  arch/um/kernel/process.c <<dump_thread>>
             void dump_thread(struct pt_regs *regs, struct user *u)
   8    519  arch/x86/kernel/process_32.c <<dump_thread>>
             void dump_thread(struct pt_regs * regs, struct user * dump)
--

Regards,
-Bryan

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  arch/blackfin/kernel/bfin_ksyms.c  |    1
>  arch/blackfin/kernel/process.c     |   45 -----------------------------
>  include/asm-blackfin/bfin-global.h |    1
>  3 files changed, 47 deletions(-)
>
> c7746b10ac98a3166a7257f7117dd125e5ba4c7b
> diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
> index 2198afe..99ea57c 100644
> --- a/arch/blackfin/kernel/bfin_ksyms.c
> +++ b/arch/blackfin/kernel/bfin_ksyms.c
> @@ -39,7 +39,6 @@
>  EXPORT_SYMBOL(__ioremap);
>  EXPORT_SYMBOL(strcmp);
>  EXPORT_SYMBOL(strncmp);
> -EXPORT_SYMBOL(dump_thread);
>
>  EXPORT_SYMBOL(ip_fast_csum);
>
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 9124467..1a8cf33 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -239,51 +239,6 @@ copy_thread(int nr, unsigned long clone_flags,
>  }
>
>  /*
> - * fill in the user structure for a core dump..
> - */
> -void dump_thread(struct pt_regs *regs, struct user *dump)
> -{
> -       dump->magic = CMAGIC;
> -       dump->start_code = 0;
> -       dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
> -       dump->u_tsize = ((unsigned long)current->mm->end_code) >> PAGE_SHIFT;
> -       dump->u_dsize = ((unsigned long)(current->mm->brk +
> -                                        (PAGE_SIZE - 1))) >> PAGE_SHIFT;
> -       dump->u_dsize -= dump->u_tsize;
> -       dump->u_ssize = 0;
> -
> -       if (dump->start_stack < TASK_SIZE)
> -               dump->u_ssize =
> -                   ((unsigned long)(TASK_SIZE -
> -                                    dump->start_stack)) >> PAGE_SHIFT;
> -
> -       dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
> -
> -       dump->regs.r0 = regs->r0;
> -       dump->regs.r1 = regs->r1;
> -       dump->regs.r2 = regs->r2;
> -       dump->regs.r3 = regs->r3;
> -       dump->regs.r4 = regs->r4;
> -       dump->regs.r5 = regs->r5;
> -       dump->regs.r6 = regs->r6;
> -       dump->regs.r7 = regs->r7;
> -       dump->regs.p0 = regs->p0;
> -       dump->regs.p1 = regs->p1;
> -       dump->regs.p2 = regs->p2;
> -       dump->regs.p3 = regs->p3;
> -       dump->regs.p4 = regs->p4;
> -       dump->regs.p5 = regs->p5;
> -       dump->regs.orig_p0 = regs->orig_p0;
> -       dump->regs.a0w = regs->a0w;
> -       dump->regs.a1w = regs->a1w;
> -       dump->regs.a0x = regs->a0x;
> -       dump->regs.a1x = regs->a1x;
> -       dump->regs.rets = regs->rets;
> -       dump->regs.astat = regs->astat;
> -       dump->regs.pc = regs->pc;
> -}
> -
> -/*
>   * sys_execve() executes a new program.
>   */
>
> diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
> index 0212e18..cd924bb 100644
> --- a/include/asm-blackfin/bfin-global.h
> +++ b/include/asm-blackfin/bfin-global.h
> @@ -50,7 +50,6 @@ extern unsigned long get_sclk(void);
>  extern unsigned long sclk_to_usecs(unsigned long sclk);
>  extern unsigned long usecs_to_sclk(unsigned long usecs);
>
> -extern void dump_thread(struct pt_regs *regs, struct user *dump);
>  extern void dump_bfin_regs(struct pt_regs *fp, void *retaddr);
>  extern void dump_bfin_trace_buffer(void);
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
