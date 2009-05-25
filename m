Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZEYCee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZEYCee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 22:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZEYCeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 22:34:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59197 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751335AbZEYCeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 22:34:24 -0400
Date: Sun, 24 May 2009 22:34:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Robert Hancock <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
In-Reply-To: <20090524161114.GA2667@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0905242226570.15195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 May 2009, [utf-8] Rogério Brito wrote:

> On May 24 2009, Alan Stern wrote:
> > It is abnormal, but I can't tell what the reason is without more
> > information.  You should try using usbmon (see
> > Documentation/usb/usbmon.txt) to trace these events.
> 
> Here you go with a log that is pure text (compressed). The part of dmesg
> relative to the USB plugging is here:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> [  248.286615] usb-storage: device found at 3
> [  248.286620] usb-storage: waiting for device to settle before scanning
> [  248.286631] usbcore: registered new interface driver usb-storage
> [  248.286636] USB Mass Storage support registered.
> [  248.351740] usb 4-2.2: New USB device found, idVendor=067b, idProduct=2316
> [  248.351749] usb 4-2.2: New USB device strings: Mfr=1, Product=5, SerialNumber=0
> [  248.351753] usb 4-2.2: Product: USB Security Device
> [  248.351756] usb 4-2.2: Manufacturer: Leading Driver Co.,LTD.
> [  248.351860] PM: Adding info for usb:4-2.2
> [  248.351907] usb 4-2.2: configuration #1 chosen from 1 choice
> [  248.354759] PM: Adding info for usb:4-2.2:1.0
> [  248.354894] PM: Adding info for No Bus:usbdev4.4_ep00
> [  253.288125] usb-storage: device scan complete
> [  253.291081] scsi 0:0:0:0: Direct-Access     Prolific USB Flash Disk   1.00 PQ: 0 ANSI: 0 CCS
> [  253.291476] PM: Adding info for scsi:target0:0:0
> [  253.291903] PM: Adding info for scsi:0:0:0:0
> [  253.292167] PM: Adding info for No Bus:0:0:0:0
> [  253.331140] Driver 'sd' needs updating - please use bus_type methods
> [  253.331290] PM: Adding info for No Bus:0:0:0:0
> [  253.337069] sd 0:0:0:0: [sda] 256000 512-byte hardware sectors: (131 MB/125 MiB)
> [  253.340068] sd 0:0:0:0: [sda] Write Protect is off
> [  253.340073] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
> [  253.340077] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [  253.340130] PM: Adding info for No Bus:sda
> [  253.347047] sd 0:0:0:0: ioctl_internal_command return code = 8000002
> [  253.347053]    : Sense Key : 0x0 [current] 
> [  253.347059]    : ASC=0x0 ASCQ=0x0

I see the problem.  It's a bug in the Prolific drive.  The drive says
that it has removable media, which is not true.  Then when the computer
tells the drive to lock the media in place, the drive reports an error.  
And it doesn't use the proper error code, so the computer doesn't
know what went wrong.

You can test this by setting a "quirks" option for usb-storage, to tell 
it that the Prolific drive does not understand the "Lock" command:

	modprobe usb-storage quirks=67b:2316:L

or

	echo 67b:2316:L >/sys/module/usb_storage/parameters/quirks

If that eliminates the errors, we can add a permanent quirk entry for 
this device.

Alan Stern

