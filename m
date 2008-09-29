Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYI2OMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYI2OMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYI2OMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:12:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:49159 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYI2OMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:12:12 -0400
Date: Mon, 29 Sep 2008 23:11:19 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080929085647.GB2190@elte.hu>
References: <20080927181855.GA11147@elte.hu>
	<20080928193436.GA8386@amd.com>
	<20080929085647.GB2190@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080929231116Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 10:56:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Sat, Sep 27, 2008 at 08:18:55PM +0200, Ingo Molnar wrote:
> > > 
> > > another thing:
> > > 
> > > How hard would it be to add an CONFIG_IOMMU_DEBUG option that forces as 
> > > many DMA requests to go via the IOMMU as possible?
> > > 
> > > This slows things down of course so it's only for debugging - but it 
> > > also makes sure that we utilize the IOMMU code to the maximum - which is 
> > > not normally the case.
> > > 
> > > Would be nice to have it .config driven (default-disabled), so that 
> > > -tip's randconfig testing can stumble upon it every now and then. I've 
> > > got GART test-systems - this way we could find certain types of IOMMU 
> > > breakages sooner.
> > 
> > For AMD IOMMU I disabled the round-robin allocator to stress-test the 
> > code. This means that the address allocation bitmap is always 
> > traversed from the first bit. In consequence the TLB flushing is 
> > stressed a lot (both in hardware and software) because the same DMA 
> > addresses are used again and again. For testing I hardcoded it into 
> > the driver but I can also make it depend on CONFIG_IOMMU_DEBUG.
> 
> yes - could you please make a new option for it, 
> CONFIG_IOMMU_DEBUG_FORCE=y or so - and cover all iommus that support it?

I'm not sure we are talking about the same thing. Surely, I and Joerg
are talking different things.

GART driver doesn't need to use the IOMMU hardware at all times. GART
does a virtual mapping only when necessary (a device needs to handle
an address that it can't access to). But as I wrote, if you use
iommu=force, GART driver always use the IOMMU hardware.


Other x86 IOMMU drivers always use the IOMMU hardware. Except for
Intel VT-D, they manage free virtual I/O space in the round-robin
manner with the bitmap algorithm to avoid frequent IOTLB flush. Joerg
said he tested AMD IOMMU driver with the round-robin manner disabled
so AMD IOMMU driver uses the same virtual I/O space with lots of IOTLB
flush.
