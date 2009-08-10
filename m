Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZHJR23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZHJR23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZHJR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:28:29 -0400
Received: from ppp-152-125.adsl.restena.lu ([158.64.152.125]:59910 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbZHJR21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:28:27 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2009 13:28:27 EDT
Date: Mon, 10 Aug 2009 19:18:22 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090810191822.26370810@neptune.home>
In-Reply-To: <20090810154402.GA7701@kroah.com>
References: <20090808194733.38406075@neptune.home>
	<Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
	<20090810154402.GA7701@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 August 2009 Greg KH <greg@kroah.com> wrote:
> On Mon, Aug 10, 2009 at 11:18:29AM -0400, Alan Stern wrote:
> > On Sat, 8 Aug 2009, Bruno Prémont wrote:
> > 
> > > I tried bisecting this but bisect did end up on a fully unrelated
> > > commit (which is not even being compiled into my kernel).
> > > Possibly the failed bisect could be related to mis-classified
> > > kernel panic/hang while pulling the USB cable (there were two
> > > such panics for the whole iteration)?
> > > 
> > > There are quite a few patches touching tty, ttyUSB and friends
> > > between rc4 and now so pretty hard to guess on the correct one.
> > > 
> > > The oops always happens when I disconnect the USB serial console
> > > (here the one built into Marvell SheevaPlug) while having minicom
> > > connected to it.
> > > During the bisection for the last few bad iterations minicom got
> > > killed (segfault), the bad ones on the iteration left a minicom
> > > zombie in 'D' state.
> > 
> > By the way, there are quite a few serial patches in Greg KH's
> > tree.  At least one of them looks like it is meant to fix exactly
> > this problem.
> > 
> > Can you try running with
> > 
> > http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-all-2.6.31-rc5.patch
> > 
> > applied to the standard 2.6.31-rc5 source?
> 
> Yes, that would be good to find out, so we can pick the right patch to
> send in now.
> 
> thanks,
> 
> greg k-h
> 

Unfortunately none of the patches in gregkh-all-2.6.31-rc5.patch do fix
it.
With these patches minicom segfaults instead of remaining as a zombie
(but that also happened during my bisect sequence.

In this case it looks rather like some use-after-free as kernel tries
to access some memory at an address pretty far away from NULL.

thanks,
Bruno

Here the kernel log for this attempt:
[   78.730035] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   78.948188] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[   78.948198] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   78.948206] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[   78.948213] usb 1-2: Manufacturer: FTDI
[   78.948219] usb 1-2: SerialNumber: FTS55QK6
[   78.948452] usb 1-2: configuration #1 chosen from 1 choice
[   79.053847] usbcore: registered new interface driver usbserial
[   79.053851] usbserial: USB Serial Driver core
[   79.072653] USB Serial support registered for FTDI USB Serial Device
[   79.072865] usb 1-2: Ignoring serial port reserved for JTAG
[   79.072968] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[   79.073030] usb 1-2: Detected FT2232C
[   79.073036] usb 1-2: Number of endpoints 2
[   79.073042] usb 1-2: Endpoint 1 MaxPacketSize 64
[   79.073049] usb 1-2: Endpoint 2 MaxPacketSize 64
[   79.073055] usb 1-2: Setting MaxPacketSize 64
[   79.074355] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[   79.074395] usbcore: registered new interface driver ftdi_sio
[   79.074401] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  199.731548] loop0 used greatest stack depth: 1104 bytes left
[  213.040179] usb 1-2: USB disconnect, address 2
[  213.040577] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  213.040607] ftdi_sio 1-2:1.1: device disconnected
[  213.040893] tty_port_close_start: count = -1
[  213.040914] BUG: unable to handle kernel paging request at de1ab42c
[  213.041166] IP: [<c1165026>] tty_port_close_start+0x96/0x170
[  213.046870] *pde = 00000000 
[  213.052897] Oops: 0002 [#1] 
[  213.058817] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  213.064956] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer pcspkr snd ehci_hcd i2c_i801 snd_page_alloc uhci_hcd nsc_ircc usbcore irda crc_ccitt
[  213.078798] 
[  213.085472] Pid: 2119, comm: minicom Tainted: G   M       (2.6.31-rc5-gregkh #3) TravelMate 660
[  213.092424] EIP: 0060:[<c1165026>] EFLAGS: 00010096 CPU: 0
[  213.099402] EIP is at tty_port_close_start+0x96/0x170
[  213.106429] EAX: de1ab42c EBX: dd1ab404 ECX: ffffffff EDX: c13c6564
[  213.113587] ESI: 00000286 EDI: daafc000 EBP: daaead8c ESP: daaead74
[  213.120747]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  213.127925] Process minicom (pid: 2119, ti=daaea000 task=dd952120 task.ti=daaea000)
[  213.135206] Stack:
[  213.142493]  c1374da0 ffffffff c1084cbd dd1ab400 dd1ab404 daafc000 daaeadb4 dfae8a36
[  213.142869] <0> 00000000 daaeadb4 c115cb85 daafc0a0 db067e80 daafc000 00000000 00000000
[  213.150558] <0> daaeae44 c115ed00 daaeaef4 4c99875a dd9d4a80 db067e80 00000000 00000000
[  213.165774] Call Trace:
[  213.173463]  [<c1084cbd>] ? dput+0x8d/0x120
[  213.181179]  [<dfae8a36>] ? serial_close+0x36/0x90 [usbserial]
[  213.188945]  [<c115cb85>] ? tty_fasync+0x55/0xe0
[  213.196693]  [<c115ed00>] ? tty_release_dev+0x130/0x490
[  213.204434]  [<c12b6d8e>] ? mutex_lock+0xe/0x20
[  213.212142]  [<dfae8dc9>] ? usb_serial_put+0x29/0x30 [usbserial]
[  213.219890]  [<dfae9060>] ? serial_open+0x70/0x250 [usbserial]
[  213.227741]  [<c115f70d>] ? tty_open+0x45d/0x4b0
[  213.235653]  [<c1076fe6>] ? chrdev_open+0x96/0x140
[  213.243604]  [<c1072d7f>] ? __dentry_open+0x9f/0x250
[  213.251588]  [<c1073019>] ? nameidata_to_filp+0x59/0x70
[  213.259570]  [<c1076f50>] ? chrdev_open+0x0/0x140
[  213.267596]  [<c107f2f9>] ? do_filp_open+0x269/0x890
[  213.275626]  [<c10389ec>] ? ktime_get_ts+0x4c/0x50
[  213.283673]  [<c1072b47>] ? do_sys_open+0x57/0x140
[  213.291762]  [<c1026b65>] ? alarm_setitimer+0x35/0x70
[  213.299872]  [<c1072c99>] ? sys_open+0x29/0x40
[  213.307998]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  213.316146] Code: eb b8 89 44 24 04 c7 04 24 a0 4d 37 c1 e8 3d 10 15 00 c7 43 0c 00 00 00 00 8d b6 00 00 00 00 8d bf 00 00 00 00 8d 83 28 00 00 01 <80> 8b 28 00 00 01 01 80 8f 2c 01 00 00 20 56 9d 0f b6 87 94 00 
[  213.334752] EIP: [<c1165026>] tty_port_close_start+0x96/0x170 SS:ESP 0068:daaead74
[  213.343661] CR2: 00000000de1ab42c
[  213.352536] ---[ end trace 4e30eef18c7e8fe3 ]---
