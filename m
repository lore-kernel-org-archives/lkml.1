Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbYENQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbYENQEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYENQE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:04:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42387 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762915AbYENQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:04:29 -0400
Date: Wed, 14 May 2008 09:03:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Timur Tabi <timur@freescale.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Add alloc_pages_exact() and free_pages_exact()
Message-Id: <20080514090335.a4bacd17.randy.dunlap@oracle.com>
In-Reply-To: <1210714006-8976-1-git-send-email-timur@freescale.com>
References: <1210714006-8976-1-git-send-email-timur@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 16:26:46 -0500 Timur Tabi wrote:

>  include/linux/gfp.h |    3 ++
>  mm/page_alloc.c     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bdd5c43..2b685eb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1736,6 +1736,59 @@ void free_pages(unsigned long addr, unsigned int order)
>  
>  EXPORT_SYMBOL(free_pages);

Hi Timur,

Please use kernel-doc notation/format for these functions as documented
in Documentation/kernel-doc-nano-HOWTO.txt.  Ask me if you have
any questions/problems with it.

> +/**
> + * Allocate an exact number of pages of physically-contiguous memory.
> + *
> + * This function is similar to alloc_pages(), except that it allocates the
> + * minimum number of pages to satisfy the request.  alloc_pages() can only
> + * allocate memory in power-of-two pages.
> + *
> + * This function is also limited by MAX_ORDER.
> + *
> + * Memory allocated by this function must be released by free_pages_exact().
> + */
> +void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
> +{
> +	unsigned int order = get_order(size);
> +	unsigned long addr;
> +
> +	addr = __get_free_pages(gfp_mask, order);
> +	if (addr) {
> +		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> +		unsigned long used = addr + PAGE_ALIGN(size);
> +
> +		split_page(virt_to_page(addr), order);
> +		while (used < alloc_end) {
> +			free_page(used);
> +			used += PAGE_SIZE;
> +		}
> +	}
> +
> +	return (void *)addr;
> +}
> +EXPORT_SYMBOL(alloc_pages_exact);
> +
> +/**
> + * Releases memory allocated via alloc_pages_exact()
> + *
> + * Release the memory allocated by a previous call to alloc_pages_exact.
> + *
> + * The first parameter must be the value returned by alloc_pages_exact(),
> + * and the 'size' parameter must be the same as was passed to
> + * alloc_pages_exact().
> + */
> +void free_pages_exact(void *virt, size_t size)
> +{
> +	unsigned long addr = (unsigned long)virt;
> +	unsigned long end = addr + PAGE_ALIGN(size);
> +
> +	while (addr < end) {
> +		free_page(addr);
> +		addr += PAGE_SIZE;
> +	}
> +}
> +EXPORT_SYMBOL(free_pages_exact);


---
~Randy
