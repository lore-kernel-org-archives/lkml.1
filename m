Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZFVIoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZFVIoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZFVIn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:43:57 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:20439
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752168AbZFVIn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:43:56 -0400
Message-ID: <4A3F4448.30502@panasas.com>
Date: Mon, 22 Jun 2009 11:43:52 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 08:43:55.0502 (UTC) FILETIME=[93B930E0:01C9F315]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2009 03:55 AM, Paul Menage wrote:
> UML: Fix some apparent bitrot
> 
> - migration of net_device methods into net_device_ops
> - dma_sync_single() changes
> - cpumask_clear() -> cpumask_clear_cpu()
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> --
> 
> Fixes the following compile errors:
> 
> include/linux/dma-mapping.h:113: error: redefinition of 'dma_sync_single'
> arch/um/include/asm/dma-mapping.h:84: error: previous definition of 'dma_sync_single' was here
> include/linux/dma-mapping.h: In function 'dma_sync_single':
> include/linux/dma-mapping.h:117: error: implicit declaration of function 'dma_sync_single_for_cpu'
> include/linux/dma-mapping.h: At top level:
> include/linux/dma-mapping.h:120: error: redefinition of 'dma_sync_sg'
> arch/um/include/asm/dma-mapping.h:91: error: previous definition of 'dma_sync_sg' was here
> include/linux/dma-mapping.h: In function 'dma_sync_sg':
> include/linux/dma-mapping.h:124: error: implicit declaration of function 'dma_sync_sg_for_cpu'
> 
> 
> arch/um/drivers/slirp_kern.c: In function 'slirp_init':
> arch/um/drivers/slirp_kern.c:35: error: 'struct net_device' has no member named 'init'
> 
> 
> arch/um/include/asm/mmu_context.h: In function 'switch_mm':
> arch/um/include/asm/mmu_context.h:38: warning: passing argument 1 of 'cpumask_clear' makes pointer from integer without
> a cast
> arch/um/include/asm/mmu_context.h:38: error: too many arguments to function 'cpumask_clear'
> 
> ---

Stephan hi.

The above breakage is the usual stuff we get every merge window. With people doing
cross arch work and neglecting UML.

Who is the person or people responsible for the large linux-next compilation rig?
Is it possible to also add a UML traget, at least for the x86_64/x86_32 sub-arch?

Thanks
Boaz

> 
>  arch/um/drivers/slip_kern.c       |    1 -
>  arch/um/drivers/slirp_kern.c      |    1 -
>  arch/um/include/asm/dma-mapping.h |    4 ++--
>  arch/um/include/asm/mmu_context.h |    2 +-
>  4 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/um/drivers/slip_kern.c b/arch/um/drivers/slip_kern.c
> index 5ec1756..dd2aadc 100644
> --- a/arch/um/drivers/slip_kern.c
> +++ b/arch/um/drivers/slip_kern.c
> @@ -30,7 +30,6 @@ static void slip_init(struct net_device *dev, void *data)
>  
>  	slip_proto_init(&spri->slip);
>  
> -	dev->init = NULL;
>  	dev->hard_header_len = 0;
>  	dev->header_ops = NULL;
>  	dev->addr_len = 0;
> diff --git a/arch/um/drivers/slirp_kern.c b/arch/um/drivers/slirp_kern.c
> index f15a6e7..e376284 100644
> --- a/arch/um/drivers/slirp_kern.c
> +++ b/arch/um/drivers/slirp_kern.c
> @@ -32,7 +32,6 @@ void slirp_init(struct net_device *dev, void *data)
>  
>  	slip_proto_init(&spri->slip);
>  
> -	dev->init = NULL;
>  	dev->hard_header_len = 0;
>  	dev->header_ops = NULL;
>  	dev->addr_len = 0;
> diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dma-mapping.h
> index 90fc708..378de4b 100644
> --- a/arch/um/include/asm/dma-mapping.h
> +++ b/arch/um/include/asm/dma-mapping.h
> @@ -79,14 +79,14 @@ dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
>  }
>  
>  static inline void
> -dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
> +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
>  		enum dma_data_direction direction)
>  {
>  	BUG();
>  }
>  
>  static inline void
> -dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
> +dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
>  	    enum dma_data_direction direction)
>  {
>  	BUG();
> diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
> index edd719e..34d8130 100644
> --- a/arch/um/include/asm/mmu_context.h
> +++ b/arch/um/include/asm/mmu_context.h
> @@ -35,7 +35,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>  	unsigned cpu = smp_processor_id();
>  
>  	if(prev != next){
> -		cpumask_clear(cpu, mm_cpumask(prev));
> +		cpumask_clear_cpu(cpu, mm_cpumask(prev));
>  		cpumask_set_cpu(cpu, mm_cpumask(next));
>  		if(next != &init_mm)
>  			__switch_mm(&next->context.id);
> 
> 
