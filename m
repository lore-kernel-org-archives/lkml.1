Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYKSJZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYKSJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYKSJZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:25:51 -0500
Received: from 8bytes.org ([88.198.83.132]:40295 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYKSJZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:25:49 -0500
Date: Wed, 19 Nov 2008 10:25:44 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081119092544.GD29705@8bytes.org>
References: <20081118154322.GX13394@amd.com> <20081119150504G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119150504G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 03:05:24PM +0900, FUJITA Tomonori wrote:
> On Tue, 18 Nov 2008 16:43:22 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Joerg Roedel (4):
> >       AMD IOMMU: add parameter to disable device isolation
> >       AMD IOMMU: enable device isolation per default
> >       AMD IOMMU: fix fullflush comparison length
> >       AMD IOMMU: check for next_bit also in unmapped area
> > 
> >  Documentation/kernel-parameters.txt |    4 +++-
> >  arch/x86/kernel/amd_iommu.c         |    2 +-
> >  arch/x86/kernel/amd_iommu_init.c    |    6 ++++--
> >  3 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > As the most important change these patches enable device isolation per
> > default. Tests have shown that there are drivers which have bugs and do
> > double-freeing of DMA memory.
> 
> What drivers? We need to fix them if they are mainline drivers.

I found issues in network drivers only for now. The two drivers where I
found issues are the in-kernel ixgbe driver (I see IO_PAGE_FAULTS
there), the ixgbe version from the Intel website has a double-free bug
when unloading the driver or changing the device mtu. The same problem
was found with the Broadcom NetXtreme II driver.

> > This can lead to data corruption with a
> > hardware IOMMU when multiple devices share the same protection domain.
> > Therefore device isolation should be enabled by default.
> 
> Hmm, the change is just because of the bug workaround? If so, I'm not
> sure it's a good idea. We need to fix the buggy drivers anyway. And
> device isolation is not free; e.g. use more memory rather than sharing
> a protection domain. I guess that more people prefer sharing a
> protection domain by default. It had been the default option for AMD
> IOMMU until you hit the bugs. IIRC, VT-d also shares a protection
> domain by default. It would be nice to avoid surprising users if the
> two virtualization IOMMUs works in the similar way.

We can't test all drivers for those bugs until 2.6.28 will be released.
And these bugs can corrupt data, for example when a driver frees dma
addresses allocated by another driver and these addresses are then
reallocated.
The only way to protect the drivers from each other is to isolate them
in different protection domains. The AMD IOMMU driver prints a WARN_ON()
if a driver frees dma addresses not yet mapped. This triggered with the
bnx2 and the ixgbe driver.
And the data corruption is real, it eat the root-fs of my testbox one
time.
I agree that we need to fix the drivers. I plan to implement some debug
code which allows driver developers to detect those bugs even if they
have no IOMMU in the system.

Joerg

