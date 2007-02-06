Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXBFIZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXBFIZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXBFIZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:25:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXBFIZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:25:21 -0500
Date: Tue, 6 Feb 2007 00:25:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 1/3] mm: fix PageUptodate memorder
Message-Id: <20070206002512.4e0bbbad.akpm@linux-foundation.org>
In-Reply-To: <20070206054935.21042.13541.sendpatchset@linux.site>
References: <20070206054925.21042.50546.sendpatchset@linux.site>
	<20070206054935.21042.13541.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Feb 2007 09:02:11 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:

> +static inline void __SetPageUptodate(struct page *page)
> +{
> +#ifdef CONFIG_S390
>  	if (!test_and_set_bit(PG_uptodate, &page->flags))
>  		page_test_and_clear_dirty(page);
> -}
>  #else
> -#define SetPageUptodate(page)	set_bit(PG_uptodate, &(page)->flags)
> +	/*
> +	 * Memory barrier must be issued before setting the PG_uptodate bit,
> +	 * so all previous writes that served to bring the page uptodate are
> +	 * visible before PageUptodate becomes true.
> +	 *
> +	 * S390 is guaranteed to have a barrier in the test_and_set operation
> +	 * (see Documentation/atomic_ops.txt).
> +	 *
> +	 * XXX: does this memory barrier need to be anything special to
> +	 * handle things like DMA writes into the page?
> +	 */
> +	smp_wmb();
> +	set_bit(PG_uptodate, &(page)->flags);
>  #endif
> +}
> +
> +static inline void SetPageUptodate(struct page *page)
> +{
> +	WARN_ON(!PageLocked(page));
> +	__SetPageUptodate(page);
> +}
> +
> +static inline void SetNewPageUptodate(struct page *page)
> +{
> +	__SetPageUptodate(page);
> +}

I was panicing for a minute when I saw that __SetPageUptodate() in there.

Conventionally the __SetPageFoo namespace is for nonatomic updates to
page->flags.  Can we call this something different?


What a fugly patchset :(
