Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZGMVvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZGMVvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZGMVvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:51:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:48853 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbZGMVvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:51:04 -0400
Cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
       galak@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-Id: <B6C36B32-6861-4FD9-B8A3-E8C328687E0F@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090710104706I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: removing addr_needs_map in struct dma_mapping_ops
Date: Mon, 13 Jul 2009 16:50:43 -0500
References: <20090710104706I.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9, 2009, at 8:47 PM, FUJITA Tomonori wrote:

> I'm trying to convert POWERPC to use asm-generic/dma-mapping-common.h.
>
> POWERPC needs addr_needs_map() in struct dma_mapping_ops for SWIOTLB
> support but I want to avoid add addr_needs_map() in struct
> dma_map_ops. IIRC, you guys think it as a temporary solution and

That is correct - I was planning to update when the iotlb folks had  
decided on a final scheme for this.  We don't like the additional  
indirection we're getting with the current implementation.

>
> talked about defining something like struct dma_data. Then we could
>
> struct dev_archdata {
>      ...
>
>      struct dma_data *ddata;
> };
>
> or
>
> struct dev_archdata {
>      ...
>
>      struct dma_data ddata;
> };
>
>
> struct dma_data needs dma_direct_offset, iommu_table, dma_base, and
> dma_window_size, anything else?

IIRC, what we had talked about was simpler - we talked about changing  
the current dev_archdata from this:

struct dev_archdata {
        struct device_node      *of_node;
        struct dma_mapping_ops  *dma_ops;
        void                    *dma_data;
};

to this:

struct dev_archdata {
	struct device_node *of_node;
	struct dma_mapping_ops *dma_ops;
	unsigned long long dma_data;
#ifdef CONFIG_SWIOTLB
	dma_addr_t max_direct_dma_addr;
#endif
};

Where max_direct_dma_addr is the address beyond which a specific  
device must use swiotlb, and dma_data is the offset like it is now  
(but wider on 32-bit systems than void *). I believe Ben had mentioned  
wanting to make the max_direct_dma_addr part conditional so we don't  
bloat archdata on platforms that don't ever bounce.

The change to the type of dma_data is actually in preparation for an  
optimization I have planned for 64-bit PCI devices (and which probably  
requires more discussion), so that doesn't need to happen now -  just  
leave it as a void *, and I can post a followup patch.

Let me know if I can help or do any testing - I've been meaning to  
look into switching to dma_map_ops for a while now but it hasn't  
managed to pop off my todo stack.

Cheers,
Becky

