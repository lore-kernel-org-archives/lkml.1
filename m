Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZCRJjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZCRJjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZCRJjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:39:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbZCRJjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:39:21 -0400
Date: Wed, 18 Mar 2009 10:38:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
Message-ID: <20090318093847.GC5879@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317120112.GP6159@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Mon, Mar 16, 2009 at 06:05:27PM +0100, Joerg Roedel wrote:
> > Hi,
> > 
> > this small series of patches adds three additional checks to the dma-api
> > debugging code. The first one checks if dma mappings are requested for
> > kernel text or rodata segments.
> > The second check added makes noise if a device is unbound from its
> > driver and there are still pending dma allocations we are aware of.
> > 
> > Joerg
> > 
> > diffstat:
> > 
> >  arch/x86/kernel/pci-dma.c |    4 ++
> >  include/linux/dma-debug.h |    7 ++++
> >  lib/dma-debug.c           |   81 ++++++++++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 91 insertions(+), 1 deletions(-)
> 
> Ingo,
> 
> you can also pull these patches from my dma-api/debug branch at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-api/debug
> 
> including the other dma-debug patches relative to your tip/core/iommu
> branch.
> 
> The complete diffstat and shortlog against tip/core/iommu is here:
> 
>  Documentation/DMA-API.txt           |  106 ++++
>  Documentation/kernel-parameters.txt |   10 +
>  arch/Kconfig                        |    2 +
>  arch/x86/Kconfig                    |    1 +
>  arch/x86/include/asm/dma-mapping.h  |   45 ++-
>  arch/x86/kernel/pci-dma.c           |   10 +
>  include/linux/dma-debug.h           |  174 +++++++
>  lib/Kconfig.debug                   |   11 +
>  lib/Makefile                        |    2 +
>  lib/dma-debug.c                     |  949 +++++++++++++++++++++++++++++++++++
>  10 files changed, 1304 insertions(+), 6 deletions(-)

Pulled into tip:core/iommu and started testing it, thanks a lot 
Joerg!

btw., on latest Fedora rawhide a testbox of mine is getting this:

e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
------------[ cut here ]------------
WARNING: at lib/dma-debug.c:461 check_unmap+0xd4/0x3dd() (Not tainted)
Hardware name: 2241B48
e1000e 0000:00:19.0: DMA-API: device driver tries to free DMA memory 
it has not allocated [device address=0x0000000052ff084a] [size=90 bytes]
 [<ffffffff811a6fb0>] check_unmap+0xd4/0x3dd
 [<ffffffff811a7406>] debug_dma_unmap_page+0x50/0x52
 [<ffffffffa00f4523>] pci_unmap_page+0x4e/0x57 [e1000e]
 [<ffffffffa00f455a>] e1000_put_txbuf+0x2e/0x4f [e1000e]
 [<ffffffffa00f4681>] e1000_clean_tx_irq+0xc8/0x2c2 [e1000e]
 [<ffffffffa00f809b>] ? e1000_clean+0x6b/0x246 [e1000e]
 [<ffffffffa00f80a7>] e1000_clean+0x77/0x246 [e1000e]
 [<ffffffff812f89dd>] net_rx_action+0xb6/0x1ee
 [<ffffffff812f8acc>] ? net_rx_action+0x1a5/0x1ee
 [<ffffffff81051353>] __do_softirq+0x94/0x179
 [<ffffffff810127ac>] call_softirq+0x1c/0x30
 [<ffffffff8101393e>] do_softirq+0x52/0xb9
 [<ffffffff81050f76>] irq_exit+0x53/0x90
 [<ffffffff81013c57>] do_IRQ+0x12c/0x151
 [<ffffffff81011e93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff811fe088>] ? acpi_idle_enter_bm+0x287/0x2de
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811fe090>] ? acpi_idle_enter_bm+0x28f/0x2de
 [<ffffffff811fe088>] ? acpi_idle_enter_bm+0x287/0x2de
 [<ffffffff81399916>] ? __atomic_notifier_call_chain+0x0/0x86
 [<ffffffff812d62ad>] ? cpuidle_idle_call+0x8d/0xc4
 [<ffffffff810102c7>] ? cpu_idle+0x68/0xb3
 [<ffffffff81381817>] ? rest_init+0x6b/0x6d
---[ end trace b8ae2341b2e9bbc2 ]---

i have some vague memories of this being discussed somewhere - it 
got fixed in the driver, right? If yes, do you have an URL to that 
fix? (if it's not upstream yet i will pick it up into 
tip:out-of-tree to not have already-fixed warnings)

	Ingo
