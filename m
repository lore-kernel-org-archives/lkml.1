Return-Path: <linux-kernel-owner+w=401wt.eu-S1765475AbXHDSQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765475AbXHDSQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764989AbXHDSQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:16:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761630AbXHDSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:16:27 -0400
Date: Sat, 4 Aug 2007 11:15:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: Oops in 2.6.23-rc1-git9,
 arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-Id: <20070804111532.1d3936fa.akpm@linux-foundation.org>
In-Reply-To: <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
References: <46B3A7BB.9000102@redhat.com>
	<20070803155035.1fb11c9a.akpm@linux-foundation.org>
	<200708041130.42038.ak@suse.de>
	<20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	<86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 10:45:31 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> Andrew,
> 
> still need
> x86_64-get-mp_bus_to_node-as-early-v2.patch in the -mm
> it fix

What does it fix?  Much more detail, please.

> diff -puN arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v2
> arch/i386/pci/irq.c
> --- a/arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v2
> +++ a/arch/i386/pci/irq.c
> @@ -136,10 +136,26 @@ static void __init pirq_peer_trick(void)
>                busmap[e->bus] = 1;
>        }
>        for(i = 1; i < 256; i++) {
> +               struct pci_bus *bus = NULL;
> +               struct pci_sysdata *sd;
>                if (!busmap[i] || pci_find_bus(0, i))
>                        continue;
> -               if (pci_scan_bus(i, &pci_root_ops, NULL))
> +               /* Allocate per-root-bus (not per bus) arch-specific data.
> +                * TODO: leak; this memory is never freed.
> +                * It's arguable whether it's worth the trouble to care.
> +                */
> +               sd = kzalloc(sizeof(*sd), GFP_KERNEL);
> +               if (!sd) {
> +                       printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n",
> +                               i);
> +                       continue;
> +               }
> +               sd->node = get_mp_bus_to_node(i);
> +               bus = pci_scan_bus(i, &pci_root_ops, sd);
> +               if (bus)
>                        printk(KERN_INFO "PCI: Discovered primary peer
> bus %02x [IRQ]\n", i);

Wordwrapped, tabs replaced with spaces.

Please, for once and for all, fix your email client?

Thanks.

