Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0BMT3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:29:39 -0500
Received: from mail001.aei.ca ([206.123.6.130]:40736 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab0BMT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:29:37 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 0/2] Provide a driver for the Apple Magic Mouse - opps
Date: Sat, 13 Feb 2010 14:29:29 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <87y6j2eeqv.fsf_-_@troilus.org> <alpine.LNX.2.00.1002101456490.30967@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002101456490.30967@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131429.29671.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010 08:57:37 Jiri Kosina wrote:
> On Tue, 9 Feb 2010, Michael Poole wrote:
> 
> > I think this patch is ready for real review.  The Magic Mouse requires
> > that a driver send an unlock Report(Feature) command, similar to the
> > Wacom wireless tablet and Sixaxis controller quirks.  This turns on an
> > Input Report that isn't published in the input Report descriptor that
> > contains touch data (and usually overrides the normal motion and click
> > Report).
> > 
> > Because the mouse has only one switch and no scroll wheel, the driver
> > (under control of parameters) emulates a middle button and scroll wheel.
> > User space could also ignore and/or re-synthesize those events based on
> > the reported events.
> > 
> > The first patch exports hid_register_report() so the driver can turn on
> > the multitouch report.  The second patch adds the device ID and the
> > driver.  Some user-space tools to talk to the mouse directly (that is,
> > when it is not associated with the host's HIDP stack) are at
> > http://github.com/entrope/linux-magicmouse .
> 
> I have applied the driver into apple_magic_mouse branch and merged this 
> branch into for-next, so it should appear in the upcoming linux-next.

This driver (or the hid changes) can triggers an opps.  What I did was start X.  Turn on the magic mouse.  It connected on input7&8.  
Then I powered it off and on.  This time it conneced on input9&10.  Then I exited X and got the opps.  Note my X does not hotplug 
the magic mouse.  I've also included a trace of the udev events that generated the log below (if there was a remove after X stopped 
it would not be included).  To my eyes it looks like we leak an input device (there is not a remove event for input8).

[ 5955.908380] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7
[ 5955.921165] magicmouse 0005:05AC:030D.0004: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:0A:3A:55:07:5A
[ 5955.934120] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8
[ 6180.899332] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input9
[ 6180.911914] magicmouse 0005:05AC:030D.0005: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:0A:3A:55:07:5A
[ 6180.923988] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input10
[ 6391.991295] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 6391.995818] IP: [<ffffffffa05a604f>] magicmouse_input_open+0x1f/0x30 [hid_magicmouse]
[ 6392.009801] PGD 16c3b6067 PUD 16b139067 PMD 0 
[ 6392.009801] Oops: 0000 [#1] PREEMPT SMP 
[ 6392.009801] last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input
[ 6392.009801] CPU 1 
[ 6392.009801] Pid: 2763, comm: gpm Not tainted 2.6.33-rc8-crc #106 M3A78-T/System Product Name
[ 6392.064520] RIP: 0010:[<ffffffffa05a604f>]  [<ffffffffa05a604f>] magicmouse_input_open+0x1f/0x30 [hid_magicmouse]
[ 6392.064520] RSP: 0018:ffff88016c2ddba8  EFLAGS: 00010282
[ 6392.064520] RAX: ffff88016dd90000 RBX: ffff88016bc9b000 RCX: 0000000000000001
[ 6392.107009] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88016dd90000
[ 6392.107009] RBP: ffff88016c2ddba8 R08: 2222222222222222 R09: 2222222222222222
[ 6392.107009] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880133b5a810
[ 6392.107009] R13: ffff88016bc9b820 R14: ffff88016dd60150 R15: ffff88016dd600a8
[ 6392.107009] FS:  00007f5ee305b700(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
[ 6392.107009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6392.107009] CR2: 0000000000000010 CR3: 000000016c3b7000 CR4: 00000000000006e0
[ 6392.107009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6392.107009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6392.107009] Process gpm (pid: 2763, threadinfo ffff88016c2dc000, task ffff88016dde0000)
[ 6392.107009] Stack:
[ 6392.107009]  ffff88016c2ddbe8 ffffffff814010e9 ffff88016dd60150 ffff88016dd600a8
[ 6392.107009] <0> ffff88016c2ddbe8 ffff880133b5a800 ffff880133b5a8d8 0000000000000000
[ 6392.107009] <0> ffff88016c2ddc18 ffffffff81404236 ffff88016c2ddc18 ffff880133b5a800
[ 6392.107009] Call Trace:
[ 6392.107009]  [<ffffffff814010e9>] input_open_device+0x89/0xb0
[ 6392.107009]  [<ffffffff81404236>] mousedev_open_device+0x76/0x100
[ 6392.107009]  [<ffffffff814042a9>] mousedev_open_device+0xe9/0x100
[ 6392.107009]  [<ffffffff8140523f>] mousedev_open+0x19f/0x260
[ 6392.107009]  [<ffffffff814bc243>] ? _lock_kernel+0x143/0x1e0
[ 6392.107009]  [<ffffffff81402ba7>] input_open_file+0x227/0x410
[ 6392.107009]  [<ffffffff814bf981>] ? sub_preempt_count+0x51/0x60
[ 6392.107009]  [<ffffffff8112384d>] chrdev_open+0x17d/0x320
[ 6392.107009]  [<ffffffff814bbb7c>] ? _raw_spin_unlock+0x5c/0x70
[ 6392.107009]  [<ffffffff8111d358>] __dentry_open+0x1a8/0x400
[ 6392.107009]  [<ffffffff811236d0>] ? chrdev_open+0x0/0x320
[ 6392.107009]  [<ffffffff8111d6b4>] nameidata_to_filp+0x54/0x70
[ 6392.107009]  [<ffffffff8112e7f1>] do_filp_open+0x841/0xc00
[ 6392.107009]  [<ffffffff814bf981>] ? sub_preempt_count+0x51/0x60
[ 6392.107009]  [<ffffffff814bbb7c>] ? _raw_spin_unlock+0x5c/0x70
[ 6392.107009]  [<ffffffff81002b0c>] ? sysret_check+0x27/0x62
[ 6392.107009]  [<ffffffff8111e954>] do_sys_open+0xa4/0x180
[ 6392.107009]  [<ffffffff8111ea70>] sys_open+0x20/0x30
[ 6392.107009]  [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[ 6392.107009] Code: 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 48 81 c7 a0 08 00 00 e8 3b f0 de e0 48 8b 90 38 1b 00 00 48 89 c7 <ff> 52 10 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
[ 6392.107009] RIP  [<ffffffffa05a604f>] magicmouse_input_open+0x1f/0x30 [hid_magicmouse]
[ 6392.107009]  RSP <ffff88016c2ddba8>
[ 6392.107009] CR2: 0000000000000010
[ 6392.107321] ---[ end trace c83e80c68826df09 ]---

grover ~ # udevadm monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[1266085238.085802] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41 (bluetooth)
UDEV  [1266085238.113475] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41 (bluetooth)
KERNEL[1266085238.412016] add      /module/hidp (module)
UDEV  [1266085238.412247] add      /module/hidp (module)
KERNEL[1266085238.418193] add      /bus/hid/drivers/generic-bluetooth (drivers)
UDEV  [1266085238.418365] add      /bus/hid/drivers/generic-bluetooth (drivers)
KERNEL[1266085238.418507] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004 (hid)
KERNEL[1266085238.460711] add      /module/hid_magicmouse (module)
UDEV  [1266085238.460906] add      /module/hid_magicmouse (module)
KERNEL[1266085238.460977] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7 (input)
UDEV  [1266085238.462772] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7 (input)
KERNEL[1266085238.473232] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/mouse1 (input)
KERNEL[1266085238.473323] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/event7 (input)
KERNEL[1266085238.473662] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004/hidraw/hidraw3 (hidraw)
UDEV  [1266085238.479691] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/event7 (input)
KERNEL[1266085238.486090] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8 (input)
UDEV  [1266085238.488291] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/mouse1 (input)
UDEV  [1266085238.493195] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8 (input)
KERNEL[1266085238.498954] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8/mouse2 (input)
KERNEL[1266085238.499066] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8/event8 (input)
KERNEL[1266085238.499154] add      /bus/hid/drivers/magicmouse (drivers)
UDEV  [1266085238.499624] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004 (hid)
UDEV  [1266085238.501108] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004/hidraw/hidraw3 (hidraw)
UDEV  [1266085238.501311] add      /bus/hid/drivers/magicmouse (drivers)
UDEV  [1266085238.509221] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8/event8 (input)
UDEV  [1266085238.511459] add      /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input8/mouse2 (input)
KERNEL[1266085311.467279] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/mouse1 (input)
UDEV  [1266085311.468189] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/mouse1 (input)
KERNEL[1266085311.471961] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/event7 (input)
UDEV  [1266085311.472632] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7/event7 (input)
KERNEL[1266085311.475921] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7 (input)
KERNEL[1266085311.475985] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004/hidraw/hidraw3 (hidraw)
KERNEL[1266085311.476153] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004 (hid)
KERNEL[1266085311.476214] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41 (bluetooth)
UDEV  [1266085311.476397] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/input7 (input)
UDEV  [1266085311.476734] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004/hidraw/hidraw3 (hidraw)
UDEV  [1266085311.477000] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41/0005:05AC:030D.0004 (hid)
UDEV  [1266085311.503056] remove   /devices/pci0000:00/0000:00:13.2/usb7/7-4/7-4.4/7-4.4:1.0/bluetooth/hci0/hci0:41 (bluetooth)

Ideas?
Ed Tomlinson
