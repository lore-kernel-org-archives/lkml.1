Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZDEUWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZDEUWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZDEUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:22:38 -0400
Received: from mail.fieldses.org ([141.211.133.115]:52207 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZDEUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:22:37 -0400
Date: Sun, 5 Apr 2009 16:22:33 -0400
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: bus errors on nfs writes in latest git
Message-ID: <20090405202233.GA16937@fieldses.org>
References: <20090404161447.GE495@fieldses.org> <1238861949.8114.3.camel@heimdal.trondhjem.org> <1238862470.8114.5.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238862470.8114.5.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 12:27:50PM -0400, Trond Myklebust wrote:
> On Sat, 2009-04-04 at 12:19 -0400, Trond Myklebust wrote:
> > On Sat, 2009-04-04 at 12:14 -0400, J. Bruce Fields wrote:
> > > My regular connecthon tests are reporting bus errors on the "write/read
> > > 30 MB file" on recent upstream kernels.  I'm travelling and haven't had
> > > a chance to do anything beyond kick off a dumb git-bisect, which pointed
> > > the blame at the following commit.  Any ideas?
> 
> The following patch should fix it.

Thanks--confirmed.  For what it's worth:

	Tested-by: J. Bruce Fields <bfields@citi.umich.edu>

--b.

> 
> Cheers
>  Trond
> ---------------------------------------------------------------
> >From b7a178f4fab331821b8cff384e1954e62aa63e52 Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Sat, 4 Apr 2009 12:22:57 -0400
> Subject: [PATCH] NFS: Fix the return value in nfs_page_mkwrite()
> 
> Commit c2ec175c39f62949438354f603f4aa170846aabb (mm: page_mkwrite change
> prototype to match fault) exposed a bug in the NFS implementation of
> page_mkwrite. We should be returning 0 on success...
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  fs/nfs/file.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 3523b89..5a97bcf 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -516,8 +516,6 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		goto out_unlock;
>  
>  	ret = nfs_updatepage(filp, page, 0, pagelen);
> -	if (ret == 0)
> -		ret = pagelen;
>  out_unlock:
>  	unlock_page(page);
>  	if (ret)
> -- 
> 1.6.0.4
> 
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer
> 
> NetApp
> Trond.Myklebust@netapp.com
> www.netapp.com
