Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYGaVat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYGaVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYGaVak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:30:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbYGaVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:30:39 -0400
Date: Thu, 31 Jul 2008 14:30:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: halesh.s@india.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: mlock() return value issue in kernel 2.6.23.17
Message-Id: <20080731143032.2a211c18.akpm@linux-foundation.org>
In-Reply-To: <20080731211811.3CA9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <loom.20080731T100441-892@post.gmane.org>
	<20080731211811.3CA9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 21:50:06 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > This testcase results with mlock failure with errno 14 that is EFAULT, but this 
> > has been no where reported that mlock will give EFAULT, When i tested the same 
> > on older kernel like 2.6.18, I got the correct result i.e errno 12 (ENOMEM).
> > 
> > 
> > I think in source code mlock(2),  setting errno ENOMEM has been missed in 
> > do_mlock() , on mlock_fixup() failure.
> > 
> > Let me know if my understanding is wrong!
> 
> Hi Halesh,
> 
> Could you try to following patch?
> 
> -----------------------------------------------------
> SUSv3 require following behavior to mlock(2).
> 
> [ENOMEM]
>     Some or all of the address range specified by the addr and
>     len arguments does not correspond to valid mapped pages 
>     in the address space of the process.
> 
> [EAGAIN]
>     Some or all of the memory identified by the operation could not 
>     be locked when the call was made. 
> 
> 
> This rule isn't so nice and slighly strange.
> but many people think POSIX/SUS compliance is important.
> 
> 
> ---
>  mm/memory.c |   16 +++++++++++++---
>  mm/mlock.c  |    2 --
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> Index: b/mm/memory.c
> ===================================================================
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2736,16 +2736,26 @@ int make_pages_present(unsigned long add
>  
>  	vma = find_vma(current->mm, addr);
>  	if (!vma)
> -		return -1;
> +		return -ENOMEM;
>  	write = (vma->vm_flags & VM_WRITE) != 0;
>  	BUG_ON(addr >= end);
>  	BUG_ON(end > vma->vm_end);
>  	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
>  	ret = get_user_pages(current, current->mm, addr,
>  			len, write, 0, NULL, NULL);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		/*
> +		   SUS require strange return value to mlock
> +		    - invalid addr generate to ENOMEM.
> +		    - out of memory should generate EAGAIN.
> +		*/
> +		if (ret == -EFAULT)
> +			ret = -ENOMEM;
> +		else if (ret == -ENOMEM)
> +			ret = -EAGAIN;
>  		return ret;
> -	return ret == len ? 0 : -1;
> +	}
> +	return ret == len ? 0 : -ENOMEM;
>  }
>  
>  #if !defined(__HAVE_ARCH_GATE_AREA)
> Index: b/mm/mlock.c
> ===================================================================
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -78,8 +78,6 @@ success:
>  
>  	mm->locked_vm -= pages;
>  out:
> -	if (ret == -ENOMEM)
> -		ret = -EAGAIN;
>  	return ret;
>  }
>  
> 

I assume that you tested it too?

If it comes down to a choice between complying with SuS versus
complying with earlier Linux versions then we'd usually prefer to
comply with earlier Linux versions.

I queued this, but would prefer to await confirmation that it has been
tested to take us back to the 2.6.18 interface, please.

Also, please send a Signed-off-by: for this change.
