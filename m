Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZHUQuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZHUQuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZHUQuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:50:54 -0400
Received: from ppp-153-131.adsl.restena.lu ([158.64.153.131]:39702 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbZHUQuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:50:52 -0400
Date: Fri, 21 Aug 2009 18:50:26 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090821185026.2b2632d1@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.0908211042380.2912-100000@iolanthe.rowland.org>
References: <20090821112554.18a297fa@pluto.restena.lu>
	<Pine.LNX.4.44L0.0908211042380.2912-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 21 Aug 2009, Bruno [UTF-8] Prémont wrote:
> 
> > The module refcount was for both. It's the pl2302/ftdi-sio module's
> > refcount.
> > 
> > I don't remember for sure about the panic if it also affects
> > pl2302 or not.
> > At least one of the panics was when running dmesg after exiting
> > minicom.
> > 
> > I will redo the tests this evening when I get home and report back
> > with more details.
> 
> Apparently the problem is in serial_do_free(); it doesn't know 
> whether it's getting called for a successful open or an unsuccessful 
> open, so it decrements the module count when it shouldn't.  The same
> is true for port->dev's refcount.

That makes sense, see below dmesg log extracts (from USB plug-in until
after exiting minicom), there are two calls to serial_do_free().

On USB disconnect module refcount is zero, on minicom exit it underflows.

> Alan, related to this problem is the fact that usb_serial_driver
> doesn't include a "hangup" method.  I'm not sure that making
> serial_hangup() call serial_do_down() is correct, but if it is then
> shouldn't we call port->serial->type->open() afterwards?  Otherwise
> the lower driver can't know that the port is still open.
> 
> Furthermore, shouldn't we check ASYNCB_INITIALIZED in serial_close()?
> 
> Alan Stern

This time I had no crash (neither with ftdi nor with pl2302), possibly
a matter of what memory areas were affected...

Bruno


dmesg + lsmod as at end of dmesg log. First for ftdi device, second for
pl2302 device:

[  389.940038] usb 1-2: new full speed USB device using uhci_hcd and address 2
[  390.158982] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[  390.159202] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  390.159447] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[  390.159622] usb 1-2: Manufacturer: FTDI
[  390.159763] usb 1-2: SerialNumber: FTS55QK6
[  390.160160] usb 1-2: configuration #1 chosen from 1 choice
[  390.243200] usbcore: registered new interface driver usbserial
[  390.243309] usbserial: USB Serial Driver core
[  390.274397] USB Serial support registered for FTDI USB Serial Device
[  390.274888] usb 1-2: Ignoring serial port reserved for JTAG
[  390.275185] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[  390.275467] usb 1-2: Detected FT2232C
[  390.275589] usb 1-2: Number of endpoints 2
[  390.275740] usb 1-2: Endpoint 1 MaxPacketSize 64
[  390.275888] usb 1-2: Endpoint 2 MaxPacketSize 64
[  390.276052] usb 1-2: Setting MaxPacketSize 64
[  390.278136] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[  390.278435] usbcore: registered new interface driver ftdi_sio
[  390.278619] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  394.507447] usb_serial_get_by_index(index 0): @dd0b88a0
[  394.507642] ------------[ cut here ]------------
[  394.507836] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  394.508189] Hardware name: TravelMate 660
[  394.508334] Modules linked in: ftdi_sio usbserial usb_storage squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd i2c_i801 ehci_hcd uhci_hcd usbcore snd_page_alloc pcspkr crc_ccitt
[  394.509752] Pid: 3116, comm: minicom Tainted: G   M       2.6.31-rc6 #1
[  394.509959] Call Trace:
[  394.510089]  [<c12b7052>] ? printk+0x18/0x1e
[  394.510241]  [<df57b182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  394.510480]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  394.510660]  [<df57b182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  394.510894]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  394.511068]  [<df57b182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  394.511304]  [<df57b36d>] serial_open+0x2d/0x250 [usbserial]
[  394.511490]  [<c115f7b9>] ? tty_init_dev+0x89/0x160
[  394.511666]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  394.511815]  [<c1077566>] chrdev_open+0x96/0x140
[  394.511986]  [<c10732ff>] __dentry_open+0x9f/0x250
[  394.512144]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  394.512324]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  394.512478]  [<c107f889>] do_filp_open+0x269/0x890
[  394.512652]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  394.512812]  [<c10730c7>] do_sys_open+0x57/0x140
[  394.512983]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  394.513148]  [<c1073219>] sys_open+0x29/0x40
[  394.513306]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  394.513466] ---[ end trace a4862da83be6d4cc ]---
[  410.250064] usb 1-2: USB disconnect, address 2
[  410.250628] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  410.250935] usb_serial_put(serial @dd0b88a0)
[  410.251074] ------------[ cut here ]------------
[  410.251257] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  410.251586] Hardware name: TravelMate 660
[  410.251730] Modules linked in: ftdi_sio usbserial usb_storage squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd i2c_i801 ehci_hcd uhci_hcd usbcore snd_page_alloc pcspkr crc_ccitt
[  410.253139] Pid: 976, comm: khubd Tainted: G   M    W  2.6.31-rc6 #1
[  410.253339] Call Trace:
[  410.253448]  [<c12b7052>] ? printk+0x18/0x1e
[  410.253598]  [<df57aceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  410.253813]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  410.253992]  [<df57aceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  410.254202]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  410.254376]  [<df57aceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  410.254588]  [<df57af81>] usb_serial_disconnect+0xf1/0x160 [usbserial]
[  410.254835]  [<dea3f447>] ? usb_disable_interface+0x37/0x50 [usbcore]
[  410.255086]  [<dea42221>] usb_unbind_interface+0xf1/0x130 [usbcore]
[  410.255293]  [<c11b5441>] __device_release_driver+0x51/0xa0
[  410.255491]  [<c11b5540>] device_release_driver+0x20/0x40
[  410.255666]  [<c11b4aad>] bus_remove_device+0x7d/0xb0
[  410.255847]  [<c11b2ef2>] device_del+0x102/0x190
[  410.256025]  [<dea3f3a7>] usb_disable_device+0x87/0xf0 [usbcore]
[  410.256259]  [<dea3a8a6>] usb_disconnect+0x96/0xf0 [usbcore]
[  410.256469]  [<dea3b989>] hub_thread+0x829/0x1210 [usbcore]
[  410.256672]  [<c10357a0>] ? autoremove_wake_function+0x0/0x50
[  410.256882]  [<dea3b160>] ? hub_thread+0x0/0x1210 [usbcore]
[  410.257079]  [<c10353cc>] kthread+0x7c/0x90
[  410.257217]  [<c1035350>] ? kthread+0x0/0x90
[  410.257376]  [<c1003673>] kernel_thread_helper+0x7/0x14
[  410.257543] ---[ end trace a4862da83be6d4cd ]---
[  410.257708] ftdi_sio 1-2:1.1: device disconnected
[  410.258188] usb_serial_get_by_index(index 0): @dd0b88a0
[  410.258358] ------------[ cut here ]------------
[  410.258537] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  410.258887] Hardware name: TravelMate 660
[  410.259031] Modules linked in: ftdi_sio usbserial usb_storage squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd i2c_i801 ehci_hcd uhci_hcd usbcore snd_page_alloc pcspkr crc_ccitt
[  410.260453] Pid: 3116, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  410.260660] Call Trace:
[  410.260763]  [<c12b7052>] ? printk+0x18/0x1e
[  410.260912]  [<df57b182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  410.261161]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  410.261340]  [<df57b182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  410.261589]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  410.261763]  [<df57b182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  410.262012]  [<df57b36d>] serial_open+0x2d/0x250 [usbserial]
[  410.262198]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  410.262384]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  410.262531]  [<c1077566>] chrdev_open+0x96/0x140
[  410.262701]  [<c10732ff>] __dentry_open+0x9f/0x250
[  410.262859]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  410.263040]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  410.263194]  [<c107f889>] do_filp_open+0x269/0x890
[  410.263367]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  410.273068]  [<c10730c7>] do_sys_open+0x57/0x140
[  410.283083]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  410.293149]  [<c1073219>] sys_open+0x29/0x40
[  410.303259]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  410.313388] ---[ end trace a4862da83be6d4ce ]---
[  410.331134] tty_port_close_start: count = -1
[  410.335326] serial_do_free(port @d8c72400)
[  410.339451]   serial @dd0b88a0
[  410.343874]   type   @df5d8660
[  410.348150] usb_serial_put(serial @dd0b88a0)
[  410.352244] ------------[ cut here ]------------
[  410.356280] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  410.360483] Hardware name: TravelMate 660
[  410.364569] Modules linked in: ftdi_sio usbserial usb_storage squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd i2c_i801 ehci_hcd uhci_hcd usbcore snd_page_alloc pcspkr crc_ccitt
[  410.373535] Pid: 3116, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  410.377676] Call Trace:
[  410.381732]  [<c12b7052>] ? printk+0x18/0x1e
[  410.385770]  [<df57aceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  410.389857]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  410.393946]  [<df57aceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  410.398034]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  410.402115]  [<df57aceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  410.406209]  [<df57adb9>] serial_do_free+0x99/0xd0 [usbserial]
[  410.410283]  [<df57ae57>] serial_close+0x67/0xa0 [usbserial]
[  410.414352]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  410.418378]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  410.422426]  [<c102372e>] ? warn_slowpath_common+0x9e/0xc0
[  410.426440]  [<c10207e3>] ? __cond_resched+0x23/0x40
[  410.430475]  [<c12b7555>] ? _cond_resched+0x25/0x40
[  410.434478]  [<c12b7d7e>] ? mutex_lock+0xe/0x20
[  410.438499]  [<df57b3a9>] ? serial_open+0x69/0x250 [usbserial]
[  410.442530]  [<c115fced>] tty_open+0x45d/0x4b0
[  410.446533]  [<c1077566>] chrdev_open+0x96/0x140
[  410.450546]  [<c10732ff>] __dentry_open+0x9f/0x250
[  410.454546]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  410.458525]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  410.462523]  [<c107f889>] do_filp_open+0x269/0x890
[  410.466498]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  410.470499]  [<c10730c7>] do_sys_open+0x57/0x140
[  410.474455]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  410.478424]  [<c1073219>] sys_open+0x29/0x40
[  410.482384]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  410.486332] ---[ end trace a4862da83be6d4cf ]---
[  518.992741] serial_do_free(port @d8c72400)
[  518.992888]   serial @dd0b88a0
[  518.993010]   type   @df5d8660
[  518.993115] usb_serial_put(serial @dd0b88a0)
[  518.993268] ------------[ cut here ]------------
[  518.993435] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  518.993794] Hardware name: TravelMate 660
[  518.993923] Modules linked in: ftdi_sio usbserial usb_storage squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd i2c_i801 ehci_hcd uhci_hcd usbcore snd_page_alloc pcspkr crc_ccitt
[  518.995333] Pid: 3116, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  518.995571] Call Trace:
[  518.995665]  [<c12b7052>] ? printk+0x18/0x1e
[  518.995830]  [<df57aceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  518.996029]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  518.996225]  [<df57aceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  518.996419]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  518.996609]  [<df57aceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  518.996804]  [<df57adb9>] serial_do_free+0x99/0xd0 [usbserial]
[  518.997016]  [<df57ae57>] serial_close+0x67/0xa0 [usbserial]
[  518.997200]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  518.997369]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  518.997539]  [<c1056d72>] ? put_page+0x42/0x120
[  518.997708]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  518.997875]  [<c115f64a>] tty_release+0xa/0x10
[  518.998037]  [<c1075f1c>] __fput+0xdc/0x1d0
[  518.998174]  [<c107602f>] fput+0x1f/0x30
[  518.998323]  [<c1072f8e>] filp_close+0x3e/0x70
[  518.998470]  [<c1024fa2>] put_files_struct+0xa2/0xc0
[  518.998648]  [<c1024fdc>] exit_files+0x1c/0x20
[  518.998795]  [<c1026339>] do_exit+0xb9/0x630
[  518.998954]  [<c103acd8>] ? __put_cred+0x18/0x20
[  518.999107]  [<c10268dd>] do_group_exit+0x2d/0x80
[  518.999277]  [<c1026943>] sys_exit_group+0x13/0x20
[  518.999434]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  518.999610] ---[ end trace a4862da83be6d4d0 ]---
[  518.999758] destroy_serial(kref @dd0b88d4)
[  518.999905]   serial @dd0b88a0

Module                  Size  Used by
ftdi_sio               51372  4294967295 
usbserial              31164  1 ftdi_sio
usb_storage            49504  0 
squashfs               20936  1 
zlib_inflate           16164  1 squashfs
nfs                   141068  0 
lockd                  65768  1 nfs
nfs_acl                 2884  1 nfs
sunrpc                170044  3 nfs,lockd,nfs_acl
8021q                  19872  0 
snd_pcm_oss            36096  0 
snd_mixer_oss          14564  1 snd_pcm_oss
xfs                   483008  1 
exportfs                3844  1 xfs
loop                   14352  2 
snd_intel8x0           29792  0 
nsc_ircc               16112  0 
snd_ac97_codec        101540  1 snd_intel8x0
ac97_bus                1540  1 snd_ac97_codec
irda                  101496  1 nsc_ircc
snd_pcm                60524  3 snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              18344  1 snd_pcm
snd                    48772  6 snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
i2c_i801                8500  0 
ehci_hcd               33972  0 
uhci_hcd               21876  0 
usbcore               133920  5 ftdi_sio,usbserial,usb_storage,ehci_hcd,uhci_hcd
snd_page_alloc          8044  2 snd_intel8x0,snd_pcm
pcspkr                  2276  0 
crc_ccitt               1796  1 irda




[  691.010035] usb 1-1: new full speed USB device using uhci_hcd and address 2
[  691.176987] usb 1-1: New USB device found, idVendor=067b, idProduct=2303
[  691.177206] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  691.177451] usb 1-1: Product: USB-Serial Controller
[  691.177608] usb 1-1: Manufacturer: Prolific Technology Inc.
[  691.178025] usb 1-1: configuration #1 chosen from 1 choice
[  691.254399] usbcore: registered new interface driver usbserial
[  691.254507] usbserial: USB Serial Driver core
[  691.274470] USB Serial support registered for pl2303
[  691.274732] pl2303 1-1:1.0: pl2303 converter detected
[  691.286169] usb 1-1: pl2303 converter now attached to ttyUSB0
[  691.286430] usbcore: registered new interface driver pl2303
[  691.286610] pl2303: Prolific PL2303 USB to serial adaptor driver
[  702.598739] usb_serial_get_by_index(index 0): @da6a3780
[  702.598931] ------------[ cut here ]------------
[  702.599124] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  702.599476] Hardware name: TravelMate 660
[  702.599621] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec ac97_bus nsc_ircc irda snd_pcm snd_timer snd ehci_hcd pcspkr i2c_i801 uhci_hcd snd_page_alloc crc_ccitt usbcore
[  702.601064] Pid: 2528, comm: minicom Tainted: G   M       2.6.31-rc6 #1
[  702.601272] Call Trace:
[  702.601383]  [<c12b7052>] ? printk+0x18/0x1e
[  702.601532]  [<deb16182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  702.601771]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  702.601950]  [<deb16182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  702.602198]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  702.602372]  [<deb16182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  702.602621]  [<deb1636d>] serial_open+0x2d/0x250 [usbserial]
[  702.602806]  [<c115f7b9>] ? tty_init_dev+0x89/0x160
[  702.602981]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  702.603129]  [<c1077566>] chrdev_open+0x96/0x140
[  702.603300]  [<c10732ff>] __dentry_open+0x9f/0x250
[  702.603457]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  702.603637]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  702.603793]  [<c107f889>] do_filp_open+0x269/0x890
[  702.603966]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  702.604126]  [<c10730c7>] do_sys_open+0x57/0x140
[  702.604296]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  702.604461]  [<c1073219>] sys_open+0x29/0x40
[  702.604619]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  702.604779] ---[ end trace 11618bfb3543f78d ]---
[  733.750062] usb 1-1: USB disconnect, address 2
[  733.751174] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[  733.751434] usb_serial_put(serial @da6a3780)
[  733.751573] ------------[ cut here ]------------
[  733.751756] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  733.752096] Hardware name: TravelMate 660
[  733.752241] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec ac97_bus nsc_ircc irda snd_pcm snd_timer snd ehci_hcd pcspkr i2c_i801 uhci_hcd snd_page_alloc crc_ccitt usbcore
[  733.753645] Pid: 956, comm: khubd Tainted: G   M    W  2.6.31-rc6 #1
[  733.753846] Call Trace:
[  733.753954]  [<c12b7052>] ? printk+0x18/0x1e
[  733.754103]  [<deb15ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  733.754317]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  733.754497]  [<deb15ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  733.754707]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  733.754880]  [<deb15ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  733.755092]  [<deb15f81>] usb_serial_disconnect+0xf1/0x160 [usbserial]
[  733.755339]  [<dea0c447>] ? usb_disable_interface+0x37/0x50 [usbcore]
[  733.755590]  [<dea0f221>] usb_unbind_interface+0xf1/0x130 [usbcore]
[  733.755797]  [<c11b5441>] __device_release_driver+0x51/0xa0
[  733.755994]  [<c11b5540>] device_release_driver+0x20/0x40
[  733.756169]  [<c11b4aad>] bus_remove_device+0x7d/0xb0
[  733.756349]  [<c11b2ef2>] device_del+0x102/0x190
[  733.756528]  [<dea0c3a7>] usb_disable_device+0x87/0xf0 [usbcore]
[  733.756762]  [<dea078a6>] usb_disconnect+0x96/0xf0 [usbcore]
[  733.756971]  [<dea08989>] hub_thread+0x829/0x1210 [usbcore]
[  733.757175]  [<c10357a0>] ? autoremove_wake_function+0x0/0x50
[  733.757386]  [<dea08160>] ? hub_thread+0x0/0x1210 [usbcore]
[  733.757584]  [<c10353cc>] kthread+0x7c/0x90
[  733.757722]  [<c1035350>] ? kthread+0x0/0x90
[  733.757881]  [<c1003673>] kernel_thread_helper+0x7/0x14
[  733.758049] ---[ end trace 11618bfb3543f78e ]---
[  733.758213] pl2303 1-1:1.0: device disconnected
[  733.759141] usb_serial_get_by_index(index 0): @da6a3780
[  733.759316] ------------[ cut here ]------------
[  733.759497] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  733.759847] Hardware name: TravelMate 660
[  733.759992] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec ac97_bus nsc_ircc irda snd_pcm snd_timer snd ehci_hcd pcspkr i2c_i801 uhci_hcd snd_page_alloc crc_ccitt usbcore
[  733.761423] Pid: 2528, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  733.761660] Call Trace:
[  733.761750]  [<c12b7052>] ? printk+0x18/0x1e
[  733.761914]  [<deb16182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  733.762133]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  733.762329]  [<deb16182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  733.762547]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  733.762737]  [<deb16182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  733.762957]  [<deb1636d>] serial_open+0x2d/0x250 [usbserial]
[  733.763159]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  733.763328]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  733.763492]  [<c1077566>] chrdev_open+0x96/0x140
[  733.763647]  [<c10732ff>] __dentry_open+0x9f/0x250
[  733.763821]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  733.763985]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  733.764155]  [<c107f889>] do_filp_open+0x269/0x890
[  733.764313]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  733.773926]  [<c10730c7>] do_sys_open+0x57/0x140
[  733.783856]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  733.793832]  [<c1073219>] sys_open+0x29/0x40
[  733.803856]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  733.813897] ---[ end trace 11618bfb3543f78f ]---
[  733.829386] tty_port_close_start: count = -1
[  733.930036] serial_do_free(port @dd86ae00)
[  733.940088]   serial @da6a3780
[  733.950089]   type   @deb25c20
[  733.960455] usb_serial_put(serial @da6a3780)
[  733.964507] ------------[ cut here ]------------
[  733.968561] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  733.973026] Hardware name: TravelMate 660
[  733.977130] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec ac97_bus nsc_ircc irda snd_pcm snd_timer snd ehci_hcd pcspkr i2c_i801 uhci_hcd snd_page_alloc crc_ccitt usbcore
[  733.986053] Pid: 2528, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  733.990213] Call Trace:
[  733.994262]  [<c12b7052>] ? printk+0x18/0x1e
[  733.998300]  [<deb15ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  734.002543]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  734.006612]  [<deb15ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  734.010724]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  734.014796]  [<deb15ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  734.018898]  [<deb15db9>] serial_do_free+0x99/0xd0 [usbserial]
[  734.022988]  [<deb15e57>] serial_close+0x67/0xa0 [usbserial]
[  734.027062]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  734.031105]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  734.035140]  [<c102372e>] ? warn_slowpath_common+0x9e/0xc0
[  734.039158]  [<c10207e3>] ? __cond_resched+0x23/0x40
[  734.043201]  [<c12b7555>] ? _cond_resched+0x25/0x40
[  734.047213]  [<c12b7d7e>] ? mutex_lock+0xe/0x20
[  734.051243]  [<deb163a9>] ? serial_open+0x69/0x250 [usbserial]
[  734.055258]  [<c115fced>] tty_open+0x45d/0x4b0
[  734.059281]  [<c1077566>] chrdev_open+0x96/0x140
[  734.063302]  [<c10732ff>] __dentry_open+0x9f/0x250
[  734.067307]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  734.071304]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  734.075288]  [<c107f889>] do_filp_open+0x269/0x890
[  734.079264]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  734.083275]  [<c10730c7>] do_sys_open+0x57/0x140
[  734.087234]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  734.091225]  [<c1073219>] sys_open+0x29/0x40
[  734.095170]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  734.099124] ---[ end trace 11618bfb3543f790 ]---
[  834.133234] serial_do_free(port @dd86ae00)
[  834.133379]   serial @da6a3780
[  834.133499]   type   @deb25c20
[  834.133621] usb_serial_put(serial @da6a3780)
[  834.133757] ------------[ cut here ]------------
[  834.133939] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  834.134266] Hardware name: TravelMate 660
[  834.134410] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec ac97_bus nsc_ircc irda snd_pcm snd_timer snd ehci_hcd pcspkr i2c_i801 uhci_hcd snd_page_alloc crc_ccitt usbcore
[  834.135811] Pid: 2528, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  834.136018] Call Trace:
[  834.136127]  [<c12b7052>] ? printk+0x18/0x1e
[  834.136276]  [<deb15ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  834.136489]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  834.136669]  [<deb15ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  834.136878]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  834.137051]  [<deb15ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  834.137262]  [<deb15db9>] serial_do_free+0x99/0xd0 [usbserial]
[  834.137457]  [<deb15e57>] serial_close+0x67/0xa0 [usbserial]
[  834.137658]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  834.137810]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  834.137995]  [<c1056d72>] ? put_page+0x42/0x120
[  834.138148]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  834.138331]  [<c115f64a>] tty_release+0xa/0x10
[  834.138477]  [<c1075f1c>] __fput+0xdc/0x1d0
[  834.138630]  [<c107602f>] fput+0x1f/0x30
[  834.138763]  [<c1072f8e>] filp_close+0x3e/0x70
[  834.138926]  [<c1024fa2>] put_files_struct+0xa2/0xc0
[  834.139088]  [<c1024fdc>] exit_files+0x1c/0x20
[  834.139251]  [<c1026339>] do_exit+0xb9/0x630
[  834.139393]  [<c103acd8>] ? __put_cred+0x18/0x20
[  834.139562]  [<c10268dd>] do_group_exit+0x2d/0x80
[  834.139717]  [<c1026943>] sys_exit_group+0x13/0x20
[  834.139890]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  834.140084] ---[ end trace 11618bfb3543f791 ]---
[  834.141308] destroy_serial(kref @da6a37b4)
[  834.141366]   serial @da6a3780

Module                  Size  Used by
pl2303                 16808  4294967295 
usbserial              31164  1 pl2303
squashfs               20936  1 
zlib_inflate           16164  1 squashfs
nfs                   141068  0 
lockd                  65768  1 nfs
nfs_acl                 2884  1 nfs
sunrpc                170044  3 nfs,lockd,nfs_acl
8021q                  19872  0 
snd_pcm_oss            36096  0 
snd_mixer_oss          14564  1 snd_pcm_oss
xfs                   483008  1 
exportfs                3844  1 xfs
loop                   14352  2 
usb_storage            49504  0 
snd_intel8x0           29792  0 
snd_ac97_codec        101540  1 snd_intel8x0
ac97_bus                1540  1 snd_ac97_codec
nsc_ircc               16112  0 
irda                  101496  1 nsc_ircc
snd_pcm                60524  3 snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              18344  1 snd_pcm
snd                    48772  6 snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
ehci_hcd               33972  0 
pcspkr                  2276  0 
i2c_i801                8500  0 
uhci_hcd               21876  0 
snd_page_alloc          8044  2 snd_intel8x0,snd_pcm
crc_ccitt               1796  1 irda
usbcore               133920  5 pl2303,usbserial,usb_storage,ehci_hcd,uhci_hcd



