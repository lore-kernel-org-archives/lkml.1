Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZIGRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZIGRu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZIGRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:50:27 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37334 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbZIGRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:50:26 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, alan@linux.intel.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0909071101010.7175-100000@netrider.rowland.org>
	(message from Alan Stern on Mon, 7 Sep 2009 11:08:25 -0400 (EDT))
Subject: Re: WARNINGs in usb-serial.c
References: <Pine.LNX.4.44L0.0909071101010.7175-100000@netrider.rowland.org>
Message-Id: <E1MkiMA-0000vX-5L@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Sep 2009 19:50:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Alan Stern wrote:
> On Mon, 7 Sep 2009, Miklos Szeredi wrote:
> 
> > Here's a reproducible Oops on that kernel when trying to connect with
> > wvdial.  This is a regression compared to -linus, where wvdial works
> > (most of the time anyway).
> > 
> > I can bisect it if it's not immediately obvious what is happening...
> 
> I don't think bisecting will help (or is even possible).
> 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> > IP: [<ffffffffa020709c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
> 
> It's difficult to say without an assembly listing, but I gather that
> serial_chars_in_buffer() is seeing port->serial == NULL.  Can you
> verify this?

Yes, that is the case.

> This is unexpected, because port->serial is initialized in
> usb_serial_probe() and is not set to NULL until destroy_serial(), after
> which port should not be used at all.  Can you add a
> 
> #define DEBUG
> 
> line at the start of usb-serial.c (before the #include lines) so that
> we can tell if destroy_serial() is getting called too early?  When you
> do, post the dmesg log showing everything from the time you start
> running your test.

drivers/usb/serial/usb-serial.c: serial_install
drivers/usb/serial/usb-serial.c: serial_open - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x541e
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5402
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5402
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_tiocmget - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5402
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 5 byte(s)
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 4 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 13 byte(s)
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 28 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
PPP generic driver version 2.4.2
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_open - port 0
drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_open - port 0
drivers/usb/serial/usb-serial.c: destroy_serial - GSM modem (1-port)
drivers/usb/serial/usb-serial.c: return_serial
drivers/usb/serial/usb-serial.c: serial_close - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/class/rfkill/rfkill2/state
CPU 0 
Modules linked in: ppp_generic slhc usb_storage option usbserial bnep sco rfcomm l2cap acpi_cpufreq nf_conntrack_netbios_ns microcode fuse iwl3945 iwlcore mac80211 thinkpad_acpi backlight btusb ac led_class nsc_ircc bluetooth cfg80211 button battery processor thermal irda uinput rfkill e1000e crc_ccitt
Pid: 5139, comm: pppd Not tainted 2.6.31-rc8-gkh-00038-g37d0892-dirty #42 2007FUG
RIP: 0010:[<ffffffffa01ca09c>]  [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
RSP: 0018:ffff88009cc17d78  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800b5d7a800 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88009cc17ca7
RBP: ffff88009cc17d88 R08: 0000000000000082 R09: ffffffff8105d685
R10: 0000000000000082 R11: 0000000000018600 R12: ffff8800b64af000
R13: ffff8800b64af000 R14: ffff8800b64af000 R15: ffff8800b64af000
FS:  00007ff05244d6f0(0000) GS:ffff880001f45000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 000000009cc95000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pppd (pid: 5139, threadinfo ffff88009cc16000, task ffff8800a89f4040)
Stack:
 ffff8800a547c940 7fffffffffffffff ffff88009cc17d98 ffffffff811c7aa2
<0> ffff88009cc17e08 ffffffff811c7ff7 ffff88009cc17df8 0000000000000046
<0> ffff8800a89f4040 ffffffff810c9f8a ffff8800aa902200 ffff8800bf840bc0
Call Trace:
 [<ffffffff811c7aa2>] tty_chars_in_buffer+0x1a/0x1c
 [<ffffffff811c7ff7>] tty_wait_until_sent+0x32/0xfc
 [<ffffffff810c9f8a>] ? kmem_cache_free+0x118/0x18b
 [<ffffffff811c3aa4>] tty_ioctl+0xa6/0x891
 [<ffffffff810dba8e>] vfs_ioctl+0x2f/0x7d
 [<ffffffff810dc00b>] do_vfs_ioctl+0x4af/0x4ec
 [<ffffffff810cf9ce>] ? fget+0x0/0x127
 [<ffffffff8100b1cc>] ? sysret_check+0x27/0x62
 [<ffffffff810dc08f>] sys_ioctl+0x47/0x6a
 [<ffffffff8100b19b>] system_call_fastpath+0x16/0x1b
Code: 00 74 23 0f b6 8b 50 02 00 00 48 c7 c2 20 dc 1c a0 48 c7 c6 67 e0 1c a0 48 c7 c7 87 e0 1c a0 31 c0 e8 93 76 15 e1 48 8b 13 31 c0 <f6> 42 18 01 75 0d 48 8b 42 08 4c 89 e7 ff 90 58 01 00 00 5b 41 
RIP  [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
 RSP <ffff88009cc17d78>
CR2: 0000000000000018
---[ end trace ef2106e42e2196ab ]---
