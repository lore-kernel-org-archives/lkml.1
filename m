Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZD0Tm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZD0Tm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZD0TmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:42:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbZD0TmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:42:14 -0400
Date: Mon, 27 Apr 2009 12:38:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       trond.myklebust@fys.uio.no, jack@suse.cz
Subject: Re: [PATCH 1/8] vfs: Fix sys_sync() and fsync_super() reliability
 (version 4)
Message-Id: <20090427123825.d24dbbbc.akpm@linux-foundation.org>
In-Reply-To: <1240843435-1786-2-git-send-email-jack@suse.cz>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
	<1240843435-1786-2-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 16:43:48 +0200
Jan Kara <jack@suse.cz> wrote:

> So far, do_sync() called:
>   sync_inodes(0);
>   sync_supers();
>   sync_filesystems(0);
>   sync_filesystems(1);
>   sync_inodes(1);

The description has me all confused.

> This ordering makes it kind of hard for filesystems as sync_inodes(0) need not
> submit all the IO (for example it skips inodes with I_SYNC set) so e.g. forcing
> transaction to disk in ->sync_fs() is not really enough.

Is not really enough for what?

sync_fs(wait==0) is not supposed to be reliable - it's an advice to the
fs that it should push as much "easy" writeback into the queue as
possible.  We'll do the real sync later, with sync_fs(wait==1).

> Therefore sys_sync has
> not been completely reliable on some filesystems (ext3, ext4, reiserfs, ocfs2
> and others are hit by this) when racing e.g. with background writeback.

No sync can ever be reliable in the presence of concurrent write
activity, unless we freeze userspace.

> A
> similar problem hits also other filesystems (e.g. ext2) because of
> write_supers() being called before the sync_inodes(1).
> 
> Change the ordering of calls in do_sync() - this requires a new function
> sync_blkdevs() to preserve the property that block devices are always synced
> after write_super() / sync_fs() call.
> 
> The same issue is fixed in __fsync_super() function used on umount /
> remount read-only.

So it's all a bit unclear (to me) what this patch is trying to fix?


> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/super.c         |   27 ++++++++++++++++++++++++++-
>  fs/sync.c          |    3 ++-
>  include/linux/fs.h |    2 ++
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 786fe7d..4826540 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -267,6 +267,7 @@ void __fsync_super(struct super_block *sb)
>  {
>  	sync_inodes_sb(sb, 0);
>  	vfs_dq_sync(sb);
> +	sync_inodes_sb(sb, 1);
>  	lock_super(sb);
>  	if (sb->s_dirt && sb->s_op->write_super)
>  		sb->s_op->write_super(sb);
> @@ -274,7 +275,6 @@ void __fsync_super(struct super_block *sb)
>  	if (sb->s_op->sync_fs)
>  		sb->s_op->sync_fs(sb, 1);
>  	sync_blockdev(sb->s_bdev);
> -	sync_inodes_sb(sb, 1);
>  }
>  
>  /*
> @@ -502,6 +502,31 @@ restart:
>  	mutex_unlock(&mutex);
>  }
>  
> +/*
> + *  Sync all block devices underlying some superblock
> + */
> +void sync_blockdevs(void)
> +{
> +	struct super_block *sb;
> +
> +	spin_lock(&sb_lock);
> +restart:
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		if (!sb->s_bdev)
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +		down_read(&sb->s_umount);
> +		if (sb->s_root)
> +			sync_blockdev(sb->s_bdev);
> +		up_read(&sb->s_umount);
> +		spin_lock(&sb_lock);
> +		if (__put_super_and_need_restart(sb))
> +			goto restart;
> +	}
> +	spin_unlock(&sb_lock);
> +}

The comment doesn't match the implementation.  This function syncs all
blockdevs underlying _all_ superblocks.

