Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbXHAO6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbXHAO6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932670AbXHAO6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:58:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60479 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665AbXHAO6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:58:46 -0400
Date: Wed, 1 Aug 2007 09:57:40 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.sourceforge.net, moriai.satoshi@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc1] eCryptfs: fix lookup error for special files
Message-ID: <20070801145740.GF30416@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <200708011301.AA00221@paprika.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708011301.AA00221@paprika.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:01:14PM +0900, Ryusuke Konishi wrote:
> When ecryptfs_lookup() is called against special files, eCryptfs
> generates the following errors because it tries to treat them like
> regular eCryptfs files.
> 
> Error opening lower file for lower_dentry [0xffff810233a6f150], lower_mnt [0xffff810235bb4c80], and flags 
> [0x8000]
> Error opening lower_file to read header region
> Error attempting to read the [user.ecryptfs] xattr from the lower file; return value = [-95]
> Valid metadata not found in header region or xattr region; treating file as unencrypted
> 
> For instance, the problem can be reproduced by the steps below.
> 
>   # mkdir /root/crypt /mnt/crypt
>   # mount -t ecryptfs /root/crypt /mnt/crypt
>   # mknod /mnt/crypt/c0 c 0 0
>   # umount /mnt/crypt
>   # mount -t ecryptfs /root/crypt /mnt/crypt
>   # ls -l /mnt/crypt
> 
> This patch fixes it by adding a check similar to directories and
> symlinks.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

> ---
>  fs/ecryptfs/inode.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 0a50942..131954b 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -353,6 +353,10 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
>  		ecryptfs_printk(KERN_DEBUG, "Is a symlink; returning\n");
>  		goto out;
>  	}
> +	if (special_file(lower_inode->i_mode)) {
> +		ecryptfs_printk(KERN_DEBUG, "Is a special file; returning\n");
> +		goto out;
> +	}
>  	if (!nd) {
>  		ecryptfs_printk(KERN_DEBUG, "We have a NULL nd, just leave"
>  				"as we *think* we are about to unlink\n");
