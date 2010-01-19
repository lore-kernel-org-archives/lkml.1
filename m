Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126Ab0ATABk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0ATABk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096Ab0ATABh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:01:37 -0500
Received: from kroah.org ([198.145.64.141]:57283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab0ATABf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:01:35 -0500
Date: Tue, 19 Jan 2010 15:52:24 -0800
From: Greg KH <greg@kroah.com>
To: Nick Piggin <npiggin@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] vfs: Fix vmtruncate() regression
Message-ID: <20100119235224.GJ4034@kroah.com>
References: <876378jxhx.fsf@devron.myhome.or.jp>
 <20100113060734.GC3901@nick>
 <87r5pucin4.fsf@devron.myhome.or.jp>
 <877hrmcicu.fsf@devron.myhome.or.jp>
 <20100114143044.cc65be51.akpm@linux-foundation.org>
 <87ska86wo5.fsf@devron.myhome.or.jp>
 <20100118035146.GA7447@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118035146.GA7447@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 02:51:46PM +1100, Nick Piggin wrote:
> On Fri, Jan 15, 2010 at 09:26:02AM +0900, OGAWA Hirofumi wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > 
> > > On Wed, 13 Jan 2010 21:14:09 +0900
> > > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> > >
> > >> 
> > >> If __block_prepare_write() was failed in block_write_begin(), the
> > >> allocated blocks can be outside of ->i_size.
> > >> 
> > >> But new truncate_pagecache() in vmtuncate() does nothing if new < old.
> > >> It means the above usage is not working anymore.
> > >> 
> > >> So, this patch fixes it by removing "new < old" check. It would need
> > >> more cleanup/change. But, now -rc and truncate working is in progress,
> > >> so, this tried to fix it minimum change.
> > >> 
> > >> Acked-by: Nick Piggin <npiggin@suse.de>
> > >> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > >> ---
> > >> 
> > >>  mm/truncate.c |   28 +++++++++++++---------------
> > >>  1 file changed, 13 insertions(+), 15 deletions(-)
> > >> 
> > >> diff -puN mm/truncate.c~truncate_pagecache-fix mm/truncate.c
> > >> --- linux-2.6/mm/truncate.c~truncate_pagecache-fix	2010-01-12 05:43:06.000000000 +0900
> > >> +++ linux-2.6-hirofumi/mm/truncate.c	2010-01-12 05:43:06.000000000 +0900
> > >> @@ -522,22 +522,20 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
> > >>   */
> > >>  void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
> > >>  {
> > >> -	if (new < old) {
> > >> -		struct address_space *mapping = inode->i_mapping;
> > >> +	struct address_space *mapping = inode->i_mapping;
> > >>  
> > >> -		/*
> > >> -		 * unmap_mapping_range is called twice, first simply for
> > >> -		 * efficiency so that truncate_inode_pages does fewer
> > >> -		 * single-page unmaps.  However after this first call, and
> > >> -		 * before truncate_inode_pages finishes, it is possible for
> > >> -		 * private pages to be COWed, which remain after
> > >> -		 * truncate_inode_pages finishes, hence the second
> > >> -		 * unmap_mapping_range call must be made for correctness.
> > >> -		 */
> > >> -		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > >> -		truncate_inode_pages(mapping, new);
> > >> -		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > >> -	}
> > >> +	/*
> > >> +	 * unmap_mapping_range is called twice, first simply for
> > >> +	 * efficiency so that truncate_inode_pages does fewer
> > >> +	 * single-page unmaps.  However after this first call, and
> > >> +	 * before truncate_inode_pages finishes, it is possible for
> > >> +	 * private pages to be COWed, which remain after
> > >> +	 * truncate_inode_pages finishes, hence the second
> > >> +	 * unmap_mapping_range call must be made for correctness.
> > >> +	 */
> > >> +	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > >> +	truncate_inode_pages(mapping, new);
> > >> +	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > >>  }
> > >>  EXPORT_SYMBOL(truncate_pagecache);
> > >
> > > The fix was applied to 2.6.33-rcX
> > > (cedabed49b39b4319bccc059a63344b6232b619c), appears to be needed in
> > > 2.6.32.x but no cc:stable's are present?
> > 
> > Ah, yes. I forgot to add "Cc: stable". Please apply this to 2.6.32.x.
> 
> Thanks guys, it's quite important so please apply to stable 2.6.32 and
> consider it as a high priority to release.

Now queued up for the next .32 -stable release.

greg k-h
