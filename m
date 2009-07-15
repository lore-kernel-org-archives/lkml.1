Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZGONT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZGONT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZGONT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:19:28 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:56898 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbZGONT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:19:27 -0400
X-Trace: 226530479/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.119.106/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.119.106
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEAOdzXUpPRXdq/2dsb2JhbACBUc59gjaBUwU
X-IronPort-AV: E=Sophos;i="4.42,404,1243810800"; 
   d="scan'208";a="226530479"
Date: Wed, 15 Jul 2009 14:18:44 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
In-Reply-To: <20090715111012.GA1403@localhost>
Message-ID: <Pine.LNX.4.64.0907151405020.23573@sister.anvils>
References: <20090714092926.GA23969@localhost> <Pine.LNX.4.64.0907141918380.10805@sister.anvils>
 <20090715111012.GA1403@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Wu Fengguang wrote:
> On Wed, Jul 15, 2009 at 02:24:54AM +0800, Hugh Dickins wrote:
> > On Tue, 14 Jul 2009, Wu Fengguang wrote:
> > > Here set_page_dirty() can be moved into the page lock.
> > 
> > Indeed it can, but you've forgotten to mention why you think
> > that would be a good thing?  All I can see is that it would
> 
> Sorry for missing out the rational.  My problem is: the hwpoison code
> must make sure whether one page can be dropped without losing data.

Ah, thanks: your comments here will need to go into the patch
description.  But shouldn't this patch be part of the hwpoison set?

> 
> > very very slightly increase the page's lock hold time, which
> > wouldn't be an improvement: what improvement are you making?
> 
> Yes there were nothing wrong. Just to make it align with the general
> practice(not rule): pages are normally dirtied inside the page lock.

I don't mind making shmem follow more common practice here if it makes
life easier for you; but until now there's been no reason to do so -
as you say, there's no rule to call set_page_dirty with page locked.

I wish you would distinguish between dirtying a page and marking a
page dirty: if it matters to you whether it's done inside the page
lock or not, then it matter which one you are talking about.  This
page was dirtied while the page lock was held, but it's being marked
dirty just after dropping the page lock.

What about shmem_symlink: shouldn't this patch be moving the
unlock_page down there too?

Hugh

> 
> The noticeable exceptions are mapped pages and pages with buffer_heads
> - they could go dirty at any time. Fortunately they will have to be
> unmapped/released anyway.
> 
> shmem may not be the only remaining exception. But let's fix it first.
> I'd be appreciated if someone could name some more exceptions, or some
> better criterion on "the data in this page can be recovered".
> 
> Thanks,
> Fengguang
> 
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
