Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbXKNKtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbXKNKtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbXKNKtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:49:06 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:8276 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXKNKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:49:05 -0500
Date: Wed, 14 Nov 2007 13:46:22 +0300
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.24-rc2-mm1 -- mkfs failing on variety of fs types
Message-ID: <20071114104622.GA20655@dmon-lap.sw.ru>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@lst.de>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <20071114085549.GG12003@shadowen.org> <20071114022810.215a5e3a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114022810.215a5e3a.akpm@linux-foundation.org>
Organization: SWsoft.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02:28 Wed 14 Nov     , Andrew Morton wrote:
> On Wed, 14 Nov 2007 08:56:01 +0000 Andy Whitcroft <apw@shadowen.org> wrote:
> 
[snip]
> > We seem to have some general problem with mkfs for all filesystems.
> > UUID: e9aa2dc4-dfc3-47e8-865b-693f28eac2e5
> > Initializing journal - 0%....20%....40%....60%....80%....100%
> > bwrite: write 4096 bytes returned -1 (block=360448, dev=3): No space left on device
> 
> It was mm-fix-blkdev-size-calculation-in-generic_write_checks.patch.
Oh my ..., I'm truly sorry. When i've sent this patch to Andrew first time
he ask me to remake it in order to make it less intrusive. When later 
i've found what patch was buggy because of incorrect int to loff_t conversion
isize = i_size_read(inode) & ~(blksize - 1);
                              ^^^^^^^^^^^^^^
Later i've missed when this patch was accepted some days ago :(.
> 
> Odd, I thought that looked OK.
> 
> 
> Here's a revert (uploaded to hot-fixes/, too):
> 
> --- a/mm/filemap.c~revert-mm-fix-blkdev-size-calculation-in-generic_write_checks
> +++ a/mm/filemap.c
> @@ -1855,11 +1855,9 @@ inline int generic_write_checks(struct f
>  	} else {
>  #ifdef CONFIG_BLOCK
>  		loff_t isize;
> -		unsigned int blksize;
>  		if (bdev_read_only(I_BDEV(inode)))
>  			return -EPERM;
> -		blksize = block_size(I_BDEV(inode));
> -		isize = i_size_read(inode) & ~(blksize - 1);
> +		isize = i_size_read(inode);
>  		if (*pos >= isize) {
>  			if (*count || *pos > isize)
>  				return -ENOSPC;
> _
> 

