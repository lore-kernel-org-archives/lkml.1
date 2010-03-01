Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0CAS7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:59:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34925 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0CAS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:59:49 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, garyhade@us.ibm.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com, iranna.ankad@in.ibm.com,
       suresh.b.siddha@intel.com, trenn@suse.de
Subject: Re: [PATCH -v12 2/2] x86: fix out of order of gsi - full
References: <4B882182.4030205@kernel.org>
	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>
	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>
	<4B8995FB.9000908@kernel.org> <m1mxyue31g.fsf@fess.ebiederm.org>
	<4B89E751.1060903@kernel.org> <20100228080941.GD14205@elte.hu>
	<4B8A3270.2000007@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Mar 2010 10:59:37 -0800
In-Reply-To: <4B8A3270.2000007@kernel.org> (Yinghai Lu's message of "Sun\, 28 Feb 2010 01\:08\:00 -0800")
Message-ID: <m1ljeb50me.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> Iranna D Ankad reported that IBM x3950 systems have boot problems
> after this commit:
>
>  |
>  | commit b9c61b70075c87a8612624736faf4a2de5b1ed30
>  |
>  |    x86/pci: update pirq_enable_irq() to setup io apic routing
>  |
>
>     As explained in the previous patch ("x86: Fix out of order gsi - partial)
>     try to remap those gsis
>
>     This patch adds boot_ioapic_idx and gsi_to_irq/irq_to_gsi


A couple of nits, that we will eventually want to fix.

> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -97,6 +97,41 @@ int mp_irq_entries;
>  /* GSI interrupts */
>  static int nr_irqs_gsi = NR_IRQS_LEGACY;
>  
> +/* By default isa irqs are identity mapped to gsis */
> +unsigned int isa_irq_to_gsi[NR_IRQS_LEGACY] = {
> +	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
> +};
> +
> +static int boot_ioapic_idx;
> +static int gsi_delta;
> +int gsi_to_irq(unsigned int gsi)
> +{
> +	unsigned int irq = gsi;
> +	unsigned int i;
> +
> +	irq += gsi_delta;
> +	for (i = 0; i < NR_IRQS_LEGACY; i++) {
> +		if (isa_irq_to_gsi[i] == gsi) {
> +			irq = i;
> +			break;
> +		}
> +	}
> +
> +	return irq;
> +}
> +
> +unsigned int irq_to_gsi(int irq)
> +{
> +	unsigned int gsi;
> +
> +	if (irq < NR_IRQS_LEGACY)
> +		gsi = isa_irq_to_gsi[irq];
> +	else
> +		gsi = irq - gsi_delta;
> +
> +	return gsi;
> +}

This should really live in arch/x86/kernel/acpi/boot.c or similar as
it has everything to do with acpi and gsis and nothing to do with the
ioapics.

Not this merge window, but ultimately we want a fixed value of 16 for
gsi_delta, and we want to always use it.  This has a greater chance of
breaking things but it will ensure in the long run that we flush out
every place that actually needs translation from irqs to gsis.

> Index: linux-2.6/drivers/pnp/pnpacpi/rsparser.c
> ===================================================================
> --- linux-2.6.orig/drivers/pnp/pnpacpi/rsparser.c
> +++ linux-2.6/drivers/pnp/pnpacpi/rsparser.c
> @@ -123,6 +123,14 @@ static void pnpacpi_parse_allocated_irqr
>  	}
>  
>  	flags = irq_flags(triggering, polarity, shareable);
> +#ifdef CONFIG_X86_IO_APIC
> +	/*
> +	 * looks like IBM x3950 is using irq instead of gsi etc...
> +	 * convert it back at first
> +	 */
> +	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
> +		gsi = irq_to_gsi(gsi);
> +#endif

I would like to understand this better.  I suspect the actual problem
is that we are getting passed bus_irq instead of gsi from acpi.  If we
are getting passed the bus_irq than doing this just for x3950 is wrong.

I really dislike having special cases for a specific motherboard.  Both
because they are hard to maintain (as quickly no one has that board) and
because may times they are a symptom of a bug elsewhere in the code
that we are trying to patch over instead of actually fix properly.

>  	irq = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
>  	if (irq >= 0)
>  		pcibios_penalize_isa_irq(irq, 1);

Eric
