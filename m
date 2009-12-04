Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZLDTRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZLDTRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZLDTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:17:38 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50142 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755817AbZLDTRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:17:37 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Fri, 4 Dec 2009 20:17:34 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912041041370.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041041370.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2470
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912042017.36459.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009 16:47:37 Alan Stern wrote:
> On Fri, 4 Dec 2009, Ondrej Zary wrote:
> > > Furthermore, the patch shows that the second-to-last argument to
> > > usb_fill_bulk_urb() -- the completion function -- is NULL.  That is
> > > strictly illegal and it should have caused an oops as soon as the URB
> > > was used.
> >
> > Thanks for catching this. usbmon showed no ACK packets so it didn't work
> > at all. The device did not care. It started to work after adding a
> > complete function.
>
> What started to work?  If you don't send any ACK packets, it doesn't
> make any difference whether the completion function is set or not.

Sending ACKs started to work. I was sending them but usbmon didn't show any. 
Just found why - the check of usb_submit_urb() return value got lost 
somewhere. It returned -EINVAL when completion function was NULL and I didn't 
notice it.

> > Seems that -EPIPE is returned only after the device is disconnected.
> > Adding a check for -EPIPE to usbtouch_irq() and not submitting the urb
> > again seems to fix the problem!
>
> Fix which problem?  The unending resubmissions or the oops in ehci-hcd?

It fixed both. If the urb fails with -EPIPE, it's not resubmitted again - and 
this (mysteriously) fixes the oops on USB disconnect.

Last problem that remains: after rmmod, the USB bus where the device is
connected, hangs completely. Not always, only sometimes (see below).

> BTW, does the touchscreen run at high speed or at full speed?

It runs at full speed.

Just found why it was sometimes hard to reproduce a problem. Sometimes the
devices are controlled by uhci_hcd and sometimes by ehci_hcd. It seems to
be random and can change on every reboot. Both are compiled as modules and
are loaded from initramfs. It might be Debian bug. The machine is Asus Eee
Box B202.

lsusb with ehci_hcd:
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 041e:4068 Creative Technology, Ltd Webcam Live! Notebook
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 413c:2003 Dell Computer Corp. Keyboard
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 009: ID 1870:0001 Nexio Co., Ltd iNexio Touchscreen controller
Bus 001 Device 008: ID 088c:2030 Swecoin AB Ticket Printer TTP 2030
Bus 001 Device 007: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
Bus 001 Device 006: ID 065a:0001 Optoelectronics Co., Ltd Barcode scanner
Bus 001 Device 005: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0 multicard reader
Bus 001 Device 002: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

lsusb with uhci_hcd:
Bus 003 Device 002: ID 413c:2003 Dell Computer Corp. Keyboard
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 004: ID 065a:0001 Optoelectronics Co., Ltd Barcode scanner
Bus 002 Device 006: ID 088c:2030 Swecoin AB Ticket Printer TTP 2030
Bus 002 Device 005: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
Bus 002 Device 003: ID 041e:4068 Creative Technology, Ltd Webcam Live! Notebook
Bus 002 Device 002: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 005: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0 multicard reader
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub


With uhci_hcd, rmmod works fine. With ehci_hcd, rmmod hangs the bus - all
urbs fail with -ENOENT:
f67265e8 1428021080 S Bi:1:009:2 -115 128 <
f67265e8 1431508327 C Bi:1:009:2 -108 0
f6726718 1458252464 S Co:1:007:0 s 40 09 0001 0000 0000 0
f6726718 1463261404 C Co:1:007:0 -2 0
f6726978 1463261428 S Co:1:002:0 s 23 08 0070 0001 0000 0
f6726718 1463261509 S Co:1:007:0 s 40 00 0000 0000 0000 0
f6726978 1464273397 C Co:1:002:0 -2 0
f6726718 1468273397 C Co:1:007:0 -2 0

and of course, some errors appear in dmesg:
[  226.962844] usbcore: deregistering interface driver usbtouchscreen
[  226.962966] drivers/input/touchscreen/usbtouchscreen.c: usbtouch_irq - urb shutting down with status: -108
[  226.962977] drivers/input/touchscreen/usbtouchscreen.c: usbtouch_disconnect - called
[  226.962982] drivers/input/touchscreen/usbtouchscreen.c: usbtouch_disconnect - usbtouch is initialized, cleaning up
[  258.716124] ftdi_sio ttyUSB0: Unable to write latency timer: -110
[  259.728087] usb 1-1: clear tt 1 (0070) error -110
[  264.740086] ftdi_sio ttyUSB0: ftdi_set_termios FAILED to set databits/stopbits/parity
[  265.752088] ftdi_sio ttyUSB0: ftdi_set_termios urb failed to set baudrate
[  270.764087] ftdi_sio ttyUSB0: urb failed to clear flow control
[  310.788083] ftdi_sio ttyUSB0: error from flowcontrol urb

My submitted urb is correctly ended with -ESHUTDOWN and no other communication
with touchscreen appears.

I also tried rmmoding usb_storage (as the integrated realtek card reader
is on the affected bus when it breaks and it's not when it works) but it
didn't help.


> Alan Stern


-- 
Ondrej Zary
