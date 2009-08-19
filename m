Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZHSVB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZHSVB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZHSVB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:01:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35731 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312AbZHSVBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:01:25 -0400
Date: Wed, 19 Aug 2009 17:01:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090819221532.6b4e8a4a@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908191648160.3229-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Bruno [UTF-8] Prémont wrote:

> I've added WARN_ON()s in usb_serial_put() and usb_serial_get_by_index()
> in order to have information on who called us (easier than searching
> around and adding lots of printk()s and output is also more verbose :)
> 
> Below, my changes to usb-serial.c and dmesg extracts for crash cases with
> pl2302 and ftdi_sio.
> 
> You have guessed right, there are calls to serial_do_free() after
> destroy_serial() in the crash cases. destroy_serial when disconnecting
> device and final serial_do_free() when exiting minicom.

Good work.  This shows clearly where the problem is.

> [  417.320036] usb 2-1: new full speed USB device using uhci_hcd and address 3
> [  417.486198] usb 2-1: New USB device found, idVendor=067b, idProduct=2303
> [  417.486418] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  417.486663] usb 2-1: Product: USB-Serial Controller
> [  417.486820] usb 2-1: Manufacturer: Prolific Technology Inc.
> [  417.487238] usb 2-1: configuration #1 chosen from 1 choice
> [  417.490544] pl2303 2-1:1.0: pl2303 converter detected
> [  417.502366] usb 2-1: pl2303 converter now attached to ttyUSB0

The pl2303 was plugged in.

> [  419.476126] usb_serial_get_by_index(index 0): @d9cc2720
> [  419.476320] ------------[ cut here ]------------
> [  419.476518] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
> [  419.476870] Hardware name: TravelMate 660
> [  419.477016] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
> [  419.478371] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
> [  419.478609] Call Trace:
> [  419.478704]  [<c12b7052>] ? printk+0x18/0x1e
> [  419.478869]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
> [  419.479092]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
> [  419.487714]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
> [  419.496407]  [<c1023765>] warn_slowpath_null+0x15/0x20
> [  419.505172]  [<dea49182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
> [  419.514032]  [<dea4936d>] serial_open+0x2d/0x250 [usbserial]

Minicom opened the device file.

> [  434.000189] usb 2-1: USB disconnect, address 3
> [  434.001726] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> [  434.001986] usb_serial_put(serial @d9cc2720)
> [  434.002126] ------------[ cut here ]------------
> [  434.002310] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
> [  434.002650] Hardware name: TravelMate 660
> [  434.002795] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
> [  434.004145] Pid: 978, comm: khubd Tainted: G   M    W  2.6.31-rc6 #1
> [  434.004361] Call Trace:
> [  434.004455]  [<c12b7052>] ? printk+0x18/0x1e
> [  434.004620]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.004818]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
> [  434.005014]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.005208]  [<c1023765>] warn_slowpath_null+0x15/0x20
> [  434.005398]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
> [  434.005594]  [<dea48f81>] usb_serial_disconnect+0xf1/0x160 [usbserial]
...
> [  434.008710] pl2303 2-1:1.0: device disconnected

The pl2303 was unplugged.

> [  434.009183] usb_serial_get_by_index(index 0): @d9cc2720
> [  434.009354] ------------[ cut here ]------------
> [  434.009532] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
> [  434.009885] Hardware name: TravelMate 660
> [  434.010054] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
> [  434.011402] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
> [  434.011626] Call Trace:
> [  434.011714]  [<c12b7052>] ? printk+0x18/0x1e
> [  434.011877]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
> [  434.012097]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
> [  434.012293]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
> [  434.012511]  [<c1023765>] warn_slowpath_null+0x15/0x20
> [  434.012701]  [<dea49182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
> [  434.012920]  [<dea4936d>] serial_open+0x2d/0x250 [usbserial]
> [  434.013123]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
> [  434.013292]  [<c115fa4d>] tty_open+0x1bd/0x4b0

For some reason, minicom attempted to reopen the device file 
immediately.

> [  434.079109] usb_serial_put(serial @d9cc2720)
> [  434.083537] ------------[ cut here ]------------
> [  434.087641] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
> [  434.091916] Hardware name: TravelMate 660
> [  434.096132] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
> [  434.105454] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
> [  434.109980] Call Trace:
> [  434.114426]  [<c12b7052>] ? printk+0x18/0x1e
> [  434.118801]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.123133]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
> [  434.127306]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.131466]  [<c1023765>] warn_slowpath_null+0x15/0x20
> [  434.135581]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
> [  434.139755]  [<dea493b0>] serial_open+0x70/0x250 [usbserial]
> [  434.143923]  [<c115fa4d>] tty_open+0x1bd/0x4b0

The open failed, because the device had been unplugged.  serial_open()
would therefore return -ENODEV.

> [  434.193345] tty_port_close_start: count = -1
> [  434.290041] serial_do_free(port @d8df5c00)
> [  434.299763]   serial @d9cc2720
> [  434.309450]   type   @de77dc20
> [  434.319321] usb_serial_put(serial @d9cc2720)
> [  434.323540] ------------[ cut here ]------------
> [  434.327490] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
> [  434.331601] Hardware name: TravelMate 660
> [  434.335662] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
> [  434.344746] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
> [  434.349160] Call Trace:
> [  434.353463]  [<c12b7052>] ? printk+0x18/0x1e
> [  434.357707]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.361868]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
> [  434.365907]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.369882]  [<c1023765>] warn_slowpath_null+0x15/0x20
> [  434.373881]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
> [  434.377868]  [<dea48db9>] serial_do_free+0x99/0xd0 [usbserial]
> [  434.381857]  [<dea48e57>] serial_close+0x67/0xa0 [usbserial]
> [  434.385792]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
> [  434.389716]  [<c115f2e0>] tty_release_dev+0x130/0x490
> [  434.393638]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
> [  434.397546]  [<c10207e3>] ? __cond_resched+0x23/0x40
> [  434.401443]  [<c12b7d7e>] ? mutex_lock+0xe/0x20
> [  434.405321]  [<dea48d0b>] ? usb_serial_put+0x4b/0x60 [usbserial]
> [  434.409216]  [<dea493b0>] ? serial_open+0x70/0x250 [usbserial]
> [  434.413153]  [<c115fced>] tty_open+0x45d/0x4b0

This is the key.  When the open failed, tty_open() went on to call
tty_release_dev(), which in turn called serial_close().  In other
words, the TTY layer was trying to close a device reference which had
never successfully been opened!  This resulted in an unbalanced call
to usb_serial_put().

> [  434.459076] destroy_serial(kref @d9cc2754)
> [  434.462686]   serial @d9cc2720

The extra put caused the data structure to be released too soon.

> [  454.363600] serial_do_free(port @d8df5c00)
> [  454.363745]   serial @d8df5a00
> [  454.363868]   type   @(null)
> [  454.363992] BUG: unable to handle kernel NULL pointer dereference at 0000001c
> [  454.364252] IP: [<dea48d8d>] serial_do_free+0x6d/0xd0 [usbserial]
> [  454.364487] *pde = 00000000 
> [  454.364609] Oops: 0000 [#1] 
> [  454.364731] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
> [  454.364974] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
> [  454.366315] 
> [  454.366391] Pid: 2186, comm: minicom Tainted: G   M    W  (2.6.31-rc6 #1) TravelMate 660
> [  454.366644] EIP: 0060:[<dea48d8d>] EFLAGS: 00010282 CPU: 0
> [  454.366844] EIP is at serial_do_free+0x6d/0xd0 [usbserial]
> [  454.367018] EAX: 00000000 EBX: d8df5c00 ECX: ffffffff EDX: c13c6584
> [  454.367245] ESI: d8df5a00 EDI: 00000000 EBP: d8cc3e24 ESP: d8cc3e10
> [  454.367444]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  454.367633] Process minicom (pid: 2186, ti=d8cc3000 task=dd8e1dd0 task.ti=d8cc3000)
> [  454.367870] Stack:
> [  454.367954]  dea4cc4e 00000000 d8df5c00 dd0d8c00 00000000 d8cc3e4c dea48e57 00000000
> [  454.368329] <0> d8cc3e4c c115d1a5 dd0d8ca0 dd8d1180 dd0d8c00 00000000 00000000 d8cc3edc
> [  454.368749] <0> c115f2e0 40000000 d8cc3e94 00000082 dd8d1180 00000000 00000000 00000000
> [  454.369178] Call Trace:
> [  454.369290]  [<dea48e57>] ? serial_close+0x67/0xa0 [usbserial]
> [  454.369483]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
> [  454.369652]  [<c115f2e0>] ? tty_release_dev+0x130/0x490
> [  454.369828]  [<c1056d72>] ? put_page+0x42/0x120
> [  454.369993]  [<c105435a>] ? free_hot_page+0xa/0x10
> [  454.370195]  [<c105438f>] ? __free_pages+0x2f/0x40
> [  454.370356]  [<c107042e>] ? __free_slab+0xae/0x160
> [  454.370530]  [<c115f64a>] ? tty_release+0xa/0x10
> [  454.370681]  [<c1075f1c>] ? __fput+0xdc/0x1d0
> [  454.370840]  [<c107602f>] ? fput+0x1f/0x30
> [  454.370976]  [<c1072f8e>] ? filp_close+0x3e/0x70
> [  454.371148]  [<c1024fa2>] ? put_files_struct+0xa2/0xc0
> [  454.371315]  [<c1024fdc>] ? exit_files+0x1c/0x20
> [  454.371483]  [<c1026339>] ? do_exit+0xb9/0x630

And this is the actual close that occurred when minicom exited.  But
by then it was too late.

So Alan, what's the explanation?  An unsuccessful open method call
should not lead to a close method call.

Alan Stern

