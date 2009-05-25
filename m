Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZEYUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZEYUiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEYUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:37:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58149 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751793AbZEYUh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:37:57 -0400
Date: Mon, 25 May 2009 16:37:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
In-Reply-To: <20090525184816.GB6649@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0905251621320.26833-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009, Michael S. Tsirkin wrote:

> On Mon, May 25, 2009 at 11:32:31AM -0400, Alan Stern wrote:
> > On Mon, 25 May 2009, OGAWA Hirofumi wrote:
> > 
> > > "Michael S. Tsirkin" <mst@redhat.com> writes:
> > > 
> > > > An attempt to mount it under linux 2.6.30-rc7 results in these messages:
> > > >
> > > > usb 1-3: new high speed USB device using ehci_hcd and address 7
> > > > usb 1-3: New USB device found, idVendor=090c, idProduct=6000
> > > > usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > > > usb 1-3: Product: USB2.0 Card Reader  
> > > > usb 1-3: Manufacturer: Generic       ,   . 
> > > > usb 1-3: SerialNumber: 0000001       
> > > > usb 1-3: configuration #1 chosen from 1 choice
> > > > Initializing USB Mass Storage driver...
> > > > scsi2 : SCSI emulation for USB Mass Storage devices
> > > > usbcore: registered new interface driver usb-storage
> > > > USB Mass Storage support registered.
> > > > usb-storage: device found at 7
> > > > usb-storage: waiting for device to settle before scanning
> > > > usb-storage: device scan complete
> > > > scsi 2:0:0:0: Direct-Access     Generic                   6000 PQ: 0 ANSI: 0 CCS
> > > > sd 2:0:0:0: Attached scsi generic sg2 type 0
> > > > sd 2:0:0:0: [sdb] 990976 512-byte hardware sectors: (507 MB/483 MiB)
> > > > sd 2:0:0:0: [sdb] Write Protect is off
> > > > sd 2:0:0:0: [sdb] Mode Sense: 4b 00 00 08
> > > > sd 2:0:0:0: [sdb] Assuming drive cache: write through
> > > > sd 2:0:0:0: [sdb] Assuming drive cache: write through
> > > >  sdb:<6>sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > > > sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current] 
> > > > sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
> > > > end_request: I/O error, dev sdb, sector 0
> > > > Buffer I/O error on device sdb, logical block 0
> > > > Dev sdb: unable to read RDB block 0
> > > >  unable to read partition table
> > > > sd 2:0:0:0: [sdb] Attached SCSI removable disk
> > > > usb 1-3: USB disconnect, address 7
> > > >
> > > > parted seems to display both partitions just fine,
> > > > and that other OS does not seem to have any trouble
> > > > accessing the disk.
> > > >
> > > > The message 'unable to read RDB block' seems to come from
> > > > fs/partitions/amiga.c which looks pretty weird.
> > > >
> > > > Any idea what info would be helpful in debugging this?
> > > > Just to clarify, this is not a regression - older linux versions
> > > > as far back as 2.6.24 seem to behave the same way.
> > > 
> > > It seems I/O error happened while checking the partition types (sector 0).
> > > I guess usb people may have knowledge of this. CC to linux-usb.
> > 
> > It's hard to imagine why a device would claim that sector 0 was out of 
> > range!
> > 
> > Try collecting a usbmon trace of these events (instructions in 
> > Documentation/usb/usbmon.txt).
> > 
> > Alan Stern
> 
> Here comes:
> 
> lsusb output:
> Bus 001 Device 006: ID 090c:6000 Feiya Technology Corp. 
> Bus 001 Device 001: ID 1d6b:0002  
> Bus 005 Device 003: ID 10d5:55a4 Uni Class Technology Co., Ltd 
> Bus 005 Device 002: ID 058f:9254 Alcor Micro Corp. Hub
> Bus 005 Device 001: ID 1d6b:0001  
> Bus 004 Device 001: ID 1d6b:0001  
> Bus 003 Device 001: ID 1d6b:0001  
> Bus 002 Device 001: ID 1d6b:0001  
> 
> First device (Feiya Technology Corp) is the disk on key.
> 
> Usbmon output from cat /sys/kernel/debug/usbmon/1u

(... Uninteresting parts removed ...)

Here is the command preceding the one that failed.  It is a MODE
SENSE(6) command for 192 bytes; the device replies with 76 bytes and
then fails to set the residue appropriately -- not a good sign but 
plenty of other devices have the same bug.

> ef48ab00 3229280711 S Bo:1:006:2 -115 31 = 55534243 0c000000 c0000000 8000061a 003f00c0 00000000 00000000 000000
> ef48ab00 3229280811 C Bo:1:006:2 0 31 >
> ef727880 3229280818 S Bi:1:006:1 -115 192 <
> ef727880 3229281185 C Bi:1:006:1 -121 76 = 4b000008 000f1f00 00000200 010a0010 00000000 03000000 051e3c00 203f0200
> ef48ab00 3229281195 S Bi:1:006:1 -115 13 <
> ef48ab00 3229281435 C Bi:1:006:1 0 13 = 55534253 0c000000 00000000 00

Next comes the very first READ(10) command.  It asks for 8 sectors 
starting at sector 0:

> ef48ab00 3229281483 S Bo:1:006:2 -115 31 = 55534243 0d000000 00100000 80000a28 00000000 00000008 00000000 000000
> ef48ab00 3229281560 C Bo:1:006:2 0 31 >
> ef635d80 3229281567 S Bi:1:006:1 -115 4096 <
> ef635d80 3229410691 C Bi:1:006:1 -32 0
> ef48ab00 3229410723 S Co:1:006:0 s 02 01 0000 0081 0000 0
> ef48ab00 3229410815 C Co:1:006:0 0 0
> ef48ab00 3229410822 S Bi:1:006:1 -115 13 <
> ef48ab00 3229410940 C Bi:1:006:1 0 13 = 55534253 0d000000 00100000 01

The command fails.  The computer then sends a REQUEST SENSE command to 
find out why:

> ef48ab00 3229410948 S Bo:1:006:2 -115 31 = 55534243 0e000000 12000000 80000603 00000012 00000000 00000000 000000
> ef48ab00 3229411065 C Bo:1:006:2 0 31 >
> ef6c7f00 3229411071 S Bi:1:006:1 -115 18 <
> ef6c7f00 3229411190 C Bi:1:006:1 0 18 = 70000500 0000000a 00000000 21000000 0000
> ef48ab00 3229411197 S Bi:1:006:1 -115 13 <
> ef48ab00 3229411315 C Bi:1:006:1 0 13 = 55534253 0e000000 12000000 00

The device responds with Sense Key = 5 (Illegal Request) and ASC =
0x21 (Logical Block Address Out of Range), as mentioned in the log.  
Oddly enough, the residue value for this REQUEST SENSE result is set to 
18, so perhaps that means we shouldn't believe any of the sense data!  
(More likely it means the residue values are totally bogus...)

Regardless, this causes the read of the partition table to fail.  But
the next command sent by the computer is another READ(10) for 8 sectors
starting at sector 0, and this time it works!

> ef48ab00 3229411387 S Bo:1:006:2 -115 31 = 55534243 0f000000 00100000 80000a28 00000000 00000008 00000000 000000
> ef48ab00 3229411439 C Bo:1:006:2 0 31 >
> ef6c7e00 3229411497 S Bi:1:006:1 -115 4096 <
> ef6c7e00 3229412314 C Bi:1:006:1 0 4096 = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> ef48ab00 3229412831 S Bi:1:006:1 -115 13 <
> ef48ab00 3229412939 C Bi:1:006:1 0 13 = 55534253 0f000000 00000000 00

So apparently this is a bug in the device; it doesn't respond correctly
to the first READ command.  But since it does respond correctly to 
later commands, everything works okay thereafter.  You ought to be able 
to recover from the error by running

	blockdev --rereadpt /dev/sdb

manually.

As far as I can tell, this has nothing to do with any user programs in 
the distribution.  It appears to be entirely the device's fault.

Alan Stern

