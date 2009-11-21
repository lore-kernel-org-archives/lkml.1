Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZKUOEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZKUOEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 09:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZKUOEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 09:04:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:63157 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbZKUOEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 09:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Zg1o+sY5mFZZyFO0YoziHNpqgvy2VS0/RVVHY9QJPPhAr3bRr+Jm2i7i4IV345VCFM
         9iupKMao9kvQVggfQb5UvS+fBWmHLiMpI5cToDtmi18oOHVNlDiVDZxmX+P4NF5BxyLr
         wb2Cnvet7N9N/wKEMskStRaKEl/FKK2wX/A3I=
Date: Sat, 21 Nov 2009 17:04:37 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091121170437.0839daef.isloginov@gmail.com>
In-Reply-To: <20091120163751.731781e8.akpm@linux-foundation.org>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 16:37:51 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Your patch fixes bascially the same problem in MTD as we have in AOE. 
> And it introduces the same problem as well - pointless empty
> cache-thrashing loops on architectures for which flush_dcache_page() is
> a no-op.
> 
> What would be better here would be for block core to add a new
> rq_flush_dcache_pages() and bio_flush_dcache_pages() which the drivers
> can call.  Those functions would be a no-op on architectures which
> don't need them.

Do you mean something like this?

in include/linux/bio.h

#ifdef SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS
extern void bio_flush_dcache_pages(struct bio *bi);
#else
static inline void bio_flush_dcache_pages(struct bio *bi)
{
}
#endif /* SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS */

in fs/bio.c

void bio_flush_dcache_pages(struct bio *bi)
{
	int i;
	struct bio_vec* bvec;

	rq_for_each_segment(bvec, bio, i)
		flush_dcache_page(bvec->bv_page);
}

in include/linux/blkdev.h

#ifdef SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS
extern void rq_flush_dcache_pages(struct request *rq);
#else
static inline void rq_flush_dcache_pages(struct request *rq)
{
}
#endif

in block/blk-core.c

void rq_flush_dcache_pages(struct request *rq)
{
	struct req_iterator iter;
	struct bio_vec* bvec;

	rq_for_each_segment(bvec, bio, iter)
		flush_dcache_page(bvec->bv_page);
}

And SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS should be defined
in Kconfigs for each architecture that requires this fix. I think 
this is good solution and if you think the same I can create the
patch.

-- 
Ilya Loginov <isloginov@gmail.com>
