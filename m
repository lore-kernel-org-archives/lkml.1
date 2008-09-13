Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYIMSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYIMSs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 14:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYIMSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 14:48:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:39283 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYIMSsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 14:48:21 -0400
Date: Sun, 14 Sep 2008 03:47:06 +0900
To: daniel.blueman@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, jens.axboe@oracle.com, tony.luck@intel.com,
       akpm@linux-foundation.org
Subject: Re: [2.6.27-rc6, patch] fix SWIOTLB oops...
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <6278d2220809131053p303e839dy5521d5975523fea8@mail.gmail.com>
References: <6278d2220809101307h798bb921m3b471f29ce8150ad@mail.gmail.com>
	<20080911222838V.fujita.tomonori@lab.ntt.co.jp>
	<6278d2220809131053p303e839dy5521d5975523fea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080914034719Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 18:53:13 +0100
"Daniel J Blueman" <daniel.blueman@gmail.com> wrote:

> >> Fix back-off path when memory allocation fails
> >> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> >>
> >> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> >> index 977edbd..8826fdf 100644
> >> --- a/lib/swiotlb.c
> >> +++ b/lib/swiotlb.c
> >> @@ -491,7 +491,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> >>                * the lowest available address range.
> >>                */
> >>               dma_addr_t handle;
> >> -             handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
> >> +             handle = swiotlb_map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
> >
> > I think that it's better to use map_single instead of
> > swiotlb_map_single since we always need swiotlb memory here.
> >
> > http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/0043.html
> 
> Thanks Fujita; this looks a better way of doing this. I've tested the
> three patches you posted and they address the original issue I bumped
> into, so seem an appropriate fix for -rc7. Not sure if preceding
> comments need tweaking though.
> 
> Our work isn't done yet though, since we see unexpected page state [5]
> on the release path. Calling the appropriate IOMMU/SWIOTLB release
> function [6] corrects this. Verified on x86-64 Intel system with
> SWIOTLB in use due to large memory; without this, processes end up
> hosed, so I'd say it's -rc7 material.

Are you sure your patch doesn't break other x86 IOMMU implementations
(note that this patch affects all the IOMMUs)?

x86 IOMMU coherent code has been broken for a long time. The coherent
code was completely rewritten for 2.6.28 to fix all the issues.

git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git

I think it's too late to try to fix v2.6.27.
