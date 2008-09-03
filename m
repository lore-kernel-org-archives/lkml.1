Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYICRhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYICRhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYICRgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:36:46 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:54838 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbYICRgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:36:41 -0400
Date: Wed, 3 Sep 2008 14:36:53 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Nezhevenko <dion@inhex.net>, herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903143653.68bb58df@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902175544.131bc54e@doriath.conectiva>
	<alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
	<20080903104132.7a736282@doriath.conectiva>
	<alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
	<20080903164415.GA24442@laptop.local>
	<alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/xxLbbLDRHnZPm99twoKDe7M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/xxLbbLDRHnZPm99twoKDe7M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Em Wed, 3 Sep 2008 19:05:39 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| On Wed, 3 Sep 2008, Dmitry Nezhevenko wrote:
| > On Wed, Sep 03, 2008 at 05:15:40PM +0200, Thomas Gleixner wrote:
| > > On Wed, 3 Sep 2008, Thomas Gleixner wrote:
| > > > Dont think so. Your dmesg outputs do not show any sign of that
| > > > disease.
| > > > 
| > > > Can you try the patch below please ?
| > 
| > I'm not original problem reporter. However I'm experiencing possible same
| > problem with MSI M673 laptop. Here is link to bugzilla report (with
| > dmesgs and other info):
| > http://bugzilla.kernel.org/show_bug.cgi?id=11101
| > 
| > 2.6.27-rc4 on this machine freezes with exactly same messages:
| > 
| > hpet0: at MMIO 0xfed00000, IRQ 2, 8, 31
| > hpet0: 3 32-bit timers, 25000000 Hz
| > ACPI: RTC can wake from S4
| > 
| > This patch do not help me
| > 
| > > @@ -228,6 +228,8 @@ static void tick_do_broadcast_on_off(voi
| > >  	if (!tick_device_is_functional(dev))
| > >  		goto out;
| > >  
| > > +	bc_stoppped = cpus_empty(tick_broadcast_mask);
| > 
| > btw little type here, should be "bc_stopped"
| 
| Yeah, noticed already. Sorry.
| 
| Find a debug patch below, which looks at the two functions which might
| loop forver under certain conditions. Does one of the checks hit ?

 I can actually boot with this patch. Was this intended?

 As the dmesg has various WARN_ON() outputs I'm attaching it, this is
the first one:

"""
PCI: Using ACPI for IRQ routing
DMAR:parse DMAR table failure.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Switched to high resolution mode on CPU 0
tick_broadcast_set_event is stuck f09fa64 f0a01e4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
Switched to high resolution mode on CPU 1
"""

-- 
Luiz Fernando N. Capitulino

--MP_/xxLbbLDRHnZPm99twoKDe7M
Content-Type: text/plain; name=dmesg.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.txt

Linux version 2.6.27-rc5-test9 (lcapitulino@build1.conectiva) (gcc version 4.3.2 (GCC) ) #69 SMP Wed Sep 3 14:24:30 BRT 2008
Command line: root=UUID=4c906e0e-7507-11dd-8b10-0019bbeb0788
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bf00000 (usable)
 BIOS-e820: 000000003bf00000 - 000000003bf16000 (ACPI data)
 BIOS-e820: 000000003bf16000 - 000000003bf80000 (ACPI NVS)
 BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
last_pfn = 0x3bf00 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 003be00000 page 2M
 003be00000 - 003bf00000 page 4k
kernel direct mapping tables up to 3bf00000 @ 8000-b000
last_map_addr: 3bf00000 end: 3bf00000
RAMDISK: 37c1f000 - 37fefe9e
DMI present.
Compaq Presario V6000: using 0xed I/O delay port
ACPI: RSDP 000F88F0, 0014 (r0 HP    )
ACPI: RSDT 3BF0CE48, 003C (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 3BF15D10, 0074 (r1 HP     MCP51M    6040000 PTL_    F4240)
ACPI: DSDT 3BF0CE84, 8E8C (r1 HP       MCP51M  6040000 MSFT  3000000)
ACPI: FACS 3BF16FC0, 0040
ACPI: SSDT 3BF15D84, 0182 (r1 PTLTD  POWERNOW  6040000  LTP        1)
ACPI: MCFG 3BF15F06, 003C (r1 HP       MCFG    6040000  LTP        0)
ACPI: HPET 3BF15F42, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC 3BF15F7A, 005E (r1 HP     	 APIC    6040000  LTP        0)
ACPI: BOOT 3BF15FD8, 0028 (r1     HP $SBFTBL$  6040000  LTP        1)
ACPI: DMI detected: Hewlett-Packard
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003bf00000
Bootmem setup node 0 0000000000000000-000000003bf00000
  NODE_DATA [0000000000001000 - 0000000000005fff]
  bootmap [0000000000009000 -  00000000000107df] pages 8
(6 early reservations) ==> bootmem [0000000000 - 003bf00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000d59050]    TEXT DATA BSS ==> [0000200000 - 0000d59050]
  #3 [0037c1f000 - 0037fefe9e]          RAMDISK ==> [0037c1f000 - 0037fefe9e]
  #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff8800000f8920] 000f8920
 [ffffe20000000000-ffffe200015fffff] PMD -> [ffff880001200000-ffff8800027fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0003bf00
On node 0 totalpages: 245405
  DMA zone: 900 pages, LIFO batch:0
  DMA32 zone: 236221 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 52384 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 237121
Policy zone: DMA32
Kernel command line: root=UUID=4c906e0e-7507-11dd-8b10-0019bbeb0788
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1607.292 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 3839 kB
 per task-struct memory footprint: 1920 bytes
Checking aperture...
No AGP bridge found
Node 0: aperture @ 3840000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 943276k/982016k available (2689k kernel code, 38344k reserved, 1338k data, 472k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3214.58 BogoMIPS (lpj=1607292)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 0/0 -> Node 0
tseg: 003bf80000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557018
Detected 12.557 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3214.68 BogoMIPS (lpj=1607344)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: <6>System has C1E enabled
Switch to broadcast mode on CPU1
AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6429.27 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
Switch to broadcast mode on CPU0
net_namespace: 696 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fe0bffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [40000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 6
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e06fffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:0a.1: PME# supported from D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0b.0: supports D1
pci 0000:00:0b.0: supports D2
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0b.1: supports D1
pci 0000:00:0b.1: supports D2
pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.1: PME# disabled
pci 0000:00:10.1: PME# supported from D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:14.0: supports D1
pci 0000:00:14.0: supports D2
pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:14.0: PME# disabled
PCI: bridge 0000:00:02.0 io port: [4000, 4fff]
PCI: bridge 0000:00:02.0 32bit mmio: [b4000000, b7ffffff]
PCI: bridge 0000:00:02.0 64bit mmio pref: [d0000000, d01fffff]
PCI: bridge 0000:00:03.0 io port: [5000, 5fff]
PCI: bridge 0000:00:03.0 32bit mmio: [b8000000, bbffffff]
PCI: bridge 0000:00:03.0 64bit mmio pref: [d0200000, d03fffff]
pci 0000:00:10.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 7) *11
ACPI: PCI Interrupt Link [LNK3] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 18) *11
ACPI: PCI Interrupt Link [LK4E] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs *10)
ACPI: PCI Interrupt Link [LPMU] (IRQs 11) *10
ACPI: PCI Interrupt Link [LUS0] (IRQs 22) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 22) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *10
ACPI: PCI Interrupt Link [LAZA] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 23) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 20) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
DMAR:parse DMAR table failure.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Switched to high resolution mode on CPU 0
tick_broadcast_set_event is stuck f09fa64 f0a01e4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
Switched to high resolution mode on CPU 1
ACPI: RTC can wake from S4
system 00:00: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:01: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:03: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:04: ioport range 0x1000-0x107f has been reserved
system 00:04: ioport range 0x1080-0x10ff has been reserved
system 00:04: ioport range 0x1400-0x147f has been reserved
system 00:04: ioport range 0x1480-0x14ff has been reserved
system 00:04: ioport range 0x1800-0x187f has been reserved
system 00:04: ioport range 0x1880-0x18ff has been reserved
system 00:04: ioport range 0x2000-0x203f has been reserved
system 00:05: ioport range 0x360-0x361 has been reserved
system 00:05: ioport range 0x380-0x383 has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0x4000-0x4fff
pci 0000:00:02.0:   MEM window: 0xb4000000-0xb7ffffff
pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000d01fffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
pci 0000:00:03.0:   IO window: 0x5000-0x5fff
pci 0000:00:03.0:   MEM window: 0xb8000000-0xbbffffff
pci 0000:00:03.0:   PREFETCH window: 0x000000d0200000-0x000000d03fffff
pci 0000:00:10.0: PCI bridge, secondary bus 0000:07
pci 0000:00:10.0:   IO window: disabled
pci 0000:00:10.0:   MEM window: disabled
pci 0000:00:10.0:   PREFETCH window: disabled
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:10.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [4000, 4fff]
bus: 01 index 1 mmio: [b4000000, b7ffffff]
bus: 01 index 2 mmio: [d0000000, d01fffff]
bus: 01 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [5000, 5fff]
bus: 03 index 1 mmio: [b8000000, bbffffff]
bus: 03 index 2 mmio: [d0200000, d03fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 07 index 0 mmio: [0, 0]
bus: 07 index 1 mmio: [0, 0]
bus: 07 index 2 mmio: [0, 0]
bus: 07 index 3 io port: [0, ffff]
bus: 07 index 4 mmio: [0, ffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3907k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1220462972.690:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1849
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:02.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Boot video device
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie03: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pci_express 0000:00:03.0:pcie03: allocate port service
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 472k freed
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
No dock devices found.
libata version 3.00 loaded.
sata_nv 0000:00:0e.0: version 3.5
sata_nv 0000:00:0e.0: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
sata_nv 0000:00:0e.0: PCI INT A -> Link[LTID] -> GSI 23 (level, high) -> IRQ 23
sata_nv 0000:00:0e.0: Using SWNCQ mode
sata_nv 0000:00:0e.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x30c0 ctl 0x30b4 bmdma 0x3090 irq 23
ata2: SATA max UDMA/133 cmd 0x30b8 ctl 0x30b0 bmdma 0x3098 irq 23
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input1
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HTS541010G9SA00, MBZOC60P, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: Drive reports diagnostics failure. This may indicate a drive
ata1.00: fault or invalid emulation. Contact drive vendor for information.
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
pata_amd 0000:00:0d.0: version 0.3.10
pata_amd 0000:00:0d.0: setting latency timer to 64
scsi2 : pata_amd
scsi3 : pata_amd
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x3080 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x3088 irq 15
ata3.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.05, max MWDMA2
ata3: nv_mode_filter: 0x39f&0x39f->0x39f, BIOS=0x0 (0xc600) ACPI=0x39f (120:600:0x12)
ata3.00: configured for MWDMA2
ata4: port disabled. ignoring.
scsi 2:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.05 PQ: 0 ANSI: 5
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda9: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 550642
ext3_orphan_cleanup: deleting unreferenced inode 546723
ext3_orphan_cleanup: deleting unreferenced inode 550637
ext3_orphan_cleanup: deleting unreferenced inode 549531
ext3_orphan_cleanup: deleting unreferenced inode 549530
ext3_orphan_cleanup: deleting unreferenced inode 549741
ext3_orphan_cleanup: deleting unreferenced inode 550636
ext3_orphan_cleanup: deleting unreferenced inode 549737
ext3_orphan_cleanup: deleting unreferenced inode 549343
ext3_orphan_cleanup: deleting unreferenced inode 546731
ext3_orphan_cleanup: deleting unreferenced inode 546725
ext3_orphan_cleanup: deleting unreferenced inode 549492
ext3_orphan_cleanup: deleting unreferenced inode 546728
ext3_orphan_cleanup: deleting unreferenced inode 546722
ext3_orphan_cleanup: deleting unreferenced inode 546729
ext3_orphan_cleanup: deleting unreferenced inode 546726
ext3_orphan_cleanup: deleting unreferenced inode 546727
EXT3-fs: sda9: 17 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
tick_broadcast_set_event is stuck 2e4dabdd4 2e4dac554
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
ACPI: AC Adapter [ACAD] (on-line)
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (60 C)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input4
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID]
ACPI: Battery Slot [BAT0] (battery present)
ACPI: WMI: Mapper loaded
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 2:0:0:0: Attached scsi generic sg1 type 5
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
forcedeth 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 20 (level, high) -> IRQ 20
forcedeth 0000:00:14.0: setting latency timer to 64
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, hpet irqs
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:bb:eb:07:88
forcedeth 0000:00:14.0: highdma pwrctl timirq lnktim desc-v3
Non-volatile memory driver v1.2
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-50 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
tick_broadcast_set_event is stuck 369ec9fc4 369eca744
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 36bf3757c 36bf37cfc
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
floppy0: no floppy controllers found
tick_broadcast_set_event is stuck 424eb43d4 424eb4b54
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 425ade3e4 425adeb64
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff8036d0f4>] ? delay_tsc+0x44/0x90
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 425fa1b4c 425fa22cc
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
EXT3 FS on sda9, internal journal
loop: module loaded
tick_broadcast_set_event is stuck 489d46014 489d46794
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
Adding 257000k swap on /dev/sda1.  Priority:-1 extents:1 across:257000k
tick_broadcast_set_event is stuck 495dec494 495decc14
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff8036d0f4>] ? delay_tsc+0x44/0x90
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 4adb64b64 4adb652e4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff8036d0f4>] ? delay_tsc+0x44/0x90
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 4d966dfbc 4d966e73c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
Clocksource tsc unstable (delta = -77578803 ns)
tick_broadcast_set_event is stuck 54db0c6bc 54db0ce3c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 61225b87c 61225bffc
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 6288f0c6c 6288f13ec
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 6b3cb9494 6b3cb9c14
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 6bb2fd68c 6bb2fde0c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 6e160d70c 6e160de8c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
NET: Registered protocol family 17
tick_broadcast_set_event is stuck 7736c8e84 7736c9604
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
tick_broadcast_set_event is stuck 7fdb5010c 7fdb5088c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 802c5fd7c 802c604fc
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 83e7f4904 83e7f5084
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 8413d2ddc 8413d355c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 86f5f8174 86f5f88f4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 8801b78c4 8801b8044
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 893e926bc 893e92e3c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 8a1d7f21c 8a1d7f99c
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 8b38f9064 8b38f97e4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 904627344 904627ac4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80496286>] start_secondary+0x151/0x1ab

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 9b49ee044 9b49ee7c4
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---
tick_broadcast_set_event is stuck 1003403db4 1003404534
------------[ cut here ]------------
WARNING: at kernel/time/tick-broadcast.c:383 tick_broadcast_set_event+0x97/0xc0()
Modules linked in: af_packet binfmt_misc loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table nvram rtc_cmos k8temp sr_mod forcedeth sg wmi battery button thermal processor ac evdev joydev pata_amd sata_nv libata dock sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-test9 #69

Call Trace:
 [<ffffffff80246a4f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80498e87>] ? printk+0x67/0x70
 [<ffffffff8036489a>] ? __next_cpu+0x1a/0x30
 [<ffffffff802655c9>] ? getnstimeofday+0x49/0xc0
 [<ffffffff80262979>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80269177>] tick_broadcast_set_event+0x97/0xc0
 [<ffffffff802692ba>] tick_broadcast_oneshot_control+0x11a/0x130
 [<ffffffff80268dd5>] tick_notify+0x2f5/0x420
 [<ffffffff8026379f>] notifier_call_chain+0x3f/0x80
 [<ffffffff80263891>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026853b>] clockevents_notify+0x2b/0x90
 [<ffffffff80215ab5>] c1e_idle+0x85/0x130
 [<ffffffff80263eb1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020ae42>] cpu_idle+0x72/0x100
 [<ffffffff80489611>] rest_init+0x61/0x70

---[ end trace 4eaa2a86a8e2da22 ]---

--MP_/xxLbbLDRHnZPm99twoKDe7M--
