Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXEFAYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXEFAYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 20:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXEFAYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 20:24:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:17122 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXEFAYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 20:24:05 -0400
X-IronPort-AV: i="4.14,497,1170662400"; 
   d="scan'208"; a="57553419:sNHT81389476"
Subject: Re: [PATCH 2/4] sunrpc: Use path_component_lookup
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       neilb@suse.de, mhalcrow@us.ibm.com
In-Reply-To: <11784065741393-git-send-email-jsipek@cs.sunysb.edu>
References: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
	 <11784065741393-git-send-email-jsipek@cs.sunysb.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sat, 05 May 2007 19:52:24 -0400
Message-Id: <1178409144.6561.73.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 05 May 2007 23:52:38.0485 (UTC) FILETIME=[7628E850:01C78F70]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 19:09 -0400, Josef 'Jeff' Sipek wrote:
> use path_component_lookup instead of open-coding the necessary
> functionality.
> 
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  net/sunrpc/rpc_pipe.c |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9b9ea50..b67cb54 100644
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
> +	if (path_component_lookup(rpc_mount->mnt_root, mnt, path, LOOKUP_PARENT, nd)) {
>  		printk(KERN_WARNING "%s: %s failed to find path %s\n",
>  				__FILE__, __FUNCTION__, path);
>  		rpc_put_mount();

Just one minor nit: could you make that

	if (path_component_lookup(mnt->mnt_root, mnt, path, LOOKUP_PARENT, nd)) {

instead. It really is a bug even for the existing code to be referencing
rpc_mount directly.

Cheers
  Trond
