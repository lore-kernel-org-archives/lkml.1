Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZHYBmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZHYBmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZHYBmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:42:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43197 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754066AbZHYBmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:42:31 -0400
Date: Mon, 24 Aug 2009 21:42:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090824221508.055cfbc6@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908242116180.17556-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Bruno [UTF-8] Prémont wrote:

> The patch does not work properly:
> 
> When I plug in the USB2serial converter (be it ftdi or pl2302) device
> node is created properly and minicom can use it.
> 
> When I exit minicom I can no longer start it again, eventually I get
> a killed minicom with NULL-dereference
> 
> A rmmod/modprobe cycle works but the end result is no device node
> created by udev and udev's path_id helper is stuck. (unable to
> determine where for now as netconsole causes trouble with netdev
> polling)
> I will have a deeper look tomorrow as this evening is already over.
> 
> Bruno
> 
> 
> Trace result for ftdi device:

> [   76.115797] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
> [  163.471333] BUG: unable to handle kernel NULL pointer dereference at 00000064
> [  163.471531] IP: [<c115f7ae>] tty_open+0x11e/0x4b0
> [  163.471650] *pde = 00000000 
> [  163.471730] Oops: 0000 [#1] 
> [  163.471809] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
> [  163.471944] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd snd_page_alloc ehci_hcd pcspkr i2c_i801 uhci_hcd usbcore crc_ccitt
> [  163.472927] 
> [  163.472967] Pid: 2157, comm: minicom Tainted: G   M       (2.6.31-rc6-gregkh #2) TravelMate 660
> [  163.473148] EIP: 0060:[<c115f7ae>] EFLAGS: 00010246 CPU: 0
> [  163.473247] EIP is at tty_open+0x11e/0x4b0

> For both cases EIP is at:
>   drivers/char/tty_io.c:1253:
> 1246:static int tty_reopen(struct tty_struct *tty)
> 1247:{
> 1248:	struct tty_driver *driver = tty->driver;
> ...
> 1253:	if (driver->type == TTY_DRIVER_TYPE_PTY &&
> 1254:	    driver->subtype == PTY_TYPE_MASTER) {

Okay, thanks for trying it out.  

Apparently the tty isn't getting removed from the driver the way it
should when minicom closes it the first time.  And no wonder -- I just
realized that my new serial_shutdown() routine doesn't call
tty_shutdown(tty).  Try inserting such a call right before
tty->driver_data gets set to NULL.

The division of labor between the TTY core and the lower drivers makes 
very little sense...

Alan Stern

