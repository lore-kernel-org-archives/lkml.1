Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab0BHFGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:06:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34680 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0BHFGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:06:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH] Restrict stack space reservation to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Serge Hallyn <serue@us.ibm.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
In-Reply-To: <18033.1265587672@neuling.org>
References: <10125.1265451732@neuling.org> <18033.1265587672@neuling.org>
Message-Id: <20100208140323.FB52.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Feb 2010 14:06:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> apkm, linus: this or something like it needs to go into 2.6.33 (& 32) to
> fix 'ulimit -s'.  

"fix ulimit -s" is too cool explanation ;-)
we are not ESPer. please consider to provide what bug is exist.


> Mikey
> 
> [PATCH] Restrict stack space reservation to rlimit
> 
> When reserving stack space for a new process, make sure we're not
> attempting to allocate more than rlimit allows.
> 
> Also, reserve the same stack size independent of page size.

Why do we need page size independent stack size? It seems to have
compatibility breaking risk.


> 
> This fixes a bug unmasked by fc63cf237078c86214abcb2ee9926d8ad289da9b
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: stable@kernel.org
> ---
>  fs/exec.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: clone1/fs/exec.c
> ===================================================================
> --- clone1.orig/fs/exec.c
> +++ clone1/fs/exec.c
> @@ -554,7 +554,7 @@ static int shift_arg_pages(struct vm_are
>  	return 0;
>  }
>  
> -#define EXTRA_STACK_VM_PAGES	20	/* random */
> +#define EXTRA_STACK_VM_SIZE	81920UL	/* randomly 20 4K pages */
>  
>  /*
>   * Finalizes the stack vm_area_struct. The flags and permissions are updated,
> @@ -627,10 +627,13 @@ int setup_arg_pages(struct linux_binprm 
>  			goto out_unlock;
>  	}
>  
> +	stack_base = min(EXTRA_STACK_VM_SIZE,
> +			 current->signal->rlim[RLIMIT_STACK].rlim_cur) -
> +		PAGE_SIZE;
>  #ifdef CONFIG_STACK_GROWSUP
> -	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	stack_base = vma->vm_end + stack_base;
>  #else
> -	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> +	stack_base = vma->vm_start - stack_base;
>  #endif
>  	ret = expand_stack(vma, stack_base);
>  	if (ret)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



