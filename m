Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbZLNLCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbZLNLCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZLNLCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:02:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:33813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbZLNLCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:02:18 -0500
Message-ID: <4B261AC3.502@kernel.org>
Date: Mon, 14 Dec 2009 03:00:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Move swiotlb initialization before dma32_free_bootmem
References: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <tip-f4780ca005404166cc40af77ef0e86132ab98a81@git.kernel.org>
In-Reply-To: <tip-f4780ca005404166cc40af77ef0e86132ab98a81@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for FUJITA Tomonori wrote:
> Commit-ID:  f4780ca005404166cc40af77ef0e86132ab98a81
> Gitweb:     http://git.kernel.org/tip/f4780ca005404166cc40af77ef0e86132ab98a81
> Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> AuthorDate: Mon, 14 Dec 2009 11:52:14 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 14 Dec 2009 08:57:40 +0100
> 
> x86: Move swiotlb initialization before dma32_free_bootmem
> 
> The commit 75f1cdf1dda92cae037ec848ae63690d91913eac introduced a
> bug that we initialize SWIOTLB right after dma32_free_bootmem so
> we wrongly steal memory area allocated for GART with broken BIOS
> earlier.
> 
> This moves swiotlb initialization before dma32_free_bootmem().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: yinghai@kernel.org
> LKML-Reference: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/pci-dma.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index afcc58b..fcc2f2b 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -120,11 +120,14 @@ static void __init dma32_free_bootmem(void)
>  
>  void __init pci_iommu_alloc(void)
>  {
> +	int use_swiotlb;
> +
> +	use_swiotlb = pci_swiotlb_init();
>  #ifdef CONFIG_X86_64
>  	/* free the range so iommu could get some range less than 4G */
>  	dma32_free_bootmem();
>  #endif
> -	if (pci_swiotlb_init())
> +	if (use_swiotlb)
>  		return;
>  
>  	gart_iommu_hole_init();
> --

on one 1t socket system numa is enabled, got

[    0.000000] bootmem alloc of 67108864 bytes failed!
[    0.000000] Kernel panic - not syncing: Out of memory
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32-tip-yh-08635-g3614d3a-dirty #902
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cb3fec>] panic+0x7a/0x136
[    0.000000]  [<ffffffff81cb7819>] ? _raw_spin_unlock_irqrestore+0x3d/0x4c
[    0.000000]  [<ffffffff810a5866>] ? trace_hardirqs_off+0xd/0xf
[    0.000000]  [<ffffffff8273d055>] ___alloc_bootmem_node+0x0/0x61
[    0.000000]  [<ffffffff8273d1c1>] __alloc_bootmem_low+0xe/0x10
[    0.000000]  [<ffffffff82749b4b>] swiotlb_init_with_default_size+0x41/0x127
[    0.000000]  [<ffffffff82749c41>] swiotlb_init+0x10/0x12
[    0.000000]  [<ffffffff827326ef>] pci_swiotlb_init+0x52/0x67
[    0.000000]  [<ffffffff81cbfbfc>] ? _etext+0x0/0x24
[    0.000000]  [<ffffffff827276dd>] pci_iommu_alloc+0xc/0x6e
[    0.000000]  [<ffffffff81cbfbfc>] ? _etext+0x0/0x24
[    0.000000]  [<ffffffff82735037>] mem_init+0x19/0xec
[    0.000000]  [<ffffffff81caa52e>] ? x86_init_noop+0x9/0xb
[    0.000000]  [<ffffffff82720b1a>] start_kernel+0x13c/0x313
[    0.000000]  [<ffffffff82720295>] x86_64_start_reservations+0xa5/0xa9
[    0.000000]  [<ffffffff8272037a>] x86_64_start_kernel+0xe1/0xe8
[    0.000000] ------------[ cut here ]------------

