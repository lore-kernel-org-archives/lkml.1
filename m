Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYLaB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYLaB0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLaB0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:26:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:33816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYLaB0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:26:43 -0500
Date: Wed, 31 Dec 2008 02:26:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] minix: fix add link - wrong position calculation
Message-ID: <20081231012640.GA32239@wotan.suse.de>
References: <20081228232550.GA11504@rain> <20081230153230.8e72dc88.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230153230.8e72dc88.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 03:32:30PM -0800, Andrew Morton wrote:
> On Mon, 29 Dec 2008 02:25:50 +0300
> Evgeniy Dushistov <dushistov@mail.ru> wrote:
> 
> > This patch fixes add link method.
> > Position in directory was calculated in wrong way.
> > 
> > Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
> > ---
> >  fs/minix/dir.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/minix/dir.c b/fs/minix/dir.c
> > index f704338..4b603b7 100644
> > --- a/fs/minix/dir.c
> > +++ b/fs/minix/dir.c
> > @@ -280,7 +280,7 @@ int minix_add_link(struct dentry *dentry, struct inode *inode)
> >  	return -EINVAL;
> >  
> >  got_it:
> > -	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
> > +	pos = page_offset(page) + p - (char*)page_address(page);
> >  	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
> >  					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
> >  	if (err)
> 
> Well that's cute.  Seems that we broke it over a year ago:
> 
> commit 4a66af9eaa9531372cfcb9e20103ed147c729ff9
> Author:     Nick Piggin <npiggin@suse.de>
> AuthorDate: Tue Oct 16 01:25:21 2007 -0700
> Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Tue Oct 16 09:42:57 2007 -0700
> 
>     minixfs: convert to new aops
> 
> Is minixfs getting THAT little use, or is this bustage more subtle
> than it appears?

Not getting used, I'd suspect (although I definitely have used it -- I
converted it to large block size for testing fsblock, probably I didn't
test softlinks).

But anyway I think it is still useful as a primer for ext2? Probably there
are quite a lot of other filesystems that are less useful than minix ;)
