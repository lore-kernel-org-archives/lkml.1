Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXLRWwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXLRWwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXLRWvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:51:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36190 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXLRWvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:51:52 -0500
Date: Tue, 18 Dec 2007 14:50:07 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Handle i_size > s_maxbytes gracefully
Message-ID: <20071218225007.GE13821@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071218152504.GD31091@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218152504.GD31091@duck.suse.cz>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 04:25:05PM +0100, Jan Kara wrote:
> Although we don't allow writes over s_maxbytes, it can happen that a file's
> size is larger than s_maxbytes. For example we can write the file from
> a computer with a different architecture (which has larger s_maxbytes),
> boot a kernel with a different set of config options (CONFIG_LBD...), etc.
> Thus we have to make sure we don't crash / corrupt data when seeing such
> file (page offset of the last page needn't fit into pgoff_t). Firstly, we
> make read() and mmap() return error when user tries to access the file
> above s_maxbytes, secondly we introduce a function i_size_read_trunc() which
> returns min(i_size, s_maxbytes) and use it when determining maximal page
> offset we are interested in.

To give folks some more background on another case of this problem: If two
nodes in a [Ocfs2, and likely Gfs2] cluster have mounted the same file
system and have different s_maxbytes, you could get into a similar situation
during runtime if the node with the larger s_maxbytes extends a file past
what the lesser node can read.

Generally, what we (Ocfs2) needs is just that the node with the lower
s_maxbytes cleanly errors out instead of panicing or corrupting when it
tries to do some operation at an offset past what it can support.

Disallowing access past s_maxbytes up in the vfs should save us from some
number of fs specific i_size versus s_maxbytes comparisons. It also has the
nice property that it should help the case which Jan outlined above.


> diff --git a/fs/buffer.c b/fs/buffer.c
> index 7249e01..3861118 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1623,7 +1623,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  
>  	BUG_ON(!PageLocked(page));
>  
> -	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
> +	last_block = (i_size_read_trunc(inode) - 1) >> inode->i_blkbits;
>  
>  	if (!page_has_buffers(page)) {
>  		create_empty_buffers(page, blocksize,

I'm curious - how can we get to __block_write_full_page() if this condition
is caught in mkwrite and write? That said, I'm not against defensive coding
:)
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
