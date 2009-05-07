Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZEGKid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZEGKid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZEGKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:38:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZEGKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:38:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH -tip 1/5] add asm-generic/dma-mappig.h
Date: Thu, 7 May 2009 12:38:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
References: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1241670948-5818-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241670948-5818-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071238.05110.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Xz1McUxcltYpsZ0hkPkDwtZSc11QcrTEMi2z
 yT/9u+2Di49ztq/Z2hTJ04ib3O/HcgBnfUNxKvIzHWRBqIre0C
 neZ2+6jfBxotqJyqKI9Lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, FUJITA Tomonori wrote:
> This header file provides some generic dma mapping function
> definitions for the users of struct dma_map_ops.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

I'm currently trying to add asm-generic variants for all of
the common headers. One of my goals there is to make them
as complete as possible, i.e. if a header file in asm-generic
has the same name as one in any of the architectures, it should
IMHO provide the same (full) API.

I would therefore suggest that you either rename the file to
something like dma-mapping-common.h or add some template
functions that can be overriden per architecture, like

#ifndef dma_get_ops
static inline struct dma_map_ops *get_dma_ops(struct device *dev)
{
	return dma_ops;
}
#endif
#ifndef dma_alloc_coherent
/*
 * to be defined out of line
 */
extern void *dma_alloc_coherent(struct device *dev, size_t size,
		dma_addr_t *dma_handle, gfp_t gfp);
#endif

Then an architecture can opt-in to do things like:

#define dma_get_ops dma_get_ops
static inline struct dma_map_ops *get_dma_ops(struct device *dev)
{
	return dev->archdata.dma_ops;
}

before the #include <asm-generic/dma-mapping.h>

> +static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
> +					      size_t size,
> +					      enum dma_data_direction dir,
> +					      struct dma_attrs *attrs)
> +{
> +	struct dma_map_ops *ops = get_dma_ops(dev);
> +	dma_addr_t addr;
> +
> +	kmemcheck_mark_initialized(ptr, size);
> +	BUG_ON(!valid_dma_direction(dir));
> +	addr = ops->map_page(dev, virt_to_page(ptr),
> +			     (unsigned long)ptr & ~PAGE_MASK, size,
> +			     dir, NULL);
> +	debug_dma_map_page(dev, virt_to_page(ptr),
> +			   (unsigned long)ptr & ~PAGE_MASK, size,
> +			   dir, addr, true);
> +	return addr;
> +}

You are not passing the dma_attrs down here, which I think you need to,
if any of the architectures using this file want to support DMA attributes.

> +
> +static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
> +					  size_t size,
> +					  enum dma_data_direction dir,
> +					  struct dma_attrs *attrs)
> +{
> +	struct dma_map_ops *ops = get_dma_ops(dev);
> +
> +	BUG_ON(!valid_dma_direction(dir));
> +	if (ops->unmap_page)
> +		ops->unmap_page(dev, addr, size, dir, NULL);
> +	debug_dma_unmap_page(dev, addr, size, dir, true);
> +}

same here and in the next few functions.

	Arnd <><
