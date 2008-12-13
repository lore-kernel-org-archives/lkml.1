Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYLMAF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYLMAF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 19:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYLMAFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 19:05:49 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20053 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYLMAFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 19:05:44 -0500
Date: Fri, 12 Dec 2008 17:05:38 -0700
From: Alex Chiang <achiang@hp.com>
To: matthew@wil.cx, torvalds@linux-foundation.org
Cc: justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: PCI BAR mem resource allocation "regression"
Message-ID: <20081213000538.GC9947@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, matthew@wil.cx,
	torvalds@linux-foundation.org, justin.chen@hp.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi willy, Linus,

I've been chasing a bug for the past week or so that I can't seem
to figure out, and was hoping to get your eyes on it.

The basic summary is, we can't allocate a memory resource for our
BAR after a PCI hotplug operation. We've been able to bisect it
down to d33b6fba2c4350651f3f61ff2ab858a2f116e9a4 (Resources:
insert identical resources above existing resources).

This happened around the 2.6.19 timeframe, and we just haven't
noticed it until now. My testing has been with latest 2.6.28-rc8
release.

Since it's been around for so long, I don't think this is urgent
enough to hold 2.6.28, but it would be nice to understand and
fix. :)

I've got a lot of data that I'll include in this mail, but the
general "table of contents" are:

	(a) console log from mainline
	(b) console log with revert patch applied
	(c) memory map presented by firmware
	(d) dmesg from mainline
	(e) dmesg with revert patch
	(f) lspci -vv output
	(g) the revert patch I used

The only real difference between (a) and (b) is this error:

pci 0000:c3:00.0: BAR 0: can't allocate mem resource [0xfe000000-0xfdffffff]

There was no significant difference between (d) and (e), but I
included them both for completeness.

As regards (g), I couldn't do a plain 'git revert' because of
conflicts due to changes since 2.6.19. I manually reverted it,
and I'm pretty sure I got it right, but that might be worth
double-checking too.

Thanks.

/ac

# (a) console log from mainline
[root@canola ~]# dmesg -n 8
[root@canola ~]# modprobe acpiphp
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [9] registered
acpiphp: Slot [10] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [7] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [6] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [8] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [4] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [3] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [5] registered

[root@canola ~]# cat /sys/bus/pci/slots/5/address
0000:c3:00

[root@canola ~]# lspci | grep c3
c3:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex (Tavor compatibility mode) (rev a0)

[root@canola ~]# echo 0 > /sys/bus/pci/slots/5/power
[root@canola ~]#
[root@canola ~]# echo 1 > /sys/bus/pci/slots/5/power
pci 0000:c3:00.0: reg 10 64bit mmio: [0x000000-0x0fffff]
pci 0000:c3:00.0: reg 18 64bit mmio: [0x000000-0x7fffff]
pci 0000:c3:00.0: reg 20 64bit mmio: [0x000000-0x7ffffff]
pci 0000:c3:00.0: BAR 0: can't allocate mem resource [0xfe000000-0xfdffffff]
decode_hpp: Could not get hotplug parameters. Use defaults
[root@canola ~]# 

# (b) console log with revert patch applied
[root@canola ~]# dmesg -n 8
[root@canola ~]# modprobe acpiphp
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [9] registered
acpiphp: Slot [10] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [7] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [6] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [8] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [4] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [3] registered
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp: Slot [5] registered

[root@canola ~]# cat /sys/bus/pci/slots/5/address
0000:c3:00

[root@canola ~]# lspci | grep c3
c3:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex (Tavor compatibility mode) (rev a0)

[root@canola ~]# echo 0 > /sys/bus/pci/slots/5/power
[root@canola ~]#
[root@canola ~]# echo 1 > /sys/bus/pci/slots/5/power
pci 0000:c3:00.0: reg 10 64bit mmio: [0x000000-0x0fffff]
pci 0000:c3:00.0: reg 18 64bit mmio: [0x000000-0x7fffff]
pci 0000:c3:00.0: reg 20 64bit mmio: [0x000000-0x7ffffff]
decode_hpp: Could not get hotplug parameters. Use defaults
[root@canola ~]#

# (c) memory map presented by firmware
Shell> memmap
Type       Start            End               # Pages          Attributes
BS_data    0000000000000000-0000000000000FFF  0000000000000001 0000000000000008
available  0000000000001000-000000000009FFFF  000000000000009F 0000000000000008
MemMapIO   00000000000A0000-00000000000BFFFF  0000000000000020 0000000000000003
RT_code    00000000000C0000-00000000000FFFFF  0000000000000040 8000000000000001
BS_data    0000000000100000-0000000000100FFF  0000000000000001 0000000000000008
available  0000000000101000-000000003DC3BFFF  000000000003DB3B 0000000000000008
RT_code    000000003DC3C000-000000003DDD7FFF  000000000000019C 8000000000000008
RT_data    000000003DDD8000-000000003DDD9FFF  0000000000000002 8000000000000008
RT_code    000000003DDDA000-000000003E199FFF  00000000000003C0 8000000000000008
BS_data    000000003E19A000-000000003E527FFF  000000000000038E 0000000000000008
RT_data    000000003E528000-000000003F7FFFFF  00000000000012D8 8000000000000008
PAL_code   000000003F800000-000000003FBFFFFF  0000000000000400 8000000000000008
available  000000003FC00000-000000003FD54FFF  0000000000000155 0000000000000008
BS_data    000000003FD55000-000000003FD55FFF  0000000000000001 0000000000000008
RT_data    000000003FD56000-000000003FD57FFF  0000000000000002 8000000000000008
BS_data    000000003FD58000-000000003FD5DFFF  0000000000000006 0000000000000008
RT_data    000000003FD5E000-000000003FD5FFFF  0000000000000002 8000000000000008
BS_data    000000003FD60000-000000003FD65FFF  0000000000000006 0000000000000008
RT_data    000000003FD66000-000000003FDC7FFF  0000000000000062 8000000000000008
BS_data    000000003FDC8000-000000003FDCDFFF  0000000000000006 0000000000000008
ACPI_recl  000000003FDCE000-000000003FDF7FFF  000000000000002A 0000000000000008
RT_data    000000003FDF8000-000000003FDFFFFF  0000000000000008 8000000000000008
RT_code    000000003FE00000-000000003FFFFFFF  0000000000000200 8000000000000008
MemMapIO   0000000080000000-00000000FDFFFFFF  000000000007E000 0000000000000003
MemMapIO   00000000FED00000-00000000FFFFFFFF  0000000000001300 8000000000000001
available  0000000100000000-00000005FFFFFFFF  0000000000500000 0000000000000008
available  0000010040000000-00000100FF1FDFFF  00000000000BF1FE 0000000000000008
ACPI_recl  00000100FF1FE000-00000100FF1FFFFF  0000000000000002 0000000000000008
available  00000100FF200000-00000100FF453FFF  0000000000000254 0000000000000008
BS_data    00000100FF454000-00000100FF800FFF  00000000000003AD 0000000000000008
available  00000100FF801000-00000100FF903FFF  0000000000000103 0000000000000008
BS_data    00000100FF904000-00000100FFBFFFFF  00000000000002FC 0000000000000008
available  00000100FFC00000-00000100FFE74FFF  0000000000000275 0000000000000008
BS_code    00000100FFE75000-00000100FFFFFFFF  000000000000018B 0000000000000008
MemMapIO   0000080000000000-00000807FFFFFFFF  0000000000800000 0000000000000003
MemPortIO  0003FFFFFC000000-0003FFFFFFFFFFFF  0000000000004000 0000000000000001

  BS_code   :     395 Pages (1,617,920)
  BS_data   :   2,636 Pages (10,797,056)
  RT_code   :   1,948 Pages (7,979,008)
  RT_data   :   4,936 Pages (20,217,856)
  available : 6,280,441 Pages (25,724,686,336)
  ACPI_recl :      44 Pages (180,224)
  MemMapIO  : 8,909,600 Pages (36,493,721,600)
  MemPortIO :  16,384 Pages (67,108,864)
  PAL_code  :   1,024 Pages (4,194,304)
Total Memory: 24,575 MB (25,769,672,704) Bytes

Shell>

# (d) dmesg from mainline
[root@canola ~]# dmesg
Initializing cgroup subsys cpuset
Linux version 2.6.28-rc8-00001-g6c34bc2 (achiang@bob) (gcc version 3.4.5) #5 SMP Fri Dec 12 14:40:35 MST 2008
EFI v2.00 by HP: SALsystab=0x3e528000 ACPI 2.0=0x3fdd0000 SMBIOS=0x3e52a000 HCDP=0x3fdce000
booting generic kernel on platform hpzx1
PCDP: v3 at 0x3fdce000
Early serial console at MMIO 0x84033000 (options '115200n8')
console [uart8250] enabled
ACPI: RSDP 3FDD0000, 0028 (r2     HP)
ACPI: XSDT 3FDD002C, 0114 (r1     HP   rx6600        0   HP        0)
ACPI: FACP 3FDF7818, 00F4 (r3     HP   rx6600        0   HP        0)
ACPI: DSDT 3FDD01C8, 19E62 (r1     HP   rx6600        7 INTL 20050309)
ACPI: FACS 3FDF7910, 0040
ACPI: SPCR 3FDF7950, 0050 (r1     HP                 0   HP        0)
ACPI: DBGP 3FDF79A0, 0034 (r1     HP   rx6600        0   HP        0)
ACPI: APIC 3FDF7DC0, 0178 (r1     HP   rx6600        0   HP        0)
ACPI: SPMI 3FDF79D8, 0050 (r4     HP   rx6600        0   HP        0)
ACPI: CPEP 3FDF7C90, 0034 (r1     HP   rx6600        0   HP        0)
ACPI: SSDT 3FDEA038, 04B3 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEA4F8, 22BF (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEC7B8, 1277 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEDA38, 1A37 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEF478, 1214 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF0698, 1284 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF1928, 33D8 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF4D08, 198D (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6698, 0138 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF67D8, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF68C8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6A08, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6AF8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6C38, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6D28, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6E68, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6F58, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF7098, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF7188, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF72C8, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF73B8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF74F8, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF75E8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF7728, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: Local APIC address c0000000fee00000
SMP: Allowing 16 CPUs, 8 hotplug CPUs
Initial ramdisk at: 0xe0000100fede8000 (3830236 bytes)
SAL 3.20: HP version 4.3
SAL Platform features: None
SAL: AP wakeup using external interrupt vector 0xff
ACPI: Local APIC address c0000000fee00000
GSI 25 (level, low) -> CPU 0 (0x0000) vector 48
8 CPUs available, 16 CPUs total
MCA related initialization done
Virtual mem_map starts at 0xa07fffffc7c80000
Zone PFN ranges:
  DMA      0x00000100 -> 0x00010000
  Normal   0x00010000 -> 0x01010000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000100 -> 0x00003dc3
    0: 0x00003e1a -> 0x00003e52
    0: 0x00003fc0 -> 0x00003fd5
    0: 0x00010000 -> 0x00060000
    0: 0x01004000 -> 0x0100ff1f
    0: 0x0100ff20 -> 0x01010000
On node 0 totalpages: 392463
free_area_init_node: node 0, pgdat e000000001380000, node_mem_map a07fffffc7c83800
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 15576 pages, LIFO batch:1
  Normal zone: 14336 pages used for memmap
  Normal zone: 362495 pages, LIFO batch:1
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 378071
Policy zone: Normal
Kernel command line: BOOT_IMAGE=scsi0:\EFI\redhat\vmlinuz-2.6.28-rc8-00001-g6c34bc2  rhgb root=UUID=c8c0d0b3-bf0c-4a2d-b3fd-6038792f273d selinux=0 ro
PID hash table entries: 4096 (order: 12, 32768 bytes)
CPU 0: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
Console: colour VGA+ 80x25
Memory: 25042496k/25068608k available (8557k code, 75136k reserved, 11640k data, 1792k init)
SLUB: Genslabs=17, HWalign=128, Order=0-3, MinObjects=0, CPUs=16, Nodes=1024
Calibrating delay loop... 3186.68 BogoMIPS (lpj=6373376)
Dentry cache hash table entries: 4194304 (order: 9, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 8, 16777216 bytes)
Mount-cache hash table entries: 4096
ACPI: Core revision 20080926
Boot processor id 0x0/0x0
Fixed BSP b0 value from CPU 1
CPU 1: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 158 cycles)
CPU 1: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
CPU 2: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 159 cycles)
CPU 2: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
CPU 3: synchronized ITC with CPU 0 (last diff -8 cycles, maxerr 162 cycles)
CPU 3: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
CPU 4: synchronized ITC with CPU 0 (last diff -7 cycles, maxerr 159 cycles)
CPU 4: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
CPU 5: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 159 cycles)
CPU 5: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
CPU 6: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 159 cycles)
CPU 6: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
CPU 7: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 159 cycles)
CPU 7: base freq=266.143MHz, ITC ratio=6/4, ITC freq=399.215MHz+/-150ppm
Brought up 8 CPUs
Total of 8 processors activated (25493.50 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 0 1 2 3 4 5 6 7
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU1 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 1 2 3 4 5 6 7 0
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU2 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 2 3 4 5 6 7 0 1
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU3 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 3 4 5 6 7 0 1 2
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU4 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 4 5 6 7 0 1 2 3
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU5 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 5 6 7 0 1 2 3 4
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU6 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 6 7 0 1 2 3 4 5
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU7 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 7 0 1 2 3 4 5 6
  domain 1: span 0-7 level NODE
   groups: 0-7
net_namespace: 552 bytes
DMI 2.4 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOSAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [L000] (0000:00)
pci 0000:00:01.1: reg 14 64bit mmio: [0x84034000-0x84034fff]
pci 0000:00:01.1: reg 1c 64bit mmio: [0x80080000000-0x8008001ffff]
pci 0000:00:01.2: reg 14 64bit mmio: [0x84033000-0x84033fff]
pci 0000:00:02.0: reg 10 32bit mmio: [0x84032000-0x84032fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0x84031000-0x84031fff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.2: reg 10 32bit mmio: [0x84030000-0x840300ff]
pci 0000:00:02.2: supports D1 D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.2: PME# disabled
pci 0000:00:04.0: reg 10 32bit mmio: [0x80000000-0x83ffffff]
pci 0000:00:04.0: reg 14 io port: [0x1000-0x10ff]
pci 0000:00:04.0: reg 18 32bit mmio: [0x84020000-0x8402ffff]
pci 0000:00:04.0: reg 30 32bit mmio: [0x84000000-0x8401ffff]
pci 0000:00:04.0: Boot video device
pci 0000:00:04.0: supports D1 D2
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L000._PRT]
ACPI: PCI Root Bridge [L001] (0000:01)
pci 0000:01:02.0: reg 10 64bit mmio: [0x90120000-0x9013ffff]
pci 0000:01:02.0: reg 18 64bit mmio: [0x900c0000-0x900fffff]
pci 0000:01:02.0: reg 20 io port: [0x1040-0x107f]
pci 0000:01:02.0: reg 30 32bit mmio: [0x90080000-0x900bffff]
pci 0000:01:02.0: PME# supported from D0 D3hot
pci 0000:01:02.0: PME# disabled
pci 0000:01:02.1: reg 10 64bit mmio: [0x90100000-0x9011ffff]
pci 0000:01:02.1: reg 18 64bit mmio: [0x90040000-0x9007ffff]
pci 0000:01:02.1: reg 20 io port: [0x1000-0x103f]
pci 0000:01:02.1: reg 30 32bit mmio: [0x90000000-0x9003ffff]
pci 0000:01:02.1: PME# supported from D0 D3hot
pci 0000:01:02.1: PME# disabled
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L001._PRT]
ACPI: PCI Root Bridge [L002] (0000:0a)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L002._PRT]
ACPI: PCI Root Bridge [L003] (0000:0f)
pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:10:00.0: reg 10 64bit mmio: [0xb0083000-0xb0083fff]
pci 0000:10:00.0: reg 18 64bit mmio: [0xb0082000-0xb00820ff]
pci 0000:10:00.0: reg 20 io port: [0x1100-0x11ff]
pci 0000:10:00.0: reg 30 32bit mmio: [0xb0040000-0xb007ffff]
pci 0000:10:00.1: reg 10 64bit mmio: [0xb0081000-0xb0081fff]
pci 0000:10:00.1: reg 18 64bit mmio: [0xb0080000-0xb00800ff]
pci 0000:10:00.1: reg 20 io port: [0x1000-0x10ff]
pci 0000:10:00.1: reg 30 32bit mmio: [0xb0000000-0xb003ffff]
pci 0000:0f:00.0: bridge io port: [0x1000-0xffff]
pci 0000:0f:00.0: bridge 32bit mmio: [0xb0000000-0xbfffffff]
pci 0000:0f:00.0: bridge 64bit mmio pref: [0x80380000000-0x803ffffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L003._PRT]
ACPI: PCI Root Bridge [L004] (0000:48)
pci 0000:48:02.0: reg 10 64bit mmio: [0xc0120000-0xc013ffff]
pci 0000:48:02.0: reg 18 64bit mmio: [0xc00c0000-0xc00fffff]
pci 0000:48:02.0: reg 20 io port: [0x1040-0x107f]
pci 0000:48:02.0: reg 30 32bit mmio: [0xc0080000-0xc00bffff]
pci 0000:48:02.0: PME# supported from D0 D3hot D3cold
pci 0000:48:02.0: PME# disabled
pci 0000:48:02.1: reg 10 64bit mmio: [0xc0100000-0xc011ffff]
pci 0000:48:02.1: reg 18 64bit mmio: [0xc0040000-0xc007ffff]
pci 0000:48:02.1: reg 20 io port: [0x1000-0x103f]
pci 0000:48:02.1: reg 30 32bit mmio: [0xc0000000-0xc003ffff]
pci 0000:48:02.1: PME# supported from D0 D3hot
pci 0000:48:02.1: PME# disabled
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L004._PRT]
ACPI: PCI Root Bridge [L005] (0000:49)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L005._PRT]
ACPI: PCI Root Bridge [L006] (0000:4e)
pci 0000:4e:00.0: PME# supported from D0 D3hot D3cold
pci 0000:4e:00.0: PME# disabled
pci 0000:4f:00.0: PME# supported from D0 D3hot D3cold
pci 0000:4f:00.0: PME# disabled
pci 0000:4e:00.0: bridge io port: [0x1000-0xffff]
pci 0000:4e:00.0: bridge 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:4e:00.0: bridge 64bit mmio pref: [0x80680000000-0x806ffffffff]
pci 0000:50:00.0: PME# supported from D0 D3hot D3cold
pci 0000:50:00.0: PME# disabled
pci 0000:50:01.0: PME# supported from D0 D3hot D3cold
pci 0000:50:01.0: PME# disabled
pci 0000:4f:00.0: bridge io port: [0x1000-0xffff]
pci 0000:4f:00.0: bridge 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:4f:00.0: bridge 64bit mmio pref: [0x80680000000-0x806ffffffff]
pci 0000:51:00.0: PME# supported from D0 D3hot D3cold
pci 0000:51:00.0: PME# disabled
pci 0000:50:00.0: bridge io port: [0x9000-0xffff]
pci 0000:50:00.0: bridge 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:50:00.0: bridge 64bit mmio pref: [0x80680000000-0x806bfffffff]
pci 0000:52:02.0: PME# supported from D0 D3hot D3cold
pci 0000:52:02.0: PME# disabled
pci 0000:52:04.0: PME# supported from D0 D3hot D3cold
pci 0000:52:04.0: PME# disabled
pci 0000:51:00.0: bridge io port: [0x9000-0xffff]
pci 0000:51:00.0: bridge 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:51:00.0: bridge 64bit mmio pref: [0x80680000000-0x806bfffffff]
pci 0000:53:00.0: reg 10 32bit mmio: [0xe4820000-0xe483ffff]
pci 0000:53:00.0: reg 14 32bit mmio: [0xe4400000-0xe47fffff]
pci 0000:53:00.0: reg 18 io port: [0x9020-0x903f]
pci 0000:53:00.0: PME# supported from D0 D3hot
pci 0000:53:00.0: PME# disabled
pci 0000:53:00.1: reg 10 32bit mmio: [0xe4800000-0xe481ffff]
pci 0000:53:00.1: reg 14 32bit mmio: [0xe4000000-0xe43fffff]
pci 0000:53:00.1: reg 18 io port: [0x9000-0x901f]
pci 0000:53:00.1: PME# supported from D0 D3hot
pci 0000:53:00.1: PME# disabled
pci 0000:52:02.0: bridge io port: [0x9000-0xcfff]
pci 0000:52:02.0: bridge 32bit mmio: [0xe4000000-0xe7ffffff]
pci 0000:52:02.0: bridge 64bit mmio pref: [0x80680000000-0x8069fffffff]
pci 0000:54:00.0: reg 10 32bit mmio: [0xe0820000-0xe083ffff]
pci 0000:54:00.0: reg 14 32bit mmio: [0xe0400000-0xe07fffff]
pci 0000:54:00.0: reg 18 io port: [0xd020-0xd03f]
pci 0000:54:00.0: PME# supported from D0 D3hot
pci 0000:54:00.0: PME# disabled
pci 0000:54:00.1: reg 10 32bit mmio: [0xe0800000-0xe081ffff]
pci 0000:54:00.1: reg 14 32bit mmio: [0xe0000000-0xe03fffff]
pci 0000:54:00.1: reg 18 io port: [0xd000-0xd01f]
pci 0000:54:00.1: PME# supported from D0 D3hot
pci 0000:54:00.1: PME# disabled
pci 0000:52:04.0: bridge io port: [0xd000-0xffff]
pci 0000:52:04.0: bridge 32bit mmio: [0xe0000000-0xe3ffffff]
pci 0000:52:04.0: bridge 64bit mmio pref: [0x806a0000000-0x806bfffffff]
pci 0000:89:00.0: reg 10 64bit mmio: [0xe8000000-0xe80fffff]
pci 0000:89:00.0: reg 18 io port: [0x1000-0x10ff]
pci 0000:89:00.0: reg 1c 64bit mmio: [0xe8140000-0xe8140fff]
pci 0000:89:00.0: reg 30 32bit mmio: [0xe8100000-0xe813ffff]
pci 0000:89:00.0: supports D1
pci 0000:50:01.0: bridge io port: [0x1000-0x8fff]
pci 0000:50:01.0: bridge 32bit mmio: [0xe8000000-0xefffffff]
pci 0000:50:01.0: bridge 64bit mmio pref: [0x806c0000000-0x806ffffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L006._PRT]
ACPI: PCI Root Bridge [L007] (0000:c2)
pci 0000:c2:00.0: PME# supported from D0 D3hot D3cold
pci 0000:c2:00.0: PME# disabled
pci 0000:c3:00.0: reg 10 64bit mmio: [0xf0000000-0xf00fffff]
pci 0000:c3:00.0: reg 18 64bit mmio: [0x80788000000-0x807887fffff]
pci 0000:c3:00.0: reg 20 64bit mmio: [0x80780000000-0x80787ffffff]
pci 0000:c2:00.0: bridge io port: [0x1000-0xffff]
pci 0000:c2:00.0: bridge 32bit mmio: [0xf0000000-0xfdffffff]
pci 0000:c2:00.0: bridge 64bit mmio pref: [0x80780000000-0x807ffffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L007._PRT]
SCSI subsystem initialized
libata version 3.00 loaded.
IOC: zx2 2.0 HPA 0xfed01000 IOVA space 1024Mb at 0x40000000
pnp: PnP ACPI init
ACPI: bus type pnp registered
GSI 24 (level, low) -> CPU 1 (0x0200) vector 49
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
NET: Registered protocol family 2
IP route cache hash table entries: 1048576 (order: 7, 8388608 bytes)
TCP established hash table entries: 524288 (order: 7, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3648kB freed
perfmon: version 2.0 IRQ 238
perfmon: Montecito PMU detected, 27 PMCs, 35 PMDs, 12 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Please use IA-32 EL for executing IA-32 binaries
HugeTLB registered 256 MB page size, pre-allocated 0 pages
msgmni has been set to 32768
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
GSI 49 (level, low) -> CPU 2 (0x0400) vector 50
pcieport-driver 0000:0f:00.0: PCI INT A -> GSI 49 (level, low) -> IRQ 50
pcieport-driver 0000:0f:00.0: found MSI capability
pci_express 0000:0f:00.0:pcie00: allocate port service
pci_express 0000:0f:00.0:pcie01: allocate port service
pci_express 0000:0f:00.0:pcie02: allocate port service
GSI 78 (level, low) -> CPU 3 (0x0600) vector 52
pcieport-driver 0000:4e:00.0: PCI INT A -> GSI 78 (level, low) -> IRQ 52
pcieport-driver 0000:4e:00.0: found MSI capability
pci_express 0000:4e:00.0:pcie00: allocate port service
pci_express 0000:4e:00.0:pcie01: allocate port service
pci_express 0000:4f:00.0:pcie13: allocate port service
pcieport-driver 0000:50:00.0: found MSI capability
pci_express 0000:50:00.0:pcie22: allocate port service
pci_express 0000:50:00.0:pcie23: allocate port service
pcieport-driver 0000:50:01.0: found MSI capability
pci_express 0000:50:01.0:pcie22: allocate port service
pci_express 0000:50:01.0:pcie23: allocate port service
pci_express 0000:51:00.0:pcie11: allocate port service
pci_express 0000:51:00.0:pcie13: allocate port service
pcieport-driver 0000:52:02.0: found MSI capability
pci_express 0000:52:02.0:pcie21: allocate port service
pci_express 0000:52:02.0:pcie23: allocate port service
pcieport-driver 0000:52:04.0: found MSI capability
pci_express 0000:52:04.0:pcie21: allocate port service
pci_express 0000:52:04.0:pcie23: allocate port service
GSI 85 (level, low) -> CPU 4 (0x0800) vector 58
pcieport-driver 0000:c2:00.0: PCI INT A -> GSI 85 (level, low) -> IRQ 58
pcieport-driver 0000:c2:00.0: found MSI capability
pci_express 0000:c2:00.0:pcie00: allocate port service
pci_express 0000:c2:00.0:pcie01: allocate port service
pci_express 0000:c2:00.0:pcie02: allocate port service
aer 0000:0f:00.0:pcie01: service driver aer loaded
aer 0000:4e:00.0:pcie01: service driver aer loaded
aer 0000:c2:00.0:pcie01: service driver aer loaded
EFI Time Services Driver v0.4
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
00:03: ttyS0 at MMIO 0xff5e2000 (irq = 49) is a 16550A
GSI 16 (level, low) -> CPU 5 (0x0a00) vector 60
serial 0000:00:01.2: PCI INT A -> GSI 16 (level, low) -> IRQ 60
0000:00:01.2: ttyS1 at MMIO 0x84033000 (irq = 60) is a 16550A
console handover: boot [uart8250] -> real [ttyS1]
brd: module loaded
HP CISS Driver (v 3.6.20)
GSI 79 (level, low) -> CPU 6 (0x0c00) vector 61
cciss 0000:89:00.0: PCI INT A -> GSI 79 (level, low) -> IRQ 61
cciss0: <0x3230> at PCI 0000:89:00.0 IRQ 64 using DAC
      blocks= 286611840 block_size= 512
      heads=255, sectors=32, cylinders=35124

      blocks= 286611840 block_size= 512
      heads=255, sectors=32, cylinders=35124

 cciss/c0d0: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d1:
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d2:
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d3: unknown partition table
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
GSI 31 (level, low) -> CPU 7 (0x0e00) vector 66
e1000 0000:01:02.0: PCI INT A -> GSI 31 (level, low) -> IRQ 66
e1000: 0000:01:02.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:15:60:04:57:2a
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 32 (level, low) -> CPU 0 (0x0000) vector 67
e1000 0000:01:02.1: PCI INT B -> GSI 32 (level, low) -> IRQ 67
e1000: 0000:01:02.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:15:60:04:57:2b
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 60 (level, low) -> CPU 1 (0x0200) vector 68
e1000 0000:48:02.0: PCI INT A -> GSI 60 (level, low) -> IRQ 68
e1000: 0000:48:02.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:1a:4b:06:64:56
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 61 (level, low) -> CPU 2 (0x0400) vector 69
e1000 0000:48:02.1: PCI INT B -> GSI 61 (level, low) -> IRQ 69
e1000: 0000:48:02.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:1a:4b:06:64:57
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide-cd driver 5.00
QLogic Fibre Channel HBA Driver: 8.02.01-k9
Emulex LightPulse Fibre Channel SCSI driver 8.2.8
Copyright(c) 2004-2008 Emulex.  All rights reserved.
lpfc 0000:10:00.0: PCI INT A -> GSI 49 (level, low) -> IRQ 50
scsi0 :  on PCI bus 10 device 00 irq 50
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
GSI 50 (level, low) -> CPU 3 (0x0600) vector 71
lpfc 0000:10:00.1: PCI INT B -> GSI 50 (level, low) -> IRQ 71
scsi1 :  on PCI bus 10 device 01 irq 71
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
Driver 'sd' needs updating - please use bus_type methods
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
Fusion MPT FC Host driver 3.04.07
Fusion MPT SAS Host driver 3.04.07
Fusion MPT misc device (ioctl) driver 3.04.07
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
mice: PS/2 mouse device common for all mice
EFI Variables Facility v0.08 2004-May-17
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 1792kB freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
GSI 19 (level, low) -> CPU 4 (0x0800) vector 73
ehci_hcd 0000:00:02.2: PCI INT C -> GSI 19 (level, low) -> IRQ 73
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: irq 73, io mem 0x84030000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
GSI 17 (level, low) -> CPU 5 (0x0a00) vector 74
ohci_hcd 0000:00:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 74
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 74, io mem 0x84032000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
GSI 18 (level, low) -> CPU 6 (0x0c00) vector 75
ohci_hcd 0000:00:02.1: PCI INT B -> GSI 18 (level, low) -> IRQ 75
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 75, io mem 0x84031000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 1-2: new high speed USB device using ehci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
usb 2-1: new full speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
udev: renamed network interface eth0 to eth6
udev: renamed network interface eth2 to eth0
udev: renamed network interface eth1 to eth7
udev: renamed network interface eth3 to eth1
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:02: registered as cooling_device1
processor ACPI_CPU:04: registered as cooling_device2
processor ACPI_CPU:06: registered as cooling_device3
processor ACPI_CPU:08: registered as cooling_device4
processor ACPI_CPU:0a: registered as cooling_device5
processor ACPI_CPU:0c: registered as cooling_device6
processor ACPI_CPU:0e: registered as cooling_device7
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (27 C)
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
input: HP Virtual Management Device as /class/input/input2
generic-usb 0003:03F0:1126.0001: input: USB HID v1.11 Keyboard [HP Virtual Management Device] on usb-0000:00:02.0-1/input0
input: HP Virtual Management Device as /class/input/input3
generic-usb 0003:03F0:1126.0002: input: USB HID v1.01 Mouse [HP Virtual Management Device] on usb-0000:00:02.0-1/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on cciss/c0d0p3, internal journal
Unable to find swap-space signature
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
hald(2677): unaligned access to 0x2000000000d00d14, ip=0x4000000000020fc1
hald(2677): unaligned access to 0x2000000000d011ec, ip=0x4000000000020fc1
hald(2677): unaligned access to 0x2000000000d01534, ip=0x4000000000020fc1
hald(2677): unaligned access to 0x2000000000d01c1c, ip=0x4000000000020fc1
hald(2677): unaligned access to 0x2000000000d020e4, ip=0x4000000000020fc1
scsi 2:0:0:0: CD-ROM            _NEC     DVD+-RW ND-6650A 1.82 PQ: 0 ANSI: 0
usb-storage: device scan complete
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg0 type 5
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX

# (e) dmesg with revert patch
[root@canola ~]# dmesg
Initializing cgroup subsys cpuset
Linux version 2.6.28-rc8-00001-g6c34bc2-dirty (achiang@bob) (gcc version 3.4.5) #6 SMP Fri Dec 12 15:52:43 MST 2008
EFI v2.00 by HP: SALsystab=0x3e528000 ACPI 2.0=0x3fdd0000 SMBIOS=0x3e52a000 HCDP=0x3fdce000
booting generic kernel on platform hpzx1
PCDP: v3 at 0x3fdce000
Early serial console at MMIO 0x84033000 (options '115200n8')
console [uart8250] enabled
ACPI: RSDP 3FDD0000, 0028 (r2     HP)
ACPI: XSDT 3FDD002C, 0114 (r1     HP   rx6600        0   HP        0)
ACPI: FACP 3FDF7818, 00F4 (r3     HP   rx6600        0   HP        0)
ACPI: DSDT 3FDD01C8, 19E62 (r1     HP   rx6600        7 INTL 20050309)
ACPI: FACS 3FDF7910, 0040
ACPI: SPCR 3FDF7950, 0050 (r1     HP                 0   HP        0)
ACPI: DBGP 3FDF79A0, 0034 (r1     HP   rx6600        0   HP        0)
ACPI: APIC 3FDF7DC0, 0178 (r1     HP   rx6600        0   HP        0)
ACPI: SPMI 3FDF79D8, 0050 (r4     HP   rx6600        0   HP        0)
ACPI: CPEP 3FDF7C90, 0034 (r1     HP   rx6600        0   HP        0)
ACPI: SSDT 3FDEA038, 04B3 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEA4F8, 22BF (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEC7B8, 1277 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEDA38, 1A37 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDEF478, 1214 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF0698, 1284 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF1928, 33D8 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF4D08, 198D (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6698, 0138 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF67D8, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF68C8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6A08, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6AF8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6C38, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6D28, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6E68, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF6F58, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF7098, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF7188, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF72C8, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF73B8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF74F8, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF75E8, 013C (r1     HP   rx6600        6 INTL 20050309)
ACPI: SSDT 3FDF7728, 00E0 (r1     HP   rx6600        6 INTL 20050309)
ACPI: Local APIC address c0000000fee00000
SMP: Allowing 16 CPUs, 8 hotplug CPUs
Initial ramdisk at: 0xe0000100fede8000 (3830319 bytes)
SAL 3.20: HP version 4.3
SAL Platform features: None
SAL: AP wakeup using external interrupt vector 0xff
ACPI: Local APIC address c0000000fee00000
GSI 25 (level, low) -> CPU 0 (0x0000) vector 48
8 CPUs available, 16 CPUs total
MCA related initialization done
Virtual mem_map starts at 0xa07fffffc7c80000
Zone PFN ranges:
  DMA      0x00000100 -> 0x00010000
  Normal   0x00010000 -> 0x01010000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000100 -> 0x00003dc3
    0: 0x00003e1a -> 0x00003e52
    0: 0x00003fc0 -> 0x00003fd5
    0: 0x00010000 -> 0x00060000
    0: 0x01004000 -> 0x0100ff1f
    0: 0x0100ff20 -> 0x01010000
On node 0 totalpages: 392463
free_area_init_node: node 0, pgdat e000000001380000, node_mem_map a07fffffc7c83800
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 15576 pages, LIFO batch:1
  Normal zone: 14336 pages used for memmap
  Normal zone: 362495 pages, LIFO batch:1
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 378071
Policy zone: Normal
Kernel command line: BOOT_IMAGE=scsi0:\EFI\redhat\vmlinuz-2.6.28-rc8-00001-g6c34bc2-dirty  rhgb root=UUID=c8c0d0b3-bf0c-4a2d-b3fd-6038792f273d selinux=0 ro
PID hash table entries: 4096 (order: 12, 32768 bytes)
CPU 0: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
Console: colour VGA+ 80x25
Memory: 25042496k/25068608k available (8557k code, 75136k reserved, 11640k data, 1792k init)
SLUB: Genslabs=17, HWalign=128, Order=0-3, MinObjects=0, CPUs=16, Nodes=1024
Calibrating delay loop... 3186.68 BogoMIPS (lpj=6373376)
Dentry cache hash table entries: 4194304 (order: 9, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 8, 16777216 bytes)
Mount-cache hash table entries: 4096
ACPI: Core revision 20080926
Boot processor id 0x0/0x0
Fixed BSP b0 value from CPU 1
CPU 1: synchronized ITC with CPU 0 (last diff -7 cycles, maxerr 159 cycles)
CPU 1: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
CPU 2: synchronized ITC with CPU 0 (last diff -7 cycles, maxerr 159 cycles)
CPU 2: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
CPU 3: synchronized ITC with CPU 0 (last diff -7 cycles, maxerr 159 cycles)
CPU 3: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
CPU 4: synchronized ITC with CPU 0 (last diff -7 cycles, maxerr 159 cycles)
CPU 4: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
CPU 5: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 159 cycles)
CPU 5: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
CPU 6: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 158 cycles)
CPU 6: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
CPU 7: synchronized ITC with CPU 0 (last diff -6 cycles, maxerr 158 cycles)
CPU 7: base freq=266.144MHz, ITC ratio=6/4, ITC freq=399.216MHz+/-150ppm
Brought up 8 CPUs
Total of 8 processors activated (25493.50 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 0 1 2 3 4 5 6 7
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU1 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 1 2 3 4 5 6 7 0
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU2 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 2 3 4 5 6 7 0 1
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU3 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 3 4 5 6 7 0 1 2
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU4 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 4 5 6 7 0 1 2 3
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU5 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 5 6 7 0 1 2 3 4
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU6 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 6 7 0 1 2 3 4 5
  domain 1: span 0-7 level NODE
   groups: 0-7
CPU7 attaching sched-domain:
 domain 0: span 0-7 level CPU
  groups: 7 0 1 2 3 4 5 6
  domain 1: span 0-7 level NODE
   groups: 0-7
net_namespace: 552 bytes
DMI 2.4 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOSAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [L000] (0000:00)
pci 0000:00:01.1: reg 14 64bit mmio: [0x84034000-0x84034fff]
pci 0000:00:01.1: reg 1c 64bit mmio: [0x80080000000-0x8008001ffff]
pci 0000:00:01.2: reg 14 64bit mmio: [0x84033000-0x84033fff]
pci 0000:00:02.0: reg 10 32bit mmio: [0x84032000-0x84032fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0x84031000-0x84031fff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.2: reg 10 32bit mmio: [0x84030000-0x840300ff]
pci 0000:00:02.2: supports D1 D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.2: PME# disabled
pci 0000:00:04.0: reg 10 32bit mmio: [0x80000000-0x83ffffff]
pci 0000:00:04.0: reg 14 io port: [0x1000-0x10ff]
pci 0000:00:04.0: reg 18 32bit mmio: [0x84020000-0x8402ffff]
pci 0000:00:04.0: reg 30 32bit mmio: [0x84000000-0x8401ffff]
pci 0000:00:04.0: Boot video device
pci 0000:00:04.0: supports D1 D2
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L000._PRT]
ACPI: PCI Root Bridge [L001] (0000:01)
pci 0000:01:02.0: reg 10 64bit mmio: [0x90120000-0x9013ffff]
pci 0000:01:02.0: reg 18 64bit mmio: [0x900c0000-0x900fffff]
pci 0000:01:02.0: reg 20 io port: [0x1040-0x107f]
pci 0000:01:02.0: reg 30 32bit mmio: [0x90080000-0x900bffff]
pci 0000:01:02.0: PME# supported from D0 D3hot
pci 0000:01:02.0: PME# disabled
pci 0000:01:02.1: reg 10 64bit mmio: [0x90100000-0x9011ffff]
pci 0000:01:02.1: reg 18 64bit mmio: [0x90040000-0x9007ffff]
pci 0000:01:02.1: reg 20 io port: [0x1000-0x103f]
pci 0000:01:02.1: reg 30 32bit mmio: [0x90000000-0x9003ffff]
pci 0000:01:02.1: PME# supported from D0 D3hot
pci 0000:01:02.1: PME# disabled
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L001._PRT]
ACPI: PCI Root Bridge [L002] (0000:0a)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L002._PRT]
ACPI: PCI Root Bridge [L003] (0000:0f)
pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:10:00.0: reg 10 64bit mmio: [0xb0083000-0xb0083fff]
pci 0000:10:00.0: reg 18 64bit mmio: [0xb0082000-0xb00820ff]
pci 0000:10:00.0: reg 20 io port: [0x1100-0x11ff]
pci 0000:10:00.0: reg 30 32bit mmio: [0xb0040000-0xb007ffff]
pci 0000:10:00.1: reg 10 64bit mmio: [0xb0081000-0xb0081fff]
pci 0000:10:00.1: reg 18 64bit mmio: [0xb0080000-0xb00800ff]
pci 0000:10:00.1: reg 20 io port: [0x1000-0x10ff]
pci 0000:10:00.1: reg 30 32bit mmio: [0xb0000000-0xb003ffff]
pci 0000:0f:00.0: bridge io port: [0x1000-0xffff]
pci 0000:0f:00.0: bridge 32bit mmio: [0xb0000000-0xbfffffff]
pci 0000:0f:00.0: bridge 64bit mmio pref: [0x80380000000-0x803ffffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L003._PRT]
ACPI: PCI Root Bridge [L004] (0000:48)
pci 0000:48:02.0: reg 10 64bit mmio: [0xc0120000-0xc013ffff]
pci 0000:48:02.0: reg 18 64bit mmio: [0xc00c0000-0xc00fffff]
pci 0000:48:02.0: reg 20 io port: [0x1040-0x107f]
pci 0000:48:02.0: reg 30 32bit mmio: [0xc0080000-0xc00bffff]
pci 0000:48:02.0: PME# supported from D0 D3hot D3cold
pci 0000:48:02.0: PME# disabled
pci 0000:48:02.1: reg 10 64bit mmio: [0xc0100000-0xc011ffff]
pci 0000:48:02.1: reg 18 64bit mmio: [0xc0040000-0xc007ffff]
pci 0000:48:02.1: reg 20 io port: [0x1000-0x103f]
pci 0000:48:02.1: reg 30 32bit mmio: [0xc0000000-0xc003ffff]
pci 0000:48:02.1: PME# supported from D0 D3hot
pci 0000:48:02.1: PME# disabled
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L004._PRT]
ACPI: PCI Root Bridge [L005] (0000:49)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L005._PRT]
ACPI: PCI Root Bridge [L006] (0000:4e)
pci 0000:4e:00.0: PME# supported from D0 D3hot D3cold
pci 0000:4e:00.0: PME# disabled
pci 0000:4f:00.0: PME# supported from D0 D3hot D3cold
pci 0000:4f:00.0: PME# disabled
pci 0000:4e:00.0: bridge io port: [0x1000-0xffff]
pci 0000:4e:00.0: bridge 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:4e:00.0: bridge 64bit mmio pref: [0x80680000000-0x806ffffffff]
pci 0000:50:00.0: PME# supported from D0 D3hot D3cold
pci 0000:50:00.0: PME# disabled
pci 0000:50:01.0: PME# supported from D0 D3hot D3cold
pci 0000:50:01.0: PME# disabled
pci 0000:4f:00.0: bridge io port: [0x1000-0xffff]
pci 0000:4f:00.0: bridge 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:4f:00.0: bridge 64bit mmio pref: [0x80680000000-0x806ffffffff]
pci 0000:51:00.0: PME# supported from D0 D3hot D3cold
pci 0000:51:00.0: PME# disabled
pci 0000:50:00.0: bridge io port: [0x9000-0xffff]
pci 0000:50:00.0: bridge 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:50:00.0: bridge 64bit mmio pref: [0x80680000000-0x806bfffffff]
pci 0000:52:02.0: PME# supported from D0 D3hot D3cold
pci 0000:52:02.0: PME# disabled
pci 0000:52:04.0: PME# supported from D0 D3hot D3cold
pci 0000:52:04.0: PME# disabled
pci 0000:51:00.0: bridge io port: [0x9000-0xffff]
pci 0000:51:00.0: bridge 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:51:00.0: bridge 64bit mmio pref: [0x80680000000-0x806bfffffff]
pci 0000:53:00.0: reg 10 32bit mmio: [0xe4820000-0xe483ffff]
pci 0000:53:00.0: reg 14 32bit mmio: [0xe4400000-0xe47fffff]
pci 0000:53:00.0: reg 18 io port: [0x9020-0x903f]
pci 0000:53:00.0: PME# supported from D0 D3hot
pci 0000:53:00.0: PME# disabled
pci 0000:53:00.1: reg 10 32bit mmio: [0xe4800000-0xe481ffff]
pci 0000:53:00.1: reg 14 32bit mmio: [0xe4000000-0xe43fffff]
pci 0000:53:00.1: reg 18 io port: [0x9000-0x901f]
pci 0000:53:00.1: PME# supported from D0 D3hot
pci 0000:53:00.1: PME# disabled
pci 0000:52:02.0: bridge io port: [0x9000-0xcfff]
pci 0000:52:02.0: bridge 32bit mmio: [0xe4000000-0xe7ffffff]
pci 0000:52:02.0: bridge 64bit mmio pref: [0x80680000000-0x8069fffffff]
pci 0000:54:00.0: reg 10 32bit mmio: [0xe0820000-0xe083ffff]
pci 0000:54:00.0: reg 14 32bit mmio: [0xe0400000-0xe07fffff]
pci 0000:54:00.0: reg 18 io port: [0xd020-0xd03f]
pci 0000:54:00.0: PME# supported from D0 D3hot
pci 0000:54:00.0: PME# disabled
pci 0000:54:00.1: reg 10 32bit mmio: [0xe0800000-0xe081ffff]
pci 0000:54:00.1: reg 14 32bit mmio: [0xe0000000-0xe03fffff]
pci 0000:54:00.1: reg 18 io port: [0xd000-0xd01f]
pci 0000:54:00.1: PME# supported from D0 D3hot
pci 0000:54:00.1: PME# disabled
pci 0000:52:04.0: bridge io port: [0xd000-0xffff]
pci 0000:52:04.0: bridge 32bit mmio: [0xe0000000-0xe3ffffff]
pci 0000:52:04.0: bridge 64bit mmio pref: [0x806a0000000-0x806bfffffff]
pci 0000:89:00.0: reg 10 64bit mmio: [0xe8000000-0xe80fffff]
pci 0000:89:00.0: reg 18 io port: [0x1000-0x10ff]
pci 0000:89:00.0: reg 1c 64bit mmio: [0xe8140000-0xe8140fff]
pci 0000:89:00.0: reg 30 32bit mmio: [0xe8100000-0xe813ffff]
pci 0000:89:00.0: supports D1
pci 0000:50:01.0: bridge io port: [0x1000-0x8fff]
pci 0000:50:01.0: bridge 32bit mmio: [0xe8000000-0xefffffff]
pci 0000:50:01.0: bridge 64bit mmio pref: [0x806c0000000-0x806ffffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L006._PRT]
ACPI: PCI Root Bridge [L007] (0000:c2)
pci 0000:c2:00.0: PME# supported from D0 D3hot D3cold
pci 0000:c2:00.0: PME# disabled
pci 0000:c3:00.0: reg 10 64bit mmio: [0xf0000000-0xf00fffff]
pci 0000:c3:00.0: reg 18 64bit mmio: [0x80788000000-0x807887fffff]
pci 0000:c3:00.0: reg 20 64bit mmio: [0x80780000000-0x80787ffffff]
pci 0000:c2:00.0: bridge io port: [0x1000-0xffff]
pci 0000:c2:00.0: bridge 32bit mmio: [0xf0000000-0xfdffffff]
pci 0000:c2:00.0: bridge 64bit mmio pref: [0x80780000000-0x807ffffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.L007._PRT]
SCSI subsystem initialized
libata version 3.00 loaded.
IOC: zx2 2.0 HPA 0xfed01000 IOVA space 1024Mb at 0x40000000
pnp: PnP ACPI init
ACPI: bus type pnp registered
GSI 24 (level, low) -> CPU 1 (0x0200) vector 49
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
NET: Registered protocol family 2
IP route cache hash table entries: 1048576 (order: 7, 8388608 bytes)
TCP established hash table entries: 524288 (order: 7, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3648kB freed
perfmon: version 2.0 IRQ 238
perfmon: Montecito PMU detected, 27 PMCs, 35 PMDs, 12 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Please use IA-32 EL for executing IA-32 binaries
HugeTLB registered 256 MB page size, pre-allocated 0 pages
msgmni has been set to 32768
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
GSI 49 (level, low) -> CPU 2 (0x0400) vector 50
pcieport-driver 0000:0f:00.0: PCI INT A -> GSI 49 (level, low) -> IRQ 50
pcieport-driver 0000:0f:00.0: found MSI capability
pci_express 0000:0f:00.0:pcie00: allocate port service
pci_express 0000:0f:00.0:pcie01: allocate port service
pci_express 0000:0f:00.0:pcie02: allocate port service
GSI 78 (level, low) -> CPU 3 (0x0600) vector 52
pcieport-driver 0000:4e:00.0: PCI INT A -> GSI 78 (level, low) -> IRQ 52
pcieport-driver 0000:4e:00.0: found MSI capability
pci_express 0000:4e:00.0:pcie00: allocate port service
pci_express 0000:4e:00.0:pcie01: allocate port service
pci_express 0000:4f:00.0:pcie13: allocate port service
pcieport-driver 0000:50:00.0: found MSI capability
pci_express 0000:50:00.0:pcie22: allocate port service
pci_express 0000:50:00.0:pcie23: allocate port service
pcieport-driver 0000:50:01.0: found MSI capability
pci_express 0000:50:01.0:pcie22: allocate port service
pci_express 0000:50:01.0:pcie23: allocate port service
pci_express 0000:51:00.0:pcie11: allocate port service
pci_express 0000:51:00.0:pcie13: allocate port service
pcieport-driver 0000:52:02.0: found MSI capability
pci_express 0000:52:02.0:pcie21: allocate port service
pci_express 0000:52:02.0:pcie23: allocate port service
pcieport-driver 0000:52:04.0: found MSI capability
pci_express 0000:52:04.0:pcie21: allocate port service
pci_express 0000:52:04.0:pcie23: allocate port service
GSI 85 (level, low) -> CPU 4 (0x0800) vector 58
pcieport-driver 0000:c2:00.0: PCI INT A -> GSI 85 (level, low) -> IRQ 58
pcieport-driver 0000:c2:00.0: found MSI capability
pci_express 0000:c2:00.0:pcie00: allocate port service
pci_express 0000:c2:00.0:pcie01: allocate port service
pci_express 0000:c2:00.0:pcie02: allocate port service
aer 0000:0f:00.0:pcie01: service driver aer loaded
aer 0000:4e:00.0:pcie01: service driver aer loaded
aer 0000:c2:00.0:pcie01: service driver aer loaded
EFI Time Services Driver v0.4
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
00:03: ttyS0 at MMIO 0xff5e2000 (irq = 49) is a 16550A
GSI 16 (level, low) -> CPU 5 (0x0a00) vector 60
serial 0000:00:01.2: PCI INT A -> GSI 16 (level, low) -> IRQ 60
0000:00:01.2: ttyS1 at MMIO 0x84033000 (irq = 60) is a 16550A
console handover: boot [uart8250] -> real [ttyS1]
brd: module loaded
HP CISS Driver (v 3.6.20)
GSI 79 (level, low) -> CPU 6 (0x0c00) vector 61
cciss 0000:89:00.0: PCI INT A -> GSI 79 (level, low) -> IRQ 61
cciss0: <0x3230> at PCI 0000:89:00.0 IRQ 64 using DAC
      blocks= 286611840 block_size= 512
      heads=255, sectors=32, cylinders=35124

      blocks= 286611840 block_size= 512
      heads=255, sectors=32, cylinders=35124

 cciss/c0d0: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d1:
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d2:
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d3: unknown partition table
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
GSI 31 (level, low) -> CPU 7 (0x0e00) vector 66
e1000 0000:01:02.0: PCI INT A -> GSI 31 (level, low) -> IRQ 66
e1000: 0000:01:02.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:15:60:04:57:2a
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 32 (level, low) -> CPU 0 (0x0000) vector 67
e1000 0000:01:02.1: PCI INT B -> GSI 32 (level, low) -> IRQ 67
e1000: 0000:01:02.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:15:60:04:57:2b
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 60 (level, low) -> CPU 1 (0x0200) vector 68
e1000 0000:48:02.0: PCI INT A -> GSI 60 (level, low) -> IRQ 68
e1000: 0000:48:02.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:1a:4b:06:64:56
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 61 (level, low) -> CPU 2 (0x0400) vector 69
e1000 0000:48:02.1: PCI INT B -> GSI 61 (level, low) -> IRQ 69
e1000: 0000:48:02.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:1a:4b:06:64:57
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide-cd driver 5.00
QLogic Fibre Channel HBA Driver: 8.02.01-k9
Emulex LightPulse Fibre Channel SCSI driver 8.2.8
Copyright(c) 2004-2008 Emulex.  All rights reserved.
lpfc 0000:10:00.0: PCI INT A -> GSI 49 (level, low) -> IRQ 50
scsi0 :  on PCI bus 10 device 00 irq 50
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.0: 0:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
GSI 50 (level, low) -> CPU 3 (0x0600) vector 71
lpfc 0000:10:00.1: PCI INT B -> GSI 50 (level, low) -> IRQ 71
scsi1 :  on PCI bus 10 device 01 irq 71
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
lpfc 0000:10:00.1: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus xffff Data: x0
Driver 'sd' needs updating - please use bus_type methods
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
Fusion MPT FC Host driver 3.04.07
Fusion MPT SAS Host driver 3.04.07
Fusion MPT misc device (ioctl) driver 3.04.07
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
mice: PS/2 mouse device common for all mice
EFI Variables Facility v0.08 2004-May-17
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 1792kB freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
GSI 19 (level, low) -> CPU 4 (0x0800) vector 73
ehci_hcd 0000:00:02.2: PCI INT C -> GSI 19 (level, low) -> IRQ 73
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: irq 73, io mem 0x84030000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
GSI 17 (level, low) -> CPU 5 (0x0a00) vector 74
ohci_hcd 0000:00:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 74
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 74, io mem 0x84032000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
GSI 18 (level, low) -> CPU 6 (0x0c00) vector 75
ohci_hcd 0000:00:02.1: PCI INT B -> GSI 18 (level, low) -> IRQ 75
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 75, io mem 0x84031000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 1-2: new high speed USB device using ehci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
usb 2-1: new full speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
udev: renamed network interface eth1 to eth7
udev: renamed network interface eth0 to eth6
udev: renamed network interface eth3_rename to eth1
udev: renamed network interface eth2_rename to eth0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:02: registered as cooling_device1
processor ACPI_CPU:04: registered as cooling_device2
processor ACPI_CPU:06: registered as cooling_device3
processor ACPI_CPU:08: registered as cooling_device4
processor ACPI_CPU:0a: registered as cooling_device5
processor ACPI_CPU:0c: registered as cooling_device6
processor ACPI_CPU:0e: registered as cooling_device7
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (27 C)
input: HP Virtual Management Device as /class/input/input2
generic-usb 0003:03F0:1126.0001: input: USB HID v1.11 Keyboard [HP Virtual Management Device] on usb-0000:00:02.0-1/input0
input: HP Virtual Management Device as /class/input/input3
generic-usb 0003:03F0:1126.0002: input: USB HID v1.01 Mouse [HP Virtual Management Device] on usb-0000:00:02.0-1/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on cciss/c0d0p3, internal journal
Unable to find swap-space signature
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
hald(2684): unaligned access to 0x2000000000d00d14, ip=0x4000000000020fc1
hald(2684): unaligned access to 0x2000000000d011ec, ip=0x4000000000020fc1
hald(2684): unaligned access to 0x2000000000d01534, ip=0x4000000000020fc1
hald(2684): unaligned access to 0x2000000000d01c1c, ip=0x4000000000020fc1
hald(2684): unaligned access to 0x2000000000d020e4, ip=0x4000000000020fc1
scsi 2:0:0:0: CD-ROM            _NEC     DVD+-RW ND-6650A 1.82 PQ: 0 ANSI: 0
usb-storage: device scan complete
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg0 type 5
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX

# (f) lspci -vv output
[root@canola ~]# lspci -vv
00:01.0 Class ff00: Hewlett-Packard Company RMP-3 (Remote Management Processor)
	Subsystem: Hewlett-Packard Company RMP-3 (Remote Management Processor)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000

00:01.1 Communication controller: Hewlett-Packard Company RMP-3 Shared Memory Driver
	Subsystem: Hewlett-Packard Company RMP-3 Shared Memory Driver
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 1: Memory at 84034000 (64-bit, non-prefetchable) [size=4K]
	Region 3: Memory at 80080000000 (64-bit, prefetchable) [size=128K]
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 0000000000000000  Data: 0000

00:01.2 Serial controller: Hewlett-Packard Company Diva Serial [GSP] Multiport UART (prog-if 02 [16550])
	Subsystem: Hewlett-Packard Company Diva RMP3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 60
	Region 1: Memory at 84033000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: serial

00:02.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: Unknown device 03f0:0226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns min, 10500ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 74
	Region 0: Memory at 84032000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: Unknown device 03f0:0226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (250ns min, 10500ns max), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 75
	Region 0: Memory at 84031000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Unknown device 03f0:0326
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
	Interrupt: pin C routed to IRQ 73
	Region 0: Memory at 84030000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:04.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Radeon 7000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (2000ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at 80000000 (32-bit, prefetchable) [size=64M]
	Region 1: I/O ports at 1001000 [size=256]
	Region 2: Memory at 84020000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at 84000000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 66
	Region 0: Memory at 90120000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at 900c0000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 2001040 [size=64]
	Expansion ROM at 90080000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=01:02.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

01:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 67
	Region 0: Memory at 90100000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at 90040000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 2001000 [size=64]
	Expansion ROM at 90000000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=01:02.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

0f:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=0f, secondary=10, subordinate=47, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: b0000000-bfffffff
	Prefetchable memory behind bridge: 0000080380000000-00000803ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4033
	Capabilities: [60] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  6, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Vendor Specific Information <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

10:00.0 Fibre Channel: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter (rev 02)
	Subsystem: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 70
	Region 0: Memory at b0083000 (64-bit, non-prefetchable) [size=4K]
	Region 2: Memory at b0082000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 4001100 [size=256]
	Expansion ROM at b0040000 [disabled] [size=256K]
	Capabilities: [58] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable+
		Address: 00000000fee00000  Data: 4046
	Capabilities: [44] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <4us, L1 <16us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Power Budgeting <?>
	Kernel driver in use: lpfc

10:00.1 Fibre Channel: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter (rev 02)
	Subsystem: Emulex Corporation Zephyr-X LightPulse Fibre Channel Host Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 72
	Region 0: Memory at b0081000 (64-bit, non-prefetchable) [size=4K]
	Region 2: Memory at b0080000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 4001000 [size=256]
	Expansion ROM at b0000000 [disabled] [size=256K]
	Capabilities: [58] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable+
		Address: 00000000fee00000  Data: 4048
	Capabilities: [44] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <4us, L1 <16us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [12c] Power Budgeting <?>
	Kernel driver in use: lpfc

48:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 68
	Region 0: Memory at c0120000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at c00c0000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 5001040 [size=64]
	Expansion ROM at c0080000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=48:02.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

48:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 69
	Region 0: Memory at c0100000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at c0040000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 5001000 [size=64]
	Expansion ROM at c0000000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=48:02.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: e1000

4e:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=4e, secondary=4f, subordinate=c1, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: e0000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4035
	Capabilities: [60] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Vendor Specific Information <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

4f:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=4f, secondary=50, subordinate=c1, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: e0000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Upstream Port, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-SlotPowerLimit 0.000000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

50:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=50, secondary=51, subordinate=88, sec-latency=0
	I/O behind bridge: 00009000-0000ffff
	Memory behind bridge: e0000000-e7ffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  4, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt+ HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4036
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

50:01.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=50, secondary=89, subordinate=c1, sec-latency=0
	I/O behind bridge: 00001000-00008fff
	Memory behind bridge: e8000000-efffffff
	Prefetchable memory behind bridge: 00000806c0000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  3, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt+ HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4037
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

51:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=51, secondary=52, subordinate=54, sec-latency=0
	I/O behind bridge: 00009000-0000ffff
	Memory behind bridge: e0000000-e7ffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Upstream Port, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 25.000000W
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

52:02.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=52, secondary=53, subordinate=53, sec-latency=0
	I/O behind bridge: 00009000-0000cfff
	Memory behind bridge: e4000000-e7ffffff
	Prefetchable memory behind bridge: 0000080680000000-000008069fffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4038
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

52:04.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=52, secondary=54, subordinate=54, sec-latency=0
	I/O behind bridge: 0000d000-0000ffff
	Memory behind bridge: e0000000-e3ffffff
	Prefetchable memory behind bridge: 00000806a0000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4039
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

53:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 0
	Region 0: Memory at e4820000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e4400000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 7009020 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number e8-03-47-ff-ff-c4-1c-00

53:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at e4800000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e4000000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 7009000 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number e8-03-47-ff-ff-c4-1c-00

54:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 0
	Region 0: Memory at e0820000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e0400000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 700d020 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number ea-03-47-ff-ff-c4-1c-00

54:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port Gigabit Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at e0800000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 700d000 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number ea-03-47-ff-ff-c4-1c-00

89:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Controller (rev 03)
	Subsystem: Hewlett-Packard Company P400 SAS Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 61
	Region 0: Memory at e8000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at 7001000 [size=256]
	Region 3: Memory at e8140000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at e8100000 [disabled] [size=256K]
	Capabilities: [b0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 2048 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [d4] MSI-X: Enable+ Mask- TabSize=4
		Vector table: BAR=0 offset=000fe000
		PBA: BAR=0 offset=000ff000
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [ec] Vital Product Data <?>
	Capabilities: [100] Power Budgeting <?>
	Kernel driver in use: cciss

c2:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=c2, secondary=c3, subordinate=fb, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: f0000000-fdffffff
	Prefetchable memory behind bridge: 0000080780000000-00000807ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 403b
	Capabilities: [60] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Suprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surpise-
			Slot #  5, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL+ PresDet+ CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Vendor Specific Information <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

c3:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex (Tavor compatibility mode) (rev a0)
	Subsystem: Mellanox Technologies MT25208 InfiniHost III Ex (Tavor compatibility mode)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at 80788000000 (64-bit, prefetchable) [size=8M]
	Region 4: Memory at 80780000000 (64-bit, prefetchable) [size=128M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Vital Product Data <?>
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [84] MSI-X: Enable- Mask- TabSize=32
		Vector table: BAR=0 offset=00082000
		PBA: BAR=0 offset=00082200
	Capabilities: [60] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #8, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-

# (g) the revert patch I used

diff --git a/kernel/resource.c b/kernel/resource.c
index 4337063..628535a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -369,32 +369,37 @@ EXPORT_SYMBOL(allocate_resource);
  */
 static struct resource * __insert_resource(struct resource *parent, struct resource *new)
 {
+	int result;
 	struct resource *first, *next;
 
-	for (;; parent = first) {
-		first = __request_resource(parent, new);
-		if (!first)
-			return first;
+ begin:
+ 	result = 0;
+	first = __request_resource(parent, new);
+	if (!first)
+		goto out;
 
-		if (first == parent)
-			return first;
+	result = -EBUSY;
+	if (first == parent)
+		goto out;
 
-		if ((first->start > new->start) || (first->end < new->end))
-			break;
-		if ((first->start == new->start) && (first->end == new->end))
-			break;
+	/* Resource fully contained by the clashing resource? Recurse into it */
+	if (first->start <= new->start && first->end >= new->end) {
+		parent = first;
+		goto begin;
 	}
 
 	for (next = first; ; next = next->sibling) {
 		/* Partial overlap? Bad, and unfixable */
 		if (next->start < new->start || next->end > new->end)
-			return next;
+			goto out;
 		if (!next->sibling)
 			break;
 		if (next->sibling->start > new->end)
 			break;
 	}
 
+	result = 0;
+
 	new->parent = parent;
 	new->sibling = next->sibling;
 	new->child = first;
@@ -411,7 +416,9 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 			next = next->sibling;
 		next->sibling = new;
 	}
-	return NULL;
+
+ out:
+	return result;
 }
 
 /**
