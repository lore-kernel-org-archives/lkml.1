Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYG3V0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYG3V0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYG3VZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:25:54 -0400
Received: from chimx.wms.com ([208.46.59.21]:10049 "EHLO chimx.wms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYG3VZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:25:53 -0400
Date: Wed, 30 Jul 2008 16:25:52 -0500
From: Chris Fester <cfester@wms.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Matt Waddel <matt.waddel@freescale.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH] ROMFS 0 byte file read error
Message-ID: <20080730212552.GA4016@kaboom.dhcp.chi.wms.com>
Reply-To: cfester@wms.com
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matt Waddel <matt.waddel@freescale.com>,
	Greg Ungerer <gerg@snapgear.com>
References: <20080730161051.GA3133@kaboom.dhcp.chi.wms.com> <alpine.LFD.1.10.0807301052180.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807301052180.3334@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 30 Jul 2008 21:25:52.0020 (UTC) FILETIME=[D7CFFD40:01C8F28A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jul 30, 2008 at 11:06:29AM -0700, Linus Torvalds wrote:
> Something like this. UNTESTED. Pls verify and send back if this is ok. The 
> patch is certainly bigger, but I think that the end result is more 
> obvious.
> 
> 		Linus

I tested this patch by:
1.)  cat'ing the 0 length file.
2.)  doing a diff between the loop mounted filesystem and the source
directory for the romfs image.
3.)  cp -rdp'ing the contents of the loop mounted filesystem to another
directory, diffing that directory to the source directory.

All of those tests pass.  The image I'm testing with is about 23MB, with
900 files and directories.

I agree that your patch generates far more straightforward code than the
original.  Coolbeans!

Let me know if there's anything else I should do to test.  Also, let me
know if there's other pressing work to be done to this driver and I'll
try my best at de-crustifying it.

Thanks,
Chris Fester

> 
> ---
>  fs/romfs/inode.c |   37 +++++++++++++++++++++++--------------
>  1 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
> index 8e51a2a..60d2f82 100644
> --- a/fs/romfs/inode.c
> +++ b/fs/romfs/inode.c
> @@ -418,7 +418,8 @@ static int
>  romfs_readpage(struct file *file, struct page * page)
>  {
>  	struct inode *inode = page->mapping->host;
> -	loff_t offset, avail, readlen;
> +	loff_t offset, size;
> +	unsigned long filled;
>  	void *buf;
>  	int result = -EIO;
>  
> @@ -430,21 +431,29 @@ romfs_readpage(struct file *file, struct page * page)
>  
>  	/* 32 bit warning -- but not for us :) */
>  	offset = page_offset(page);
> -	if (offset < i_size_read(inode)) {
> -		avail = inode->i_size-offset;
> -		readlen = min_t(unsigned long, avail, PAGE_SIZE);
> -		if (romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen) == readlen) {
> -			if (readlen < PAGE_SIZE) {
> -				memset(buf + readlen,0,PAGE_SIZE-readlen);
> -			}
> -			SetPageUptodate(page);
> -			result = 0;
> +	size = i_size_read(inode);
> +	filled = 0;
> +	result = 0;
> +	if (offset < size) {
> +		unsigned long readlen;
> +
> +		size -= offset;
> +		readlen = size > PAGE_SIZE ? PAGE_SIZE : size;
> +
> +		filled = romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen);
> +
> +		if (filled != readlen) {
> +			SetPageError(page);
> +			filled = 0;
> +			result = -EIO;
>  		}
>  	}
> -	if (result) {
> -		memset(buf, 0, PAGE_SIZE);
> -		SetPageError(page);
> -	}
> +
> +	if (filled < PAGE_SIZE)
> +		memset(buf + filled, 0, PAGE_SIZE-filled);
> +
> +	if (!result)
> +		SetPageUptodate(page);
>  	flush_dcache_page(page);
>  
>  	unlock_page(page);
