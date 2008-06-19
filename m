Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYFSSEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYFSSEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYFSSEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:04:25 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:47882 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYFSSEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:04:24 -0400
Date: Thu, 19 Jun 2008 14:03:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: let MPS support selectable
In-reply-to: <86802c440806191039q5c6a2266p82d319a61a3bba3c@mail.gmail.com>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806191350530.3040@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200806181432.57204.yhlu.kernel@gmail.com>
 <200806181729.31464.yhlu.kernel@gmail.com>
 <200806190018.45944.yhlu.kernel@gmail.com>
 <Pine.LNX.4.55.0806191600290.12929@cliff.in.clinika.pl>
 <86802c440806191039q5c6a2266p82d319a61a3bba3c@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2008, Yinghai Lu wrote:

> On Thu, Jun 19, 2008 at 8:10 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> > On Thu, 19 Jun 2008, Yinghai Lu wrote:
> >
> >> @@ -233,6 +233,19 @@ config SMP
> >>
> >>         If you don't know what to do here, say N.
> >>
> >> +config X86_FIND_SMP_CONFIG
> >> +     def_bool y
> >> +     depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
> >> +     depends on X86_32
> >> +
> >> +config X86_MPPARSE
> >> +     def_bool y
> >> +     bool "Enable MPS table"
> >> +     depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
> >> +     help
> >> +       For old smp systems that do not have proper acpi support. Newer systems
> >> +       (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
> >> +
> >>  choice
> >>       prompt "Subarchitecture Type"
> >>       default X86_PC
> >
> >  First of all you want to make sure at least one of ACPI and X86_MPPARSE
> > is enabled if X86_LOCAL_APIC or you risk a known-broken kernel
> > configuration, e.g. SMP which has no slightest chance to work.
> >
> >  Personally I'd be happy to see CONFIG_ACPI_BOOT we used to have at one
> > point back just so that you can use ACPI tables to run an SMP system
> > without the need to pull all the power management stuff.  Useful if the MP
> > table is broken beyond recovery.  I am assuming it has been removed for a
> > reason though.
> 
> thanks. will try to add CONFIG_ACPI_BOOT...

NAK.

CONFIG_ACPI_BOOT was removed because it was fundamentally ill-conceived
and created a situation which was not only more difficult to maintain
but also didn't work on most machines.
ACPI interrupt configuration depends on the ACPI interpreter, so to boot
properly and configure interrupts with ACPI, you need 90% of the kernel's
ACPI code present anyway.
The other 10% are the Linux policy drivers, fan, processor, etc, and those
can be already be de-configured one by one if desired.

If you want to use ACPI just for enumerating processors, ie to see
the HT that MPS usually doesn't include, you can boot with "acpi=ht",
which will not enter ACPI mode or use ACPI for anything else.
We used to have a compile option for this, but most people who used
it did so by mistake and then complained that all sorts of things,
(starting with the power button) didn't work, so it was removed.

I don't think we should be going out of our way to enhance MPS support.
There probably isn't a single system shipped in this century that has MPS
that doesen't have ACPI, while there are millions of systems that
have ACPI and no MPS.  MPS is going away, and making
it a config option prepares us for the day when we completely
don't care about it any more.

However, I think that adding CONFIG_MPS before removing ACPI's
depencency on mpparse.c has all risk and no value.

thanks,
-Len



