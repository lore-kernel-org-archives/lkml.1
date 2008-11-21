Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYKUIRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYKUIRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYKUIRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:17:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbYKUIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:17:23 -0500
Date: Fri, 21 Nov 2008 00:17:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/45] FS-Cache: Recruit a couple of page flags for
 cache management [ver #41]
Message-Id: <20081121001704.51e7d744.akpm@linux-foundation.org>
In-Reply-To: <20081120144210.10667.11143.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144210.10667.11143.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:42:10 +0000 David Howells <dhowells@redhat.com> wrote:

> Recruit a couple of page flags to aid in cache management.  The following extra
> flags are defined:
> 
>  (1) PG_fscache (PG_private_2)
> 
>      The marked page is backed by a local cache and is pinning resources in the
>      cache driver.
> 
>  (2) PG_fscache_write (PG_owner_priv_2)
> 
>      The marked page is being written to the local cache.  The page may not be
>      modified whilst this is in progress.
> 
> If PG_fscache is set, then things that checked for PG_private will now also
> check for that.  This includes things like truncation and page invalidation.
> The function page_has_private() had been added to make the checks for both
> PG_private and PG_private_2 at the same time.
> 
> ...
> 
> index 74b9d90..da467b2 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -79,9 +79,11 @@ enum pageflags {
>  	PG_active,
>  	PG_slab,
>  	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
> +	PG_owner_priv_2,	/* Owner use. fs may use in pagecache */
>  	PG_arch_1,
>  	PG_reserved,
>  	PG_private,		/* If pagecache, has fs-private data */
> +	PG_private_2,		/* If pagecache, has fs aux data */
>  	PG_writeback,		/* Page is under writeback */

ow, that hurt.  Every time someone does this I ask "how many are left"
but nobody seems to know how to work it out.

How many are left?

> -	if (PagePrivate(page) &&
> +	if (page_has_private(page) &&

I'd suggest that we make PagePrivate() go away completely, to prevent
accidental usages from sneaking back in.  If that's practical.

