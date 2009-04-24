Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZDXIL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZDXIL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZDXILN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:11:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbZDXILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:11:12 -0400
Date: Fri, 24 Apr 2009 01:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: a.p.zijlstra@chello.nl, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [rfc 1/2] x86, bts, mm: buffer allocation
Message-Id: <20090424010326.e85ddb93.akpm@linux-foundation.org>
In-Reply-To: <20090424095143.A30265@sedona.ch.intel.com>
References: <20090424095143.A30265@sedona.ch.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 09:51:43 +0200 Markus Metzger <markus.t.metzger@intel.com> wrote:

> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -629,38 +629,36 @@ void user_shm_unlock(size_t size, struct
>  	free_uid(user);
>  }
>  
> -void *alloc_locked_buffer(size_t size)
> +int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
> +			  size_t size)
>  {
> -	unsigned long rlim, vm, pgsz;
> -	void *buffer = NULL;
> +	unsigned long lim, vm, pgsz;
> +	int error = -ENOMEM;
>  
>  	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
>  
> -	down_write(&current->mm->mmap_sem);
> -
> -	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> -	vm   = current->mm->total_vm + pgsz;
> -	if (rlim < vm)
> -		goto out;
> +	down_write(&mm->mmap_sem);
>  
> -	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
> -	vm   = current->mm->locked_vm + pgsz;
> -	if (rlim < vm)
> +	lim = rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> +	vm   = mm->total_vm + pgsz;
> +	if (lim < vm)
>  		goto out;
>  
> -	buffer = kzalloc(size, GFP_KERNEL);
> -	if (!buffer)
> +	lim = rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
> +	vm   = mm->locked_vm + pgsz;
> +	if (lim < vm)
>  		goto out;
>  
> -	current->mm->total_vm  += pgsz;
> -	current->mm->locked_vm += pgsz;
> +	mm->total_vm  += pgsz;
> +	mm->locked_vm += pgsz;
>  
> +	error = 0;
>   out:
> -	up_write(&current->mm->mmap_sem);
> -	return buffer;
> +	up_write(&mm->mmap_sem);
> +	return error;
>  }

Looks OK to me.  Getting that GFP_KERNEL allocation out from inside
mmap_sem can only be good.

