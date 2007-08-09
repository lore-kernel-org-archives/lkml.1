Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXHISxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXHISxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXHISxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:53:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbXHISxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:53:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1186683869.6699.136.camel@heimdal.trondhjem.org>
References: <1186683869.6699.136.camel@heimdal.trondhjem.org> <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com> <20070809160550.17906.40862.stgit@warthog.cambridge.redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] NFS: Use local caching [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 09 Aug 2007 19:52:28 +0100
Message-ID: <21984.1186685548@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> Dang, that's a lot of inlines... AFAICS, approx half of fs/nfs/fscache.h
> should really be moved into fscache.c.

If you wish.  It seems a shame since a lot of them have only one caller.

> > +	/* we can do this here as the bits are only set with the page lock
> > +	 * held, and our caller is holding that */
> > +	if (!page->private)
> > +		ClearPagePrivate(page);
> 
> Why would PG_private be set at this point?

Looks like I've got a bit more cleaning up to do.  PG_private isn't set by
FS-Cache, so this bit shouldn't be here.

> In any case, please send this and other PagePrivate changes as a
> separate patch. Any changes to the PagePrivate semantics must be made
> easy to debug.

There shouldn't be any.

Note that due to patch #2, PG_fscache causes releasepage() and
invalidatepage() to be called in addition to PG_private.

> > +
> > +	if (!nfs_fscache_release_page(page, gfp))
> > +		return 0;
> 
> This looks _very_ dubious. Why shouldn't I be able to discard a page
> just because fscache isn't done writing it out? I may have very good
> reasons to do so.

Hmmm...  Looking at the truncate routines, I suppose this ought to be okay,
provided the cache retains a reference on the page whilst it's writing it out
(put_page() won't can the page until we release it).

It also seems dubious, though, to release the page when the filesystem is
doing stuff to it, even if it's by proxy in the cache.  I'll have to test
that, but I'm slightly concerned that the netfs could end up releasing its
cookie before the cache has finished with its pages.  On the other hand, with
the new asynchronous stuff I've done, I'm not sure this'll be an actual
problem.

> >  static int nfs_launder_page(struct page *page)
> >  {
> > +	nfs_fscache_invalidate_page(page, page->mapping->host, 0);
> 
> Why? The function of launder_page() is to clean the page, not to
> truncate it.

Okay.

> > @@ -1000,11 +1007,13 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
> >  			if (data_stable) {
> >  				inode->i_size = new_isize;
> >  				invalid |= NFS_INO_INVALID_DATA;
> > +				nfs_fscache_attr_changed(inode);
> 
> Can't fscache_attr_changed() call kmalloc(GFP_KERNEL)? You are in a
> spinlocked context here.

Hmmm...  How about I move the call to fscache_attr_changed() to the callers of
nfs_update_inode(), to just after the spinlock is unlocked.  The operation is
going to be asynchronous, so the delay shouldn't matter.

> I'm not too happy about the change to the binary mount interface. As far
> as I'm concerned, the binary interface should really be considered
> frozen, and should not be touched.

I hadn't come across that.  I'll have a look.

> Instead, feel free to update the text-based mount interface (which can
> be found in 2.6.23-rc1 and later). Please put any such mount interface
> changes in a separate patch together with the Kconfig changes.

If you wish, but doesn't that violate the rules of patch division laid down by
Linus and Andrew?

David
