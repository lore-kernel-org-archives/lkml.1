Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXBTRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXBTRN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030311AbXBTRN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:13:57 -0500
Received: from lixom.net ([66.141.50.11]:44981 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030297AbXBTRN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:13:56 -0500
Date: Tue, 20 Feb 2007 11:23:45 -0600
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
Message-ID: <20070220172345.GA19249@lixom.net>
References: <20070216170532.GA4895@lixom.net> <1171984200.6271.15.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171984200.6271.15.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 10:10:00AM -0500, Trond Myklebust wrote:
> > Trond, is your MAINTAINERS entry up to date? Seems like you mostly post
> > from @netapp.com these days.
> 
> I tend to be easier to get hold of via the fys.uio.no address, since
> that isn't hidden behind a VPN. I use the netapp.com address when
> posting patches etc since that is sort of required by the developers
> certificate of origin.

Ok, no problem. Just figured I'd ask.

> > Index: linux-2.6/fs/nfs/inode.c
> > ===================================================================
> > --- linux-2.6.orig/fs/nfs/inode.c
> > +++ linux-2.6/fs/nfs/inode.c
> > @@ -1123,6 +1123,7 @@ struct inode *nfs_alloc_inode(struct sup
> >  	nfsi->flags = 0UL;
> >  	nfsi->cache_validity = 0UL;
> >  	nfsi->cache_change_attribute = jiffies;
> > +	nfsi->req_lock = SPIN_LOCK_UNLOCKED;
> >  #ifdef CONFIG_NFS_V3_ACL
> >  	nfsi->acl_access = ERR_PTR(-EAGAIN);
> >  	nfsi->acl_default = ERR_PTR(-EAGAIN);
> 
> As Andrew implied, this spin lock should already be initialised by the
> slab allocator in the "init_once" callback. Is this a vanilla kernel, or
> do you have any extra patches applied?

Plain 2.6.20 on an old dual g5 with g5_defconfig + NFS_ROOT +
serial port enabled. To see the error instead of lockup I enable
CONFIG_DEBUG_SPINLOCK.

In my original reproduction, I had to boot with nfs root, and try to mount
my sata drive (/dev/sda3). This is with a static /dev, no udev. Seems like it
happens when trying to mount any block device that's located on NFS.

Since this is what nfs_sync_mapping_wait does:

long nfs_sync_mapping_wait(struct address_space *mapping, struct
		 	   writeback_control *wbc, int how) {
        struct inode *inode = mapping->host;
        struct nfs_inode *nfsi = NFS_I(inode);
[...]
        spin_lock(&nfsi->req_lock);
[...]

I added this and it pops when mounting:

@@ -421,6 +421,10 @@ int nfs_getattr(struct vfsmount *mnt, st
        int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
        int err;
 
+       if (inode->i_mapping->host != inode) {
+               printk("inode %p host %p\n", inode, inode->i_mapping->host);
+               printk("inode_nfs %p host_nfs %p\n", NFS_I(inode), NFS_I(inode->i_mapping->host));
+       }
        /* Flush out writes to the server in order to update c/mtime */
        nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
 

I don't claim to know VFS internals, but doesn't it make sense that the
device node is backed against the actual device, not an NFS inode? And
if so, NFS can't expect to do nfs_sync_mapping_range() on it, or at
least not dereference ->host and use it as an NFS inode, right?

What I'm not sure I understand is why it disappears in the first place
when I add the spin lock init -- I never even see the i_mapping->host
pointer being allocated as an nfs inode. Maybe I just messed that one
up somehow.


-Olof
