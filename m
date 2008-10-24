Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYJXLLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYJXLLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYJXLLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:11:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:45618 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbYJXLLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:11:16 -0400
Date: Fri, 24 Oct 2008 20:10:09 +0900
To: mingo@elte.hu
Cc: dwmw2@infradead.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: Re: [GIT *] iommu fixes for 2.6.28
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081024110125.GA18869@elte.hu>
References: <1224616464.16910.103.camel@macbook.infradead.org>
	<20081024110125.GA18869@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024201041T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 13:01:25 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > This contains a few iommu-related fixes -- it restores DMA remapping 
> > on newer Intel hardware, which was disabled by the interrupt remapping 
> > patches, adds IA64 support for the Intel IOMMU, and some other small 
> > fixes.
> > 
> >  MAINTAINERS                      |    7 +
> >  arch/x86/kernel/amd_iommu_init.c |    2 +-
> >  arch/x86/kernel/pci-dma.c        |   16 ---
> >  drivers/pci/dmar.c               |  119 +++++++++++++-----
> >  drivers/pci/intel-iommu.c        |  250 ++++++++++++++++++++------------------
> >  drivers/pci/quirks.c             |   14 ++
> >  include/asm-x86/iommu.h          |    4 +
> >  include/linux/dma_remapping.h    |   27 ++--
> >  include/linux/intel-iommu.h      |   66 ++++++++---
> >  9 files changed, 305 insertions(+), 200 deletions(-)
> 
> hm, i just updated to v2.6.28-rc1, and these changes broke the x86 
> 32-bit build:
> 
>   arch/x86/kernel/built-in.o: In function `dma_supported':
>   (.text+0x5797): undefined reference to `forbid_dac'
>   arch/x86/kernel/built-in.o: In function `iommu_setup':
>   pci-dma.c:(.init.text+0x326c): undefined reference to `forbid_dac'
>   pci-dma.c:(.init.text+0x328b): undefined reference to `forbid_dac'
>   pci-dma.c:(.init.text+0x32aa): undefined reference to `forbid_dac'
> 
> seems to be caused by:
> 
>   5b6985c: intel-iommu: IA64 support

http://marc.info/?l=linux-kernel&m=122480590627590&w=2


Sharing forbid_dac between IA64 and X86 doesn't make sense and IA64
doesn't even use forbid_dac... Reverting the forbid_dac relocation is
the right fix, I think.
