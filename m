Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZEKI3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZEKI3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZEKI3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:29:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbZEKI3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:29:42 -0400
Date: Mon, 11 May 2009 10:28:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 5/7] x86/pci: add 4 more return param in
	IO_APIC_get_PCI_irq_vector
Message-ID: <20090511082834.GD5636@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01C406.2040303@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> +int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
> +				int *ioapic, int *ioapic_pin,
> +				int *trigger, int *polarity)

>  		if (io_apic_assign_pci_irqs) {
>  			int irq;
> +			int ioapic = -1, ioapic_pin = -1;
> +			int triggering, polarity;

please put this into a helper function/inline.

>  
> -			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number, PCI_SLOT(dev->devfn), pin - 1);
> +			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
> +						PCI_SLOT(dev->devfn),
> +						pin - 1,
> +						&ioapic, &ioapic_pin,
> +						&triggering, &polarity);
>  			/*
>  			 * Busses behind bridges are typically not listed in the MP-table.
>  			 * In this case we have to look up the IRQ based on the parent bus,
> @@ -1235,7 +1248,10 @@ static int pirq_enable_irq(struct pci_de
>  
>  				pin = pci_swizzle_interrupt_pin(dev, pin);
>  				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
> -						PCI_SLOT(bridge->devfn), pin - 1);
> +						PCI_SLOT(bridge->devfn),
> +						pin - 1,
> +						&ioapic, &ioapic_pin,
> +						&triggering, &polarity);
>  				if (irq >= 0)
>  					dev_warn(&dev->dev, "using bridge %s "
>  						 "INT %c to get IRQ %d\n",

That function has way too many parameters. Please introduce a helper 
structure (struct io_apic_irq_attr) where the parameters can be 
passed along in a clean and short fashion. We update them by 
reference anyway.

I've applied the patch, but we need these cleanups too, the code has 
become too ugly.

	Ingo
