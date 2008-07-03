Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYGCHGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYGCHGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYGCG5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:39 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:63799 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753624AbYGCCkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:40:01 -0400
X-Nifty-SrcIP: [210.131.59.195]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=WIth72JjQrOvtFY6cXGHfyFZr/wWdUtOmHjITloY+ToiVMNZxZmdoKEYLcxxISRj8SDjcCP15zAKo/scHRrCZg==  ;
Date: Thu, 03 Jul 2008 10:58:58 +0900 (JST)
Message-Id: <20080703.105858.193690507.takada@mbf.nifty.com>
To: roland@redhat.com
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <20080630210241.93738154077@magilla.localdomain>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
	<20080630210241.93738154077@magilla.localdomain>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Thanks for your right patch.
BTW, are FXSAVE and FXRSTOR instructions device?
Is it right to return ENODEV?
I think I had bettor return EXIO or ENOTSUP. 
If it discussed, tell me URL of tree at lkml.org.

From: Roland McGrath <roland@redhat.com>
Subject: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
Date: Mon, 30 Jun 2008 14:02:41 -0700 (PDT)

> ptrace has always returned only -EIO for all failures to access
> registers.  The user_regset calls are allowed to return a more
> meaningful variety of errors.  The REGSET_XFP calls use -ENODEV
> for !cpu_has_fxsr hardware.  Make ptrace return the traditional
> -EIO instead of the error code from the user_regset call.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/kernel/ptrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index a7835f2..77040b6 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -943,13 +943,13 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
>  		return copy_regset_to_user(child, &user_x86_32_view,
>  					   REGSET_XFP,
>  					   0, sizeof(struct user_fxsr_struct),
> -					   datap);
> +					   datap) ? -EIO : 0;
>  
>  	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
>  		return copy_regset_from_user(child, &user_x86_32_view,
>  					     REGSET_XFP,
>  					     0, sizeof(struct user_fxsr_struct),
> -					     datap);
> +					     datap) ? -EIO : 0;
>  #endif
>  
>  #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
