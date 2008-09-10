Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYIJOZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYIJOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYIJOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:25:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:43348 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbYIJOZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:25:18 -0400
Date: Wed, 10 Sep 2008 23:24:57 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080910135347.GI6329@amd.com>
References: <20080910131032.GH6329@amd.com>
	<20080910223735O.fujita.tomonori@lab.ntt.co.jp>
	<20080910135347.GI6329@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910232446O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 15:53:47 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 10, 2008 at 10:37:45PM +0900, FUJITA Tomonori wrote:
> > On Wed, 10 Sep 2008 15:10:32 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > Can't we simply make the gfp hacks depend on
> > > dma_ops->is_phys and avoid further gfp hacks in the hardware iommu
> > > implementations?
> > 
> > I thought about it but adding a new dma_ops->we_don't_want_gfp_flag
> > hook doesn't make the code simpler much. Currently, we have the gfp
> > setting hack in just one place. It's not bad. Adding such new hook
> > means adding more lines than we can remove.
> 
> The is_phys flas is already in place and its meaning is "the dma_ops
> return bus addresses equal to physical addresses". This is exactly the
> case when we need the gfp hacks. So I don't see a problem in just
> skipping the gfp rewrite if is_phys is zero. I don't see a point in
> adding gfp flags in dma_alloc_coherent and remove them again
> dma_ops->alloc_coherent code. Specially in this case where we already
> know in dma_alloc_coherent if we really need the flag rewrite.

dma_ops->is_phys doesn't work well for GART and Intel IOMMU, that do
virtual mappings for some devices and doesn't for some.

We need to a hook that can pass a point to a device to IOMMUs like:

dma_ops->is_phys(struct device *dev)


Because they need to look at a device to know if they will do virtual
mappings or not for it.
