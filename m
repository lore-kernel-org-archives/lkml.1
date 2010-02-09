Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0BII7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 03:59:31 -0500
Received: from ozlabs.org ([203.10.76.45]:35108 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab0BII73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 03:59:29 -0500
From: Michael Neuling <mikey@neuling.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Americo Wang <xiyou.wangcong@gmail.com>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
Subject: Re: [PATCH] Restrict initial stack space expansion to rlimit
In-reply-to: <20100209154141.03F0.A69D9226@jp.fujitsu.com>
References: <20100208161014.7C6D.A69D9226@jp.fujitsu.com> <1273.1265695885@neuling.org> <20100209154141.03F0.A69D9226@jp.fujitsu.com>
Comments: In-reply-to KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
   message dated "Tue, 09 Feb 2010 15:46:50 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 09 Feb 2010 19:59:27 +1100
Message-ID: <11046.1265705967@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20100209154141.03F0.A69D9226@jp.fujitsu.com> you wrote:
> > When reserving stack space for a new process, make sure we're not
> > attempting to expand the stack by more than rlimit allows.
> > 
> > This fixes a bug caused by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba "mm:
> > variable length argument support" and unmasked by
> > fc63cf237078c86214abcb2ee9926d8ad289da9b "exec: setup_arg_pages() fails
> > to return errors".  This bug means when limiting the stack to less the
> > 20*PAGE_SIZE (eg. 80K on 4K pages or 'ulimit -s 79') all processes will
> > be killed before they start.  This is particularly bad with 64K pages,
> > where a ulimit below 1280K will kill every process.
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > Cc: stable@kernel.org
> > ---
> > Attempts to answer comments from Kosaki Motohiro.
> > 
> > Tested on PPC only, hence !CONFIG_STACK_GROWSUP.  Someone should
> > probably ACK for an arch with CONFIG_STACK_GROWSUP.
> > 
> > As noted, stable needs the same patch, but 2.6.32 doesn't have the
> > rlimit() helper.
> > 
> >  fs/exec.c |   21 ++++++++++++++++++---
> >  1 file changed, 18 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6-ozlabs/fs/exec.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/fs/exec.c
> > +++ linux-2.6-ozlabs/fs/exec.c
> > @@ -555,6 +555,7 @@ static int shift_arg_pages(struct vm_are
> >  }
> >  
> >  #define EXTRA_STACK_VM_PAGES	20	/* random */
> > +#define ALIGN_DOWN(addr,size)	((addr)&(~((size)-1)))
> >  
> >  /*
> >   * Finalizes the stack vm_area_struct. The flags and permissions are updat
ed,
> > @@ -570,7 +571,7 @@ int setup_arg_pages(struct linux_binprm 
> >  	struct vm_area_struct *vma = bprm->vma;
> >  	struct vm_area_struct *prev = NULL;
> >  	unsigned long vm_flags;
> > -	unsigned long stack_base;
> > +	unsigned long stack_base, stack_expand, stack_expand_lim, stack_size;
> >  
> >  #ifdef CONFIG_STACK_GROWSUP
> >  	/* Limit stack size to 1GB */
> > @@ -627,10 +628,24 @@ int setup_arg_pages(struct linux_binprm 
> >  			goto out_unlock;
> >  	}
> >  
> > +	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> > +	stack_size = vma->vm_end - vma->vm_start;
> > +	if (rlimit(RLIMIT_STACK) < stack_size)
> > +		stack_expand_lim = 0; /* don't shrick the stack */
> > +	else
> > +		/*
> > +		 * Align this down to a page boundary as expand_stack
> > +		 * will align it up.
> > +		 */
> > +		stack_expand_lim = ALIGN_DOWN(rlimit(RLIMIT_STACK) - stack_size
,
> > +					      PAGE_SIZE);
> > +	/* Initial stack must not cause stack overflow. */
> > +	if (stack_expand > stack_expand_lim)
> > +		stack_expand = stack_expand_lim;
> >  #ifdef CONFIG_STACK_GROWSUP
> > -	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> > +	stack_base = vma->vm_end + stack_expand;
> >  #else
> > -	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> > +	stack_base = vma->vm_start - stack_expand;
> >  #endif
> >  	ret = expand_stack(vma, stack_base);
> >  	if (ret)
> 
> Umm.. It looks correct. but the nested complex if statement seems a bit ugly.
> Instead, How about following?

I don't like the duplicated code in the #ifdef/else but I can live with it.

> note: it's untested.

Works for me on ppc64 with 4k and 64k pages.  Thanks!

I'd still like someone with a CONFIG_STACK_GROWSUP arch to test/ACK it
as well.

Mikey

> 
> 
> 
> ===============
> From: Michael Neuling <mikey@neuling.org>
> Subject: Restrict initial stack space expansion to rlimit
> 
> When reserving stack space for a new process, make sure we're not
> attempting to expand the stack by more than rlimit allows.
> 
> This fixes a bug caused by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba "mm:
> variable length argument support" and unmasked by
> fc63cf237078c86214abcb2ee9926d8ad289da9b "exec: setup_arg_pages() fails
> to return errors".  This bug means when limiting the stack to less the
> 20*PAGE_SIZE (eg. 80K on 4K pages or 'ulimit -s 79') all processes will
> be killed before they start.  This is particularly bad with 64K pages,
> where a ulimit below 1280K will kill every process.
> 
> [kosaki.motohiro@jp.fujitsu.com: cleanups]
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: stable@kernel.org
> ---
> Attempts to answer comments from Kosaki Motohiro.
> 
> Tested on PPC only, hence !CONFIG_STACK_GROWSUP.  Someone should
> probably ACK for an arch with CONFIG_STACK_GROWSUP.
> 
> As noted, stable needs the same patch, but 2.6.32 doesn't have the
> rlimit() helper.
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 6f7fb0c..325bad4 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -573,6 +573,9 @@ int setup_arg_pages(struct linux_binprm *bprm,
>  	struct vm_area_struct *prev = NULL;
>  	unsigned long vm_flags;
>  	unsigned long stack_base;
> +	unsigned long stack_size;
> +	unsigned long stack_expand;
> +	unsigned long rlim_stack;
>  
>  #ifdef CONFIG_STACK_GROWSUP
>  	/* Limit stack size to 1GB */
> @@ -629,10 +632,27 @@ int setup_arg_pages(struct linux_binprm *bprm,
>  			goto out_unlock;
>  	}
>  
> +	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	stack_size = vma->vm_end - vma->vm_start;
> +	/*
> +	 * Align this down to a page boundary as expand_stack
> +	 * will align it up.
> +	 */
> +	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
> +	if (rlim_stack < stack_size)
> +		rlim_stack = stack_size;
>  #ifdef CONFIG_STACK_GROWSUP
> -	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	if (stack_size + stack_expand > rlim_stack) {
> +		stack_base = vma->vm_start + rlim_stack;
> +	} else {
> +		stack_base = vma->vm_end + stack_expand;
> +	}
>  #else
> -	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	if (stack_size + stack_expand > rlim_stack) {
> +		stack_base = vma->vm_end - rlim_stack;
> +	} else {
> +		stack_base = vma->vm_start - stack_expand;
> +	}
>  #endif
>  	ret = expand_stack(vma, stack_base);
>  	if (ret)
> 
> 
> 
