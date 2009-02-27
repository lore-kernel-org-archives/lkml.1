Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZB0Lzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZB0Lzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZB0Lz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:55:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:49708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZB0Lz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:55:26 -0500
Date: Fri, 27 Feb 2009 12:55:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: iozone regression with 2.6.29-rc6
Message-ID: <20090227115520.GC21296@wotan.suse.de>
References: <1235726039.11610.243.camel@minggr> <1235728154.24401.55.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235728154.24401.55.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 10:49:14AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-02-27 at 17:13 +0800, Lin Ming wrote:
> > bisect locates below commits,
> > 
> > commit 1cf6e7d83bf334cc5916137862c920a97aabc018
> > Author: Nick Piggin <npiggin@suse.de>
> > Date:   Wed Feb 18 14:48:18 2009 -0800
> > 
> >     mm: task dirty accounting fix
> > 
> >     YAMAMOTO-san noticed that task_dirty_inc doesn't seem to be called properly for
> >     cases where set_page_dirty is not used to dirty a page (eg. mark_buffer_dirty).
> > 
> >     Additionally, there is some inconsistency about when task_dirty_inc is
> >     called.  It is used for dirty balancing, however it even gets called for
> >     __set_page_dirty_no_writeback.
> > 
> >     So rather than increment it in a set_page_dirty wrapper, move it down to
> >     exactly where the dirty page accounting stats are incremented.
> > 
> >     Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> >     Signed-off-by: Nick Piggin <npiggin@suse.de>
> >     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > 
> > below data in parenthesis is the result after above commit reverted, for example,
> > -10% (+2%) means,
> > iozone has ~10% regression with 2.6.29-rc6 compared with 2.6.29-rc5.
> > and
> > iozone has ~2% improvement with 2.6.29-rc6-revert-1cf6e7d compared with 2.6.29-rc5.
> > 
> > 
> > 			4P dual-core HT	 	2P qual-core  	2P qual-core HT
> > 			tulsa		   	stockley	Nehalem
> > 			--------------------------------------------------------
> > iozone-rewrite		-10% (+2%)		-8% (0%)	-10% (-7%)
> > iozone-rand-write	-50% (0%)		-20% (+10%)
> > iozone-read					-13% (0%)
> > iozone-write					-28% (-1%)
> > iozone-reread							-5% (-1%)
> > iozone-mmap-read						-7% (+2%)
> > iozone-mmap-reread						-7% (+2%)
> > iozone-mmap-rand-read						-7% (+3%)
> > iozone-mmap-rand-write						-5% (0%)
> 
> Ugh, that's unexpected..
> 
> So 'better' accounting leads to worse performance, which would indicate
> we throttle more.
> 
> I take it you machine has gobs of memory.
> 
> Does something like the below help any?

Shall we revert this for 2.6.29, then? And try to improve it in the next
cycle? Are we looking at a several more weeks before 2.6.29, or do we
prefer not to try tweaking heuristics at this point?

 
> ---
> Subject: mm: bdi: tweak task dirty penalty
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Feb 27 10:41:22 CET 2009
> 
> Penalizing heavy dirtiers with 1/8-th the total dirty limit might be rather
> excessive on large memory machines. Use sqrt to scale it sub-linearly.
> 
> Update the comment while we're there.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/page-writeback.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.orig/mm/page-writeback.c
> +++ linux-2.6/mm/page-writeback.c
> @@ -293,17 +293,21 @@ static inline void task_dirties_fraction
>  }
>  
>  /*
> - * scale the dirty limit
> + * Task specific dirty limit:
>   *
> - * task specific dirty limit:
> + *   dirty -= 8 * sqrt(dirty) * p_{t}
>   *
> - *   dirty -= (dirty/8) * p_{t}
> + * Penalize tasks that dirty a lot of pages by lowering their dirty limit. This
> + * avoids infrequent dirtiers from getting stuck in this other guys dirty
> + * pages.
> + *
> + * Use a sub-linear function to scale the penalty, we only need a little room.
>   */
>  static void task_dirty_limit(struct task_struct *tsk, long *pdirty)
>  {
>  	long numerator, denominator;
>  	long dirty = *pdirty;
> -	u64 inv = dirty >> 3;
> +	u64 inv = 8*int_sqrt(dirty);
>  
>  	task_dirties_fraction(tsk, &numerator, &denominator);
>  	inv *= numerator;
> 
