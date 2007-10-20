Return-Path: <linux-kernel-owner+w=401wt.eu-S935890AbXJTBfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935890AbXJTBfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbXJTBfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:35:16 -0400
Received: from lixom.net ([66.141.50.11]:58042 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbXJTBfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:35:13 -0400
Date: Fri, 19 Oct 2007 20:41:49 -0500
From: Olof Johansson <olof@lixom.net>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] NFS client fixes for 2.6.23++
Message-ID: <20071020014149.GA19871@lixom.net>
References: <1192828993.7466.18.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192828993.7466.18.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nfs: Fix build break with CONFIG_NFS_V4=n

Signed-off-by: Olof Johansson <olof@lixom.net>

---


On Fri, Oct 19, 2007 at 05:23:13PM -0400, Trond Myklebust wrote:
> Hi Linus,
> 
> Please pull from the repository at
> 
>    git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git
> 
> This will update the following files through the appended changesets.
> 
[...]
> @@ -522,8 +522,12 @@ void put_nfs_open_context(struct nfs_open_context *ctx)
>  		return;
>  	list_del(&ctx->list);
>  	spin_unlock(&inode->i_lock);
> -	if (ctx->state != NULL)
> -		nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
> +	if (ctx->state != NULL) {
> +		if (wait)
> +			nfs4_close_sync(&ctx->path, ctx->state, ctx->mode);
> +		else
> +			nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
> +	}
>  	if (ctx->cred != NULL)
>  		put_rpccred(ctx->cred);
>  	dput(ctx->path.dentry);

This gives me build errors on most PPC defconfigs, which don't enable NFSv4.

This seems sufficient to fix it.


diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index a4e3b96..b35069a 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -236,6 +236,7 @@ extern struct svc_version nfs4_callback_version1;
 #else
 
 #define nfs4_close_state(a, b, c) do { } while (0)
+#define nfs4_close_sync(a, b, c) do { } while (0)
 
 #endif /* CONFIG_NFS_V4 */
 #endif /* __LINUX_FS_NFS_NFS4_FS.H */
