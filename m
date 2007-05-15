Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbXEOFKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbXEOFKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 01:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbXEOFKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 01:10:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:17788 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbXEOFKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 01:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L4YpNZcj24A7RZyYNAU+MmnSSYU9RQyNBgegSTDDb9HvMAb831GAXXbIAtuGi4ivMWN2XlNba8VyrQcRm6j5wy0A4ozxQgoCcX9XJAKVxRnpZX3ikYCH/KjfpYcjetKgSmQQtjAF4lM+4jkuDP+fRd5phXVzBpyvAVRmqOl/ktw=
Message-ID: <d45a3acc0705142210w3982c14ep8afac73c1352ec7e@mail.gmail.com>
Date: Tue, 15 May 2007 15:10:36 +1000
From: "andrew hendry" <andrew.hendry@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705142135390.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <d45a3acc0705142114t2ed13889p5ed97740782d2821@mail.gmail.com>
	 <alpine.LFD.0.98.0705142135390.6739@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

almost, highstart_pfn is used in a few printks

arch/i386/mm/discontig.c: In function 'setup_memory':
arch/i386/mm/discontig.c:314: error: 'highstart_pfn' undeclared (first
use in this function)
arch/i386/mm/discontig.c:314: error: (Each undeclared identifier is
reported only once
arch/i386/mm/discontig.c:314: error: for each function it appears in.)

On 5/15/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 15 May 2007, andrew hendry wrote:
> >
> > from a randconfig, attached.
> >
> > arch/i386/mm/discontig.c:107: error: expected identifier or '(' before numeric constant
>
> Gaah. That file is horrible. It redeclares a lot of stuff that it has no
> business declaring.
>
> Does this patch help?
>
>                 Linus
> ---
>  arch/i386/mm/discontig.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/i386/mm/discontig.c b/arch/i386/mm/discontig.c
> index aa58720..baac2a4 100644
> --- a/arch/i386/mm/discontig.c
> +++ b/arch/i386/mm/discontig.c
> @@ -31,6 +31,7 @@
>  #include <linux/module.h>
>  #include <linux/kexec.h>
>  #include <linux/pfn.h>
> +#include <linux/swap.h>
>
>  #include <asm/e820.h>
>  #include <asm/setup.h>
> @@ -97,15 +98,8 @@ unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
>  #endif
>
>  extern unsigned long find_max_low_pfn(void);
> -extern void find_max_pfn(void);
>  extern void add_one_highpage_init(struct page *, int, int);
>
> -extern struct e820map e820;
> -extern unsigned long highend_pfn, highstart_pfn;
> -extern unsigned long max_low_pfn;
> -extern unsigned long totalram_pages;
> -extern unsigned long totalhigh_pages;
> -
>  #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
>
>  unsigned long node_remap_start_pfn[MAX_NUMNODES];
> @@ -360,7 +354,9 @@ void __init zone_sizes_init(void)
>         max_zone_pfns[ZONE_DMA] =
>                 virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
>         max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> +#ifdef CONFIG_HIGHMEM
>         max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
> +#endif
>
>         /* If SRAT has not registered memory, register it now */
>         if (find_max_pfn_with_active_regions() == 0) {
>
