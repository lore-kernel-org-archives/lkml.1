Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXEFOqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXEFOqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 10:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXEFOqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 10:46:39 -0400
Received: from mx2.netapp.com ([216.240.18.37]:7877 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbXEFOqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 10:46:38 -0400
X-IronPort-AV: i="4.14,499,1170662400"; 
   d="scan'208"; a="57697834:sNHT20421765"
Subject: Re: [PATCH 1/1] sunrpc: Use path_component_lookup
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       neilb@suse.de, mhalcrow@us.ibm.com
In-Reply-To: <1178412766906-git-send-email-jsipek@cs.sunysb.edu>
References: <1178409144.6561.73.camel@heimdal.trondhjem.org>
	 <1178412766906-git-send-email-jsipek@cs.sunysb.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sun, 06 May 2007 10:46:34 -0400
Message-Id: <1178462794.6561.92.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 06 May 2007 14:46:49.0002 (UTC) FILETIME=[605C20A0:01C78FED]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 20:52 -0400, Josef 'Jeff' Sipek wrote:
> use path_component_lookup instead of open-coding the necessary
> functionality.
> 
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  net/sunrpc/rpc_pipe.c |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9b9ea50..c93a454 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -451,21 +451,19 @@ void rpc_put_mount(void)
>  static int
>  rpc_lookup_parent(char *path, struct nameidata *nd)
>  {
> +	struct vfsmount *mnt;
> +
>  	if (path[0] == '\0')
>  		return -ENOENT;
> -	nd->mnt = rpc_get_mount();
> -	if (IS_ERR(nd->mnt)) {
> +
> +	mnt = rpc_get_mount();
> +	if (IS_ERR(mnt)) {
>  		printk(KERN_WARNING "%s: %s failed to mount "
>  			       "pseudofilesystem \n", __FILE__, __FUNCTION__);
> -		return PTR_ERR(nd->mnt);
> +		return PTR_ERR(mnt);
>  	}
> -	mntget(nd->mnt);
> -	nd->dentry = dget(rpc_mount->mnt_root);
> -	nd->last_type = LAST_ROOT;
> -	nd->flags = LOOKUP_PARENT;
> -	nd->depth = 0;
>  
> -	if (path_walk(path, nd)) {
> +	if (path_component_lookup(mnt->mnt_root, mnt, path, LOOKUP_PARENT, nd)) {
>  		printk(KERN_WARNING "%s: %s failed to find path %s\n",
>  				__FILE__, __FUNCTION__, path);
>  		rpc_put_mount();

Thanks! That looks good.

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Cheers
  Trond
