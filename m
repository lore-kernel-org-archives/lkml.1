Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXLRX7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXLRX7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXLRX7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:59:32 -0500
Received: from styx.suse.cz ([82.119.242.94]:54280 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753441AbXLRX7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:59:31 -0500
Date: Wed, 19 Dec 2007 00:59:29 +0100
From: Jan Kara <jack@suse.cz>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Handle i_size > s_maxbytes gracefully
Message-ID: <20071218235929.GA3569@duck.suse.cz>
References: <20071218152504.GD31091@duck.suse.cz> <20071218225007.GE13821@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218225007.GE13821@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-12-07 14:50:07, Mark Fasheh wrote:
> On Tue, Dec 18, 2007 at 04:25:05PM +0100, Jan Kara wrote:
> > Although we don't allow writes over s_maxbytes, it can happen that a file's
> > size is larger than s_maxbytes. For example we can write the file from
> > a computer with a different architecture (which has larger s_maxbytes),
> > boot a kernel with a different set of config options (CONFIG_LBD...), etc.
> > Thus we have to make sure we don't crash / corrupt data when seeing such
> > file (page offset of the last page needn't fit into pgoff_t). Firstly, we
> > make read() and mmap() return error when user tries to access the file
> > above s_maxbytes, secondly we introduce a function i_size_read_trunc() which
> > returns min(i_size, s_maxbytes) and use it when determining maximal page
> > offset we are interested in.
> 
> To give folks some more background on another case of this problem: If two
> nodes in a [Ocfs2, and likely Gfs2] cluster have mounted the same file
> system and have different s_maxbytes, you could get into a similar situation
> during runtime if the node with the larger s_maxbytes extends a file past
> what the lesser node can read.
> 
> Generally, what we (Ocfs2) needs is just that the node with the lower
> s_maxbytes cleanly errors out instead of panicing or corrupting when it
> tries to do some operation at an offset past what it can support.
> 
> Disallowing access past s_maxbytes up in the vfs should save us from some
> number of fs specific i_size versus s_maxbytes comparisons. It also has the
> nice property that it should help the case which Jan outlined above.
> 
> 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 7249e01..3861118 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1623,7 +1623,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
> >  
> >  	BUG_ON(!PageLocked(page));
> >  
> > -	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
> > +	last_block = (i_size_read_trunc(inode) - 1) >> inode->i_blkbits;
> >  
> >  	if (!page_has_buffers(page)) {
> >  		create_empty_buffers(page, blocksize,
> 
> I'm curious - how can we get to __block_write_full_page() if this condition
> is caught in mkwrite and write? That said, I'm not against defensive coding
> :)
  We could still write to some offset below s_maxbytes and when i_size
happens to be larger than s_maxbytes, we have to handle that gracefully
(i.e., not overflow last_block in this case). But maybe I'm missing
something...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
