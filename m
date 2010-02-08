Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab0BHGFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:05:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37311 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0BHGFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:05:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH] Restrict stack space reservation to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org, miltonm@bga.com, aeb@cwi.nl
In-Reply-To: <9729.1265607469@neuling.org>
References: <20100208141716.FB55.A69D9226@jp.fujitsu.com> <9729.1265607469@neuling.org>
Message-Id: <20100208145240.FB58.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Feb 2010 15:05:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  
> > > Hi,
> > > 
> > > > Why do we need page size independent stack size? It seems to have
> > > > compatibility breaking risk.
> > > 
> > > I don't think so. The current behaviour is clearly wrong, we dont need a
> > > 16x larger stack just because you went from a 4kB to a 64kB base page
> > > size. The user application stack usage is the same in both cases.
> > 
> > I didn't discuss which behavior is better. Michael said he want to apply
> > his patch to 2.6.32 & 2.6.33. stable tree never accept the breaking
> > compatibility patch.
> > 
> > Your answer doesn't explain why can't we wait it until next merge window.
> > 
> > btw, personally, I like page size indepent stack size. but I'm not sure
> > why making stack size independency is related to bug fix.
> 
> I tend to agree.  
> 
> Below is just the bug fix to limit the reservation size based rlimit.
> We still reserve different stack sizes based on the page size as
> before (unless we hit rlimit of course).

Thanks.

I agree your patch in almost part. but I have very few requests.


> Mikey
> 
> Restrict stack space reservation to rlimit
> 
> When reserving stack space for a new process, make sure we're not
> attempting to allocate more than rlimit allows.
> 
> This fixes a bug cause by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba 
> "mm: variable length argument support" and unmasked by
> fc63cf237078c86214abcb2ee9926d8ad289da9b 
> "exec: setup_arg_pages() fails to return errors".

Your initial mail have following problem use-case. please append it
into the patch description.

	On recent ppc64 kernels, limiting the stack (using 'ulimit -s blah') is
	now more restrictive than it was before.  On 2.6.31 with 4k pages I
	could run 'ulimit -s 16; /usr/bin/test' without a problem.  Now with
	mainline, even 'ulimit -s 64; /usr/bin/test' gets killed.


> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: stable@kernel.org
> ---
>  fs/exec.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-ozlabs/fs/exec.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/fs/exec.c
> +++ linux-2.6-ozlabs/fs/exec.c
> @@ -627,10 +627,13 @@ int setup_arg_pages(struct linux_binprm 
>  			goto out_unlock;
>  	}
>  
> +	stack_base = min(EXTRA_STACK_VM_PAGES * PAGE_SIZE,
> +			 current->signal->rlim[RLIMIT_STACK].rlim_cur -
> +			   PAGE_SIZE);

This line is a bit unclear why "- PAGE_SIZE" is necessary.
personally, I like following likes explicit comments.

	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
	stack_lim = ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur);

	/* Initial stack must not cause stack overflow. */
	if (stack_expand + PAGE_SIZE > stack_lim)
		stack_expand = stack_lim - PAGE_SIZE;

note: accessing rlim_cur require ACCESS_ONCE.


Thought?


>  #ifdef CONFIG_STACK_GROWSUP
> -	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	stack_base = vma->vm_end + stack_base;
>  #else
> -	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	stack_base = vma->vm_start - stack_base;
>  #endif
>  	ret = expand_stack(vma, stack_base);
>  	if (ret)
> 



