Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZFYKxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZFYKxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZFYKx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:53:26 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:41067 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFYKxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XnFojQzIoFYCvgrOg1o7IdN0G4QGq4/UDVTgh3nfKI0HZadXhvZpuPIVGqoDBqmmt1
         Z4tzAg9TCQx5fpFXDYU3pFHPqUzmPHrqfbW9ETBp89I6RSCr3wqbXFkrFF1t+7AjwcoL
         CDfHuCpnMriIBpyB6rg8Kg1zEylsCyGRQlqr8=
Date: Thu, 25 Jun 2009 18:55:33 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Paul Menage <menage@google.com>
Cc: torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, jdike@addtoit.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090625105533.GI6374@cr0.nay.redhat.com>
References: <20090625071715.20355.80952.stgit@menage.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625071715.20355.80952.stgit@menage.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jun 25, 2009 at 12:17:15AM -0700, Paul Menage wrote:
>UML: Fix some apparent bitrot
>
>- migration of net_device methods into net_device_ops
>- dma_sync_single() changes
>
>Signed-off-by: Paul Menage <menage@google.com>

ACK for these two.

Thanks, Paul!

Andrew, please take these two patches for UML.


>
>--
>
>This version is split from my earlier patch, including just the
>portions that ar required for Linus' tree.
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
>---
>
> arch/um/drivers/slip_kern.c       |    1 -
> arch/um/drivers/slirp_kern.c      |    1 -
> arch/um/include/asm/dma-mapping.h |    4 ++--
> 3 files changed, 2 insertions(+), 4 deletions(-)
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
>
