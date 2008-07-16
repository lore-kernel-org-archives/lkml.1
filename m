Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbYGPMYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbYGPMYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYGPMYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:24:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:51130 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGPMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Fn1zmpCr6zXydFEoLEcfSCFwJABhRMK+Fulwk2pAkR8TOhYipCNesmPUyyZ/AoK4cR
         ZNS2ddXSrB3cO3TLonpwDtgbm94gLcRY4VuhqBCc+ZeqRIggIh3UnvB9BRk+HtyGBSTr
         h1yZMhG2xXH4RWRxQCrLnKwboZtwL4VK9egZ8=
Message-ID: <c4e36d110807160524i51f12d8eof0b1d58219725c3c@mail.gmail.com>
Date: Wed, 16 Jul 2008 14:24:30 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG: spinlock bad magic on CPU#1, modprobe/815 - led-triggers
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm running 2.6.26 kernel - git commit: bce7f793daec3e65ec5c5705d2457b81fe7b5725
I've T61, 2GB, C2D, x86_64

 I'm getting this oops while using 64bit kernel and running mostly 32bit system.

This one happens sometimes during boot - unpredictible - usually once
in 15 boots.

this might help:

addr2line -e vmlinux ffffffff81263c17
drivers/leds/led-triggers.c:171

---
		down_write(&led_cdev->trigger_lock);
>>>	if (!led_cdev->trigger && led_cdev->default_trigger &&
			    !strcmp(led_cdev->default_trigger, trigger->name))
---


Linux version 2.6.26 (user@localhost) (gcc version 4.3.1 20080708 (Red
Hat 4.3.1-4) (GCC) ) #44 SMP PREEMPT Mon Jul 14 18:45:34 CEST 2008
Command line: ro root=/dev/sda6 selinux=off no_console_suspend
console=tty0 console=ttyS0 vga=0x36d 4
BIOS-provided physical RAM map:
.....
PM: Adding info for No Bus:hwmon0
thinkpad_acpi: ThinkPad ACPI Extras v0.20
usb 1-1: new full speed USB device using uhci_hcd and address 2
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7LETB9WW (2.19 ), EC 7KHT24WW-1.08
PM: Adding info for No Bus:usbdev7.1_ep81
PM: Adding info for No Bus:usbdev7.1
PM: Adding info for No Bus:usbdev7.1_ep00
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.26 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 21)
thinkpad_acpi: Lenovo ThinkPad T61, model 6464CTO
ACPI: PCI Interrupt 0000:15:00.2[C] -> GSI 18 (level, low) -> IRQ 18
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness
control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
PCI: Setting latency timer of device 0000:15:00.2 to 64
PM: Adding info for No Bus:tpacpi::thinklight
BUG: spinlock bad magic on CPU#1, modprobe/815
 lock: ffffffffa014f350, .magic: 00000000, .owner: modprobe/815, .owner_cpu: 1
Pid: 815, comm: modprobe Not tainted 2.6.26 #44

Call Trace:
 [<ffffffff81060a87>] ? put_lock_stats+0x27/0x30
 [<ffffffff81186c02>] spin_bug+0xa2/0xf0
 [<ffffffff81186c71>] _raw_spin_unlock+0x21/0xa0
 [<ffffffff812fa57f>] _spin_unlock_irqrestore+0x2f/0x90
 [<ffffffff8117f36d>] __down_write_trylock+0x3d/0x60
 [<ffffffff812f8c30>] down_write+0x40/0x70
 [<ffffffff81263c17>] led_trigger_register+0xb7/0x110
 [<ffffffff81263cae>] led_trigger_register_simple+0x3e/0x80
 [<ffffffffa009b36e>] :mmc_core:mmc_add_host+0x3e/0x80
 [<ffffffffa012803a>] :sdhci:sdhci_probe+0x59a/0x7fe
 [<ffffffff8118e17c>] pci_device_probe+0x7c/0xa0
 [<ffffffff8120ad72>] driver_probe_device+0xa2/0x1e0
 [<ffffffff8120af3b>] __driver_attach+0x8b/0x90
 [<ffffffff8120aeb0>] ? __driver_attach+0x0/0x90
 [<ffffffff8120a50b>] bus_for_each_dev+0x6b/0xa0
 [<ffffffff8120abbc>] driver_attach+0x1c/0x20
 [<ffffffff81209d78>] bus_add_driver+0x1f8/0x270
 [<ffffffff8120b123>] driver_register+0x73/0x170
 [<ffffffff8118e42a>] __pci_register_driver+0x6a/0xb0
 [<ffffffffa006d03a>] :sdhci:sdhci_drv_init+0x3a/0x3c
 [<ffffffff8106cd62>] sys_init_module+0x152/0x1f00
 [<ffffffff812fa595>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff811894c0>] ? pci_bus_read_config_byte+0x0/0x90
 [<ffffffff81028902>] sysenter_do_call+0x1b/0x70
 [<ffffffff812f9ef1>] ? trace_hardirqs_on_thunk+0x35/0x3a

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff812f9d97>] __down_write_nested+0x67/0xc0
PGD 7d076067 PUD 7d3c4067 PMD 0
Oops: 0002 [1] PREEMPT SMP
CPU 1
Modules linked in: snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
iwl3945(+) thinkpad_acpi(+) i2c_i801(+) snd_seq_device led_class video
backlight sdhci(+) sr_mod psmouse intel_agp battery mac80211 i2c_core
iTCO_wdt rtc_cmos ehci_hcd uhci_hcd output ac button mmc_core snd
cdrom nvram iTCO_vendor_support e1000e serio_raw rtc_core rtc_lib
evdev usbcore cfg80211 soundcore snd_page_alloc
Pid: 815, comm: modprobe Not tainted 2.6.26 #44
RIP: 0010:[<ffffffff812f9d97>]  [<ffffffff812f9d97>]
__down_write_nested+0x67/0xc0
RSP: 0018:ffff81007d2afac8  EFLAGS: 00010007
RAX: ffff81007d2afac8 RBX: ffff81007c4824a0 RCX: ffffffffa014f388
RDX: 0000000000000000 RSI: ffffffffa014f368 RDI: ffff81007c4824a0
RBP: ffff81007d2afb08 R08: 0000000000000002 R09: 0000000000000001
R10: ffff81007c4824a0 R11: 0000000000000000 R12: ffffffffa014f348
R13: ffffffffa014f350 R14: 0000000000000000 R15: ffff81007d3d9000
FS:  0000000000000000(0000) GS:ffff81007e006600(0063) knlGS:00000000f7e446b0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007d385000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 815, threadinfo ffff81007d2ae000, task ffff81007c4824a0)
Stack:  ffffffffa014f388 ffffffff81060a6e ffff81007c4824a0 0000000000000002
 0000000000000246 ffffffffa014f398 ffffffffa014f348 ffff81007d266f00
 ffff81007d2afb18 ffffffff812f9dfb ffff81007d2afb38 ffffffff812f8c48
Call Trace:
 [<ffffffff81060a6e>] ? put_lock_stats+0xe/0x30
 [<ffffffff812f9dfb>] __down_write+0xb/0x10
 [<ffffffff812f8c48>] down_write+0x58/0x70
 [<ffffffff81263c17>] led_trigger_register+0xb7/0x110
 [<ffffffff81263cae>] led_trigger_register_simple+0x3e/0x80
 [<ffffffffa009b36e>] :mmc_core:mmc_add_host+0x3e/0x80
 [<ffffffffa012803a>] :sdhci:sdhci_probe+0x59a/0x7fe
 [<ffffffff8118e17c>] pci_device_probe+0x7c/0xa0
 [<ffffffff8120ad72>] driver_probe_device+0xa2/0x1e0
 [<ffffffff8120af3b>] __driver_attach+0x8b/0x90
 [<ffffffff8120aeb0>] ? __driver_attach+0x0/0x90
 [<ffffffff8120a50b>] bus_for_each_dev+0x6b/0xa0
 [<ffffffff8120abbc>] driver_attach+0x1c/0x20
 [<ffffffff81209d78>] bus_add_driver+0x1f8/0x270
 [<ffffffff8120b123>] driver_register+0x73/0x170
 [<ffffffff8118e42a>] __pci_register_driver+0x6a/0xb0
 [<ffffffffa006d03a>] :sdhci:sdhci_drv_init+0x3a/0x3c
 [<ffffffff8106cd62>] sys_init_module+0x152/0x1f00
 [<ffffffff812fa595>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff811894c0>] ? pci_bus_read_config_byte+0x0/0x90
 [<ffffffff81028902>] sysenter_do_call+0x1b/0x70
 [<ffffffff812f9ef1>] ? trace_hardirqs_on_thunk+0x35/0x3a


Code: 00 00 b8 02 00 00 00 48 87 03 48 89 5d d0 c7 45 d8 02 00 00 00
f0 ff 43 10 49 8b 54 24 48 48 8d 45 c0 48 89 4d c0 49 89 44 24 48 <48>
89 02 48 89 55 c8 4c 89 ef e8 2a 07 00 00 48 83 7d d0 00 74
RIP  [<ffffffff812f9d97>] __down_write_nested+0x67/0xc0
 RSP <ffff81007d2afac8>
CR2: 0000000000000000
---[ end trace 979939bc542c4b4d ]---
note: modprobe[815] exited with preempt_count 1
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():1, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 21112
hardirqs last  enabled at (21111): [<ffffffff812f9ef1>]
trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (21112): [<ffffffff812fa8c0>]
_spin_lock_irqsave+0x20/0x80
softirqs last  enabled at (21028): [<ffffffff81041f10>] __do_softirq+0xe0/0x100
softirqs last disabled at (20987): [<ffffffff8100d7ec>] call_softirq+0x1c/0x30
Pid: 815, comm: modprobe Tainted: G      D   2.6.26 #44

Call Trace:
 [<ffffffff8105fc00>] ? print_irqtrace_events+0x110/0x120
 [<ffffffff810326fc>] __might_sleep+0xec/0x130
 [<ffffffff812f8c80>] down_read+0x20/0x70
 [<ffffffff810757a4>] acct_collect+0x44/0x1f0
 [<ffffffff8103f753>] do_exit+0x1b3/0x860
 [<ffffffff811f500d>] ? do_unblank_screen+0x1d/0x170
 [<ffffffff812fb7c8>] oops_end+0x88/0x90
 [<ffffffff812fd900>] do_page_fault+0x280/0xaf0
 [<ffffffff810642f5>] ? print_lock_contention_bug+0x25/0x130
 [<ffffffff81034a99>] ? hrtick_set+0x39/0x130
 [<ffffffff81034a99>] ? hrtick_set+0x39/0x130
 [<ffffffff810642f5>] ? print_lock_contention_bug+0x25/0x130
 [<ffffffff812fa595>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff81034ada>] ? hrtick_set+0x7a/0x130
 [<ffffffff812fb03d>] error_exit+0x0/0xa9
 [<ffffffff812f9d97>] ? __down_write_nested+0x67/0xc0
 [<ffffffff812f9d4c>] ? __down_write_nested+0x1c/0xc0
 [<ffffffff81060a6e>] ? put_lock_stats+0xe/0x30
 [<ffffffff812f9dfb>] ? __down_write+0xb/0x10
 [<ffffffff812f8c48>] ? down_write+0x58/0x70
 [<ffffffff81263c17>] ? led_trigger_register+0xb7/0x110
 [<ffffffff81263cae>] ? led_trigger_register_simple+0x3e/0x80
 [<ffffffffa009b36e>] ? :mmc_core:mmc_add_host+0x3e/0x80
 [<ffffffffa012803a>] ? :sdhci:sdhci_probe+0x59a/0x7fe
 [<ffffffff8118e17c>] ? pci_device_probe+0x7c/0xa0
 [<ffffffff8120ad72>] ? driver_probe_device+0xa2/0x1e0
 [<ffffffff8120af3b>] ? __driver_attach+0x8b/0x90
 [<ffffffff8120aeb0>] ? __driver_attach+0x0/0x90
 [<ffffffff8120a50b>] ? bus_for_each_dev+0x6b/0xa0
 [<ffffffff8120abbc>] ? driver_attach+0x1c/0x20
 [<ffffffff81209d78>] ? bus_add_driver+0x1f8/0x270
 [<ffffffff8120b123>] ? driver_register+0x73/0x170
 [<ffffffff8118e42a>] ? __pci_register_driver+0x6a/0xb0
 [<ffffffffa006d03a>] ? :sdhci:sdhci_drv_init+0x3a/0x3c
 [<ffffffff8106cd62>] ? sys_init_module+0x152/0x1f00
 [<ffffffff812fa595>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff811894c0>] ? pci_bus_read_config_byte+0x0/0x90
 [<ffffffff81028902>] ? sysenter_do_call+0x1b/0x70
 [<ffffffff812f9ef1>] ? trace_hardirqs_on_thunk+0x35/0x3a

BUG: scheduling while atomic: modprobe/815/0x10000002
INFO: lockdep is turned off.
irq event stamp: 21112
hardirqs last  enabled at (21111): [<ffffffff812f9ef1>]
trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (21112): [<ffffffff812fa8c0>]
_spin_lock_irqsave+0x20/0x80
softirqs last  enabled at (21028): [<ffffffff81041f10>] __do_softirq+0xe0/0x100
softirqs last disabled at (20987): [<ffffffff8100d7ec>] call_softirq+0x1c/0x30
Pid: 815, comm: modprobe Tainted: G      D   2.6.26 #44

Call Trace:
 [<ffffffff8105fc00>] ? print_irqtrace_events+0x110/0x120
 [<ffffffff81037265>] __schedule_bug+0x95/0xa0
 [<ffffffff812f71b5>] thread_return+0x14e/0x619
 [<ffffffff8103c1c0>] ? vprintk+0x3e0/0x4c0
 [<ffffffff81037847>] __cond_resched+0x27/0x50
 [<ffffffff812f77e5>] _cond_resched+0x35/0x50
 [<ffffffff810a018f>] unmap_vmas+0x7cf/0x910
 [<ffffffff810a49ad>] exit_mmap+0x8d/0x140
 [<ffffffff81038a50>] mmput+0x40/0xe0
 [<ffffffff8103d7bb>] exit_mm+0x9b/0x110
 [<ffffffff8103f7a8>] do_exit+0x208/0x860
 [<ffffffff811f500d>] ? do_unblank_screen+0x1d/0x170
 [<ffffffff812fb7c8>] oops_end+0x88/0x90
 [<ffffffff812fd900>] do_page_fault+0x280/0xaf0
 [<ffffffff810642f5>] ? print_lock_contention_bug+0x25/0x130
 [<ffffffff81034a99>] ? hrtick_set+0x39/0x130
 [<ffffffff81034a99>] ? hrtick_set+0x39/0x130
 [<ffffffff810642f5>] ? print_lock_contention_bug+0x25/0x130
 [<ffffffff812fa595>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff81034ada>] ? hrtick_set+0x7a/0x130
 [<ffffffff812fb03d>] error_exit+0x0/0xa9
 [<ffffffff812f9d97>] ? __down_write_nested+0x67/0xc0
 [<ffffffff812f9d4c>] ? __down_write_nested+0x1c/0xc0
 [<ffffffff81060a6e>] ? put_lock_stats+0xe/0x30
 [<ffffffff812f9dfb>] ? __down_write+0xb/0x10
 [<ffffffff812f8c48>] ? down_write+0x58/0x70
 [<ffffffff81263c17>] ? led_trigger_register+0xb7/0x110
 [<ffffffff81263cae>] ? led_trigger_register_simple+0x3e/0x80
 [<ffffffffa009b36e>] ? :mmc_core:mmc_add_host+0x3e/0x80
 [<ffffffffa012803a>] ? :sdhci:sdhci_probe+0x59a/0x7fe
 [<ffffffff8118e17c>] ? pci_device_probe+0x7c/0xa0
 [<ffffffff8120ad72>] ? driver_probe_device+0xa2/0x1e0
 [<ffffffff8120af3b>] ? __driver_attach+0x8b/0x90
 [<ffffffff8120aeb0>] ? __driver_attach+0x0/0x90
 [<ffffffff8120a50b>] ? bus_for_each_dev+0x6b/0xa0
 [<ffffffff8120abbc>] ? driver_attach+0x1c/0x20
 [<ffffffff81209d78>] ? bus_add_driver+0x1f8/0x270
 [<ffffffff8120b123>] ? driver_register+0x73/0x170
 [<ffffffff8118e42a>] ? __pci_register_driver+0x6a/0xb0
 [<ffffffffa006d03a>] ? :sdhci:sdhci_drv_init+0x3a/0x3c
 [<ffffffff8106cd62>] ? sys_init_module+0x152/0x1f00
 [<ffffffff812fa595>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff811894c0>] ? pci_bus_read_config_byte+0x0/0x90
 [<ffffffff81028902>] ? sysenter_do_call+0x1b/0x70
 [<ffffffff812f9ef1>] ? trace_hardirqs_on_thunk+0x35/0x3a

ACPI: EC: missing confirmations, switch off interrupt mode.
Registered led device: tpacpi::thinklight
PM: Adding info for No Bus:tpacpi::power
PM: Adding info for usb:1-1
usb 1-1: configuration #1 chosen from 1 choice
