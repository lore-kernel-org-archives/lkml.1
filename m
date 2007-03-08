Return-Path: <linux-kernel-owner+w=401wt.eu-S1751280AbXCHC5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbXCHC5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbXCHC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:57:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45313 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXCHC5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:57:07 -0500
Date: Wed, 7 Mar 2007 18:53:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
Message-Id: <20070307185317.5601d452.akpm@linux-foundation.org>
In-Reply-To: <m1649cdfas.fsf@ebiederm.dsl.xmission.com>
References: <20070227103021.GA2250@kernel.dk>
	<20070227103407.GA17819@elte.hu>
	<20070227105922.GD2250@kernel.dk>
	<20070227111515.GA4271@kernel.dk>
	<20070301093450.GA8508@elte.hu>
	<20070302100704.GB2293@elf.ucw.cz>
	<20070305084257.GA4464@mellanox.co.il>
	<20070305101120.GA23032@elte.hu>
	<45ECFC5F.7000102@garzik.org>
	<45ED0BBF.1050000@intel.com>
	<20070306090444.GA25409@elte.hu>
	<45ED8A12.5040803@intel.com>
	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>
	<45EEE8CF.1060803@intel.com>
	<45EEEC2C.5090609@intel.com>
	<m1649cdfas.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 12:28:11 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Below is an additional set of warnings that should help debug this.
> The old code just got lucky that it triggered a warning when this happens.
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 01869b1..5113913 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -613,6 +613,7 @@ int pci_enable_msi(struct pci_dev* dev)
>  		return -EINVAL;
>  
>  	WARN_ON(!!dev->msi_enabled);
> +	WARN_ON(!hlist_empty(&dev->saved_cap_space));
>  
>  	/* Check whether driver already requested for MSI-X irqs */
>  	if (dev->msix_enabled) {
> @@ -638,6 +639,8 @@ void pci_disable_msi(struct pci_dev* dev)
>  	if (!dev->msi_enabled)
>  		return;
>  
> +	WARN_ON(!hlist_empty(&dev->saved_cap_space));
> +
>  	msi_set_enable(dev, 0);
>  	pci_intx(dev, 1);		/* enable intx */
>  	dev->msi_enabled = 0;
> @@ -739,6 +742,7 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
>  		}
>  	}
>  	WARN_ON(!!dev->msix_enabled);
> +	WARN_ON(!hlist_empty(&dev->saved_cap_space));
>  
>  	/* Check whether driver already requested for MSI irq */
>     	if (dev->msi_enabled) {
> @@ -763,6 +767,8 @@ void pci_disable_msix(struct pci_dev* dev)
>  	if (!dev->msix_enabled)
>  		return;
>  
> +	WARN_ON(!hlist_empty(&dev->saved_cap_space));
> +
>  	msix_set_enable(dev, 0);
>  	pci_intx(dev, 1);		/* enable intx */
>  	dev->msix_enabled = 0;
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index bd44a48..4418839 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -677,6 +677,7 @@ pci_restore_state(struct pci_dev *dev)
>  	}
>  	pci_restore_pcix_state(dev);
>  	pci_restore_msi_state(dev);
> +	WARN_ON(!hlist_empty(&dev->saved_cap_space));
>  
>  	return 0;
>  }

Got a hit on a powerpc g5:

PM: Writing back config space on device 0001:05:04.0 at offset 1 (was 2b00000, writing 2b00006)
------------[ cut here ]------------
Badness at drivers/pci/pci.c:679
Call Trace:
[C0000000080F7410] [C000000000011EFC] .show_stack+0x50/0x1cc (unreliable)
[C0000000080F74C0] [C0000000001AD610] .report_bug+0xa0/0x110
[C0000000080F7550] [C0000000000256E4] .program_check_exception+0xb4/0x670
[C0000000080F7630] [C0000000000046F4] program_check_common+0xf4/0x100
--- Exception: 700 at .pci_restore_state+0x310/0x340
    LR = .pci_restore_state+0x2e0/0x340
[C0000000080F79D0] [C00000000026A174] .tg3_chip_reset+0x19c/0xa04
[C0000000080F7A90] [C00000000026D948] .tg3_reset_hw+0xa4/0x2718
[C0000000080F7BA0] [C000000000270030] .tg3_init_hw+0x74/0x94
[C0000000080F7C30] [C000000000270BE0] .tg3_open+0x4c8/0x854
[C0000000080F7CF0] [C0000000003A74A4] .dev_open+0x100/0x12c
[C0000000080F7D90] [C0000000003BAEA8] .netpoll_setup+0x2dc/0x3ec
[C0000000080F7E40] [C000000000283450] .init_netconsole+0x64/0x8c
[C0000000080F7EC0] [C0000000005C0BE4] .init+0x1d0/0x390
[C0000000080F7F90] [C0000000000271F8] .kernel_thread+0x4c/0x68
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
Scheduler bitmap error - bitmap being reconstructed..
netconsole: network logging started
Calling initcall 0xc0000000006bd180: .macio_module_init+0x0/0x3c()

That's:

        pci_restore_pcix_state(dev);
        pci_restore_msi_state(dev);
        WARN_ON(!hlist_empty(&dev->saved_cap_space));

        return 0;

