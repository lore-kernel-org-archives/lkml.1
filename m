Return-Path: <linux-kernel-owner+w=401wt.eu-S1946178AbXBBXwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946178AbXBBXwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946174AbXBBXwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:52:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45215 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946172AbXBBXwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:52:44 -0500
Date: Fri, 2 Feb 2007 15:52:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 1/9] fs: libfs buffered write leak fix
Message-Id: <20070202155236.dae54aa2.akpm@linux-foundation.org>
In-Reply-To: <20070129081914.23584.23886.sendpatchset@linux.site>
References: <20070129081905.23584.97878.sendpatchset@linux.site>
	<20070129081914.23584.23886.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 11:31:46 +0100 (CET)
Nick Piggin <npiggin@suse.de> wrote:

> simple_prepare_write and nobh_prepare_write leak uninitialised kernel data.

They do?  Under what situation?

> Fix the former,

How?

> make a note of the latter. Several other filesystems seem
> to be iffy here, too.

Please, tell us what the bug is so that others have a chance of reviewing
and, if needed, fixing those other filesystems.

> --- linux-2.6.orig/fs/libfs.c
> +++ linux-2.6/fs/libfs.c
> @@ -327,32 +327,35 @@ int simple_readpage(struct file *file, s
>  int simple_prepare_write(struct file *file, struct page *page,
>  			unsigned from, unsigned to)
>  {
> -	if (!PageUptodate(page)) {
> -		if (to - from != PAGE_CACHE_SIZE) {
> -			void *kaddr = kmap_atomic(page, KM_USER0);
> -			memset(kaddr, 0, from);
> -			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> -			flush_dcache_page(page);
> -			kunmap_atomic(kaddr, KM_USER0);
> -		}
> +	if (PageUptodate(page))
> +		return 0;
> +
> +	if (to - from != PAGE_CACHE_SIZE) {
> +		clear_highpage(page);
> +		flush_dcache_page(page);
>  		SetPageUptodate(page);
>  	}

memclear_highpage_flush() is fashionable.

> ===================================================================
> --- linux-2.6.orig/fs/buffer.c
> +++ linux-2.6/fs/buffer.c
> @@ -2344,6 +2344,8 @@ int nobh_prepare_write(struct page *page
>  
>  	if (is_mapped_to_disk)
>  		SetPageMappedToDisk(page);
> +
> +	/* XXX: information leak vs read(2) */
>  	SetPageUptodate(page);
>  
>  	/*

That comment is too terse to be useful.
