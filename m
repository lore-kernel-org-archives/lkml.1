Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYHGVqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYHGVqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHGVqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:46:45 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:34281
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYHGVqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:46:45 -0400
Date: Thu, 7 Aug 2008 23:46:42 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
Message-ID: <20080807214642.GQ31535@duo.random>
References: <20080804130317.994042639@chello.nl> <1218108349.8625.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218108349.8625.25.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 01:25:49PM +0200, Peter Zijlstra wrote:
> Index: linux-2.6/mm/mmap.c
> ===================================================================
> --- linux-2.6.orig/mm/mmap.c
> +++ linux-2.6/mm/mmap.c
> @@ -2358,11 +2358,17 @@ int mm_take_all_locks(struct mm_struct *
>  	for (vma = mm->mmap; vma; vma = vma->vm_next) {
>  		if (signal_pending(current))
>  			goto out_unlock;
> -		if (vma->anon_vma)
> -			vm_lock_anon_vma(mm, vma->anon_vma);
>  		if (vma->vm_file && vma->vm_file->f_mapping)
>  			vm_lock_mapping(mm, vma->vm_file->f_mapping);
>  	}
> +
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if (signal_pending(current))
> +			goto out_unlock;
> +		if (vma->anon_vma)
> +			vm_lock_anon_vma(mm, vma->anon_vma);
> +	}
> +
>  	ret = 0;

I'd suggest to add a comment to document this is just to reduce the
amount of false positives that lockdep emits, otherwise it'll be
optimized away again sooner or later I guess. I'm fine either ways
even if this runs a bit slower. Note that I _strongly_fully_ support
this kind of lockdep changes like above because those are to
accommodate check_noncircular, which is very useful feature of
prove-locking and it can find bugs that would otherwise go unnoticed
(even if it clearly emits false positives at will like above).

As for 8/7 you know my opinion from somebody who's way beyond the
point: check_deadlock should be dropped and we'd rather spend time
incorporating kdb/nlkd/whatever if sysrq/nmiwatchdog/kgdb aren't
already friendly enough for casual driver developers who may not be
able to read assembly or setup kgdb, to make a recursion deadlock
trivial to identify by other means (furthermore if those developers
can't use sysrq/nmiwatchdog/kgdb/systemtap a real debugger will help
them for many others things like singlestepping so they don't have to
add printk all over the place to debug). So I really dislike 8/7 and
furthermore I doubt it works because with regular kvm I get 57 vmas
filebacked alone, did you test 8/7, I didn't yet but I can test if you
didn't. It's true mmu notifier registration happens at the very early
stage of vm creation but most libs are loaded by the dynamic linker
before it. In any case instead of 8/7 I prefer my trylock patch than
to try to accomodate useless check_deadlock (again useless from
someone who's beyond the point, agree to disagree here).

Thanks for the help in cleaning up these lockdep bits!
