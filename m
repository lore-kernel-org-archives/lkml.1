Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXGFW5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXGFW5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbXGFW5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:57:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbXGFW5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:57:16 -0400
Date: Fri, 6 Jul 2007 15:56:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       riel <riel@redhat.com>
Subject: Re: [PATCH] mm: double mark_page_accessed() in
 read_cache_page_async()
Message-Id: <20070706155647.3056f1f5.akpm@linux-foundation.org>
In-Reply-To: <1183737834.7054.108.camel@twins>
References: <1183737834.7054.108.camel@twins>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jul 2007 18:03:54 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> read_cache_page_async() seems to have two invocations of
> mark_page_accessed() which will launch pages right onto the active list.
> 
> Remove the first one, keeping the latter one. This avoids marking
> unwanted pages active (in the retry loop).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/filemap.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6/mm/filemap.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap.c
> +++ linux-2.6/mm/filemap.c
> @@ -1588,7 +1588,6 @@ retry:
>  	page = __read_cache_page(mapping, index, filler, data);
>  	if (IS_ERR(page))
>  		return page;
> -	mark_page_accessed(page);
>  	if (PageUptodate(page))
>  		goto out;
>  
> 

Thanks for catching this.  It is a post-2.6.21 regression.

We cannot afford to do stuff like this.
