Return-Path: <linux-kernel-owner+w=401wt.eu-S1946009AbXEAVBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009AbXEAVBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXEAVBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:01:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946009AbXEAVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:01:11 -0400
Date: Tue, 1 May 2007 14:00:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Mollett <molletts@yahoo.com>
Cc: bfennema@falcon.csc.calpoly.edu, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH 2.6.21] udf: Decrement correct link count in udf_rmdir
Message-Id: <20070501140049.04fa2a69.akpm@linux-foundation.org>
In-Reply-To: <200705011923.14950.molletts@yahoo.com>
References: <200705011923.14950.molletts@yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 19:23:14 +0100
Stephen Mollett <molletts@yahoo.com> wrote:

> It appears that a minor thinko occurred in udf_rmdir and the (already-cleared) 
> link count on the directory that is being removed was being decremented 
> instead of the link count on its parent directory. This gives rise to lots of 
> kernel messages similar to:
> 
> UDF-fs warning (device loop1): udf_rmdir: empty directory has nlink != 2 (8)
> 
> when removing directory trees. No other ill effects have been observed but I 
> guess it could theoretically result in the link count overflowing on a very 
> long-lived, much modified directory.
> 
> Signed-off-by: Stephen Mollett <molletts@yahoo.com>
> ---
> 
> Patch applies cleanly to latest git snapshot and other recent 2.6 kernels.
> 
> Please CC: me as I'm not currently subscribed to linux-kernel.
> 
> First attempt at formally submitting a kernel patch - apologies if I've cocked 
> something up - please be nice :-)
> 
> 
> --- linux-2.6.21/fs/udf/namei.c.orig	2007-05-01 18:52:02.000000000 +0100
> +++ linux-2.6.21/fs/udf/namei.c	2007-05-01 18:53:00.000000000 +0100
> @@ -878,7 +878,7 @@ static int udf_rmdir(struct inode * dir,
>  			inode->i_nlink);
>  	clear_nlink(inode);
>  	inode->i_size = 0;
> -	inode_dec_link_count(inode);
> +	inode_dec_link_count(dir);
>  	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
>  	mark_inode_dirty(dir);
>  

OK, thanks.  git-blame says

9a53c3a7 (Dave Hansen    2006-09-30 23:29:03 -0700  881)        inode_dec_link_count(inode);

This bug is also fixed in Jan's UDF fixes for 2.6.22, but it looks like I
should make your fix a separate thing, with a 2.6.21.x backport.

