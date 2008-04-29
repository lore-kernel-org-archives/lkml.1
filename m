Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYD2VfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYD2VfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYD2Ve7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:34:59 -0400
Received: from pat.uio.no ([129.240.10.15]:50726 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYD2Ve6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:34:58 -0400
Subject: Re: [RFC][PATCH 2/5] introduce simple_set_mnt_no_get() helper for
	NFS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
In-Reply-To: <20080429185945.8D7AD196@kernel>
References: <20080429185943.3BA6A050@kernel>
	 <20080429185945.8D7AD196@kernel>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 14:34:53 -0700
Message-Id: <1209504893.8321.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: AA0C76AC85E13529E77BC565B59B8936887FCC24
X-UiO-SR-test: 8B9D36208A5E18B9794A57882A7447B0E5EAFC30
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 324 total 8155224 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 11:59 -0700, Dave Hansen wrote:
> The next patch will introduce a list of all mounts for a given
> superblock.  In order to keep the list, we need to make sure
> all filesystems attaching a mount to a superblock get added
> to this list.
> 
> NFS currently bypasses the simple_set_mnt() function, and sets
> mnt_sb directly.  This patch makes it use a helper function,
> instead.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/fs/namespace.c     |   11 +++++++++--
>  linux-2.6.git-dave/fs/nfs/super.c     |   10 +++++-----
>  linux-2.6.git-dave/include/linux/fs.h |    1 +
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff -puN fs/namespace.c~introduce_simple_set_mnt_no_get_helper_for_NFS fs/namespace.c
> --- linux-2.6.git/fs/namespace.c~introduce_simple_set_mnt_no_get_helper_for_NFS	2008-04-29 11:56:39.000000000 -0700
> +++ linux-2.6.git-dave/fs/namespace.c	2008-04-29 11:56:39.000000000 -0700
> @@ -402,12 +402,19 @@ static void __mnt_unmake_readonly(struct
>  	spin_unlock(&vfsmount_lock);
>  }
>  
> -int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
> +int simple_set_mnt_no_get(struct vfsmount *mnt, struct super_block *sb)
>  {
>  	mnt->mnt_sb = sb;
> -	mnt->mnt_root = dget(sb->s_root);
> +	add_mount_to_sb_list(mnt, sb);
>  	return 0;
>  }
> +EXPORT_SYMBOL(simple_set_mnt_no_get);
> +
> +int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
> +{
> +	mnt->mnt_root = dget(sb->s_root);
> +	return simple_set_mnt_no_get(mnt, sb);
> +}
>  

My only concern is the proliferation of 'simple_*' operations: in some
cases in libfs.c we explicitly label those as being for in-memory/ramfs
filesystems, whereas in other cases (such as this one) the name appears
to be used for more generic functions.

Cheers
  Trond

