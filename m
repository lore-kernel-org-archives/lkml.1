Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbXGVI7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbXGVI7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbXGVI7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:59:15 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:56986 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756796AbXGVI7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:59:14 -0400
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <385093918.09754@ustc.edu.cn>
References: <20070721210005.000228000@chello.nl>
	 <20070721210052.497469000@chello.nl>  <385093918.09754@ustc.edu.cn>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 10:59:11 +0200
Message-Id: <1185094751.20032.221.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 16:45 +0800, Fengguang Wu wrote:
> On Sat, Jul 21, 2007 at 11:00:08PM +0200, Peter Zijlstra wrote:
> > Scale the default max readahead size with the system memory size.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  block/ll_rw_blk.c  |    2 +-
> >  include/linux/fs.h |    1 +
> >  mm/readahead.c     |   32 ++++++++++++++++++++++++++++++++
> >  3 files changed, 34 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/block/ll_rw_blk.c
> > ===================================================================
> > --- linux-2.6.orig/block/ll_rw_blk.c
> > +++ linux-2.6/block/ll_rw_blk.c
> > @@ -208,7 +208,7 @@ void blk_queue_make_request(request_queu
> >  	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
> >  	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
> >  	q->make_request_fn = mfn;
> > -	q->backing_dev_info.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
> > +	bdi_ra_init(&q->backing_dev_info);
> 
> fs/fuse/inode.c has another line to be converted.

Drad, right you are. Will grep a bit.

> >  	q->backing_dev_info.state = 0;
> >  	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
> >  	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> > Index: linux-2.6/include/linux/fs.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/fs.h
> > +++ linux-2.6/include/linux/fs.h
> > @@ -1696,6 +1696,7 @@ extern long do_splice_direct(struct file
> >  
> >  extern void
> >  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
> > +extern void bdi_ra_init(struct backing_dev_info *bdi);
> >  extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
> >  extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
> >  extern loff_t remote_llseek(struct file *file, loff_t offset, int origin);
> > Index: linux-2.6/mm/readahead.c
> > ===================================================================
> > --- linux-2.6.orig/mm/readahead.c
> > +++ linux-2.6/mm/readahead.c
> > @@ -42,6 +42,38 @@ file_ra_state_init(struct file_ra_state 
> >  }
> >  EXPORT_SYMBOL_GPL(file_ra_state_init);
> >  
> > +static unsigned long ra_pages;
> > +
> > +static __init int readahead_init(void)
> > +{
> > +	/*
> > +	 * Scale the max readahead window with system memory
> > +	 *
> > +	 *   64M:   128K
> > +	 *  128M:   180K
> > +	 *  256M:   256K
> > +	 *  512M:   360K
> > +	 *    1G:   512K
> > +	 *    2G:   724K
> > +	 *    4G:  1024K
> > +	 *    8G:  1448K
> > +	 *   16G:  2048K
> > +	 */
> > +	ra_pages = int_sqrt(totalram_pages/16);
> > +	if (ra_pages > (2 << (20 - PAGE_SHIFT)))
> > +		ra_pages = 2 << (20 - PAGE_SHIFT);
> 
> We can elaborate on the numbers ;)
> 
> How about the following rules?
> - limit it under 1MB: we have to consider latencies

readahead is done async and we have these cond_resched() things
sprinkled all over, no?

> - make them alignment-friendly, i.e. 128K, 256K, 512K, 1M.

Would that actually matter? but yeah, that seems like a sane suggestion.
roundup_pow_of_two() comes to mind.

> My original plan is to simply do the following:
> 
> - #define VM_MAX_READAHEAD        128     /* kbytes */
> + #define VM_MAX_READAHEAD        512     /* kbytes */

Yeah, the trouble I have with that is that it might adversely affect
tiny systems (although the trash detection might mitigate that impact)

> I'd like to post some numbers to back-up the discussion:
> 
>   readahead   readahead
>        size        miss
>        128K         38%
>        512K         45%
>       1024K         49%
> 
> The numbers are measured on a fresh booted KDE desktop.
> 
> The majority misses come from the larger mmap read-arounds.

the mmap code never gets into readahead unless madvise(MADV_SEQUENTIAL)
is used afaik.

> Sequential readahead hits are pretty high and not quite affected by
> the readahead size, thanks to its size ramp-up process.
> 
> > +
> > +	return 0;
> > +}
> > +
> > +subsys_initcall(readahead_init);
> 
> Remove the global ra_pages and fold readahead_init() into bdi_ra_init()?
> bdi_ra_init will only be called several times I guess.

I guess we could, this just seemed like a proper setup where more things
could grow into.

