Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYDPSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYDPSzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYDPSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:55:37 -0400
Received: from pat.uio.no ([129.240.10.15]:45182 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYDPSzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:55:37 -0400
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080416181336.GA7657@cvg>
References: <20080416174421.442716301@gmail.com>
	 <48063bc9.2234440a.747d.09ea@mx.google.com>
	 <1208369492.5376.9.camel@heimdal.trondhjem.org> <20080416181336.GA7657@cvg>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 14:55:22 -0400
Message-Id: <1208372123.5376.43.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 9789979AFE428B81EC75400E891D358C0602484D
X-UiO-SR-test: 4139ACD233F9E51BE419C8F1304CB446FB1415A7
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 772 total 7927424 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-16 at 22:13 +0400, Cyrill Gorcunov wrote:
> [Trond Myklebust - Wed, Apr 16, 2008 at 02:11:31PM -0400]
> | 
> | On Wed, 2008-04-16 at 21:44 +0400, Cyrill Gorcunov wrote:
> | > plain text document attachment (nfs-kstrdup-nul-fix)
> | > It's possible to get NULL pointer dereference
> | > if kstrndup failed
> | > 
> | > Here is a possible scenario
> | > 
> | > nfs4_get_sb
> | >   nfs4_validate_mount_data
> | >     o kstrndup failed so args->nfs_server.export_path = NULL
> | >   nfs4_create_server
> | >     nfs4_path_walk(..., NULL) -> Oops!
> | > 
> | > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> | 
> | Why fix only the one case? What about the other kstrdup/kstrndup cases
> | in super.c that appear to be unchecked?
> | 
> | Trond
> | 
> | > ---
> | > 
> | > Index: linux-2.6.git/fs/nfs/super.c
> | > ===================================================================
> | > --- linux-2.6.git.orig/fs/nfs/super.c	2008-04-15 23:01:30.000000000 +0400
> | > +++ linux-2.6.git/fs/nfs/super.c	2008-04-16 20:01:44.000000000 +0400
> | > @@ -1858,6 +1858,8 @@ static int nfs4_validate_mount_data(void
> | >  		if (len > NFS4_MAXPATHLEN)
> | >  			return -ENAMETOOLONG;
> | >  		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
> | > +		if (!args->nfs_server.export_path)
> | > +			return -ENOMEM;
> | >  
> | >  		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);
> | > 
> | 
> 
> This one is leading to NULL deref, others - don't

So? The defensive coding principle is that you perform validity checks
when the pointer is created. Otherwise, we could equally well have added
the NULL deref check to nfs4_path_walk()...

  Trond

