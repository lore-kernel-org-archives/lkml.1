Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZH2Tjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZH2Tjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 15:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZH2Tjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 15:39:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZH2Tjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 15:39:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>, Len Brown <lenb@kernel.org>
Subject: Is acpi_ec_ecdt_probe() broken? (was: Re: ACPI locks hardware devices when it doesn't detect vista)
Date: Sat, 29 Aug 2009 21:40:06 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Mairo <rety@poczta.onet.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <1250945310.14167.150.camel@maxim-laptop> <1251503638.17451.14.camel@maxim-laptop>
In-Reply-To: <1251503638.17451.14.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908292140.06935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009, Maxim Levitsky wrote:
> On Sat, 2009-08-22 at 15:48 +0300, Maxim Levitsky wrote:
> > Hi,
> > 
> > <joke>
> > This should be brought to a Microsoft antitrust case...
> > </joke>
> > 
> > 
> > Today many notebooks ship with a embedded infrared receiver.
> > In Vista there is new subsystem that decodes these signals.
> > (of course it works only with Microsoft Certificated Remotes (TM)...)
> > 
> > The receiver is usually presented to system as a pnp device 
> > (using acpi tables)
> > 
> > It turns out that some bioses actually use the OSI, ACPI feature of the
> > operation system to detect if running inside Vista. If not they disable
> > the infrared receiver.
> > 
> >             Device (MIR)
> >             {
> >                 Name (_HID, EisaId ("ENE0100"))
> >                 Method (_STA, 0, NotSerialized)
> >                 {
> >                     If (LAnd (MCIR, LEqual (OSYS, 0x07D6)))
> >                     {
> >                         Return (0x0F)
> >                     }
> >                     Else
> >                     {
> >                         Store (Zero, ^^LPCB.IOR2)
> >                         Return (Zero)
> >                     }
> >                 }
> > 
> > 	.......
> > 
> 
> >     Scope (_SB)
> >     {
> >         Method (_INI, 0, NotSerialized)
> >         {
> 		....
> 
> >             If (CondRefOf (_OSI, Local0))
> >             {
> >                 If (_OSI ("Linux"))
> >                 {
> >                     Store (One, LINX)
> >                     Store (Zero, ECDY)
> >                 }
> 
>                   ..........
> > 
> 
> >                 If (_OSI ("Windows 2006"))
> >                 {
> >                     Store (0x07D6, OSYS)
> >                 }
>                   .......
> 
> 
> I have finally managed to find root case of this problem.
> 
> Indeed the _STA method of infrared receiver is called before the _INI of
> _SB.

This is a bug IMO.  Len, what do you think?

> The problem lies in acpi_bus_init()
> 	/*
> 	 * ACPI 2.0 requires the EC driver to be loaded and work before
> 	 * the EC device is found in the namespace (i.e. before acpi_initialize_objects()
> 	 * is called).
> 	 *
> 	 * This is accomplished by looking for the ECDT table, and getting
> 	 * the EC parameters out of that.
> 	 */
> 
> 	status = acpi_ec_ecdt_probe();
> 	/* Ignore result. Not having an ECDT is not fatal. */
> 
> 	status = acpi_initialize_objects(ACPI_FULL_INITIALIZATION);
> 	if (ACPI_FAILURE(status)) {
> 		printk(KERN_ERR PREFIX "Unable to initialize ACPI objects\n");
> 		goto error1;
> 	}
>         .......
> 
> 
> on Mairo's system (just as well as on mine) there is no ECDT.
> Thus, acpi_ec_ecdt_probe() triggers a acpi namespace walk, 
> which in turn triggers invocation on _STA (which is supposed to be
> harmless, but the <beep>, the bios developers produce doesn't seem to
> meet this criteria....).
> 
> And this is done before running _INI methods, which are run just later,
> in acpi_initialize_objects.
> 
> I suspect that many systems use _SB._INI to test the OS version, thus
> this behavior needs to be revised.
> 
> The fact that this (as usual) works in windows suggest that it might  be
> good to look up the ECDT table before acpi_initialize_objects, but if
> not found, look up the EC later.
> 
> On my system, although I have tried to reproduce this bug, I couldn't,
> and I know now why: It just so happens that on my system CIR device is
> listed in acpi tables after the EC, but on Mairo's system EC is just
> first device.
> 
> Maybe we can add a 'walk only' function, that walks the namespace, but
> doesn't touch the _STA, and use it to find the EC there?

To my eyes, this problem is a result of a workaround in acpi_ec_ecdt_probe(),
that according to the comment in there "is needed only on some broken machines
which require early EC, but fail to provide ECDT".

You probably wrote that in one of the previous messages, but is your machine an
ASUS one by chance?

Len, really, the things done by acpi_ec_ecdt_probe() in case ECDT is not found
don't look good to me at all.

Why do we run the workaround for everyone, not just for _the_ broken systems?

Moreover, why is "ASUS" hardcoded into the function as a known bad vendor
rather than put into a table?

Thanks,
Rafael
