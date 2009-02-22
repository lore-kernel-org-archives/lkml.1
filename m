Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZBVGvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZBVGvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 01:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBVGv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 01:51:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:39146 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZBVGv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 01:51:28 -0500
Date: Sun, 22 Feb 2009 15:50:46 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 15/16] dma-debug: x86 architecture bindings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1232376423-11067-16-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
	<1232376423-11067-16-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090222155050W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 22 Feb 2009 15:50:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 15:47:02 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Impact: make use of DMA-API debugging code in x86
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/Kconfig                   |    1 +
>  arch/x86/include/asm/dma-mapping.h |   45 +++++++++++++++++++++++++++++++----
>  arch/x86/kernel/pci-dma.c          |    6 ++++
>  3 files changed, 46 insertions(+), 6 deletions(-)

(snip)

>  static inline int
> @@ -79,9 +86,13 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
>  	   int nents, enum dma_data_direction dir)
>  {
>  	struct dma_map_ops *ops = get_dma_ops(hwdev);
> +	int ents;
>  
>  	BUG_ON(!valid_dma_direction(dir));
> -	return ops->map_sg(hwdev, sg, nents, dir, NULL);
> +	ents = ops->map_sg(hwdev, sg, nents, dir, NULL);
> +	debug_dma_map_sg(hwdev, sg, ents, dir);

The way to handle dma_map_sg and dma_unmap_sg looks wrong.

ents could be smaller than nents here with IOMMU implementations that
merge several sg entries into one.


> +	return ents;
>  }
>  
>  static inline void
> @@ -91,6 +102,7 @@ dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
>  	struct dma_map_ops *ops = get_dma_ops(hwdev);
>  
>  	BUG_ON(!valid_dma_direction(dir));
> +	debug_dma_unmap_sg(hwdev, sg, nents, dir);

Here the nents is the same one you passed into dma_map_sg call. It is
not the value returned from dma_map_sg (see DMA-mapping.txt).

So we call check_unmap for entries that we didn't call add_dma_entry
for on dma_map_sg. These entries are not initialized so we could get any
kinds of warnings from check_unmap.
