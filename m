Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbXFTIBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbXFTIBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbXFTIAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:00:54 -0400
Received: from main.gmane.org ([80.91.229.2]:59369 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbXFTIAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:00:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC PATCH 3/4] Lookup changes to support union mount.
Date: Wed, 20 Jun 2007 07:51:58 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <f5amau$foi$3@sea.gmane.org>
References: <20070620055050.GB4267@in.ibm.com>
	<20070620055326.GE4267@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: pan 0.119 (Karma Hunters)
Cc: linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 11:23:26 +0530, Bharata B Rao wrote:

> +/*
> + * Looks for the given @name in dcache by walking through all the layers
> + * of the union stack, starting from the top.
> + * FIXME: If we don't find the dentry in a upper layer, we descend to the
> + * next layer. So there is a chance to miss this dentry in the top layer
> + * if this is the _first_ time lookup of the dentry in this layer. A real
> + * lookup might have fetched a valid dentry in this layer itself, while we
> + * chose to descend to the next lower layer. One solution is not have this
> + * function itself, do the toplevel lookup in dcache and if it fails proceed
> + * to real_lookup_union() directly.
> + */
> +struct dentry *__d_lookup_union(struct nameidata *nd, struct qstr *name)
> +{
> +	struct dentry *dentry;
> +	struct nameidata nd_tmp;
> +	struct vfsmount *mnt = mntget(nd->mnt);
> +	struct qstr this;
> +	int err;
> +
> +	nd_tmp.mnt = nd->mnt;
> +	nd_tmp.dentry = nd->dentry;
> +
> +	this.name = name->name;
> +	this.len = name->len;
> +	this.hash = name->hash;
> +
> +	do {
> +		/* d_hash() is a repetition for the top layer. */
> +		if (nd_tmp.dentry->d_op && nd_tmp.dentry->d_op->d_hash) {
> +			err = nd_tmp.dentry->d_op->d_hash(nd_tmp.dentry, &this);
> +			if (err < 0)
> +				goto out;
> +		}
> +
> +		dentry = __d_lookup(nd_tmp.dentry, &this);
> +		if (dentry) {
> +			if (dentry->d_inode) {
> +				if (nd->mnt != nd_tmp.mnt) {
> +					mntput(nd->mnt);
> +					nd->mnt = mntget(nd_tmp.mnt);
> +				}
> +				mntput(mnt);
> +				return dentry;
> +			} else {
> +				dput(dentry);
> +			}
> +		}
> +	} while (next_union_mount(&nd_tmp));
> +out:
> +	mntput(mnt);
> +	return NULL;
> +}
> +

The reference counting for vfsmount is wrong. next_union_mount() should be
something similar to follow_down(). You should grab the reference to the
underlying mount before doing the lookup. Ok ok, you already have a valid
reference in struct union_mount but anyway.

Jan

