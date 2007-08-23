Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbXHWN3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbXHWN3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761269AbXHWN3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:29:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45466 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761276AbXHWN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:29:03 -0400
Date: Thu, 23 Aug 2007 22:27:45 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Cc: "Luck, Tony" <tony.luck@intel.com>, Jeremy Higdon <jeremy@sgi.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-ia64@vger.kernel.org
In-Reply-To: <20070823091556.GA18456@skynet.ie>
References: <617E1C2C70743745A92448908E030B2A023B2FD5@scsmsx411.amr.corp.intel.com> <20070823091556.GA18456@skynet.ie>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070823221005.0D76.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On (22/08/07 16:27), Luck, Tony didst pronounce:
> > > The more ioc's you have, the more space you will use.
> > 
> > Default SW IOTLB allocation is 64MB ... how much should we see
> > used per ioc?
> > 
> > Kamelesh: You could try increasing the amount of sw iotlb space
> > available by booting with a swiotlb=131072 argument (argument
> > value is the number of 2K slabs to allocate ... 131072 would
> > give you four times as much space as the default allocation).
> > 
> 
> I tried that value and just in case swiotlb=262144. An IA-64 machines I
> have here fails with the same message anyway. i.e.
> 
> [   19.834906] mptbase: Initiating ioc1 bringup
> [   20.317152] ioc1: LSI53C1030 C0: Capabilities={Initiator}
> [   15.474303] scsi1 : ioc1: LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=222, IRQ=72
> [   20.669730] GSI 142 (level, low) -> CPU 5 (0x1200) vector 73
> [   20.675602] ACPI: PCI Interrupt 0000:41:03.0[A] -> GSI 142 (level, low) -> IRQ 73
> [   20.683508] mptbase: Initiating ioc2 bringup
> [   21.166796] ioc2: LSI53C1030 C0: Capabilities={Initiator}
> [   21.180539] DMA: Out of SW-IOMMU space for 263200 bytes at device ?
> [   21.187018] Kernel panic - not syncing: DMA: Memory would be corrupted

I saw same trouble on my box, and I chased what was wrong.
Here is today's progress of mine.

__get_free_pages() of swiotlb_alloc_coherent() fails in rc3-mm1.
(See following patch)
But, it doesn't fail on rc2-mm2, and kernel can boot up.

Hmmm....


(2.6.23-rc3-mm1)
---
swiotlb_alloc_coherent flags=21 order=3 ret=0000000000000000
DMA: Out of SW-IOMMU space for 266368 bytes at device ?
Kernel panic - not syncing: DMA: Memory would be corrupted
---




(2.6.23-rc2-mm2)
---
swiotlb_alloc_coherent flags=21 order=3 ret=e000000020080000
           :
       (boot up continue...)

---
 lib/swiotlb.c |    2 ++
 1 file changed, 2 insertions(+)

Index: current/lib/swiotlb.c
===================================================================
--- current.orig/lib/swiotlb.c	2007-08-23 22:27:01.000000000 +0900
+++ current/lib/swiotlb.c	2007-08-23 22:29:49.000000000 +0900
@@ -455,6 +455,8 @@ swiotlb_alloc_coherent(struct device *hw
 	flags |= GFP_DMA;
 
 	ret = (void *)__get_free_pages(flags, order);
+
+	printk("%s flags=%0x order=%d ret=%p\n",__func__, flags, order, ret);
 	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
 		/*
 		 * The allocated memory isn't reachable by the device.


-- 
Yasunori Goto 


