Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYANRVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYANRVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYANRVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:21:20 -0500
Received: from brick.kernel.dk ([87.55.233.238]:13468 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYANRVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:21:19 -0500
Date: Mon, 14 Jan 2008 18:21:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net
Subject: Re: [patch] rewrite rd
Message-ID: <20080114172114.GR6258@kernel.dk>
References: <20071204042628.GA26636@wotan.suse.de> <20080114164754.GL18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114164754.GL18741@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14 2008, Matthew Wilcox wrote:
> On Tue, Dec 04, 2007 at 05:26:28AM +0100, Nick Piggin wrote:
> > +static void copy_to_brd(struct brd_device *brd, const void *src,
> > +			sector_t sector, size_t n)
> > +{
> > +	struct page *page;
> > +	void *dst;
> > +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> > +	size_t copy;
> > +
> > +	copy = min((unsigned long)n, PAGE_SIZE - offset);
> > +	page = brd_lookup_page(brd, sector);
> > +	BUG_ON(!page);
> > +
> > +	dst = kmap_atomic(page, KM_USER1);
> > +	memcpy(dst + offset, src, copy);
> > +	kunmap_atomic(dst, KM_USER1);
> 
> You're using kmap_atomic, but I see no reason you can't be preempted.
> Don't you need to at least disable preemption while you have stuff
> atomically kmapped?

kmap_atomic() disables preemption through pagefault_disable().

-- 
Jens Axboe

