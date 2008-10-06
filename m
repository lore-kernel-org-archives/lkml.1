Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYJFOz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYJFOz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYJFOzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:55:48 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24748 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYJFOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:55:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH 2/2]Add Variable Page Size and IA64 Support in Intel IOMMU: IA64 Specific Part
Date: Mon, 6 Oct 2008 08:55:35 -0600
User-Agent: KMail/1.9.9
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
References: <20081001165750.GA21272@linux-os.sc.intel.com> <200810030941.42800.bjorn.helgaas@hp.com> <A6AD88C3F2289247BE726C37303E1EB8844A6398@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8844A6398@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810060855.36880.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 06:53:04 pm Yu, Fenghua wrote:
> >> >This patch adds clflush_cache_range(), but it's not used anywhere.
> >> Clflush_cache_range() is used in __iommu_flush_cache() in include/linux/intel-iommu.h.
> 
> >Oh, OK.  I didn't look hard enough to find __iommu_flush_cache()
> > (currently in drivers/pci/intel-iommu.c).
> 
> >Architecturally, I'm surprised that ia64 would need to actually do a
> >cache flush.  I would think the VT-d hardware would do coherent accesses
> >which would make the cache flush unnecessary.
> 
> VT-d hardware supports both non cache coherency and cache coherency by bit Coherency in Extended Capabilities Register.
> 
> Could you please point me to the doc that explicitly says that architecturally ia64 doesn't need cache flush?

I don't know the details of VT-d, so I'm just asking the question.  I
do know the HP IOMMU does not require flushing because it participates
in the coherency domain, so I was just surprised to see this in Intel
chipset support.

The following sections in volume 2 of the SDM mention DMA:

Part 1, Sec 4.4.3, Cacheability and Coherency Attribute:

  The processor must ensure that transactions from other I/O agents
  (such as DMA) are physically coherent with the instruction and data
  cache.

Part 2, Sec 2.5.4, DMA:

  Unlike Programmed I/O, which requires intervention from the CPU
  to move data from the device to main memory, data movement in DMA
  occurs without help from the CPU.  A processor based on the Itanium
  architecture expects the platform to maintain coherency for DMA
  traffic.  That is, the platform issues snoop cycles on the bus to
  invalidate cacheable pages that a DMA access modifies.  These snoop
  cycles invalidate the appropriate lines in both instruction and
  data caches and thus maintain coherency. This behavior allows an
  operating system to page code pages without taking explicit actions
  to ensure coherency.

  Software must maintain coherency for DMA traffic through explicit
  action if the platform does not maintain coherency for this traffic.
  Software can provide coherency by using the flush cache instruction,
  fc, to invalidate the instruction and data cache lines that a DMA
  transfer modifies.

It sounds like the expectation is that DMA will be fully coherent
and no flushes would be required, but there is wiggle room in that
last paragraph for platforms that don't maintain coherency.

Bjorn
