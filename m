Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZIYW4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZIYW4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZIYW4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:56:36 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:63944 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIYW4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T1CQm934sPHxJ43Zb9zAOzctYcyQbJmFgewixmK3AeEy4BxC2b2n7qiUy8lQYWxp9H
         e+bGH4GNYZ1wfZMTbAoxbDJy8OQfjqj8gj0Vg7PhLJovUFs/JtVCRsa5tXKGF65rdGLS
         k75e+dLDwjV/qJvntv0uhKv3r+DkL3o4ShstE=
MIME-Version: 1.0
In-Reply-To: <4ABD3EC2.1020104@goop.org>
References: <4ABD3EC2.1020104@goop.org>
Date: Fri, 25 Sep 2009 18:56:38 -0400
Message-ID: <73c1f2160909251556g40f3c5b1o1c29b7f012912873@mail.gmail.com>
Subject: Re: [GIT PULL] x86: unify sys_iopl
From: Brian Gerst <brgerst@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct fix is to move set_iopl_mask into do_iopl.  sys_iopl
should only be a wrapper around do_iopl to manage the different
calling convention used by 32-bit and 64-bit.

On Fri, Sep 25, 2009 at 6:05 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Hi Ingo,
>
> The x86-64 implementation of iopl was buggy because it never ended up calling
> set_iopl_mask().  This had no effect on native sys_iopl (because set_iopl_mask
> is normally no-op on 64-bit), but it ended up never calling the pvop, which caused
> iopl to have no effect on 64-bit Xen guests.
>
> The two functions are needlessly different anyway.  This patch just unifies them
> into a single function which is mostly derived from the 32-bit version.
>
> Thanks,
>        J
>
> The following changes since commit c44c9ec0f38b939b3200436e3aa95c1aa83c41c7:
>  Jeremy Fitzhardinge (1):
>        x86: split NX setup into separate file to limit unstack-protected code
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix
>
> Jeremy Fitzhardinge (1):
>      x86: unify sys_iopl
>
>  arch/x86/include/asm/syscalls.h |    8 +++-----
>  arch/x86/kernel/ioport.c        |   11 ++---------
>  2 files changed, 5 insertions(+), 14 deletions(-)
>
> From 8dbb1d168eb8be6bf43d123fdfb3ba3b03762e62 Mon Sep 17 00:00:00 2001
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date: Wed, 23 Sep 2009 16:35:24 -0700
> Subject: [PATCH] x86: unify sys_iopl
>
> The 32 and 64-bit versions of sys_iopl were needlessly different:
>  - The 32-bit version ignored its function argument and directly
>   fetched the parameter from struct regs, presumably code dating
>   from the neolithic era.
>  - The 64-bit version never called set_iopl_mask().  Usually this
>   is a no-op for 64-bit, but it is also a pvop, which meant that
>   that iopl never worked for 64-bit guests under Xen.
>  - Both versions use the archaic style of getting pt_regs passed
>   to them.  We can get the current pt_regs with task_pt_regs, which
>   avoids worrying about the fine details of stack layout.
>
> We can use the body of the 32-bit function with a few small
> adjustments to the function definition.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
> index 372b76e..5336ce2 100644
> --- a/arch/x86/include/asm/syscalls.h
> +++ b/arch/x86/include/asm/syscalls.h
> @@ -33,11 +33,11 @@ long sys_rt_sigreturn(struct pt_regs *);
>  asmlinkage int sys_set_thread_area(struct user_desc __user *);
>  asmlinkage int sys_get_thread_area(struct user_desc __user *);
>
> -/* X86_32 only */
> -#ifdef CONFIG_X86_32
>  /* kernel/ioport.c */
> -long sys_iopl(struct pt_regs *);
> +asmlinkage long sys_iopl(unsigned int);
>
> +/* X86_32 only */
> +#ifdef CONFIG_X86_32
>  /* kernel/process_32.c */
>  int sys_clone(struct pt_regs *);
>  int sys_execve(struct pt_regs *);
> @@ -70,8 +70,6 @@ int sys_vm86(struct pt_regs *);
>  #else /* CONFIG_X86_32 */
>
>  /* X86_64 only */
> -/* kernel/ioport.c */
> -asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
>
>  /* kernel/process_64.c */
>  asmlinkage long sys_clone(unsigned long, unsigned long,
> diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
> index 99c4d30..bad4f22 100644
> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -119,11 +119,10 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
>        return 0;
>  }
>
> -#ifdef CONFIG_X86_32
> -long sys_iopl(struct pt_regs *regs)
> +asmlinkage long sys_iopl(unsigned int level)
>  {
> -       unsigned int level = regs->bx;
>        struct thread_struct *t = &current->thread;
> +       struct pt_regs *regs = task_pt_regs(current);
>        int rc;
>
>        rc = do_iopl(level, regs);
> @@ -135,9 +134,3 @@ long sys_iopl(struct pt_regs *regs)
>  out:
>        return rc;
>  }
> -#else
> -asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
> -{
> -       return do_iopl(level, regs);
> -}
> -#endif
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
