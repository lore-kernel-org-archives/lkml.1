Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYLKUGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYLKUGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbYLKUG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:06:29 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42637 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbYLKUG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:06:28 -0500
Subject: Re: [PATCH] JFS: ensure link targets are NULL-terminated
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>,
       Dave.Kleikamp.shaggy@austin.ibm.com,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <1229022995-9898-9-git-send-email-duaneg@dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-2-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-3-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-4-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-5-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-6-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-7-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-8-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-9-git-send-email-duaneg@dghda.com>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 14:06:11 -0600
Message-Id: <1229025971.9245.18.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 19:16 +0000, Duane Griffin wrote:
> Ensure link targets are NULL-terminated, even if corrupted on-disk.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/jfs/symlink.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jfs/symlink.c b/fs/jfs/symlink.c
> index 4af1a05..f5f1b5d 100644
> --- a/fs/jfs/symlink.c
> +++ b/fs/jfs/symlink.c
> @@ -18,6 +18,7 @@
>  
>  #include <linux/fs.h>
>  #include <linux/namei.h>
> +#include "jfs_filsys.h"
>  #include "jfs_incore.h"
>  #include "jfs_inode.h"
>  #include "jfs_xattr.h"
> @@ -25,6 +26,7 @@
>  static void *jfs_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
>  	char *s = JFS_IP(dentry->d_inode)->i_inline;
> +	s[IDATASIZE - 1] = '\0';
>  	nd_set_link(nd, s);
>  	return NULL;
>  }

Thanks.

I came up with an alternate patch that I like slightly better.  This one
null-terminates the string when the inode is read rather than every time
the link is followed, and at the proper place (i_size).  It's not a big
deal, since the symlink will be corrupted either way.  What do you think
of this patch?

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 2103397..b00ee9f 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -59,8 +59,14 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		if (inode->i_size >= IDATASIZE) {
 			inode->i_op = &page_symlink_inode_operations;
 			inode->i_mapping->a_ops = &jfs_aops;
-		} else
+		} else {
 			inode->i_op = &jfs_symlink_inode_operations;
+			/*
+			 * The inline data should be null-terminated, but
+			 * don't let on-disk corruption crash the kernel
+			 */
+			JFS_IP(inode)->i_inline[inode->i_size] = '\0';
+		}
 	} else {
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);

-- 
David Kleikamp
IBM Linux Technology Center

