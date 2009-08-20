Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZHTXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZHTXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 19:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZHTXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 19:25:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbZHTXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 19:25:24 -0400
Date: Thu, 20 Aug 2009 16:25:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH,resend] Fix strange panic message selection logic when
 swiotlb fills up
Message-Id: <20090820162510.063d603c.akpm@linux-foundation.org>
In-Reply-To: <4A8DA97C.9020406@redhat.com>
References: <4A8DA97C.9020406@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 15:52:28 -0400
Casey Dahlin <cdahlin@redhat.com> wrote:

> swiotlb_full in lib/swiotlb.c throws one of two panic messages based on whether
> the direction of transfer is from the device or to the device. The logic around
> this is somewhat weird in the case of bidirectional transfers. It appears to
> want to throw both in succession, but since its a panic only the first makes it.
> 
> This patch adds a third, separate error for DMA_BIDIRECTIONAL to make things a
> bit clearer.
> 
> Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
> 
> ---
>  lib/swiotlb.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index bffe6d7..35e01b3 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -625,12 +625,15 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
>  	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
>  	       "device %s\n", size, dev ? dev_name(dev) : "?");
>  
> -	if (size > io_tlb_overflow && do_panic) {
> -		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
> -			panic("DMA: Memory would be corrupted\n");
> -		if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
> -			panic("DMA: Random memory would be DMAed\n");
> -	}
> +	if (size <= io_tlb_overflow || !do_panic)
> +		return;
> +
> +	if (dir == DMA_BIDIRECTIONAL)
> +		panic("DMA: Random memory could be corrupted or DMAed\n");
> +	if (dir == DMA_FROM_DEVICE)
> +		panic("DMA: Memory would be corrupted\n");
> +	if (dir == DMA_TO_DEVICE)
> +		panic("DMA: Random memory would be DMAed\n");
>  }
>  

Seems sane to me.

While we're there, how about we make the final message less ambiguous? 

--- a/lib/swiotlb.c~lib-swiotlbc-fix-strange-panic-message-selection-logic-when-swiotlb-fills-up-fix
+++ a/lib/swiotlb.c
@@ -633,7 +633,7 @@ swiotlb_full(struct device *dev, size_t 
 	if (dir == DMA_FROM_DEVICE)
 		panic("DMA: Memory would be corrupted\n");
 	if (dir == DMA_TO_DEVICE)
-		panic("DMA: Random memory would be DMAed\n");
+		panic("DMA: Random memory would be DMAed from\n");
 }
 
 /*
_

