Return-Path: <linux-kernel-owner+w=401wt.eu-S968298AbXG3UhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968298AbXG3UhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967012AbXG3Ug4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:36:56 -0400
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:48768 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966831AbXG3Ugz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:36:55 -0400
Date: Mon, 30 Jul 2007 16:36:42 -0400
From: "A. Kalten" <akalten@comcast.net>
To: linux-kernel@vger.kernel.org
Subject: Can't unload uhci_hcd module with 2.6.22 -- also oops
Message-Id: <20070730163642.2d97e31c.akalten@comcast.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

To send a fax using an external usb modem, I do the following:

modprobe uhci-hcd
modprobe cdc-acm
mount -t usbfs none /proc/bus/usb

Then I send the fax.

However, when I attempt to unload the modules by reversing
the above steps, then uhci_hcd module will not unload:

[/]# rmmod uhci-hcd
ERROR: Removing 'uhci_hcd': Device or resource busy

Using lsof to list all open files gives the following:

ksuspend_  766 root  cwd       DIR                8,1     456          2 /
ksuspend_  766 root  rtd       DIR                8,1     456          2 /
ksuspend_  766 root  txt   unknown                                       /proc/766/exe
khubd      769 root  cwd       DIR                8,1     456          2 /
khubd      769 root  rtd       DIR                8,1     456          2 /
khubd      769 root  txt   unknown                                       /proc/769/exe

I cannot terminate these processes.

Also, the kernel log shows an oops:

kernel: usbcore: deregistering interface driver cdc_acm
kernel: uhci_hcd 0000:00:1d.3: remove, state 1
kernel: usb usb4: USB disconnect, address 1
kernel: uhci_hcd 0000:00:1d.3: USB bus 4 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
kernel: uhci_hcd 0000:00:1d.2: remove, state 1
kernel: usb usb3: USB disconnect, address 1
kernel: uhci_hcd 0000:00:1d.2: USB bus 3 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
kernel: uhci_hcd 0000:00:1d.1: remove, state 1
kernel: usb usb2: USB disconnect, address 1
kernel: usb 2-2: USB disconnect, address 2
kernel: Unable to handle kernel paging request at ffffffff88040440 RIP: 
kernel:  [sysfs_get_name+46/65] sysfs_get_name+0x2e/0x41
kernel: PGD 203067 PUD 205063 PMD 7a6b2067 PTE 0
kernel: Oops: 0000 [1] SMP 
kernel: CPU 1 
kernel: Modules linked in: uhci_hcd usbcore af_packet skge bitrev crc32
kernel: Pid: 1123, comm: rmmod Not tainted 2.6.22 #3
kernel: RIP: 0010:[sysfs_get_name+46/65]  [sysfs_get_name+46/65] sysfs_get_name+0x2e/0x41
kernel: RSP: 0018:ffff81006edd5ce0  EFLAGS: 00010246
kernel: RAX: ffffffff88040440 RBX: ffff81006fbb68e0 RCX: 0000000000000000
kernel: RDX: 0000000000000004 RSI: ffffffff80423b38 RDI: ffff81006fbb6b88
kernel: RBP: ffff81006fbb6b88 R08: 0000000000000000 R09: 8000000000000000
kernel: R10: 0000000000000080 R11: ffffffff80330606 R12: ffff81006fbb6b90
kernel: R13: ffff81006f414c78 R14: ffffffff80423b38 R15: ffffffff8803b940
kernel: FS:  00002b93765b76f0(0000) GS:ffff810002f4d140(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: ffffffff88040440 CR3: 000000006f5e5000 CR4: 00000000000006e0
kernel: Process rmmod (pid: 1123, threadinfo ffff81006edd4000, task ffff81006e48ae40)
kernel: Stack:  ffffffff8029b6dd ffff81006fbb0420 ffff81006fbb05a0 ffff8100784a9800
kernel:  ffff81006fbb0510 ffff8100784a9888 ffffffff80330986 ffff81006fbb0400
kernel:  ffff81006fbb0400 ffff81006fbb0420 ffffffff80330b95 ffff81006fbb0400
kernel: Call Trace:
kernel:  [sysfs_hash_and_remove+104/295] sysfs_hash_and_remove+0x68/0x127
kernel:  [device_remove_file+37/58] device_remove_file+0x25/0x3a
kernel:  [device_del+375/704] device_del+0x177/0x2c0
kernel:  [_end+129064639/2131730856] :usbcore:usb_disable_device+0x8c/0x106
kernel:  [_end+129049073/2131730856] :usbcore:usb_disconnect+0x98/0xee
kernel:  [_end+129049053/2131730856] :usbcore:usb_disconnect+0x84/0xee
kernel:  [_end+129057037/2131730856] :usbcore:usb_remove_hcd+0x85/0xe1
kernel:  [_end+129097874/2131730856] :usbcore:usb_hcd_pci_remove+0x1d/0x89
kernel:  [pci_device_remove+36/77] pci_device_remove+0x24/0x4d
kernel:  [__device_release_driver+130/184] __device_release_driver+0x82/0xb8
kernel:  [driver_detach+252/261] driver_detach+0xfc/0x105
kernel:  [bus_remove_driver+122/157] bus_remove_driver+0x7a/0x9d
kernel:  [pci_unregister_driver+16/129] pci_unregister_driver+0x10/0x81
kernel:  [_end+129186684/2131730856] :uhci_hcd:uhci_hcd_cleanup+0x10/0x2c
kernel:  [sys_delete_module+319/444] sys_delete_module+0x13f/0x1bc
kernel:  [__up_write+29/318] __up_write+0x1d/0x13e
kernel:  [system_call+126/131] system_call+0x7e/0x83
kernel: 
kernel: 
kernel: Code: 48 8b 00 c3 83 fa 20 74 f7 31 c0 0f 1f 00 c3 0f 0b eb fe 41 
kernel: RIP  [sysfs_get_name+46/65] sysfs_get_name+0x2e/0x41
kernel:  RSP <ffff81006edd5ce0>
kernel: CR2: ffffffff88040440

My system is Intel Pentium D dual core with Asus P5WD2 motherboard.

Please CC to my personal address as I am not subscribed to the list.

Andrew Kalten

