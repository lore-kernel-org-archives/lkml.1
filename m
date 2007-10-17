Return-Path: <linux-kernel-owner+w=401wt.eu-S933919AbXJQPYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbXJQPYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760028AbXJQPYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:24:43 -0400
Received: from pat.uio.no ([129.240.10.15]:41416 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759653AbXJQPYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:24:42 -0400
Subject: Re: [PATCH] nfs: fix nfs_writepage()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1192628458.27435.119.camel@twins>
References: <1192628458.27435.119.camel@twins>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 11:25:02 -0400
Message-Id: <1192634702.7573.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.130)
X-UiO-Scanned: 13A155A304162CCC723649C0DFE3AD620B0BF295
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 408 total 4555263 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-17 at 15:40 +0200, Peter Zijlstra wrote:
> I noticed that ->writepage() didn't actually do anything since it
> doesn't generate a write request for the given page.
> 
> The below is an attempt at fixing it, and it works for me. Although I'm
> not quite sure its the proper fix.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  fs/nfs/write.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: linux-2.6/fs/nfs/write.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/write.c
> +++ linux-2.6/fs/nfs/write.c
> @@ -332,10 +332,30 @@ static int nfs_page_async_flush(struct n
>  static int nfs_do_writepage(struct page *page, struct writeback_control *wbc, struct nfs_pageio_descriptor *pgio)
>  {
>  	struct inode *inode = page_file_mapping(page)->host;
> +	struct rpc_cred *cred;
> +	struct nfs_open_context *ctx;
> +	int status;
>  
>  	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
>  	nfs_add_stats(inode, NFSIOS_WRITEPAGES, 1);
>  
> +	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
> +	if (IS_ERR(cred))
> +		return PTR_ERR(cred);
> +
> +	ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
> +	if (!ctx)
> +		return -EBADF;
> +
> +	status = nfs_writepage_setup(ctx, page, 0, nfs_page_length(page));
> +
> +	put_nfs_open_context(ctx);
> +
> +	if (status < 0) {
> +		nfs_set_pageerror(page);
> +		return status;
> +	}
> +
>  	nfs_pageio_cond_complete(pgio, page_file_index(page));
>  	return nfs_page_async_flush(pgio, page);
>  }

NACK. writepage()'s job is simply to start writeout on the page.
nfs_vm_page_mkwrite(), and nfs_commit_write() actually set up the
nfs_page structure before we ever get to writepage().

Cheers
  Trond

