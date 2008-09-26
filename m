Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYIZLGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYIZLGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYIZLGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:06:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYIZLGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:06:39 -0400
From: Amit Shah <amit.shah@redhat.com>
Organization: Red Hat
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Date: Fri, 26 Sep 2008 16:19:51 +0530
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <200809261326.19261.amit.shah@redhat.com> <20080926085924.GC27928@amd.com>
In-Reply-To: <20080926085924.GC27928@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261619.51637.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* On Friday 26 Sep 2008 14:29:24 Joerg Roedel wrote:
> On Fri, Sep 26, 2008 at 01:26:19PM +0530, Amit Shah wrote:
> > * On Monday 22 Sep 2008 23:51:21 Joerg Roedel wrote:
> > > This patch enables stackable dma_ops on x86. To do this, it also
> > > enables the per-device dma_ops on i386.
> > >
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > ---
> > >  arch/x86/kernel/pci-dma.c     |   26 ++++++++++++++++++++++++++
> > >  include/asm-x86/device.h      |    6 +++---
> > >  include/asm-x86/dma-mapping.h |   14 +++++++-------
> > >  3 files changed, 36 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > > index b990fb6..2e517c2 100644
> > > --- a/arch/x86/kernel/pci-dma.c
> > > +++ b/arch/x86/kernel/pci-dma.c
> > > @@ -82,6 +82,32 @@ void x86_register_dma_ops(struct dma_mapping_ops
> > > *ops, write_unlock_irqrestore(&dma_ops_list_lock, flags);
> > >  }
> > >
> > > +struct dma_mapping_ops *find_dma_ops_for_device(struct device *dev)
> > > +{
> > > +	int i;
> > > +	unsigned long flags;
> > > +	struct dma_mapping_ops *entry, *ops = NULL;
> > > +
> > > +	read_lock_irqsave(&dma_ops_list_lock, flags);
> > > +
> > > +	for (i = 0; i < DMA_OPS_TYPE_MAX; ++i)
> > > +		list_for_each_entry(entry, &dma_ops_list[i], list) {
> > > +			if (!entry->device_supported)
> > > +				continue;
> > > +			if (entry->device_supported(dev)) {
> > > +				ops = entry;
> > > +				goto out;
> > > +			}
> > > +		}
> > > +out:
> > > +	read_unlock_irqrestore(&dma_ops_list_lock, flags);
> >
> > For PVDMA, we want the "native" dma_ops to succeed first, eg, nommu, and
> > then do our "PV DMA", which is just translating gpa  to hpa and then
> > program the hardware. This isn't being done here. This can be done by
> > extending the return type:
> >
> > DMA_DEV_NOT_SUPPORTED
> > DMA_DEV_HANDLED
> > DMA_DEV_PASS
> >
> > Where NOT_SUPPORTED means we should look for the next one in the chain
> > (current return value 0), DEV_HANDLED means the dma operation has been
> > handled successfully (current return value 1) and DEV_PASS means fall
> > back to the next layer and then return back.
>
> I am not sure I fully understand what you mean? Why do we need to call
> nommu handlers first for PVDMA devices?

For the usual dma_alloc_coherent, dma_map_single, etc. routines. They return 
the gpa to the driver. We want to intercept this gpa and convert it to the 
hpa before passing on the value to the driver. So our dma_alloc_coherent will 
assume the real underlying alloc_coherent has succeeded and then make a 
hypercall.

The PV dma_ops routines won't do the usual allocation, etc. that's already 
done elsewhere.

> I think that PVDMA devices must always be handled by a pv-dma_ops
> implementation. So it makes more sense for me to assign the the dma_ops
> of this implementation to the per-device dma_ops structure when we do
> the first call to the dma api. So we pay this overhead of finding out
> who is responsible only once and not at every call to the dma api.
>
> Joerg


