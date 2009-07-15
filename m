Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZGOLRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZGOLRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZGOLRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:17:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:59597 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZGOLRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,404,1243839600"; 
   d="scan'208";a="165219292"
Date: Wed, 15 Jul 2009 19:17:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
Message-ID: <20090715111739.GA2596@localhost>
References: <20090714092926.GA23969@localhost> <Pine.LNX.4.64.0907141918380.10805@sister.anvils> <20090715111012.GA1403@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715111012.GA1403@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 07:10:12PM +0800, Wu Fengguang wrote:
> On Wed, Jul 15, 2009 at 02:24:54AM +0800, Hugh Dickins wrote:
> > On Tue, 14 Jul 2009, Wu Fengguang wrote:
> > > Here set_page_dirty() can be moved into the page lock.
> > 
> > Indeed it can, but you've forgotten to mention why you think
> > that would be a good thing?  All I can see is that it would
> 
> Sorry for missing out the rational.  My problem is: the hwpoison code
> must make sure whether one page can be dropped without losing data.
> 
> > very very slightly increase the page's lock hold time, which
> > wouldn't be an improvement: what improvement are you making?
> 
> Yes there were nothing wrong. Just to make it align with the general
> practice(not rule): pages are normally dirtied inside the page lock.
> 
> The noticeable exceptions are mapped pages and pages with buffer_heads
> - they could go dirty at any time. Fortunately they will have to be
> unmapped/released anyway.
> 
> shmem may not be the only remaining exception. But let's fix it first.
> I'd be appreciated if someone could name some more exceptions, or some
> better criterion on "the data in this page can be recovered".

btrfs will also dirty its extent pages without taking the page lock.
But I'd call that metadata pages, which the hwpoison code can do
nothing helpful anyway.

Thanks,
Fengguang

> > > CC: Hugh Dickins <hugh@veritas.com>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > >  mm/shmem.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- linux.orig/mm/shmem.c
> > > +++ linux/mm/shmem.c
> > > @@ -1630,8 +1630,8 @@ shmem_write_end(struct file *file, struc
> > >  	if (pos + copied > inode->i_size)
> > >  		i_size_write(inode, pos + copied);
> > >  
> > > -	unlock_page(page);
> > >  	set_page_dirty(page);
> > > +	unlock_page(page);
> > >  	page_cache_release(page);
> > >  
> > >  	return copied;
