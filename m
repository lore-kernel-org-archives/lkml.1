Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbYLXQfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbYLXQfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 11:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLXQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 11:35:32 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:46917 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYLXQf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 11:35:29 -0500
Date: Wed, 24 Dec 2008 22:04:00 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081224163400.GA11562@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au> <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <495153A4.5060201@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org> [2008-12-23 13:09:56]:

> Kamalesh Babulal wrote:
> > * Yinghai Lu <yinghai@kernel.org> [2008-12-19 13:02:40]:
> > 
> > 
> > 	I tried testing with today's tip/master and it can be reproduced with it.
> > 
> > root (hd0,0)
> >  Filesystem type is ext2fs, partition type 0x83
> > kernel /vmlinuz-autotest root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 c
> > onsole=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall
> > _debug earlyprintk=serial,ttyS1,19200 IDENT=1230036460
> >    [Linux-bzImage, setup=0x3000, size=0x273c10]
> > initrd /initrd-autotest
> >    [Linux-initrd @ 0x37e5f000, 0x190980 bytes]
> > 
> > Linux version 2.6.28-rc8-autotest-tip (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Tue Dec 23 06:37:41 CST 2008
> > Command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230036460
> > Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256240
> > Policy zone: DMA32
> > Kernel command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230036460
> > Initializing CPU#0
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> > IP: [<ffffffff8070e46a>] init_ISA_irqs+0x18/0x53
> > PGD 0 
> 
> please try attached debug patch.
> 
> Thanks
> 
> YH

> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> index 3e070bb..41b29cf 100644
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -180,6 +180,9 @@ void __init arch_early_irq_init(void)
>  	cfg = irq_cfgx;
>  	count = ARRAY_SIZE(irq_cfgx);
> 
> +	printk(KERN_DEBUG
> +		 "calling arch_early_irq_init with count=%d\n", count);
> +
>  	for (i = 0; i < count; i++) {
>  		desc = irq_to_desc(i);
>  		desc->chip_data = &cfg[i];
> diff --git a/init/main.c b/init/main.c
> index f10a499..dadff40 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -544,10 +544,12 @@ void __init __weak thread_info_cache_init(void)
> 
>  void __init __weak arch_early_irq_init(void)
>  {
> +	printk(KERN_DEBUG "calling __weak arch_early_irq_init\n");
>  }
> 
>  void __init __weak early_irq_init(void)
>  {
> +	printk(KERN_DEBUG "calling __weak early_irq_init\n");
>  	arch_early_irq_init();
>  }
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 6492400..c7f4404 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -56,10 +56,6 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
>  int nr_irqs = NR_IRQS;
>  EXPORT_SYMBOL_GPL(nr_irqs);
> 
> -void __init __attribute__((weak)) arch_early_irq_init(void)
> -{
> -}
> -
>  #ifdef CONFIG_SPARSE_IRQ
>  static struct irq_desc irq_desc_init = {
>  	.irq	    = -1,
> @@ -143,6 +139,9 @@ void __init early_irq_init(void)
>  	desc = irq_desc_legacy;
>  	legacy_count = ARRAY_SIZE(irq_desc_legacy);
> 
> +	printk(KERN_DEBUG
> +		 "calling early_irq_init with legacy_count=%d\n", legacy_count);
> +
>  	for (i = 0; i < legacy_count; i++) {
>  		desc[i].irq = i;
>  		desc[i].kstat_irqs = kstat_irqs_legacy[i];


boot log after applying the debug patch

root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /vmlinuz-autotest root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 c
onsole=ttyS1,19200 selinux=no debug IDENT=1230133532
   [Linux-bzImage, setup=0x3000, size=0x273cf0]
initrd /initrd-autotest
   [Linux-initrd @ 0x37e5f000, 0x19097a bytes]

Linux version 2.6.28-rc8-autotest-tip (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Wed Dec 24 09:37:30 CST 2008
Command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug IDENT=1230133532
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
 BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
 BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.3 present.
last_pfn = 0x3ffcd max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-000000003ffcd000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ffcd000 page 4k
kernel direct mapping tables up to 3ffcd000 @ 8000-b000
last_map_addr: 3ffcd000 end: 3ffcd000
RAMDISK: 37e5f000 - 37fef97a
ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
ACPI: FACS 3FFCFCC0, 0040
ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-40000000
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000003ffcd000
  NODE_DATA [0000000000009000 - 000000000000efff]
  bootmap [000000000000f000 -  0000000000016fff] pages 8
(6 early reservations) ==> bootmem [0000000000 - 003ffcd000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00008127f0]    TEXT DATA BSS ==> [0000200000 - 00008127f0]
  #3 [0037e5f000 - 0037fef97a]          RAMDISK ==> [0037e5f000 - 0037fef97a]
  #4 [000009d400 - 0000100000]    BIOS reserved ==> [000009d400 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff88000009d540] 0009d540
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0003ffcd
On node 0 totalpages: 261994
  DMA zone: 64 pages used for memmap
  DMA zone: 1658 pages reserved
  DMA zone: 2275 pages, LIFO batch:0
  DMA32 zone: 4032 pages used for memmap
  DMA32 zone: 253965 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x2208
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 13, version 0, address 0xfec10000, GSI 24-27
ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
IOAPIC[2]: apic_id 12, version 0, address 0xfec20000, GSI 48-51
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228203 base: 0xfecff000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 49152 bytes of per cpu data
per cpu data for cpu0 on node0 at 000000000100e000
per cpu data for cpu1 on node0 at 000000000101a000
per cpu data for cpu2 on node0 at 0000000001026000
per cpu data for cpu3 on node0 at 0000000001032000
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256240
Policy zone: DMA32
Kernel command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug IDENT=1230133532
Initializing CPU#0
calling early_irq_init with legacy_count=16
calling arch_early_irq_init with count=16
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 1993.805 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Checking aperture...
No AGP bridge found
Node 0: aperture @ dc000000 size 64 MB
Node 1: aperture @ dc000000 size 64 MB
Memory: 1023412k/1048372k available (3242k kernel code, 396k absent, 24564k reserved, 1771k data, 440k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3987.61 BogoMIPS (lpj=7975220)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20080926
Setting APIC routing to flat
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: Dual Core AMD Opteron(tm) Processor 270 stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3987.51 BogoMIPS (lpj=7975023)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Dual Core AMD Opteron(tm) Processor 270 stepping 02
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 3987.51 BogoMIPS (lpj=7975026)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/0x2 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU2: Dual Core AMD Opteron(tm) Processor 270 stepping 02
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 3987.51 BogoMIPS (lpj=7975035)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/0x3 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual Core AMD Opteron(tm) Processor 270 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (15950.15 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-3 level CPU
  groups: 0 1 2 3
CPU1 attaching sched-domain:
 domain 0: span 0-3 level CPU
  groups: 1 2 3 0
CPU2 attaching sched-domain:
 domain 0: span 0-3 level CPU
  groups: 2 3 0 1
CPU3 attaching sched-domain:
 domain 0: span 0-3 level CPU
  groups: 3 0 1 2
net_namespace: 1248 bytes
NET: Registered protocol family 16
node 0 link 1: io port [0, 2fff]
node 0 link 1: io port [3000, 3fff]
node 0 link 1: io port [4000, 4fff]
node 0 link 1: io port [5000, ffff]
TOM: 0000000040000000 aka 1024M
node 0 link 1: mmio [ee000000, ff00ffff]
node 0 link 1: mmio [fec00000, fec0ffff]
node 0 link 1: mmio [a0000, bffff]
node 0 link 1: mmio [fec10000, fec1ffff]
node 0 link 1: mmio [fec20000, fec2ffff]
bus: [00,ff] on node 0 link 1
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [40000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:01:00.0: reg 10 32bit mmio: [0xfeaff000-0xfeafffff]
pci 0000:01:00.1: reg 10 32bit mmio: [0xfeafe000-0xfeafefff]
pci 0000:01:04.0: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
pci 0000:01:04.0: reg 14 io port: [0x3000-0x30ff]
pci 0000:01:04.0: reg 18 32bit mmio: [0xfeae0000-0xfeaeffff]
pci 0000:01:04.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:04.0: supports D1 D2
pci 0000:00:06.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:06.0: bridge 32bit mmio: [0xfd000000-0xfeafffff]
pci 0000:00:06.0: bridge 32bit mmio pref: [0xf0000000-0xfcffffff]
pci 0000:02:01.0: reg 10 64bit mmio: [0xefff0000-0xefffffff]
pci 0000:02:01.0: PME# supported from D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:02:01.1: reg 10 64bit mmio: [0xeffe0000-0xeffeffff]
pci 0000:02:01.1: PME# supported from D3hot D3cold
pci 0000:02:01.1: PME# disabled
pci 0000:02:02.0: reg 10 io port: [0x4000-0x40ff]
pci 0000:02:02.0: reg 14 64bit mmio: [0xeffc0000-0xeffdffff]
pci 0000:02:02.0: reg 1c 64bit mmio: [0xeffa0000-0xeffbffff]
pci 0000:02:02.0: reg 30 32bit mmio: [0x000000-0x0fffff]
pci 0000:02:02.0: supports D1 D2
pci 0000:00:0a.0: bridge io port: [0x4000-0x4fff]
pci 0000:00:0a.0: bridge 32bit mmio: [0xee000000-0xefffffff]
pci 0000:00:0b.0: bridge io port: [0x5000-0xffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *10)
ACPI: PCI Interrupt Link [LP01] (IRQs *7)
ACPI: PCI Interrupt Link [LP02] (IRQs *9)
ACPI: PCI Interrupt Link [LP03] (IRQs *5)
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfecff000, IRQs 2, 8, 0
hpet0: 3 comparators, 32-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x510-0x517 has been reserved
system 00:01: ioport range 0x504-0x507 has been reserved
system 00:01: ioport range 0x500-0x503 has been reserved
system 00:01: ioport range 0x520-0x53f has been reserved
system 00:01: ioport range 0x540-0x547 has been reserved
system 00:01: ioport range 0x460-0x461 has been reserved
system 00:0b: ioport range 0x400-0x47f could not be reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x540-0x55f could not be reserved
system 00:0b: ioport range 0x580-0x5ff has been reserved
system 00:0b: ioport range 0xca8-0xca8 has been reserved
system 00:0b: ioport range 0xcac-0xcac has been reserved
system 00:0b: ioport range 0xcb0-0xcb0 has been reserved
system 00:0b: ioport range 0xcb4-0xcb4 has been reserved
system 00:0b: ioport range 0xcc0-0xcdf has been reserved
system 00:0b: iomem range 0xfec00000-0xffffffff has been reserved
pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
pci 0000:00:06.0:   IO window: 0x3000-0x3fff
pci 0000:00:06.0:   MEM window: 0xfd000000-0xfeafffff
pci 0000:00:06.0:   PREFETCH window: 0x000000f0000000-0x000000fcffffff
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: 0x4000-0x4fff
pci 0000:00:0a.0:   MEM window: 0xee000000-0xefffffff
pci 0000:00:0a.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0b.0:   IO window: 0x5000-0xffff
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 io port: [0x3000-0x3fff]
bus: 01 index 1 mmio: [0xfd000000-0xfeafffff]
bus: 01 index 2 mmio: [0xf0000000-0xfcffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0x4000-0x4fff]
bus: 02 index 1 mmio: [0xee000000-0xefffffff]
bus: 02 index 2 mmio: [0x50000000-0x500fffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0x5000-0xffff]
bus: 03 index 1 mmio: [0x0-0x0]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 mmio: [0x0-0x0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1602k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1230112145.555:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 2001
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
disabled boot interrupts on PCI device 0x1022:0x746b
pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:01:04.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU3] (supports 8 throttling states)
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU2] (supports 8 throttling states)
processor ACPI_CPU:02: registered as cooling_device2
ACPI: Processor [CPU1] (supports 8 throttling states)
processor ACPI_CPU:03: registered as cooling_device3
ACPI: Processor [CPU0] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
erial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
tg3.c:v3.94 (August 14, 2008)
vendor=1022 device=7450
  alloc irq_desc for 24 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-rc8-autotest-tip #1
RIP: 0010:[<ffffffff8021f8fd>]  [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
RSP: 0018:ffff88003f9d7b20  EFLAGS: 00010282
RAX: ffff88003e5f0400 RBX: ffff88003e5f0400 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000046 R09: ffff880001046040
R10: 00000000ffffff00 R11: ffffffff8036f11f R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffffffff806f1480(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
Stack:
 0000000000000018 ffff88003e5f0400 0000000000000018 0000000000000001
 0000000000000000 ffffffff8021f9e1 0000000080020800 0000000000000018
 0000000000000001 0000000000000000 ffff88003f9d7bec 0000000000000018
Call Trace:
 [<ffffffff8021f9e1>] ? io_apic_set_pci_routing+0x85/0xa9
 [<ffffffff8021c5bb>] ? mp_register_gsi+0xab/0xb2
 [<ffffffff80398967>] ? acpi_pci_irq_enable+0x178/0x284
 [<ffffffff803986fa>] ? acpi_pci_allocate_irq+0x0/0x4c
 [<ffffffff80363340>] ? pci_enable_resources+0x2b/0x11a
 [<ffffffff8035f65e>] ? do_pci_enable_device+0x2d/0x48
 [<ffffffff8035f6c2>] ? __pci_enable_device_flags+0x49/0x56
 [<ffffffff80515749>] ? tg3_init_one+0x43/0x12b1
 [<ffffffff80357534>] ? __bitmap_weight+0x6e/0x81
 [<ffffffff802329f9>] ? set_cpus_allowed_ptr+0x114/0x11f
 [<ffffffff802e9fd4>] ? sysfs_find_dirent+0x1b/0x2f
 [<ffffffff80361539>] ? pci_device_probe+0xb6/0x105
 [<ffffffff803cb8a8>] ? driver_probe_device+0xdb/0x168
 [<ffffffff803cb98e>] ? __driver_attach+0x59/0x80
 [<ffffffff803cb935>] ? __driver_attach+0x0/0x80
 [<ffffffff803cae81>] ? bus_for_each_dev+0x44/0x6f
 [<ffffffff803cb2b8>] ? bus_add_driver+0xb4/0x201
 [<ffffffff803cbb3f>] ? driver_register+0x8d/0x102
 [<ffffffff803617f9>] ? __pci_register_driver+0x6a/0x9d
 [<ffffffff8072a8e8>] ? tg3_init+0x0/0x15
 [<ffffffff80209051>] ? do_one_initcall+0x51/0x126
 [<ffffffff802e29b7>] ? create_proc_entry+0x73/0x88
 [<ffffffff8026885b>] ? register_irq_proc+0x9f/0xb7
 [<ffffffff8070792f>] ? kernel_init+0x196/0x1eb
 [<ffffffff8020ceda>] ? child_rip+0xa/0x20
 [<ffffffff80707799>] ? kernel_init+0x0/0x1eb
 [<ffffffff8020ced0>] ? child_rip+0x0/0x20
Code: 48 c7 c7 e3 29 5f 80 31 c0 e8 83 85 01 00 5b 4c 89 e0 41 5c 41 5d c3 41 55 49 89 fd 89 f7 41 54 41 89 cc 55 89 d5 53 48 83 ec 08 <49> 8b 5d 00 48 85 db 75 35 e8 88 ff ff ff 48 85 c0 75 18 5b 5b 
RIP  [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
 RSP <ffff88003f9d7b20>
CR2: 0000000000000000
---[ end trace bf00ede76e653fb4 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.28-rc8-autotest-tip #1
Call Trace:
 [<ffffffff80237321>] panic+0x86/0x144
 [<ffffffff80236bc8>] mm_release+0x3f/0xd3
 [<ffffffff80238b4f>] exit_fs+0x35/0x46
 [<ffffffff80239fd7>] do_exit+0x75/0x78f
 [<ffffffff8052579e>] oops_end+0xa8/0xad
 [<ffffffff80526fed>] do_page_fault+0x756/0x80f
 [<ffffffff80524daf>] page_fault+0x1f/0x30
 [<ffffffff8036f11f>] vgacon_cursor+0x0/0x1a4
 [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
 [<ffffffff8021f9e1>] io_apic_set_pci_routing+0x85/0xa9
 [<ffffffff8021c5bb>] mp_register_gsi+0xab/0xb2
 [<ffffffff80398967>] acpi_pci_irq_enable+0x178/0x284
 [<ffffffff803986fa>] acpi_pci_allocate_irq+0x0/0x4c
 [<ffffffff80363340>] pci_enable_resources+0x2b/0x11a
 [<ffffffff8035f65e>] do_pci_enable_device+0x2d/0x48
 [<ffffffff8035f6c2>] __pci_enable_device_flags+0x49/0x56
 [<ffffffff80515749>] tg3_init_one+0x43/0x12b1
 [<ffffffff80357534>] __bitmap_weight+0x6e/0x81
 [<ffffffff802329f9>] set_cpus_allowed_ptr+0x114/0x11f
 [<ffffffff802e9fd4>] sysfs_find_dirent+0x1b/0x2f
 [<ffffffff80361539>] pci_device_probe+0xb6/0x105
 [<ffffffff803cb8a8>] driver_probe_device+0xdb/0x168
 [<ffffffff803cb98e>] __driver_attach+0x59/0x80
 [<ffffffff803cb935>] __driver_attach+0x0/0x80
 [<ffffffff803cae81>] bus_for_each_dev+0x44/0x6f
 [<ffffffff803cb2b8>] bus_add_driver+0xb4/0x201
 [<ffffffff803cbb3f>] driver_register+0x8d/0x102
 [<ffffffff803617f9>] __pci_register_driver+0x6a/0x9d
 [<ffffffff8072a8e8>] tg3_init+0x0/0x15
 [<ffffffff80209051>] do_one_initcall+0x51/0x126
 [<ffffffff802e29b7>] create_proc_entry+0x73/0x88
 [<ffffffff8026885b>] register_irq_proc+0x9f/0xb7
 [<ffffffff8070792f>] kernel_init+0x196/0x1eb
 [<ffffffff8020ceda>] child_rip+0xa/0x20
 [<ffffffff80707799>] kernel_init+0x0/0x1eb
 [<ffffffff8020ced0>] child_rip+0x0/0x20
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
