Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbYESVXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbYESVXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbYESVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:23:15 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63559 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756963AbYESVXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:23:14 -0400
Date: Mon, 19 May 2008 22:21:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Kevin Hao <kexin.hao@windriver.com>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Get irq for hpet timer
In-Reply-To: <4831A678.5070208@ladisch.de>
Message-ID: <Pine.LNX.4.55.0805192156070.19879@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de>
 <1210929270.11912.3.camel@kevin-desktop> <4831A678.5070208@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Clemens Ladisch wrote:

> Another problem: the interrupt controller doesn't get correctly
> initialized for some interrupt line that didn't already have some
> routing:
> | $ cat /proc/interrupts
> |            CPU0
> |   0:         63   IO-APIC-edge      timer
> |   1:         96   IO-APIC-edge      i8042
> |   2:          0    XT-PIC-XT        hpet2
> |   6:          3   IO-APIC-edge      floppy
> |   7:          0   IO-APIC-edge      parport0
> |   8:          3   IO-APIC-edge      rtc
> |   9:          0   IO-APIC-fasteoi   acpi
> | ...

 IRQ2 cannot be wired to the legacy 8259A chips, because this line is
taken for the cascade from the slave to the master.  If you know for sure
that the HPET2 can be routed to the an otherwise unused input of the I/O
APIC, then you can use add_pin_to_irq() to route the entry manually.

> Additionally, I vaguely remember that on X86, there is some funny stuff
> going on with interrupt lines 0, 2 and 8 which means that the interrupt
> number passed to request_irq() is not necessarily identical to the
> hardware interrupt line.

 You are correct as far as input lines INT0 and INT2 of the I/O APIC are
concerned.  INT8 is not generally a problem except from some systems where
the polarity used to be recorded incorrectly in the BIOS tables (hardware
can be configured for either).  With INT0 and INT2 the following is
usually the case.

 INT0 is wired to the output of the master 8259A legacy controller.  It is
either configured as an ExtINTA interrupt or disabled by default
altogether (and the LINT0 input of the local APIC of the bootstrap
processor used instead).  Even if some additional logic is present in the
system so that another source can be routed to this line and the 8259A is
quiesced, sharing is probably impossible, because the output of the 8259A
is traditionally active high.

 INT2 is wired to the output of the 8254 timer (and in some more recent
systems shared with the HPET0).  This is the line that is referred to as
IRQ0 above.  This is because in an ACPI-based system the IRQ numbers refer
to lines as defined in ACPI tables, which may not necessarily identity-map
to I/O APIC input lines.

 Then the reasons for routing INT0 and INT2 like this are generally
historical and date back to the old Multi-Processor Specification.  There
may be systems that differ, but care must be taken and the correct
configuration table consulted.

  Maciej
