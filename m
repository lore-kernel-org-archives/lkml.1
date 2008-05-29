Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYE2Oep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYE2Oep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYE2Oef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:34:35 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64312 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751352AbYE2Oee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:34:34 -0400
Date: Thu, 29 May 2008 15:32:42 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kevin Hao <kexin.hao@windriver.com>
cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
In-Reply-To: <1212057664.8343.29.camel@kevin-desktop>
Message-ID: <Pine.LNX.4.55.0805291319250.8254@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de>
 <1210929270.11912.3.camel@kevin-desktop>  <4831A678.5070208@ladisch.de>
 <1211274219.8718.7.camel@kevin-desktop>  <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
  <4833DD38.2010702@ladisch.de>  <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
  <1211441231.7323.10.camel@kevin-desktop>  <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
  <1211971330.6085.33.camel@kevin-desktop>  <Pine.LNX.4.55.0805290348350.29522@cliff.in.clinika.pl>
 <1212057664.8343.29.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Kevin Hao wrote:

> The IRQ trigger mode is set to level by acpi_register_gsi in PIC mode.
> And I have tested it on a host using legacy PIC. It works well.

 It may work by chance.  All what the code in question guarantees is:

int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
{
	*irq = gsi;
	return 0;
}

int acpi_register_gsi(u32 gsi, int triggering, int polarity)
{
	unsigned int irq;
	unsigned int plat_gsi = gsi;

	acpi_gsi_to_irq(plat_gsi, &irq);
	return irq;
}

CONFIG_PCI is optional for the x86 platform.  You could argue this is a
bug in acpi_register_gsi() and I tend to agree -- I think the existence of
the ELCR is implied for ACPI-compliant systems, though I am happy to be
corrected.  The ACPI spec does not mention the register, but quotes:  
"Existing industry standard register interfaces to: CMOS, PIC, PITs, ..."

 Anyway, blindly attaching to an IRQ line is not a terribly good idea as
there may be an edge-triggered line from a device wired there after all.  
For example many LPC SuperIO chips have configurable IRQ resources -- the
parallel port can use either IRQ5 or IRQ7 (but not both at a time).  OTOH
IRQ6 may be free after all as floppy drives become rare.  Only IRQ10 and
IRQ11 are probably safe to be assumed free in systems with no ISA slots,
but then again, I may have missed something.  Hopefully there are no true
PCI-ISA bridges with the HPET implemented -- I have checked a couple of 
datasheets for ACPI-compliant PCI-ISA bridges (such as the PIIX4) that I 
have handy and none of them implements the HPET.

> >  I am assuming you have verified ACPI_ACTIVE_LOW works here, contrary to 
> > the HPET spec.
> 
> Yes, It can work with other PCI device in ACPI_ACTIVE_LOW polarity.

 Good to know.  Thanks for verifying this.

  Maciej
