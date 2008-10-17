Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYJQBAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYJQBAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJQBAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:00:46 -0400
Received: from gw.goop.org ([64.81.55.164]:58957 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbYJQBAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:00:44 -0400
Message-ID: <48F7E3B8.2090106@goop.org>
Date: Thu, 16 Oct 2008 18:00:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0810161921460.31660-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810161921460.31660-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> And at that point qh must be equal to uhci->next_qh.  There are only 
> about five places where uhci->next_qh is assigned to; you could test 
> each of them for NULL.
>   

OK.

>> OK, with uhci-hcd.debug=2 on the kernel command line I still get an 
>> oops, but in a different function.  I guess the qh list is corrupt 
>> either way?
>>     
>
> It sure looks that way.
>
>   
>> uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
>> usb usb2: default language 0x0409
>> uhci_hcd 0000:00:1d.0: host controller halted, very bad!
>> BUG: unable to handle kernel NULL pointer dereference<7>usb usb2: uevent
>>  at 0000000000000020
>> IP: [<ffffffff803b0d29>] uhci_show_qh+0x228/0x59d
>>     
>
> I guess you also better add code to uhci_sprint_schedule() in 
> uhci-debug.c to check each assignment to qh (there are only two) for 
> NULL, and jump directly to the next iteration of the "for i" loop when 
> you see it.
>   
Looks like this is the relevent detail: "uhci->skelqh[1]->node.next is 
NULL" for all the queues.  Haven't looked into it yet.

hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
/home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-tip uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
 [<ffffffff80235786>] ? try_to_wake_up+0x198/0x1aa
 [<ffffffff802357a5>] ? default_wake_function+0xd/0xf
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff80464744>] ? _spin_unlock_irqrestore+0x1b/0x20
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff8020ea9b>] ? xen_clocksource_read+0x21/0x23
 [<ffffffff8024ef4c>] ? run_posix_cpu_timers+0x27/0x73d
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff803b1d4f>] uhci_scan_schedule+0xb7/0x9a3
 [<ffffffff8020eb38>] ? xen_vcpuop_set_next_event+0x52/0x66
 [<ffffffff80328d89>] ? _raw_spin_lock+0x68/0x10b
 [<ffffffff803b2f93>] uhci_hub_status_data+0x38/0x179
 [<ffffffff80398b1c>] usb_hcd_poll_rh_status+0x49/0x14f
 [<ffffffff80399261>] ? rh_timer_func+0x0/0xb
 [<ffffffff8039926a>] rh_timer_func+0x9/0xb
 [<ffffffff8024363b>] run_timer_softirq+0x175/0x1ef
 [<ffffffff8023f746>] __do_softirq+0x8a/0x150
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
 [<ffffffff8021374c>] call_softirq+0x1c/0x28
 [<ffffffff80214885>] do_softirq+0x44/0x8b
 [<ffffffff8023f44a>] irq_exit+0x3f/0x82
 [<ffffffff80365f0a>] xen_evtchn_do_upcall+0x19d/0x1be
 [<ffffffff80464f2e>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI>  [<ffffffff8020922a>] ? _stext+0x22a/0x1000
 [<ffffffff8020922a>] ? _stext+0x22a/0x1000
 [<ffffffff8020e584>] ? xen_restore_fl+0x39/0x3b
 [<ffffffff8023b421>] ? vprintk+0x2e5/0x312
 [<ffffffff8039a313>] ? urb_destroy+0x0/0x28
 [<ffffffff80320efd>] ? kref_put+0x43/0x4f
 [<ffffffff8039a1a8>] ? usb_free_urb+0x15/0x17
 [<ffffffff80461fb1>] ? printk+0x67/0x6e
 [<ffffffff8039b242>] ? usb_control_msg+0xe0/0xf1
 [<ffffffff80396066>] ? hub_probe+0x3c4/0xa3a
 [<ffffffff8039c1f0>] ? usb_match_one_id+0x2b/0x88
 [<ffffffff8039c76f>] ? usb_probe_interface+0x13c/0x16a
 [<ffffffff8038e29b>] ? driver_probe_device+0xc0/0x16e
 [<ffffffff8038e3c2>] ? __device_attach+0x0/0xb
 [<ffffffff8038e3cb>] ? __device_attach+0x9/0xb
 [<ffffffff8038d83b>] ? bus_for_each_drv+0x51/0x88
 [<ffffffff8038e455>] ? device_attach+0x64/0x7b
 [<ffffffff8038d679>] ? bus_attach_device+0x28/0x59
 [<ffffffff8038c523>] ? device_add+0x3a9/0x54f
 [<ffffffff80290cea>] ? kfree+0xed/0xfa
 [<ffffffff8039bf52>] ? usb_set_configuration+0x4c7/0x521
 [<ffffffff803a30fe>] ? generic_probe+0x55/0x9b
 [<ffffffff8039c801>] ? usb_probe_device+0x64/0x69
 [<ffffffff8038e29b>] ? driver_probe_device+0xc0/0x16e
 [<ffffffff8038e3c2>] ? __device_attach+0x0/0xb
 [<ffffffff8038e3cb>] ? __device_attach+0x9/0xb
 [<ffffffff8038d83b>] ? bus_for_each_drv+0x51/0x88
 [<ffffffff8038e455>] ? device_attach+0x64/0x7b
 [<ffffffff8038d679>] ? bus_attach_device+0x28/0x59
 [<ffffffff8038c523>] ? device_add+0x3a9/0x54f
 [<ffffffff8039580d>] ? usb_new_device+0x5b/0x16b
 [<ffffffff80328d89>] ? _raw_spin_lock+0x68/0x10b
 [<ffffffff80397377>] ? hub_thread+0xc9b/0x127c
 [<ffffffff8020bb19>] ? xen_leave_lazy+0x15/0x17
 [<ffffffff8024d69b>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803966dc>] ? hub_thread+0x0/0x127c
 [<ffffffff8024d2ee>] ? kthread+0x49/0x76
 [<ffffffff80213339>] ? child_rip+0xa/0x11
 [<ffffffff8021264d>] ? retint_restore_args+0x5/0x20
 [<ffffffff8021332f>] ? child_rip+0x0/0x11
---[ end trace 7c092a45d81b69fc ]---
------------[ cut here ]------------
WARNING: at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1744 uhci_scan_schedule+0xb7/0x9a3()
uhci->skelqh[1]->node.next is NULL
Modules linked in:
Pid: 125, comm: khubd Tainted: G        W 2.6.27-tip #241
Call Trace:
 <IRQ>  [<ffffffff8023a6d5>] warn_slowpath+0xae/0xd7
 [<ffffffff80235786>] ? try_to_wake_up+0x198/0x1aa
 [<ffffffff802357a5>] ? default_wake_function+0xd/0xf
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff80464744>] ? _spin_unlock_irqrestore+0x1b/0x20
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff8020ea9b>] ? xen_clocksource_read+0x21/0x23
 [<ffffffff8024ef4c>] ? run_posix_cpu_timers+0x27/0x73d
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff80225832>] ? pvclock_clocksource_read+0x42/0x7e
 [<ffffffff803b1d4f>] uhci_scan_schedule+0xb7/0x9a3
 [<ffffffff8020eb38>] ? xen_vcpuop_set_next_event+0x52/0x66
 [<ffffffff80328d89>] ? _raw_spin_lock+0x68/0x10b
 [<ffffffff803b2f93>] uhci_hub_status_data+0x38/0x179
 [<ffffffff80398b1c>] usb_hcd_poll_rh_status+0x49/0x14f
 [<ffffffff80399261>] ? rh_timer_func+0x0/0xb
 [<ffffffff8039926a>] rh_timer_func+0x9/0xb
 [<ffffffff8024363b>] run_timer_softirq+0x175/0x1ef
 [<ffffffff8023f746>] __do_softirq+0x8a/0x150
 [<ffffffff8021374c>] call_softirq+0x1c/0x28
 [<ffffffff80214885>] do_softirq+0x44/0x8b
 [<ffffffff8023f44a>] irq_exit+0x3f/0x82
 [<ffffffff80365f0a>] xen_evtchn_do_upcall+0x19d/0x1be
 [<ffffffff80464f2e>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI>  [<ffffffff8020922a>] ? _stext+0x22a/0x1000
 [<ffffffff8020922a>] ? _stext+0x22a/0x1000
 [<ffffffff8020e584>] ? xen_restore_fl+0x39/0x3b
 [<ffffffff8023b421>] ? vprintk+0x2e5/0x312
 [<ffffffff8039a313>] ? urb_destroy+0x0/0x28
 [<ffffffff80320efd>] ? kref_put+0x43/0x4f
 [<ffffffff8039a1a8>] ? usb_free_urb+0x15/0x17
 [<ffffffff80461fb1>] ? printk+0x67/0x6e
 [<ffffffff8039b242>] ? usb_control_msg+0xe0/0xf1
 [<ffffffff80396066>] ? hub_probe+0x3c4/0xa3a
 [<ffffffff8039c1f0>] ? usb_match_one_id+0x2b/0x88
 [<ffffffff8039c76f>] ? usb_probe_interface+0x13c/0x16a
 [<ffffffff8038e29b>] ? driver_probe_device+0xc0/0x16e
 [<ffffffff8038e3c2>] ? __device_attach+0x0/0xb
 [<ffffffff8038e3cb>] ? __device_attach+0x9/0xb
 [<ffffffff8038d83b>] ? bus_for_each_drv+0x51/0x88
 [<ffffffff8038e455>] ? device_attach+0x64/0x7b
 [<ffffffff8038d679>] ? bus_attach_device+0x28/0x59
 [<ffffffff8038c523>] ? device_add+0x3a9/0x54f
 [<ffffffff80290cea>] ? kfree+0xed/0xfa
 [<ffffffff8039bf52>] ? usb_set_configuration+0x4c7/0x521
 [<ffffffff803a30fe>] ? generic_probe+0x55/0x9b
 [<ffffffff8039c801>] ? usb_probe_device+0x64/0x69
 [<ffffffff8038e29b>] ? driver_probe_device+0xc0/0x16e
 [<ffffffff8038e3c2>] ? __device_attach+0x0/0xb
 [<ffffffff8038e3cb>] ? __device_attach+0x9/0xb
 [<ffffffff8038d83b>] ? bus_for_each_drv+0x51/0x88
 [<ffffffff8038e455>] ? device_attach+0x64/0x7b
 [<ffffffff8038d679>] ? bus_attach_device+0x28/0x59
 [<ffffffff8038c523>] ? device_add+0x3a9/0x54f
 [<ffffffff8039580d>] ? usb_new_device+0x5b/0x16b
 [<ffffffff80328d89>] ? _raw_spin_lock+0x68/0x10b
 [<ffffffff80397377>] ? hub_thread+0xc9b/0x127c
 [<ffffffff8020bb19>] ? xen_leave_lazy+0x15/0x17
 [<ffffffff8024d69b>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803966dc>] ? hub_thread+0x0/0x127c
 [<ffffffff8024d2ee>] ? kthread+0x49/0x76
 [<ffffffff80213339>] ? child_rip+0xa/0x11
 [<ffffffff8021264d>] ? retint_restore_args+0x5/0x20
 [<ffffffff8021332f>] ? child_rip+0x0/0x11


> Maybe make this change first, since it will be easier and it might give 
> a good idea of where to look in uhci-q.c.
>
> By the way, would there be any problem caused by the fact that the 
> hardware can only use 32-bit DMA addresses?
>   

No.  I'm explicitly asking for memory under 4G (and this machine only 
has 2G anyway).

    J
