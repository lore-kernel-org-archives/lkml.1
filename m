Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZFCIhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZFCIhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZFCIhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:37:03 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50911 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbZFCIhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:37:01 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dR1805Mzz1202hzz5a6ciz32i6bh1a3h17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKNML8-03-6L0-01
Date: Wed, 3 Jun 2009 10:36:42 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: amd_iommu, fix lock imbalance
Message-ID: <20090603083642.GB22359@amd.com>
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com> <1243497289-18591-2-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1243497289-18591-2-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 03 Jun 2009 08:36:42.0888 (UTC) FILETIME=[6C044880:01C9E426]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 09:54:48AM +0200, Jiri Slaby wrote:
> In alloc_coherent there is an omitted unlock on the path where mapping
> fails. Add the unlock.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index a97db99..b123e20 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -1537,8 +1537,10 @@ static void *alloc_coherent(struct device *dev, size_t size,
>  	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
>  				 size, DMA_BIDIRECTIONAL, true, dma_mask);
>  
> -	if (*dma_addr == bad_dma_address)
> +	if (*dma_addr == bad_dma_address) {
> +		spin_unlock_irqrestore(&domain->lock, flags);
>  		goto out_free;
> +	}
>  
>  	iommu_completion_wait(iommu);

Applied to amd-iommu/fixes. Thanks Jiri.

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

