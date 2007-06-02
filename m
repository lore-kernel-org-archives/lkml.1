Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbXFBQh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbXFBQh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 12:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbXFBQhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 12:37:18 -0400
Received: from brick.kernel.dk ([80.160.20.94]:3207 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670AbXFBQhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 12:37:17 -0400
Date: Sat, 2 Jun 2007 18:35:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070602163553.GJ32105@kernel.dk>
References: <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org> <20070602150104.GH32105@kernel.dk> <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02 2007, Linus Torvalds wrote:
> 
> 
> On Sat, 2 Jun 2007, Jens Axboe wrote:
> >
> > splice() WILL return EAGAIN, but in that case it should have triggered
> > the read-ahead and thus started some IO.
> 
> That's not enough.
> 
> If the IO has already been started, splice needs to wait.

But splice doesn't know, page_cache_readahead() may not have started
anything.

> > For the from-file case, see __generic_file_splice_read(). splice does:
> > 
> >        if (!PageUptodate(page)) {
> >                /*
> >                 * If in nonblock mode then dont block on
> >                 * waiting
> >                 * for an in-flight io page
> >                 */
> >                if (flags & SPLICE_F_NONBLOCK) {
> >                        if (TestSetPageLocked(page))
> >                                break;
> >                } else
> >                        lock_page(page);
> 
> Yeah, that's just wrong.
> 
> Your suggested:
> 
> >       if ((flags & SPLICE_F_NONBLOCK) && spd.nr_pages) {
> >               if (TestSetPageLocked(page))
> >                       break;
> >       } else
> >               lock_page(page);
> > 
> > should do that - always block for the first page and potentially return
> > a partial results for the remaining pages that read-ahead kicked into
> > gear.
> 
> would work, but I suspect that for a server, returning EAGAIN once is 
> actually the best option - if it has a select() loop, and something else 
> is running, the "return EAGAIN once" actually makes tons of sense (it 
> would basically boil down to the kernel effectively saying "ok, try 
> anything else you might have pending in your queues first, if you get back 
> to me, I'll block then").

Well then the current code should work, _provided_ that we know
read-ahead kicked off the IO. Well almost, still needs a bit of
tweaking, with some knowledge of whether page_cache_readahead() actually
called into read_pages() or not.

-- 
Jens Axboe

