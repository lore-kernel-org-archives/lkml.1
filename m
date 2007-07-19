Return-Path: <linux-kernel-owner+w=401wt.eu-S937067AbXGSIlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937067AbXGSIlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762591AbXGSIlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:41:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9253 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936185AbXGSIlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:41:05 -0400
Date: Thu, 19 Jul 2007 10:07:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ken Chen <kenchen@google.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
Message-ID: <20070719080722.GZ11657@kernel.dk>
References: <20070718141533.GA11657@kernel.dk> <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com> <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk> <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com> <20070719062934.GT11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719062934.GT11657@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19 2007, Jens Axboe wrote:
> On Wed, Jul 18 2007, Hugh Dickins wrote:
> > On Wed, 18 Jul 2007, Jens Axboe wrote:
> > > 
> > > Since I had my hands dirty already...
> > 
> > Great, thanks.  (There's also such a test in fs/nfs/direct.c,
> > but let's not trouble Trond until we've settled what to do here.)
> > 
> > > 
> > > ---
> > > 
> > > [PATCH] Remove PageCompound() checks before calling set_page_dirty()
> > > 
> > > Pre commit 41d78ba55037468e6c86c53e3076d1a74841de39 it was illegal
> > > to call set_page_dirty() on a compound page, since it stored the
> > > destructor in the mapping field. But now it's ok, so remove the
> > > ugly PageCompound() checks from bio and direct-io.
> > > 
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > 
> > I was about to Ack that, now that I've found something or other in the
> > libhugetlb testsuite comes this way, even on page[1], without showing
> > any problem.
> > 
> > However, I have noticed a particular inefficiency arising: that
> > bio_check_pages_dirty test specifically avoids pages already
> > PageDirty; but hugetlbfs_set_page_dirty carefully redirects to
> > set the head page dirty: so tail pages of a hugetlb compound page
> > will tend never to be PageDirty, and keep on coming back this way.
> > 
> > Which led me to look up the origin of those PageCompound tests:
> > Author: Andrew Morton <akpm@osdl.org>
> > Date:   Sun Sep 21 01:42:22 2003 -0700
> > 
> >     [PATCH] Speed up direct-io hugetlbpage handling
> >     
> >     This patch short-circuits all the direct-io page dirtying logic for
> >     higher-order pages.  Without this, we pointlessly bounce BIOs up to keventd
> >     all the time.
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index d016523..2463163 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -532,6 +532,12 @@ void bio_unmap_user(struct bio *bio, int write_to_vm)
> >   * check that the pages are still dirty.   If so, fine.  If not, redirty them
> >   * in process context.
> >   *
> > + * We special-case compound pages here: normally this means reads into hugetlb
> > + * pages.  The logic in here doesn't really work right for compound pages
> > + * because the VM does not uniformly chase down the head page in all cases.
> > + * But dirtiness of compound pages is pretty meaningless anyway: the VM doesn't
> > + * handle them at all.  So we skip compound pages here at an early stage.
> > ...
> > 
> > It looks like I was wrong in thinking it was just trying to avoid 
> > the crash on page[1].mapping.  At the least, your patch needs also
> > to remove that paragraph of comment from Andrew.  But really, it
> > looks like those PageCompound tests should stay, unless you can
> > persuade Andrew to Ack their removal.
> > 
> > Except (now, how many times can I change my mind in the course of
> > one email?), hugetlbfs_set_page_dirty was specifically added by
> > Ken Chen to avoid losing data via /proc/sys/vm/drop_caches.  Yet
> > fs/bio.c is carefully avoiding going there when dirtying a hugepage.
> > How does this work?  Looks like those PageCompound tests need to go!
> 
> Hehe, that didn't really get us much further, did it? :-)
> 
> My opinion is that since the win is marginal at best, we want to remove
> such tests as it just clutters up the code. And it's definitely not
> obvious why the tests are there, since they are not commented at all.
> Since it's even confusing you, then we can't expect the more vm ignorant
> of us (which definitely includes me) to grasp it!
> 
> > I'm lost: I hope Andrew and Ken can sort it out for us.
> 
> Posting a revised version, still leaving nfs out of it (I'll ping Trond
> to do the same, if this goes in).

FWIW, I ran a hugepage+O_DIRECT read test, that will cause the direct-io
code to hit set_page_dirty() for a compound page - and it works fine for
me. The fio job file used was:

[global]
directory=/data1
bs=4k
direct=1
hugepage-size=4m
iomem=shmhuge

[iothread]
filename=testfile
size=128m
rw=read

Test box is a lowly x86.

-- 
Jens Axboe

