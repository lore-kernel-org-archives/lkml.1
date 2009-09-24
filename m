Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZIXOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZIXOqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZIXOqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZIXOqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:46:45 -0400
Date: Thu, 24 Sep 2009 16:51:25 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Mark Langsdorf <mark.langsdorf@amd.com>
Subject: use after free of struct powernow_k8_data
Message-ID: <20090924165125.7cf51a1f@leela>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Pubd4mh9pFk.6H.Q4uXGLhF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Pubd4mh9pFk.6H.Q4uXGLhF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

After resume from suspend I get:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
BUG kmalloc-256: Poison overwritten
---------------------------------------------------------------------------=
--

INFO: 0xffff880073bf1bb0-0xffff880073bf1bb7. First byte 0x12 instead of 0x6b
INFO: Allocated in powernowk8_cpu_init+0x72/0xc27 [powernow_k8] age=3D290 c=
pu=3D0 pid=3D1782
INFO: Freed in powernowk8_cpu_exit+0x6b/0x88 [powernow_k8] age=3D289 cpu=3D=
0 pid=3D1782
INFO: Slab 0xffffea0002f059e8 objects=3D12 used=3D10 fp=3D0xffff880073bf1b8=
8 flags=3D0x200000000000c3
INFO: Object 0xffff880073bf1b88 @offset=3D2952 fp=3D0xffff880073bf1e18

Bytes b4 0xffff880073bf1b78:  ec 77 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a =
5a =C4=9Bw=C5=A3=CB=99....ZZZZZZZZ
  Object 0xffff880073bf1b88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1ba8:  6b 6b 6b 6b 6b 6b 6b 6b 12 00 00 00 0c 00 00 =
00 kkkkkkkk........
  Object 0xffff880073bf1bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk

The overwritten values correspond to the currvid (0x12) and currfid (0x0c)
fields if struct powernow_k8_data. Earlier in dmesg these exact values
can be seen:

powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: target matches current values (fid 0xc, vid 0x12)

It seems that something called query_current_values_with_pending_wait()
while the struct was already freed.

It is perfectly reproducible. The kernel is the latest from git
(94a8d5caba74211ec76dac80fc6e2d5c391530df).
I'm attaching the full dmesg and .config.

Michal

--MP_/Pubd4mh9pFk.6H.Q4uXGLhF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmesg.txt

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.31 (michich@leela) (gcc version 4.4.1 20090918 (Red Hat 4=
.4.1-15) (GCC) ) #15 SMP Thu Sep 24 15:46:34 CEST 2009
Command line: ro root=3D/dev/mapper/luks-c31ea7be-1f06-464c-be0b-5b4a16dec7=
42 rhgb quiet SYSFONT=3Dlatarcyrheb-sun16 LANG=3Den_US.UTF-8 KEYTABLE=3Dus =
rd_plytheme=3Dcharge cpufreq.debug=3D3
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077e70000 (usable)
 BIOS-e820: 0000000077e70000 - 0000000077e82000 (ACPI data)
 BIOS-e820: 0000000077e82000 - 0000000077e84000 (ACPI NVS)
 BIOS-e820: 0000000077e84000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (re=
served)
last_pfn =3D 0x77e70 max_arch_pfn =3D 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-0000000077e70000
 0000000000 - 0077e00000 page 2M
 0077e00000 - 0077e70000 page 4k
kernel direct mapping tables up to 77e70000 @ 10000-14000
RAMDISK: 37ba5000 - 37feff61
ACPI: RSDP 00000000000f82f0 00024 (v02 TOSINV)
ACPI: XSDT 0000000077e7a36c 00054 (v01 TOSINV TOSINV00 06040000  INV 000000=
00)
ACPI: FACP 0000000077e81a4a 000F4 (v03 ATI    Herring  06040000 ATI  000F42=
40)
ACPI: DSDT 0000000077e7a3c0 0768A (v01 TOSINV    SB600 06040000 MSFT 010000=
0E)
ACPI: FACS 0000000077e83fc0 00040
ACPI: SSDT 0000000077e81bb2 00210 (v01 PTLTD  POWERNOW 06040000  LTP 000000=
01)
ACPI: APIC 0000000077e81dc2 00054 (v01 TOSINV ? APIC   06040000  INV 000000=
00)
ACPI: SLIC 0000000077e81e16 00176 (v01 TOSINV TOSINV00 06040000  INV 000000=
00)
ACPI: MCFG 0000000077e81f8c 0003C (v01 TOSINV   MCFG   06040000  INV 000000=
00)
ACPI: HPET 0000000077e81fc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP 000000=
01)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000077e70000
Bootmem setup node 0 0000000000000000-0000000077e70000
  NODE_DATA [0000000000012000 - 0000000000029fff]
  bootmap [000000000002a000 -  0000000000038fcf] pages f
(7 early reservations) =3D=3D> bootmem [0000000000 - 0077e70000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
08000]
  #2 [0001000000 - 0002704708]    TEXT DATA BSS =3D=3D> [0001000000 - 00027=
04708]
  #3 [0037ba5000 - 0037feff61]          RAMDISK =3D=3D> [0037ba5000 - 0037f=
eff61]
  #4 [000009dc00 - 0000100000]    BIOS reserved =3D=3D> [000009dc00 - 00001=
00000]
  #5 [0002705000 - 00027051c8]              BRK =3D=3D> [0002705000 - 00027=
051c8]
  #6 [0000010000 - 0000012000]          PGTABLE =3D=3D> [0000010000 - 00000=
12000]
found SMP MP-table at [ffff8800000f83b0] f83b0
 [ffffea0000000000-ffffea00031fffff] PMD -> [ffff880002c00000-ffff880005dff=
fff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x00077e70
On node 0 totalpages: 491005
  DMA zone: 104 pages used for memmap
  DMA zone: 103 pages reserved
  DMA zone: 3774 pages, LIFO batch:0
  DMA32 zone: 12366 pages used for memmap
  DMA32 zone: 474658 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x43538301 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 479 pages/cpu @ffff880005e00000 s1931032 r8192 d22760 u209=
7152
pcpu-alloc: s1931032 r8192 d22760 u2097152 alloc=3D1*2097152
pcpu-alloc: [0] 0 [0] 1=20
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 478432
Policy zone: DMA32
Kernel command line: ro root=3D/dev/mapper/luks-c31ea7be-1f06-464c-be0b-5b4=
a16dec742 rhgb quiet SYSFONT=3Dlatarcyrheb-sun16 LANG=3Den_US.UTF-8 KEYTABL=
E=3Dus rd_plytheme=3Dcharge cpufreq.debug=3D3
PID hash table entries: 4096 (order: 3, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ cc2c000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 1880664k/1964480k available (5327k kernel code, 460k absent, 83356k=
 reserved, 3236k data, 3404k init)
SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:424
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
allocated 19660800 bytes of page_cgroup
please try 'cgroup_disable=3Dmemory' option if you don't want memory cgroups
ODEBUG: 10 of 10 active objects replaced
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 1994.859 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. =
3989.71 BogoMIPS (lpj=3D1994859)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0077f00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
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
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 23276 entries in 92 pages
Setting APIC routing to flat
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=3D-1 pin2=3D-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 01
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.15 BogoMIPS (lpj=3D19=
95079)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
System has AMD C1E enabled
Switch to broadcast mode on CPU1
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 01
Brought up 2 CPUs
Total of 2 processors activated (7979.87 BogoMIPS).
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
Switch to broadcast mode on CPU0
regulator: core version 0.5
Time: 14:22:28  Date: 09/24/09
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 0000000080000000 aka 2048M
node 0 link 0: mmio [f8100000, ffffffff]
node 0 link 0: mmio [f8000000, f80fffff]
node 0 link 0: mmio [f8000000, f7ffffff]
node 0 link 0: mmio [f0000000, f7ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [f0000000, efffffff]
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [80000000, dfffffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [80000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 24
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e18fffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE =3D 0x7, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: Power Resource [PFA1] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:12.0: reg 10 io port: [0x8440-0x8447]
pci 0000:00:12.0: reg 14 io port: [0x8434-0x8437]
pci 0000:00:12.0: reg 18 io port: [0x8438-0x843f]
pci 0000:00:12.0: reg 1c io port: [0x8430-0x8433]
pci 0000:00:12.0: reg 20 io port: [0x8400-0x840f]
pci 0000:00:12.0: reg 24 32bit mmio: [0xf8709000-0xf87093ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: reg 10 32bit mmio: [0xf8704000-0xf8704fff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xf8705000-0xf8705fff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xf8706000-0xf8706fff]
pci 0000:00:13.3: reg 10 32bit mmio: [0xf8707000-0xf8707fff]
pci 0000:00:13.4: reg 10 32bit mmio: [0xf8708000-0xf8708fff]
pci 0000:00:13.5: reg 10 32bit mmio: [0xf8709400-0xf87094ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.0: reg 10 io port: [0x8410-0x841f]
pci 0000:00:14.1: reg 10 io port: [0x1f0-0x1f7]
pci 0000:00:14.1: reg 14 io port: [0x3f4-0x3f7]
pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
pci 0000:00:14.1: reg 20 io port: [0x8420-0x842f]
pci 0000:00:14.2: reg 10 64bit mmio: [0xf8700000-0xf8703fff]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:01:05.0: reg 10 64bit mmio pref: [0xf0000000-0xf7ffffff]
pci 0000:01:05.0: reg 18 64bit mmio: [0xf8100000-0xf810ffff]
pci 0000:01:05.0: reg 20 io port: [0x9000-0x90ff]
pci 0000:01:05.0: reg 24 32bit mmio: [0xf8000000-0xf80fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xf8000000-0xf81fffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
pci 0000:00:04.0: bridge io port: [0x00-0xfff]
pci 0000:00:04.0: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:08:00.0: reg 10 io port: [0xa000-0xa0ff]
pci 0000:08:00.0: reg 18 64bit mmio: [0xf8300000-0xf8300fff]
pci 0000:08:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:08:00.0: supports D1 D2
pci 0000:08:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:08:00.0: PME# disabled
pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:05.0: bridge io port: [0xa000-0xafff]
pci 0000:00:05.0: bridge 32bit mmio: [0xf8300000-0xf83fffff]
pci 0000:0e:00.0: reg 10 64bit mmio: [0xf8200000-0xf820ffff]
pci 0000:0e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:06.0: bridge 32bit mmio: [0xf8200000-0xf82fffff]
pci 0000:14:06.0: reg 10 32bit mmio: [0xf8400000-0xf84007ff]
pci 0000:14:06.0: supports D1 D2
pci 0000:14:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:14:06.0: PME# disabled
pci 0000:14:06.1: reg 10 32bit mmio: [0xf8400800-0xf84008ff]
pci 0000:14:06.1: supports D1 D2
pci 0000:14:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:14:06.1: PME# disabled
pci 0000:14:06.2: reg 10 32bit mmio: [0xf8400c00-0xf8400cff]
pci 0000:14:06.2: supports D1 D2
pci 0000:14:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:14:06.2: PME# disabled
pci 0000:14:06.3: reg 10 32bit mmio: [0xf8401000-0xf84010ff]
pci 0000:14:06.3: supports D1 D2
pci 0000:14:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:14:06.3: PME# disabled
pci 0000:14:06.4: reg 10 32bit mmio: [0xf8401400-0xf84014ff]
pci 0000:14:06.4: supports D1 D2
pci 0000:14:06.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:14:06.4: PME# disabled
pci 0000:00:14.4: transparent bridge
pci 0000:00:14.4: bridge 32bit mmio: [0xf8400000-0xf84fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BB4_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BB5_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
vgaarb: device added: PCI:0000:01:05.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:04.0: BAR 13: can't allocate resource
pci 0000:00:04.0: BAR 14: can't allocate resource
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource hpet
kstop/0 used greatest stack depth: 6064 bytes left
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:08: ioport range 0x1080-0x1080 has been reserved
system 00:08: ioport range 0x220-0x22f has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0x530-0x537 has been reserved
system 00:08: ioport range 0xc00-0xc01 has been reserved
system 00:08: ioport range 0xc14-0xc14 has been reserved
system 00:08: ioport range 0xc50-0xc52 has been reserved
system 00:08: ioport range 0xc6c-0xc6c has been reserved
system 00:08: ioport range 0xc6f-0xc6f has been reserved
system 00:08: ioport range 0xcd0-0xcd1 has been reserved
system 00:08: ioport range 0xcd2-0xcd3 has been reserved
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0xfe00-0xfe00 has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xff800000-0xff80ffff has been reserved
system 00:09: iomem range 0xfff00000-0xffffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xf8000000-0xf81fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: 0x2000-0x2fff
pci 0000:00:04.0:   MEM window: 0x80000000-0x801fffff
pci 0000:00:04.0:   PREFETCH window: 0x00000080200000-0x000000803fffff
pci 0000:00:05.0: PCI bridge, secondary bus 0000:08
pci 0000:00:05.0:   IO window: 0xa000-0xafff
pci 0000:00:05.0:   MEM window: 0xf8300000-0xf83fffff
pci 0000:00:05.0:   PREFETCH window: 0x80400000-0x804fffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:0e
pci 0000:00:06.0:   IO window: 0x3000-0x3fff
pci 0000:00:06.0:   MEM window: 0xf8200000-0xf82fffff
pci 0000:00:06.0:   PREFETCH window: 0x00000080500000-0x000000806fffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:14
pci 0000:00:14.4:   IO window: disabled
pci 0000:00:14.4:   MEM window: 0xf8400000-0xf84fffff
pci 0000:00:14.4:   PREFETCH window: disabled
pci 0000:00:04.0: enabling device (0000 -> 0003)
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xf8000000-0xf81fffff]
pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf7ffffff]
pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:02: resource 1 mem: [0x80000000-0x801fffff]
pci_bus 0000:02: resource 2 pref mem [0x80200000-0x803fffff]
pci_bus 0000:08: resource 0 io:  [0xa000-0xafff]
pci_bus 0000:08: resource 1 mem: [0xf8300000-0xf83fffff]
pci_bus 0000:08: resource 2 pref mem [0x80400000-0x804fffff]
pci_bus 0000:0e: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:0e: resource 1 mem: [0xf8200000-0xf82fffff]
pci_bus 0000:0e: resource 2 pref mem [0x80500000-0x806fffff]
pci_bus 0000:14: resource 1 mem: [0xf8400000-0xf84fffff]
pci_bus 0000:14: resource 3 io:  [0x00-0xffff]
pci_bus 0000:14: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4395k freed
audit: initializing netlink socket (disabled)
type=3D2000 audit(1253802147.914:1): initialized
Warning: could not register the kmem tracer
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3681
SELinux:  Registering netfilter hooks
cryptomgr_test used greatest stack depth: 5728 bytes left
cryptomgr_test used greatest stack depth: 5664 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:05.0: Boot video device
  alloc irq_desc for 24 on node 0
  alloc kstat_irqs on node 0
pcieport-driver 0000:00:04.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:04.0: setting latency timer to 64
work_for_cpu used greatest stack depth: 5600 bytes left
  alloc irq_desc for 25 on node 0
  alloc kstat_irqs on node 0
pcieport-driver 0000:00:05.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:05.0: setting latency timer to 64
  alloc irq_desc for 26 on node 0
  alloc kstat_irqs on node 0
pcieport-driver 0000:00:06.0: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:06.0: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp: Slot [1] registered
pci-stub: invalid id string ""
ACPI: AC Adapter [ADP0] (on-line)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/inpu=
t1
ACPI: Power Button [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
ACPI: Lid Switch [LID]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN1] (off)
ACPI: processor limited to max C-state 1
processor LNXCPU:00: registered as cooling_device1
ACPI: Processor [CPU0] (supports 8 throttling states)
processor LNXCPU:01: registered as cooling_device2
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZCR] (75 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input3
ahci 0000:00:12.0: version 3.0
  alloc irq_desc for 22 on node 0
  alloc kstat_irqs on node 0
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part=
=20
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ACPI: Battery Slot [BAT0] (battery present)
ata1: SATA max UDMA/133 abar m1024@0xf8709000 port 0xf8709100 irq 22
ata2: SATA max UDMA/133 abar m1024@0xf8709000 port 0xf8709180 irq 22
ata3: SATA max UDMA/133 abar m1024@0xf8709000 port 0xf8709200 irq 22
ata4: SATA max UDMA/133 abar m1024@0xf8709000 port 0xf8709280 irq 22
work_for_cpu used greatest stack depth: 4608 bytes left
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:13.5: power state changed by ACPI to D0
  alloc irq_desc for 19 on node 0
  alloc kstat_irqs on node 0
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xf8709400
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31 ehci_hcd
usb usb1: SerialNumber: 0000:00:13.5
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
work_for_cpu used greatest stack depth: 3920 bytes left
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
  alloc irq_desc for 16 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 16, io mem 0xf8704000
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.31 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xf8705000
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.31 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
  alloc irq_desc for 18 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xf8706000
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.31 ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xf8707000
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.31 ohci_hcd
usb usb5: SerialNumber: 0000:00:13.3
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
work_for_cpu used greatest stack depth: 3888 bytes left
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xf8708000
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.31 ohci_hcd
usb usb6: SerialNumber: 0000:00:13.4
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redha=
t.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=3D1 kernel parameter, acct=3D1 nf_conntrack module option=
 or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
  Magic number: 9:130:385
usb usb3: hash matches
thermal cooling_device0: hash matches
rtc_cmos 00:04: setting system clock to 2009-09-24 14:22:29 UTC (1253802149)
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input4
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata1: softreset failed (device not ready)
ata1: applying SB600 PMP SRST workaround and retrying
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST9120822AS, 3.ALE, max UDMA/133
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
Freeing unused kernel memory: 3404k freed
Write protecting the kernel read-only data: 7484k
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04713/0x204000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/i=
nput5
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:05.0: power state changed by ACPI to D0
radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[drm] radeon: Initializing kernel modesetting.
[drm] register mmio base: 0xF8100000
[drm] register mmio size: 65536
ATOM BIOS: ATI
[drm] GPU reset succeed (RBBM_STATUS=3D0x10000140)
[drm] Clocks initialized !
[drm] radeon: 1 quad pipes, 1 z pipes initialized.
[drm] radeon: VRAM 128M
[drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
[drm] radeon: GTT 512M
[drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=3D128M, BAR=3D128M
[drm] RAM width 64bits DDR
[TTM] Zone  kernel: Available graphics memory: 944232 kiB.
[drm] radeon: 128M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: cp idle (0x10000C03)
[drm] Loading RS690/RS740 Microcode
platform radeon_cp.0: firmware: requesting radeon/RS690_cp.bin
[drm] radeon: ring at 0x0000000020000000
[drm] ring test succeeded in 0 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] radeon: kernel modesetting successfully initialized.
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Connector 1:
[drm]   LVDS
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     LCD1: INTERNAL_LVTM1
[drm] Connector 2:
[drm]   S-video
[drm]   Encoders:
[drm]     TV1: INTERNAL_KLDSCP_DAC1
[drm] fb mappable at 0xF0040000
[drm] vram apper at 0xF0000000
[drm] size 4096000
[drm] fb depth is 24
[drm]    pitch is 5120
executing set pll
executing set crtc timing
[drm] LVDS-10: set mode 1280x800 17
async/4 used greatest stack depth: 3536 bytes left
Console: switching to colour frame buffer device 160x50
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.0.0 20080528 for 0000:01:05.0 on minor 0
work_for_cpu used greatest stack depth: 2976 bytes left
EXT4-fs (dm-10): barriers enabled
kjournald2 starting: pid 123, dev dm-10:8, commit interval 5 seconds
EXT4-fs (dm-10): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (dm-10): mounted filesystem with ordered data mode
type=3D1404 audit(1253802197.182:2): enforcing=3D1 old_enforcing=3D0 auid=
=3D4294967295 ses=3D4294967295
SELinux: 8192 avtab hash slots, 138487 rules.
SELinux: 8192 avtab hash slots, 138487 rules.
SELinux:  8 users, 12 roles, 2875 types, 129 bools, 1 sens, 1024 cats
SELinux:  75 classes, 138487 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-10, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_cont=
exts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=3D1403 audit(1253802198.353:3): policy loaded auid=3D4294967295 ses=3D=
4294967295
readahead[153]: segfault at 0 ip 0000003b16a81272 sp 00007fffe505ec88 error=
 4 in libc-2.10.90.so[3b16a00000+176000]
udev: starting version 145
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_atiixp 0000:00:14.1: setting latency timer to 64
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8420 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8428 irq 15
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
ricoh-mmc: Ricoh MMC controller found at 0000:14:06.2 [1180:0843] (rev 12)
ricoh-mmc: Controller is now disabled.
ata5.00: ATAPI: TSSTcorp CDDVDW TS-L632H, TO01, max UDMA/33
ata5.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-L632H  TO01 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #1=
41
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8410, revision 0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
EDAC MC: Ver: 2.1.0 Sep 24 2009
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:08:00.0: setting latency timer to 64
  alloc irq_desc for 27 on node 0
  alloc kstat_irqs on node 0
r8169 0000:08:00.0: irq 27 for MSI/MSI-X
acpi device:20: registered as cooling_device3
eth0: RTL8101e at 0xffffc900054e8000, 00:a0:d1:85:85:cd, XID 94200000 IRQ 27
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1d/dev=
ice:1e/input/input6
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
EDAC amd64_edac:  Ver: 3.2.0 Sep 24 2009
EDAC amd64: This node reports that Memory ECC is currently disabled, set F3=
x44[22] (0000:00:18.3).
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:18.2 failed with error -22
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:14:06.1: SDHCI controller found [1180:0822] (rev 22)
  alloc irq_desc for 21 on node 0
  alloc kstat_irqs on node 0
sdhci-pci 0000:14:06.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
sdhci-pci 0000:14:06.1: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:14:06.1: setting latency timer to 64
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:14:06.1] using DMA
  alloc irq_desc for 20 on node 0
  alloc kstat_irqs on node 0
firewire_ohci 0000:14:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
firewire_ohci: Added fw-ohci device 0000:14:06.0, OHCI version 1.10
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: created device fw0: GUID 00080da0d18585cd, S400
cfg80211: World regulatory domain updated:
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ALSA sound/pci/hda/hda_codec.c:3881: autoconfig: line_outs=3D1 (0x14/0x0/0x=
0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3885:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0=
x0)
ALSA sound/pci/hda/hda_codec.c:3889:    hp_outs=3D1 (0x15/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3890:    mono: mono_out=3D0x0
ALSA sound/pci/hda/hda_codec.c:3901:    inputs: mic=3D0x18, fmic=3D0x0, lin=
e=3D0x0, fline=3D0x0, cd=3D0x0, aux=3D0x0
ALSA sound/pci/hda/patch_realtek.c:1282: realtek: No valid SSID, checking p=
incfg 0x4015812d for NID 0x1d
ALSA sound/pci/hda/patch_realtek.c:1298: realtek: Enabling init ASM_ID=3D0x=
812d CODEC_ID=3D10ec0268
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input7
ath5k 0000:0e:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k 0000:0e:00.0: setting latency timer to 64
ath5k 0000:0e:00.0: registered as 'phy0'
ath: EEPROM regdomain: 0x36
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: HR
ath: Regpair used: 0x36
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
cfg80211: Calling CRDA for country: HR
cfg80211: Regulatory domain changed to country: HR
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2000 mBm)
	(5250000 KHz - 5330000 KHz @ 20000 KHz), (N/A, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
kvm: Nested Virtualization enabled
device-mapper: multipath: version 1.1.0 loaded
EXT4-fs (dm-10): internal journal on dm-10:8
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
EXT4-fs (dm-11): barriers enabled
kjournald2 starting: pid 674, dev dm-11:8, commit interval 5 seconds
EXT4-fs (dm-11): internal journal on dm-11:8
EXT4-fs (dm-11): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (dm-11): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-11, type ext4), uses xattr
EXT4-fs (dm-5): barriers enabled
kjournald2 starting: pid 675, dev dm-5:8, commit interval 5 seconds
EXT4-fs (dm-5): warning: maximal mount count reached, running e2fsck is rec=
ommended
EXT4-fs (dm-5): internal journal on dm-5:8
EXT4-fs (dm-5): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (dm-5): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-5, type ext4), uses xattr
Adding 2097144k swap on /dev/dm-12.  Priority:-1 extents:1 across:2097144k=
=20
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contex=
ts
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-60 processor=
s (2 cpu cores) (version 2.20.00)
cpufreq-core: trying to register driver powernow-k8
cpufreq-core: adding CPU 0
powernow-k8:    0 : fid 0xc, vid 0x12
powernow-k8:    1 : fid 0xa, vid 0x13
powernow-k8:    2 : fid 0x8, vid 0x14
powernow-k8:    3 : fid 0x0, vid 0x1e
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x12
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x13
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x14
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: cpu0, init lo 0x120c, hi 0x1
powernow-k8: policy current frequency 2000000 kHz
freq-table: table entry 0: 2000000 kHz, 4620 index
freq-table: table entry 1: 1800000 kHz, 4874 index
freq-table: table entry 2: 1600000 kHz, 5128 index
freq-table: table entry 3: 800000 kHz, 7680 index
freq-table: setting show_table for cpu 0 to ffff880065e963b8
powernow-k8: cpu_init done, current fid 0xc, vid 0x12
cpufreq-core: CPU 1 already managed, adding link
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor switch
cpufreq-core: __cpufreq_governor for CPU 0, event 1
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: target for CPU 0: 2000000 kHz, relation 0
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 0
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 2000000 kHz (relation: 0) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: target matches current values (fid 0xc, vid 0x12)
cpufreq-core: initialization complete
cpufreq-core: adding CPU 1
cpufreq-core: driver powernow-k8 up and running
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor switch
cpufreq-core: __cpufreq_governor for CPU 0, event 2
cpufreq-core: __cpufreq_governor for CPU 0, event 1
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: target for CPU 0: 1000000 kHz, relation 0
powernow-k8: targ: cpu 0, 1000000 kHz, min 800000, max 2000000, relation 0
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 1000000 kHz (relation: 0) for cpu 0
freq-table: target is 2 (1600000 kHz, 5128)
powernow-k8: cpu 0 transition to index 2
powernow-k8: table matched fid 0x8, giving vid 0x14
powernow-k8: cpu 0, changing to fid 0x8, vid 0x14
cpufreq-core: notification 0 of frequency transition to 1600000 kHz
cpufreq-core: notification 0 of frequency transition to 1600000 kHz
Clocksource tsc unstable (delta =3D -266309162 ns)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
__ratelimit: 205 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
r8169: eth0: link up
r8169: eth0: link up
ADDRCONF(NETDEV_UP): wlan0: link is not ready
__ratelimit: 565 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 441 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
Bridge firewalling registered
virbr0: starting userspace STP failed, starting kernel STP
__ratelimit: 437 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
lo: Disabled Privacy Extensions
SELinux: initialized (dev proc, type proc), uses genfs_contexts
__ratelimit: 414 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 394 callbacks suppressed
cpufreq-core: target for CPU 0: 891304 kHz, relation 0
powernow-k8: targ: cpu 0, 891304 kHz, min 800000, max 2000000, relation 0
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 891304 kHz (relation: 0) for cpu 0
freq-table: target is 2 (1600000 kHz, 5128)
powernow-k8: cpu 0 transition to index 2
powernow-k8: table matched fid 0x8, giving vid 0x14
powernow-k8: cpu 0, changing to fid 0x8, vid 0x14
cpufreq-core: notification 0 of frequency transition to 1600000 kHz
cpufreq-core: notification 0 of frequency transition to 1600000 kHz
__ratelimit: 455 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 303 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
fuse init (API version 7.13)
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
__ratelimit: 465 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 400 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 620 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 666 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 468 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 176 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
__ratelimit: 233 callbacks suppressed
cpufreq-core: target for CPU 0: 717391 kHz, relation 0
powernow-k8: targ: cpu 0, 717391 kHz, min 800000, max 2000000, relation 0
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 717391 kHz (relation: 0) for cpu 0
freq-table: target is 3 (800000 kHz, 7680)
powernow-k8: cpu 0 transition to index 3
powernow-k8: table matched fid 0x0, giving vid 0x1e
powernow-k8: cpu 0, changing to fid 0x0, vid 0x1e
cpufreq-core: notification 0 of frequency transition to 800000 kHz
cpufreq-core: notification 0 of frequency transition to 800000 kHz
__ratelimit: 13 callbacks suppressed
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor switch
cpufreq-core: __cpufreq_governor for CPU 0, event 2
cpufreq-core: __cpufreq_governor for CPU 0, event 1
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0x0, vid 0x1e
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: cpu 0, changing to fid 0xc, vid 0x12
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
cpufreq-core: notification 0 of frequency transition to 2000000 kHz
powernow-k8: ph1 (cpu0): start, currfid 0x0, currvid 0x1e, reqvid 0x12, rvo=
 0x2
powernow-k8: ph1 maxvid=3D0x10
powernow-k8: ph1: curr 0x1e, req vid 0x12
powernow-k8: writing vid 0x1d, lo 0x11d00, hi 0x1
powernow-k8: ph1: curr 0x1d, req vid 0x12
powernow-k8: writing vid 0x1c, lo 0x11c00, hi 0x1
powernow-k8: ph1: curr 0x1c, req vid 0x12
powernow-k8: writing vid 0x1b, lo 0x11b00, hi 0x1
powernow-k8: ph1: curr 0x1b, req vid 0x12
powernow-k8: writing vid 0x1a, lo 0x11a00, hi 0x1
powernow-k8: ph1: curr 0x1a, req vid 0x12
powernow-k8: writing vid 0x19, lo 0x11900, hi 0x1
powernow-k8: ph1: curr 0x19, req vid 0x12
powernow-k8: writing vid 0x18, lo 0x11800, hi 0x1
powernow-k8: ph1: curr 0x18, req vid 0x12
powernow-k8: writing vid 0x17, lo 0x11700, hi 0x1
powernow-k8: ph1: curr 0x17, req vid 0x12
powernow-k8: writing vid 0x16, lo 0x11600, hi 0x1
powernow-k8: ph1: curr 0x16, req vid 0x12
powernow-k8: writing vid 0x15, lo 0x11500, hi 0x1
powernow-k8: ph1: curr 0x15, req vid 0x12
powernow-k8: writing vid 0x14, lo 0x11400, hi 0x1
powernow-k8: ph1: curr 0x14, req vid 0x12
powernow-k8: writing vid 0x13, lo 0x11300, hi 0x1
powernow-k8: ph1: curr 0x13, req vid 0x12
powernow-k8: writing vid 0x12, lo 0x11200, hi 0x1
powernow-k8: ph1: changing vid for rvo, req 0x11
powernow-k8: writing vid 0x11, lo 0x11100, hi 0x1
powernow-k8: ph1: changing vid for rvo, req 0x10
powernow-k8: writing vid 0x10, lo 0x11000, hi 0x1
powernow-k8: ph1 complete, currfid 0x0, currvid 0x10
powernow-k8: ph2 (cpu0): starting, currfid 0x0, currvid 0x10, reqfid 0xc
powernow-k8: writing fid 0xa, lo 0x1100a, hi 0x258
powernow-k8: writing fid 0xc, lo 0x1100c, hi 0x258
powernow-k8: ph2 complete, currfid 0xc, currvid 0x10
powernow-k8: ph3 (cpu0): starting, currfid 0xc, currvid 0x10
powernow-k8: writing vid 0x12, lo 0x1120c, hi 0x1
powernow-k8: ph3 complete, currfid 0xc, currvid 0x12
powernow-k8: transitioned (cpu0): new fid 0xc, vid 0x12
cpufreq-core: notification 1 of frequency transition to 2000000 kHz
cpufreq-core: notification 1 of frequency transition to 2000000 kHz
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: target matches current values (fid 0xc, vid 0x12)
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
sdhci-pci 0000:14:06.1: PCI INT B disabled
ACPI handle has no context!
ACPI handle has no context!
ath5k 0000:0e:00.0: PCI INT A disabled
radeon 0000:01:05.0: PCI INT A disabled
radeon 0000:01:05.0: power state changed by ACPI to D3
HDA Intel 0000:00:14.2: PCI INT A disabled
pata_atiixp 0000:00:14.1: PCI INT A disabled
ehci_hcd 0000:00:13.5: PCI INT D disabled
ohci_hcd 0000:00:13.4: PCI INT C disabled
ohci_hcd 0000:00:13.3: PCI INT B disabled
ohci_hcd 0000:00:13.2: PCI INT C disabled
ohci_hcd 0000:00:13.1: PCI INT B disabled
ohci_hcd 0000:00:13.0: PCI INT A disabled
ahci 0000:00:12.0: PCI INT A disabled
PM: suspend devices took 2.810 seconds
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
r8169 0000:08:00.0: PME# enabled
ehci_hcd 0000:00:13.5: power state changed by ACPI to D3
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
cpufreq-core: unregistering CPU 1
cpufreq-core: removing link
Broke affinity for irq 12
Broke affinity for irq 22
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
__ratelimit: 182 callbacks suppressed
cpufreq-core: suspending cpu 0
cpufreq-core: suspending cpu 1
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
cpufreq-core: resuming cpu 0
cpufreq-core: resuming cpu 1
BUG: sleeping function called from invalid context at kernel/mutex.c:280
in_atomic(): 0, irqs_disabled(): 1, pid: 1782, name: pm-suspend
2 locks held by pm-suspend/1782:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811d7ee8>] sysfs_write_file+0=
x4b/0x15a
 #1:  (pm_mutex){+.+.+.}, at: [<ffffffff810c057f>] enter_state+0x48/0x158
irq event stamp: 79758
hardirqs last  enabled at (79757): [<ffffffff8152a633>] __mutex_unlock_slow=
path+0x12f/0x158
hardirqs last disabled at (79758): [<ffffffff810c0327>] arch_suspend_disabl=
e_irqs+0x28/0x3e
softirqs last  enabled at (79644): [<ffffffff810737be>] __do_softirq+0x1c6/=
0x1f4
softirqs last disabled at (79609): [<ffffffff8101316c>] call_softirq+0x1c/0=
x30
Pid: 1782, comm: pm-suspend Not tainted 2.6.31 #15
Call Trace:
 [<ffffffff8105d15d>] __might_sleep+0x116/0x131
 [<ffffffff8152ace5>] mutex_lock_nested+0x38/0x68
 [<ffffffff810a1e69>] clocksource_resume+0x2b/0x86
 [<ffffffff810a100f>] timekeeping_resume+0x2d/0x1ea
 [<ffffffff81385de1>] __sysdev_resume+0x34/0xf5
 [<ffffffff81385f8e>] sysdev_resume+0xec/0x19b
 [<ffffffff810c048c>] suspend_devices_and_enter+0x14f/0x1fa
 [<ffffffff810c0625>] enter_state+0xee/0x158
 [<ffffffff810bfad7>] state_store+0xc5/0xf9
 [<ffffffff812ac26d>] kobj_attr_store+0x2a/0x40
 [<ffffffff811d7fa7>] sysfs_write_file+0x10a/0x15a
 [<ffffffff81165a33>] vfs_write+0xbd/0x12e
 [<ffffffff81165b96>] sys_write+0x59/0x91
 [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
Enabling non-boot CPUs ...
cpufreq-core: handle_update for cpu 0 called
cpufreq-core: updating policy for CPU 0
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: target matches current values (fid 0xc, vid 0x12)
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.45 BogoMIPS (lpj=3D19=
95226)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 01
kvm: enabling virtualization on CPU1
Switch to broadcast mode on CPU1
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
cpufreq-core: adding CPU 1
powernow-k8:    0 : fid 0xc, vid 0x12
powernow-k8:    1 : fid 0xa, vid 0x13
powernow-k8:    2 : fid 0x8, vid 0x14
powernow-k8:    3 : fid 0x0, vid 0x1e
powernow-k8: cpu1, init lo 0x120c, hi 0x1
powernow-k8: policy current frequency 2000000 kHz
freq-table: table entry 0: 2000000 kHz, 4620 index
freq-table: table entry 1: 1800000 kHz, 4874 index
freq-table: table entry 2: 1600000 kHz, 5128 index
freq-table: table entry 3: 800000 kHz, 7680 index
freq-table: setting show_table for cpu 1 to ffff880072d934c8
powernow-k8: cpu_init done, current fid 0xc, vid 0x12
cpufreq-core: CPU already managed, adding link
freq-table: clearing show_table for cpu 1
CPU1 is up
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
ACPI: Waking up from system sleep state S3
cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
cpufreq-core: updating policy for CPU 0
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: target matches current values (fid 0xc, vid 0x12)
cpufreq-core: CPU 1: _PPC is 0 - frequency not limited
cpufreq-core: updating policy for CPU 1
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
powernow-k8: targ: cpu 0, 2000000 kHz, min 800000, max 2000000, relation 1
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
freq-table: target is 0 (2000000 kHz, 4620)
powernow-k8: cpu 0 transition to index 0
powernow-k8: table matched fid 0xc, giving vid 0x12
powernow-k8: target matches current values (fid 0xc, vid 0x12)
pci 0000:00:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x=
4000)
pci 0000:00:01.0: restoring config space at offset 0x9 (was 0x10001, writin=
g 0xf7f1f001)
pcieport-driver 0000:00:04.0: restoring config space at offset 0xf (was 0xf=
f, writing 0x400ff)
pcieport-driver 0000:00:04.0: restoring config space at offset 0x9 (was 0x1=
0001, writing 0x80318021)
pcieport-driver 0000:00:04.0: restoring config space at offset 0x8 (was 0x0=
, writing 0x80108000)
pcieport-driver 0000:00:04.0: restoring config space at offset 0x7 (was 0x1=
01, writing 0x2121)
pcieport-driver 0000:00:04.0: restoring config space at offset 0x3 (was 0x1=
0000, writing 0x10008)
pcieport-driver 0000:00:04.0: restoring config space at offset 0x1 (was 0x1=
00000, writing 0x100407)
pcieport-driver 0000:00:05.0: restoring config space at offset 0xf (was 0xf=
f, writing 0x400ff)
pcieport-driver 0000:00:05.0: restoring config space at offset 0x9 (was 0x1=
0001, writing 0x80418041)
pcieport-driver 0000:00:05.0: restoring config space at offset 0x8 (was 0x0=
, writing 0xf830f830)
pcieport-driver 0000:00:05.0: restoring config space at offset 0x7 (was 0x2=
0000101, writing 0xa1a1)
pcieport-driver 0000:00:05.0: restoring config space at offset 0x3 (was 0x1=
0000, writing 0x10008)
pcieport-driver 0000:00:05.0: restoring config space at offset 0x1 (was 0x1=
00000, writing 0x100407)
pcieport-driver 0000:00:06.0: restoring config space at offset 0xf (was 0xf=
f, writing 0x400ff)
pcieport-driver 0000:00:06.0: restoring config space at offset 0x9 (was 0x1=
0001, writing 0x80618051)
pcieport-driver 0000:00:06.0: restoring config space at offset 0x8 (was 0x0=
, writing 0xf820f820)
pcieport-driver 0000:00:06.0: restoring config space at offset 0x7 (was 0x2=
0000101, writing 0x3131)
pcieport-driver 0000:00:06.0: restoring config space at offset 0x3 (was 0x1=
0000, writing 0x10008)
pcieport-driver 0000:00:06.0: restoring config space at offset 0x1 (was 0x1=
00000, writing 0x100407)
ahci 0000:00:12.0: restoring config space at offset 0x2 (was 0x1018f00, wri=
ting 0x1060100)
ahci 0000:00:12.0: set SATA to AHCI mode
ohci_hcd 0000:00:13.0: restoring config space at offset 0x1 (was 0x2a00002,=
 writing 0x2a00012)
ohci_hcd 0000:00:13.1: restoring config space at offset 0x1 (was 0x2a00002,=
 writing 0x2a00012)
ohci_hcd 0000:00:13.2: restoring config space at offset 0x1 (was 0x2a00002,=
 writing 0x2a00012)
ohci_hcd 0000:00:13.3: restoring config space at offset 0x1 (was 0x2a00002,=
 writing 0x2a00012)
ohci_hcd 0000:00:13.4: restoring config space at offset 0x1 (was 0x2a00002,=
 writing 0x2a00012)
ehci_hcd 0000:00:13.5: restoring config space at offset 0x3 (was 0x4008, wr=
iting 0x4010)
ehci_hcd 0000:00:13.5: restoring config space at offset 0x1 (was 0x2b00002,=
 writing 0x2b00012)
pata_atiixp 0000:00:14.1: restoring config space at offset 0x3 (was 0x0, wr=
iting 0x4000)
HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x10a, wr=
iting 0xa)
HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100006=
, writing 0x4100002)
r8169 0000:08:00.0: restoring config space at offset 0xf (was 0x100, writin=
g 0x105)
r8169 0000:08:00.0: restoring config space at offset 0x6 (was 0x4, writing =
0xf8300004)
r8169 0000:08:00.0: restoring config space at offset 0x4 (was 0x1, writing =
0xa001)
r8169 0000:08:00.0: restoring config space at offset 0x3 (was 0x0, writing =
0x10)
r8169 0000:08:00.0: restoring config space at offset 0x1 (was 0x100000, wri=
ting 0x100407)
ath5k 0000:0e:00.0: restoring config space at offset 0xf (was 0x100, writin=
g 0x10b)
ath5k 0000:0e:00.0: restoring config space at offset 0x4 (was 0x4, writing =
0xf8200004)
ath5k 0000:0e:00.0: restoring config space at offset 0x3 (was 0x0, writing =
0x8)
ath5k 0000:0e:00.0: restoring config space at offset 0x1 (was 0x100000, wri=
ting 0x100007)
firewire_ohci 0000:14:06.0: restoring config space at offset 0xf (was 0x402=
0100, writing 0x402010b)
firewire_ohci 0000:14:06.0: restoring config space at offset 0x3 (was 0x800=
000, writing 0x804008)
sdhci-pci 0000:14:06.1: restoring config space at offset 0xf (was 0x200, wr=
iting 0x20b)
sdhci-pci 0000:14:06.1: restoring config space at offset 0x4 (was 0x0, writ=
ing 0xf8400800)
sdhci-pci 0000:14:06.1: restoring config space at offset 0x3 (was 0x800000,=
 writing 0x804008)
sdhci-pci 0000:14:06.1: restoring config space at offset 0x1 (was 0x2100000=
, writing 0x2100006)
ricoh-mmc 0000:14:06.2: restoring config space at offset 0xf (was 0x200, wr=
iting 0x20b)
ricoh-mmc 0000:14:06.2: restoring config space at offset 0x4 (was 0x0, writ=
ing 0xf8400c00)
ricoh-mmc 0000:14:06.2: restoring config space at offset 0x3 (was 0x800000,=
 writing 0x804008)
ricoh-mmc 0000:14:06.2: restoring config space at offset 0x1 (was 0x2100000=
, writing 0x2100006)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
pci 0000:14:06.3: restoring config space at offset 0xf (was 0x200, writing =
0x20b)
pci 0000:14:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x=
f8401400)
pci 0000:14:06.3: restoring config space at offset 0x3 (was 0x800000, writi=
ng 0x804008)
pci 0000:14:06.3: restoring config space at offset 0x1 (was 0x2100000, writ=
ing 0x2100006)
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
BUG kmalloc-256: Poison overwritten
---------------------------------------------------------------------------=
--

INFO: 0xffff880073bf1bb0-0xffff880073bf1bb7. First byte 0x12 instead of 0x6b
INFO: Allocated in powernowk8_cpu_init+0x72/0xc27 [powernow_k8] age=3D290 c=
pu=3D0 pid=3D1782
INFO: Freed in powernowk8_cpu_exit+0x6b/0x88 [powernow_k8] age=3D289 cpu=3D=
0 pid=3D1782
INFO: Slab 0xffffea0002f059e8 objects=3D12 used=3D10 fp=3D0xffff880073bf1b8=
8 flags=3D0x200000000000c3
INFO: Object 0xffff880073bf1b88 @offset=3D2952 fp=3D0xffff880073bf1e18

Bytes b4 0xffff880073bf1b78:  ec 77 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a =
5a =ECw=FE=FF....ZZZZZZZZ
  Object 0xffff880073bf1b88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1ba8:  6b 6b 6b 6b 6b 6b 6b 6b 12 00 00 00 0c 00 00 =
00 kkkkkkkk........
  Object 0xffff880073bf1bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1bc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1bd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1be8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1bf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880073bf1c78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
a5 kkkkkkkkkkkkkkk=A5
 Redzone 0xffff880073bf1c88:  bb bb bb bb bb bb bb bb                      =
   =BB=BB=BB=BB=BB=BB=BB=BB       =20
 Padding 0xffff880073bf1cc8:  5a 5a 5a 5a 5a 5a 5a 5a                      =
   ZZZZZZZZ       =20
Pid: 1782, comm: pm-suspend Not tainted 2.6.31 #15
Call Trace:
 [<ffffffff81152698>] print_trailer+0x153/0x174
 [<ffffffff81152ccb>] check_bytes_and_report+0xc9/0x10e
 [<ffffffff81152de9>] check_object+0xd9/0x1d3
 [<ffffffff81154dda>] __slab_alloc+0x332/0x3f0
 [<ffffffff811ce4a1>] ? __proc_create+0x9c/0x148
 [<ffffffff81156a9d>] __kmalloc+0x130/0x1c4
 [<ffffffff811cd764>] ? xlate_proc_name+0xb9/0xde
 [<ffffffff811ce4a1>] ? __proc_create+0x9c/0x148
 [<ffffffff811ce4a1>] __proc_create+0x9c/0x148
 [<ffffffff811ce788>] proc_mkdir_mode+0x3d/0x7d
 [<ffffffff811ce7f1>] proc_mkdir+0x29/0x3f
 [<ffffffff810e4333>] register_handler_proc+0xf3/0x120
 [<ffffffff810e1bf3>] __setup_irq+0x273/0x32a
 [<ffffffffa028c4c0>] ? azx_interrupt+0x0/0x159 [snd_hda_intel]
 [<ffffffff810e229e>] request_threaded_irq+0x15c/0x202
 [<ffffffffa028c296>] azx_acquire_irq+0x5b/0xc8 [snd_hda_intel]
 [<ffffffffa028d134>] azx_resume+0xae/0x14d [snd_hda_intel]
 [<ffffffff812cb12e>] pci_legacy_resume+0x4b/0x70
 [<ffffffff812cb2fe>] pci_pm_resume+0x63/0xad
 [<ffffffff8138db38>] pm_op+0x7e/0x113
 [<ffffffff8138e876>] dpm_resume_end+0xf1/0x45a
 [<ffffffff810c04e3>] suspend_devices_and_enter+0x1a6/0x1fa
 [<ffffffff810c0625>] enter_state+0xee/0x158
 [<ffffffff810bfad7>] state_store+0xc5/0xf9
 [<ffffffff812ac26d>] kobj_attr_store+0x2a/0x40
 [<ffffffff811d7fa7>] sysfs_write_file+0x10a/0x15a
 [<ffffffff81165a33>] vfs_write+0xbd/0x12e
 [<ffffffff81165b96>] sys_write+0x59/0x91
 [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
FIX kmalloc-256: Restoring 0xffff880073bf1bb0-0xffff880073bf1bb7=3D0x6b

FIX kmalloc-256: Marking all objects used
radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[drm] GPU reset succeed (RBBM_STATUS=3D0x10000140)
[drm] Clocks initialized !
[drm] radeon: 1 quad pipes, 1 z pipes initialized.
[drm] radeon: VRAM 128M
[drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
[drm] radeon: GTT 512M
[drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[drm] radeon: cp idle (0x10000C03)
[drm] radeon: ring at 0x0000000020000000
[drm] ring test succeeded in 0 usecs
executing set pll
executing set crtc timing
[drm] LVDS-10: set mode 1280x800 17
r8169 0000:08:00.0: PME# disabled
ath5k 0000:0e:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:14:06.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
sdhci-pci 0000:14:06.1: Will use DMA mode even though HW doesn't fully clai=
m to support it.
firewire_core: skipped bus generations, destroying all nodes
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata5.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata5.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata5.00: configured for UDMA/33
firewire_core: rediscovered device fw0
ata1: softreset failed (device not ready)
ata1: applying SB600 PMP SRST workaround and retrying
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/133
PM: resume devices took 2.170 seconds
PM: Finishing wakeup.
Restarting tasks ... done.
cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
freq-table: request for verification of policy (800000 - 2000000 kHz) for c=
pu 0
freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
cpufreq-core: governor switch
cpufreq-core: __cpufreq_governor for CPU 0, event 2
cpufreq-core: __cpufreq_governor for CPU 0, event 1
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
r8169: eth0: link up
r8169: eth0: link up
ADDRCONF(NETDEV_UP): wlan0: link is not ready
__ratelimit: 136 callbacks suppressed
cpufreq-core: target for CPU 0: 1304347 kHz, relation 0
powernow-k8: targ: cpu 0, 1304347 kHz, min 800000, max 2000000, relation 0
powernow-k8: targ: curr fid 0xc, vid 0x12
freq-table: request for target 1304347 kHz (relation: 0) for cpu 0
freq-table: target is 2 (1600000 kHz, 5128)
powernow-k8: cpu 0 transition to index 2
powernow-k8: table matched fid 0x8, giving vid 0x14
powernow-k8: cpu 0, changing to fid 0x8, vid 0x14
cpufreq-core: notification 0 of frequency transition to 1600000 kHz
cpufreq-core: notification 0 of frequency transition to 1600000 kHz
__ratelimit: 109 callbacks suppressed


--MP_/Pubd4mh9pFk.6H.Q4uXGLhF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=config.txt

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31
# Thu Sep 24 15:14:14 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=m
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_EVENT_PROFILE=y
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_UV is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_TARGET_HL is not set
# CONFIG_IP6_NF_TARGET_LOG is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
# CONFIG_IP6_NF_SECURITY is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEFAULT_PS_VALUE=1
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NET is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
CONFIG_SFC=m
# CONFIG_BE2NET is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
# CONFIG_ATH9K is not set
# CONFIG_AR9170_USB is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set
# CONFIG_HERMES is not set
# CONFIG_WL12XX is not set
# CONFIG_IWM is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_MISDN is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set
CONFIG_XEN_KBDDEV_FRONTEND=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_WINBOND_CIR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=5
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_AT91 is not set
# CONFIG_MMC_ATMELMCI is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set

#
# TI VLYNQ
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XEN_DEV_EVTCHN is not set
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_AGNX is not set
# CONFIG_OTUS is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set
# CONFIG_RT3090 is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_ALTERA_PCIE_CHDMA is not set
# CONFIG_RTL8187SE is not set
# CONFIG_RTL8192SU is not set
# CONFIG_RTL8192E is not set
# CONFIG_INPUT_MIMIO is not set
# CONFIG_TRANZPORT is not set

#
# Android
#
# CONFIG_ANDROID is not set

#
# Qualcomm MSM Camera And Video
#

#
# Camera Sensor Selection
#
# CONFIG_INPUT_GPIO is not set
# CONFIG_DST is not set
# CONFIG_POHMELFS is not set
# CONFIG_B3DFG is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_PLAN9AUTH is not set
# CONFIG_LINE6_USB is not set
CONFIG_DRM_RADEON_KMS=y
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_USB_CPC is not set
# CONFIG_FB_UDL is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set

#
# RAR Register Driver
#
# CONFIG_RAR_REGISTER is not set
# CONFIG_IIO is not set
# CONFIG_COWLOOP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--MP_/Pubd4mh9pFk.6H.Q4uXGLhF--
