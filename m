Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbZH2AlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbZH2AlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 20:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZH2Ak7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 20:40:59 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34929 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZH2Ak5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 20:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BJ/nWu3pX/Qnb4+6uTBkoFLj/49jpwAZm/pejFrl1Tyse+y6BcGvU4T97kl1gLAMAJ
         obPAP/ht5XBHyljAP/+Oi8i8qrVrz82cuk5XwEPS/3u18dh6eNlgAg2nHgkacJ461mfV
         Smu6bbY6TkXhIK3PmBw1s0iR5MtL4V9EhnqPk=
Subject: Re: ACPI locks hardware devices when it doesn't detect vista
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Mairo <rety@poczta.onet.pl>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <1251503638.17451.14.camel@maxim-laptop>
References: <1250945310.14167.150.camel@maxim-laptop>
	 <1251503638.17451.14.camel@maxim-laptop>
Content-Type: text/plain
Date: Sat, 29 Aug 2009 03:40:53 +0300
Message-Id: <1251506453.28828.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and cc linux-acpi....

On Sat, 2009-08-29 at 02:53 +0300, Maxim Levitsky wrote:
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
> 
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
> 
> Looking for comments,
> 	Best regards,
> 		Maxim Levitsky
> 

