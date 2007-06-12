Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbXFLVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbXFLVz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXFLVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:55:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54838 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750864AbXFLVzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:55:11 -0400
Date: Tue, 12 Jun 2007 23:55:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070612215501.GE13747@elf.ucw.cz>
References: <200706071530.51552.jesse.barnes@intel.com> <20070612145007.GA5986@ucw.cz> <200706120829.21465.jesse.barnes@intel.com> <20070612213020.GA13747@elf.ucw.cz> <2c0942db0706121438y6d2d2bb5qbe11269691366d20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0706121438y6d2d2bb5qbe11269691366d20@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-06-12 14:38:28, Ray Lee wrote:
> On 6/12/07, Pavel Machek <pavel@ucw.cz> wrote:
> >> > > On some machines, buggy BIOSes don't properly setup WB MTRRs to
> >> > > cover all available RAM, meaning the last few megs (or even gigs)
> >> > > of memory will be marked uncached.  Since Linux tends to allocate
> >> > > from high memory addresses first, this causes the machine to be
> >> > > unusably slow as soon as the kernel starts really using memory
> >> > > (i.e. right around init time).
> >> > >
> >> > > + if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> >> > > +         printk(KERN_WARNING "***************\n");
> >> > > +         printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> >> > > +         printk(KERN_WARNING "**** MTRRs don't cover all of "
> >> > > +                "memory, trimmed %ld pages\n", end_pfn -
> >> > > +                (highest_addr >> PAGE_SHIFT));
> >> > > +         printk(KERN_WARNING "***************\n");
> >> > > +         end_pfn = highest_addr >> PAGE_SHIFT;
> >> >
> >> > Missing 4K of memory is not worth 4K of junk in syslog per boot. Can
> >> > you drop the stars and stop shouting?
> >>
> >> How missing about 1G of memory?  We already discussed this, and Andi and
> >> Venki felt that either a panic or a really obnoxious message was the
> >> way to go...
> >
> >Just use panic, then.
> >                                                                        Pavel,
> >        who still thinks anyone missing 1GB of ram will not miss
> >        friendly notice in dmesg, even if it goes without 20 stars.
> 
> Panicking when it's not necessary is anti-social. If the kernel can
> continue, then it should, unless it's a correctness issue that may
> cause data corruption. Given that the kernel can even work around the
> problem now, throwing a panic is even less warranted.

Printk("*********************** WARNING")

is anti-social, too.

Here's what my dmesg looks. Lots of uninteresting, unneccessary crap.

Instead of removing some of that crap, this patch starts "I'm more
important than you" wars, trying to get attetion with stars. How do
you like dump below?

Come on, we have printk loglevels. They are meant for getting
attetion. Shouting printk with ton of stars is not.

								Pavel

Linux version 2.6.22-rc4 (pavel@amd) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #440 SMP Sat Jun 9 15:25:43 CEST 2007
...
DMI present.
ACPI: RSDP 000F6880, 0024 (r2 LENOVO)
ACPI: XSDT 7F6E6621, 0074 (r1 LENOVO TP-7B        1060  LTP        0)
ACPI: FACP 7F6E6700, 00F4 (r3 LENOVO TP-7B        1060 LNVO        1)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!ACPI WARNING (TBFADT-0434): OPTIONAL FIELD
!!!!!!!!!!!!!!!!!!"GPE1BLOCK" HAS ZERO ADDRESS OR LENGTH: 000000000000102C/0 [20070126]
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ACPI: DSDT 7F6E68E7, C463 (r1 LENOVO TP-7B        1060 MSFT  100000E)
ACPI: FACS 7F6F4000, 0040
ACPI: SSDT 7F6E68B4, 0033 (r1 LENOVO TP-7B        1060 MSFT  100000E)
ACPI: ECDT 7F6F2D4A, 0052 (r1 LENOVO TP-7B        1060 LNVO        1)
ACPI: TCPA 7F6F2D9C, 0032 (r2 LENOVO TP-7B        1060 LNVO        1)
ACPI: APIC 7F6F2DCE, 0068 (r1 LENOVO TP-7B        1060 LNVO        1)
ACPI: MCFG 7F6F2E36, 003E (r1 LENOVO TP-7B        1060 LNVO        1)
ACPI: HPET 7F6F2E74, 0038 (r1 LENOVO TP-7B        1060 LNVO        1)
ACPI: BOOT 7F6F2FD8, 0028 (r1 LENOVO TP-7B        1060  LTP        1)
ACPI: SSDT 7F6E5BDC, 0507 (r1 LENOVO TP-7B        1060 INTL 20050513)
ACPI: SSDT 7F6E5A04, 01D8 (r1 LENOVO TP-7B        1060 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
////////////////////////////////////////////////////////////////////
/////////////////////////////ACPI: IRQ0 used by override.
///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
/////////////////////////////ACPI: IRQ2 used by override.
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
/////////////////////////////ACPI: IRQ9 used by override.
////////////////////////////////////////////////////////////////////
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
Built 1 zonelists.  Total pages: 517875
Kernel command line: root=/dev/sda4 resume=/dev/sda1
psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps
vga=791 init=/tmp/swsusp-init
************ Unknown boot option `psmouse.psmouse_proto=imps': ignoring
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
....
Total of 2 processors activated (7318.93 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
************
*
*
*
*           Measured 627605 cycles TSC warp between CPUs, turning off TSC clock.
*
*
*
*
*
**********************
##########################################################################
##### Marking TSC unstable due to: check_tsc_sync_source failed. ########
########################################################################
Brought up 2 CPUs
migration_cost=10000

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
