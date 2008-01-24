Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYAXUun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYAXUun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYAXUue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:50:34 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37600 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbYAXUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:50:32 -0500
Message-ID: <4798F9BC.4040405@oracle.com>
Date: Thu, 24 Jan 2008 15:49:00 -0500
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture team, Oracle USA
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [patch 21/26] mount options: partially fix nfs
References: <20080124193341.166753833@szeredi.hu> <20080124193449.550058933@szeredi.hu>
In-Reply-To: <20080124193449.550058933@szeredi.hu>
Content-Type: multipart/mixed;
 boundary="------------060702070406030201040409"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060702070406030201040409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Miklos-

Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add posix, bsize=, namelen= options to /proc/mounts for nfs
> filesystems.
> 
> Document several other options that are still missing.

NFS lists only some options in /proc/mounts on purpose: only the 
essential options are mentioned there to keep clutter down.  The three 
you've added here are for all intents and purposes deprecated, which is 
why they are not supported.

NFS lists a more complete set of mount options for a mount point in 
/proc/self/mountstats.  See nfs_show_stats().

Since your cover letter does not explain why you are changing this code, 
can you refer me to a description of why you are doing this?

More below.

> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/nfs/super.c
> ===================================================================
> --- linux.orig/fs/nfs/super.c	2008-01-19 11:56:34.000000000 +0100
> +++ linux/fs/nfs/super.c	2008-01-21 20:41:30.000000000 +0100
> @@ -449,6 +449,7 @@ static void nfs_show_mount_options(struc
>  	} nfs_info[] = {
>  		{ NFS_MOUNT_SOFT, ",soft", ",hard" },
>  		{ NFS_MOUNT_INTR, ",intr", ",nointr" },
> +		{ NFS_MOUNT_POSIX, ",posix", "" },
>  		{ NFS_MOUNT_NOCTO, ",nocto", "" },
>  		{ NFS_MOUNT_NOAC, ",noac", "" },
>  		{ NFS_MOUNT_NONLM, ",nolock", "" },
> @@ -459,10 +460,17 @@ static void nfs_show_mount_options(struc
>  	};
>  	const struct proc_nfs_info *nfs_infop;
>  	struct nfs_client *clp = nfss->nfs_client;
> +	unsigned int default_namelen =
> +		clp->rpc_ops->version == 4 ? NFS4_MAXNAMLEN :
> +		clp->rpc_ops->version == 3 ? NFS3_MAXNAMLEN : NFS2_MAXNAMLEN;
>  
>  	seq_printf(m, ",vers=%d", clp->rpc_ops->version);
>  	seq_printf(m, ",rsize=%d", nfss->rsize);
>  	seq_printf(m, ",wsize=%d", nfss->wsize);
> +	if (nfss->bsize != 0)
> +		seq_printf(m, ",bsize=%d", nfss->bsize);
> +	if (nfss->namelen != default_namelen)
> +		seq_printf(m, ",namelen=%d", nfss->namelen);
>  	if (nfss->acregmin != 3*HZ || showdefaults)
>  		seq_printf(m, ",acregmin=%d", nfss->acregmin/HZ);
>  	if (nfss->acregmax != 60*HZ || showdefaults)
> @@ -482,6 +490,18 @@ static void nfs_show_mount_options(struc
>  	seq_printf(m, ",timeo=%lu", 10U * nfss->client->cl_timeout->to_initval / HZ);
>  	seq_printf(m, ",retrans=%u", nfss->client->cl_timeout->to_retries);
>  	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
> +
> +	/*
> +	 * Missing options:
> +	 * port=

Probably should be supported.

> +	 * addr=

This one is already supported; see nfs_show_options().

> +	 * clientaddr=

This one isn't, and should be... would be useful for tracking down 
certain NFSv4 problems.

> +	 * mounthost=
> +	 * mountaddr=
 > +	 * mountport=
 > +	 * mountvers=
 > +	 * mountproto=

And these mount* options are for the kernel's new mount protocol client. 
  They aren't really useful for understanding steady-state NFS client 
behavior, they only effect mount-time behavior.

--------------060702070406030201040409
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck_lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck_lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------060702070406030201040409--
