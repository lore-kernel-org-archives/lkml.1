Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbYAYJnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbYAYJnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYAYJnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:43:41 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50591 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYAYJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:43:40 -0500
To: Trond.Myklebust@netapp.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <1201208010.7054.17.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Thu, 24 Jan 2008 15:53:30 -0500)
Subject: Re: [patch 21/26] mount options: partially fix nfs
References: <20080124193341.166753833@szeredi.hu>
	 <20080124193449.550058933@szeredi.hu> <1201208010.7054.17.camel@heimdal.trondhjem.org>
Message-Id: <E1JIL5y-0001O4-C6@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 10:43:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2008-01-24 at 20:34 +0100, Miklos Szeredi wrote:
> > plain text document attachment (nfs_opts.patch)
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add posix, bsize=, namelen= options to /proc/mounts for nfs
> > filesystems.
> > 
> > Document several other options that are still missing.
> > 
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
> >  	seq_printf(m, ",vers=%d", clp->rpc_ops->version);
> >  	seq_printf(m, ",rsize=%d", nfss->rsize);
> >  	seq_printf(m, ",wsize=%d", nfss->wsize);
> > +	if (nfss->bsize != 0)
> > +		seq_printf(m, ",bsize=%d", nfss->bsize);
> > +	if (nfss->namelen != default_namelen)
> > +		seq_printf(m, ",namelen=%d", nfss->namelen);
> 
> You really just want to look at the value of nfss->namelen. It should
> always be set.

OK, I usually add the condition for (value != default_value) to avoid
unnecessary clutter.  But sure, there's no problem with showing the
option unconditionally.

> 
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
> > +	 * mountport=
> > +	 * mountvers=
> > +	 * mountproto=
> > +	 * addr=
> > +	 * clientaddr=
> > +	 * mounthost=
> > +	 * mountaddr=
> > +	 */
> 
> The new text mount interface actually does allow us to store these
> values if we really do need to. That should be a separate patch,
> however.

OK.

Thanks,
Miklos
