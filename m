Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYCJSdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYCJSdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYCJSc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:32:59 -0400
Received: from waste.org ([66.93.16.53]:36295 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbYCJSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:32:58 -0400
Subject: Re: [PATCH] pagemap: proper read error handling
From: Matt Mackall <mpm@selenic.com>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080308233555.GA21461@dmt>
References: <20080308233555.GA21461@dmt>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 13:32:42 -0500
Message-Id: <1205173962.11669.61.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-08 at 20:35 -0300, Marcelo Tosatti wrote:
> Fix pagemap_read() error handling by releasing acquired resources and
> checking for get_user_pages() partial failure.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Thanks, Marcelo, this all looks good.

Signed-off-by: Matt Mackall <mpm@selenic.com>

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 6dc0334..4206454 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -640,17 +640,17 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  
>  	ret = -EACCES;
>  	if (!ptrace_may_attach(task))
> -		goto out;
> +		goto out_task;
>  
>  	ret = -EINVAL;
>  	/* file position must be aligned */
>  	if (*ppos % PM_ENTRY_BYTES)
> -		goto out;
> +		goto out_task;
>  
>  	ret = 0;
>  	mm = get_task_mm(task);
>  	if (!mm)
> -		goto out;
> +		goto out_task;
>  
>  	ret = -ENOMEM;
>  	uaddr = (unsigned long)buf & PAGE_MASK;
> @@ -658,7 +658,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
>  	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
>  	if (!pages)
> -		goto out_task;
> +		goto out_mm;
>  
>  	down_read(&current->mm->mmap_sem);
>  	ret = get_user_pages(current, current->mm, uaddr, pagecount,
> @@ -668,6 +668,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	if (ret < 0)
>  		goto out_free;
>  
> +	if (ret != pagecount) {
> +		pagecount = ret;
> +		ret = -EFAULT;
> +		goto out_pages;
> +	}
> +
>  	pm.out = buf;
>  	pm.end = buf + count;
>  
> @@ -699,15 +705,17 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  			ret = pm.out - buf;
>  	}
>  
> +out_pages:
>  	for (; pagecount; pagecount--) {
>  		page = pages[pagecount-1];
>  		if (!PageReserved(page))
>  			SetPageDirty(page);
>  		page_cache_release(page);
>  	}
> -	mmput(mm);
>  out_free:
>  	kfree(pages);
> +out_mm:
> +	mmput(mm);
>  out_task:
>  	put_task_struct(task);
>  out:
-- 
Mathematics is the supreme nostalgia of our time.

