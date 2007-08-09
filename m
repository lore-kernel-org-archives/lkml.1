Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXHIT1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXHIT1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761245AbXHIT0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:26:17 -0400
Received: from pat.uio.no ([129.240.10.15]:38139 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbXHIT0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:26:15 -0400
Subject: Re: [PATCH 14/14] NFS: Use local caching [try #2]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <21984.1186685548@redhat.com>
References: <1186683869.6699.136.camel@heimdal.trondhjem.org>
	 <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
	 <20070809160550.17906.40862.stgit@warthog.cambridge.redhat.com>
	 <21984.1186685548@redhat.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 15:25:57 -0400
Message-Id: <1186687557.6699.167.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.090)
X-UiO-Scanned: 51427F74C9F4FCB871B023A3217D3C9BB0DD756A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 189 total 3174773 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 19:52 +0100, David Howells wrote:
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > Dang, that's a lot of inlines... AFAICS, approx half of fs/nfs/fscache.h
> > should really be moved into fscache.c.
> 
> If you wish.  It seems a shame since a lot of them have only one caller.

...however it also forces you to export a lot of stuff which is really
private to fscache.c (the atomics etc).

> Note that due to patch #2, PG_fscache causes releasepage() and
> invalidatepage() to be called in addition to PG_private.



> > > +
> > > +	if (!nfs_fscache_release_page(page, gfp))
> > > +		return 0;
> > 
> > This looks _very_ dubious. Why shouldn't I be able to discard a page
> > just because fscache isn't done writing it out? I may have very good
> > reasons to do so.
> 
> Hmmm...  Looking at the truncate routines, I suppose this ought to be okay,
> provided the cache retains a reference on the page whilst it's writing it out
> (put_page() won't can the page until we release it).
> 
> It also seems dubious, though, to release the page when the filesystem is
> doing stuff to it, even if it's by proxy in the cache.  I'll have to test
> that, but I'm slightly concerned that the netfs could end up releasing its
> cookie before the cache has finished with its pages.  On the other hand, with
> the new asynchronous stuff I've done, I'm not sure this'll be an actual
> problem.

Actually, as long as launder_page() and invalidate_page() are doing
their thing, then your current code might be OK. The important thing is
to ensure that invalidate_inode_pages2() and truncate_inode_pages() work
as expected.

> > >  static int nfs_launder_page(struct page *page)
> > >  {
> > > +	nfs_fscache_invalidate_page(page, page->mapping->host, 0);
> > 
> > Why? The function of launder_page() is to clean the page, not to
> > truncate it.
> 
> Okay.

What you should be doing here is probably to make a call to
wait_on_page_fscache_write(page). That should suffice to ensure that the
page is clean w.r.t. fscache activity afaics.

> > > @@ -1000,11 +1007,13 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
> > >  			if (data_stable) {
> > >  				inode->i_size = new_isize;
> > >  				invalid |= NFS_INO_INVALID_DATA;
> > > +				nfs_fscache_attr_changed(inode);
> > 
> > Can't fscache_attr_changed() call kmalloc(GFP_KERNEL)? You are in a
> > spinlocked context here.
> 
> Hmmm...  How about I move the call to fscache_attr_changed() to the callers of
> nfs_update_inode(), to just after the spinlock is unlocked.  The operation is
> going to be asynchronous, so the delay shouldn't matter.

Right. You might also want to add a flag NFS_INO_INVALID_FSCACHE_ATTR or
something like that in order to trigger it.

> > I'm not too happy about the change to the binary mount interface. As far
> > as I'm concerned, the binary interface should really be considered
> > frozen, and should not be touched.
> 
> I hadn't come across that.  I'll have a look.
> 
> > Instead, feel free to update the text-based mount interface (which can
> > be found in 2.6.23-rc1 and later). Please put any such mount interface
> > changes in a separate patch together with the Kconfig changes.
> 
> If you wish, but doesn't that violate the rules of patch division laid down by
> Linus and Andrew?

Why? It should be possible to set this up so that the NFS+fscache code
compiles correctly without the mount patch.

Trond

