Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbXEORXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbXEORXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbXEORXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:23:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657AbXEORXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:23:42 -0400
X-Greylist: delayed 703 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 13:23:42 EDT
Date: Tue, 15 May 2007 10:11:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johann Lombardi <johann@clusterfs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-Id: <20070515101144.f7072476.akpm@linux-foundation.org>
In-Reply-To: <20070515143726.GC2160@chiva>
References: <20070515143726.GC2160@chiva>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:37:26 +0200 Johann Lombardi <johann@clusterfs.com> wrote:

> We've observed that transient disk errors can result in persistent I/O issues
> at the filesystem level. I can at least put forward the problem with ext2/ext3
> and scsci_debug.
> 
> Here are the steps to reproduce:
> * format an ext3 fs on a SCSI disk simulated by scsci_debug
> * mount the fs and create a 10MB file
> * unmount/remount the fs
> * enable the medium error flag in scsi_debug (please note that I've slightly
>   modified scsi_debug to return a medium error indication when any sector >=
>   0x1234 is read)
> * try to read the file (as expected, got -EIO)
> * disable medium error injection in scsi_debug
> * try to read the file (keep getting -EIO)
> 
> In fact, when the underlying device experiences errors, block_read_full_page()
> calls ext3_get_block() which correctly returns an I/O error.
> Consequently, block_read_full_page() set the PG_error flag.
> However, the problem is that afterwards, when the device no longer returns
> any errors, PG_error is never cleared and, as a consequence, we are still
> getting -EIO at the filesystem level.
> 
> Granted that block_read_full_page() always tries to fill a full page,
> I think it should first clear the PG_error flag and set it back if a call
> to get_block() fails. Besides, we should handle this in block_read_full_page
> but also in other places that do full page reads. Any comments?
> I am not able to reproduce the problem with the patch below.
> 
> Johann
> 
> Signed-off-by: Johann Lombardi <johann@clusterfs.com>
> --
> 
> --- linux-2.6.12.6.orig/fs/buffer.c	2005-08-29 18:55:27.000000000 +0200
> +++ linux-2.6.12.6/fs/buffer.c	2007-05-11 15:51:03.000000000 +0200
> @@ -2078,6 +2078,7 @@ int block_read_full_page(struct page *pa
>  	int fully_mapped = 1;
>  
>  	BUG_ON(!PageLocked(page));
> +	ClearPageError(page);
>  	blocksize = 1 << inode->i_blkbits;
>  	if (!page_has_buffers(page))
>  		create_empty_buffers(page, blocksize, 0);

We need to make sure that this page has PG_uptodate cleared, so
that a re-read is forced.  And the affected buffer_head, if any, should have
buffer_uptodate() cleared.

This change might have horrid interactions with readahead and various
application access patterns: if for some reason a dud sector takes 30
seconds of driver futzing to return -EIO and someone (application or
kernel) tries to read the same sector tens or hundreds of times, suckiness
ensues.  This will be hard to test for.

Most reads don't (or shouldn't) go through block_read_full_page(). 
mpage_readpages() does the heavy lifting.

