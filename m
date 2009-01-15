Return-Path: <linux-kernel-owner+w=401wt.eu-S935162AbZAOXFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162AbZAOXFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936322AbZAOXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:04:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936281AbZAOXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:04:08 -0500
Date: Thu, 15 Jan 2009 15:03:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mhalcrow@us.ibm.com, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH] ecryptfs: some inode attrs, and a question
Message-Id: <20090115150332.f72ad0f8.akpm@linux-foundation.org>
In-Reply-To: <7471.1231827621@jrobl>
References: <7471.1231827621@jrobl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 15:20:21 +0900
hooanon05@yahoo.co.jp wrote:

> 
> Here are several fixes for linux-2.6.27/fs/ecryptfs.
> 
> - The ecryptfs inode holds a reference to the lower inode, but doesn't
>   increment the reference counter. When a user sets inotify to the
>   ecryptfs inode, it may live without the corresponding dentry. In this
>   case the referecen to the lower inode may be broken.
>   This patch maintains the reference of the lower inode.
> 
> - follow the VFS unlink sequence in ecryptfs_unlink() which is
>   inrementing and decrementing the inode->i_count and the reference
>   counter for the dentry.
> 
> - maintain the link count and ctime in ecryptfs_rmdir() because a user
>   may issue fstat(2) later.
> 
> - remove the unnecessary d_drop()s in ecryptfs_link().
> 
> And I have experienced a strange behaviour. When ecryptfs gets -ENOSPC
> from the lower fs, it converts and returns EINVAL to the userspace. Is
> this an intended behaviour?
> 

I am puzzled by the current ecryptfs maintenance situation.

I queued this for 2.6.30.  It could be bumped up for 2.6.29 (and even
backported to 2.6.28 and earlier) with suitable acks from the
maintainer(?)

> 
> ...
>
> +	atomic_inc_return(&lower_dentry->d_inode->i_count);
> +	atomic_inc_return(&lower_inode->i_count);

atomic_inc() would suffice here, yes?

From: Andrew Morton <akpm@linux-foundation.org>

s/atomic_inc_return/atomic_inc/

Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    2 +-
 fs/ecryptfs/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes-fix fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes-fix
+++ a/fs/ecryptfs/inode.c
@@ -479,7 +479,7 @@ static int ecryptfs_unlink(struct inode 
 
 	lower_dir_dentry = lock_parent(lower_dentry);
 	dget(lower_dentry);
-	atomic_inc_return(&lower_dentry->d_inode->i_count);
+	atomic_inc(&lower_dentry->d_inode->i_count);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	dput(lower_dentry);
 	if (rc) {
diff -puN fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes-fix fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes-fix
+++ a/fs/ecryptfs/super.c
@@ -102,7 +102,7 @@ static void ecryptfs_destroy_inode(struc
  */
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode)
 {
-	atomic_inc_return(&lower_inode->i_count);
+	atomic_inc(&lower_inode->i_count);
 	ecryptfs_set_inode_lower(inode, lower_inode);
 	inode->i_ino = lower_inode->i_ino;
 	inode->i_version++;
_

