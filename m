Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYFXTGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYFXTGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYFXTGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:06:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46885 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYFXTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:06:16 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LFD.1.10.0806241129590.2926@woody.linux-foundation.org>
	(message from Linus Torvalds on Tue, 24 Jun 2008 11:31:33 -0700 (PDT))
Subject: Re: [rfc patch 3/4] splice: remove confirm from
 pipe_buf_operations
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
 <alpine.LFD.1.10.0806241022120.2926@woody.linux-foundation.org> <E1KBDBg-0002XZ-DG@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241129590.2926@woody.linux-foundation.org>
Message-Id: <E1KBDpg-0002bR-3X@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Jun 2008 21:05:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 24 Jun 2008, Miklos Szeredi wrote:
> > 
> > OK.  But currently we have an implementation that
> > 
> >  1) doesn't do any of this, unless readahead is disabled
> 
> Sure. But removing even the conceptual support? Not a good idea.
> 
> > And in addition, splice-in and splice-out can return a short count or
> > even zero count if the filesystem invalidates the cached pages during
> > the splicing (data became stale for example).  Are these the right
> > semantics?  I'm not sure.
> 
> What does that really have with splice() and removing the features? Why 
> don't you just fix that issue? 

Because it's freakin' difficult, and I'm lazy, that's why :)

Let's start with page_cache_pipe_buf_confirm().  How should we deal
with finding an invalidated page (!PageUptodate(page) &&
!page->mapping)?

We could return zero to use the contents even though it was
invalidated, not good, but if the page was originally uptodate, then
it should be OK to use the stale data.  But it could have been
invalidated before becoming uptodate, so the contents could be total
crap, and that's not good.  So now we have to tweak page invalidation
to differentiate between was-uptodate and was-never-uptodate pages.

The other is __generic_file_splice_read().  Currently it just bails
out if it finds an invalidated page.  That could be rewritten to throw
away the page, look it up again in the radix tree, etc, etc...  Lots
of added complexity in an already not-too-simple function.

All for what?  To be able to keep the async-on-no-readahead behavior
of generic_file_splice_read()?  The current implementation is not even
close to what would be required to do the async splicing properly.

Conclusion: I think we are better off with a simple
do_generic_file_read() based implementation until someone gives this
the proper thought and effort, than to leave all the complex and dead
code to rot and cause people (me) headaches... :)

Miklos
