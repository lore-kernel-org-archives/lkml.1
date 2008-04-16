Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYDPSO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYDPSO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYDPSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:14:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36232 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYDPSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EuOEAFIJfqFsnBn5ZJjE2DMKA/+XlHAkCWccqc+tWupZlPrWs4s9P2UuDSvkBQ89+CdHhjUw3kfCdC0thDQ2ETF5CcR+skT7XG0aT8CMIkAzNKL2GTSeWkg2RD0zHGdbAB45IJ1/2A3XNh9wKjbxwaKcMxwS5MB3O6nYJswHrvM=
Date: Wed, 16 Apr 2008 22:13:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
Message-ID: <20080416181336.GA7657@cvg>
References: <20080416174421.442716301@gmail.com> <48063bc9.2234440a.747d.09ea@mx.google.com> <1208369492.5376.9.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208369492.5376.9.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trond Myklebust - Wed, Apr 16, 2008 at 02:11:31PM -0400]
| 
| On Wed, 2008-04-16 at 21:44 +0400, Cyrill Gorcunov wrote:
| > plain text document attachment (nfs-kstrdup-nul-fix)
| > It's possible to get NULL pointer dereference
| > if kstrndup failed
| > 
| > Here is a possible scenario
| > 
| > nfs4_get_sb
| >   nfs4_validate_mount_data
| >     o kstrndup failed so args->nfs_server.export_path = NULL
| >   nfs4_create_server
| >     nfs4_path_walk(..., NULL) -> Oops!
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| Why fix only the one case? What about the other kstrdup/kstrndup cases
| in super.c that appear to be unchecked?
| 
| Trond
| 
| > ---
| > 
| > Index: linux-2.6.git/fs/nfs/super.c
| > ===================================================================
| > --- linux-2.6.git.orig/fs/nfs/super.c	2008-04-15 23:01:30.000000000 +0400
| > +++ linux-2.6.git/fs/nfs/super.c	2008-04-16 20:01:44.000000000 +0400
| > @@ -1858,6 +1858,8 @@ static int nfs4_validate_mount_data(void
| >  		if (len > NFS4_MAXPATHLEN)
| >  			return -ENAMETOOLONG;
| >  		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
| > +		if (!args->nfs_server.export_path)
| > +			return -ENOMEM;
| >  
| >  		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);
| > 
| 

This one is leading to NULL deref, others - don't

		- Cyrill -
