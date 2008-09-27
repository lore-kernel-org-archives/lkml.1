Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYI0AOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYI0AOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYI0ANz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:13:55 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:47094 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYI0ANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:13:54 -0400
Date: Sat, 27 Sep 2008 03:13:21 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080927001321.GI9118@il.ibm.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <200809261326.19261.amit.shah@redhat.com> <20080926085924.GC27928@amd.com> <200809261619.51637.amit.shah@redhat.com> <20080926123243.GE27928@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926123243.GE27928@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 02:32:43PM +0200, Joerg Roedel wrote:

> Ok, the allocation only matters for dma_alloc_coherent. Fujita
> introduced a generic software-based dma_alloc_coherent recently
> which you can use for that. I think implementing PVDMA into an own
> dma_ops backend and multiplex it using my patches introduces less
> overhead than an additional layer over the current dma_ops
> implementation.

I'm not sure what you have in mind, but I agree with Amit that
conceptually pvdma should be called after the guest's "native" dma_ops
have done their thing. This is not just for nommu, consider a guest
that is using an (emulated) hardware IOMMU, or that wants to use
swiotlb. We can't replicate their functionality in the pv_dma_ops
layer, we have to let them run first and then pass deal with whatever
we get back.

> Another two questions to your approach: What happens if a
> dma_alloc_coherent allocation crosses page boundarys and the gpa's
> are not contiguous in host memory? How will dma masks be handled?

That's a very good question. The host will need to be aware of a
device's DMA capabilities in order to return I/O addresses (which
could be hpa's if you don't have an IOMMU) that satisfy them. That's
quite a pain.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                      xxx
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
