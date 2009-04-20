Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZDTLxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZDTLxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZDTLxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:53:39 -0400
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:35288 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZDTLxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:53:38 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 07:53:38 EDT
Message-ID: <49EC60BC.1070501@Calva.COM>
Date: Mon, 20 Apr 2009 13:47:08 +0200
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Am I allowed to call request_firmware_nowait from an interrupt handler?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for fun I'm writing a driver for an old board I have lying around 
(a Brooktrout Netaccess PRI-PCI ISDN primary rate board).  One of the 
amusing things it does it ask for various firmware modules when it's 
booting.

As I receive these requests in the interrupt handler I'm trying to call 
request_firmware_nowait to do the download.

But it complains:

[  167.058933] pri: pri0: board wants file I990803.PKG (rev ) for module 1d
[  167.058933] BUG: scheduling while atomic: swapper/0/0x00010000
[  167.058933]
[  167.058933] Pid: 0, comm: swapper Not tainted (2.6.26-2-686 #1)
[  167.058933] EIP: 0060:[<c0114d68>] EFLAGS: 00000246 CPU: 1
[  167.058933] EIP is at native_safe_halt+0x2/0x3
[  167.058933] EAX: ef474000 EBX: c0102656 ECX: 0125b000 EDX: ffff6fbb
[  167.058933] ESI: 00000001 EDI: 00000000 EBP: 00000000 ESP: ef475fa8
[  167.058933]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  167.058933] CR0: 8005003b CR2: b7ee9264 CR3: 2e1c7000 CR4: 000006d0
[  167.058933] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  167.058933] DR6: ffff0ff0 DR7: 00000400
[  167.058933]  [<c0102683>] default_idle+0x2d/0x53
[  167.058933]  [<c01025ce>] cpu_idle+0xab/0xcb
[  167.058933]  =======================
[  167.058933] bad: scheduling from the idle thread!
[  167.058933] Pid: 0, comm: swapper Not tainted 2.6.26-2-686 #1
[  167.058933]  [<c011edc0>] dequeue_task_idle+0x1f/0x28
[  167.058933]  [<c011817f>] dequeue_task+0xa/0x14
[  167.058933]  [<c01181a4>] deactivate_task+0x1b/0x30
[  167.058933]  [<c02b7e43>] schedule+0x121/0x66d
[  167.058933]  [<c01360ac>] getnstimeofday+0x37/0xbc
[  167.058933]  [<c02b852f>] schedule_timeout+0x13/0x86
[  167.058933]  [<c0134556>] ktime_get+0xd/0x21
[  167.058933]  [<c0119132>] hrtick_start_fair+0xeb/0x12c
[  167.058933]  [<c01188fe>] enqueue_task+0x52/0x5d
[  167.058933]  [<c02b7c55>] wait_for_common+0xaf/0x10f
[  167.058933]  [<c011b6ce>] default_wake_function+0x0/0x8
[  167.058933]  [<c0131810>] kthread_create+0x75/0xa8
[  167.058933]  [<f09a3331>] request_firmware_work_func+0x0/0x63 [firmware_class]
[  167.058933]  [<f09a3704>] request_firmware_nowait+0x9c/0xe0 [firmware_class]
[  167.058933]  [<f09a3331>] request_firmware_work_func+0x0/0x63 [firmware_class]
[  167.058933]  [<f0a64725>] pri_download+0x0/0x247 [pri]
[  167.231311]  [<f0a64608>] pri_interrupt+0x1fe/0x31b [pri]
[  167.235301]  [<f0a64725>] pri_download+0x0/0x247 [pri]
[  167.235301]  [<c015208e>] handle_IRQ_event+0x23/0x51
[  167.235301]  [<c015318d>] handle_fasteoi_irq+0x71/0xa4
[  167.247302]  [<c0105f3a>] do_IRQ+0x4d/0x63
[  167.247302]  [<c0102656>] default_idle+0x0/0x53
[  167.247302]  [<c01042a7>] common_interrupt+0x23/0x28
[  167.247302]  [<c0102656>] default_idle+0x0/0x53
[  167.247302]  [<c0114d68>] native_safe_halt+0x2/0x3
[  167.247302]  [<c0102683>] default_idle+0x2d/0x53

After that the system crashes:

[  167.247302] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  167.247302] IP: [<00000000>]
[  167.247302] *pde = 00000000
[  167.247302] Oops: 0000 [#1] SMP
[  167.247302] Modules linked in: pri firmware_class ipv6 loop parport_pc parport snd_pcm snd_timer snd soundcore snd_page_alloc serio_raw button shpchp pcspkr pci_hotplug psmouse i2c_piix4 sworks_agp i2c_core agpgart dcdbas evdev ext3 jbd mbcache sd_mod ide_cd_mod cdrom sg ide_pci_generic serverworks ide_core aic7xxx ata_generic ohci_hcd scsi_transport_spi floppy libata e100 mii usbcore scsi_mod dock e1000 thermal processor fan thermal_sys
[  167.247302]
[  167.247302] Pid: 2, comm: kthreadd Not tainted (2.6.26-2-686 #1)
[  167.247302] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 0
[  167.247302] EIP is at 0x0
[  167.247302] EAX: c1615fa0 EBX: c02c4e20 ECX: 00000001 EDX: ef471500
[  167.247302] ESI: ef471500 EDI: c1615fa0 EBP: 00000001 ESP: ef443f5c
[  167.247302]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  167.247302] Process kthreadd (pid: 2, ti=ef442000 task=ef43f4e0 task.ti=ef442000)
[  167.247302] Stack: c01188fe c1615fa0 ef471500 00000001 c0118924 ef471500 c1615fa0 c011b68c
[  167.247302]        00000003 00000002 ef475e54 ef475e94 00000001 00000001 c01184a9 00000000
[  167.247302]        00000003 ef475e9c ef475e98 ef475e9c 00000296 00000000 c011a618 00000000
[  167.247302] Call Trace:
[  167.247302]  [<c01188fe>] enqueue_task+0x52/0x5d
[  167.247302]  [<c0118924>] activate_task+0x1b/0x26
[  167.247302]  [<c011b68c>] try_to_wake_up+0xaf/0xf1
[  167.247302]  [<c01184a9>] __wake_up_common+0x2e/0x58
[  167.247302]  [<c011a618>] complete+0x28/0x36
[  167.247302]  [<c0131773>] kthreadd+0x112/0x13a
[  167.247302]  [<c0131661>] kthreadd+0x0/0x13a
[  167.247302]  [<c01044f3>] kernel_thread_helper+0x7/0x10
[  167.247302]  =======================
[  167.247302] Code:  Bad EIP value.
[  167.247302] EIP: [<00000000>] 0x0 SS:ESP 0068:ef443f5c
[  167.247302] ---[ end trace 22fd0ce8ade70dbc ]---
[  167.267303]  [<c01025ce>] cpu_idle+0xab/0xcb
[  167.267303]  =======================


Am I being a naughty boy?
