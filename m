Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYILPE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYILPE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYILPEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:04:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:44085 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYILPEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:04:20 -0400
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: make GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080912145227.GA24945@amd.com>
References: <1221216155-17640-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1221216155-17640-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080912145227.GA24945@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080913001134J.fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 13 Sep 2008 00:11:34 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 16:52:27 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Fri, Sep 12, 2008 at 07:42:35PM +0900, FUJITA Tomonori wrote:
> > Currently, GART IOMMU ingores device's dma_mask when it does virtual
> > mappings. So it could give a device a virtual address that the device
> > can't access to.
> > 
> > This patch fixes the above problem.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |   39 ++++++++++++++++++++++++++++-----------
> >  1 files changed, 28 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > index 47abe43..9739d56 100644
> > --- a/arch/x86/kernel/pci-gart_64.c
> > +++ b/arch/x86/kernel/pci-gart_64.c
> > @@ -83,23 +83,34 @@ static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
> >  static int need_flush;		/* global flush state. set for each gart wrap */
> >  
> >  static unsigned long alloc_iommu(struct device *dev, int size,
> > -				 unsigned long align_mask)
> > +				 unsigned long align_mask, u64 dma_mask)
> 
> You can calculate the dma_mask in this function from the dev parameter.
> There is no need to pass it two levels down to this function extending
> various parameter lists.

No, we can't because we need to use dev->coherent_dma_mask for
alloc_coherent and dev->dma_mask for the rest.
