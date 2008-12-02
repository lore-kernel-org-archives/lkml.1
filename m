Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYLBX6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYLBX6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYLBX6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:58:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbYLBX6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:58:40 -0500
Date: Tue, 2 Dec 2008 15:58:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dmonakhov@openvz.org
Subject: Re: [PATCH] fs: truncate blocks outside i_size after O_DIRECT write
 error.
Message-Id: <20081202155837.f977710b.akpm@linux-foundation.org>
In-Reply-To: <1228051966-23866-1-git-send-email-dmonakhov@openvz.org>
References: <1228051966-23866-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008 16:32:46 +0300
Dmitri Monakhov <dmonakhov@openvz.org> wrote:

> In case of error extending write may have instantiated a few  blocks
> outside i_size. We need to trim these blocks. We have to do it *regardless*
> to blocksize. At least ext2, ext3 and reiserfs interpret
> (i_size < biggest block) condition as error. Fsck will complain about wrong
> i_size. Then fsck will fix the error by changing i_size according to the
> biggest block. This is bad because this blocks contain garbage from previous
> write attempt. And result in data corruption.
> 
> Changes from previous version:
>  - Move error handling from generic mm code to __blockdev_direct_IO(). As soon
>    as i remember this is 11'th version of the patch, and now finally it looks
>    simple and clean.

Only 11?  We can do better than that..

> ####TESTCASE_BEGIN
> $touch /mnt/test/BIG_FILE
> ## at this moment /mnt/test/BIG_FILE size and blocks equal to zero
> open("/mnt/test/BIG_FILE", O_WRONLY|O_CREAT|O_DIRECT, 0666) = 3
> write(3, "aaaaaaaaaaaa"..., 104857600) = -1 ENOSPC (No space left on device)
> ## size and block sould't be changed because write op failed.
> $stat /mnt/test/BIG_FILE
> File: `/mnt/test/BIG_FILE'
> Size: 0 Blocks: 110896 IO Block: 1024 regular empty file
> <<<<<<<<^^^^^^^^^^^^^^^^^^^^^^^^^^^^^file size is less than biggest block idx
> Device: fe07h/65031d Inode: 14 Links: 1
> Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
> Access: 2007-01-24 20:03:38.000000000 +0300
> Modify: 2007-01-24 20:03:38.000000000 +0300
> Change: 2007-01-24 20:03:39.000000000 +0300
> 
> #fsck.ext3 -f /dev/VG/test
> e2fsck 1.39 (29-May-2006)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 14, i_size is 0, should be 56556544. Fix<y>? yes
> Pass 2: Checking directory structure
> ....
> #####TESTCASE_ENDdiff --git a/fs/direct-io.c b/fs/direct-io.c
> index af0558d..4e88bea 100644
> 
> Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
> ---
>  fs/direct-io.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index af0558d..4e88bea 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1209,6 +1209,16 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	retval = direct_io_worker(rw, iocb, inode, iov, offset,
>  				nr_segs, blkbits, get_block, end_io, dio);
>  
> +	/*
> +	 * In case of error extending write may have instantiated a few
> +	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
> +	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this by
> +	 * it's own meaner.
> +	 */
> +	if (unlikely(retval < 0 && (rw & WRITE) && (end > i_size_read(inode))
> +			&& dio_lock_type == DIO_LOCKING))
> +		vmtruncate(inode, inode->i_size);
> +
>  	if (rw == READ && dio_lock_type == DIO_LOCKING)
>  		release_i_mutex = 0;

Really we should use i_size_read() in both cases (i_mutex might not be
held).  How does this look?

	/*
	 * In case of error extending write may have instantiated a few
	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this by
	 * it's own meaner.
	 */
	if (unlikely(retval < 0 && (rw & WRITE))) {
		loff_t isize = i_size_read(inode);

		if (end > isize && dio_lock_type == DIO_LOCKING)
			vmtruncate(inode, isize);
	}


