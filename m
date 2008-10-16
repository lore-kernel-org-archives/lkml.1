Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYJPWC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYJPWC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYJPWCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:02:16 -0400
Received: from gw.goop.org ([64.81.55.164]:34926 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbYJPWCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:02:14 -0400
Message-ID: <48F7B9E0.90407@goop.org>
Date: Thu, 16 Oct 2008 15:02:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0810160949100.2487-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810160949100.2487-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> uhci-hcd uses dma_allocate_coherent() and dma_pool_create() with 
> dma_pool_alloc().  If either of these returned an area of memory that 
> crossed a physical page boundary then there might be trouble -- but 
> there probably would already be trouble in non-virtualized systems too!
>   

Hm, that should be OK then.  No chance something is simply using __pa() 
on an address rather than using the proper dma address?

>> The problem I'm seeing is this:
>>
>> xen_create_contiguous_region: vstart=ffff880073ff0000 order=0 addr_bits=20
>> uhci_hcd 0000:00:1d.0:  -> ret ffff880073ff0000 dma 79b6c000
>> uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
>> uhci_hcd 0000:00:1d.0: host controller halted, very bad!
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> IP: [<ffffffff803acb56>] uhci_scan_schedule+0xa8/0x85f
>> PGD 0 
>> Thread overran stack, or stack corrupted
>>     
>
> That last line sounds bad in and of itself.
>   

Hm, could well be spurious.

>> The RIP corresponds to:
>> 0xffffffff803acb56 is in uhci_scan_schedule 
>> (/home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1740).
>>
>> 1740                uhci->next_qh = list_entry(qh->node.next,
>> 1741                        struct uhci_qh, node);
>>     
>
> Does this mean that qh is NULL?  I don't have a 64-bit system so I 
> can't tell just where in the instruction stream the fault occurred.  
> Maybe you can add one or two debugging printks in there to figure out 
> exactly what's going wrong.
>   

Yes, it must be qh which is NULL.  uhci is the only other dereference 
there, and must be non-NULL to get to that point.

>> If you have any hints as to what's causing the host controller process 
>> error and how I might go about debugging it, that would be very useful.
>>     
>
> You should start by loading uhci-hcd with the debug=2 parameter setting
> (you'll have to enable CONFIG_USB_DEBUG).  Then when an HC process
> error occurs, the driver will dump its internal data structures to the 
> system log.
>   

OK, with uhci-hcd.debug=2 on the kernel command line I still get an 
oops, but in a different function.  I guess the qh list is corrupt 
either way?

ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 31
xen: PCI device 0000:00:1d.7 pin 4 -> irq 31
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
/home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/inode.c: creating file 'devices'
/home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: xen_alloc_coherent: size=4096 handlep=ffff880075371498 gfp=24
xen_create_contiguous_region: vstart=ffff880073f2b000 order=0 addr_bits=20
ehci_hcd 0000:00:1d.7:  -> ret ffff880073f2b000 dma 7dda2000
ehci_hcd 0000:00:1d.7: xen_alloc_coherent: size=4096 handlep=ffff880075371458 gfp=24
xen_create_contiguous_region: vstart=ffff880073f2c000 order=0 addr_bits=20
ehci_hcd 0000:00:1d.7:  -> ret ffff880073f2c000 dma 79830000
ehci_hcd 0000:00:1d.7: xen_alloc_coherent: size=4096 handlep=ffff880073f7adb0 gfp=4
xen_create_contiguous_region: vstart=ffff880073f2d000 order=0 addr_bits=20
ehci_hcd 0000:00:1d.7:  -> ret ffff880073f2d000 dma 7982f000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 31, io mem 0xdff00000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
ehci_hcd 0000:00:1d.7: xen_alloc_coherent: size=4096 handlep=ffff880075371318 gfp=24
xen_create_contiguous_region: vstart=ffff88007538e000 order=0 addr_bits=20
ehci_hcd 0000:00:1d.7:  -> ret ffff88007538e000 dma 7982e000
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3: status 0501 change 0001
hub 1-0:1.0: state 7 ports 6 chg 0008 evt 0000
/home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/inode.c: creating file '001'
hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-tip ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
USB Universal Host Controller Interface driver v3.0
xen: enabling pci device 0000:00:1d.0 pin 1
xen: registering gsi 16 triggering 0 polarity 1
xen_allocate_pirq: returning irq 29 for gsi 16
xen: --> irq=29
xen_set_ioapic_routing: irq 29 gsi 16 vector 152 ioapic 0 pin 16 triggering 0 polarity 1
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 29
xen: PCI device 0000:00:1d.0 pin 1 -> irq 29
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
/home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 29, io base 0x0000bce0
uhci_hcd 0000:00:1d.0: xen_alloc_coherent: size=4096 handlep=ffff880073f7bdf8 gfp=4
xen_create_contiguous_region: vstart=ffff880073fde000 order=0 addr_bits=20
uhci_hcd 0000:00:1d.0:  -> ret ffff880073fde000 dma 7dfcd000
uhci_hcd 0000:00:1d.0: xen_alloc_coherent: size=4096 handlep=ffff880075371158 gfp=24
xen_create_contiguous_region: vstart=ffff880073fdf000 order=0 addr_bits=20
uhci_hcd 0000:00:1d.0:  -> ret ffff880073fdf000 dma 79b7d000
uhci_hcd 0000:00:1d.0: xen_alloc_coherent: size=4096 handlep=ffff880075371118 gfp=24
xen_create_contiguous_region: vstart=ffff880073f74000 order=0 addr_bits=20
uhci_hcd 0000:00:1d.0:  -> ret ffff880073f74000 dma 79b7c000
uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
usb usb2: default language 0x0409
uhci_hcd 0000:00:1d.0: host controller halted, very bad!
BUG: unable to handle kernel NULL pointer dereference<7>usb usb2: uevent
 at 0000000000000020
IP: [<ffffffff803b0d29>] uhci_show_qh+0x228/0x59d
PGD 0 
Thread overran stack, or stack corrupted
Oops: 0000 [#1] SMP 
Dumping ftrace buffer:
   (ftrace buffer empty)
CPU 0 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-tip #236
RIP: e030:[<ffffffff803b0d29>]  [<ffffffff803b0d29>] uhci_show_qh+0x228/0x59d
RSP: e02b:ffffffff80661cc8  EFLAGS: 00010003
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: ffff880073f74000 RSI: 0000000000000000 RDI: ffffffff8051c332
RBP: ffffffff80661d58 R08: 00000000ffffffff R09: 0000000000000000
R10: ffff8800f3fc8450 R11: 0000000000000010 R12: ffff880073fc84af
R13: ffff880073f7bd58 R14: ffff880073f74000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff805b6f40(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000000201000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805bc000, task ffffffff805773a0)
Stack:
 0000000000000000 0000000000000000 0000000000000000 0000000047c39500
 ffffffff80661d58 00007baf00000004 ffff880073fc8451 ffff880073f74000
 ffff880073f74030 ffffffff8051c332 ffffffff8051c332 ffffffff8051c332
Call Trace:
 <IRQ> <0> [<ffffffff803b16cf>] uhci_sprint_schedule+0x631/0x77a
 [<ffffffff803b427c>] uhci_irq+0x11a/0x18a
 [<ffffffff8039822b>] usb_hcd_irq+0x42/0x90
 [<ffffffff80251a7e>] ? __update_sched_clock+0x1e/0x93
 [<ffffffff8026164a>] handle_IRQ_event+0x2e/0x65
 [<ffffffff80262b35>] handle_level_irq+0x91/0xe2
 [<ffffffff80214a6d>] handle_irq+0x27/0x36
 [<ffffffff80365f05>] xen_evtchn_do_upcall+0x198/0x1be
 [<ffffffff80464e5e>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI> <0> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
 [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
 [<ffffffff8020e5e0>] ? xen_safe_halt+0x10/0x1a
 [<ffffffff8020be00>] ? xen_idle+0x34/0x48
 [<ffffffff80211188>] ? cpu_idle+0x51/0x92
 [<ffffffff80454598>] ? rest_init+0x5c/0x5e
 [<ffffffff805e5d64>] ? start_kernel+0x409/0x414
 [<ffffffff805e52ba>] ? x86_64_start_reservations+0xa5/0xa9
 [<ffffffff805e9532>] ? xen_start_kernel+0x96f/0x981
Code: 48 98 49 01 c4 49 3b 4d 70 0f 85 30 03 00 00 8b 55 9c 49 8b 7d 20 03 55 a0 31 c9 44 29 e2 4c 89 e6 e8 e1 fa ff ff e9 0f 03 00 00 <48> 8b 40 20 3b 58 f8 74 20 4c 89 e7 48 c7 c1 32 c3 51 80 8b 55 
RIP  [<ffffffff803b0d29>] uhci_show_qh+0x228/0x59d
 RSP <ffffffff80661cc8>
CR2: 0000000000000020
Kernel panic - not syncing: Fatal exception in interrupt

Thanks,
	J



