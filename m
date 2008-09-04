Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYIDJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYIDJvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYIDJvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:51:06 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:44166 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbYIDJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:51:04 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6O0NO-03-E14-01
Date: Thu, 4 Sep 2008 11:49:33 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       tony.luck@intel.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures with swiotlb
Message-ID: <20080904094933.GR3189@amd.com>
References: <20080904074441.GY18288@one.firstfloor.org> <20080904165852I.fujita.tomonori@lab.ntt.co.jp> <20080904080528.GZ18288@one.firstfloor.org> <20080904171903M.fujita.tomonori@lab.ntt.co.jp> <20080904083124.GA18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080904083124.GA18288@one.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Sep 2008 09:49:34.0297 (UTC) FILETIME=[89385C90:01C90E73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 10:31:24AM +0200, Andi Kleen wrote:
> > Even if it's tree, only each IOMMU knows what's the best. That's the
> > point of these changes to remove the tricks in arch/x86/pci-dma.c and
> > let IOMMUs do what they want.
> 
> Duplicating all the code.  Sounds great.

Even greater is that hardware IOMMUs now don't pay the penalty of this
completly unnecessary alloc-free cycle in the generic dma_alloc_coherent
function and that now finally the driver specific free_coherent function
is called. And this all to the cost of minimal code duplication. If you
look into the patches you see that the old retry-loop is now in
pci-nommu.c where it belongs to. The GART also only needs small parts of
the old logic which are now in a specific alloc_coherent function for
this driver.
 
> > > Also there's usually the problem that not all busses are translated,
> > > e.g. Calgary used to do that so for e.g. dev == NULL allocations you had
> > > to use  these fallback algorithms anyways.
> > 
> > dev == NULL isn't a minor thing. It's just using the fallback
> > device.
> 
> You still have to handle it fully.

Thats why the handling of dev == NULL is still in the dma_alloc_coherent
function and should also stay there.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

