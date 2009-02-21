Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZBUGne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZBUGne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 01:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZBUGnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 01:43:24 -0500
Received: from hosted02.westnet.com.au ([203.10.1.213]:56996 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZBUGnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 01:43:22 -0500
From: Mike Lampard <mike@mtgambier.net>
Reply-To: mike@mtgambier.net
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: long-term regression with some usb mass storage devices
Date: Sat, 21 Feb 2009 17:13:15 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.28.3-desktop-1mnb; KDE/4.2.0; x86_64; ; )
Cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0902201153430.4145-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902201153430.4145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902211713.16201.mike@mtgambier.net>
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 05:45:36 am Alan Stern wrote:
> On Sat, 21 Feb 2009, Mike Lampard wrote:
> > > If this affected your device then the device must not report residues
> > > correctly.  If you provide the device's entry in /proc/bus/usb/devices,
> > > I'll write a patch adding a blacklist entry for it.
> >
> > Many thanks.
> >
> > > It would help if you could also provide a usbmon trace showing what
> > > happens when you plug the drive in.  Instructions are in the kernel
> > > source file Documentation/usb/usbmon.txt.
> >
> > /proc/bus/usb/devices:
> > T:  Bus=01 Lev=01 Prnt=01 Port=06 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
> > D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > P:  Vendor=05e3 ProdID=0701 Rev= 0.02
> > S:  Manufacturer=Genesyslogic
> > S:  Product=USB Mass Storage Device
> > C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr= 96mA
> > I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> > E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
>
> Ah, more fun from our friends at Genesys Logic.  :-(
>
> > I'll email the usbmod log directly, to save spamming the list with a
> > 100kb attachment.
>
> This seems to be the critical part:
>
> ffff88002ad42300 1207042173 S Bo:1:009:2 -115 31 = 55534243 08000000
> 80000000 80000a5a 002a0000 00000080 00000000 000000 ffff88002ad42300
> 1207042287 C Bo:1:009:2 0 31 >
> ffff88001dc5e780 1207042452 S Bi:1:009:1 -115 128 <
> ffff88001dc5e780 1207046917 C Bi:1:009:1 -121 72 = 00467000 00000000
> 2a3e3f17 f1632923 1b900100 07d01b90 00001089 10890001 ffff88002ad42300
> 1207048482 S Bi:1:009:1 -115 13 <
> ffff88002ad42300 1207048917 C Bi:1:009:1 -32 0
> ffff88002ad42300 1207049111 S Co:1:009:0 s 02 01 0000 0081 0000 0
> ffff88002ad42300 1207050037 C Co:1:009:0 0 0
> ffff88002ad42300 1207050269 S Bi:1:009:1 -115 13 <
> ffff88002ad42300 1207050910 C Bi:1:009:1 0 13 = 55534253 08000000 80000000
> 00
>
> This shows the computer sending a MODE SENSE command for page 0x2a (the
> MultiMedia Capabilities and Mechanical Status page), asking for 128
> bytes of information.  The drive sent back 72 bytes followed by a
> residue of 128, indicating that none of the data was valid.
>
> Presumably the data really was valid and the residue should have been
> 56.  On the other hand, we have never had any other reports of invalid
> residues from a Genesys Logic controller.  Maybe the error actually
> came from the attached Pioneer drive instead of the controller; there's
> no way to tell unless you attach a different kind of drive to the
> controller.

I've now tested two other DVD writers in this adapter without the patch - one 
LG and the other a much newer Pioneer.  Both exhibit the identical symptoms.

> Anyway, this patch may fix the problem.  Let me know what happens with
> it.  I'm a little hesitant to add it to the kernel, because of the
> significant probability that the Genesys Logic controller itself is
> okay.

The patch worked flawlessly with all devices I tested it on.  I also tested a 
HDD in the cradle to ensure there were no obvious regressions in that regard, 
it too worked as it should.

> Starting with 2.6.29 you'll be able to add special flags like this at
> runtime without the need for any patches, by means of a module
> parameter for usb-storage.

If you do decide to commit the change to the kernel, any chance you could mark 
it for the stable releases?

Cheers
Mike

