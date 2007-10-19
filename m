Return-Path: <linux-kernel-owner+w=401wt.eu-S1764442AbXJSP7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764442AbXJSP7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXJSP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:59:40 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47116 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbXJSP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:59:39 -0400
Message-ID: <4718D469.2080606@lwfinger.net>
Date: Fri, 19 Oct 2007 10:59:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net
Subject: Locking problem in usbserial with 2.6.23-git 5a34417f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While attempting to configure a new USB modem, the following locking problem occurred. In addition,
shortly after this problem occurred, the computer froze. The log data starts at the point that
usbserial was loaded and contains everything that was written to disk before the machine locked up.
Some info may be missing from the end of the stack dump.

The system is an HP laptop running an x86_64 system. NetworkManager was used to initiate the modem
connection.

Dump Contents:

usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbserial_generic 2-5:1.0: Generic device with no bulk out, not allowed.
usbserial_generic: probe of 2-5:1.0 failed with error -5
usbserial_generic 2-5:1.1: generic converter detected
usb 2-5: generic converter now attached to ttyUSB0
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
ifup:     modem1
interface modem1 is up
Plugin passwordfd.so loaded.
PPP generic driver version 2.4.2
pppd 2.4.4 started by root, uid 0

=================================
[ INFO: inconsistent lock state ]
2.6.23-Linus-g5a34417f-dirty #27
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&port->lock){+...}, at: [<ffffffff883f38bd>] usb_serial_generic_read_bulk_callback+0x104/0x179
[usbserial]
{hardirq-on-W} state was registered at:
  [<ffffffff8024eb9e>] mark_lock+0x8b/0x49a
  [<ffffffff8024fbab>] __lock_acquire+0x517/0xd4b
  [<ffffffff883f3b7f>] usb_serial_generic_write+0x8a/0x24f [usbserial]
  [<ffffffff80250464>] lock_acquire+0x85/0xa9
  [<ffffffff883f3b7f>] usb_serial_generic_write+0x8a/0x24f [usbserial]
  [<ffffffff803ea2f7>] _spin_lock_bh+0x34/0x41
  [<ffffffff883f3b7f>] usb_serial_generic_write+0x8a/0x24f [usbserial]
  [<ffffffff883f162e>] serial_write+0xb2/0xc1 [usbserial]
  [<ffffffff80340635>] write_chan+0x292/0x317
  [<ffffffff8022c1ce>] default_wake_function+0x0/0xf
  [<ffffffff8033dd45>] tty_write+0x102/0x20b
  [<ffffffff8033ddb0>] tty_write+0x16d/0x20b
  [<ffffffff803403a3>] write_chan+0x0/0x317
  [<ffffffff8028ef15>] vfs_write+0xae/0x137
  [<ffffffff8028f47e>] sys_write+0x47/0x70
  [<ffffffff8020c2fa>] tracesys+0xdc/0xe1
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 2973292
hardirqs last  enabled at (2973291): [<ffffffff8020adc6>] default_idle+0x35/0x51
hardirqs last disabled at (2973292): [<ffffffff803e9d54>] trace_hardirqs_off_thunk+0x35/0x37
softirqs last  enabled at (2973288): [<ffffffff80237add>] __do_softirq+0xe1/0xed
softirqs last disabled at (2973281): [<ffffffff8020d43c>] call_softirq+0x1c/0x28

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:

Call Trace:
<IRQ>  [<ffffffff8024e39d>] print_usage_bug+0x162/0x173
 [<ffffffff8024ebee>] mark_lock+0xdb/0x49a
 [<ffffffff8024fb3c>] __lock_acquire+0x4a8/0xd4b
 [<ffffffff883f38bd>] :usbserial:usb_serial_generic_read_bulk_callback+0x104/0x179
 [<ffffffff80250464>] lock_acquire+0x85/0xa9
 [<ffffffff883f38bd>] :usbserial:usb_serial_generic_read_bulk_callback+0x104/0x179
 [<ffffffff803ea2b6>] _spin_lock+0x2f/0x3c
 [<ffffffff883f38bd>] :usbserial:usb_serial_generic_read_bulk_callback+0x104/0x179
 [<ffffffff880c516b>] :usbcore:usb_hcd_giveback_urb+0x84/0x
 [<ffffffff88105578>] :ohci_hcd:finish_urb+0x74/0xb6
 [<ffffffff881055fc>] :ohci_hcd:takeback_td+0x42/0xb5
 [<ffffffff8810579a>] :ohci_hcd:dl_done_list+0x12b/0x13c
 [<ffffffff88107ce3>] :ohci_hcd:ohci_irq+0x19a/0x2d6
 [<ffffffff880c5441>] :usbcore:usb_hcd_irq+0x2c/0x5d
 [<ffffffff802663b5>] handle_IRQ_event+0x20/0x55
 [<ffffffff80267767>] handle_fasteoi_irq+0x9c/0xdc
 [<ffffffff8020ad91>] default_idle+0x0/0x51
 [<ffffffff8020f475>] do_IRQ+0x70/0xd7
 [<ffffffff8020ad91>] default_idle+0x0/0x51
 [<ffffffff8020c706>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8020adc8>] default_idle+0x37/0x51
 [<ffffffff8020adc6>] default_idle+0x35/0x51
 [<ffffffff8020ae80>] cpu_idle+0x9e/0xd5
 [<ffffffff8021aae3>] start_secondary+0x34c/0x35d

Thanks,

Larry
