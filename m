Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYKGDuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYKGDuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 22:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYKGDuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 22:50:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:56621 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYKGDuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:50:39 -0500
Date: Fri, 7 Nov 2008 12:49:54 +0900
To: shehjart@cse.unsw.edu.au
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49125F21.8010806@cse.unsw.edu.au>
References: <490F880E.4000801@cse.unsw.edu.au>
	<20081106032605J.fujita.tomonori@lab.ntt.co.jp>
	<49125F21.8010806@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081107125011M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 14:06:09 +1100
Shehjar Tikoo <shehjart@cse.unsw.edu.au> wrote:

> FUJITA Tomonori wrote:
> > Sorry for the delay.
> > 
> > CC'ed linux-parisc since the same problem could happen to parisc.
> > 
> > On Tue, 04 Nov 2008 10:23:58 +1100
> > Shehjar Tikoo <shehjart@cse.unsw.edu.au> wrote:
> > 
> >> I've been observing kernel panics for the past week on
> >> kernel versions 2.6.26, 2.6.27 but not on 2.6.24 and 2.6.25.
> >>
> >> The panic message says:
> >>
> >> arch/ia64/hp/common/sba_iommu.c: I/O MMU is out of mapping resources
> >>
> >> Using git-bisect, I've zeroed in on the commit that introduced this.
> >> Please see the attached file for the commit.
> >>
> >> The workload consists of 2 tests:
> >> 1. Single fio process writing a 1 TB file.
> >> 2. 15 fio processes writing 15GB files each.
> >>
> >> The panic happens on both workloads. There is no stack trace after
> >> the above message.
> >>
> >> Other info:
> >> System is HP RX6600(16Gb RAM, 16 processors w/ dual cores and HT)
> >> 20 SATA disks under software RAID0 with 6 TB capacity.
> >> Silicon Image 3124 controller.
> >> File system is XFS.
> >>
> >> I'd much appreciate some help in fixing this because this panic has
> >> basically stalled my own work. I'd be willing to run more tests on my
> >> setup to test any patches that possibly fix this issue.
> > 
> > This patch modified the sba IOMMU driver to support LLDs' segment
> > boundary limits properly.
> > 
> > ATA hardware has poor segment boundary limit, 64KB. In addition, sba
> > IOMMU driver uses size-aligned allocation algorithm. It means that
> > it's difficult for the IOMMU driver to find an appropriate I/O address
> > space. I think that you hit the allocation failure due to this problem
> > (of course, it's possible that my change breaks the IOMMU driver but I
> > can't find a problem so far).
> > 
> > To make matters worse, sba IOMMU driver panic when the allocation
> > fails. IIRC, only IA64 and parisc IOMMU drivers panic by default in
> > the case of the allocation failure. I think that we need to change
> > them to handle the failure properly.
> > 
> > Can you try this? I've not fixed map_single failure yet but I think
> > that you hit the failure allocation in map_sg path.
> > 
> 
> On 2.6.27, this patch seems to prevent the panic from happening for
> both the tests I had described earlier.

Thanks!

> Do you need more info to 
> validate this? I will be running more tests with this patch over
> the next few days, so we'll find out anyway.

Can you check if data corruption doesn't happen during the tests?


Tony, changing the sba IOMMU driver to return an error instead of
panic in the case of allocation failure is fine with you?
