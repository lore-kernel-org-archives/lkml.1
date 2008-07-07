Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYGGMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYGGMxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYGGMxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:53:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44179 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYGGMxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:53:04 -0400
To: nickpiggin@yahoo.com.au
CC: miklos@szeredi.hu, jamie@shareable.org, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, hugh@veritas.com
In-reply-to: <200807072217.57509.nickpiggin@yahoo.com.au> (message from Nick
	Piggin on Mon, 7 Jul 2008 22:17:57 +1000)
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
References: <20080625124038.103406301@szeredi.hu> <200807072101.58963.nickpiggin@yahoo.com.au> <E1KFpRL-0001pA-Aq@pomaz-ex.szeredi.hu> <200807072217.57509.nickpiggin@yahoo.com.au>
Message-Id: <E1KFqD4-0001vq-3F@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Jul 2008 14:52:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Nick Piggin wrote:
> On Monday 07 July 2008 22:03, Miklos Szeredi wrote:
> > Case 3: page is invalidated while in the pipe
> >
> >   This can happen on pages in the middle of the file, and splice-out
> >   can return a zero count.  This is *BAD*, callers of splice really
> >   should be able to assume, that a zero return means EOF.
> >
> > Page invalidation (the invalidate_inode_pages2 kind) is done by only a
> > few filesystems (FUSE, NFS, AFS, 9P), and by O_DIRECT hackery.  So
> > case 3 only affects these, and only fuse can be re-exported by nfsd
> > (and that's only in -mm yet), hence this is very unlikely to be hit
> > for any of the others.
> 
> Things that are using invalidate_complete_page2 are probably
> also subtly broken if they allow mmap of the same pages, BTW.
> It is easy to get wrong. If they have to handle the case of
> invalidation failure _anyway_, then we really should have them
> just use the safe invalidate...

No, if the file changed remotely, then we really want to invalidate
_all_ cached pages.

The only way invalidate_complete_page2() can fail is if the page is
dirty.  But we call ->launder_page() for exactly that reason.  Now if
->launder_page() leaves the page dirty, that's bad, but that shouldn't
normally happen.

> That would "solve" the splice issue... Although if they handle
> failure with a wait/retry loop, then it probably opens a window
> to DoS by leaving your pipe filled. In theory one could have a
> slowpath function triggered when invalidate fails which copies
> the page data and then replaces them with copies in the pipe.
> The hard part I suspect is to walk through everybodies pipes and
> going through all pages. Probably not realistically solveable.

Right.  I think leaving PG_uptodate on invalidation is actually a
rather clean solution compared to the alternatives.

Well, other than my original proposal, which would just have reused
the do_generic_file_read() infrastructure for splice.  I still don't
see why we shouldn't use that, until the whole async splice-in thing
is properly figured out.

Miklos
