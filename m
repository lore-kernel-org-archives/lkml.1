Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbYAYJji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbYAYJji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYAYJjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:39:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33438 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbYAYJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:39:23 -0500
To: chuck.lever@oracle.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com
In-reply-to: <4798F9BC.4040405@oracle.com> (message from Chuck Lever on Thu,
	24 Jan 2008 15:49:00 -0500)
Subject: Re: [patch 21/26] mount options: partially fix nfs
References: <20080124193341.166753833@szeredi.hu> <20080124193449.550058933@szeredi.hu> <4798F9BC.4040405@oracle.com>
Message-Id: <E1JIL1f-0001N6-Tg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 10:39:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add posix, bsize=, namelen= options to /proc/mounts for nfs
> > filesystems.
> > 
> > Document several other options that are still missing.
> 
> NFS lists only some options in /proc/mounts on purpose: only the 
> essential options are mentioned there to keep clutter down.  The three 
> you've added here are for all intents and purposes deprecated, which is 
> why they are not supported.
> 
> NFS lists a more complete set of mount options for a mount point in 
> /proc/self/mountstats.  See nfs_show_stats().
> 
> Since your cover letter does not explain why you are changing this code, 
> can you refer me to a description of why you are doing this?

Descritption is in the 01/26 patch.

> More below.
> 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> > 
> > Index: linux/fs/nfs/super.c
> > ===================================================================
> > --- linux.orig/fs/nfs/super.c	2008-01-19 11:56:34.000000000 +0100
> > +++ linux/fs/nfs/super.c	2008-01-21 20:41:30.000000000 +0100
> > @@ -449,6 +449,7 @@ static void nfs_show_mount_options(struc
> >  	} nfs_info[] = {
> >  		{ NFS_MOUNT_SOFT, ",soft", ",hard" },
> >  		{ NFS_MOUNT_INTR, ",intr", ",nointr" },
> > +		{ NFS_MOUNT_POSIX, ",posix", "" },
> >  		{ NFS_MOUNT_NOCTO, ",nocto", "" },
> >  		{ NFS_MOUNT_NOAC, ",noac", "" },
> >  		{ NFS_MOUNT_NONLM, ",nolock", "" },
> > @@ -459,10 +460,17 @@ static void nfs_show_mount_options(struc
> >  	};
> >  	const struct proc_nfs_info *nfs_infop;
> >  	struct nfs_client *clp = nfss->nfs_client;
> > +	unsigned int default_namelen =
> > +		clp->rpc_ops->version == 4 ? NFS4_MAXNAMLEN :
> > +		clp->rpc_ops->version == 3 ? NFS3_MAXNAMLEN : NFS2_MAXNAMLEN;
> >  
> >  	seq_printf(m, ",vers=%d", clp->rpc_ops->version);
> >  	seq_printf(m, ",rsize=%d", nfss->rsize);
> >  	seq_printf(m, ",wsize=%d", nfss->wsize);
> > +	if (nfss->bsize != 0)
> > +		seq_printf(m, ",bsize=%d", nfss->bsize);
> > +	if (nfss->namelen != default_namelen)
> > +		seq_printf(m, ",namelen=%d", nfss->namelen);
> >  	if (nfss->acregmin != 3*HZ || showdefaults)
> >  		seq_printf(m, ",acregmin=%d", nfss->acregmin/HZ);
> >  	if (nfss->acregmax != 60*HZ || showdefaults)
> > @@ -482,6 +490,18 @@ static void nfs_show_mount_options(struc
> >  	seq_printf(m, ",timeo=%lu", 10U * nfss->client->cl_timeout->to_initval / HZ);
> >  	seq_printf(m, ",retrans=%u", nfss->client->cl_timeout->to_retries);
> >  	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
> > +
> > +	/*
> > +	 * Missing options:
> > +	 * port=
> 
> Probably should be supported.
> 
> > +	 * addr=
> 
> This one is already supported; see nfs_show_options().

Right, thanks.

> 
> > +	 * clientaddr=
> 
> This one isn't, and should be... would be useful for tracking down 
> certain NFSv4 problems.
> 
> > +	 * mounthost=
> > +	 * mountaddr=
>  > +	 * mountport=
>  > +	 * mountvers=
>  > +	 * mountproto=
> 
> And these mount* options are for the kernel's new mount protocol client. 
>   They aren't really useful for understanding steady-state NFS client 
> behavior, they only effect mount-time behavior.

All mount options should be shown, which are needed to reconstruct a
previous mount.

For example, if you copy options out from /proc/mount, umount the
filesystem, and then create a new mount with the copied options, you
should get the same mount.

So not only those options are interesting which are useful for
understanding steady state behavior.

The only options, which should not be shown, are those which have a
permanent effect at mount time, like journal creation, etc.  And those
which are meaningless across different mounts, like communication file
descriptors.

Thanks,
Miklos
