Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYLUPsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYLUPsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYLUPsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:48:42 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:58319 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYLUPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:48:41 -0500
Date: Sun, 21 Dec 2008 16:48:37 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: John Ogness <dazukocode@ogness.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/5] VFS: DazukoFS, stackable-fs, file access control
Message-ID: <20081221154837.GA1940@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	John Ogness <dazukocode@ogness.net>, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, malware-list@lists.printk.net,
	eparis@redhat.com, hch@infradead.org, alan@lxorguk.ukuu.org.uk
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net> <868wq9h905.fsf@johno-ibook.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <868wq9h905.fsf@johno-ibook.fn.ogness.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 03:56:42PM +0100, John Ogness wrote:
> +#ifndef __DAZUKOFS_FS_H
> +#define __DAZUKOFS_FS_H

There are several (okay, all) includes missing.

> +static inline
> +struct dazukofs_sb_info *GET_SB_INFO(struct super_block *upper_sb)

Coding-style.

> +static inline void SET_LOWER_INODE(struct inode *upper_inode,
> +				   struct inode *lower_inode)
> +{
> +	((struct dazukofs_inode_info *)
> +	 container_of(upper_inode, struct dazukofs_inode_info,
> +		      vfs_inode))->lower_inode = lower_inode;
> +}

Please make such cast cascades explicit:

| struct dazukofs_inode_info *info = container_of(...);
| info->lower_inode = lower_inode;

There are other people which want to read the code.

> +static int dazukofs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
> +{
> +	struct vfsmount *lower_mnt;
> +	struct dentry *lower_dentry;
> +	struct vfsmount *vfsmount_save;
> +	struct dentry *dentry_save;
> +	int valid;
> +
> +	valid = 1;
> +
> +	lower_dentry = GET_LOWER_DENTRY(dentry);
> +
> +	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
> +		goto out;

Why do you use goto instead of return?

> +static int dazukofs_d_hash(struct dentry *dentry, struct qstr *name)
> +{
> +	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
> +
> +	if (!lower_dentry || !lower_dentry->d_op ||
> +	    !lower_dentry->d_op->d_hash) {
> +		return 0;
> +	}

You mix rather different coding styles through the whole code. Also why
do you say that lower_dentry can be 0 in _hash, but not in _revalidate?

> +static void dazukofs_d_release(struct dentry *dentry)
> +{
> +	if (GET_DENTRY_INFO(dentry)) {
> +		dput(GET_LOWER_DENTRY(dentry));
> +		mntput(GET_LOWER_MNT(dentry));

Why do you push anything out in other functions while making it explicit
would make it much easier readable?

Bastian

-- 
Killing is stupid; useless!
		-- McCoy, "A Private Little War", stardate 4211.8
