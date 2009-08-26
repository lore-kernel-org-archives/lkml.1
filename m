Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZHZUkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZHZUkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZHZUkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:40:20 -0400
Received: from ppp-153-178.adsl.restena.lu ([158.64.153.178]:58496 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZHZUkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:40:19 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 16:40:18 EDT
Date: Wed, 26 Aug 2009 22:32:02 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090826223202.49914a41@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.0908251921390.3665-100000@netrider.rowland.org>
References: <20090825221918.4de9e30f@neptune.home>
 <Pine.LNX.4.44L0.0908251921390.3665-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 25 Aug 2009, Bruno Prémont wrote:
> > Bang at:
> > /tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1456
> > 
> > 1456:	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
> > 1457:		wake_up_interruptible(&tty->read_wait);
> > 
> > 	#define ICANON      0000002
> > 	#define _L_FLAG(tty, f) ((tty)->termios->c_lflag & (f))
> > 	#define L_ICANON(tty)  _L_FLAG((tty), ICANON)
> > =>
> > 	if (canon_change && !((tty)->termios->c_lflag & (ICANON)) && tty->read_cnt)
> > =>
> > 	tty->termios is probably NULL
> 
> Unquestionably that is the problem.
> 
> It looks like something is wrong in serial_install().  We want to
> call tty_init_termios(tty) always, regardless of whether 
> tty->driver->termios[idx] is NULL.  But after the call it definitely 
> won't be NULL, so the test has to be made before the call is done.  
> Something like this:
> 
> 	struct ktermios *t = tty->driver->termios[idx];
> 
> 	/* perform the standard setup */
> 	retval = tty_init_termios(tty);
> 	if (retval)
> 		return retval;
> 
> 	/* If the specialized termios setup has yet to be done */
> 	if (!t) {
> 		...
> 
> Want to try that?

Change applied to usb-serial.c, serial_instal().
Tried it out with both pl2302 and ftdi-sio, no visible issues!

Actions I tried: connect, disconnect (with minicom running as well as
without), start/stop minicom multiple times.

I've seen nothing unexpected or bad in kernel log (just a note that
some sending failed while typing into minicom and pulling the USB
plug: pl2303_write_bulk_callback - failed resubmitting write urb, error -19)

Bruno


Full log while trying out:
[   96.060039] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   96.278980] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[   96.279105] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   96.279249] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[   96.279346] usb 1-2: Manufacturer: FTDI
[   96.279433] usb 1-2: SerialNumber: FTS55QK6
[   96.279746] usb 1-2: configuration #1 chosen from 1 choice
[   96.386173] usbcore: registered new interface driver usbserial
[   96.386245] usbserial: USB Serial Driver core
[   96.448488] USB Serial support registered for FTDI USB Serial Device
[   96.448888] usb 1-2: Ignoring serial port reserved for JTAG
[   96.449106] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[   96.449296] usb 1-2: Detected FT2232C
[   96.449367] usb 1-2: Number of endpoints 2
[   96.449460] usb 1-2: Endpoint 1 MaxPacketSize 64
[   96.449544] usb 1-2: Endpoint 2 MaxPacketSize 64
[   96.449643] usb 1-2: Setting MaxPacketSize 64
[   96.450799] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[   96.450895] usbcore: registered new interface driver ftdi_sio
[   96.450938] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  147.540073] usb 1-2: USB disconnect, address 2
[  147.540627] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  147.540820] ftdi_sio 1-2:1.1: device disconnected
[  177.410037] usb 1-2: new full speed USB device using uhci_hcd and address 3
[  177.628979] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[  177.629105] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  177.629251] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[  177.629349] usb 1-2: Manufacturer: FTDI
[  177.629436] usb 1-2: SerialNumber: FTS55QK6
[  177.629751] usb 1-2: configuration #1 chosen from 1 choice
[  177.637131] usb 1-2: Ignoring serial port reserved for JTAG
[  177.642161] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[  177.642379] usb 1-2: Detected FT2232C
[  177.642452] usb 1-2: Number of endpoints 2
[  177.642546] usb 1-2: Endpoint 1 MaxPacketSize 64
[  177.642629] usb 1-2: Endpoint 2 MaxPacketSize 64
[  177.642729] usb 1-2: Setting MaxPacketSize 64
[  177.643137] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[  199.790072] usb 1-2: USB disconnect, address 3
[  199.790622] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  199.790815] ftdi_sio 1-2:1.1: device disconnected
[  202.910037] usb 1-2: new full speed USB device using uhci_hcd and address 4
[  203.128984] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[  203.129101] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  203.129242] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[  203.129333] usb 1-2: Manufacturer: FTDI
[  203.129415] usb 1-2: SerialNumber: FTS55QK6
[  203.129723] usb 1-2: configuration #1 chosen from 1 choice
[  203.137131] usb 1-2: Ignoring serial port reserved for JTAG
[  203.142155] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[  203.142366] usb 1-2: Detected FT2232C
[  203.142431] usb 1-2: Number of endpoints 2
[  203.142519] usb 1-2: Endpoint 1 MaxPacketSize 64
[  203.142596] usb 1-2: Endpoint 2 MaxPacketSize 64
[  203.142691] usb 1-2: Setting MaxPacketSize 64
[  203.143150] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB1
[  266.033894] usbcore: deregistering interface driver ftdi_sio
[  266.038905] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disconnected from ttyUSB1
[  266.042730] ftdi_sio 1-2:1.1: device disconnected
[  266.045992] USB Serial deregistering driver FTDI USB Serial Device
[  284.281542] usbcore: deregistering interface driver usbserial
[  288.540072] usb 1-2: USB disconnect, address 4
[  294.000036] usb 1-2: new full speed USB device using uhci_hcd and address 5
[  294.218988] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[  294.219114] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  294.219259] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[  294.219357] usb 1-2: Manufacturer: FTDI
[  294.219443] usb 1-2: SerialNumber: FTS55QK6
[  294.219759] usb 1-2: configuration #1 chosen from 1 choice
[  294.261216] usbcore: registered new interface driver usbserial
[  294.261288] usbserial: USB Serial Driver core
[  294.267068] USB Serial support registered for FTDI USB Serial Device
[  294.267281] usb 1-2: Ignoring serial port reserved for JTAG
[  294.267383] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[  294.267479] usb 1-2: Detected FT2232C
[  294.267509] usb 1-2: Number of endpoints 2
[  294.267555] usb 1-2: Endpoint 1 MaxPacketSize 64
[  294.267590] usb 1-2: Endpoint 2 MaxPacketSize 64
[  294.267639] usb 1-2: Setting MaxPacketSize 64
[  294.269091] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[  294.269197] usbcore: registered new interface driver ftdi_sio
[  294.269240] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  300.000027] Machine check events logged
[  723.280035] usb 1-1: new full speed USB device using uhci_hcd and address 6
[  723.446315] usb 1-1: New USB device found, idVendor=067b, idProduct=2303
[  723.450777] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  723.455164] usb 1-1: Product: USB-Serial Controller
[  723.459524] usb 1-1: Manufacturer: Prolific Technology Inc.
[  723.465908] usb 1-1: configuration #1 chosen from 1 choice
[  723.916652] USB Serial support registered for pl2303
[  723.921271] pl2303 1-1:1.0: pl2303 converter detected
[  723.935435] usb 1-1: pl2303 converter now attached to ttyUSB1
[  723.939890] usbcore: registered new interface driver pl2303
[  723.944327] pl2303: Prolific PL2303 USB to serial adaptor driver
[  739.750073] usb 1-1: USB disconnect, address 6
[  739.750909] pl2303 ttyUSB1: pl2303 converter now disconnected from ttyUSB1
[  739.751075] pl2303 1-1:1.0: device disconnected
[  743.530041] usb 1-1: new full speed USB device using uhci_hcd and address 7
[  743.696932] usb 1-1: New USB device found, idVendor=067b, idProduct=2303
[  743.697050] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  743.697190] usb 1-1: Product: USB-Serial Controller
[  743.697271] usb 1-1: Manufacturer: Prolific Technology Inc.
[  743.697600] usb 1-1: configuration #1 chosen from 1 choice
[  743.700108] pl2303 1-1:1.0: pl2303 converter detected
[  743.712094] usb 1-1: pl2303 converter now attached to ttyUSB2
[  752.250070] usb 1-1: USB disconnect, address 7
[  752.250499] usb 1-1: pl2303_write_bulk_callback - failed resubmitting write urb, error -19
[  752.251803] pl2303 ttyUSB2: pl2303 converter now disconnected from ttyUSB2
[  752.251967] pl2303 1-1:1.0: device disconnected
[  776.780035] usb 1-1: new full speed USB device using uhci_hcd and address 8
[  776.946378] usb 1-1: New USB device found, idVendor=067b, idProduct=2303
[  776.946496] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  776.946633] usb 1-1: Product: USB-Serial Controller
[  776.946716] usb 1-1: Manufacturer: Prolific Technology Inc.
[  776.947044] usb 1-1: configuration #1 chosen from 1 choice
[  776.949528] pl2303 1-1:1.0: pl2303 converter detected
[  776.961542] usb 1-1: pl2303 converter now attached to ttyUSB3
[  816.250068] usb 1-1: USB disconnect, address 8
[  816.250476] pl2303 ttyUSB3: pl2303 converter now disconnected from ttyUSB3
[  816.250644] pl2303 1-1:1.0: device disconnected
[  818.250058] usb 1-2: USB disconnect, address 5
[  818.250531] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  818.250723] ftdi_sio 1-2:1.1: device disconnected
[  829.914462] usbcore: deregistering interface driver pl2303
[  829.915564] USB Serial deregistering driver pl2303
[  829.915958] usbcore: deregistering interface driver ftdi_sio
[  829.916113] USB Serial deregistering driver FTDI USB Serial Device
[  829.916472] usbcore: deregistering interface driver usbserial

