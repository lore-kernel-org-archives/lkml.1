Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbZHVPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbZHVPi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbZHVPi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 11:38:27 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34900 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbZHVPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 11:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G5hkpTC7nkoUG3/It1jrjuxXd71YbaAt95G5oXAqEmv9FF3s6q0cvt5m4MTWCREWZe
         WLwCY/d0F8Mp1xT+YlqIpS16PNcmV3GKIDAeLU7r6ygJG0yg1zHbBZxNUgru3d6lHGQ5
         yQ3l43fqpXeQhjETkmvVM6fCO6AzWg6braXIA=
Subject: Re: ACPI locks hardware devices when it doesn't detect vista
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mario <rety@poczta.onet.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200908221710.33961.rety@poczta.onet.pl>
References: <1250945310.14167.150.camel@maxim-laptop>
	 <200908221710.33961.rety@poczta.onet.pl>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 18:38:22 +0300
Message-Id: <1250955502.10739.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-22 at 17:10 +0200, Mario wrote:
> Hi,
> 
> I tried to start the system with aspi=off, but as I thought system won't
You mean acpi=off ?
>  
> start. It hangs at the same beginning. Probably because RTC and other stuff 
> normaly controled by acpi stops working.
Not RTC, but there are plenty of things that can go wrong with acpi=off
Thanks for testing.
 

Best regards,
	Maxim Levitsky
> 
> Kind Regards 
> Mario
> 
> Saturday 22 of August 2009 14:48:30 Maxim Levitsky wrote:
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
> > On my system this it is still tolerable:
> >
> >             Device (MIR)
> >             {
> >                 Name (_HID, EisaId ("ENE0100"))
> >                 Method (_STA, 0, NotSerialized)
> >                 {
> >                     If (LGreaterEqual (OSYS, 0x07D6))
> >                     {
> >                         If (LOr (And (OTHR, 0x02), And (OTHR, 0x40)))
> >                         {
> >                             Return (0x00)
> >                         }
> >                         Else
> >                         {
> >                             Return (0x0F)
> >                         }
> >                     }
> >                     Else
> >                     {
> >                         Return (0x00)
> >                     }
> >                 }
> >
> > But not so, on Mairo's system:
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
> >     Method (_WAK, 1, NotSerialized)
> >     {
> >     .......
> >         If (Not (LAnd (MCIR, LEqual (OSYS, 0x07D6))))
> >         {
> >             Store (Zero, \_SB.PCI0.LPCB.IOR2)
> >         }
> >
> >
> > .....
> >
> >     Scope (_SB)
> >     {
> >         Method (_INI, 0, NotSerialized)
> >         {
> >             If (DTSE)
> >             {
> >                 TRAP (0x47)
> >             }
> >
> >             Store (0x07D0, OSYS)
> >             If (CondRefOf (_OSI, Local0))
> >             {
> >                 If (_OSI ("Linux"))
> >                 {
> >                     Store (One, LINX)
> >                     Store (Zero, ECDY)
> >                 }
> >
> >                 If (_OSI ("Windows 2001"))
> >                 {
> >                     Store (0x07D1, OSYS)
> >                 }
> >
> >                 If (_OSI ("Windows 2001 SP1"))
> >                 {
> >                     Store (0x07D1, OSYS)
> >                 }
> >
> >                 If (_OSI ("Windows 2001 SP2"))
> >                 {
> >                     Store (0x07D2, OSYS)
> >                 }
> >
> >                 If (_OSI ("Windows 2006"))
> >                 {
> >                     Store (0x07D6, OSYS)
> >                 }
> >
> >                 If (LEqual (TPMV, One))
> >                 {
> >                     If (LLessEqual (OSYS, 0x07D2))
> >                     {
> >                         TRAP (0x49)
> >                     }
> >                 }
> >             }
> >
> >             If (LAnd (MPEN, LEqual (OSYS, 0x07D1)))
> >             {
> >                 TRAP (0x3D)
> >             }
> >
> >             TRAP (0x2B)
> >         }
> >     }
> >
> > We have tried to boot the system with acpi_osi="Windows 2006", but it
> > didn't help (kernel log confirmed that this parameter was set)
> >
> > The only explanation I think of is ether his laptop is whitelisted on
> > osi=Linux, or that _SB._INI is called by linux _after_ MIR._STA
> > or that acpi_osi isn't yet in charge when _SB._INI is called.
> >
> >
> > The kernel in question is quite recent kernel, (2.6.30.5 from debian
> > unstable).
> >
> >
> > The only way I managed to 'enable' this device is to
> > do 'sudo setpci -s 00:1f.0 0x88.W=0x701'
> >
> > Or in other words undo the damage done by these ACPI commands.
> >
> > Mairo, can you boot the system with acpi=off, and then poke the cir IO
> > range (0x700-0x703) ?
> >
> >
> >
> > Best regards,
> > 	Maxim Levitsky
> 
> 

