Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZGUSgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZGUSgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZGUSgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:36:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37870 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751134AbZGUSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:36:41 -0400
Date: Tue, 21 Jul 2009 14:36:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090721171625.6e2c54e4@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907211423420.2088-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Alan Cox wrote:

> A tty getting destructed before it should have been would perhaps do some
> of it but it doesn't explain how the close path got where it did.
> 
> What should be occurring is
> 
> 	USB disconnect
> 		usb_serial_disconnect(interface)
> 		tty_hangup(tty)   [this is buggy and commented as such in
> 		the USB code as it should do it synchronously]

I'll change it to tty_vhangup(tty) eventually.

> 	tty_hangup()
> 	do_tty_hangup()
> 	file->f_ops = &hung_up_tty_ops;
> 
> 		(so the USB close will never be called)

That doesn't make sense.  The driver's open method has been called, so 
of course the driver expects its close method to be called.

> 	ldisc hangup
> 	tty->ops->hangup (no-op on USB serial)

What do you mean?  There is a serial_hangup method in usb-serial.c
and it does get called; see below.

> so the trace to me implies that the usb_serial_disconnect is not
> happening. That in turn leads the close method to be called on a
> disconnected port which in turn crashes stuff.

No, you're wrong.  Here is a log with some extra debugging lines added:

Open /dev/ttyUSB0:
[  278.680845] opening ttyUSB0...
[  278.689268] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 1, phase 0, 19 us
[  278.690246] pl2303 ttyUSB0: serial_open port 0 (ef7fd920), refcount 6
[  278.696682] opening tty2...
[  278.696766] tty_release_dev of tty2 (tty count=2)...
[  278.699716] opening tty2...

Unplug the pl2303 device (a bunch of uninteresting USB messages have 
been left out):
[  283.618244] usb 2-2: unregistering interface 2-2:1.0
[  283.618864] pl2303 ttyUSB0: serial_disconnect port 0, refcount 6

The line above was inserted in serial_disconnect.

[  283.618958] ttyUSB0 hangup...
[  283.619722] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[  283.619974] pl2303 2-2:1.0: device disconnected
[  283.620244] usb 2-2:1.0: uevent
[  283.621302] usb 2-2: uevent
[  283.623660] usb-serial ttyUSB0: serial_hangup port 0, refcount 2

The line above was inserted in serial_hangup, as was the following
stack dump.

[  283.623765] Pid: 6, comm: events/0 Not tainted 2.6.31-rc3 #2
[  283.623859] Call Trace:
[  283.623954]  [<c11c0111>] ? printk+0xf/0x11
[  283.624088]  [<f08b09d7>] serial_hangup+0x45/0x66 [usbserial]
[  283.624187]  [<c112018c>] do_tty_hangup+0x28c/0x2b9
[  283.624282]  [<c102e6fe>] worker_thread+0x168/0x247
[  283.624374]  [<c102e6b9>] ? worker_thread+0x123/0x247
[  283.624466]  [<c111ff00>] ? do_tty_hangup+0x0/0x2b9
[  283.624560]  [<c1031b57>] ? autoremove_wake_function+0x0/0x33
[  283.624653]  [<c102e596>] ? worker_thread+0x0/0x247
[  283.624744]  [<c10318f1>] kthread+0x69/0x6e
[  283.624834]  [<c1031888>] ? kthread+0x0/0x6e
[  283.624926]  [<c10034ef>] kernel_thread_helper+0x7/0x10
[  283.625144] usb-serial ttyUSB0: serial_do_free port 0, refcount 2
[  283.625314] usb-serial ttyUSB0: destroy_serial port 0, refcount 1
[  283.625408] port_free port 0, refcount 0

Close the open file descriptor:
[  291.227977] tty_release_dev of tty2 (tty count=2)...
[  291.230492] tty_release_dev of ttyUSB0 (tty count=1)...
[  291.230630] serial_close port 107 (ef7fd920)

That line was inserted in serial_close.  As you can see, the port 
number is wrong because the port structure has already been 
deallocated by port_free.  And that leads to the following corruption.

[  291.230772] ------------[ cut here ]------------
[  291.230943] WARNING: at kernel/lockdep.c:2621 __lock_acquire+0x395/0xaf5()
[  291.231037] Hardware name:         
[  291.231123] Modules linked in: pl2303 usbserial pcspkr evdev e100 mii ohci_hcd ehci_hcd uhci_hcd floppy processor button thermal_sys usbcore [last unloaded: scsi_wait_scan]
[  291.231901] Pid: 2037, comm: cat Not tainted 2.6.31-rc3 #2
[  291.231990] Call Trace:
[  291.232042]  [<c1021718>] warn_slowpath_common+0x60/0x90
[  291.232042]  [<c1021755>] warn_slowpath_null+0xd/0x10
[  291.232042]  [<c103ed98>] __lock_acquire+0x395/0xaf5
[  291.232042]  [<c1021ca4>] ? release_console_sem+0x197/0x1c4
[  291.232042]  [<c103f540>] lock_acquire+0x48/0x64
[  291.232042]  [<c112689c>] ? tty_port_close_start+0x1a/0x118
[  291.232042]  [<c11c227f>] _spin_lock_irqsave+0x2e/0x3e
[  291.232042]  [<c112689c>] ? tty_port_close_start+0x1a/0x118
[  291.232042]  [<c112689c>] tty_port_close_start+0x1a/0x118
[  291.232042]  [<f08b0a5a>] serial_close+0x62/0x91 [usbserial]
[  291.232042]  [<c1120c2b>] tty_release_dev+0x191/0x41f
[  291.232042]  [<c103d28e>] ? register_lock_class+0x17/0x272
[  291.232042]  [<c1120ecb>] tty_release+0x12/0x1c
[  291.232042]  [<c107201f>] __fput+0xe9/0x172
[  291.232042]  [<c10720c1>] fput+0x19/0x1c
[  291.232042]  [<c106f93c>] filp_close+0x51/0x5b
[  291.232042]  [<c106f9b0>] sys_close+0x6a/0xa4
[  291.232042]  [<c1002a08>] sysenter_do_call+0x12/0x36
[  291.232042] ---[ end trace 5e364c88669fab14 ]---
[  291.233897] freeing tty structure...

Does this help pin down the source of the problem?

Alan Stern

