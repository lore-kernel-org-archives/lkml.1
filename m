Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0BCEfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:35:45 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:58268 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0BCEfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=asR4MqoCLG8spLBc5T+oim4II11loOsYQxopHlAtEQHA9U/OPyesp/coJTVCpT2hRK
         tiZqb7IYd9jqcPgtpT98h99AKKGS30hIf5I9dLHSOuwIZKQlbPAXI8TWAglWfOjoWO3s
         yAx60srHn9S9QBWWxs0Ib5dLdZ7ZkRSyeEDYQ=
MIME-Version: 1.0
In-Reply-To: <20100202185837.GB3630@lst.de>
References: <20100202185755.GA3630@lst.de> <20100202185837.GB3630@lst.de>
Date: Tue, 2 Feb 2010 23:35:42 -0500
Message-ID: <b4198de61002022035s3111a07ctf6aa94bbf2088c08@mail.gmail.com>
Subject: Re: [PATCH 2/14] alpha: use generic ptrace_resume code
From: Matt Turner <mattst88@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 1:58 PM, Christoph Hellwig <hch@lst.de> wrote:
> Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
> PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
> arch_has_single_step in <asm/ptrace.h> and implementing the
> user_enable_single_step and user_disable_single_step functions, which
> also causes the breakpoint information to be cleared on fork, which
> could be considered a bug fix.
>
> Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
> which it previously wasn't, which is consistent with all architectures
> using the modern ptrace code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6/arch/alpha/kernel/ptrace.c
> ===================================================================
> --- linux-2.6.orig/arch/alpha/kernel/ptrace.c   2010-02-02 11:05:03.197004058 +0100
> +++ linux-2.6/arch/alpha/kernel/ptrace.c        2010-02-02 11:07:04.091006019 +0100
> @@ -249,6 +249,17 @@ ptrace_cancel_bpt(struct task_struct * c
>        return (nsaved != 0);
>  }
>
> +void user_enable_single_step(struct task_struct *child)
> +{
> +       /* Mark single stepping.  */
> +       task_thread_info(child)->bpt_nsaved = -1;
> +}
> +
> +void user_disable_single_step(struct task_struct *child)
> +{
> +       ptrace_cancel_bpt(child);
> +}
> +
>  /*
>  * Called by kernel/ptrace.c when detaching..
>  *
> @@ -256,7 +267,7 @@ ptrace_cancel_bpt(struct task_struct * c
>  */
>  void ptrace_disable(struct task_struct *child)
>  {
> -       ptrace_cancel_bpt(child);
> +       user_disable_single_step(child);
>  }
>
>  long arch_ptrace(struct task_struct *child, long request, long addr, long data)
> @@ -289,52 +300,6 @@ long arch_ptrace(struct task_struct *chi
>                DBG(DBG_MEM, ("poke $%ld<-%#lx\n", addr, data));
>                ret = put_reg(child, addr, data);
>                break;
> -
> -       case PTRACE_SYSCALL:
> -               /* continue and stop at next (return from) syscall */
> -       case PTRACE_CONT:    /* restart after signal. */
> -               ret = -EIO;
> -               if (!valid_signal(data))
> -                       break;
> -               if (request == PTRACE_SYSCALL)
> -                       set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> -               else
> -                       clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> -               child->exit_code = data;
> -               /* make sure single-step breakpoint is gone. */
> -               ptrace_cancel_bpt(child);
> -               wake_up_process(child);
> -               ret = 0;
> -               break;
> -
> -       /*
> -        * Make the child exit.  Best I can do is send it a sigkill.
> -        * perhaps it should be put in the status that it wants to
> -        * exit.
> -        */
> -       case PTRACE_KILL:
> -               ret = 0;
> -               if (child->exit_state == EXIT_ZOMBIE)
> -                       break;
> -               child->exit_code = SIGKILL;
> -               /* make sure single-step breakpoint is gone. */
> -               ptrace_cancel_bpt(child);
> -               wake_up_process(child);
> -               break;
> -
> -       case PTRACE_SINGLESTEP:  /* execute single instruction. */
> -               ret = -EIO;
> -               if (!valid_signal(data))
> -                       break;
> -               /* Mark single stepping.  */
> -               task_thread_info(child)->bpt_nsaved = -1;
> -               clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> -               child->exit_code = data;
> -               wake_up_process(child);
> -               /* give it a chance to run. */
> -               ret = 0;
> -               break;
> -
>        default:
>                ret = ptrace_request(child, request, addr, data);
>                break;
> Index: linux-2.6/arch/alpha/include/asm/ptrace.h
> ===================================================================
> --- linux-2.6.orig/arch/alpha/include/asm/ptrace.h      2010-02-02 11:07:29.091023600 +0100
> +++ linux-2.6/arch/alpha/include/asm/ptrace.h   2010-02-02 11:07:38.645007248 +0100
> @@ -68,6 +68,7 @@ struct switch_stack {
>
>  #ifdef __KERNEL__
>
> +#define arch_has_single_step()         (1)
>  #define user_mode(regs) (((regs)->ps & 8) != 0)
>  #define instruction_pointer(regs) ((regs)->pc)
>  #define profile_pc(regs) instruction_pointer(regs)
>

Acked-by: Matt Turner <mattst88@gmail.com>
