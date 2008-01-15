Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbYAOPPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbYAOPPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYAOPPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:15:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37035 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYAOPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:15:01 -0500
Subject: Re: [RFC/PATCH 4/8] revoke: core code V7
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712141716370.28689@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0712141716370.28689@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 16:14:54 +0100
Message-Id: <1200410094.26045.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 17:16 +0200, Pekka J Enberg wrote:

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
> +
> +		get_file(file);
> +
> +		/*
> +		 * inode->i_mutex cannot be acquired under files_lock
> +		 */
> +		file_list_unlock();
> +
> +		err = file->f_op->revoke(file);
> +		make_revoked_file(inode, file);
> +		fput(file);
> +
> +		if (err)
> +			goto out;
> +
> +		if (signal_pending(current)) {
> +			err = -EINTR;
> +			goto out;
> +		}
> +		cond_resched();
> +		goto restart;
> +	}
> +	file_list_unlock();
> +out:
> +	return err;
> +}

Humm, we were trying to get rid of file_list_lock(), this puts up
another user of the sb file list.

Also, that loop looks horribly expensive: n*(1+m); where n is the list
size, and m the number of matching fds.

Granted, I see no other options either.

