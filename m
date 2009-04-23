Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZDWU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZDWU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZDWU1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:27:17 -0400
Received: from mail.fieldses.org ([141.211.133.115]:52856 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZDWU1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:27:16 -0400
Date: Thu, 23 Apr 2009 16:27:05 -0400
To: hooanon05@yahoo.co.jp
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090423202705.GA31085@fieldses.org>
References: <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org> <9180.1240468823@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9180.1240468823@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:40:23PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> "J. Bruce Fields":
> > > Isn't it better to test it BEFORE fh_compose()?
> 	:::
> > Yes, I think you're right.
> 
> Then here you are.

The nfsv4 readdir callback needs a similar fix.

Also, it looks to me like this results in us encoding an entry for this
deleted file in the readdir reply, but with an empty filehandle.  From a
quick glance at the rfc it's not clear to me whether this is really
legal.  I suspect it may cause odd behavior on clients.  At the least it
would seem cleaner to check for this condition early enough that we can
just skip the entry entirely.

--b.

> 
> J. R. Okajima
> 
> ----------------------------------------------------------------------
> 
> commit c98c6c4a207d602bd9498ea5f1d2993a00e98445
> Author: J. R. Okajima <hooanon05@yahoo.co.jp>
> Date:   Thu Apr 23 15:38:43 2009 +0900
> 
>     NFSD: test d_inode before fh_compose()
>     
>     After 2f9092e1020246168b1309b35e085ecd7ff9ff72 "Fix i_mutex vs. readdir
>     handling in nfsd" (and 14f7dd63 "Copy XFS readdir hack into nfsd code"),
>     an entry may be removed between the first mutex_unlock and the second
>     mutex_lock. In this case, lookup_one_len() in compose_entry_fh() will
>     return a negative dentry.
>     It is better to test inode (positive/negative) BEFORE fh_compose().
>     
>     Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> 
> diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> index 17d0dd9..1b5543b 100644
> --- a/fs/nfsd/nfs3xdr.c
> +++ b/fs/nfsd/nfs3xdr.c
> @@ -851,8 +851,8 @@ compose_entry_fh(struct nfsd3_readdirres *cd, struct svc_fh *fhp,
>  	if (IS_ERR(dchild))
>  		return 1;
>  	if (d_mountpoint(dchild) ||
> -	    fh_compose(fhp, exp, dchild, &cd->fh) != 0 ||
> -	    !dchild->d_inode)
> +	    !dchild->d_inode ||
> +	    fh_compose(fhp, exp, dchild, &cd->fh) != 0)
>  		rv = 1;
>  	dput(dchild);
>  	return rv;
