Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZANSSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZANSSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZANSSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:18:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbZANSSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:18:41 -0500
Date: Wed, 14 Jan 2009 10:18:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Message-Id: <20090114101834.fbb9ea12.akpm@linux-foundation.org>
In-Reply-To: <1231945948-23676-2-git-send-email-jack@suse.cz>
References: <1231945948-23676-1-git-send-email-jack@suse.cz>
	<1231945948-23676-2-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 16:12:28 +0100 Jan Kara <jack@suse.cz> wrote:

> To be really safe that the data hit the platter, we should also flush drive's
> writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
> 

It's not good to randomly sprinkle blkdev_issue_flush() calls all over
the filesystem like this.  How do we know that you didn't miss a site? 
How do we ensure that people who modify the fs in the future don't
forget to add the blkdev_issue_flush() call, if needed?

IOW, it is fragile.  Is there anything we can do to make this more
robust?  Do the flush calls from some higher-level callsite?  Perhaps
even the VFS?

> @@ -97,8 +98,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
>  
>  	if (IS_DIRSYNC(dir)) {
>  		err = write_one_page(page, 1);
> -		if (!err)
> +		if (!err) {
>  			err = ext2_sync_inode(dir);
> +			blkdev_issue_flush(dir->i_sb->s_bdev, NULL);

The patch itself would have been a bit neater if it had added

int ext3_blkdev_issue_flush(struct inode *inode)

and called that, IMO.


Also, the changelog needs some work, methinks.

/**
 * blkdev_issue_flush - queue a flush
 * @bdev:	blockdev to issue flush for
 * @error_sector:	error sector
 *
 * Description:
 *    Issue a flush for the block device in question. Caller can supply
 *    room for storing the error offset in case of a flush error, if they
 *    wish to.  Caller must run wait_for_completion() on its own.
 */

So afaict the change you've made is incomplete.  We'll queue a
writeback command to the disk but we won't wait for it to be sent down
the wire.  Nor do we wait for the command to complete at the device
end.  So it can still be a looong time (seconds!) before the data which
the user thinks is on disk really is safe.

Yes?

If so, this design decision should be described in the changelog, and
justified.  Actually, doing this in the comment over
ext3_blkdev_issue_flush() would be good.


