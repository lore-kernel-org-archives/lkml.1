Return-Path: <linux-kernel-owner+w=401wt.eu-S1750777AbXB0UZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750777AbXB0UZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXB0UZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:25:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXB0UZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:25:04 -0500
Date: Tue, 27 Feb 2007 12:24:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] fix section mismatch warning in lib/swiotlb.c
Message-Id: <20070227122454.831c75b8.akpm@linux-foundation.org>
In-Reply-To: <20070226183800.GA15669@uranus.ravnborg.org>
References: <20070226183800.GA15669@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 26 Feb 2007 19:38:00 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> kbuild spits outs following warning on a 
> defconfig x86_64 build:
> WARNING: swiotlb.o - Section mismatch: reference to .init.text:swiotlb_init from __ksymtab between '__ksymtab_swiotlb_init' (at offset 0xa0) and '__ksymtab_swiotlb_free_coherent'
> 
> This warning happens because the function 
> swiotlb_init is marked __init and EXPORT_SYMBOL().
> A 'git grep swiotlb_init' showed no users in drivers/
> so maybe the EXPORT_SYMBOL can be deleted which would cure the warning?
> 
> I took the pragmatic approach and made it non-__init.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 623a68a..3133495 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -160,7 +160,7 @@ __setup("swiotlb=", setup_io_tlb_npages);
>   * Statically reserve bounce buffer space and initialize bounce buffer data
>   * structures for the software IO TLB used to implement the DMA API.
>   */
> -void __init
> +void
>  swiotlb_init_with_default_size(size_t default_size)
>  {
>  	unsigned long i, bytes;
> @@ -211,7 +211,7 @@ swiotlb_init_with_default_size(size_t default_size)
>  #define __swiotlb_init_with_default_size swiotlb_init_with_default_size
>  #endif
>  
> -void __init
> +void
>  swiotlb_init(void)
>  {
>  	__swiotlb_init_with_default_size(64 * (1<<20)); /* default to 64MB */

eh.  If there's a module anywhere which calls swiotlb_init() then I suspect
it's one which deserves breaking ;)

I'll remove the export.
