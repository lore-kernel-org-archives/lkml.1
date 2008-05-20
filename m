Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbYETSrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbYETSrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbYETSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:47:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56793 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932925AbYETSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:47:18 -0400
Date: Tue, 20 May 2008 14:47:10 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch 1/9] lockd: dont return EAGAIN for a permanent error
Message-ID: <20080520184710.GA8177@fieldses.org>
References: <20080515195019.754545421@szeredi.hu> <20080515195103.521911468@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515195103.521911468@szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:50:20PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Fix nlm_fopen() to return NLM_FAILED (or NLM_LCK_DENIED_NOLOCKS)
> instead of NLM_LCK_DENIED.  The latter means the lock request failed
> because of a conflicting lock (i.e. a temporary error), which is wrong
> in this case.
> 
> Also fix the client to return ENOLCK instead of EAGAIN if a blocking
> lock request returns with NLM_LOCK_DENIED.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Trond Myklebust <trond.myklebust@fys.uio.no>
> CC: "J. Bruce Fields" <bfields@fieldses.org>
> ---
>  fs/lockd/clntproc.c |   10 +++++++++-
>  fs/nfsd/lockd.c     |   13 +++++++++----
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/fs/lockd/clntproc.c
> ===================================================================
> --- linux-2.6.orig/fs/lockd/clntproc.c	2008-05-15 17:54:30.000000000 +0200
> +++ linux-2.6/fs/lockd/clntproc.c	2008-05-15 17:59:41.000000000 +0200
> @@ -580,7 +580,15 @@ again:
>  	}
>  	if (status < 0)
>  		goto out_unlock;
> -	status = nlm_stat_to_errno(resp->status);
> +	/*
> +	 * EAGAIN doesn't make sense for sleeping locks, and in some
> +	 * cases NLM_LCK_DENIED is returned for a permanent error.  So

Just for the sake of future readers, I might go ahead and give
specifics: "and older versions of the linux server sometimes returned
NLM_LCK_DENIED for permanent errors", or something.

> +	 * turn it into an ENOLCK.
> +	 */
> +	if (resp->status == nlm_lck_denied && (fl_flags & FL_SLEEP))
> +		status = -ENOLCK;
> +	else
> +		status = nlm_stat_to_errno(resp->status);

Might be a bit clearer (or at least make the comment and code more
obviously agree) to do:

	status = nlm_stat_to_errno(resp->status);
	if (status == -EAGAIN && (fl_flags & FL_SLEEP))
		status = -ENOLCK;

This might make more sense as separate client and server-side patches.

Seems reasonable to me otherwise.

--b.

>  out_unblock:
>  	nlmclnt_finish_block(block);
>  out:
> Index: linux-2.6/fs/nfsd/lockd.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/lockd.c	2008-05-15 17:54:30.000000000 +0200
> +++ linux-2.6/fs/nfsd/lockd.c	2008-05-15 17:57:45.000000000 +0200
> @@ -19,6 +19,13 @@
>  
>  #define NFSDDBG_FACILITY		NFSDDBG_LOCKD
>  
> +#ifdef CONFIG_LOCKD_V4
> +#define nlm_stale_fh	nlm4_stale_fh
> +#define nlm_failed	nlm4_failed
> +#else
> +#define nlm_stale_fh	nlm_lck_denied_nolocks
> +#define nlm_failed	nlm_lck_denied_nolocks
> +#endif
>  /*
>   * Note: we hold the dentry use count while the file is open.
>   */
> @@ -47,12 +54,10 @@ nlm_fopen(struct svc_rqst *rqstp, struct
>  		return 0;
>  	case nfserr_dropit:
>  		return nlm_drop_reply;
> -#ifdef CONFIG_LOCKD_V4
>  	case nfserr_stale:
> -		return nlm4_stale_fh;
> -#endif
> +		return nlm_stale_fh;
>  	default:
> -		return nlm_lck_denied;
> +		return nlm_failed;
>  	}
>  }
>  
> 
> --
