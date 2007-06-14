Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXFNINH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXFNINH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXFNIMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:12:54 -0400
Received: from styx.suse.cz ([82.119.242.94]:49887 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750901AbXFNIMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:12:53 -0400
Date: Thu, 14 Jun 2007 10:25:47 +0200
From: Jan Kara <jack@suse.cz>
To: Rich Coe <Richard.Coe@med.ge.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: udf fs corruption on linux-2.6
Message-ID: <20070614082547.GG13141@duck.suse.cz>
References: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Rich,

On Wed 13-06-07 15:48:03, Rich Coe wrote:
> This patch fixes directory and missing files corruption in fs/udf which
> occurs on all known 2.6 releases.
> 
> The corruption occurs because blocks which were pre-alloc'd for a directory 
> are released back to the fs freelist, but the inode's alloc block information
> is not updated to reflect this.
> 
> You would not see corruption if the number of files in any directory is 
> less than 41, because the pre-alloc routine does not allocate blocks for the
> directory until the number of files is over 40.
> 
> The problem occurs during unmounting because fs/udf incorrectly calls 
> udf_discard_prealloc() from udf_clear_inode().  udf_discard_prealloc() will
> update the inode and schedule it for write, but no write will ever occur 
> because the fs is in the process of being umount'd. 
> 
> The solution is to add a put_inode routine to update the inode contents
> and release the pre-alloc'd blocks to disk prior to clearing the inode
> from the kernel.
> 
> Test case:
>     mkuddfs /dev/scd0
>     mount -o sync /dev/scd0 /mnt/cdrom
>     mkdir /mnt/cdrom/A /mnt/cdrom/B
>     cp A/* /mnt/cdrom/A		[ A contains 90 files of various sizes ]
>     cp B/* /mnt/cdrom/B 	[ B contains 20 or fewer files ]
>     umount /mnt/cdrom
> 
> Here you can see how 7 blocks starting at sector 139 are free and listed in the
> directory entry for 'A'.  I used udfdump to get the following information:
>     [ ... ]
>     Free space found on this partition
> 	[00000139 - 00000159]   [00000161 - 00000191]   [00000193 - 00000223]   
> 	[00004464 - 00004475]   [00004485 - 00524286]   [00524287 - 01048573]
> 	[01048574 - 01572860]   [01572861 - 02097147]   [02097148 - 02235039]   
>     [ ... ]
>     Filename `A`
>     [ ... ]
>     [ blob at sector     2038 for     2048 bytes in logical partion 0 ] 
>     [ blob at sector      137 for     4096 bytes in logical partion 0 ] 
>     [ blob at sector      139 for    14336 bytes in logical partion 0 flags 1 ] 
> 
> -- 
> Rich Coe		richard.coe@med.ge.com
> Virtual Principle Engineer  General Electric Healthcare Technologies
> Global Software Platforms, Computer Technology Team
> 
> Signed-off-by: Rich Coe <richard.coe@med.ge.com>
> ---
> diff -urNp linux-2.6.20.orig/fs/udf/inode.c linux-2.6.20/fs/udf/inode.c
> --- linux-2.6.20.orig/fs/udf/inode.c	2007-02-04 12:44:54.000000000 -0600
> +++ linux-2.6.20/fs/udf/inode.c	2007-06-13 11:32:41.930983471 -0500
> @@ -102,14 +102,17 @@ no_delete:
>  
>  void udf_clear_inode(struct inode *inode)
>  {
> +	kfree(UDF_I_DATA(inode));
> +	UDF_I_DATA(inode) = NULL;
> +}
> +
> +void udf_put_inode(struct inode *inode)
> +{
>  	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
>  		lock_kernel();
>  		udf_discard_prealloc(inode);
>  		unlock_kernel();
>  	}
  Calling udf_discard_preallloc() from put_inode() has the problem that you
truncate the last extent too early - see the comments in the patch Chuck
pointed too (http://lkml.org/lkml/2007/6/11/79).
  Can you try whether that patch fixes your problems?

								Thanks
									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
