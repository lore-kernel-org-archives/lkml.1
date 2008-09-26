Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYIZLAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYIZLAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYIZLAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:00:19 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40923 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYIZLAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:00:17 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K7SUK4-04-OSK-01
Date: Fri, 26 Sep 2008 13:00:04 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Amit Shah <amit.shah@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080926110004.GD27928@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-10-git-send-email-joerg.roedel@amd.com> <200809261326.19261.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200809261326.19261.amit.shah@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 26 Sep 2008 11:00:04.0833 (UTC) FILETIME=[07E76D10:01C91FC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 01:26:19PM +0530, Amit Shah wrote:
> * On Monday 22 Sep 2008 23:51:21 Joerg Roedel wrote:
> > This patch enables stackable dma_ops on x86. To do this, it also enables
> > the per-device dma_ops on i386.
> >
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-dma.c     |   26 ++++++++++++++++++++++++++
> >  include/asm-x86/device.h      |    6 +++---
> >  include/asm-x86/dma-mapping.h |   14 +++++++-------
> >  3 files changed, 36 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index b990fb6..2e517c2 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -82,6 +82,32 @@ void x86_register_dma_ops(struct dma_mapping_ops *ops,
> >  	write_unlock_irqrestore(&dma_ops_list_lock, flags);
> >  }
> >
> > +struct dma_mapping_ops *find_dma_ops_for_device(struct device *dev)
> > +{
> > +	int i;
> > +	unsigned long flags;
> > +	struct dma_mapping_ops *entry, *ops = NULL;
> > +
> > +	read_lock_irqsave(&dma_ops_list_lock, flags);
> > +
> > +	for (i = 0; i < DMA_OPS_TYPE_MAX; ++i)
> > +		list_for_each_entry(entry, &dma_ops_list[i], list) {
> > +			if (!entry->device_supported)
> > +				continue;
> > +			if (entry->device_supported(dev)) {
> > +				ops = entry;
> > +				goto out;
> > +			}
> > +		}
> > +out:
> > +	read_unlock_irqrestore(&dma_ops_list_lock, flags);
> 
> For PVDMA, we want the "native" dma_ops to succeed first, eg, nommu, and then 
> do our "PV DMA", which is just translating gpa  to hpa and then program the 

Btw, how will dma_masks be handled when PV DMA just translates gpa to
hpa?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

