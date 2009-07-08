Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZGHKJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZGHKJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZGHKJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:09:24 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:2962
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889AbZGHKJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:09:23 -0400
Message-ID: <4A547050.20606@panasas.com>
Date: Wed, 08 Jul 2009 13:09:20 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@nokia.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] VFS: introduce helpers for manipulation s_dirty flag
References: <20090707180541.17048.49901.sendpatchset@localhost.localdomain> <20090707180548.17048.74367.sendpatchset@localhost.localdomain>
In-Reply-To: <20090707180548.17048.74367.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 10:09:23.0300 (UTC) FILETIME=[2ABD1240:01C9FFB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 09:05 PM, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH] VFS: introduce helpers for manipulation s_dirty flag
> 
> This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
> 'mark_sb_clean()', and 'is_sb_dirty()'. The helpers simply
> set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
> every FS use these helpers instead of manipulating
> 'sb->s_dirt' directly.
> 
> This patch also makes all file-systems use the helpers.
> 
> This patch is just a preparation for further periodic write-back
> timer optimizations. No functional changes yet.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  fs/exofs/inode.c      |    2 +-
>  fs/exofs/super.c      |    6 +++---
<snip>
> diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
> index 77d0a29..cb20f1c 100644
> --- a/fs/exofs/inode.c
> +++ b/fs/exofs/inode.c
> @@ -1066,7 +1066,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
>  
>  	sbi = sb->s_fs_info;
>  
> -	sb->s_dirt = 1;
> +	mark_sb_dirty(sb);
>  	inode->i_uid = current->cred->fsuid;
>  	if (dir->i_mode & S_ISGID) {
>  		inode->i_gid = dir->i_gid;
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 8216c5b..14263ff 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -241,7 +241,7 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
>  		EXOFS_ERR("exofs_write_super: exofs_sync_op failed.\n");
>  		goto out;
>  	}
> -	sb->s_dirt = 0;
> +	mark_sb_clean(sb);
>  
>  out:
>  	if (or)
> @@ -257,7 +257,7 @@ static void exofs_write_super(struct super_block *sb)
>  	if (!(sb->s_flags & MS_RDONLY))
>  		exofs_sync_fs(sb, 1);
>  	else
> -		sb->s_dirt = 0;
> +		mark_sb_clean(sb);
>  }
>  
>  /*
> @@ -271,7 +271,7 @@ static void exofs_put_super(struct super_block *sb)
>  
>  	lock_kernel();
>  
> -	if (sb->s_dirt)
> +	if (is_sb_dirty(sb))
>  		exofs_write_super(sb);
>  
>  	/* make sure there are no pending commands */
<snip>

I have just asked a pull request from Linus with a patch that adds
one more "if (sb->s_dirt)" call site. So if he pulls it into 2.6.31-rc3
I'll send you a mail and you can update. If not then it will go in at
2.6.32, please tel me when this is going into linux-next and through which
tree, and I'll sync with it.

Boaz
