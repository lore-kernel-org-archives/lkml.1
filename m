Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYDPSL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYDPSL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYDPSLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:11:48 -0400
Received: from pat.uio.no ([129.240.10.15]:50715 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYDPSLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:11:48 -0400
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48063bc9.2234440a.747d.09ea@mx.google.com>
References: <20080416174421.442716301@gmail.com> >
	  <48063bc9.2234440a.747d.09ea@mx.google.com>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 14:11:31 -0400
Message-Id: <1208369492.5376.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 874F5A0468329CF02DF81E0230B557D85898A257
X-UiO-SR-test: 17B084BA3EE85819DF7A39B836D34D4EED35E0FD
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 133 total 7926785 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-16 at 21:44 +0400, Cyrill Gorcunov wrote:
> plain text document attachment (nfs-kstrdup-nul-fix)
> It's possible to get NULL pointer dereference
> if kstrndup failed
> 
> Here is a possible scenario
> 
> nfs4_get_sb
>   nfs4_validate_mount_data
>     o kstrndup failed so args->nfs_server.export_path = NULL
>   nfs4_create_server
>     nfs4_path_walk(..., NULL) -> Oops!
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Why fix only the one case? What about the other kstrdup/kstrndup cases
in super.c that appear to be unchecked?

Trond

> ---
> 
> Index: linux-2.6.git/fs/nfs/super.c
> ===================================================================
> --- linux-2.6.git.orig/fs/nfs/super.c	2008-04-15 23:01:30.000000000 +0400
> +++ linux-2.6.git/fs/nfs/super.c	2008-04-16 20:01:44.000000000 +0400
> @@ -1858,6 +1858,8 @@ static int nfs4_validate_mount_data(void
>  		if (len > NFS4_MAXPATHLEN)
>  			return -ENAMETOOLONG;
>  		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
> +		if (!args->nfs_server.export_path)
> +			return -ENOMEM;
>  
>  		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);
> 

