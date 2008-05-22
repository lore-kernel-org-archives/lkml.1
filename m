Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbYEVDtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbYEVDtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbYEVDtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:49:23 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63046 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757696AbYEVDtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:49:22 -0400
Date: Thu, 22 May 2008 04:47:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Kevin Hao <kexin.hao@windriver.com>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
In-Reply-To: <4833DD38.2010702@ladisch.de>
Message-ID: <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de>
 <1210929270.11912.3.camel@kevin-desktop>  <4831A678.5070208@ladisch.de>
 <1211274219.8718.7.camel@kevin-desktop> <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
 <4833DD38.2010702@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Clemens Ladisch wrote:

> >  Hmm, you probably want to skip all lines that are edge-triggered.
> > Otherwise you may have problems with sharing.
> 
> HPET interrupts can be either edge or level triggered.  Probably we
> should modify it according to the type of the interrupt line we're
> trying to grab.

 Edge-triggered lines are generally associated with legacy devices.  It
may not be possible to grab one without disturbing the other device.

> >  This driver is quite platform-specific -- how about instead of blindly
> > probing for interrupt lines, you actually allocate one somehow in platform
> > code?
> 
> I don't have much of a clue about that "somehow", but this sound like a
> good idea.  ;-)
> 
> I think hpet_reserve_platform_timers() might be the place for this.
> 
> It gets called from hpet_late_init(), which is a fs_initcall, so I think
> we should be careful not to grab some unsharable interrupt that might be
> needed by some ISA device whose driver is initialized later.
> (This was a bug in 2.6.25-rc5: <http://bugzilla.kernel.org/show_bug.cgi?id=10382>)

 I have had a look at the relevant areas of ACPI and HPET specs and it
looks pretty straightforward, although not all the information is recorded
in system tables.  Essentially you are free to choose an arbitrary
interrupt supported by the HPET -- which you can find in the timer's
routing capability (as the proposed patch is doing).

 However you are right you really want to select one which does not
conflict with a legacy device, so it's probably best to avoid the legacy
range altogether (worth noting as for example the system I have handy has
the capability of its timer #2 set to 0x00f00800 -- here IRQ11 may not be
safe to use) and then you have to check how many inputs beyond the legacy
range are supported by the I/O APICs in the system -- you can have a look
at mp_find_ioapic() to see how obtain that information and then you can
call mp_register_gsi() on the interrupt line selected like this to set up
routing in the I/O APIC as necessary.  Level-triggered mode has to be used
as the resulting interrupt entry may happen to be shared with a PCI
interrupt.

 Though I have just noticed there is something wrong with the spec -- it
says that "The interrupts are all active high." which precludes sharing,
hmm... -- broken spec?  If hardware designers actually followed it in this
respect (I wouldn't be surprised as for some of them software is abstract
enough a concept not to be bothered with, and then it is a spec after
all), then I am afraid we need to have a way to get an exclusive
reservation of an I/O APIC line.  It could be tough with a system using
fixed routing and reusing a legacy IRQ might be the only choice -- if
supported by the HPET router, that is.

 Of course if the HPET supports MSI delivery and the kernel configuration
has it enabled, then you can avoid all the hassle with finding an
available IRQ line altogether.

  Maciej
