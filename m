Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZBTTPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZBTTPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBTTPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:15:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145AbZBTTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:15:38 -0500
Date: Fri, 20 Feb 2009 14:15:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mike Lampard <mike@mtgambier.net>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: long-term regression with some usb mass storage devices
In-Reply-To: <200902210212.04737.mike@mtgambier.net>
Message-ID: <Pine.LNX.4.44L0.0902201153430.4145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009, Mike Lampard wrote:

> > If this affected your device then the device must not report residues
> > correctly.  If you provide the device's entry in /proc/bus/usb/devices,
> > I'll write a patch adding a blacklist entry for it.
> 
> Many thanks.
> 
> > It would help if you could also provide a usbmon trace showing what
> > happens when you plug the drive in.  Instructions are in the kernel
> > source file Documentation/usb/usbmon.txt.
> 
> /proc/bus/usb/devices: 
> T:  Bus=01 Lev=01 Prnt=01 Port=06 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=05e3 ProdID=0701 Rev= 0.02
> S:  Manufacturer=Genesyslogic
> S:  Product=USB Mass Storage Device
> C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr= 96mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

Ah, more fun from our friends at Genesys Logic.  :-(

> I'll email the usbmod log directly, to save spamming the list with a 100kb 
> attachment.

This seems to be the critical part:

ffff88002ad42300 1207042173 S Bo:1:009:2 -115 31 = 55534243 08000000 80000000 80000a5a 002a0000 00000080 00000000 000000
ffff88002ad42300 1207042287 C Bo:1:009:2 0 31 >
ffff88001dc5e780 1207042452 S Bi:1:009:1 -115 128 <
ffff88001dc5e780 1207046917 C Bi:1:009:1 -121 72 = 00467000 00000000 2a3e3f17 f1632923 1b900100 07d01b90 00001089 10890001
ffff88002ad42300 1207048482 S Bi:1:009:1 -115 13 <
ffff88002ad42300 1207048917 C Bi:1:009:1 -32 0
ffff88002ad42300 1207049111 S Co:1:009:0 s 02 01 0000 0081 0000 0
ffff88002ad42300 1207050037 C Co:1:009:0 0 0
ffff88002ad42300 1207050269 S Bi:1:009:1 -115 13 <
ffff88002ad42300 1207050910 C Bi:1:009:1 0 13 = 55534253 08000000 80000000 00

This shows the computer sending a MODE SENSE command for page 0x2a (the
MultiMedia Capabilities and Mechanical Status page), asking for 128
bytes of information.  The drive sent back 72 bytes followed by a
residue of 128, indicating that none of the data was valid.

Presumably the data really was valid and the residue should have been
56.  On the other hand, we have never had any other reports of invalid
residues from a Genesys Logic controller.  Maybe the error actually
came from the attached Pioneer drive instead of the controller; there's
no way to tell unless you attach a different kind of drive to the 
controller.

Anyway, this patch may fix the problem.  Let me know what happens with
it.  I'm a little hesitant to add it to the kernel, because of the
significant probability that the Genesys Logic controller itself is
okay.

Starting with 2.6.29 you'll be able to add special flags like this at 
runtime without the need for any patches, by means of a module 
parameter for usb-storage.

Alan Stern



Index: usb-2.6/drivers/usb/storage/unusual_devs.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
+++ usb-2.6/drivers/usb/storage/unusual_devs.h
@@ -802,13 +802,13 @@ UNUSUAL_DEV(  0x05e3, 0x0701, 0x0000, 0x
 		"Genesys Logic",
 		"USB to IDE Optical",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 ),
+		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 | US_FL_IGNORE_RESIDUE ),
 
 UNUSUAL_DEV(  0x05e3, 0x0702, 0x0000, 0xffff,
 		"Genesys Logic",
 		"USB to IDE Disk",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 ),
+		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 | US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Ben Efros <ben@pc-doctor.com> */
 UNUSUAL_DEV(  0x05e3, 0x0723, 0x9451, 0x9451,

