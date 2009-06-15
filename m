Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZFOWdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZFOWdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZFOWdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:33:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:45529 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZFOWdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EyjmcqhXbs98c45xg6lYM9SjCYeSA4XuK9zrOuEHTa64i/9UyBdz+7XZmGKuw6tZxu
         QCkmd33KnXQSWya0lFiqmrotIkPfhGfxTXzJsIu43A5npywGreFrMHwe1vUonuEMqZoc
         DByYkHbq4MKXZ/NxPUfZT/9MyPFWDWBtiAnDw=
Date: Tue, 16 Jun 2009 02:33:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stefani@seibold.net, a.p.zijlstra@chello.nl,
       ebiederm@xmission.com, mingo@elte.hu
Subject: Re: + procfs-provide-stack-information-for-threads-v08.patch added
	to -mm tree
Message-ID: <20090615223333.GA8734@x200.localdomain>
References: <200906152202.n5FM25VD021536@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906152202.n5FM25VD021536@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:02:05PM -0700, akpm@linux-foundation.org wrote:
>      procfs-provide-stack-information-for-threads-v08.patch
> --- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v08

> +++ a/fs/proc/array.c
> @@ -321,6 +321,54 @@ static inline void task_context_switch_c
>  			p->nivcsw);
>  }
>  
> +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
> +					struct task_struct *p)
> +{
> +	unsigned long	i;
> +	struct page	*page;
> +	unsigned long	stkpage;
> +
> +	stkpage = KSTK_ESP(p) & PAGE_MASK;
> +
> +#ifdef CONFIG_STACK_GROWSUP
> +	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
> +
> +		page = follow_page(vma, i-PAGE_SIZE, 0);

How can this work?

If stack page got swapped out, you'll get smaller than actual result.

> +
> +		if (!IS_ERR(page) && page)
> +			break;
> +	}
> +	return i - (p->stack_start & PAGE_MASK);
> +#else
> +	for (i = vma->vm_start; i+PAGE_SIZE <= stkpage; i += PAGE_SIZE) {
> +
> +		page = follow_page(vma, i, 0);
> +
> +		if (!IS_ERR(page) && page)
> +			break;
> +	}
> +	return (p->stack_start & PAGE_MASK) - i + PAGE_SIZE;
> +#endif
> +}
> +
> +static inline void task_show_stack_usage(struct seq_file *m,
> +						struct task_struct *task)
> +{
> +	struct vm_area_struct	*vma;
> +	struct mm_struct	*mm = get_task_mm(task);
> +
> +	if (mm) {
> +		down_read(&mm->mmap_sem);
> +		vma = find_vma(mm, task->stack_start);
> +		if (vma)
> +			seq_printf(m, "Stack usage:\t%lu kB\n",
> +				get_stack_usage_in_bytes(vma, task) >> 10);
> +
> +		up_read(&mm->mmap_sem);
> +		mmput(mm);
> +	}
> +}
