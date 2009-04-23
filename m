Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZDWQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZDWQ5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZDWQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:57:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZDWQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:57:36 -0400
Date: Thu, 23 Apr 2009 12:57:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] vfs: Make sys_sync() use fsync_super() (version 2)
Message-ID: <20090423165736.GB4083@infradead.org>
References: <1240498045-14288-1-git-send-email-jack@suse.cz> <1240498045-14288-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240498045-14288-5-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int __sync_blockdev(struct block_device *bdev, int wait)
> +{
> +	if (!bdev)
> +		return 0;
> +	if (!wait)
> +		return filemap_flush(bdev->bd_inode->i_mapping);
> +	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
> +}

I wonder if the filemap_flush for the async case really buys us much,
all the async and then later sync writeback activities of the FS will
redirty lots of bits of the blockdev mapping that we then have to write
twice.

> @@ -284,7 +277,12 @@ static int __fsync_super(struct super_block *sb)
>   */
>  int fsync_super(struct super_block *sb)
>  {
> -	return __fsync_super(sb);
> +	int ret;
> +
> +	ret = __fsync_super(sb, 0);
> +	if (ret < 0)
> +		return ret;
> +	return __fsync_super(sb, 1);

This async first then wait approach does have some benefits when syncing
multiple filesystems, but I wonder if it isn't actually conta-productive
when syncing a single one.

Maybe this should be a separate patch ontop to allow for more
fine-grained benchmarking.

>  /*
> - * Call the ->sync_fs super_op against all filesystems which are r/w and
> - * which implement it.
> + * Sync all the data for all the filesystems (called by do_sync())

Your patch removes do_sync :)

>  static void do_sync_work(struct work_struct *work)
>  {
> -	do_sync(0);
> +	/*
> +	 * Sync twice to reduce the possibility we skipped some inodes / pages
> +	 * because they were temporarily locked
> +	 */
> +	sync_filesystems(0);
> +	sync_filesystems(0);
> +	printk("Emergency Sync complete\n");
>  	kfree(work);

Ah, nice.  Good to have this out of the sys_sync path.


The patch looks generally good but I'll need some heavy testing.  I'll
do some XFS testing with it ASAP.
