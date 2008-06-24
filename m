Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYFXVeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYFXVeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbYFXVds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:33:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50454 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741AbYFXVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:33:46 -0400
Subject: Re: [PATCH] Add alloc_pages_exact() and free_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, randy.dunlap@oracle.com,
       corbet@lwn.net, torvalds@linux-foundation.org
In-Reply-To: <1214325649-26075-1-git-send-email-timur@freescale.com>
References: <1214325649-26075-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Jun 2008 14:33:38 -0700
Message-Id: <1214343218.12367.58.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 11:40 -0500, Timur Tabi wrote:
> +void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
> +{
> +       unsigned int order = get_order(size);
> +       unsigned long addr;
> +
> +       addr = __get_free_pages(gfp_mask, order);
> +       if (addr) {
> +               unsigned long alloc_end = addr + (PAGE_SIZE << order);
> +               unsigned long used = addr + PAGE_ALIGN(size);
> +
> +               split_page(virt_to_page(addr), order);
> +               while (used < alloc_end) {
> +                       free_page(used);
> +                       used += PAGE_SIZE;
> +               }
> +       }
> +
> +       return (void *)addr;
> +}

Hi Timur,

This looks like a really good idea.  It looks pretty good to me, no
functional problems.  My brain had a really hard time parsing that code
for some reason, though.  Could just be a lack of coffee.

I think the thing that confused me was trying to figure out if
'alloc_end' was the end of what we *did* allocate from
__get_free_pages() or if it was the *goal* allocation end.

'used' also seemed like a slightly strange variable name because it
points to the memory which is about to be freed and ends up *unused*.

I'll offer this up just in case you like it better.  For me, it is
easier to parse, and should do the exact same thing.  I also think it's
slightly nicer to do the arithmetic on 'struct page *' rather than
vaddrs in 'unsigned long'.  It is _slightly_ cheaper not having to do a
virt_to_page() on each free_page() call.  The same would go for the free
side as well.

All of the 'struct page *' arithmetic is OK since it is all done inside
one MAX_ORDER area.

﻿void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
{
	﻿unsigned int order = get_order(size);
	void *alloc;
	struct page *surplus_start;
	﻿struct page *surplus_end;
	struct page *page;

	size = PAGE_ALIGN(size);

	alloc = (void *)__get_free_pages(gfp_mask, order);
	if (!alloc)
		return NULL;

	/* Turn the big allocation into a bunch of single pages */
	﻿split_page(virt_to_page(alloc), order);

	surplus_start = virt_to_page(alloc + size);
	surplus_end =﻿ surplus_start + ﻿(1 << order);

	for (page = ﻿surplus_start; page < surplus_end; page++)
		﻿__free_page(page);

	return alloc;
}

-- Dave

