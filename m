Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZCEWdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZCEWdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZCEWcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:32:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925AbZCEWcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:32:52 -0500
Date: Thu, 5 Mar 2009 14:31:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, jirislaby@gmail.com,
       rmk+lkml@arm.linux.org.uk
Subject: Re: [PATCH] generic debug pagealloc (-v2)
Message-Id: <20090305143150.136e2708.akpm@linux-foundation.org>
In-Reply-To: <20090305145926.GA27015@localhost.localdomain>
References: <20090305145926.GA27015@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009 23:59:27 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> CONFIG_DEBUG_PAGEALLOC is now supported by x86, powerpc, sparc (64bit),
> and s390. This patch implements it for the rest of the architectures
> by filling the pages with poison byte patterns after free_pages() and
> verifying the poison patterns before alloc_pages().
> 
> This generic one cannot detect invalid read accesses and it can only
> detect invalid write accesses after a long delay. But it is a feasible way
> for nommu architectures.
> 
> ...
>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +
> +static void poison_page(struct page *page)
> +{
> +	void *addr;
> +
> +	if (PageHighMem(page))
> +		return; /* i goofed */

heh.  A more complete comment would be needed here.

Also, as this is a kernel bug, perhaps some sort of runtime warning?

> +	page->poison = true;
> +	addr = page_address(page);
> +	memset(addr, PAGE_POISON, PAGE_SIZE);
> +}
> +
> +static void poison_pages(struct page *page, int n)
> +{
> +	int i;
> +
> +	for (i = 0; i < n; i++)
> +		poison_page(page + i);
> +}
> +
> +static void check_poison_mem(unsigned char *mem, size_t bytes)
> +{
> +	unsigned char *start;
> +	unsigned char *end;
> +
> +	for (start = mem; start < mem + bytes; start++) {
> +		if (*start != PAGE_POISON)
> +			break;
> +	}
> +	if (start == mem + bytes)
> +		return;
> +
> +	for (end = mem + bytes - 1; end > start; end--) {
> +		if (*end != PAGE_POISON)
> +			break;
> +	}
> +	printk(KERN_ERR "Page corruption: %p-%p\n", start, end);
> +	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
> +			end - start + 1, 1);
> +}
> +
> +static void unpoison_page(struct page *page)
> +{
> +	void *addr;
> +

Shouldn't we check PageHighmem() here also?

> +	if (!page->poison)
> +		return;
> +
> +	addr = page_address(page);
> +	check_poison_mem(addr, PAGE_SIZE);
> +	page->poison = false;
> +}
> +

