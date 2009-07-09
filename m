Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZGIRvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZGIRvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZGIRu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:50:58 -0400
Received: from mx2.netapp.com ([216.240.18.37]:32899 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZGIRu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:50:58 -0400
X-IronPort-AV: E=Sophos;i="4.42,374,1243839600"; 
   d="scan'208";a="202824231"
Subject: Re: [PATCH][RFC] NFS: Propagate 'fsc' mount option through
 automounts
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: steved@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1552.1247160463@redhat.com>
References: <1552.1247160463@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Thu, 09 Jul 2009 13:50:51 -0400
Message-Id: <1247161851.5766.44.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 09 Jul 2009 17:50:56.0303 (UTC) FILETIME=[CF77BBF0:01CA00BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 18:27 +0100, David Howells wrote:
> Propagate the NFS 'fsc' mount option through NFS automounts of various types.
> 
> This is now required as commit:
> 
> 	commit c02d7adf8c5429727a98bad1d039bccad4c61c50
> 	Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> 	Date:   Mon Jun 22 15:09:14 2009 -0400
> 
> 	NFSv4: Replace nfs4_path_walk() with VFS path lookup in a private namespace
> 
> now uses VFS-driven automounting to reach all submounts barring the root, thus
> preventing fscaching from being enabled on any submount other than the root.
> 
> This patch gets around that by propagating the NFS_OPTION_FSCACHE flag across
> automounts.
> 
> Note, however, that it doesn't propagate the uniquifier in the case of
> 'fsc=<xxx>' being passed to mount.  This is probably wrong, and needs looking
> at.

Why not just use the mount path as the default uniquifier?

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/nfs/client.c |    1 +
>  fs/nfs/super.c  |    6 ++++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index c2d0616..0949b46 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -964,6 +964,7 @@ static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_serve
>  	target->acdirmin = source->acdirmin;
>  	target->acdirmax = source->acdirmax;
>  	target->caps = source->caps;
> +	target->options = source->options;

BTW: Why does fscache require a private flag field?

>  }
>  
>  /*
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index 0b4cbdc..bfab16f 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -2214,6 +2214,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
>  	struct nfs_server *server;
>  	struct dentry *mntroot;
>  	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
> +	struct nfs_parsed_mount_data parsed_data = { .fscache_uniq = NULL, };

Rather than wasting all this space on the stack, how about just changing
the second argument of nfs_fscache_get_super_cookie()? You only use the
pointer to data->fscache_uniq.

>  	struct nfs_sb_mountdata sb_mntdata = {
>  		.mntflags = flags,
>  	};

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
