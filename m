Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZFVCoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZFVCoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 22:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZFVCoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 22:44:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:23599 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbZFVCoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 22:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R2QXAoS7Vyz0rMM/Zhm34V62yJJineeFNNlMpIjwD6BB3p9kQwcDE8bAhklzQCmAaq
         FfdKSEtesKJxJozVRU519vWoD9ZzC4MesncvY8sLTSP2osnZnIMh9hwQD25OhyD8nEZK
         tizg/dj7aKgN0KYIlw6NZr3nrwsNYye1mprCk=
Date: Mon, 22 Jun 2009 10:46:10 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090622024610.GC5893@cr0.nay.redhat.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 05:55:24PM -0700, Paul Menage wrote:
>UML: Fix some apparent bitrot
>
>- migration of net_device methods into net_device_ops
>- dma_sync_single() changes
>- cpumask_clear() -> cpumask_clear_cpu()
>
>Signed-off-by: Paul Menage <menage@google.com>


Looks good.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>
>--
>
>Fixes the following compile errors:
>
>include/linux/dma-mapping.h:113: error: redefinition of 'dma_sync_single'
>arch/um/include/asm/dma-mapping.h:84: error: previous definition of 'dma_sync_single' was here
>include/linux/dma-mapping.h: In function 'dma_sync_single':
>include/linux/dma-mapping.h:117: error: implicit declaration of function 'dma_sync_single_for_cpu'
>include/linux/dma-mapping.h: At top level:
>include/linux/dma-mapping.h:120: error: redefinition of 'dma_sync_sg'
>arch/um/include/asm/dma-mapping.h:91: error: previous definition of 'dma_sync_sg' was here
>include/linux/dma-mapping.h: In function 'dma_sync_sg':
>include/linux/dma-mapping.h:124: error: implicit declaration of function 'dma_sync_sg_for_cpu'
>
>
>arch/um/drivers/slirp_kern.c: In function 'slirp_init':
>arch/um/drivers/slirp_kern.c:35: error: 'struct net_device' has no member named 'init'
>
>
>arch/um/include/asm/mmu_context.h: In function 'switch_mm':
>arch/um/include/asm/mmu_context.h:38: warning: passing argument 1 of 'cpumask_clear' makes pointer from integer without
>a cast
>arch/um/include/asm/mmu_context.h:38: error: too many arguments to function 'cpumask_clear'
>
>---
>
> arch/um/drivers/slip_kern.c       |    1 -
> arch/um/drivers/slirp_kern.c      |    1 -
> arch/um/include/asm/dma-mapping.h |    4 ++--
> arch/um/include/asm/mmu_context.h |    2 +-
> 4 files changed, 3 insertions(+), 5 deletions(-)
>
>diff --git a/arch/um/drivers/slip_kern.c b/arch/um/drivers/slip_kern.c
>index 5ec1756..dd2aadc 100644
>--- a/arch/um/drivers/slip_kern.c
>+++ b/arch/um/drivers/slip_kern.c
>@@ -30,7 +30,6 @@ static void slip_init(struct net_device *dev, void *data)
> 
> 	slip_proto_init(&spri->slip);
> 
>-	dev->init = NULL;
> 	dev->hard_header_len = 0;
> 	dev->header_ops = NULL;
> 	dev->addr_len = 0;
>diff --git a/arch/um/drivers/slirp_kern.c b/arch/um/drivers/slirp_kern.c
>index f15a6e7..e376284 100644
>--- a/arch/um/drivers/slirp_kern.c
>+++ b/arch/um/drivers/slirp_kern.c
>@@ -32,7 +32,6 @@ void slirp_init(struct net_device *dev, void *data)
> 
> 	slip_proto_init(&spri->slip);
> 
>-	dev->init = NULL;
> 	dev->hard_header_len = 0;
> 	dev->header_ops = NULL;
> 	dev->addr_len = 0;
>diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dma-mapping.h
>index 90fc708..378de4b 100644
>--- a/arch/um/include/asm/dma-mapping.h
>+++ b/arch/um/include/asm/dma-mapping.h
>@@ -79,14 +79,14 @@ dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
> }
> 
> static inline void
>-dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
>+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
> 		enum dma_data_direction direction)
> {
> 	BUG();
> }
> 
> static inline void
>-dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
>+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
> 	    enum dma_data_direction direction)
> {
> 	BUG();
>diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
>index edd719e..34d8130 100644
>--- a/arch/um/include/asm/mmu_context.h
>+++ b/arch/um/include/asm/mmu_context.h
>@@ -35,7 +35,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> 	unsigned cpu = smp_processor_id();
> 
> 	if(prev != next){
>-		cpumask_clear(cpu, mm_cpumask(prev));
>+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
> 		cpumask_set_cpu(cpu, mm_cpumask(next));
> 		if(next != &init_mm)
> 			__switch_mm(&next->context.id);
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
