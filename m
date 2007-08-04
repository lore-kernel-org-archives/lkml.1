Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbXHDFZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbXHDFZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 01:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXHDFZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 01:25:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbXHDFZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 01:25:45 -0400
Date: Fri, 3 Aug 2007 22:25:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>,
       Murillo Fernandes Bernardes <bernarde@br.ibm.com>
Subject: Re: [PATCH x86-64] Calgary - Fix mis-handled PCI topology
Message-Id: <20070803222510.fe3156cf.akpm@linux-foundation.org>
In-Reply-To: <20070802133926.GI25771@rhun.ibm.com>
References: <20070802133926.GI25771@rhun.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 16:39:26 +0300 Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> Andrew, can you please push this Calgary bug-fix to 2.6.23 in your
> next merge? it fixes a showstopper bug in the recently merged CalIOC2
> support that hits machines with multiple levels of PCI-to-PCI bridges.
> 
> Thanks,
> Muli
> ---
> From: Murillo Fernandes Bernardes <bernarde@br.ibm.com>
> Subject: x86-64: Calgary - Fix mis-handled PCI topology
> 
> Current code assumed that devices were directly connected to a Calgary
> bridge, as it tried to get the iommu table directly from the parent bus 
> controller.
> 
> When we have another bridge between the Calgary/CalIOC2 bridge and the 
> device we should look upwards until we get to the top (Calgary/CalIOC2 
> bridge), where the iommu table resides.
> 
> Signed-off-by: Murillo Fernandes Bernardes <mfb@br.ibm.com>
> Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> --
> diff -ruN linux-2.6.23-rc1.orig/arch/x86_64/kernel/pci-calgary.c linux-2.6.23-rc1/arch/x86_64/kernel/pci-calgary.c
> --- linux-2.6.23-rc1.orig/arch/x86_64/kernel/pci-calgary.c	2007-08-01 15:37:04.000000000 -0300
> +++ linux-2.6.23-rc1/arch/x86_64/kernel/pci-calgary.c	2007-08-01 15:48:55.000000000 -0300
> @@ -367,16 +367,15 @@
>  
>  	pdev = to_pci_dev(dev);
>  
> -	/* is the device behind a bridge? */
> -	if (unlikely(pdev->bus->parent))
> -		pbus = pdev->bus->parent;
> -	else
> -		pbus = pdev->bus;
> +	pbus = pdev->bus;
> +
> +	/* is the device behind a bridge? Look for the root bus */
> +	while (pbus->parent)
> +		pbus = pbus->parent;
>  
>  	tbl = pci_iommu(pbus);
>  
> -	BUG_ON(pdev->bus->parent &&
> -	       (tbl->it_busno != pdev->bus->parent->number));
> +	BUG_ON(tbl && (tbl->it_busno != pbus->number));
>  
>  	return tbl;
>  }
> 

hmm, sorry, I missed the this-is-urgent factor.

Andi, should I include this in my next batch to Linus?

btw, my list of "patches which should be in 2.6.23 but go via subsystem
maintainers" is presently

dma_free_coherent-needs-irqs-enabled-sigh.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
tpmdd-maintainers.patch
nfs-fix-put_nfs_open_context.patch
make-oprofile-call-shutdown-only-once-per-session.patch
perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
kernel-auditscc-fix-an-off-by-one.patch
document-linux-memory-policy-v3.patch
futex_unlock_pi-hurts-my-brain-and-may-cause.patch
block-hide-the-contents-of-linux-bioh-if-config_block=n.patch
cdc-acm-fix-sysfs-attribute-registration-bug.patch
rtc-periodic-irq-fix.patch
at91-include-atmel_lcdch-in-at91sam92613_devicesc.patch
fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case.patch
calgary-fix-mis-handled-pci-topology.patch

several of which are x86-related.  Please consider...

