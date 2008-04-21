Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYDUPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYDUPSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYDUPSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:18:32 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36373 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbYDUPSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:18:31 -0400
To: me@bobcopeland.com
CC: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       me@bobcopeland.com
In-reply-to: <1208637457-24969-5-git-send-email-me@bobcopeland.com> (message
	from Bob Copeland on Sat, 19 Apr 2008 16:37:33 -0400)
Subject: Re: [PATCH 4/8] omfs: add directory routines
References: <1208637457-24969-5-git-send-email-me@bobcopeland.com>
Message-Id: <E1Jnxmc-0002xo-T8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Apr 2008 17:18:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int omfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> +{
> +	int err = 0;
> +	struct inode *inode;
> +
> +	mode |= S_IFDIR;
> +
> +	inode = omfs_new_inode(dir, mode);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	if (dir->i_mode & S_ISGID) {
> +		inode->i_gid = dir->i_gid;
> +		if (S_ISDIR(mode))
> +			inode->i_mode |= S_ISGID;
> +	}
> +
> +	err = omfs_make_empty(inode, dir->i_sb);
> +	if (err)
> +		goto out;
> +
> +	err = omfs_add_link(dentry, inode);
> +	if (err)
> +		goto out;

These are leaking the inode reference.

There's more like these in the patch, please check all
omfs_new_inode() calls.

Miklos

> +
> +	d_instantiate(dentry, inode);
> +out:
> +	return err;
> +}

