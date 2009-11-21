Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZKURyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZKURyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZKURyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:54:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756609AbZKURyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:54:44 -0500
Date: Sat, 21 Nov 2009 09:54:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091121095429.1378828c.akpm@linux-foundation.org>
In-Reply-To: <20091121170437.0839daef.isloginov@gmail.com>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009 17:04:37 +0300 Ilya Loginov <isloginov@gmail.com> wrote:

> On Fri, 20 Nov 2009 16:37:51 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Your patch fixes bascially the same problem in MTD as we have in AOE. 
> > And it introduces the same problem as well - pointless empty
> > cache-thrashing loops on architectures for which flush_dcache_page() is
> > a no-op.
> > 
> > What would be better here would be for block core to add a new
> > rq_flush_dcache_pages() and bio_flush_dcache_pages() which the drivers
> > can call.  Those functions would be a no-op on architectures which
> > don't need them.
> 
> Do you mean something like this?
> 
> in include/linux/bio.h
> 
> #ifdef SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS
> extern void bio_flush_dcache_pages(struct bio *bi);
> #else
> static inline void bio_flush_dcache_pages(struct bio *bi)
> {
> }
> #endif /* SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS */
> 
> in fs/bio.c
> 
> void bio_flush_dcache_pages(struct bio *bi)
> {
> 	int i;
> 	struct bio_vec* bvec;
> 
> 	rq_for_each_segment(bvec, bio, i)
> 		flush_dcache_page(bvec->bv_page);
> }
> 
> in include/linux/blkdev.h
> 
> #ifdef SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS
> extern void rq_flush_dcache_pages(struct request *rq);
> #else
> static inline void rq_flush_dcache_pages(struct request *rq)
> {
> }
> #endif
> 
> in block/blk-core.c
> 
> void rq_flush_dcache_pages(struct request *rq)
> {
> 	struct req_iterator iter;
> 	struct bio_vec* bvec;
> 
> 	rq_for_each_segment(bvec, bio, iter)
> 		flush_dcache_page(bvec->bv_page);
> }
> 
> And SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS should be defined
> in Kconfigs for each architecture that requires this fix.

yep, that would work.

The one somewhat fragile thing is that we'll end up in a situation
where an architecture could implement a real flush_dcache_page(), but
would forget to set SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS.  Or
vice versa.  To make things reliable it would be good to cause a
compilation failure in that case.

One way of addressing this is to

- change every arch/*/include/asm/cacheflush.h to include asm-generic/cacheflush.h

- put #ifndef SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS wrappers around all content
  in asm-generic/cacheflush

So it the above mistake happens, we'll get lots of duplicated
definitions, or no definitions at all (I think).

> I think 
> this is good solution and if you think the same I can create the
> patch.

Thanks.
