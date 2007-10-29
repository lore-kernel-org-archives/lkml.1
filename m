Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXJ2R35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXJ2R35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXJ2R3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:29:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:9126 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759663AbXJ2R3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qKQWR5WnysGkc207A8ztO5dZ6+OHCw4cbtHANiTI+s0GrsqHFIOL8Vhqq7dF4bUmqVIDE/J3+OgQEU3m/PPrmz5nQnli6OaF9eq3pRNPX3WPAfsFcegDKdna56c6M8RzFHs1noS6NTvaEyUvI5WxJ6CnOIU0X6ie/9Qa8RMhswA=
Date: Mon, 29 Oct 2007 20:30:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Clean up scatterlist.h and introduce macros for
	readability.
Message-ID: <20071029173005.GA8048@cvg>
References: <Pine.LNX.4.64.0710291234560.20259@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710291234560.20259@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Robert P. J. Day - Mon, Oct 29, 2007 at 01:04:02PM -0400]
| 
| Add some macros to <linux/scatterlist.h> to make the bit manipulation
| more readable, and expand on some of the documentation.
| 
| This patch incorporates content from Cyrill Gorcunov
| <gorcunov@gmail.com> as well.
| 
| Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
| 
| ---
| 
|   compile-tested with "make defconfig" under i386.  (what kernel
| subsection would this fall under?)
| 
| 
| diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
| index 4571231..ae296c0 100644
| --- a/include/linux/scatterlist.h
| +++ b/include/linux/scatterlist.h
| @@ -1,10 +1,11 @@
|  #ifndef _LINUX_SCATTERLIST_H
|  #define _LINUX_SCATTERLIST_H
| 
| -#include <asm/types.h>
| -#include <asm/scatterlist.h>
|  #include <linux/mm.h>
|  #include <linux/string.h>
| +
| +#include <asm/types.h>
| +#include <asm/scatterlist.h>
|  #include <asm/io.h>
| 
|  /*
| @@ -12,19 +13,36 @@
|   *
|   * Architectures must provide an unsigned long page_link field in the
|   * scatterlist struct. We use that to place the page pointer AND encode
| - * information about the sg table as well. The two lower bits are reserved
| - * for this information.
| + * information about the sg table as well. The two lower bits (which we
| + * will call the "mask bits" for future reference) are reserved for this
| + * information.
|   *
| - * If bit 0 is set, then the page_link contains a pointer to the next sg
| - * table list. Otherwise the next entry is at sg + 1.
| + * If bit 0 is *not* set, then the next sg entry is simply the next one
| + * consecutively in memory.  If, however, bit 0 *is* set, we must still
| + * go to the next consecutive sg entry in memory, but then we must
| + * additionally (and immediately) follow that pointer to the next
| + * sg entry in the list.
|   *
|   * If bit 1 is set, then this sg entry is the last element in a list.
|   *
|   * See sg_next().
| - *
|   */
| +
| +/*
| + *  Define macros for the mask bits and associated operations.
| + */
| +
| +#define SG_CHAIN	0x1
| +#define SG_LAST		0x2
| +#define SG_MASK		0x3
| +
| +#define sg_is_chain(sg)		((sg)->page_link & SG_CHAIN)
| +#define sg_is_last(sg)		((sg)->page_link & SG_LAST)
| +#define sg_chain_ptr(sg)	\
| +	((struct scatterlist *) ((sg)->page_link & ~SG_MASK))
| +#define sg_page(sg)	((struct page *) ((sg)->page_link & ~SG_MASK))
| 
| -#define SG_MAGIC	0x87654321
| +#define SG_MAGIC	0x87654321	/* only for CONFIG_DEBUG_SG */
| 
|  /**
|   * sg_assign_page - Assign a given page to an SG entry
| @@ -38,17 +56,17 @@
|   **/
|  static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
|  {
| -	unsigned long page_link = sg->page_link & 0x3;
| +	unsigned long saved_mask_bits = sg->page_link & SG_MASK;
| 
|  	/*
|  	 * In order for the low bit stealing approach to work, pages
|  	 * must be aligned at a 32-bit boundary as a minimum.
|  	 */
| -	BUG_ON((unsigned long) page & 0x03);
| +	BUG_ON((unsigned long) page & SG_MASK);
|  #ifdef CONFIG_DEBUG_SG
|  	BUG_ON(sg->sg_magic != SG_MAGIC);
|  #endif
| -	sg->page_link = page_link | (unsigned long) page;
| +	sg->page_link = saved_mask_bits | (unsigned long) page;
|  }
| 
|  /**
| @@ -73,7 +91,6 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
|  	sg->length = len;
|  }
| 
| -#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
| 
|  /**
|   * sg_set_buf - Set sg entry to point at given data
| @@ -88,15 +105,6 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
|  	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
|  }
| 
| -/*
| - * We overload the LSB of the page pointer to indicate whether it's
| - * a valid sg entry, or whether it points to the start of a new scatterlist.
| - * Those low bits are there for everyone! (thanks mason :-)
| - */
| -#define sg_is_chain(sg)		((sg)->page_link & 0x01)
| -#define sg_is_last(sg)		((sg)->page_link & 0x02)
| -#define sg_chain_ptr(sg)	\
| -	((struct scatterlist *) ((sg)->page_link & ~0x03))
| 
|  /**
|   * sg_next - return the next scatterlist entry in a list
| @@ -179,7 +187,7 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
|  #ifndef ARCH_HAS_SG_CHAIN
|  	BUG();
|  #endif
| -	prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
| +	prv[prv_nents - 1].page_link = (unsigned long) sgl | SG_CHAIN;
|  }
| 
|  /**
| @@ -193,12 +201,12 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
|   **/
|  static inline void sg_mark_end(struct scatterlist *sgl, unsigned int nents)
|  {
| -	sgl[nents - 1].page_link = 0x02;
| +	sgl[nents - 1].page_link = SG_LAST;
|  }
| 
|  static inline void __sg_mark_end(struct scatterlist *sg)
|  {
| -	sg->page_link |= 0x02;
| +	sg->page_link |= SG_LAST;
|  }
| 
|  /**
| -- 
| ========================================================================
| Robert P. J. Day
| Linux Consulting, Training and Annoying Kernel Pedantry
| Waterloo, Ontario, CANADA
| 
| http://crashcourse.ca
| ========================================================================
| 

Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

