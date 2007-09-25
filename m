Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXIYLPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXIYLPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXIYLPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:15:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54576 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbXIYLPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:15:23 -0400
Date: Tue, 25 Sep 2007 12:15:20 +0100
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       neilb@suse.de, Geert.Uytterhoeven@sonycom.com,
       geoffrey.levand@am.sony.com
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070925111520.GC8076@skynet.ie>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F812DF.4010909@linux.vnet.ibm.com> <20070925102356.GB8076@skynet.ie> <20070925103119.GX2367@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070925103119.GX2367@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/09/07 12:31), Jens Axboe didst pronounce:
> On Tue, Sep 25 2007, Mel Gorman wrote:
> > On (25/09/07 01:11), Kamalesh Babulal didst pronounce:
> > 
> > Hi Kamalesh,
> > 
> > > The build fails with following error
> > > 
> > > CC drivers/block/ps3disk.o
> > > drivers/block/ps3disk.c: In function ???ps3disk_scatter_gather???:
> > > drivers/block/ps3disk.c:115: error: ???bio??? undeclared (first use in this
> > > function)
> > > drivers/block/ps3disk.c:115: error: (Each undeclared identifier is
> > > reported only once
> > > drivers/block/ps3disk.c:115: error: for each function it appears in.)
> > > drivers/block/ps3disk.c:115: error: ???j??? undeclared (first use in this
> > > function)
> > > drivers/block/ps3disk.c:116: error: implicit declaration of function
> > > ???bio_kunmap_bvec???
> > > make[2]: *** [drivers/block/ps3disk.o] Error 1
> > > make[1]: *** [drivers/block] Error 2
> > > make: *** [drivers] Error 2
> > > 
> > > The function bio_kunmap_bvec is missing.I tried checking the git-block.patch
> > > as well as the linux/kernel/git/axboe/linux-2.6-block.git and did not
> > > find this function.
> > > 
> > > Previously this function was replaced by __bio_kunmap_atomic();
> > > This patch does not solves the implicit "declaration of function
> > > ???bio_kunmap_bvec???"
> > > 
> > > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com
> > > <mailto:kamalesh@linux.vnet.ibm.com>>
> > 
> > Your mailer appears to have mangled both your signoff and the whitespace in
> > the patch and it does not apply. However, fixing it does not solve the problem
> > because of this mysterious bio_kunmap_bvec() that is only referenced by this
> > driver. Was it accidently added during the addition of sg chaining support?
> 
> This should fix things up.
> 

This builds although I lack the hardware to really test it. However, in
2.6.23-rc8-mm1 it collides with git-block-ps3disk-fix.patch. This is a
version on top of that stack but I guess the best thing to do is replace
git-block-ps3disk-fix.patch with Jens patch once it is signed off.

Not signing off because this is just a rebase. Assuming the other one
gets signed off, consider it;

Acked-by: Mel Gorman <mel@csn.ul.ie>

--- 

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc8-mm1-clean/drivers/block/ps3disk.c linux-2.6.23-rc8-mm1-fix-ps3disk/drivers/block/ps3disk.c
--- linux-2.6.23-rc8-mm1-clean/drivers/block/ps3disk.c	2007-09-25 12:05:40.000000000 +0100
+++ linux-2.6.23-rc8-mm1-fix-ps3disk/drivers/block/ps3disk.c	2007-09-25 12:09:19.000000000 +0100
@@ -106,14 +106,14 @@ static void ps3disk_scatter_gather(struc
 			(unsigned long)iter.bio->bi_sector);
 
 		size = bvec->bv_len;
-		buf = bvec_kmap_irq(bvec, flags);
+		buf = bvec_kmap_irq(bvec, &flags);
 		if (gather)
 			memcpy(dev->bounce_buf+offset, buf, size);
 		else
 			memcpy(buf, dev->bounce_buf+offset, size);
 		offset += size;
-		flush_kernel_dcache_page(bio_iovec_idx(iter.bio, iter.i)->bv_page);
-		bio_kunmap_bvec(bvec, flags);
+		flush_kernel_dcache_page(bvec->bv_page);
+		bvec_kunmap_irq(buf, &flags);
 		i++;
 	}
 }

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
