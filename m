Return-Path: <linux-kernel-owner+w=401wt.eu-S966514AbXENL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966514AbXENL5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXENLkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:40:03 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:52551 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031624AbXENLj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:39:59 -0400
Date: Mon, 14 May 2007 12:21:37 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Workaround for a PCI restoring bug
Message-ID: <20070514102136.GA3564@ics.muni.cz>
References: <20070512201237.GB3569@ics.muni.cz> <20070512234743.0a8a915f.akpm@linux-foundation.org> <20070513085718.GD3580@ics.muni.cz> <20070513021119.c4f14bd3.akpm@linux-foundation.org> <20070513122113.GA3632@ics.muni.cz> <20070513115947.105fb1ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070513115947.105fb1ba.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 14 May 2007 13:39:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 11:59:47AM -0700, Andrew Morton wrote:
> Possibly we're saving the device's state when it is already partway or
> fully through the suspend process, dunno.
> 
> What if you were to put code into pci_save_state() to detect when it reads
> an oxffffffff?  Do a dump_stack() and print pci_dev->current_state and
> ->enable_cnt and various other things in there?

The PCI topology looks like this:
-[0000:00]-+-00.0
           +-01.0-[0000:03]--
           +-02.0
           +-02.1
           +-1b.0
           +-1d.0
           +-1d.1
           +-1d.2
           +-1d.3
           +-1d.7
           +-1e.0-[0000:01-02]--+-00.0
           |                    +-01.0
           |                    +-01.1
           |                    +-01.2
           |                    +-01.3
           |                    +-01.4
           |                    \-02.0
           +-1f.0
           +-1f.1
           \-1f.3

I've modified the pci.c source in the following way:

pci_save_state:
        int wrong=0;
        /* XXX: 100% dword access ok here? */
        printk(KERN_DEBUG "PM: saving PCI state %s\n", pci_name(dev));
        printk(KERN_DEBUG "PM: dev state %d\n", dev->current_state);
        printk(KERN_DEBUG "PM: dev enabled? %d\n", atomic_read(&(dev->enable_cnt)));
        dump_stack();
        for (i = 0; i < 16; i++) {
                pci_read_config_dword(dev, i * 4,&dev->saved_config_space[i]);
                if(dev->saved_config_space[i] == 0xffffffff) {
                        wrong++;
                }
        }
        printk(KERN_DEBUG "PM: wrong values count %d\n", wrong);

and pci_restore_state:
        printk(KERN_DEBUG "PM: restoring PCI state %s\n", pci_name(dev));
        printk(KERN_DEBUG "PM: dev state %d\n", dev->current_state);
        printk(KERN_DEBUG "PM: dev enabled? %d\n", atomic_read(&(dev->enable_cnt)));


The dmesg is attached. It looks strange as the devices 0000:01:01.* are in the
same  state in both pci_save and pci_restore but in pci_save, only -1 are read
and in pci_restore the correct values are read. Maybe, it is something ACPI
related - if ACPI suspend is called at the beginning, these particular devices
suspend and their state cannot be properly gained.

I've checked also order of device suspending. It looks correct, the bridge
00:1e.0 is suspended after those devices.

So, what to do next?


PM: saving PCI state 0000:01:02.0
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:01:01.4
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 16
PM: saving PCI state 0000:01:01.3
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 16
PM: saving PCI state 0000:01:01.2
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 16
PM: saving PCI state 0000:01:01.1
PM: dev state 5
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 16
PM: saving PCI state 0000:01:01.0
PM: dev state 5
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 16
PM: saving PCI state 0000:01:00.0
PM: dev state 0
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c0200733>] pci_find_capability+0x33/0x40
 [<ef848027>] skge_suspend+0x27/0xe0 [skge]
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:1f.3
PM: dev state 5
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef85b04e>] i801_suspend+0xe/0x40 [i2c_i801]
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:1f.1
PM: dev state 5
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c0267bb4>] ata_pci_device_do_suspend+0x14/0x50
 [<c026d3ec>] ata_pci_device_suspend+0x2c/0x40
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
pci_set_power_state(): 0000:00:1f.1: state=3, current state=5
PM: saving PCI state 0000:00:1f.0
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:1e.0
PM: dev state 5
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:1d.7
PM: dev state 0
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c028abcc>] usb_hcd_pci_suspend+0x13c/0x160
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
PM: saving PCI state 0000:00:1d.3
PM: dev state 0
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef82c832>] uhci_suspend+0x92/0xf0 [uhci_hcd]
 [<c028abcc>] usb_hcd_pci_suspend+0x13c/0x160
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
PM: saving PCI state 0000:00:1d.2
PM: dev state 0
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef82c832>] uhci_suspend+0x92/0xf0 [uhci_hcd]
 [<c028abcc>] usb_hcd_pci_suspend+0x13c/0x160
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
PM: saving PCI state 0000:00:1d.1
PM: dev state 0
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef82c832>] uhci_suspend+0x92/0xf0 [uhci_hcd]
 [<c028abcc>] usb_hcd_pci_suspend+0x13c/0x160
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
PM: saving PCI state 0000:00:1d.0
PM: dev state 0
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef82c832>] uhci_suspend+0x92/0xf0 [uhci_hcd]
 [<c028abcc>] usb_hcd_pci_suspend+0x13c/0x160
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
PM: saving PCI state 0000:00:1b.0
PM: dev state 0
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c0200484>] pci_disable_device+0x54/0x90
 [<ef86ebf7>] azx_suspend+0xa7/0xd0 [snd_hda_intel]
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:02.1
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef86ec09>] azx_suspend+0xb9/0xd0 [snd_hda_intel]
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:02.0
PM: dev state 5
PM: dev enabled? 0
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<ef86ec09>] azx_suspend+0xb9/0xd0 [snd_hda_intel]
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:01.0
PM: dev state 0
PM: dev enabled? 2
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c0206788>] pcie_port_device_suspend+0x18/0x20
 [<c0203893>] pci_device_suspend+0x23/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
PM: saving PCI state 0000:00:00.0
PM: dev state 5
PM: dev enabled? 1
 [<c0201861>] pci_save_state+0x61/0x2b0
 [<c0206788>] pcie_port_device_suspend+0x18/0x20
 [<c02038be>] pci_device_suspend+0x4e/0x60
 [<c0250258>] suspend_device+0xe8/0x1b0
 [<c021997e>] acpi_hw_clear_gpe_block+0x0/0x32
 [<c01f7072>] kobject_get+0x12/0x20
 [<c02503e1>] device_suspend+0xc1/0x160
 [<c013e8a5>] enter_state+0xa5/0x140
 [<c013ea83>] state_store+0xf3/0x100
 [<c013e990>] state_store+0x0/0x100
 [<c01a91e0>] subsys_attr_store+0x30/0x40
 [<c01a9351>] sysfs_write_file+0xb1/0x110
 [<c016c016>] vfs_write+0xa6/0x140
 [<c01a92a0>] sysfs_write_file+0x0/0x110
 [<c016c5f1>] sys_write+0x41/0x70
 [<c0104068>] syscall_call+0x7/0xb
 [<c0340000>] schedule+0x280/0x630
 =======================
PM: wrong values count 0
Back to C!
PCI: Enabled ICH6/i801 SMBus device
ACPI: Transitioning device [FN00] to D3
ACPI: Transitioning device [FN00] to D3
PM: restoring PCI state 0000:00:00.0
PM: dev state 5
PM: dev enabled? 1
PM: restoring PCI state 0000:00:02.0
PM: dev state 5
PM: dev enabled? 0
PM: restoring PCI state 0000:00:01.0
PM: dev state 0
PM: dev enabled? 2
PM: Writing back config space on device 0000:00:01.0 at offset f (was 60100, writing 60105)
PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100104, writing 100504)
PCI: Setting latency timer of device 0000:00:01.0 to 64
PM: restoring PCI state 0000:00:02.0
PM: dev state 5
PM: dev enabled? 0
PM: restoring PCI state 0000:00:02.1
PM: dev state 5
PM: dev enabled? 0
PM: restoring PCI state 0000:00:1b.0
PM: dev state 0
PM: dev enabled? 0
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
PM: restoring PCI state 0000:00:1d.0
PM: dev state 0
PM: dev enabled? 1
usb usb1: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
PM: restoring PCI state 0000:00:1d.1
PM: dev state 0
PM: dev enabled? 1
usb usb2: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
PM: restoring PCI state 0000:00:1d.2
PM: dev state 0
PM: dev enabled? 1
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
PM: restoring PCI state 0000:00:1d.3
PM: dev state 0
PM: dev enabled? 1
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: restoring PCI state 0000:00:1d.7
PM: dev state 0
PM: dev enabled? 1
PM: restoring PCI state 0000:00:1e.0
PM: dev state 5
PM: dev enabled? 1
PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 1fff1, writing 35f13001)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PM: restoring PCI state 0000:00:1f.0
PM: dev state 5
PM: dev enabled? 0
PM: restoring PCI state 0000:00:1f.1
PM: dev state 5
PM: dev enabled? 0
PM: Writing back config space on device 0000:00:1f.1 at offset 1 (was 2800005, writing 2880005)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
PM: restoring PCI state 0000:00:1f.3
PM: dev state 5
PM: dev enabled? 1
PM: restoring PCI state 0000:01:00.0
PM: dev state 0
PM: dev enabled? 1
PM: restoring PCI state 0000:01:01.0
PM: dev state 5
PM: dev enabled? 1
PM: Writing back config space on device 0000:01:01.0 at offset f (was 800100, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset e (was d4fc, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset d (was d400, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset c (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset b (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset a (was 3bfff000, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 9 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 8 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 7 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 6 (was 40020201, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 5 (was 20000dc, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 4 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 3 (was 822000, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 2 (was 60700b3, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 1 (was 2100107, writing ffffffff)
PM: Writing back config space on device 0000:01:01.0 at offset 0 (was 4761180, writing ffffffff)
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: restoring PCI state 0000:01:01.1
PM: dev state 5
PM: dev enabled? 1
PM: Writing back config space on device 0000:01:01.1 at offset f (was 4020205, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset e (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset d (was dc, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset c (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset b (was 19671043, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset a (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 9 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 8 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 7 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 6 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 5 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 4 (was fe8fd800, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 3 (was 804000, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 2 (was c001008, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 1 (was 2100006, writing ffffffff)
PM: Writing back config space on device 0000:01:01.1 at offset 0 (was 5521180, writing ffffffff)
ACPI: PCI Interrupt 0000:01:01.1[B] -> GSI 16 (level, low) -> IRQ 16
PM: restoring PCI state 0000:01:01.2
PM: dev state 5
PM: dev enabled? 0
PM: Writing back config space on device 0000:01:01.2 at offset f (was 306, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset e (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset d (was 80, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset c (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset b (was 19671043, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset a (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 9 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 8 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 7 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 6 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 5 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 4 (was fe8fe400, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 3 (was 804000, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 2 (was 8050017, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 1 (was 2100006, writing ffffffff)
PM: Writing back config space on device 0000:01:01.2 at offset 0 (was 8221180, writing ffffffff)
PM: restoring PCI state 0000:01:01.3
PM: dev state 5
PM: dev enabled? 0
PM: Writing back config space on device 0000:01:01.3 at offset f (was 306, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset e (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset d (was 80, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset c (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset b (was 19671043, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset a (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 9 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 8 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 7 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 6 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 5 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 4 (was fe8fe800, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 3 (was 800000, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 2 (was 8800008, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 1 (was 2100002, writing ffffffff)
PM: Writing back config space on device 0000:01:01.3 at offset 0 (was 5921180, writing ffffffff)
PM: restoring PCI state 0000:01:01.4
PM: dev state 5
PM: dev enabled? 0
PM: Writing back config space on device 0000:01:01.4 at offset f (was 306, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset e (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset d (was 80, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset c (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset b (was 19671043, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset a (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 9 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 8 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 7 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 6 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 5 (was 0, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 4 (was fe8fec00, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 3 (was 800000, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 2 (was 8800003, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 1 (was 2100002, writing ffffffff)
PM: Writing back config space on device 0000:01:01.4 at offset 0 (was 8521180, writing ffffffff)
PM: restoring PCI state 0000:01:02.0
PM: dev state 5
PM: dev enabled? 0
PM: Writing back config space on device 0000:01:02.0 at offset 1 (was 2900016, writing 2900002)

-- 
Luká¹ Hejtmánek
