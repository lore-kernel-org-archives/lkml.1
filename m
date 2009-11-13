Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZKMNaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZKMNaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZKMNaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:30:03 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:46097 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbZKMNaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:30:02 -0500
Subject: Re: [PATCH] nfs4: handle situation where dentry wasn't revalidated
 on open
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       adobriyan@gmail.com, viro@ZenIV.linux.org.uk, jamie@shareable.org
In-Reply-To: <1258118636-1348-1-git-send-email-jlayton@redhat.com>
References: <1258118636-1348-1-git-send-email-jlayton@redhat.com>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 22:30:00 +0900
Message-Id: <1258119000.7430.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 1875 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 765FA71A7844D11230C0E07F7DE90CF4D2FDE7DD
X-UiO-SPAM-Test: remote_host: 60.45.238.24 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 1 max/h 1 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 08:23 -0500, Jeff Layton wrote:
> This patch is an alternate approach to fixing this problem that doesn't
> rely on VFS changes...
> 
> Currently, the NFSv4 client code relies on the ->lookup and
> ->d_revalidate codepaths to handle the open processing during lookup. In
> certain situations (notably LAST_BIND symlinks and file bind mounts)
> it's possible for the VFS to skip calling d_revalidate on a dentry that
> it finds in the cache. If this is done on an open call, the file doesn't
> get opened on the wire, no state is established and stateful operations
> fail against it.
> 
> This patchset fixes this problem by taking advantage of the fact that we
> can pass an open routine to lookup_instantiate_filp. A new open file
> operation for NFSv4 is added that should only be called if the filp
> wasn't instantiated during lookup. The original open routine is passed
> to lookup_instantiate_filp to ensure no change in behavior there.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
<snip>
> +/*
> + * should only be called when VFS skips revalidation
> + */
> +int
> +nfs4_open(struct inode *inode, struct file *filp)
> +{
> +	struct inode *dir = filp->f_path.dentry->d_parent->d_inode;
> +	struct rpc_cred *cred;
> +	struct nfs_open_context *ctx;
> +
> +	cred = rpc_lookup_cred();
> +	if (IS_ERR(cred))
> +		return PTR_ERR(cred);
> +
> +	ctx = alloc_nfs_open_context(filp->f_path.mnt, filp->f_path.dentry, cred);
> +	if (ctx == NULL) {
> +		put_rpccred(cred);
> +		return -ENOMEM;
> +	}
> +
> +	ctx->state = nfs4_do_open(dir, &filp->f_path, filp->f_mode, filp->f_flags, NULL, cred);
> +	put_rpccred(cred);
> +	if (IS_ERR(ctx->state)) {
> +		put_nfs_open_context(ctx);
> +		return PTR_ERR(ctx->state);
> +	}
> +	ctx->mode = filp->f_mode;
> +	nfs_set_verifier(filp->f_path.dentry, nfs_save_change_attribute(dir));
> +	nfs_file_set_open_context(filp, ctx);
> +	put_nfs_open_context(ctx);
> +	nfs_fscache_set_inode_cookie(inode, filp);
> +	return 0;
> +}
> +

So what happens if the file has been renamed/deleted/replaced since the
lookup occurred? You basically end up with a state that corresponds to a
different file than the filp->f_path...

Cheers
  Trond

