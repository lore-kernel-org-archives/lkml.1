Return-Path: <linux-kernel-owner+w=401wt.eu-S1750750AbXBUAhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750750AbXBUAhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXBUAhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:37:48 -0500
Received: from pat.uio.no ([129.240.10.15]:41045 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXBUAhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:37:46 -0500
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070220172345.GA19249@lixom.net>
References: <20070216170532.GA4895@lixom.net>
	 <1171984200.6271.15.camel@heimdal.trondhjem.org>
	 <20070220172345.GA19249@lixom.net>
Content-Type: multipart/mixed; boundary="=-/fKSCJBlg1PTbkCVRqg4"
Date: Tue, 20 Feb 2007 19:37:18 -0500
Message-Id: <1172018238.6421.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 8F9B4346025A06AAEC2B02FC0BF3310822361930
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 265 total 591547 max/h 2803 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/fKSCJBlg1PTbkCVRqg4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-02-20 at 11:23 -0600, Olof Johansson wrote:

> In my original reproduction, I had to boot with nfs root, and try to mount
> my sata drive (/dev/sda3). This is with a static /dev, no udev. Seems like it
> happens when trying to mount any block device that's located on NFS.
> 
> Since this is what nfs_sync_mapping_wait does:
> 
> long nfs_sync_mapping_wait(struct address_space *mapping, struct
> 		 	   writeback_control *wbc, int how) {
>         struct inode *inode = mapping->host;
>         struct nfs_inode *nfsi = NFS_I(inode);
> [...]
>         spin_lock(&nfsi->req_lock);
> [...]
> 
> I added this and it pops when mounting:
> 
> @@ -421,6 +421,10 @@ int nfs_getattr(struct vfsmount *mnt, st
>         int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
>         int err;
>  
> +       if (inode->i_mapping->host != inode) {
> +               printk("inode %p host %p\n", inode, inode->i_mapping->host);
> +               printk("inode_nfs %p host_nfs %p\n", NFS_I(inode), NFS_I(inode->i_mapping->host));
> +       }
>         /* Flush out writes to the server in order to update c/mtime */
>         nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
>  
> 
> I don't claim to know VFS internals, but doesn't it make sense that the
> device node is backed against the actual device, not an NFS inode? And
> if so, NFS can't expect to do nfs_sync_mapping_range() on it, or at
> least not dereference ->host and use it as an NFS inode, right?

NFS still has to manage the inode attributes and handle permissions. It
is only when you open the device that the VFS takes over (see the call
to init_special_inode() in nfs_fhget()).

> What I'm not sure I understand is why it disappears in the first place
> when I add the spin lock init -- I never even see the i_mapping->host
> pointer being allocated as an nfs inode. Maybe I just messed that one
> up somehow.

Looks like we need a check in nfs_getattr() for a regular file. It makes
no sense to call nfs_sync_mapping_range() on anything else. I think that
should fix your problem: it will stop the NFS client from interfering
with dirty pages on that inode's mapping.

Cheers
  Trond

--=-/fKSCJBlg1PTbkCVRqg4
Content-Disposition: inline; filename=linux-2.6.20-000-fix_block_device_getattr.dif
Content-Type: message/rfc822; name=linux-2.6.20-000-fix_block_device_getattr.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 20 Feb 2007 19:28:07 -0500
NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
Subject: No Subject
Message-Id: <1172017790.6421.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index af53c02..93d046c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -429,7 +429,8 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	int err;
 
 	/* Flush out writes to the server in order to update c/mtime */
-	nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
 
 	/*
 	 * We may force a getattr if the user cares about atime.

--=-/fKSCJBlg1PTbkCVRqg4--

