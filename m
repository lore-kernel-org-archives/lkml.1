Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbZKFTqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbZKFTqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759682AbZKFTqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:46:30 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44007 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655AbZKFTq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BF4o/sdDBJ63PsV3DSc0ITOxSUMz1J5gNIRkIVJ9hsw95lUnUntAXBz+E28lk2DYrn
         s3pbLq3shetWMkBmeuV0gN/tN1WoFzDjgUggODjnFo10jw3r2HVeuy7fp1WBoUrQDqCN
         /bGSdoH73HdVtoq1c5IshhroizTpXO6jamdiE=
Date: Fri, 6 Nov 2009 20:46:26 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091106194626.GC18592@alberich.amd.com>
References: <1257192496.5941.8.camel@dimm>
 <20091105153742.GA18592@alberich.amd.com>
 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
 <20091106123403.GB18592@alberich.amd.com>
 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 06, 2009 at 01:56:31PM +0100, Dmitry Adamushko wrote:
> 2009/11/6 Andreas Herrmann <herrmann.der.user@googlemail.com>:

   <snip>

> >> (CPU3 belongs to both sets) unless summarize_cpu_info() is utterly
> >> broken.
> >
> > I didn't check that yet.
> 
> Yeah, this behavior is likely due to a missing cpumask_clear() in
> summarize_cpu_info().

Yeah, that fixes the wrong messages.
The other problem of not-updated CPU microcode after suspend/resume persists.

> should be as follows:
> 
>       if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
>               return;
> 
> +    cpumask_clear(cpulist);

Better use zalloc_cpumask instead of alloc/clear.

> >> sure, my test is somewhat limited... anyway, first of all I'd like to
> >> get a clear understanding of your logs. Thanks for yout test btw. :-))
> >
> > I'll send you full logs asap.
> 
> Thanks. Maybe it's something about a particular sequence of actions
> that triggers this behavior. Or was it reproducible with the very
> first pm-suspend invocation after "modprobe microcode.ko"?

The sequence is:

1. loading microcode.ko
2. setting cpu2 offline
3. setting cpu2 online
4. suspend (pm-suspend)
5. resume

microcode of CPU2 is not updated:

  # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000065
  PATCH_LEVEL          = 0x0000000001000083

dmesg attached.

As I've said, that test used to pass with all CPUs updated to new
ucode in the past (at least that I think so ;-( -- but in contrast to
my previous mail this doesn't seem to be related to your patch. I
tested latest mainline and the test fails as well ... seems that I
need to do some debugging.


Regards,
Andreas

PS1: You should remove the needless newline from the patch level string:

 static int version_snprintf(char *buf, int len, struct cpu_signature *csig)
 {
-	return snprintf(buf, len, "patch_level=0x%x\n", csig->rev);
+	return snprintf(buf, len, "patch_level=0x%x", csig->rev);
 }
 
PS2: I plan to remove further needless messages from the amd ucode driver asap.

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-dimm

Linux version 2.6.32-rc6 (root@hadburg) (gcc version 4.4.1 (Gentoo 4.4.1 p1.0) ) #8 SMP Fri Nov 6 19:54:37 CET 2009
Command line: root=/dev/sda2 video=radeonfb:noaccel console=uart,io,0xe800,115200 console=tty0
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffc0000 (usable)
 BIOS-e820: 00000000cffc0000 - 00000000cffce000 (ACPI data)
 BIOS-e820: 00000000cffce000 - 00000000cfff0000 (ACPI NVS)
 BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Early serial console at I/O port 0xe800 (options '115200')
bootconsole [uart0] enabled
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x130000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFF0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000130000000 aka 4864M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcffc0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000cffc0000
 0000000000 - 00c0000000 page 1G
 00c0000000 - 00cfe00000 page 2M
 00cfe00000 - 00cffc0000 page 4k
kernel direct mapping tables up to cffc0000 @ 10000-13000
init_memory_mapping: 0000000100000000-0000000130000000
 0100000000 - 0130000000 page 2M
kernel direct mapping tables up to 130000000 @ 12000-14000
ACPI: RSDP 00000000000f97e0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000cffc0100 00054 (v01 043008 XSDT0025 20080430 MSFT 00000097)
ACPI: FACP 00000000cffc0290 000F4 (v03 043008 FACP0025 20080430 MSFT 00000097)
ACPI: DSDT 00000000cffc0440 0833A (v01  MMKA0 MMKA05-3 00000000 INTL 20051117)
ACPI: FACS 00000000cffce000 00040
ACPI: APIC 00000000cffc0390 0006C (v01 043008 APIC0025 20080430 MSFT 00000097)
ACPI: GFCM 00000000cffc0400 0003C (v01 043008 OEMMCFG  20080430 MSFT 00000097)
ACPI: OEMB 00000000cffce040 00071 (v01 043008 OEMB0025 20080430 MSFT 00000097)
ACPI: HPET 00000000cffc8780 00038 (v01 043008 OEMHPET  20080430 MSFT 00000097)
ACPI: SSDT 00000000cffc87c0 00544 (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000130000000
Bootmem setup node 0 0000000000000000-0000000130000000
  NODE_DATA [0000000000013000 - 0000000000016fff]
  bootmap [0000000000017000 -  000000000003cfff] pages 26
(7 early reservations) ==> bootmem [0000000000 - 0130000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 000175d184]    TEXT DATA BSS ==> [0001000000 - 000175d184]
  #3 [000008d400 - 0000100000]    BIOS reserved ==> [000008d400 - 0000100000]
  #4 [000175e000 - 000175e1d5]              BRK ==> [000175e000 - 000175e1d5]
  #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
found SMP MP-table at [ffff8800000ff780] ff780
 [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00130000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000cffc0
    0: 0x00100000 -> 0x00130000
On node 0 totalpages: 1048399
  DMA zone: 56 pages used for memmap
  DMA zone: 120 pages reserved
  DMA zone: 3807 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833528 pages, LIFO batch:31
  Normal zone: 2688 pages used for memmap
  Normal zone: 193920 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880028200000 s73432 r8192 d20776 u524288
pcpu-alloc: s73432 r8192 d20776 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031255
Policy zone: Normal
Kernel command line: root=/dev/sda2 video=radeonfb:noaccel console=uart,io,0xe800,115200 console=tty0
PID hash table entries: 4096 (order: 3, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Memory: 4060412k/4980736k available (3779k kernel code, 787140k absent, 133184k reserved, 2706k data, 516k init)
Hierarchical RCU implementation.
NR_IRQS:384
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled, bootconsole disabled
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: using HPET reference calibration
Detected 2283.669 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4599.80 BogoMIPS (lpj=2299900)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20090903
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4600.09 BogoMIPS (lpj=2300048)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4599.97 BogoMIPS (lpj=2299989)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/0x2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU2: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4600.00 BogoMIPS (lpj=2300004)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/0x3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU3: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (18399.88 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 0 1 2 3
CPU1 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 1 2 3 0
CPU2 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 2 3 0 1
CPU3 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 3 0 1 2
NET: Registered protocol family 16
i2c-core: driver [dummy] registered
node 0 link 0: io port [1000, ffffff]
TOM: 00000000d0000000 aka 3328M
Fam 10h mmconf [e0000000, efffffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [d0000000, dfffffff]
TOM2: 0000000130000000 aka 4864M
bus: [00,07] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [f0000000, ffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
bus: 00 index 3 mmio: [d0000000, dfffffff]
bus: 00 index 4 mmio: [130000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning: Incorrect checksum in table [OEMB] - FF, should be F6 (20090903/tbutils-314)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
pci 0000:00:12.0: reg 10 io port: [0x9000-0x9007]
pci 0000:00:12.0: reg 14 io port: [0x8000-0x8003]
pci 0000:00:12.0: reg 18 io port: [0x7000-0x7007]
pci 0000:00:12.0: reg 1c io port: [0x6000-0x6003]
pci 0000:00:12.0: reg 20 io port: [0x5000-0x500f]
pci 0000:00:12.0: reg 24 32bit mmio: [0xfe8ff800-0xfe8ffbff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: reg 10 32bit mmio: [0xfe8fe000-0xfe8fefff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xfe8fd000-0xfe8fdfff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xfe8fc000-0xfe8fcfff]
pci 0000:00:13.3: reg 10 32bit mmio: [0xfe8fb000-0xfe8fbfff]
pci 0000:00:13.4: reg 10 32bit mmio: [0xfe8fa000-0xfe8fafff]
pci 0000:00:13.5: reg 10 32bit mmio: [0xfe8ff000-0xfe8ff0ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.0: reg 10 io port: [0xb00-0xb0f]
pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
pci 0000:00:14.2: reg 10 64bit mmio: [0xfe8f4000-0xfe8f7fff]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:01:00.0: reg 14 io port: [0xa000-0xa0ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xfe9f0000-0xfe9fffff]
pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfe9c0000-0xfe9dffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 32bit mmio: [0xfe9e0000-0xfe9effff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:02.0: bridge io port: [0xa000-0xafff]
pci 0000:00:02.0: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafe000-0xfeafffff]
pci 0000:02:00.0: PME# supported from D3hot
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.1: reg 10 io port: [0xc800-0xc807]
pci 0000:02:00.1: reg 14 io port: [0xc400-0xc403]
pci 0000:02:00.1: reg 18 io port: [0xc000-0xc007]
pci 0000:02:00.1: reg 1c io port: [0xb800-0xb803]
pci 0000:02:00.1: reg 20 io port: [0xb400-0xb40f]
pci 0000:00:09.0: bridge io port: [0xb000-0xcfff]
pci 0000:00:09.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xfebfc000-0xfebfffff]
pci 0000:03:00.0: reg 18 io port: [0xd800-0xd8ff]
pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfebc0000-0xfebdffff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:0a.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:0a.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
pci 0000:04:05.0: reg 10 io port: [0xe800-0xe81f]
pci 0000:00:14.4: transparent bridge
pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
pci 0000:00:00.0: BAR 3: can't allocate resource
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x100000-0xcfffffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:08: ioport range 0xe00-0xe0f has been reserved
system 00:08: ioport range 0xe80-0xe8f has been reserved
system 00:08: ioport range 0xf40-0xf4f has been reserved
system 00:08: ioport range 0xa30-0xa3f has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x40b-0x40b has been reserved
system 00:0b: ioport range 0x4d6-0x4d6 has been reserved
system 00:0b: ioport range 0xc00-0xc01 has been reserved
system 00:0b: ioport range 0xc14-0xc14 has been reserved
system 00:0b: ioport range 0xc50-0xc51 has been reserved
system 00:0b: ioport range 0xc52-0xc52 has been reserved
system 00:0b: ioport range 0xc6c-0xc6c has been reserved
system 00:0b: ioport range 0xc6f-0xc6f has been reserved
system 00:0b: ioport range 0xcd0-0xcd1 has been reserved
system 00:0b: ioport range 0xcd2-0xcd3 has been reserved
system 00:0b: ioport range 0xcd4-0xcd5 has been reserved
system 00:0b: ioport range 0xcd6-0xcd7 has been reserved
system 00:0b: ioport range 0xcd8-0xcdf has been reserved
system 00:0b: ioport range 0x800-0x89f has been reserved
system 00:0b: ioport range 0xb10-0xb1f has been reserved
system 00:0b: ioport range 0x900-0x90f has been reserved
system 00:0b: ioport range 0x910-0x91f has been reserved
system 00:0b: ioport range 0xfe00-0xfefe has been reserved
system 00:0b: iomem range 0xffb80000-0xffbfffff has been reserved
system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0xfec00000-0x10d7fffff could not be reserved
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0xa000-0xafff
pci 0000:00:02.0:   MEM window: 0xfe900000-0xfe9fffff
pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
pci 0000:00:09.0:   IO window: 0xb000-0xcfff
pci 0000:00:09.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0a.0:   IO window: 0xd000-0xdfff
pci 0000:00:0a.0:   MEM window: 0xfeb00000-0xfebfffff
pci 0000:00:0a.0:   PREFETCH window: disabled
pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
pci 0000:00:14.4:   IO window: 0xe000-0xefff
pci 0000:00:14.4:   MEM window: disabled
pci 0000:00:14.4:   PREFETCH window: disabled
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:0a.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
pci_bus 0000:01: resource 1 mem: [0xfe900000-0xfe9fffff]
pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
pci_bus 0000:02: resource 0 io:  [0xb000-0xcfff]
pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
pci_bus 0000:04: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:01:00.0: Boot video device
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Slow work thread pool: Starting up
Slow work thread pool: Ready
msgmni has been set to 7930
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:02.0: irq 24 for MSI/MSI-X
pcieport 0000:00:02.0: setting latency timer to 64
pcieport 0000:00:09.0: irq 25 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
pcieport 0000:00:0a.0: setting latency timer to 64
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
processor LNXCPU:02: registered as cooling_device2
processor LNXCPU:03: registered as cooling_device3
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 0000:04:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
0000:04:05.0: ttyS1 at I/O 0xe800 (irq = 20) is a 16550A
console [ttyS1] enabled
0000:04:05.0: ttyS2 at I/O 0xe808 (irq = 20) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
Uniform Multi-Platform E-IDE driver
atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
pci 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xff00-0xff07
Probing IDE interface ide0...
hda: SONY DVD-ROM DDU1615, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
ide-cd driver 5.00
ide-cd: hda: ATAPI 40X DVD-ROM drive, 1727kB Cache
Uniform CD-ROM driver Revision: 3.20
ahci 0000:00:12.0: version 3.0
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio ccc 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff900 irq 22
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
ata3: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa80 irq 22
ahci 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ahci 0000:02:00.0: setting latency timer to 64
scsi4 : ahci
scsi5 : ahci
ata5: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe100 irq 17
ata6: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe180 irq 17
sky2 driver version 1.25
sky2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:03:00.0: setting latency timer to 64
sky2 0000:03:00.0: Yukon-2 EC chip revision 2
sky2 0000:03:00.0: irq 27 for MSI/MSI-X
sky2 eth0: addr 00:0c:87:00:40:20
console [netcon0] enabled
netconsole: network logging started
Fusion MPT base driver 3.04.12
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.12
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe8ff000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe8fe000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe8fd000
usb usb3: configuration #1 chosen from 1 choice
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe8fc000
ata6: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe8fb000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe8fa000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
i2c-core: driver [dev_driver] registered
ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
it87: Found IT8716F chip at 0xe80, revision 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.21.
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
hda_codec: ALC889A: BIOS auto-probing.
ALSA device list:
  #0: HDA ATI SB at 0xfe8f4000 irq 16
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Phenom(tm) 9650 Quad-Core Processor processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (2300 MHz)
powernow-k8:    1 : pstate 1 (1150 MHz)
ata2: softreset failed (device not ready)
ata2: applying SB600 PMP SRST workaround and retrying
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3120811AS, 3.AAE, max UDMA/133
ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST3120811AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 1:0:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
Freeing unused kernel memory: 516k freed
udev: starting version 141
EXT3 FS on sda2, internal journal
Adding 1959920k swap on /dev/sda3.  Priority:-1 extents:1 across:1959920k 
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
microcode: original microcode versions...
microcode: CPU0-3: patch_level=0x1000065

platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
microcode: size 1936, total_size 960
microcode: CPU0: patch mismatch (processor_rev_id: 1020, equiv_cpu_id: 1022)
microcode: size 968, total_size 960
platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
microcode: size 1936, total_size 960
microcode: CPU1: patch mismatch (processor_rev_id: 1020, equiv_cpu_id: 1022)
microcode: size 968, total_size 960
platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
microcode: size 1936, total_size 960
microcode: CPU2: patch mismatch (processor_rev_id: 1020, equiv_cpu_id: 1022)
microcode: size 968, total_size 960
platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
microcode: size 1936, total_size 960
microcode: CPU3: patch mismatch (processor_rev_id: 1020, equiv_cpu_id: 1022)
microcode: size 968, total_size 960
microcode: microcode versions after update...
microcode: CPU0-3: patch_level=0x1000083

Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
CPU 2 is now offline
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1,3 level MC
  groups: 0 1 3
CPU1 attaching sched-domain:
 domain 0: span 0-1,3 level MC
  groups: 1 3 0
CPU3 attaching sched-domain:
 domain 0: span 0-1,3 level MC
  groups: 3 0 1
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4599.83 BogoMIPS (lpj=2299918)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/0x2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU2: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 0 1 2 3
CPU1 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 1 2 3 0
CPU2 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 2 3 0 1
CPU3 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 3 0 1 2
platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
microcode: size 1936, total_size 960
microcode: CPU2: patch mismatch (processor_rev_id: 1020, equiv_cpu_id: 1022)
microcode: size 968, total_size 960
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 1:0:0:0: [sda] Synchronizing SCSI cache
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
serial 00:06: disabled
sky2 eth0: disabling interface
ACPI handle has no context!
ACPI handle has no context!
ahci 0000:02:00.0: PCI INT A disabled
HDA Intel 0000:00:14.2: PCI INT A disabled
ATIIXP_IDE 0000:00:14.1: PCI INT A disabled
ehci_hcd 0000:00:13.5: PCI INT D disabled
ohci_hcd 0000:00:13.4: PCI INT C disabled
ohci_hcd 0000:00:13.3: PCI INT B disabled
ohci_hcd 0000:00:13.2: PCI INT C disabled
ohci_hcd 0000:00:13.1: PCI INT B disabled
ohci_hcd 0000:00:13.0: PCI INT A disabled
ahci 0000:00:12.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0,2-3 level MC
  groups: 0 2 3
CPU2 attaching sched-domain:
 domain 0: span 0,2-3 level MC
  groups: 2 3 0
CPU3 attaching sched-domain:
 domain 0: span 0,2-3 level MC
  groups: 3 0 2
CPU1 is down
CPU 2 is now offline
CPU0 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0,3 level MC
  groups: 0 3
CPU3 attaching sched-domain:
 domain 0: span 0,3 level MC
  groups: 3 0
CPU2 is down
CPU 3 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU3 is down
Extended CMOS year: 2000
Back to C!
microcode: CPU0: updated (new patch_level=0x1000083)
PCI-DMA: Resuming GART IOMMU
PCI-DMA: Restoring GART aperture settings
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4599.84 BogoMIPS (lpj=2299922)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
CPU0 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
microcode: CPU1: updated (new patch_level=0x1000083)
CPU1 is up
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4599.85 BogoMIPS (lpj=2299927)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/0x2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU2: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#1 -> CPU#2]: passed.
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-2 level MC
  groups: 0 1 2
CPU1 attaching sched-domain:
 domain 0: span 0-2 level MC
  groups: 1 2 0
CPU2 attaching sched-domain:
 domain 0: span 0-2 level MC
  groups: 2 0 1
CPU2 is up
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4599.96 BogoMIPS (lpj=2299984)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/0x3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU3: AMD Phenom(tm) 9650 Quad-Core Processor stepping 03
checking TSC synchronization [CPU#2 -> CPU#3]: passed.
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 0 1 2 3
CPU1 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 1 2 3 0
CPU2 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 2 3 0 1
CPU3 attaching sched-domain:
 domain 0: span 0-3 level MC
  groups: 3 0 1 2
microcode: CPU3: updated (new patch_level=0x1000083)
CPU3 is up
ACPI: Waking up from system sleep state S3
pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 0x2000a1a1, writing 0xa1a1)
pcieport 0000:00:02.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:09.0: restoring config space at offset 0x7 (was 0x2000c1b1, writing 0xc1b1)
pcieport 0000:00:09.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
ahci 0000:00:12.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
ahci 0000:00:12.0: restoring config space at offset 0x2 (was 0x1018f00, writing 0x1060100)
ahci 0000:00:12.0: set SATA to AHCI mode
ehci_hcd 0000:00:13.5: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00113)
HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x103, writing 0x3)
HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100006, writing 0x4100002)
pci 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10a)
pci 0000:01:00.0: restoring config space at offset 0xc (was 0x0, writing 0xfe9c0000)
pci 0000:01:00.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9f0000)
pci 0000:01:00.0: restoring config space at offset 0x5 (was 0x1, writing 0xa001)
pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x8, writing 0xd0000008)
pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x800000, writing 0x800010)
pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
pci 0000:01:00.1: restoring config space at offset 0x4 (was 0x0, writing 0xfe9e0000)
pci 0000:01:00.1: restoring config space at offset 0x3 (was 0x0, writing 0x10)
pci 0000:01:00.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
ahci 0000:02:00.0: restoring config space at offset 0x8 (was 0xb401, writing 0x0)
ahci 0000:02:00.0: restoring config space at offset 0x7 (was 0xb801, writing 0x0)
ahci 0000:02:00.0: restoring config space at offset 0x6 (was 0xc001, writing 0x0)
ahci 0000:02:00.0: restoring config space at offset 0x5 (was 0xc401, writing 0x0)
ahci 0000:02:00.0: restoring config space at offset 0x4 (was 0xc801, writing 0x0)
ahci 0000:02:00.0: restoring config space at offset 0x3 (was 0x10, writing 0x800010)
ahci 0000:02:00.0: restoring config space at offset 0x2 (was 0x1018502, writing 0x1060102)
pci 0000:02:00.1: restoring config space at offset 0x8 (was 0x1, writing 0xb401)
pci 0000:02:00.1: restoring config space at offset 0x7 (was 0x1, writing 0xb801)
pci 0000:02:00.1: restoring config space at offset 0x6 (was 0x1, writing 0xc001)
pci 0000:02:00.1: restoring config space at offset 0x5 (was 0x1, writing 0xc401)
pci 0000:02:00.1: restoring config space at offset 0x4 (was 0x1, writing 0xc801)
sky2 0000:03:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
sky2 0000:03:00.0: restoring config space at offset 0xc (was 0x0, writing 0xfebc0000)
sky2 0000:03:00.0: restoring config space at offset 0x6 (was 0x1, writing 0xd801)
sky2 0000:03:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfebfc004)
sky2 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
sky2 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
serial 0000:04:05.0: restoring config space at offset 0xf (was 0x1ff, writing 0x107)
serial 0000:04:05.0: restoring config space at offset 0x4 (was 0x1, writing 0xe801)
serial 0000:04:05.0: restoring config space at offset 0x1 (was 0x2800080, writing 0x2800181)
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ATIIXP_IDE 0000:00:14.1: setting latency timer to 64
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ahci 0000:02:00.0: setting latency timer to 64
sky2 eth0: enabling interface
serial 00:06: activated
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata2: softreset failed (device not ready)
ata2: applying SB600 PMP SRST workaround and retrying
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
ata2.00: configured for UDMA/133
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx

floppy driver state
-------------------
now=4294746204 last interrupt=4294667714 diff=78490 last called handler=ffffffff811eb342
timeout_message=lock fdc
last output bytes:
 8 80 4294667699
 8 80 4294667699
 8 80 4294667699
 8 80 4294667711
 8 80 4294667711
 8 80 4294667711
 8 80 4294667711
 e 80 4294667712
13 80 4294667712
 0 90 4294667712
1a 90 4294667712
 0 90 4294667712
12 90 4294667712
 0 90 4294667712
14 90 4294667712
18 80 4294667712
 8 80 4294667714
 8 80 4294667714
 8 80 4294667714
 8 80 4294667714
last result at 4294667714
last redo_fd_request at 4294667714

status=0
fdc_busy=1
do_floppy=ffffffff811eb342
cont=ffffffff815deb80
current_req=(null)
command_status=-1

floppy0: floppy timeout called
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
sd 1:0:0:0: [sda] Starting disk
Restarting tasks ... done.

--oyUTqETQ0mS9luUI--
