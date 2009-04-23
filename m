Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZDWQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZDWQmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZDWQmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:42:21 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:53118 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZDWQmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:42:20 -0400
Subject: Re: [PATCH 3/4] vfs: Make __fsync_super() a static function
 (version 2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240498045-14288-4-git-send-email-jack@suse.cz>
References: <1240498045-14288-1-git-send-email-jack@suse.cz>
	 <1240498045-14288-4-git-send-email-jack@suse.cz>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 12:42:12 -0400
Message-Id: <1240504932.11148.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: 
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: CE7AFC089AA29F9F0E6B83829B0B17D83532A30E
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 188 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 16:47 +0200, Jan Kara wrote:
> __fsync_super() does the same thing as fsync_super(). So change the only
> caller to use fsync_super() and make __fsync_super() static. This removes
> unnecessarily duplicated call to sync_blockdev() and prepares ground
> for the changes to __fsync_super() in the following patches.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/block_dev.c     |    2 +-
>  fs/super.c         |    5 ++---
>  include/linux/fs.h |    1 -
>  3 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index f45dbc1..48d1290 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -240,7 +240,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
>  		sb->s_frozen = SB_FREEZE_WRITE;
>  		smp_wmb();
>  
> -		__fsync_super(sb);
> +		fsync_super(sb);
>  
>  		sb->s_frozen = SB_FREEZE_TRANS;
>  		smp_wmb();
> diff --git a/fs/super.c b/fs/super.c
> index d9759e0..4c92068 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -263,7 +263,7 @@ EXPORT_SYMBOL(unlock_super);
>   * device.  Takes the superblock lock.  Requires a second blkdev
>   * flush by the caller to complete the operation.
>   */
> -void __fsync_super(struct super_block *sb)
> +static int __fsync_super(struct super_block *sb)
          ^^^ Typo?

>  {
>  	sync_inodes_sb(sb, 0);
>  	vfs_dq_sync(sb);
> @@ -284,8 +284,7 @@ void __fsync_super(struct super_block *sb)
>   */
>  int fsync_super(struct super_block *sb)
>  {
> -	__fsync_super(sb);
> -	return sync_blockdev(sb->s_bdev);
> +	return __fsync_super(sb);
>  }
>  EXPORT_SYMBOL_GPL(fsync_super);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4bad02e..47a67c9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2084,7 +2084,6 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
>  extern int vfs_fsync(struct file *file, struct dentry *dentry, int datasync);
>  extern void sync_supers(void);
>  extern void sync_filesystems(int wait);
> -extern void __fsync_super(struct super_block *sb);
>  extern void emergency_sync(void);
>  extern void emergency_remount(void);
>  extern int do_remount_sb(struct super_block *sb, int flags,

