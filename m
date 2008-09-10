Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbYIJNyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbYIJNyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYIJNyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:54:00 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59743 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYIJNx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:53:59 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6ZFXL-04-BGY-01
Date: Wed, 10 Sep 2008 15:53:47 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910135347.GI6329@amd.com>
References: <20080910124822.GG6329@amd.com> <20080910220323D.fujita.tomonori@lab.ntt.co.jp> <20080910131032.GH6329@amd.com> <20080910223735O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080910223735O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 13:53:47.0207 (UTC) FILETIME=[A5837D70:01C9134C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 10:37:45PM +0900, FUJITA Tomonori wrote:
> On Wed, 10 Sep 2008 15:10:32 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Can't we simply make the gfp hacks depend on
> > dma_ops->is_phys and avoid further gfp hacks in the hardware iommu
> > implementations?
> 
> I thought about it but adding a new dma_ops->we_don't_want_gfp_flag
> hook doesn't make the code simpler much. Currently, we have the gfp
> setting hack in just one place. It's not bad. Adding such new hook
> means adding more lines than we can remove.

The is_phys flas is already in place and its meaning is "the dma_ops
return bus addresses equal to physical addresses". This is exactly the
case when we need the gfp hacks. So I don't see a problem in just
skipping the gfp rewrite if is_phys is zero. I don't see a point in
adding gfp flags in dma_alloc_coherent and remove them again
dma_ops->alloc_coherent code. Specially in this case where we already
know in dma_alloc_coherent if we really need the flag rewrite.

> Yeah, I was against your patch to adding the gfp setting hack to
> swiotlb but it's because gfp is kinda architecture specific stuff and
> swiotlb should not. It's the bad design IMO. It's ok for me that
> architecture specific IOMMUs can do the architecture specific stuff
> (and it's about just clearing the gfp flag).

The generic swiotlb code already contained a gfp hack for IA64 and I
added another one for x86 which is ok in my opinion. But the #ifdef was
ugly, I agree with that now :-)
Your solution of removing the flag hacks from the generic code completly
was the other possible way.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

