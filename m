Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZHYUaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZHYUaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbZHYUaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:30:12 -0400
Received: from ppp-152-237.adsl.restena.lu ([158.64.152.237]:55412 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbZHYUaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:30:10 -0400
Date: Tue, 25 Aug 2009 22:19:18 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090825221918.4de9e30f@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.0908242116180.17556-100000@netrider.rowland.org>
References: <20090824221508.055cfbc6@neptune.home>
	<Pine.LNX.4.44L0.0908242116180.17556-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> Apparently the tty isn't getting removed from the driver the way it
> should when minicom closes it the first time.  And no wonder -- I just
> realized that my new serial_shutdown() routine doesn't call
> tty_shutdown(tty).  Try inserting such a call right before
> tty->driver_data gets set to NULL.

Done that, it brings us to n_tty_set_termios() this time:

[  107.990039] usb 2-2: new full speed USB device using uhci_hcd and address 2
[  108.208982] usb 2-2: New USB device found, idVendor=9e88, idProduct=9e8f
[  108.208992] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  108.209000] usb 2-2: Product: SheevaPlug JTAGKey FT2232D B
[  108.209007] usb 2-2: Manufacturer: FTDI
[  108.209013] usb 2-2: SerialNumber: FTS55QK6
[  108.209243] usb 2-2: configuration #1 chosen from 1 choice
[  108.323938] usbcore: registered new interface driver usbserial
[  108.323943] usbserial: USB Serial Driver core
[  108.357581] USB Serial support registered for FTDI USB Serial Device
[  108.357819] usb 2-2: Ignoring serial port reserved for JTAG
[  108.357924] ftdi_sio 2-2:1.1: FTDI USB Serial Device converter detected
[  108.357990] usb 2-2: Detected FT2232C
[  108.357996] usb 2-2: Number of endpoints 2
[  108.358003] usb 2-2: Endpoint 1 MaxPacketSize 64
[  108.358009] usb 2-2: Endpoint 2 MaxPacketSize 64
[  108.358015] usb 2-2: Setting MaxPacketSize 64
[  108.360175] usb 2-2: FTDI USB Serial Device converter now attached to ttyUSB0
[  108.360216] usbcore: registered new interface driver ftdi_sio
[  108.360223] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  200.248102] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[  200.248257] IP: [<c115ff36>] n_tty_set_termios+0x1a6/0x410
[  200.248369] *pde = 00000000 
[  200.248429] Oops: 0000 [#1] 
[  200.248489] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  200.248607] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec nsc_ircc ac97_bus irda snd_pcm pcspkr i2c_i801 snd_timer uhci_hcd ehci_hcd snd snd_page_alloc crc_ccitt usbcore
[  200.249280] 
[  200.249317] Pid: 2155, comm: minicom Tainted: G   M       (2.6.31-rc6-gregkh #2) TravelMate 660
[  200.249466] EIP: 0060:[<c115ff36>] EFLAGS: 00010246 CPU: 0
[  200.249563] EIP is at n_tty_set_termios+0x1a6/0x410
[  200.249649] EAX: 00000000 EBX: dbdd9000 ECX: 00000000 EDX: 00000000
[  200.249757] ESI: 00000000 EDI: 00000000 EBP: dd2dade8 ESP: dd2dadd8
[  200.249866]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  200.249962] Process minicom (pid: 2155, ti=dd2da000 task=dd91b500 task.ti=dd2da000)
[  200.250090] Stack:
[  200.250129]  c11616ab dbdd9000 dbdd9000 00000000 dd2dadf4 c11617db dbaf20e8 dd2dae04
[  200.250312] <0> c1164280 dbdd9000 dbdd9000 dd2dae20 c1164432 dbaf20e8 dbdd9000 dbdd9000
[  200.250514] <0> db953a80 dbdd9000 dd2dae44 c115f5b9 dd2dae7c dd2daef4 00000000 00000000
[  200.250722] Call Trace:
[  200.250773]  [<c11616ab>] ? reset_buffer_flags+0xab/0xe0
[  200.250870]  [<c11617db>] ? n_tty_open+0x3b/0x90
[  200.250954]  [<c1164280>] ? tty_ldisc_open+0x30/0x50
[  200.251044]  [<c1164432>] ? tty_ldisc_setup+0x22/0x70
[  200.251135]  [<c115f5b9>] ? tty_init_dev+0x89/0x160
[  200.251223]  [<c115f9fc>] ? tty_open+0x36c/0x4b0
[  200.251310]  [<c1077246>] ? chrdev_open+0x96/0x140
[  200.251400]  [<c1072fdf>] ? __dentry_open+0x9f/0x250
[  200.251490]  [<c1073279>] ? nameidata_to_filp+0x59/0x70
[  200.251584]  [<c10771b0>] ? chrdev_open+0x0/0x140
[  200.251672]  [<c107f569>] ? do_filp_open+0x269/0x890
[  200.251762]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  200.251852]  [<c1072da7>] ? do_sys_open+0x57/0x140
[  200.251943]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  200.252035]  [<c1072ef9>] ? sys_open+0x29/0x40
[  200.252116]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  200.252205] Code: 31 c0 f3 ab 0f b6 93 2c 01 00 00 31 f6 8b 83 60 01 00 00 8b 7b 30 89 b3 74 03 00 00 80 e2 fd 89 83 78 03 00 00 88 93 2c 01 00 00 <8b> 47 0c 83 e0 02 0f 85 8a fe ff ff 8b 8b 64 01 00 00 85 c9 0f 
[  200.252995] EIP: [<c115ff36>] n_tty_set_termios+0x1a6/0x410 SS:ESP 0068:dd2dadd8
[  200.253134] CR2: 000000000000000c
[  200.253225] ---[ end trace f4b79a25ac2c3be9 ]---

My actions:
  plug-in ftdi
  run minicom
  exit minicom
  run minicom -> bang

Bang at:
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1456

1449:	if (canon_change) {
1450:		memset(&tty->read_flags, 0, sizeof tty->read_flags);
1451:		tty->canon_head = tty->read_tail;
1452:		tty->canon_data = 0;
1453:		tty->erasing = 0;
1454:	}
1455:
1456:	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
1457:		wake_up_interruptible(&tty->read_wait);

Not sure which part of the if() it is that explodes, I would guess
it's !L_ICANON(tty):

	#define ICANON      0000002
	#define _L_FLAG(tty, f) ((tty)->termios->c_lflag & (f))
	#define L_ICANON(tty)  _L_FLAG((tty), ICANON)
=>
	if (canon_change && !((tty)->termios->c_lflag & (ICANON)) && tty->read_cnt)
=>
	tty->termios is probably NULL


Anyhow, here is the matching extract of objdump for n_tty.o:
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1453
     37f:       0f b6 93 2c 01 00 00    movzbl 0x12c(%ebx),%edx
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1452
     386:       31 f6                   xor    %esi,%esi
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1451
     388:       8b 83 60 01 00 00       mov    0x160(%ebx),%eax
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1456
     38e:       8b 7b 30                mov    0x30(%ebx),%edi
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1452
     391:       89 b3 74 03 00 00       mov    %esi,0x374(%ebx)
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1453
     397:       80 e2 fd                and    $0xfd,%dl
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1451
     39a:       89 83 78 03 00 00       mov    %eax,0x378(%ebx)
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1453
     3a0:       88 93 2c 01 00 00       mov    %dl,0x12c(%ebx)
/tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1456
>    3a6:       8b 47 0c                mov    0xc(%edi),%eax
     3a9:       83 e0 02                and    $0x2,%eax
     3ac:       0f 85 8a fe ff ff       jne    23c <n_tty_set_termios+0x3c>
     3b2:       8b 8b 64 01 00 00       mov    0x164(%ebx),%ecx
     3b8:       85 c9                   test   %ecx,%ecx
     3ba:       0f 84 7c fe ff ff       je     23c <n_tty_set_termios+0x3c>



Some further notes:
- disconnect causes the device to vanish and minicom to tell so.
  Quit minicom works without complaint. Any restart produces
  the same effect as above
- after this trace some lock remains taken that causes processes
  to stall (processes ending up in D state)
- when booting with this kernel some part of the init sequence
  never shows up on screen (e.g. everything from init's runlevel
  3 is missing and getty's prompt shows up with some delay compared
  to gettys on other VTs.


Bruno
