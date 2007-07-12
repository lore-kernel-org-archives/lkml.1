Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbXGLSoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbXGLSoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbXGLSn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:43:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55608 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756558AbXGLSnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:43:55 -0400
Date: Thu, 12 Jul 2007 14:43:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel J Blueman <daniel.blueman@gmail.com>, <v@iki.fi>
cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [2.6.22-rc7] khubd NULL deref oops...
In-Reply-To: <6278d2220707111151o2b5f8b23ha14bf77be71b8b61@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707121430590.2602-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Daniel J Blueman wrote:

> On 11/07/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> > On 07/08/2007 05:45 PM, Daniel J Blueman wrote:
> > > When plugging in a USB 2 mass-storage device which I've been seeing
> > > problems with, I caught a khubd oops [1]. Kernel is 2.6.22-rc7 on ia32
> > > built with Ubuntu's 2.6.22 .config.
> >
> > > [ 4769.252000] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> > > [ 4769.252000]  sdb: sdb1 < sdb5 sdb6<6>usb 5-3: reset high speed USB
> > > device using ehci_hcd and address 8
> >
> > So the device got reset right in the middle of scanning for partitions.
> >
> > > [ 4769.544000] usb 5-3: device descriptor read/64, error -71
> > > [ 4769.760000] usb 5-3: device descriptor read/64, error -71
> > > [ 4769.976000] usb 5-3: reset high speed USB device using ehci_hcd and
> > > address 8
> > > [ 4770.088000] usb 5-3: device descriptor read/64, error -71
> > > [ 4770.304000] usb 5-3: device descriptor read/64, error -71
> > > [ 4770.520000] usb 5-3: reset high speed USB device using ehci_hcd and
> > > address 8
> > > [ 4770.928000] usb 5-3: device not accepting address 8, error -71
> > > [ 4771.040000] usb 5-3: reset high speed USB device using ehci_hcd and
> > > address 8
> >
> > Then a whole slew of these by-now-familiar messages.
> >
> > Try disabling CONFIG_USB_SUSPEND.  It makes lots of USB bugs go away
> 
> I'll give it a shot. For the record, I wasn't trying to perform a
> suspend at this time (or since booting).

On Wed, 11 Jul 2007, Chuck Ebbert wrote:

> On 07/11/2007 08:59 AM, Ville Herva wrote:
> > [98790.134315] sd 17:0:0:0: [sdb] Mode Sense: 03 00 00 00
> > [98790.134319] sd 17:0:0:0: [sdb] Assuming drive cache: write through
> > [98790.134323]  sdb:<6>usb 6-1: USB disconnect, address 27
> > [98790.366609] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>
> Another USB device disconnect while scanning for partitions.
>
> Yes, it should be handled but it also shouldn't just disconnect like that.

I have tried to duplicate these two bugs and failed.  On a vanilla
2.6.22 system I set up a USB mass storage device to return an error for
the third and all subsequent reads, so the partition-detection code was
able to learn about the primary partition and the first logical
partition but not the others.  In spite of the error at this point, the
kernel cleaned up properly:

[  550.237869] usb 11-1: new high speed USB device using dummy_hcd and address 7
[  550.401599] usb 11-1: Product: File-backed Storage Gadget
[  550.401603] usb 11-1: Manufacturer: Linux 2.6.22 with dummy_udc
[  550.401606] usb 11-1: SerialNumber: 3238204E6F76
[  550.401866] usb 11-1: configuration #1 chosen from 1 choice
[  550.405661] g_file_storage gadget: high speed config #1
[  550.414507] scsi3 : SCSI emulation for USB Mass Storage devices
[  550.433601] scsi 3:0:0:0: Direct-Access     Linux    File-Stor Gadget 0302 PQ: 0 ANSI: 2
[  550.479009] sd 3:0:0:0: [sda] 64 512-byte hardware sectors (0 MB)
[  550.597318] sd 3:0:0:0: [sda] Write Protect is off
[  550.597385] sd 3:0:0:0: [sda] Assuming drive cache: write through
[  550.620293] sd 3:0:0:0: [sda] 64 512-byte hardware sectors (0 MB)
[  550.737089] sd 3:0:0:0: [sda] Write Protect is off
[  550.737154] sd 3:0:0:0: [sda] Assuming drive cache: write through
[  550.737211]  sda: sda1 sda4 < sda5<7>dummy_udc dummy_udc: disabled ep-a
[  550.884808] usb 11-1: reset high speed USB device using dummy_hcd and address 7
[  551.032553] usb 11-1: can't restore configuration #1 (error=-32)
[  551.032682] usb 11-1: USB disconnect, address 7
[  551.033861] sd 3:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  551.033873] end_request: I/O error, dev sda, sector 40
[  551.033932] Buffer I/O error on device sda, logical block 5
[  551.034228] sd 3:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  551.034236] end_request: I/O error, dev sda, sector 40
[  551.034290] Buffer I/O error on device sda, logical block 5
[  551.034415]  >
[  551.034774] sd 3:0:0:0: [sda] Attached SCSI disk
[  551.034933] sd 3:0:0:0: Attached scsi generic sg0 type 0

CONFIG_SYSFS_DEPRECATED was enabled.

Alan Stern

