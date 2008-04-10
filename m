Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYDJPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYDJPCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYDJPC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:02:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13275 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317AbYDJPCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:02:25 -0400
Date: Thu, 10 Apr 2008 08:01:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: debug Kconfig option (was Re: linux-next: Tree for April 9)
Message-Id: <20080410080137.76011235.randy.dunlap@oracle.com>
In-Reply-To: <tkrat.991b1750a56cf2e9@s5r6.in-berlin.de>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
	<47FCF50E.9090703@s5r6.in-berlin.de>
	<20080410065227.GB30066@elte.hu>
	<20080410174418.ebfe76c3.sfr@canb.auug.org.au>
	<tkrat.991b1750a56cf2e9@s5r6.in-berlin.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 09:52:25 +0200 (CEST) Stefan Richter wrote:

> On 10 Apr, Stephen Rothwell wrote:
> > On Thu, 10 Apr 2008 08:52:27 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> what type of conflict do you have there? If it's a new entry then you 
> >> might be able to fix it by moving the new entry elsewhere in the file. 
> >> Or if i introduced a new entry close to an existing entry you modify 
> >> then i could move my new entry elsewhere.
> > 
> > Commit 523a65f1a7a339e528ca6d6d808516fe195fde03 ("firewire: fw-ohci: add
> > option for remote debugging") in the ieee1394 tree adds a new entry just
> > where the sched tree adds
> > 
> > source kernel/trace/Kconfig
> > 
> 
> I grab this opportunity to ask the list:  Would you prefer the remote
> debugging option in the kernel hacking menu (as in the commit), or
> rather in the respective driver submenu?

I like it in the kernel hacking menu.

> For reference:
> 
> Date: Thu, 28 Feb 2008 20:54:43 +0100 (CET)
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: firewire: fw-ohci: add option for remote debugging
> 
> This way firewire-ohci can be used for remote debugging like ohci1394.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  Documentation/debugging-via-ohci1394.txt |   13 ++++++++-----
>  drivers/firewire/fw-ohci.c               |    9 +++++++++
>  lib/Kconfig.debug                        |   10 ++++++++++
>  3 files changed, 27 insertions(+), 5 deletions(-)
> 
> Index: linux/Documentation/debugging-via-ohci1394.txt
> ===================================================================
> --- linux.orig/Documentation/debugging-via-ohci1394.txt
> +++ linux/Documentation/debugging-via-ohci1394.txt
> @@ -41,11 +41,14 @@ to a working state and enables physical 
>  This can be turned off by ohci1394's module parameter phys_dma=0.
>  
>  The alternative firewire-ohci driver in drivers/firewire uses filtered physical
> -DMA, hence is not yet suitable for remote debugging.
> -
> -Because ohci1394 depends on the PCI enumeration to be completed, an
> -initialization routine which runs pretty early (long before console_init()
> -which makes the printk buffer appear on the console can be called) was written.
> +DMA by default, which is more secure but not suitable for remote debugging.
> +Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA to get unfiltered
> +physical DMA.
> +
> +Because ohci1394 and firewire-ohci depend on the PCI enumeration to be
> +completed, an initialization routine which runs pretty early has been
> +implemented for x86.  This routine runs long before console_init() can be
> +called, i.e. before the printk buffer appears on the console.
>  
>  To activate it, enable CONFIG_PROVIDE_OHCI1394_DMA_INIT (Kernel hacking menu:
>  Provide code for enabling DMA over FireWire early on boot) and pass the
> Index: linux/drivers/firewire/fw-ohci.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-ohci.c
> +++ linux/drivers/firewire/fw-ohci.c
> @@ -1097,6 +1097,11 @@ static void bus_reset_tasklet(unsigned l
>  		reg_write(ohci, OHCI1394_ConfigROMhdr, ohci->next_header);
>  	}
>  
> +#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
> +	reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
> +	reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
> +#endif
> +
>  	spin_unlock_irqrestore(&ohci->lock, flags);
>  
>  	if (free_rom)
> @@ -1435,6 +1440,9 @@ static int ohci_cancel_packet(struct fw_
>  static int
>  ohci_enable_phys_dma(struct fw_card *card, int node_id, int generation)
>  {
> +#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
> +	return 0;
> +#else
>  	struct fw_ohci *ohci = fw_ohci(card);
>  	unsigned long flags;
>  	int n, retval = 0;
> @@ -1466,6 +1474,7 @@ ohci_enable_phys_dma(struct fw_card *car
>   out:
>  	spin_unlock_irqrestore(&ohci->lock, flags);
>  	return retval;
> +#endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
>  }
>  
>  static u64
> Index: linux/lib/Kconfig.debug
> ===================================================================
> --- linux.orig/lib/Kconfig.debug
> +++ linux/lib/Kconfig.debug
> @@ -592,6 +592,16 @@ config LATENCYTOP
>  	  Enable this option if you want to use the LatencyTOP tool
>  	  to find out which userspace is blocking on what kernel operations.
>  
> +config FIREWIRE_OHCI_REMOTE_DMA
> +	bool "Remote debugging via firewire-ohci"
> +	depends on FIREWIRE_OHCI
> +	help
> +	  This option lets you use the FireWire bus for remote debugging.
> +	  It enables unfiltered remote DMA in the firewire-ohci driver.
> +	  See Documentation/debugging-via-ohci1394.txt for more information.
> +
> +	  If unsure, say N.
> +
>  config PROVIDE_OHCI1394_DMA_INIT
>  	bool "Provide code for enabling DMA over FireWire early on boot"
>  	depends on PCI && X86
> 
> -- 

---
~Randy
