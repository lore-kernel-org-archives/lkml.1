Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZLNLfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZLNLfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZLNLfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:35:10 -0500
Received: from sh.osrg.net ([192.16.179.4]:52042 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZLNLfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:35:08 -0500
Date: Mon, 14 Dec 2009 20:33:44 +0900
To: yinghai@kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Move swiotlb initialization before
 dma32_free_bootmem
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B261AC3.502@kernel.org>
References: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<tip-f4780ca005404166cc40af77ef0e86132ab98a81@git.kernel.org>
	<4B261AC3.502@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091214203333L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Dec 2009 20:33:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 03:00:19 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> tip-bot for FUJITA Tomonori wrote:
> > Commit-ID:  f4780ca005404166cc40af77ef0e86132ab98a81
> > Gitweb:     http://git.kernel.org/tip/f4780ca005404166cc40af77ef0e86132ab98a81
> > Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > AuthorDate: Mon, 14 Dec 2009 11:52:14 +0900
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 14 Dec 2009 08:57:40 +0100
> > 
> > x86: Move swiotlb initialization before dma32_free_bootmem
> > 
> > The commit 75f1cdf1dda92cae037ec848ae63690d91913eac introduced a
> > bug that we initialize SWIOTLB right after dma32_free_bootmem so
> > we wrongly steal memory area allocated for GART with broken BIOS
> > earlier.
> > 
> > This moves swiotlb initialization before dma32_free_bootmem().
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: yinghai@kernel.org
> > LKML-Reference: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/pci-dma.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index afcc58b..fcc2f2b 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -120,11 +120,14 @@ static void __init dma32_free_bootmem(void)
> >  
> >  void __init pci_iommu_alloc(void)
> >  {
> > +	int use_swiotlb;
> > +
> > +	use_swiotlb = pci_swiotlb_init();
> >  #ifdef CONFIG_X86_64
> >  	/* free the range so iommu could get some range less than 4G */
> >  	dma32_free_bootmem();
> >  #endif
> > -	if (pci_swiotlb_init())
> > +	if (use_swiotlb)
> >  		return;
> >  
> >  	gart_iommu_hole_init();
> > --
> 
> on one 1t socket system numa is enabled, got

Doh, sorry, seems that we have to go with the previous approach...

How much memory does your box? VMEMMAP enabled?

Can you please send the full boot log and your config?


Thanks,

> [    0.000000] bootmem alloc of 67108864 bytes failed!
> [    0.000000] Kernel panic - not syncing: Out of memory
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32-tip-yh-08635-g3614d3a-dirty #902
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff81cb3fec>] panic+0x7a/0x136
> [    0.000000]  [<ffffffff81cb7819>] ? _raw_spin_unlock_irqrestore+0x3d/0x4c
> [    0.000000]  [<ffffffff810a5866>] ? trace_hardirqs_off+0xd/0xf
> [    0.000000]  [<ffffffff8273d055>] ___alloc_bootmem_node+0x0/0x61
> [    0.000000]  [<ffffffff8273d1c1>] __alloc_bootmem_low+0xe/0x10
> [    0.000000]  [<ffffffff82749b4b>] swiotlb_init_with_default_size+0x41/0x127
> [    0.000000]  [<ffffffff82749c41>] swiotlb_init+0x10/0x12
> [    0.000000]  [<ffffffff827326ef>] pci_swiotlb_init+0x52/0x67
> [    0.000000]  [<ffffffff81cbfbfc>] ? _etext+0x0/0x24
> [    0.000000]  [<ffffffff827276dd>] pci_iommu_alloc+0xc/0x6e
> [    0.000000]  [<ffffffff81cbfbfc>] ? _etext+0x0/0x24
> [    0.000000]  [<ffffffff82735037>] mem_init+0x19/0xec
> [    0.000000]  [<ffffffff81caa52e>] ? x86_init_noop+0x9/0xb
> [    0.000000]  [<ffffffff82720b1a>] start_kernel+0x13c/0x313
> [    0.000000]  [<ffffffff82720295>] x86_64_start_reservations+0xa5/0xa9
> [    0.000000]  [<ffffffff8272037a>] x86_64_start_kernel+0xe1/0xe8
> [    0.000000] ------------[ cut here ]------------
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
