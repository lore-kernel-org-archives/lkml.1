Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYDMUnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYDMUnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYDMUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:43:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55998 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYDMUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:43:29 -0400
Date: Sun, 13 Apr 2008 21:43:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: alan@redhat.com, hch@infradead.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 4/8] revoke: core code V7
Message-ID: <20080413204315.GQ9785@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0712141716370.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712141716370.28689@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 05:16:54PM +0200, Pekka J Enberg wrote:
> +static void revoke_aliases(struct inode *inode)
> +{
> +	struct dentry *dentry;
> +restart:
> +	spin_lock(&dcache_lock);
> +	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
> +		spin_lock(&dentry->d_lock);
> +		if (!d_unhashed(dentry)) {
> +			dget_locked(dentry);
> +			__d_drop(dentry);
> +			spin_unlock(&dentry->d_lock);
> +			spin_unlock(&dcache_lock);
> +			dput(dentry);
> +			goto restart;
> +		}
> +		spin_unlock(&dentry->d_lock);
> +	}
> +	spin_unlock(&dcache_lock);
> +}

Don't do that to directories, kids...

> +static int revoke_files(struct inode *inode)
> +{
> +	struct super_block *sb;
> +	struct file *file;
> +	int err = 0;
> +
> +	sb = inode->i_sb;
> +	if (!sb)
> +		return -EINVAL;
> +
> +restart:
> +	file_list_lock();
> +	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
> +		struct dentry *dentry = file->f_path.dentry;
> +
> +		if (dentry->d_inode != inode)
> +			continue;
> +
> +		if (file->f_op != inode->i_fop)
> +			continue;

Skip everything that has reassigned ->f_op in open()?  That includes all
char devices, to start with...

> +		err = file->f_op->revoke(file);
> +		make_revoked_file(inode, file);

*Um*

Where exactly do we terminate operations in progress and how the devil is
locking supposed to be done in driver?
