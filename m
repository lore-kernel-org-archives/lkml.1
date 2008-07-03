Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbYGCHGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbYGCHGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYGCG5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:41 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:63798 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753608AbYGCCkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:40:01 -0400
X-Nifty-SrcIP: [210.131.59.195]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=xqNmglE12U3zrwF9QU2xVlsRnrvCBRinz3Xlmieo6MiEivCMqkrGmJB+wqw1zjNm+5tO22za3ZSzon2qAM5x+A==  ;
Date: Thu, 03 Jul 2008 11:37:41 +0900 (JST)
Message-Id: <20080703.113741.226796430.takada@mbf.nifty.com>
To: mingo@elte.hu
Cc: roland@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <20080701090204.GA1729@elte.hu>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
	<20080630210241.93738154077@magilla.localdomain>
	<20080701090204.GA1729@elte.hu>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
The Roland's patch is bettor than mine.
Please apply Roland's only. Don't apply both. Either is enough.


From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
Date: Tue, 1 Jul 2008 11:02:04 +0200

> 
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > ptrace has always returned only -EIO for all failures to access 
> > registers.  The user_regset calls are allowed to return a more 
> > meaningful variety of errors.  The REGSET_XFP calls use -ENODEV for 
> > !cpu_has_fxsr hardware.  Make ptrace return the traditional -EIO 
> > instead of the error code from the user_regset call.
> 
> since the original fix is already upstream, i've applied the delta patch 
> below. Should we still do this for v2.6.26 or can we defer it to 
> v2.6.27? As ptrace is the only user of this facility for now this would 
> be an identity transformation AFAICS and the v2.6.26 release is very 
> close.
> 
> 	Ingo
> 
> ---------------->
> Subject: x86 ptrace: fix PTRACE_GETFPXREGS error
> From: Roland McGrath <roland@redhat.com>
> Date: Mon, 30 Jun 2008 14:02:41 -0700 (PDT)
> 
> ptrace has always returned only -EIO for all failures to access
> registers.  The user_regset calls are allowed to return a more
> meaningful variety of errors.  The REGSET_XFP calls use -ENODEV
> for !cpu_has_fxsr hardware.  Make ptrace return the traditional
> -EIO instead of the error code from the user_regset call.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> Cc: stable@kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/i387.c   |    4 ++--
>  arch/x86/kernel/ptrace.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: tip/arch/x86/kernel/i387.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/i387.c
> +++ tip/arch/x86/kernel/i387.c
> @@ -162,7 +162,7 @@ int xfpregs_get(struct task_struct *targ
>  	int ret;
>  
>  	if (!cpu_has_fxsr)
> -		return -EIO;
> +		return -ENODEV;
>  
>  	ret = init_fpu(target);
>  	if (ret)
> @@ -179,7 +179,7 @@ int xfpregs_set(struct task_struct *targ
>  	int ret;
>  
>  	if (!cpu_has_fxsr)
> -		return -EIO;
> +		return -ENODEV;
>  
>  	ret = init_fpu(target);
>  	if (ret)
> Index: tip/arch/x86/kernel/ptrace.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/ptrace.c
> +++ tip/arch/x86/kernel/ptrace.c
> @@ -943,13 +943,13 @@ long arch_ptrace(struct task_struct *chi
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
