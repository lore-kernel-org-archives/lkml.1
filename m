Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbZJGNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbZJGNMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933136AbZJGNMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082AbZJGNMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:12:37 -0400
Message-ID: <4ACC9373.6080703@redhat.com>
Date: Wed, 07 Oct 2009 09:11:15 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 44/45] NFS: remove NFS_INO_FLUSHING lock
References: <20091007073818.318088777@intel.com> <20091007074906.867871013@intel.com>
In-Reply-To: <20091007074906.867871013@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> It was introduced in 72cb77f4a5ac, and the several issues have been
> addressed in generic writeback:
> - out of order writeback (or interleaved concurrent writeback)
>   addressed by the per-bdi writeback and wait queue in balance_dirty_pages()
> - sync livelocked by a fast dirtier
>   addressed by throttling all to-be-synced dirty inodes
> 

I don't think that we can just remove this support.  It is
designed to reduce the effects from doing a stat(2) on a
file which is being actively written to.

If we do remove it, then we will need to replace this patch
with another.  Trond and I hadn't quite finished discussing
some aspects of that other patch...  :-)

	Thanx...

		ps

> CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
> CC: Peter Staubach <staubach@redhat.com>
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/nfs/file.c          |    9 ---------
>  fs/nfs/write.c         |   11 -----------
>  include/linux/nfs_fs.h |    1 -
>  3 files changed, 21 deletions(-)
> 
> --- linux.orig/fs/nfs/file.c	2009-10-07 14:31:45.000000000 +0800
> +++ linux/fs/nfs/file.c	2009-10-07 14:32:54.000000000 +0800
> @@ -386,15 +386,6 @@ static int nfs_write_begin(struct file *
>  		mapping->host->i_ino, len, (long long) pos);
>  
>  start:
> -	/*
> -	 * Prevent starvation issues if someone is doing a consistency
> -	 * sync-to-disk
> -	 */
> -	ret = wait_on_bit(&NFS_I(mapping->host)->flags, NFS_INO_FLUSHING,
> -			nfs_wait_bit_killable, TASK_KILLABLE);
> -	if (ret)
> -		return ret;
> -
>  	page = grab_cache_page_write_begin(mapping, index, flags);
>  	if (!page)
>  		return -ENOMEM;
> --- linux.orig/fs/nfs/write.c	2009-10-07 14:31:45.000000000 +0800
> +++ linux/fs/nfs/write.c	2009-10-07 14:32:54.000000000 +0800
> @@ -387,26 +387,15 @@ static int nfs_writepages_callback(struc
>  int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	struct inode *inode = mapping->host;
> -	unsigned long *bitlock = &NFS_I(inode)->flags;
>  	struct nfs_pageio_descriptor pgio;
>  	int err;
>  
> -	/* Stop dirtying of new pages while we sync */
> -	err = wait_on_bit_lock(bitlock, NFS_INO_FLUSHING,
> -			nfs_wait_bit_killable, TASK_KILLABLE);
> -	if (err)
> -		goto out_err;
> -
>  	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGES);
>  
>  	nfs_pageio_init_write(&pgio, inode, wb_priority(wbc));
>  	err = write_cache_pages(mapping, wbc, nfs_writepages_callback, &pgio);
>  	nfs_pageio_complete(&pgio);
>  
> -	clear_bit_unlock(NFS_INO_FLUSHING, bitlock);
> -	smp_mb__after_clear_bit();
> -	wake_up_bit(bitlock, NFS_INO_FLUSHING);
> -
>  	if (err < 0)
>  		goto out_err;
>  	err = pgio.pg_error;
> --- linux.orig/include/linux/nfs_fs.h	2009-10-07 14:31:45.000000000 +0800
> +++ linux/include/linux/nfs_fs.h	2009-10-07 14:32:54.000000000 +0800
> @@ -208,7 +208,6 @@ struct nfs_inode {
>  #define NFS_INO_STALE		(1)		/* possible stale inode */
>  #define NFS_INO_ACL_LRU_SET	(2)		/* Inode is on the LRU list */
>  #define NFS_INO_MOUNTPOINT	(3)		/* inode is remote mountpoint */
> -#define NFS_INO_FLUSHING	(4)		/* inode is flushing out data */
>  #define NFS_INO_FSCACHE		(5)		/* inode can be cached by FS-Cache */
>  #define NFS_INO_FSCACHE_LOCK	(6)		/* FS-Cache cookie management lock */
