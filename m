Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZJPVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZJPVZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZJPVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:25:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbZJPVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:30 -0400
Date: Fri, 16 Oct 2009 14:25:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] befs: redundant test on unsigned in befs_get_block()?
Message-Id: <20091016142518.998c41a2.akpm@linux-foundation.org>
In-Reply-To: <4AD88DE1.1080900@gmail.com>
References: <4AD88DE1.1080900@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 17:14:41 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> block is unsigned, this test appears redundant.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or is a different test required?
> 
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index 33baf27..3ab1336 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -128,13 +128,6 @@ befs_get_block(struct inode *inode, sector_t block,
>  	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
>  		   inode->i_ino, block);
>  
> -	if (block < 0) {
> -		befs_error(sb, "befs_get_block() was asked for a block "
> -			   "number less than zero: block %ld in inode %lu",
> -			   block, inode->i_ino);
> -		return -EIO;
> -	}
> -
>  	if (create) {
>  		befs_error(sb, "befs_get_block() was asked to write to "
>  			   "block %ld in inode %lu", block, inode->i_ino);

As far as the VFS is concerned, `block' is indeed unsigned and may well
be in the range 2G-4G with a 32-bit sector_t.  Perhaps not possible on
befs but still legal to the VFS.

So the test is wrong from that POV.

However it is possible that befs is defending itself here.  Perhaps code
internal to befs will explode if passed a "negative" block number.  Due
to coding errors within the fs implementation.

So really, we'd need to check all code paths called by
befs_get_block() and check that they are signednessly clean.

