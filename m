Return-Path: <linux-kernel-owner+w=401wt.eu-S2993150AbXEBT3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993150AbXEBT3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993158AbXEBT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:29:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35636 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766663AbXEBT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:29:06 -0400
Date: Wed, 2 May 2007 20:29:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] firewire: isochronous and asynchronous I/O
Message-ID: <20070502192904.GB1248@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.65aea95f1451c211@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	for (i = 0; i < buffer->page_count; i++) {
> +		buffer->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
> +		if (buffer->pages[i] == NULL)
> +			goto out_pages;
> +
> +		address = dma_map_page(card->device, buffer->pages[i],
> +				       0, PAGE_SIZE, direction);
> +		if (dma_mapping_error(address)) {
> +			__free_page(buffer->pages[i]);
> +			goto out_pages;
> +		}

Are you sure using streaming dma mapping is safe here?  I don't see
actual user in this patch, but doing the proper ownership protocol
for them is quite difficult if you reuse them, and allocating them
in kernelspace usually means you want to keep reusing them.

> +#include <linux/kthread.h>

You don't actually seem to use this one ..

> +#include <asm/uaccess.h>

.. or this one ..

> +#include <asm/semaphore.h>

.. or this one.

> +	retval = fw_core_add_address_handler(&topology_map,
> +					     &topology_map_region);
> +	BUG_ON(retval < 0);
> +
> +	retval = fw_core_add_address_handler(&registers,
> +					     &registers_region);
> +	BUG_ON(retval < 0);
> +
> +	/* Add the vendor textual descriptor. */
> +	retval = fw_core_add_descriptor(&vendor_id_descriptor);
> +	BUG_ON(retval < 0);
> +	retval = fw_core_add_descriptor(&model_id_descriptor);
> +	BUG_ON(retval < 0);

These kinds of bug checks look wrong.  Either the operations
can't fail in which case they should not return an error value
or you should handle them properly.



Both the previous and this patch contain quite a lot of GFP_ATOMIC
allocation which are a sign of not having a very good layering.
