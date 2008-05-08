Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbYEHNWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbYEHNWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYEHNV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:21:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYEHNV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:21:57 -0400
Date: Thu, 8 May 2008 09:07:59 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: trond.myklebust@fys.uio.no, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: NFS infinite loop in filemap_fault()
Message-ID: <20080508130759.GA30499@unused.rdu.redhat.com>
References: <E1JtqLW-0005j5-KU@pomaz-ex.szeredi.hu> <E1JtzuH-0006nY-AM@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JtzuH-0006nY-AM@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 08:47:09AM +0200, Miklos Szeredi wrote:
> > Page fault on NFS apparently goes into an infinite loop if the read on
> > the server fails.
> > 
> > I don't understand the NFS readpage code, but the filemap_fault() code
> > looks somewhat suspicious:
> > 
> > 	/*
> > 	 * Umm, take care of errors if the page isn't up-to-date.
> > 	 * Try to re-read it _once_. We do this synchronously,
> > 	 * because there really aren't any performance issues here
> > 	 * and we need to check for errors.
> > 	 */
> > 	ClearPageError(page);
> > 	error = mapping->a_ops->readpage(file, page);
> > 	page_cache_release(page);
> > 
> > 	if (!error || error == AOP_TRUNCATED_PAGE)
> > 		goto retry_find;
> > 
> > The comment doesn't seem to match what the it actually does: if
> > ->readpage() is asynchronous, then this will just repeat everything,
> > without any guarantee that it will re-read once.
> 
> This patch fixes it.  It's probably wrong in some subtle way though...
> 
> Miklos
> 
> 
> ---
>  mm/filemap.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux.git/mm/filemap.c
> ===================================================================
> --- linux.git.orig/mm/filemap.c	2008-05-08 08:17:22.000000000 +0200
> +++ linux.git/mm/filemap.c	2008-05-08 08:19:59.000000000 +0200
> @@ -1461,6 +1461,12 @@ page_not_uptodate:
>  	 */
>  	ClearPageError(page);
>  	error = mapping->a_ops->readpage(file, page);
> +	if (!error && !PageUptodate(page)) {

Shouldn't you have (!error || error != AOP_TRUNCATED_PAGE), since the fs can
return AOP_TRUNCATED_PAGE if it needs vfs to try the readpage again?  Things
like OCFS2/GFS2 do this, they send of a lock request and return
AOP_TRUNCATED_PAGE so that when we come back into readpage we are already
holding our lock without blocking while holding the page lock.  Thanks,

Josef
