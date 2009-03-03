Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZCCVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZCCVgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZCCVgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:36:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZCCVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:36:44 -0500
Date: Tue, 3 Mar 2009 13:36:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] generic debug pagealloc
Message-Id: <20090303133610.cb771fef.akpm@linux-foundation.org>
In-Reply-To: <20090303160103.GB5812@localhost.localdomain>
References: <20090303160103.GB5812@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 01:01:04 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> +static void unpoison_page(struct page *page)
> +{
> +	unsigned char *mem;
> +	int i;
> +
> +	if (!page->poison)
> +		return;
> +
> +	mem = kmap_atomic(page, KM_USER0);
> +	for (i = 0; i < PAGE_SIZE; i++) {
> +		if (mem[i] != PAGE_POISON) {
> +			dump_broken_mem(mem);
> +			break;
> +		}
> +	}
> +	kunmap_atomic(mem, KM_USER0);
> +	page->poison = false;
> +}
> +
> +static void unpoison_pages(struct page *page, int n)
> +{
> +	int i;
> +
> +	for (i = 0; i < n; i++)
> +		unpoison_page(page + i);
> +}
> +
> +void kernel_map_pages(struct page *page, int numpages, int enable)
> +{
> +	if (!debug_pagealloc_enabled)
> +		return;
> +
> +	if (enable)
> +		unpoison_pages(page, numpages);
> +	else
> +		poison_pages(page, numpages);
> +}

kernel_map_pages() is called from the memory-allocation and
memory-freeing paths.  Hence it can be called from interrupt contexts.

KM_USER0 must not be used from interrupt context - it will corrupt the
non-interrupt context's pte, causing unpleasing very hard to track down
memory corruption.  Often memory which is getting written to the user's
disk.  This makes users unhappy.

We could use KM_IRQ0 here.  The code should disable local interrupts
when holding a KM_IRQ0 kmap.

If this code were to switch to using KM_IRQ0 then we still have a
problem - if any other place in the kernel does a memory allcoation or
free while holding a KM_IRQ0 kmap, then this new code will corrupt the
caller's pte.

So I guess we'll need to create a new kmap_atomic slot for this
application.  It will need interrupt protection - the page allocator can
be called from interrupt context while it is already running in
non-interrupt context.


Alternatively, we could just not do the kmap_atomic() at all.  i386
won't be using this code and IIRC the only other highmem architecture
is powerpc32, and ppc32 appears to also have its own DEBUG_PAGEALLOC
implementation.  So you could remove the kmap_atomic() stuff and put

#ifdef CONFIG_HIGHMEM
#error i goofed
#endif

in there.
