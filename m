Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYGGO2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYGGO2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYGGO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:28:24 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:36213 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952AbYGGO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:28:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ogKpcA4kJBHXGl09pyZjsPLkP9cdY28YP7+RaVcMVkI6Ygz4cIyz89TNnFt8A6MRHr/VRGrAdI0pQuN3CZed2eyZWh5rFGr5HO8zhPtoS1IL79uJ5GxUBnMjFrAiRmUf/sh/JaP3LuGnLZJ1WLLenCGULVac9dE0tZw7eBOj8cw=  ;
X-YMail-OSG: 8AMU6WEVM1mXIfNEHm1wq5X1xATBpxpZJ0lvPGan7Qt2_FP6kQUlA7UZ1GKMJk4jRSJF_UEnk54fa9ZFkdGxI94Ou3BWZmMsAP2xINxTdQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Date: Tue, 8 Jul 2008 00:28:00 +1000
User-Agent: KMail/1.9.5
Cc: jamie@shareable.org, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com
References: <20080625124038.103406301@szeredi.hu> <200807072217.57509.nickpiggin@yahoo.com.au> <E1KFqD4-0001vq-3F@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KFqD4-0001vq-3F@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080028.00642.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 22:52, Miklos Szeredi wrote:
> On Mon, 7 Jul 2008, Nick Piggin wrote:
> > On Monday 07 July 2008 22:03, Miklos Szeredi wrote:
> > > Case 3: page is invalidated while in the pipe
> > >
> > >   This can happen on pages in the middle of the file, and splice-out
> > >   can return a zero count.  This is *BAD*, callers of splice really
> > >   should be able to assume, that a zero return means EOF.
> > >
> > > Page invalidation (the invalidate_inode_pages2 kind) is done by only a
> > > few filesystems (FUSE, NFS, AFS, 9P), and by O_DIRECT hackery.  So
> > > case 3 only affects these, and only fuse can be re-exported by nfsd
> > > (and that's only in -mm yet), hence this is very unlikely to be hit
> > > for any of the others.
> >
> > Things that are using invalidate_complete_page2 are probably
> > also subtly broken if they allow mmap of the same pages, BTW.
> > It is easy to get wrong. If they have to handle the case of
> > invalidation failure _anyway_, then we really should have them
> > just use the safe invalidate...
>
> No, if the file changed remotely, then we really want to invalidate
> _all_ cached pages.
>
> The only way invalidate_complete_page2() can fail is if the page is
> dirty.  But we call ->launder_page() for exactly that reason.  Now if
> ->launder_page() leaves the page dirty, that's bad, but that shouldn't
> normally happen.

If dirty can't happen, the caller should just use the truncate.
The creation of this "invalidate 2" thing was just papering over
problems in the callers.

But anyway your point is taken -- caller doesn't really handle failure.


> > That would "solve" the splice issue... Although if they handle
> > failure with a wait/retry loop, then it probably opens a window
> > to DoS by leaving your pipe filled. In theory one could have a
> > slowpath function triggered when invalidate fails which copies
> > the page data and then replaces them with copies in the pipe.
> > The hard part I suspect is to walk through everybodies pipes and
> > going through all pages. Probably not realistically solveable.
>
> Right.  I think leaving PG_uptodate on invalidation is actually a
> rather clean solution compared to the alternatives.

Note that files can be truncated in the middle too, so you can't
just fix one case that happens to hit you, you'd have to fix things
consistently.

But...


> Well, other than my original proposal, which would just have reused
> the do_generic_file_read() infrastructure for splice.  I still don't
> see why we shouldn't use that, until the whole async splice-in thing
> is properly figured out.

Given the alternatives, perhaps this is for the best, at least for
now.
