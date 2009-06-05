Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZFETNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZFETNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZFETNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:13:14 -0400
Received: from www84.your-server.de ([213.133.104.84]:47546 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZFETNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:13:14 -0400
Subject: Re: [patch] procfs: provide stack information for threads
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090604142358.95af81d5.akpm@linux-foundation.org>
References: <1238511505.364.61.camel@matrix>
	 <20090401193135.GA12316@elte.hu> <1244146873.20012.6.camel@wall-e>
	 <20090604142358.95af81d5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 21:12:56 +0200
Message-Id: <1244229176.31924.13.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
> > +					struct task_struct *p)
> > +{
> > +	unsigned long	i;
> > +	struct page	*page;
> > +	unsigned long	stkpage;
> > +
> > +	stkpage = KSTK_ESP(p) & PAGE_MASK;
> > +
> > +#ifdef CONFIG_STACK_GROWSUP
> > +	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
> > +
> > +		page = follow_page(vma, i-PAGE_SIZE, 0);
> > +
> > +		if (!IS_ERR(page) && page)
> > +			break;
> > +	}
> > +	return i - (p->stack_start & PAGE_MASK);
> > +#else
> > +	for (i = vma->vm_start; i+PAGE_SIZE <= stkpage; i += PAGE_SIZE) {
> > +
> > +		page = follow_page(vma, i, 0);
> > +
> > +		if (!IS_ERR(page) && page)
> > +			break;
> > +	}
> > +	return (p->stack_start & PAGE_MASK) - i + PAGE_SIZE;
> > +#endif
> > +}
> > +
> > +static inline void task_show_stack_usage(struct seq_file *m,
> > +						struct task_struct *p)
> > +{
> > +	struct vm_area_struct	*vma;
> > +	struct mm_struct	*mm;
> > +
> > +	mm = get_task_mm(p);
> > +
> > +	if (mm) {
> > +		vma = find_vma(mm, p->stack_start);
> > +
> > +		if (vma)
> > +			seq_printf(m, "Stack usage:\t%lu kB\n",
> > +				get_stack_usage_in_bytes(vma, p) >> 10);
> > +
> > +		mmput(mm);
> > +	}
> > +}
> 
> Both follow_page() and find_vma() require locking: down_read(mmap_sem)
> or down_write(mmap_sem).  down_read() is appropriate here.
> 

Didn't know that this require a lock, but i will fix this.

> > +				} else {
> > +					unsigned long stack_start;
> > +					struct proc_maps_private *pmp;
> > +
> > +					pmp = m->private;
> > +					stack_start = pmp->task->stack_start;
> > +
> > +					if (vma->vm_start <= stack_start &&
> > +					    vma->vm_end >= stack_start) {
> > +						pad_len_spaces(m, len);
> > +						seq_printf(m,
> > +						 "[thread stack: %08lx]",
> > +						 stack_start);
> > +					}
> 
> You're making changes to the user interface but it's not terribly clear
> what they look like.  Please include sample output from the affected
> procfs files so that we can review the proposed changes.
> 

This change to the user interface was suggest by ingo molnar. I will add
the sample output in the next version.

> Please update the userspace documentation to reflect the changes. 
> Documentation/filesystems/proc.txt documents VmStk, so probably that is
> the appropriate place.
> 

Good idea, but the proc.txt documentation about /proc/<pid>/status (line
140) and the contents of the /proc/<pid>/stat file (line 192) is
complete outdated. And there is also no documentation
about /proc/<pid>/*maps. 

So i want to try to fix the missing documentation in proc.txt in a
separate patch. Will this okay by you?

Greetings


