Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbYDPUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbYDPUYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYDPUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:24:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:19951 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYDPUYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SoFTY6IpahOwcpfMADvj9tfCp9uUJ/Asz6Qwuhm346k85CK/+DoUT52fn69YMZ+d0ic+8PSupxmiOWa2L6Yea0TN/DtFR+Y458YEayUsm5zrE6foFvZOPI6Ol4SGXZ992Iek4A7Get5F8J8FcTHlnYZae9EZz7LxSYWhQytDSXw=
Message-ID: <aa79d98a0804161324k734d22f9o4c1d0730c724880c@mail.gmail.com>
Date: Thu, 17 Apr 2008 00:24:00 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1208372123.5376.43.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416174421.442716301@gmail.com>
	 <48063bc9.2234440a.747d.09ea@mx.google.com>
	 <1208369492.5376.9.camel@heimdal.trondhjem.org>
	 <20080416181336.GA7657@cvg>
	 <1208372123.5376.43.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, may be you meant to perform 'near' check for rest of nfs code?
But that wold requare much more code to change...

On 4/16/08, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
>
> On Wed, 2008-04-16 at 22:13 +0400, Cyrill Gorcunov wrote:
> > [Trond Myklebust - Wed, Apr 16, 2008 at 02:11:31PM -0400]
> > |
> > | On Wed, 2008-04-16 at 21:44 +0400, Cyrill Gorcunov wrote:
> > | > plain text document attachment (nfs-kstrdup-nul-fix)
> > | > It's possible to get NULL pointer dereference
> > | > if kstrndup failed
> > | >
> > | > Here is a possible scenario
> > | >
> > | > nfs4_get_sb
> > | >   nfs4_validate_mount_data
> > | >     o kstrndup failed so args->nfs_server.export_path = NULL
> > | >   nfs4_create_server
> > | >     nfs4_path_walk(..., NULL) -> Oops!
> > | >
> > | > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > |
> > | Why fix only the one case? What about the other kstrdup/kstrndup cases
> > | in super.c that appear to be unchecked?
> > |
> > | Trond
> > |
> > | > ---
> > | >
> > | > Index: linux-2.6.git/fs/nfs/super.c
> > | > ===================================================================
> > | > --- linux-2.6.git.orig/fs/nfs/super.c	2008-04-15 23:01:30.000000000
> +0400
> > | > +++ linux-2.6.git/fs/nfs/super.c	2008-04-16 20:01:44.000000000 +0400
> > | > @@ -1858,6 +1858,8 @@ static int nfs4_validate_mount_data(void
> > | >  		if (len > NFS4_MAXPATHLEN)
> > | >  			return -ENAMETOOLONG;
> > | >  		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
> > | > +		if (!args->nfs_server.export_path)
> > | > +			return -ENOMEM;
> > | >
> > | >  		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);
> > | >
> > |
> >
> > This one is leading to NULL deref, others - don't
>
> So? The defensive coding principle is that you perform validity checks
> when the pointer is created. Otherwise, we could equally well have added
> the NULL deref check to nfs4_path_walk()...
>
>   Trond
>
>
