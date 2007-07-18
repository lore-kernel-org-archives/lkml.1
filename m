Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbXGRGeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbXGRGeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXGRGeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:34:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbXGRGeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:34:16 -0400
Date: Tue, 17 Jul 2007 23:33:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Dave Airlie <airlied@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] vmalloc_32 should use GFP_KERNEL
Message-Id: <20070717233358.2edeaac0.akpm@linux-foundation.org>
In-Reply-To: <1184739934.25235.220.camel@localhost.localdomain>
References: <1184739934.25235.220.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 16:25:34 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> I've noticed lots of failures of vmalloc_32 on machines where it
> shouldn't have failed unless it was doing an atomic operation.
> 
> Looking closely, I noticed that:
> 
> #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
> #define GFP_VMALLOC32 GFP_DMA32
> #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
> #define GFP_VMALLOC32 GFP_DMA
> #else
> #define GFP_VMALLOC32 GFP_KERNEL
> #endif
> 
> Which seems to be incorrect, it should always -or- in the DMA flags
> on top of GFP_KERNEL, thus this patch.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> This fixes frequent errors launchin X with the nouveau DRM for example.
> 
> Index: linux-work/mm/vmalloc.c
> ===================================================================
> --- linux-work.orig/mm/vmalloc.c	2007-07-18 16:22:00.000000000 +1000
> +++ linux-work/mm/vmalloc.c	2007-07-18 16:22:11.000000000 +1000
> @@ -578,9 +578,9 @@ void *vmalloc_exec(unsigned long size)
>  }
>  
>  #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
> -#define GFP_VMALLOC32 GFP_DMA32
> +#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
>  #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
> -#define GFP_VMALLOC32 GFP_DMA
> +#define GFP_VMALLOC32 GFP_DMA | GFP_KERNEL
>  #else
>  #define GFP_VMALLOC32 GFP_KERNEL
>  #endif
> 

whoops, yes.

Are those errors serious and common enough for 2.6.22.x?  
