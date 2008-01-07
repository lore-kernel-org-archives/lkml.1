Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYAGQkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYAGQkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbYAGQjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:39:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:50252 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755692AbYAGQjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:39:52 -0500
Date: Mon, 7 Jan 2008 17:39:48 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH] Handle i_size > s_maxbytes correctly
Message-ID: <20080107163948.GP12589@duck.suse.cz>
References: <20071220175104.GA11911@duck.suse.cz> <20071222001206.9d34cc78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222001206.9d34cc78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 22-12-07 00:12:06, Andrew Morton wrote:
  Sorry for a late reply but I was on vacation.

> On Thu, 20 Dec 2007 18:51:04 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > Although we don't allow writes over s_maxbytes, it can happen that a file's
> > size is larger than s_maxbytes. For example we can write the file from a
> > computer with a different architecture (which has larger s_maxbytes), boot
> > a kernel with a different set of config options (CONFIG_LBD...), or if two
> > nodes in a [Ocfs2, and likely Gfs2] cluster have mounted the same file
> > system and have different s_maxbytes.  Thus we have to make sure we don't
> > crash / corrupt data when seeing such file (page offset of the last page
> > needn't fit into pgoff_t). Firstly, we make read() and mmap() return error
> > when user tries to access the file above s_maxbytes, secondly we introduce
> > a function i_size_read_trunc() which returns min(i_size, s_maxbytes) and
> > use it when determining maximal page offset we are interested in.
> > 
> > ...
> >
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1623,7 +1623,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
> >  
> >  	BUG_ON(!PageLocked(page));
> >  
> > -	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
> > +	last_block = (i_size_read_trunc(inode) - 1) >> inode->i_blkbits;
> >  
> > ...
> >
> > +/* Truncate i_size at s_maxbytes so that pagecache doesn't have problems */
> > +static inline loff_t i_size_read_trunc(const struct inode *inode)
> > +{
> > +	loff_t i_size = i_size_read(inode);
> > +
> > +	if (unlikely(inode->i_sb->s_maxbytes < i_size))
> > +		return inode->i_sb->s_maxbytes;
> > +	return i_size;
> > +}
> > +
> 
> This patch takes the total text size of the affected nine files from 74167
> bytes up to 75066 on i386.  This is core, core kernel.  Ouch.
> 
> It's also pretty fragile.  We now have i_size_read()s and
> i_size_read_trunc()s sprinkled all over the place with no obvious rules to
> determine when we should use one versus the other.
  Looking at the patch from the distance of two weeks I agree this is a
flaw...

> uninlining i_size_read_trunc() is obviously the first thing to look at but
> the cost is still appreciable and boy the problem which is being fixed here
> is rare and obscure.
> 
> Can we look at alternatives please?  What about just failing the open
> attempt?
  As Mark wrote, just failing the open does not solve the problem for
clustered filesystems. I'll try to come up with something that would be
a less fragile solution (and won't increase the text size that much).

						Thanks for your comments

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
