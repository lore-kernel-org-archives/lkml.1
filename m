Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYFXMXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYFXMXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYFXMXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:23:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28832 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYFXMXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:23:00 -0400
Date: Tue, 24 Jun 2008 14:22:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
Subject: Re: [rfc patch 3/4] splice: remove confirm from pipe_buf_operations
Message-ID: <20080624122258.GR20851@kernel.dk>
References: <20080621154607.154640724@szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu> <200806242216.41548.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806242216.41548.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24 2008, Nick Piggin wrote:
> On Tuesday 24 June 2008 21:36, Miklos Szeredi wrote:
> > > It's an unfortunate side effect of the read-ahead, I'd much rather just
> > > get rid of that. It _should_ behave like the non-ra case, when a page is
> > > added it merely has IO started on it. So we want to have that be
> > > something like
> > >
> > >         if (!PageUptodate(page) && !PageInFlight(page))
> > >                 ...
> > >
> > > basically like PageWriteback(), but for read-in.
> >
> > OK it could be done, possibly at great pain.  But why is it important?
> 
> It has been considered, but adding atomic operations on these paths
> always really hurts. Adding something like this would basically be
> another at least 2 atomic operations that can never be removed again...
> 
> Provided that you've done the sync readahead earlier, it presumably
> should be a very rare case to have to start new IO in the loop
> below, right? In which case, I wonder if we couldn't move that 2nd
> loop out of generic_file_splice_read and into
> page_cache_pipe_buf_confirm. 

That's a good point, moving those blocks of code to the other end makes
a lot of sense. Or just kill the read-ahead, or at least do it
differently. It's definitely an oversight/bug having splice from file
block on the pages it just issued read-ahead for.

> > What's the use case where it matters that splice-in should not block
> > on the read?
> 
> It just makes it generally less able to pipeline IO and computation,
> doesn't it?

Precisely!

> > And note, after the pipe is full it will block no matter what, since
> > the consumer will have to wait until the page is brought uptodate, and
> > can only then commence with getting the data out from the pipe.
> 
> True, but (especially with patches to variably size the pipe buffer)
> I imagine programs could be designed fairly carefully to the size of
> the buffer (and not just things that blast bulk data down the pipe...)

Yep, that's the whole premise for the dynpipe branch I've been carrying
around for some time.

-- 
Jens Axboe

