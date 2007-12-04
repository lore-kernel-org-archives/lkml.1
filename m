Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXLDNBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXLDNBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXLDNAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:00:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:40631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXLDNAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:00:52 -0500
Date: Tue, 4 Dec 2007 14:00:50 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: [patch] mm: fix XIP file writes
Message-ID: <20071204130050.GB6751@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204032620.aaee039b.akpm@linux-foundation.org> <20071204113549.GA6751@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204113549.GA6751@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 12:35:49PM +0100, Nick Piggin wrote:
> On Tue, Dec 04, 2007 at 03:26:20AM -0800, Andrew Morton wrote:
> > On Tue, 4 Dec 2007 12:21:00 +0100 Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > +	 *
> > > +	 * Cannot support XIP and highmem, because our ->direct_access
> > > +	 * routine for XIP must return memory that is always addressable.
> > > +	 * If XIP was reworked to use pfns and kmap throughout, this
> > > +	 * restriction might be able to be lifted.
> > >  	 */
> > > +	gfp_flags = GFP_NOIO | __GFP_ZERO;
> > > +#ifndef CONFIG_BLK_DEV_XIP
> > > +	gfp_flags |= __GFP_HIGHMEM;
> > > +#endif
> > 
> > A dubious tradeoff?
> 
> On big highmem machines certainly. It may be somewhat useful on small
> memory systems... but having the config option there is nice for a VM
> developer without an s390 easily available ;)
> 
> But don't apply these XIP patches yet -- after a bit more testing I'm
> seeing some data corruption, so I'll have to work out what's going
> wrong with that first.

Here we go. See, brd already found a bug ;)

Can you apply the ext2 XIP patch too? And I'll resend the brd XIP patch.

---

Writing to XIP files at a non-page-aligned offset results in data corruption
because the writes were always sent to the start of the page.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c
+++ linux-2.6/mm/filemap_xip.c
@@ -314,7 +314,7 @@ __xip_file_write(struct file *filp, cons
 		fault_in_pages_readable(buf, bytes);
 		kaddr = kmap_atomic(page, KM_USER0);
 		copied = bytes -
-			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
+			__copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
 		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(page);
 
