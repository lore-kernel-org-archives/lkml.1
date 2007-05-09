Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbXEIMTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbXEIMTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXEIMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:19:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:57087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005AbXEIMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:19:39 -0400
Date: Wed, 9 May 2007 14:19:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a bad bug in read_cache_page_async()
Message-ID: <20070509121937.GA24026@wotan.suse.de>
References: <20070509120201.6771.92968.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509120201.6771.92968.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:02:01PM +0100, David Howells wrote:
> Fix a bad bug in read_cache_page_async() introduced in commit:
> 
> 	6fe6900e1e5b6fa9e5c59aa5061f244fe3f467e2
> 
> This adds:
> 
> 	mark_page_accessed(page)
> 
> into the error handling path in read_cache_page_async().  In such a case,
> 'page' holds the error code.

Obvious thinko. Thanks, ack.

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  mm/filemap.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 9e56fd1..10d4fcf 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1784,7 +1784,7 @@ struct page *read_cache_page_async(struct address_space *mapping,
>  retry:
>  	page = __read_cache_page(mapping, index, filler, data);
>  	if (IS_ERR(page))
> -		goto out;
> +		goto error;
>  	mark_page_accessed(page);
>  	if (PageUptodate(page))
>  		goto out;
> @@ -1803,9 +1803,11 @@ retry:
>  	if (err < 0) {
>  		page_cache_release(page);
>  		page = ERR_PTR(err);
> +		goto error;
>  	}
> - out:
> +out:
>  	mark_page_accessed(page);
> +error:
>  	return page;
>  }
>  EXPORT_SYMBOL(read_cache_page_async);
