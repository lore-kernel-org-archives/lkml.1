Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXLEPC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXLEPC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXLEPCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:02:19 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:21488 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXLEPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uGYNNzB85UUoApCXscC94dKDZrVEKBXRPBmGzQXvKz41dD++WFQRGOqMJiqQCN5142tymAKoyoyAovpixGW4cmSOB8BYRBofyn8UXgNLoJ7jVEADYxYrNcvK/eIPizJkQYHS/EtKr8uOLOYqVRtMVBwntueGFADfXbHYpd+nJww=
Message-ID: <105610bf0712050702j4d0f3c33l21fd6137ac3fd1f5@mail.gmail.com>
Date: Wed, 5 Dec 2007 23:02:16 +0800
From: wit <is01kzh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: about mounting the sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I found the initialization code of the sysfs in version 2.6.22:

int __init sysfs_init(void)
{
    int err = -ENOMEM;

    sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
                          sizeof(struct sysfs_dirent),
                          0, 0, NULL, NULL);
    if (!sysfs_dir_cachep)
        goto out;

    err = register_filesystem(&sysfs_fs_type);
    if (!err) {
        sysfs_mount = kern_mount(&sysfs_fs_type);
 ........

my questions are:
1. Is some initializing script responsible for mounting the sysfs? If
so, why do we call kern_mount.
2. I looked into the kern_mount code, the routine seems to get the
super block and the inode object for the sysfs, but when setting the
root, I got:
	root = d_alloc_root(inode);
	if (!root) {
		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
		iput(inode);
		return -ENOMEM;
	}
	root->d_fsdata = &sysfs_root;
	sb->s_root = root;

and the s_root is then passed to the mnt_root and the mnt_mountpoint:

int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
{
	mnt->mnt_sb = sb;
	mnt->mnt_root = dget(sb->s_root);
	return 0;
}

in vfs_kern_mount:
.......
	mnt->mnt_mountpoint = mnt->mnt_root;
	mnt->mnt_parent = mnt;
	up_write(&mnt->mnt_sb->s_umount);
.......

So, does this means we get the mount point from d_alloc_root(inode),
but this doesn't look like the truth. d_alloc_root seems to allocate a
dentry for the root, is that true? If so, why for the root?
Does the s_root stand for the root of the file system, so it should
always be "/", but this is different from root file system? But what
about the mnt_moountpoint, how does the kernel store the path (rooted
from the  root file system)?

Thanks
