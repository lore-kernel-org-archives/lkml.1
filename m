Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbXFTH6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbXFTH6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbXFTH55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:57:57 -0400
Received: from main.gmane.org ([80.91.229.2]:36615 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbXFTH54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:57:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC PATCH 2/4] Mount changes to support union mount.
Date: Wed, 20 Jun 2007 07:47:11 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <f5am1v$foi$2@sea.gmane.org>
References: <20070620055050.GB4267@in.ibm.com>
	<20070620055241.GD4267@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: pan 0.119 (Karma Hunters)
Cc: linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 11:22:41 +0530, Bharata B Rao wrote:

> +/*
> + * When propagating mount events to peer group, this is called under
> + * vfsmount_lock. Hence using GFP_ATOMIC for kmalloc here.
> + * TODO: Can we use a separate kmem cache for union_mount ?
> + */
> +struct union_mount *alloc_union_mount(struct vfsmount *src_mnt,
> +	struct dentry *src_dentry, struct vfsmount *dst_mnt,
> +	struct dentry *dst_dentry)
> +{
> +	struct union_mount *u;
> +	u = kmalloc(sizeof(struct union_mount), GFP_ATOMIC);
> +	if (!u)
> +		return u;
> +	u->dst_mnt = mntget(dst_mnt);
> +	u->dst_dentry = dget(dst_dentry);
> +	u->src_mnt = src_mnt;
> +	u->src_dentry = dget(src_dentry);
> +	INIT_LIST_HEAD(&u->hash);
> +	INIT_LIST_HEAD(&u->list);
> +	return u;
> +}

Hmm, you pin the dentries in memory until umount. This isn't good. Besides
that this doesn't work with file systems that do invalidate their
dentries. The file system must have a chance to replace the dentry in the
union structure.

Jan

