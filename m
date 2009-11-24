Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbZKXUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbZKXUtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933396AbZKXUtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:49:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932770AbZKXUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:49:21 -0500
Date: Tue, 24 Nov 2009 12:48:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091124124830.395115a0.akpm@linux-foundation.org>
In-Reply-To: <20091122235539.be1f7814.isloginov@gmail.com>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
	<20091121152633.8c79e341.akpm@linux-foundation.org>
	<20091122124631.908a32c4.isloginov@gmail.com>
	<20091122132915.GA3046@elte.hu>
	<20091122165521.0b488e05.isloginov@gmail.com>
	<20091122104816.b6920ede.akpm@linux-foundation.org>
	<20091122221836.d2d7535d.isloginov@gmail.com>
	<20091122115103.f57f0d0c.akpm@linux-foundation.org>
	<20091122235539.be1f7814.isloginov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 23:55:39 +0300
Ilya Loginov <isloginov@gmail.com> wrote:

> > > I tried this way from the beginning, and to avoid redefinitions I enclose
> > > everything in #if #endif in *.c files. I think it is not very good.
> > > So there are two possibilities.
> > > 
> 
> Ah. I think the first choice is always the best choise. =)
> 
> > In .h:
> > 
> > #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> > extern void rq_flush_dcache_pages(struct request *rq);
> > #else
> > static inline void bio_flush_dcache_pages(struct bio *bi)
> > {
> > }
> > #endif
> > 
> > In .c:
> > 	
> > #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> > void rq_flush_dcache_pages(struct request *rq)
> > {
> > 	struct req_iterator iter;
> > 	struct bio_vec* bvec;
> > 
> > 	rq_for_each_segment(bvec, rq, iter)
> > 		flush_dcache_page(bvec->bv_page);
> > }
> > EXPORT_SYMBOL(rq_flush_dcache_pages);
> > #endif
> 
> This is 2) =)
> 
> Thanks a lot for your help and comments!
> 
> Signed-off-by: Ilya Loginov <isloginov@gmail.com>

Looks good to me, but...

Patch doesn't vaguely apply to linux-next because of arch/sh changes. 
I was going to fix that but afaict your assertion that sh doesn't
implement flush_dcache_page() appears to be untrue in linux-next and a
bit of thought is needed there.

Also, please provide a nice chagnelog whcih describes the change, and
our reasons for making it.

