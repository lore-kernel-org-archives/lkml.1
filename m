Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYE2DPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYE2DPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYE2DO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:14:58 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63148 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752784AbYE2DO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:14:58 -0400
Date: Thu, 29 May 2008 04:13:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kevin Hao <kexin.hao@windriver.com>
cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
In-Reply-To: <1211971330.6085.33.camel@kevin-desktop>
Message-ID: <Pine.LNX.4.55.0805290348350.29522@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de>
 <1210929270.11912.3.camel@kevin-desktop>  <4831A678.5070208@ladisch.de>
 <1211274219.8718.7.camel@kevin-desktop>  <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
  <4833DD38.2010702@ladisch.de>  <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
  <1211441231.7323.10.camel@kevin-desktop>  <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
 <1211971330.6085.33.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Kevin Hao wrote:

> BTW, Maciej. I am not familiar with ACPI subsystem. But I think the 
> acpi_register_gsi should return -1 if mp_find_ioapic return error.
> Is that right? If you also think so, I will make a patch for that.

 Well, the interface is documented in the sources -- I do not feel like
reading through all the execution paths to see whether the implementation
matches though. ;)

 A few comments below -- I may not have time available to throw your piece 
of code at a piece of hardware though.

> +	/* we prefer level triggered mode */
> +	v = readl(&timer->hpet_config);
> +	if (!(v & Tn_INT_TYPE_CNF_MASK)) {
> +		v |= Tn_INT_TYPE_CNF_MASK;
> +		writel(v, &timer->hpet_config);
> +	}

 Please note that when routing through the 8259A you need to match the
trigger mode set for the respective input.  It is normally set in the ELCR
register in the hardware and should be recorded in the ACPI interrupt
source tables too -- the default for IRQ0-15 is edge-triggered, active
high, unless overridden.

> +	v = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK)
> +				 >> Tn_INT_ROUTE_CAP_SHIFT;

 The operator should be at the end of the first line IMHO.

> +	/*
> +	 * In PIC mode, skip IRQ0-4, IRQ6-8, IRQ12-15 which is always used by
> +	 * legacy device. In IO APIC mode, we skip all the legacy IRQS.
> +	 */

 Quite reasonable assumption IMO, but again -- I'd expect the information 
about legacy devices present on these lines to be recorded in ACPI tables.  
Note that IRQ9 is used for the SCI -- I am not sure if that's a good 
choice for sharing.

> +		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
> +					ACPI_ACTIVE_LOW);

 I am assuming you have verified ACPI_ACTIVE_LOW works here, contrary to 
the HPET spec.

> +	if  (irq < HPET_MAX_IRQ) {

 Single space here.

> @@ -37,6 +37,7 @@ struct hpet {
>  #define	hpet_compare	_u1._hpet_compare
>  
>  #define	HPET_MAX_TIMERS	(32)
> +#define HPET_MAX_IRQ	(32)

 Tab here for consistency with the others?

 Otherwise no obvious problems.

  Maciej
