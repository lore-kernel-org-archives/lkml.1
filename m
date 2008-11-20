Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYKTEZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYKTEZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYKTEZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:25:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:34201 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYKTEZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:25:45 -0500
Date: Thu, 20 Nov 2008 13:25:15 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081119092544.GD29705@8bytes.org>
References: <20081118154322.GX13394@amd.com>
	<20081119150504G.fujita.tomonori@lab.ntt.co.jp>
	<20081119092544.GD29705@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081120131951H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 10:25:44 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Nov 19, 2008 at 03:05:24PM +0900, FUJITA Tomonori wrote:
> > On Tue, 18 Nov 2008 16:43:22 +0100
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > Joerg Roedel (4):
> > >       AMD IOMMU: add parameter to disable device isolation
> > >       AMD IOMMU: enable device isolation per default
> > >       AMD IOMMU: fix fullflush comparison length
> > >       AMD IOMMU: check for next_bit also in unmapped area
> > > 
> > >  Documentation/kernel-parameters.txt |    4 +++-
> > >  arch/x86/kernel/amd_iommu.c         |    2 +-
> > >  arch/x86/kernel/amd_iommu_init.c    |    6 ++++--
> > >  3 files changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > As the most important change these patches enable device isolation per
> > > default. Tests have shown that there are drivers which have bugs and do
> > > double-freeing of DMA memory.
> > 
> > What drivers? We need to fix them if they are mainline drivers.
> 
> I found issues in network drivers only for now. The two drivers where I
> found issues are the in-kernel ixgbe driver (I see IO_PAGE_FAULTS
> there), the ixgbe version from the Intel website has a double-free bug
> when unloading the driver or changing the device mtu. The same problem
> was found with the Broadcom NetXtreme II driver.

I see, thanks. You already reported the bugs to netdev?


> > > This can lead to data corruption with a
> > > hardware IOMMU when multiple devices share the same protection domain.
> > > Therefore device isolation should be enabled by default.
> > 
> > Hmm, the change is just because of the bug workaround? If so, I'm not
> > sure it's a good idea. We need to fix the buggy drivers anyway. And
> > device isolation is not free; e.g. use more memory rather than sharing
> > a protection domain. I guess that more people prefer sharing a
> > protection domain by default. It had been the default option for AMD
> > IOMMU until you hit the bugs. IIRC, VT-d also shares a protection
> > domain by default. It would be nice to avoid surprising users if the
> > two virtualization IOMMUs works in the similar way.
> 
> We can't test all drivers for those bugs until 2.6.28 will be released.
> And these bugs can corrupt data, for example when a driver frees dma
> addresses allocated by another driver and these addresses are then
> reallocated.
> The only way to protect the drivers from each other is to isolate them
> in different protection domains. The AMD IOMMU driver prints a WARN_ON()
> if a driver frees dma addresses not yet mapped. This triggered with the
> bnx2 and the ixgbe driver.

It would be better to add such WARN_ON to VT-d. VT-d is everywhere
nowadays. I think that there are some developers who can test these
drivers with VT-d.


> And the data corruption is real, it eat the root-fs of my testbox one
> time.
> I agree that we need to fix the drivers. I plan to implement some debug
> code which allows driver developers to detect those bugs even if they
> have no IOMMU in the system.

It's not so hard to add such debug feature to swiotlb, I guess.
