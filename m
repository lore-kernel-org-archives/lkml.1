Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZCKWKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZCKWKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZCKWJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:09:54 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:58181 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbZCKWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:09:47 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of is_linear_pfn_mapping
Date: Wed, 11 Mar 2009 23:09:38 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, thellstrom@vmware.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha,Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>, ebiederm@xmission.com
References: <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org> <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com> <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com> <20090310013953.GA11312@linux-os.sc.intel.com> <49B6232B.4050503@vmware.com> <1236706959.4529.56.camel@localhost.localdomain> <49B781B6.3060704@vmware.com> <20090311093338.GC12814@elte.hu> <20090311093338.GC12814@elte.hu> <20090311175452.GA1702@linux-os.sc.intel.com>
In-reply-To: <20090311175452.GA1702@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kaDuJjF3plyPMN+"
Message-Id: <200903112309.40145.elendil@planet.nl>
X-OriginalArrivalTime: 11 Mar 2009 22:09:40.0837 (UTC) FILETIME=[133DA150:01C9A296]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kaDuJjF3plyPMN+
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Pallipadi, Venkatesh wrote:
> Use of vma->vm_pgoff to identify the pfnmaps that are fully
> mapped at mmap time is broke. vm_pgoff is set by generic mmap
> code even for cases where drivers are setting up the mappings
> at the fault time.
>=20
> The problem was originally reported here.
> http://marc.info/?l=3Dlinux-kernel&m=3D123383810628583&w=3D2
>=20
> Change is_linear_pfn_mapping logic to overload VM_NONLINEAR
> flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
> time.
>=20
> Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha>@intel.com>

I've applied this patch on top of v2.6.29-rc7-143-g99adcd9 [1] and since=20
then I've had my system, or rather X/KDE, hang several times. The last=20
time the problem seems to have been KDE's kicker. I was running a kernel=20
compile in a konsole window and that just continued and finished, but the=20
keyboard was completely dead.
I could still ssh in from another box. 'ps' would show the top processes,=20
but hang as well at some point (in the middle of listing KDE processes.

The hang was with pat enabled. I've now booted with nopat.

The log shows (full log attached):
kernel: BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
kernel: IP: [<ffffffff80322504>] prio_tree_remove+0x9c/0xcc
kernel: PGD 7cab1067 PUD 7d644067 PMD 0
kernel: Oops: 0000 [#1] SMP
kernel: last sysfs file: /sys/class/power_supply/C23D/charge_full
kernel: CPU 1
kernel: Pid: 5415, comm: kicker Not tainted 2.6.29-rc7 #4 HP Comp
aq 2510p Notebook PC
kernel: RIP: 0010:[<ffffffff80322504>]  [<ffffffff80322504>] prio
_tree_remove+0x9c/0xcc
[...]
kernel: Call Trace:
kernel:  [<ffffffff803225df>] prio_tree_insert+0xab/0x22a
kernel:  [<ffffffff8027e90d>] vma_prio_tree_insert+0x23/0xc2
kernel:  [<ffffffff802864af>] __vma_link_file+0x70/0x72
kernel:  [<ffffffff80286c15>] vma_link+0x7d/0xab
kernel:  [<ffffffff802881ea>] mmap_region+0x313/0x479
kernel:  [<ffffffff80288646>] do_mmap_pgoff+0x2f6/0x35c
kernel:  [<ffffffff802ea99a>] do_shmat+0x28a/0x36c
kernel:  [<ffffffff802eaa8d>] sys_shmat+0x11/0x1c
kernel:  [<ffffffff8020c25b>] system_call_fastpath+0x16/0x1b

=46rom the symptoms I strongly suspect this patch to be the culprit.

Cheers,
=46JP

[1] Together with some other patches (mainly Rafael's latest patchset=20
for "Rework disabling of interrupts during suspend-resume"), but I doubt=20
any of those are related to this issue.


--Boundary-00=_kaDuJjF3plyPMN+
Content-Type: text/x-log;
  charset="us-ascii";
  name="kern.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="kern.log"

Mar 11 21:20:55 aragorn kernel: Linux version 2.6.29-rc7 (root@aragorn) (gc=
c version 4.3.2 (Debian 4.3.2-1.1) ) #4 SMP Wed Mar 11 20:34:20 CET 2009
Mar 11 21:20:55 aragorn kernel: Command line: root=3D/dev/mapper/main-root =
ro vga=3D791 quiet
Mar 11 21:20:55 aragorn kernel: KERNEL supported cpus:
Mar 11 21:20:55 aragorn kernel:   Intel GenuineIntel
Mar 11 21:20:55 aragorn kernel:   AMD AuthenticAMD
Mar 11 21:20:55 aragorn kernel:   Centaur CentaurHauls
Mar 11 21:20:55 aragorn kernel: BIOS-provided physical RAM map:
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 0000000000000000 - 000000000009=
fc00 (usable)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 000000000009fc00 - 00000000000a=
0000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000000e0000 - 000000000010=
0000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 0000000000100000 - 000000007e7b=
0000 (usable)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 000000007e7b0000 - 000000007e7c=
5400 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 000000007e7c5400 - 000000007e7e=
7fb8 (ACPI NVS)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 000000007e7e7fb8 - 000000007f00=
0000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000fec00000 - 00000000fec0=
1000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000fed20000 - 00000000fed9=
a000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000feda0000 - 00000000fedc=
0000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000fee00000 - 00000000fee0=
1000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000ffb00000 - 00000000ffc0=
0000 (reserved)
Mar 11 21:20:55 aragorn kernel:  BIOS-e820: 00000000fff00000 - 000000010000=
0000 (reserved)
Mar 11 21:20:55 aragorn kernel: DMI 2.4 present.
Mar 11 21:20:55 aragorn kernel: last_pfn =3D 0x7e7b0 max_arch_pfn =3D 0x100=
000000
Mar 11 21:20:55 aragorn kernel: x86 PAT enabled: cpu 0, old 0x7040600070406=
, new 0x7010600070106
Mar 11 21:20:55 aragorn kernel: init_memory_mapping: 0000000000000000-00000=
0007e7b0000
Mar 11 21:20:55 aragorn kernel:  0000000000 - 007e600000 page 2M
Mar 11 21:20:55 aragorn kernel:  007e600000 - 007e7b0000 page 4k
Mar 11 21:20:55 aragorn kernel: kernel direct mapping tables up to 7e7b0000=
 @ 8000-c000
Mar 11 21:20:55 aragorn kernel: last_map_addr: 7e7b0000 end: 7e7b0000
Mar 11 21:20:55 aragorn kernel: RAMDISK: 37a6c000 - 37fef591
Mar 11 21:20:55 aragorn kernel: ACPI: RSDP 000F7960, 0024 (r2 HP    )
Mar 11 21:20:55 aragorn kernel: ACPI: XSDT 7E7C81C8, 007C (r1 HPQOEM SLIC-M=
PC        1 HP          1)
Mar 11 21:20:55 aragorn kernel: ACPI: FACP 7E7C8084, 00F4 (r4 HP     30C9  =
          3 HP          1)
Mar 11 21:20:55 aragorn kernel: FADT: X_PM1a_EVT_BLK.bit_width (16) does no=
t match PM1_EVT_LEN (4)
Mar 11 21:20:55 aragorn kernel: ACPI: DSDT 7E7C8538, 13484 (r1 HP       nc2=
500    10000 MSFT  3000001)
Mar 11 21:20:55 aragorn kernel: ACPI: FACS 7E7E7D80, 0040
Mar 11 21:20:55 aragorn kernel: ACPI: SLIC 7E7C8244, 0176 (r1 HPQOEM SLIC-M=
PC        1 HP          1)
Mar 11 21:20:55 aragorn kernel: ACPI: HPET 7E7C83BC, 0038 (r1 HP     30C9  =
          1 HP          1)
Mar 11 21:20:55 aragorn kernel: ACPI: APIC 7E7C83F4, 0068 (r1 HP     30C9  =
          1 HP          1)
Mar 11 21:20:55 aragorn kernel: ACPI: MCFG 7E7C845C, 003C (r1 HP     30C9  =
          1 HP          1)
Mar 11 21:20:55 aragorn kernel: ACPI: TCPA 7E7C8498, 0032 (r2 HP     30C9  =
          1 HP          1)
Mar 11 21:20:55 aragorn kernel: ACPI: ASF! 7E7C84CC, 0069 (r16 HP     CHIMA=
YU         1 HP          0)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DB9BC, 02BE (r1 HP       HPQP=
AT        1 MSFT  3000001)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DC640, 025F (r1 HP      Cpu0T=
st     3000 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DC89F, 00A6 (r1 HP      Cpu1T=
st     3000 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DC945, 04D7 (r1 HP        Cpu=
Pm     3000 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: ACPI: Local APIC address 0xfee00000
Mar 11 21:20:55 aragorn kernel: (6 early reservations) =3D=3D> bootmem [000=
0000000 - 007e7b0000]
Mar 11 21:20:55 aragorn kernel:   #0 [0000000000 - 0000001000]   BIOS data =
page =3D=3D> [0000000000 - 0000001000]
Mar 11 21:20:55 aragorn kernel:   #1 [0000006000 - 0000008000]       TRAMPO=
LINE =3D=3D> [0000006000 - 0000008000]
Mar 11 21:20:55 aragorn kernel:   #2 [0000200000 - 000075a620]    TEXT DATA=
 BSS =3D=3D> [0000200000 - 000075a620]
Mar 11 21:20:55 aragorn kernel:   #3 [0037a6c000 - 0037fef591]          RAM=
DISK =3D=3D> [0037a6c000 - 0037fef591]
Mar 11 21:20:55 aragorn kernel:   #4 [000009fc00 - 0000100000]    BIOS rese=
rved =3D=3D> [000009fc00 - 0000100000]
Mar 11 21:20:55 aragorn kernel:   #5 [0000008000 - 000000a000]          PGT=
ABLE =3D=3D> [0000008000 - 000000a000]
Mar 11 21:20:55 aragorn kernel:  [ffffe20000000000-ffffe20001ffffff] PMD ->=
 [ffff880001200000-ffff8800031fffff] on node 0
Mar 11 21:20:55 aragorn kernel: Zone PFN ranges:
Mar 11 21:20:55 aragorn kernel:   DMA      0x00000000 -> 0x00001000
Mar 11 21:20:55 aragorn kernel:   DMA32    0x00001000 -> 0x00100000
Mar 11 21:20:55 aragorn kernel:   Normal   0x00100000 -> 0x00100000
Mar 11 21:20:55 aragorn kernel: Movable zone start PFN for each node
Mar 11 21:20:55 aragorn kernel: early_node_map[2] active PFN ranges
Mar 11 21:20:55 aragorn kernel:     0: 0x00000000 -> 0x0000009f
Mar 11 21:20:55 aragorn kernel:     0: 0x00000100 -> 0x0007e7b0
Mar 11 21:20:55 aragorn kernel: On node 0 totalpages: 517967
Mar 11 21:20:55 aragorn kernel:   DMA zone: 64 pages used for memmap
Mar 11 21:20:55 aragorn kernel:   DMA zone: 1471 pages reserved
Mar 11 21:20:55 aragorn kernel:   DMA zone: 2464 pages, LIFO batch:0
Mar 11 21:20:55 aragorn kernel:   DMA32 zone: 8031 pages used for memmap
Mar 11 21:20:55 aragorn kernel:   DMA32 zone: 505937 pages, LIFO batch:31
Mar 11 21:20:55 aragorn kernel: ACPI: PM-Timer IO Port: 0x1008
Mar 11 21:20:55 aragorn kernel: ACPI: Local APIC address 0xfee00000
Mar 11 21:20:55 aragorn kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] e=
nabled)
Mar 11 21:20:55 aragorn kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] e=
nabled)
Mar 11 21:20:55 aragorn kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge li=
nt[0x1])
Mar 11 21:20:55 aragorn kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge li=
nt[0x1])
Mar 11 21:20:55 aragorn kernel: ACPI: IOAPIC (id[0x01] address[0xfec00000] =
gsi_base[0])
Mar 11 21:20:55 aragorn kernel: IOAPIC[0]: apic_id 1, version 0, address 0x=
fec00000, GSI 0-23
Mar 11 21:20:55 aragorn kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_i=
rq 2 dfl dfl)
Mar 11 21:20:55 aragorn kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_i=
rq 9 high level)
Mar 11 21:20:55 aragorn kernel: ACPI: IRQ0 used by override.
Mar 11 21:20:55 aragorn kernel: ACPI: IRQ2 used by override.
Mar 11 21:20:55 aragorn kernel: ACPI: IRQ9 used by override.
Mar 11 21:20:55 aragorn kernel: Using ACPI (MADT) for SMP configuration inf=
ormation
Mar 11 21:20:55 aragorn kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Mar 11 21:20:55 aragorn kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
Mar 11 21:20:55 aragorn kernel: nr_irqs_gsi: 24
Mar 11 21:20:55 aragorn kernel: PM: Registered nosave memory: 000000000009f=
000 - 00000000000a0000
Mar 11 21:20:55 aragorn kernel: PM: Registered nosave memory: 00000000000a0=
000 - 00000000000e0000
Mar 11 21:20:55 aragorn kernel: PM: Registered nosave memory: 00000000000e0=
000 - 0000000000100000
Mar 11 21:20:55 aragorn kernel: Allocating PCI resources starting at 800000=
00 (gap: 7f000000:7fc00000)
Mar 11 21:20:55 aragorn kernel: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr=
_node_ids:1
Mar 11 21:20:55 aragorn kernel: PERCPU: Allocating 49152 bytes of per cpu d=
ata
Mar 11 21:20:55 aragorn kernel: Built 1 zonelists in Zone order, mobility g=
rouping on.  Total pages: 508401
Mar 11 21:20:55 aragorn kernel: Kernel command line: root=3D/dev/mapper/mai=
n-root ro vga=3D791 quiet
Mar 11 21:20:55 aragorn kernel: Initializing CPU#0
Mar 11 21:20:55 aragorn kernel: PID hash table entries: 4096 (order: 12, 32=
768 bytes)
Mar 11 21:20:55 aragorn kernel: Extended CMOS year: 2000
Mar 11 21:20:55 aragorn kernel: Fast TSC calibration using PIT
Mar 11 21:20:55 aragorn kernel: Detected 1329.802 MHz processor.
Mar 11 21:20:55 aragorn kernel: Console: colour dummy device 80x25
Mar 11 21:20:55 aragorn kernel: console [tty0] enabled
Mar 11 21:20:55 aragorn kernel: Dentry cache hash table entries: 262144 (or=
der: 9, 2097152 bytes)
Mar 11 21:20:55 aragorn kernel: Inode-cache hash table entries: 131072 (ord=
er: 8, 1048576 bytes)
Mar 11 21:20:55 aragorn kernel: Checking aperture...
Mar 11 21:20:55 aragorn kernel: No AGP bridge found
Mar 11 21:20:55 aragorn kernel: Memory: 2023916k/2072256k available (2347k =
kernel code, 388k absent, 47252k reserved, 1523k data, 312k init)
Mar 11 21:20:55 aragorn kernel: SLUB: Genslabs=3D12, HWalign=3D64, Order=3D=
0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Mar 11 21:20:55 aragorn kernel: hpet clockevent registered
Mar 11 21:20:55 aragorn kernel: HPET: 3 timers in total, 0 timers will be u=
sed for per-cpu timer
Mar 11 21:20:55 aragorn kernel: Calibrating delay loop (skipped), value cal=
culated using timer frequency.. 2659.60 BogoMIPS (lpj=3D5319208)
Mar 11 21:20:55 aragorn kernel: Security Framework initialized
Mar 11 21:20:55 aragorn kernel: SELinux:  Disabled at boot.
Mar 11 21:20:55 aragorn kernel: Mount-cache hash table entries: 256
Mar 11 21:20:55 aragorn kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar 11 21:20:55 aragorn kernel: CPU: L2 cache: 2048K
Mar 11 21:20:55 aragorn kernel: [ds] using Core 2/Atom configuration
Mar 11 21:20:55 aragorn kernel: CPU: Physical Processor ID: 0
Mar 11 21:20:55 aragorn kernel: CPU: Processor Core ID: 0
Mar 11 21:20:55 aragorn kernel: CPU0: Thermal monitoring handled by SMI
Mar 11 21:20:55 aragorn kernel: using mwait in idle threads.
Mar 11 21:20:55 aragorn kernel: ACPI: Core revision 20081204
Mar 11 21:20:55 aragorn kernel: Setting APIC routing to flat
Mar 11 21:20:55 aragorn kernel: ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 a=
pic2=3D-1 pin2=3D-1
Mar 11 21:20:55 aragorn kernel: CPU0: Intel(R) Core(TM)2 Duo CPU     U7700 =
 @ 1.33GHz stepping 0d
Mar 11 21:20:55 aragorn kernel: Booting processor 1 APIC 0x1 ip 0x6000
Mar 11 21:20:55 aragorn kernel: Initializing CPU#1
Mar 11 21:20:55 aragorn kernel: Calibrating delay using timer specific rout=
ine.. 2659.96 BogoMIPS (lpj=3D5319936)
Mar 11 21:20:55 aragorn kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar 11 21:20:55 aragorn kernel: CPU: L2 cache: 2048K
Mar 11 21:20:55 aragorn kernel: [ds] using Core 2/Atom configuration
Mar 11 21:20:55 aragorn kernel: CPU: Physical Processor ID: 0
Mar 11 21:20:55 aragorn kernel: CPU: Processor Core ID: 1
Mar 11 21:20:55 aragorn kernel: CPU1: Thermal monitoring enabled (TM2)
Mar 11 21:20:55 aragorn kernel: x86 PAT enabled: cpu 1, old 0x7040600070406=
, new 0x7010600070106
Mar 11 21:20:55 aragorn kernel: CPU1: Intel(R) Core(TM)2 Duo CPU     U7700 =
 @ 1.33GHz stepping 0d
Mar 11 21:20:55 aragorn kernel: checking TSC synchronization [CPU#0 -> CPU#=
1]: passed.
Mar 11 21:20:55 aragorn kernel: Brought up 2 CPUs
Mar 11 21:20:55 aragorn kernel: Total of 2 processors activated (5319.57 Bo=
goMIPS).
Mar 11 21:20:55 aragorn kernel: CPU0 attaching sched-domain:
Mar 11 21:20:55 aragorn kernel:  domain 0: span 0-1 level MC
Mar 11 21:20:55 aragorn kernel:   groups: 0 1
Mar 11 21:20:55 aragorn kernel: CPU1 attaching sched-domain:
Mar 11 21:20:55 aragorn kernel:  domain 0: span 0-1 level MC
Mar 11 21:20:55 aragorn kernel:   groups: 1 0
Mar 11 21:20:55 aragorn kernel: net_namespace: 1856 bytes
Mar 11 21:20:55 aragorn kernel: NET: Registered protocol family 16
Mar 11 21:20:55 aragorn kernel: ACPI FADT declares the system doesn't suppo=
rt PCIe ASPM, so disable it
Mar 11 21:20:55 aragorn kernel: ACPI: bus type pci registered
Mar 11 21:20:55 aragorn kernel: PCI: MCFG configuration 0: base f8000000 se=
gment 0 buses 0 - 63
Mar 11 21:20:55 aragorn kernel: PCI: Not using MMCONFIG.
Mar 11 21:20:55 aragorn kernel: PCI: Using configuration type 1 for base ac=
cess
Mar 11 21:20:55 aragorn kernel: bio: create slab <bio-0> at 0
Mar 11 21:20:55 aragorn kernel: ACPI: EC: Enabling special treatment for EC=
 from MSI.
Mar 11 21:20:55 aragorn kernel: ACPI: EC: Look up EC in DSDT
Mar 11 21:20:55 aragorn kernel: ACPI: EC: non-query interrupt received, swi=
tching to interrupt mode
Mar 11 21:20:55 aragorn kernel: ACPI: Interpreter enabled
Mar 11 21:20:55 aragorn kernel: ACPI: (supports S0 S3 S4 S5)
Mar 11 21:20:55 aragorn kernel: ACPI: Using IOAPIC for interrupt routing
Mar 11 21:20:55 aragorn kernel: PCI: MCFG configuration 0: base f8000000 se=
gment 0 buses 0 - 63
Mar 11 21:20:55 aragorn kernel: PCI: MCFG area at f8000000 reserved in ACPI=
 motherboard resources
Mar 11 21:20:55 aragorn kernel: PCI: Using MMCONFIG at f8000000 - fbffffff
Mar 11 21:20:55 aragorn kernel: ACPI: EC: GPE =3D 0x16, I/O: command/status=
 =3D 0x66, data =3D 0x62
Mar 11 21:20:55 aragorn kernel: ACPI: EC: driver started in interrupt mode
Mar 11 21:20:55 aragorn kernel: ACPI: No dock devices found.
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Root Bridge [C003] (0000:00)
Mar 11 21:20:55 aragorn kernel: pci 0000:00:02.0: reg 10 64bit mmio: [0xe04=
00000-0xe04fffff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:02.0: reg 18 64bit mmio: [0xd00=
00000-0xdfffffff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:02.0: reg 20 io port: [0x2000-0=
x2007]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:02.1: reg 10 64bit mmio: [0xe05=
00000-0xe05fffff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.0: reg 10 64bit mmio: [0xe06=
00000-0xe060000f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.0: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.0: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.2: reg 10 io port: [0x2008-0=
x200f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.2: reg 14 io port: [0x2010-0=
x2013]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.2: reg 18 io port: [0x2018-0=
x201f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.2: reg 1c io port: [0x2020-0=
x2023]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.2: reg 20 io port: [0x2030-0=
x203f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.3: reg 10 io port: [0x2040-0=
x2047]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:03.3: reg 14 32bit mmio: [0xe06=
01000-0xe0601fff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:19.0: reg 10 32bit mmio: [0xe06=
20000-0xe063ffff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:19.0: reg 14 32bit mmio: [0xe06=
40000-0xe0640fff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:19.0: reg 18 io port: [0x2060-0=
x207f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:19.0: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:19.0: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1a.0: reg 20 io port: [0x2080-0=
x209f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1a.1: reg 20 io port: [0x20a0-0=
x20bf]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1a.7: reg 10 32bit mmio: [0xe06=
41000-0xe06413ff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1a.7: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1a.7: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1b.0: reg 10 64bit mmio: [0xe06=
44000-0xe0647fff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1b.0: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1b.0: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1d.0: reg 20 io port: [0x20c0-0=
x20df]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1d.1: reg 20 io port: [0x20e0-0=
x20ff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1d.2: reg 20 io port: [0x2100-0=
x211f]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1d.7: reg 10 32bit mmio: [0xe06=
48000-0xe06483ff]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1d.7: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1d.7: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.0: quirk: region 1000-107f c=
laimed by ICH6 ACPI/GPIO/TCO
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.0: quirk: region 1100-113f c=
laimed by ICH6 GPIO
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decod=
e 1 PIO at 0500 (mask 007f)
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decod=
e 4 PIO at 02e8 (mask 0007)
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.1: reg 10 io port: [0x00-0x0=
7]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.1: reg 14 io port: [0x00-0x0=
3]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.1: reg 18 io port: [0x00-0x0=
7]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.1: reg 1c io port: [0x00-0x0=
3]
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1f.1: reg 20 io port: [0x2120-0=
x212f]
Mar 11 21:20:55 aragorn kernel: pci 0000:10:00.0: reg 10 64bit mmio: [0xe00=
00000-0xe0001fff]
Mar 11 21:20:55 aragorn kernel: pci 0000:10:00.0: PME# supported from D0 D3=
hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:10:00.0: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1: bridge 32bit mmio: [0xe00=
00000-0xe00fffff]
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0: reg 10 32bit mmio: [0xe01=
00000-0xe0100fff]
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0: supports D1 D2
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0: PME# supported from D0 D1=
 D2 D3hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.1: reg 10 32bit mmio: [0xe01=
01000-0xe01017ff]
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.1: supports D1 D2
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.1: PME# supported from D0 D1=
 D2 D3hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.1: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.2: reg 10 32bit mmio: [0xe01=
02000-0xe01020ff]
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.2: supports D1 D2
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.2: PME# supported from D0 D1=
 D2 D3hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.2: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.3: reg 10 32bit mmio: [0xe01=
03000-0xe01030ff]
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.3: supports D1 D2
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.3: PME# supported from D0 D1=
 D2 D3hot D3cold
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.3: PME# disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0: transparent bridge
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0: bridge 32bit mmio: [0xe01=
00000-0xe03fffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:00: on NUMA node 0
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C0=
03._PRT]
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C0=
03.C0B2._PRT]
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C0=
03.C11F._PRT]
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C0=
03.C133._PRT]
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C12F] (IRQs *10 1=
1)
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C130] (IRQs *10 1=
1)
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C131] (IRQs 10 *1=
1)
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C132] (IRQs 10 11=
) *5
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C142] (IRQs *10 1=
1)
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C143] (IRQs 10 11=
) *0, disabled.
Mar 11 21:20:55 aragorn kernel: ACPI: PCI Interrupt Link [C144] (IRQs 10 *1=
1)
Mar 11 21:20:55 aragorn kernel: ACPI Exception (pci_link-0189): AE_NOT_FOUN=
D, Evaluating _PRS [20081204]
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C29F] (on)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C1C7] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3AD] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3B0] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3C3] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3C4] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3C5] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3C6] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: Power Resource [C3C7] (off)
Mar 11 21:20:55 aragorn kernel: usbcore: registered new interface driver us=
bfs
Mar 11 21:20:55 aragorn kernel: usbcore: registered new interface driver hub
Mar 11 21:20:55 aragorn kernel: usbcore: registered new device driver usb
Mar 11 21:20:55 aragorn kernel: PCI: Using ACPI for IRQ routing
Mar 11 21:20:55 aragorn kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Mar 11 21:20:55 aragorn kernel: hpet0: 3 comparators, 64-bit 14.318180 MHz =
counter
Mar 11 21:20:55 aragorn kernel: pnp: PnP ACPI init
Mar 11 21:20:55 aragorn kernel: ACPI: bus type pnp registered
Mar 11 21:20:55 aragorn kernel: pnp: PnP ACPI: found 14 devices
Mar 11 21:20:55 aragorn kernel: ACPI: ACPI bus type pnp unregistered
Mar 11 21:20:55 aragorn kernel: system 00:00: iomem range 0x0-0x9ffff could=
 not be reserved
Mar 11 21:20:55 aragorn kernel: system 00:00: iomem range 0xe0000-0xfffff c=
ould not be reserved
Mar 11 21:20:55 aragorn kernel: system 00:00: iomem range 0x100000-0x7e7fff=
ff could not be reserved
Mar 11 21:20:55 aragorn kernel: system 00:0a: ioport range 0x500-0x55f has =
been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0a: ioport range 0x800-0x80f has =
been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0a: iomem range 0xffb00000-0xffbf=
ffff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0a: iomem range 0xfff00000-0xffff=
ffff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: ioport range 0x4d0-0x4d1 has =
been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: ioport range 0x2f8-0x2ff has =
been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: ioport range 0x3f8-0x3ff has =
been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: ioport range 0x1000-0x107f ha=
s been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: ioport range 0x1100-0x113f ha=
s been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: ioport range 0x1200-0x121f ha=
s been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: iomem range 0xf8000000-0xfbff=
ffff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: iomem range 0xfec00000-0xfec0=
00ff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: iomem range 0xfed20000-0xfed3=
ffff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: iomem range 0xfed45000-0xfed8=
ffff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0c: iomem range 0xfed90000-0xfed9=
9fff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0d: iomem range 0xcee00-0xcffff h=
as been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0d: iomem range 0xd2000-0xd3fff h=
as been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0d: iomem range 0xfeda0000-0xfedb=
ffff has been reserved
Mar 11 21:20:55 aragorn kernel: system 00:0d: iomem range 0xfee00000-0xfee0=
0fff has been reserved
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0: PCI bridge, secondary bus=
 0000:08
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0:   IO window: disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0:   MEM window: disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0:   PREFETCH window: disabl=
ed
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1: PCI bridge, secondary bus=
 0000:10
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1:   IO window: disabled
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1:   MEM window: 0xe0000000-=
0xe00fffff
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1:   PREFETCH window: disabl=
ed
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0: CardBus bridge, secondary=
 bus 0000:03
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0:   IO window: 0x003000-0x0=
030ff
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0:   IO window: 0x003400-0x0=
034ff
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0:   PREFETCH window: 0x8000=
0000-0x83ffffff
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0:   MEM window: 0x84000000-=
0x87ffffff
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0: PCI bridge, secondary bus=
 0000:02
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0:   MEM window: 0xe0100000-=
0xe03fffff
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0:   PREFETCH window: 0x0000=
0080000000-0x00000083ffffff
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0: PCI INT A -> GSI 16 (leve=
l, low) -> IRQ 16
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.0: setting latency timer to =
64
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1: PCI INT B -> GSI 17 (leve=
l, low) -> IRQ 17
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1c.1: setting latency timer to =
64
Mar 11 21:20:55 aragorn kernel: pci 0000:00:1e.0: setting latency timer to =
64
Mar 11 21:20:55 aragorn kernel: pci 0000:02:06.0: PCI INT A -> GSI 18 (leve=
l, low) -> IRQ 18
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:00: resource 0 io:  [0x00-0xff=
ff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:00: resource 1 mem: [0x000000-=
0xffffffffffffffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:08: resource 0 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:08: resource 1 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:08: resource 2 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:08: resource 3 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:10: resource 0 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:10: resource 1 mem: [0xe000000=
0-0xe00fffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:10: resource 2 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:10: resource 3 mem: [0x0-0x0]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:02: resource 0 io:  [0x3000-0x=
3fff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:02: resource 1 mem: [0xe010000=
0-0xe03fffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:02: resource 2 mem: [0x8000000=
0-0x83ffffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:02: resource 3 io:  [0x00-0xff=
ff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:02: resource 4 mem: [0x000000-=
0xffffffffffffffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:03: resource 0 io:  [0x3000-0x=
30ff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:03: resource 1 io:  [0x3400-0x=
34ff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:03: resource 2 mem: [0x8000000=
0-0x83ffffff]
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:03: resource 3 mem: [0x8400000=
0-0x87ffffff]
Mar 11 21:20:55 aragorn kernel: NET: Registered protocol family 2
Mar 11 21:20:55 aragorn kernel: Switched to high resolution mode on CPU 1
Mar 11 21:20:55 aragorn kernel: Switched to high resolution mode on CPU 0
Mar 11 21:20:55 aragorn kernel: IP route cache hash table entries: 65536 (o=
rder: 7, 524288 bytes)
Mar 11 21:20:55 aragorn kernel: TCP established hash table entries: 262144 =
(order: 10, 4194304 bytes)
Mar 11 21:20:55 aragorn kernel: TCP bind hash table entries: 65536 (order: =
9, 2097152 bytes)
Mar 11 21:20:55 aragorn kernel: TCP: Hash tables configured (established 26=
2144 bind 65536)
Mar 11 21:20:55 aragorn kernel: TCP reno registered
Mar 11 21:20:55 aragorn kernel: NET: Registered protocol family 1
Mar 11 21:20:55 aragorn kernel: checking if image is initramfs... it is
Mar 11 21:20:55 aragorn kernel: Freeing initrd memory: 5645k freed
Mar 11 21:20:55 aragorn kernel: audit: initializing netlink socket (disable=
d)
Mar 11 21:20:55 aragorn kernel: type=3D2000 audit(1236802808.209:1): initia=
lized
Mar 11 21:20:55 aragorn kernel: VFS: Disk quotas dquot_6.5.2
Mar 11 21:20:55 aragorn kernel: Dquot-cache hash table entries: 512 (order =
0, 4096 bytes)
Mar 11 21:20:55 aragorn kernel: msgmni has been set to 3965
Mar 11 21:20:55 aragorn kernel: alg: No test for stdrng (krng)
Mar 11 21:20:55 aragorn kernel: io scheduler noop registered
Mar 11 21:20:55 aragorn kernel: io scheduler anticipatory registered
Mar 11 21:20:55 aragorn kernel: io scheduler deadline registered
Mar 11 21:20:55 aragorn kernel: io scheduler cfq registered (default)
Mar 11 21:20:55 aragorn kernel: pci 0000:00:02.0: Boot video device
Mar 11 21:20:55 aragorn kernel: pcieport-driver 0000:00:1c.0: setting laten=
cy timer to 64
Mar 11 21:20:55 aragorn kernel: pcieport-driver 0000:00:1c.0: irq 24 for MS=
I/MSI-X
Mar 11 21:20:55 aragorn kernel: pcieport-driver 0000:00:1c.1: setting laten=
cy timer to 64
Mar 11 21:20:55 aragorn kernel: pcieport-driver 0000:00:1c.1: irq 25 for MS=
I/MSI-X
Mar 11 21:20:55 aragorn kernel: vesafb: framebuffer at 0xd0000000, mapped t=
o 0xffffc20004100000, using 3072k, total 7616k
Mar 11 21:20:55 aragorn kernel: vesafb: mode is 1024x768x16, linelength=3D2=
048, pages=3D3
Mar 11 21:20:55 aragorn kernel: vesafb: scrolling: redraw
Mar 11 21:20:55 aragorn kernel: vesafb: Truecolor: size=3D0:5:6:5, shift=3D=
0:11:5:0
Mar 11 21:20:55 aragorn kernel: Console: switching to colour frame buffer d=
evice 128x48
Mar 11 21:20:55 aragorn kernel: fb0: VESA VGA frame buffer device
Mar 11 21:20:55 aragorn kernel: Linux agpgart interface v0.103
Mar 11 21:20:55 aragorn kernel: Serial: 8250/16550 driver, 4 ports, IRQ sha=
ring enabled
Mar 11 21:20:55 aragorn kernel: serial 0000:00:03.3: PCI INT B -> GSI 17 (l=
evel, low) -> IRQ 17
Mar 11 21:20:55 aragorn kernel: 0000:00:03.3: ttyS0 at I/O 0x2040 (irq =3D =
17) is a 16550A
Mar 11 21:20:55 aragorn kernel: brd: module loaded
Mar 11 21:20:55 aragorn kernel: PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:=
C29D] at 0x60,0x64 irq 1,12
Mar 11 21:20:55 aragorn kernel: i8042.c: Detected active multiplexing contr=
oller, rev 1.1.
Mar 11 21:20:55 aragorn kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Mar 11 21:20:55 aragorn kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Mar 11 21:20:55 aragorn kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Mar 11 21:20:55 aragorn kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Mar 11 21:20:55 aragorn kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Mar 11 21:20:55 aragorn kernel: mice: PS/2 mouse device common for all mice
Mar 11 21:20:55 aragorn kernel: rtc_cmos 00:06: RTC can wake from S4
Mar 11 21:20:55 aragorn kernel: rtc_cmos 00:06: rtc core: registered rtc_cm=
os as rtc0
Mar 11 21:20:55 aragorn kernel: rtc0: alarms up to one month, y3k, 114 byte=
s nvram, hpet irqs
Mar 11 21:20:55 aragorn kernel: cpuidle: using governor ladder
Mar 11 21:20:55 aragorn kernel: cpuidle: using governor menu
Mar 11 21:20:55 aragorn kernel: TCP bic registered
Mar 11 21:20:55 aragorn kernel: NET: Registered protocol family 17
Mar 11 21:20:55 aragorn kernel: rtc_cmos 00:06: setting system clock to 200=
9-03-11 20:20:08 UTC (1236802808)
Mar 11 21:20:55 aragorn kernel: Freeing unused kernel memory: 312k freed
Mar 11 21:20:55 aragorn kernel: input: AT Translated Set 2 keyboard as /cla=
ss/input/input0
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:00: registered as cooling_devic=
e0
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3B1] (off)
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:01: registered as cooling_devic=
e1
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3B2] (off)
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:02: registered as cooling_devic=
e2
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3C8] (off)
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:03: registered as cooling_devic=
e3
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3C9] (off)
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:04: registered as cooling_devic=
e4
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3CA] (off)
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:05: registered as cooling_devic=
e5
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3CB] (off)
Mar 11 21:20:55 aragorn kernel: fan PNP0C0B:06: registered as cooling_devic=
e6
Mar 11 21:20:55 aragorn kernel: ACPI: Fan [C3CC] (off)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DBD42, 027F (r1 HP      Cpu0I=
st     3000 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DC046, 05FA (r1 HP      Cpu0C=
st     3001 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: Monitor-Mwait will be used to enter C-1 sta=
te
Mar 11 21:20:55 aragorn kernel: Monitor-Mwait will be used to enter C-2 sta=
te
Mar 11 21:20:55 aragorn kernel: ACPI: CPU0 (power states: C1[C1] C2[C2])
Mar 11 21:20:55 aragorn kernel: processor ACPI_CPU:00: registered as coolin=
g_device7
Mar 11 21:20:55 aragorn kernel: ACPI: Processor [CPU0] (supports 8 throttli=
ng states)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DBC7A, 00C8 (r1 HP      Cpu1I=
st     3000 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: ACPI: SSDT 7E7DBFC1, 0085 (r1 HP      Cpu1C=
st     3000 INTL 20060317)
Mar 11 21:20:55 aragorn kernel: ACPI: CPU1 (power states: C1[C1] C2[C2])
Mar 11 21:20:55 aragorn kernel: processor ACPI_CPU:01: registered as coolin=
g_device8
Mar 11 21:20:55 aragorn kernel: ACPI: Processor [CPU1] (supports 8 throttli=
ng states)
Mar 11 21:20:55 aragorn kernel: Marking TSC unstable due to TSC halts in id=
le
Mar 11 21:20:55 aragorn kernel: thermal LNXTHERM:01: registered as thermal_=
zone0
Mar 11 21:20:55 aragorn kernel: ACPI: Thermal Zone [TZ6] (25 C)
Mar 11 21:20:55 aragorn kernel: thermal LNXTHERM:02: registered as thermal_=
zone1
Mar 11 21:20:55 aragorn kernel: ACPI: Thermal Zone [TZ0] (60 C)
Mar 11 21:20:55 aragorn kernel: thermal LNXTHERM:03: registered as thermal_=
zone2
Mar 11 21:20:55 aragorn kernel: ACPI: Thermal Zone [TZ1] (59 C)
Mar 11 21:20:55 aragorn kernel: thermal LNXTHERM:04: registered as thermal_=
zone3
Mar 11 21:20:55 aragorn kernel: ACPI: Thermal Zone [TZ3] (45 C)
Mar 11 21:20:55 aragorn kernel: thermal LNXTHERM:05: registered as thermal_=
zone4
Mar 11 21:20:55 aragorn kernel: ACPI: Thermal Zone [TZ4] (33 C)
Mar 11 21:20:55 aragorn kernel: thermal LNXTHERM:06: registered as thermal_=
zone5
Mar 11 21:20:55 aragorn kernel: ACPI: Thermal Zone [TZ5] (49 C)
Mar 11 21:20:55 aragorn kernel: SCSI subsystem initialized
Mar 11 21:20:55 aragorn kernel: e1000e: Intel(R) PRO/1000 Network Driver - =
0.3.3.3-k6
Mar 11 21:20:55 aragorn kernel: e1000e: Copyright (c) 1999-2008 Intel Corpo=
ration.
Mar 11 21:20:55 aragorn kernel: e1000e 0000:00:19.0: PCI INT A -> GSI 22 (l=
evel, low) -> IRQ 22
Mar 11 21:20:55 aragorn kernel: e1000e 0000:00:19.0: setting latency timer =
to 64
Mar 11 21:20:55 aragorn kernel: e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
Mar 11 21:20:55 aragorn kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controlle=
r (EHCI) Driver
Mar 11 21:20:55 aragorn kernel: libata version 3.00 loaded.
Mar 11 21:20:55 aragorn kernel: ricoh-mmc: Ricoh MMC Controller disabling d=
river
Mar 11 21:20:55 aragorn kernel: ricoh-mmc: Copyright(c) Philip Langdale
Mar 11 21:20:55 aragorn kernel: ricoh-mmc: Ricoh MMC controller found at 00=
00:02:06.3 [1180:0843] (rev 11)
Mar 11 21:20:55 aragorn kernel: ricoh-mmc: Controller is now disabled.
Mar 11 21:20:55 aragorn kernel: ohci1394 0000:02:06.1: PCI INT B -> GSI 19 =
(level, low) -> IRQ 19
Mar 11 21:20:55 aragorn kernel: sdhci: Secure Digital Host Controller Inter=
face driver
Mar 11 21:20:55 aragorn kernel: sdhci: Copyright(c) Pierre Ossman
Mar 11 21:20:55 aragorn kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IR=
Q=3D[19]  MMIO=3D[e0101000-e01017ff]  Max Packet=3D[2048]  IR/IT contexts=
=3D[4/4]
Mar 11 21:20:55 aragorn kernel: sdhci-pci 0000:02:06.2: SDHCI controller fo=
und [1180:0822] (rev 21)
Mar 11 21:20:55 aragorn kernel: sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20=
 (level, low) -> IRQ 20
Mar 11 21:20:55 aragorn kernel: Registered led device: mmc0::
Mar 11 21:20:55 aragorn kernel: mmc0: SDHCI controller on PCI [0000:02:06.2=
] using PIO
Mar 11 21:20:55 aragorn kernel: 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Wi=
dth x1) 00:1e:68:5e:3b:04
Mar 11 21:20:55 aragorn kernel: 0000:00:19.0: eth0: Intel(R) PRO/1000 Netwo=
rk Connection
Mar 11 21:20:55 aragorn kernel: 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No:=
 ffffff-0ff
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 =
(level, low) -> IRQ 18
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: EHCI Host Controller
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: new USB bus register=
ed, assigned bus number 1
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: debug port 1
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: cache line size of 3=
2 is not supported
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe06=
41000
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1a.7: USB 2.0 started, EHC=
I 1.00
Mar 11 21:20:55 aragorn kernel: usb usb1: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 1-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 1-0:1.0: 4 ports detected
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 =
(level, low) -> IRQ 20
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: new USB bus register=
ed, assigned bus number 2
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: debug port 1
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: cache line size of 3=
2 is not supported
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe06=
48000
Mar 11 21:20:55 aragorn kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHC=
I 1.00
Mar 11 21:20:55 aragorn kernel: usb usb2: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 2-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 2-0:1.0: 6 ports detected
Mar 11 21:20:55 aragorn kernel: pata_acpi 0000:00:03.2: PCI INT C -> GSI 18=
 (level, low) -> IRQ 18
Mar 11 21:20:55 aragorn kernel: pata_acpi 0000:00:03.2: setting latency tim=
er to 64
Mar 11 21:20:55 aragorn kernel: pata_acpi 0000:00:03.2: PCI INT C disabled
Mar 11 21:20:55 aragorn kernel: pata_acpi 0000:00:1f.1: PCI INT A -> GSI 16=
 (level, low) -> IRQ 16
Mar 11 21:20:55 aragorn kernel: pata_acpi 0000:00:1f.1: setting latency tim=
er to 64
Mar 11 21:20:55 aragorn kernel: pata_acpi 0000:00:1f.1: PCI INT A disabled
Mar 11 21:20:55 aragorn kernel: ata_piix 0000:00:1f.1: version 2.12
Mar 11 21:20:55 aragorn kernel: ata_piix 0000:00:1f.1: quirky BIOS, skippin=
g spindown on poweroff and hibernation
Mar 11 21:20:55 aragorn kernel: ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 =
(level, low) -> IRQ 16
Mar 11 21:20:55 aragorn kernel: ata_piix 0000:00:1f.1: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: scsi0 : ata_piix
Mar 11 21:20:55 aragorn kernel: scsi1 : ata_piix
Mar 11 21:20:55 aragorn kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6=
 bmdma 0x2120 irq 14
Mar 11 21:20:55 aragorn kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376=
 bmdma 0x2128 irq 15
Mar 11 21:20:55 aragorn kernel: uhci_hcd: USB Universal Host Controller Int=
erface driver
Mar 11 21:20:55 aragorn kernel: Uniform Multi-Platform E-IDE driver
Mar 11 21:20:55 aragorn kernel: ata1.00: ATA-7: SAMSUNG HS122JC, GQ100-04, =
max UDMA/100
Mar 11 21:20:55 aragorn kernel: ata1.00: 234441648 sectors, multi 16: LBA=20
Mar 11 21:20:55 aragorn kernel: ata1.01: ATAPI: MATSHITADVD-RAM UJ-852S, 1.=
02, max MWDMA2
Mar 11 21:20:55 aragorn kernel: ata1.00: configured for UDMA/100
Mar 11 21:20:55 aragorn kernel: ata1.01: configured for MWDMA2
Mar 11 21:20:55 aragorn kernel: isa bounce pool size: 16 pages
Mar 11 21:20:55 aragorn kernel: scsi 0:0:0:0: Direct-Access     ATA      SA=
MSUNG HS122JC  GQ10 PQ: 0 ANSI: 5
Mar 11 21:20:55 aragorn kernel: scsi 0:0:1:0: CD-ROM            MATSHITA DV=
D-RAM UJ-852S  1.02 PQ: 0 ANSI: 5
Mar 11 21:20:55 aragorn kernel: ata2: port disabled. ignoring.
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 =
(level, low) -> IRQ 16
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.0: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.0: UHCI Host Controller
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.0: new USB bus register=
ed, assigned bus number 3
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.0: irq 16, io base 0x00=
002080
Mar 11 21:20:55 aragorn kernel: usb usb3: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 3-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 3-0:1.0: 2 ports detected
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 =
(level, low) -> IRQ 17
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.1: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.1: UHCI Host Controller
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.1: new USB bus register=
ed, assigned bus number 4
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1a.1: irq 17, io base 0x00=
0020a0
Mar 11 21:20:55 aragorn kernel: usb usb4: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 4-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 4-0:1.0: 2 ports detected
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 =
(level, low) -> IRQ 20
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.0: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.0: new USB bus register=
ed, assigned bus number 5
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.0: irq 20, io base 0x00=
0020c0
Mar 11 21:20:55 aragorn kernel: usb usb5: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 5-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 5-0:1.0: 2 ports detected
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 =
(level, low) -> IRQ 22
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.1: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.1: new USB bus register=
ed, assigned bus number 6
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.1: irq 22, io base 0x00=
0020e0
Mar 11 21:20:55 aragorn kernel: usb usb6: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 6-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 6-0:1.0: 2 ports detected
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 =
(level, low) -> IRQ 18
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.2: setting latency time=
r to 64
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.2: new USB bus register=
ed, assigned bus number 7
Mar 11 21:20:55 aragorn kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x00=
002100
Mar 11 21:20:55 aragorn kernel: usb usb7: configuration #1 chosen from 1 ch=
oice
Mar 11 21:20:55 aragorn kernel: hub 7-0:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 7-0:1.0: 2 ports detected
Mar 11 21:20:55 aragorn kernel: Driver 'sd' needs updating - please use bus=
_type methods
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] 234441648 512-byte hardwa=
re sectors: (120 GB/111 GiB)
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Write Protect is off
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] 234441648 512-byte hardwa=
re sectors: (120 GB/111 GiB)
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Write Protect is off
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Mar 11 21:20:55 aragorn kernel:  sda: sda1 sda2 sda3 sda4 <<4>Driver 'sr' n=
eeds updating - please use bus_type methods
Mar 11 21:20:55 aragorn kernel:  sda5 sda6 sda7 >
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Mar 11 21:20:55 aragorn kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ra=
m cd/rw xa/form2 cdda tray
Mar 11 21:20:55 aragorn kernel: Uniform CD-ROM driver Revision: 3.20
Mar 11 21:20:55 aragorn kernel: sr 0:0:1:0: Attached scsi CD-ROM sr0
Mar 11 21:20:55 aragorn kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar 11 21:20:55 aragorn kernel: sr 0:0:1:0: Attached scsi generic sg1 type 5
Mar 11 21:20:55 aragorn kernel: Clocksource tsc unstable (delta =3D -181571=
937 ns)
Mar 11 21:20:55 aragorn kernel: usb 1-2: new high speed USB device using eh=
ci_hcd and address 3
Mar 11 21:20:55 aragorn kernel: usb 1-2: configuration #1 chosen from 1 cho=
ice
Mar 11 21:20:55 aragorn kernel: hub 1-2:1.0: USB hub found
Mar 11 21:20:55 aragorn kernel: hub 1-2:1.0: 4 ports detected
Mar 11 21:20:55 aragorn kernel: usb 3-1: new full speed USB device using uh=
ci_hcd and address 2
Mar 11 21:20:55 aragorn kernel: usb 3-1: configuration #1 chosen from 1 cho=
ice
Mar 11 21:20:55 aragorn kernel: device-mapper: ioctl: 4.14.0-ioctl (2008-04=
=2D23) initialised: dm-devel@redhat.com
Mar 11 21:20:55 aragorn kernel: ieee1394: Host added: ID:BUS[0-00:1023]  GU=
ID[001b249929192210]
Mar 11 21:20:55 aragorn kernel: usb 5-2: new full speed USB device using uh=
ci_hcd and address 2
Mar 11 21:20:55 aragorn kernel: usb 5-2: configuration #1 chosen from 1 cho=
ice
Mar 11 21:20:55 aragorn kernel: usb 1-2.2: new full speed USB device using =
ehci_hcd and address 4
Mar 11 21:20:55 aragorn kernel: usb 1-2.2: configuration #1 chosen from 1 c=
hoice
Mar 11 21:20:55 aragorn kernel: usb 1-2.3: new low speed USB device using e=
hci_hcd and address 5
Mar 11 21:20:55 aragorn kernel: usb 1-2.3: configuration #1 chosen from 1 c=
hoice
Mar 11 21:20:55 aragorn kernel: usbcore: registered new interface driver hi=
ddev
Mar 11 21:20:55 aragorn kernel: input: Logitech USB Receiver as /class/inpu=
t/input1
Mar 11 21:20:55 aragorn kernel: generic-usb 0003:046D:C50D.0001: input: USB=
 HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.7-2.3/input0
Mar 11 21:20:55 aragorn kernel: usbcore: registered new interface driver us=
bhid
Mar 11 21:20:55 aragorn kernel: usbhid: v2.6:USB HID core driver
Mar 11 21:20:55 aragorn kernel: usb 1-2.4: new low speed USB device using e=
hci_hcd and address 6
Mar 11 21:20:55 aragorn kernel: usb 1-2.4: configuration #1 chosen from 1 c=
hoice
Mar 11 21:20:55 aragorn kernel: input: USB Compliant Keyboard as /class/inp=
ut/input2
Mar 11 21:20:55 aragorn kernel: generic-usb 0003:05A4:9841.0002: input: USB=
 HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1a.7-2.4/input0
Mar 11 21:20:55 aragorn kernel: input: USB Compliant Keyboard as /class/inp=
ut/input3
Mar 11 21:20:55 aragorn kernel: generic-usb 0003:05A4:9841.0003: input: USB=
 HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1a.7-2.4/input1
Mar 11 21:20:55 aragorn kernel: PM: Starting manual resume from disk
Mar 11 21:20:55 aragorn kernel: EXT3-fs: INFO: recovery required on readonl=
y filesystem.
Mar 11 21:20:55 aragorn kernel: EXT3-fs: write access will be enabled durin=
g recovery.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3-fs: recovery complete.
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: udevd version 125 started
Mar 11 21:20:55 aragorn kernel: ACPI: AC Adapter [C23B] (on-line)
Mar 11 21:20:55 aragorn kernel: acpi device:02: registered as cooling_devic=
e9
Mar 11 21:20:55 aragorn kernel: input: Video Bus as /class/input/input4
Mar 11 21:20:55 aragorn kernel: ACPI: Video Device [C09A] (multi-head: yes =
 rom: no  post: no)
Mar 11 21:20:55 aragorn kernel: input: Power Button (FF) as /class/input/in=
put5
Mar 11 21:20:55 aragorn kernel: ACPI: Power Button (FF) [PWRF]
Mar 11 21:20:55 aragorn kernel: input: Sleep Button (CM) as /class/input/in=
put6
Mar 11 21:20:55 aragorn kernel: ACPI: Sleep Button (CM) [C2BF]
Mar 11 21:20:55 aragorn kernel: input: Lid Switch as /class/input/input7
Mar 11 21:20:55 aragorn kernel: ACPI: Lid Switch [C155]
Mar 11 21:20:55 aragorn kernel: ACPI: Battery Slot [C23D] (battery present)
Mar 11 21:20:55 aragorn kernel: ACPI: WMI: Mapper loaded
Mar 11 21:20:55 aragorn kernel: agpgart-intel 0000:00:00.0: Intel 965GM Chi=
pset
Mar 11 21:20:55 aragorn kernel: agpgart-intel 0000:00:00.0: detected 7676K =
stolen memory
Mar 11 21:20:55 aragorn kernel: agpgart-intel 0000:00:00.0: AGP aperture is=
 256M @ 0xd0000000
Mar 11 21:20:55 aragorn kernel: lis3lv02d: 2-byte sensor found
Mar 11 21:20:55 aragorn kernel: lis3lv02d: hardware type NC2510 found
Mar 11 21:20:55 aragorn kernel: Registered led device: hp::hddprotect
Mar 11 21:20:55 aragorn kernel: input: ST LIS3LV02DL Accelerometer as /clas=
s/input/input8
Mar 11 21:20:55 aragorn kernel: lis3lv02d: registered irq 23 from ACPI
Mar 11 21:20:55 aragorn kernel: yenta_cardbus 0000:02:06.0: CardBus bridge =
found [103c:30c9]
Mar 11 21:20:55 aragorn kernel: usblp0: USB Bidirectional printer dev 4 if =
0 alt 1 proto 2 vid 0x03F0 pid 0x3102
Mar 11 21:20:55 aragorn kernel: usbcore: registered new interface driver us=
blp
Mar 11 21:20:55 aragorn kernel: yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x=
0cb8, PCI irq 18
Mar 11 21:20:55 aragorn kernel: yenta_cardbus 0000:02:06.0: Socket status: =
30000006
Mar 11 21:20:55 aragorn kernel: pci_bus 0000:02: Raising subordinate bus# o=
f parent bus (#02) from #03 to #06
Mar 11 21:20:55 aragorn kernel: yenta_cardbus 0000:02:06.0: pcmcia: parent =
PCI bridge I/O window: 0x3000 - 0x3fff
Mar 11 21:20:55 aragorn kernel: yenta_cardbus 0000:02:06.0: pcmcia: parent =
PCI bridge Memory window: 0xe0100000 - 0xe03fffff
Mar 11 21:20:55 aragorn kernel: yenta_cardbus 0000:02:06.0: pcmcia: parent =
PCI bridge Memory window: 0x80000000 - 0x83ffffff
Mar 11 21:20:55 aragorn kernel: input: PC Speaker as /class/input/input9
Mar 11 21:20:55 aragorn kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v=
1.05
Mar 11 21:20:55 aragorn kernel: iTCO_wdt: Found a ICH8M-E TCO device (Versi=
on=3D2, TCOBASE=3D0x1060)
Mar 11 21:20:55 aragorn kernel: iTCO_wdt: initialized. heartbeat=3D30 sec (=
nowayout=3D0)
Mar 11 21:20:55 aragorn kernel: cfg80211: Using static regulatory domain in=
fo
Mar 11 21:20:55 aragorn kernel: cfg80211: Regulatory domain: EU
Mar 11 21:20:55 aragorn kernel: ^I(start_freq - end_freq @ bandwidth), (max=
_antenna_gain, max_eirp)
Mar 11 21:20:55 aragorn kernel: ^I(2402000 KHz - 2482000 KHz @ 40000 KHz), =
(600 mBi, 2000 mBm)
Mar 11 21:20:55 aragorn kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), =
(600 mBi, 2300 mBm)
Mar 11 21:20:55 aragorn kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), =
(600 mBi, 2300 mBm)
Mar 11 21:20:55 aragorn kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), =
(600 mBi, 2300 mBm)
Mar 11 21:20:55 aragorn kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), =
(600 mBi, 2000 mBm)
Mar 11 21:20:55 aragorn kernel: ^I(5490000 KHz - 5710000 KHz @ 40000 KHz), =
(600 mBi, 3000 mBm)
Mar 11 21:20:55 aragorn kernel: lib80211: common routines for IEEE802.11 dr=
ivers
Mar 11 21:20:55 aragorn kernel: lib80211_crypt: registered algorithm 'NULL'
Mar 11 21:20:55 aragorn kernel: iwlagn: Intel(R) Wireless WiFi Link AGN dri=
ver for Linux, 1.3.27kds
Mar 11 21:20:55 aragorn kernel: iwlagn: Copyright(c) 2003-2008 Intel Corpor=
ation
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (l=
evel, low) -> IRQ 17
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: setting latency timer =
to 64
Mar 11 21:20:55 aragorn kernel: iwlagn: Detected Intel Wireless WiFi Link 4=
965AGN REV=3D0x4
Mar 11 21:20:55 aragorn kernel: iwlagn: Tunable channels: 11 802.11bg, 13 8=
02.11a channels
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: PCI INT A disabled
Mar 11 21:20:55 aragorn kernel: wmaster0 (iwlagn): not using net_device_ops=
 yet
Mar 11 21:20:55 aragorn kernel: phy0: Selected rate control algorithm 'iwl-=
agn-rs'
Mar 11 21:20:55 aragorn kernel: input: PS/2 Generic Mouse as /class/input/i=
nput10
Mar 11 21:20:55 aragorn kernel: wlan0 (iwlagn): not using net_device_ops yet
Mar 11 21:20:55 aragorn kernel: HDA Intel 0000:00:1b.0: power state changed=
 by ACPI to D0
Mar 11 21:20:55 aragorn kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17=
 (level, low) -> IRQ 17
Mar 11 21:20:55 aragorn kernel: HDA Intel 0000:00:1b.0: setting latency tim=
er to 64
Mar 11 21:20:55 aragorn kernel: Synaptics Touchpad, model: 1, fw: 6.3, id: =
0x1a0b1, caps: 0xa04711/0xa00000
Mar 11 21:20:55 aragorn kernel: input: SynPS/2 Synaptics TouchPad as /class=
/input/input11
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-1, internal journal
Mar 11 21:20:55 aragorn kernel: loop: module loaded
Mar 11 21:20:55 aragorn kernel: input: HP WMI hotkeys as /class/input/input=
12
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-5, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-6, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-4, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-2, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-3, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-9, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-8, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: kjournald starting.  Commit interval 5 seco=
nds
Mar 11 21:20:55 aragorn kernel: EXT3 FS on dm-10, internal journal
Mar 11 21:20:55 aragorn kernel: EXT3-fs: mounted filesystem with ordered da=
ta mode.
Mar 11 21:20:55 aragorn kernel: Adding 2097144k swap on /dev/mapper/main-sw=
ap.  Priority:-1 extents:1 across:2097144k=20
Mar 11 21:20:55 aragorn kernel: lis3lv02d: registered interrupt 23
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (l=
evel, low) -> IRQ 17
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: restoring config space=
 at offset 0x1 (was 0x100002, writing 0x100006)
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: irq 27 for MSI/MSI-X
Mar 11 21:20:55 aragorn kernel: iwlagn 0000:10:00.0: firmware: requesting i=
wlwifi-4965-2.ucode
Mar 11 21:20:55 aragorn kernel: iwlagn loaded firmware version 228.57.2.21
Mar 11 21:20:55 aragorn kernel: Registered led device: iwl-phy0:radio
Mar 11 21:20:55 aragorn kernel: Registered led device: iwl-phy0:assoc
Mar 11 21:20:55 aragorn kernel: Registered led device: iwl-phy0:RX
Mar 11 21:20:55 aragorn kernel: Registered led device: iwl-phy0:TX
Mar 11 21:20:55 aragorn kernel: wlan0: authenticate with AP 00:14:c1:38:e5:=
15
Mar 11 21:20:55 aragorn kernel: wlan0: authenticated
Mar 11 21:20:55 aragorn kernel: wlan0: associate with AP 00:14:c1:38:e5:15
Mar 11 21:20:55 aragorn kernel: wlan0: RX AssocResp from 00:14:c1:38:e5:15 =
(capab=3D0x411 status=3D0 aid=3D1)
Mar 11 21:20:55 aragorn kernel: wlan0: associated
Mar 11 21:20:55 aragorn kernel: RPC: Registered udp transport module.
Mar 11 21:20:55 aragorn kernel: RPC: Registered tcp transport module.
Mar 11 21:20:55 aragorn kernel: Installing knfsd (copyright (C) 1996 okir@m=
onad.swb.de).
Mar 11 21:20:56 aragorn kernel: NET: Registered protocol family 10
Mar 11 21:20:56 aragorn kernel: lo: Disabled Privacy Extensions
Mar 11 21:20:57 aragorn kernel: lp: driver loaded but no devices found
Mar 11 21:20:57 aragorn kernel: ppdev: user-space parallel port driver
Mar 11 21:21:06 aragorn kernel: wlan0: no IPv6 routers present
Mar 11 21:21:08 aragorn kernel: [drm] Initialized drm 1.1.0 20060810
Mar 11 21:21:08 aragorn kernel: pci 0000:00:02.0: PCI INT A -> GSI 16 (leve=
l, low) -> IRQ 16
Mar 11 21:21:08 aragorn kernel: pci 0000:00:02.0: setting latency timer to =
64
Mar 11 21:21:08 aragorn kernel: pci 0000:00:02.0: irq 28 for MSI/MSI-X
Mar 11 21:21:08 aragorn kernel: [drm] Initialized i915 1.6.0 20080730 on mi=
nor 0
Mar 11 21:21:44 aragorn kernel: warning: `VirtualBox' uses 32-bit capabilit=
ies (legacy support in use)
Mar 11 21:25:34 aragorn kernel: vboxdrv: Trying to deactivate the NMI watch=
dog permanently...
Mar 11 21:25:34 aragorn kernel: vboxdrv: Successfully done.
Mar 11 21:25:34 aragorn kernel: vboxdrv: Found 2 processor cores.
Mar 11 21:25:34 aragorn kernel: VBoxDrv: dbg - g_abExecMemory=3Dffffffffa05=
62140
Mar 11 21:25:34 aragorn kernel: vboxdrv: fAsync=3D0 offMin=3D0x2bc offMax=
=3D0x693c
Mar 11 21:25:34 aragorn kernel: vboxdrv: TSC mode is 'synchronous', kernel =
timer mode is 'normal'.
Mar 11 21:25:34 aragorn kernel: vboxdrv: Successfully loaded version 2.1.4_=
OSE (interface 0x000a0009).
Mar 11 21:25:34 aragorn kernel: VBoxNetFlt: dbg - g_abExecMemory=3Dffffffff=
a06fbf40
Mar 11 21:25:55 aragorn kernel: e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
Mar 11 21:25:55 aragorn kernel: e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
Mar 11 21:25:55 aragorn kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar 11 21:25:56 aragorn kernel: e1000e: eth0 NIC Link is Up 100 Mbps Full D=
uplex, Flow Control: None
Mar 11 21:25:56 aragorn kernel: 0000:00:19.0: eth0: 10/100 speed: disabling=
 TSO
Mar 11 21:25:56 aragorn kernel: ADDRCONF(NETDEV_CHANGE): eth0: link becomes=
 ready
Mar 11 21:26:04 aragorn kernel: wlan0: deauthenticating by local choice (re=
ason=3D3)
Mar 11 21:26:04 aragorn kernel: iwlagn: MAC is in deep sleep!
Mar 11 21:26:04 aragorn last message repeated 2 times
Mar 11 21:26:04 aragorn kernel: iwlagn 0000:10:00.0: PCI INT A disabled
Mar 11 21:26:04 aragorn kernel: wlan0: deauthenticating by local choice (re=
ason=3D3)
Mar 11 21:26:07 aragorn kernel: eth0: no IPv6 routers present
Mar 11 21:26:28 aragorn kernel: device eth0 entered promiscuous mode
Mar 11 21:28:36 aragorn kernel: device eth0 left promiscuous mode
Mar 11 22:35:46 aragorn kernel: BUG: unable to handle kernel NULL pointer d=
ereference at 0000000000000008
Mar 11 22:35:46 aragorn kernel: IP: [<ffffffff80322504>] prio_tree_remove+0=
x9c/0xcc
Mar 11 22:35:46 aragorn kernel: PGD 7cab1067 PUD 7d644067 PMD 0=20
Mar 11 22:35:46 aragorn kernel: Oops: 0000 [#1] SMP=20
Mar 11 22:35:46 aragorn kernel: last sysfs file: /sys/class/power_supply/C2=
3D/charge_full
Mar 11 22:35:46 aragorn kernel: CPU 1=20
Mar 11 22:35:46 aragorn kernel: Modules linked in: vboxnetflt vboxdrv i915 =
drm i2c_algo_bit i2c_core ppdev parport_pc lp parport ipv6 nfsd exportfs nf=
s lockd nfs_acl auth_rpcgss sunrpc ext2 coretemp hp_wmi acpi_cpufreq loop s=
nd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss s=
nd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi iwlagn i=
wlcore snd_seq_midi_event snd_seq rfkill snd_timer snd_seq_device lib80211 =
pcmcia mac80211 snd soundcore snd_page_alloc cfg80211 psmouse iTCO_wdt seri=
o_raw pcspkr usblp yenta_socket rsrc_nonstatic pcmcia_core hp_accel intel_a=
gp wmi battery container button video output lis3lv02d ac joydev evdev ext3=
 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc usbhid hid dm_crypt =
dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod p=
iix ide_pci_generic ide_core uhci_hcd ata_piix pata_acpi sdhci_pci sdhci oh=
ci1394 ricoh_mmc mmc_core led_class ieee1394 ata_generic ehci_hcd e1000e li=
bata scsi_mod thermal processor fan thermal_sys
Mar 11 22:35:46 aragorn kernel: Pid: 5415, comm: kicker Not tainted 2.6.29-=
rc7 #4 HP Compaq 2510p Notebook PC
Mar 11 22:35:46 aragorn kernel: RIP: 0010:[<ffffffff80322504>]  [<ffffffff8=
0322504>] prio_tree_remove+0x9c/0xcc
Mar 11 22:35:46 aragorn kernel: RSP: 0018:ffff8800684cbce8  EFLAGS: 00010203
Mar 11 22:35:46 aragorn kernel: RAX: 0000000000000009 RBX: ffff880068648278=
 RCX: 0000000000000000
Mar 11 22:35:46 aragorn kernel: RDX: 0000000000000009 RSI: ffff88007e2c6390=
 RDI: ffff88007e2c6390
Mar 11 22:35:46 aragorn kernel: RBP: ffff8800684cbcf8 R08: ffff880068640001=
 R09: 0000000000000009
Mar 11 22:35:46 aragorn kernel: R10: ffffffff8046bb90 R11: 0000000000000017=
 R12: ffff88007cfddc18
Mar 11 22:35:46 aragorn kernel: R13: ffff88007cfddc18 R14: 0000000000000000=
 R15: ffff88007cb5ed58
Mar 11 22:35:46 aragorn kernel: FS:  00007f34b1c536f0(0000) GS:ffff88007e00=
2b00(0000) knlGS:0000000000000000
Mar 11 22:35:46 aragorn kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080=
050033
Mar 11 22:35:46 aragorn kernel: CR2: 0000000000000008 CR3: 000000007bd89000=
 CR4: 00000000000006e0
Mar 11 22:35:46 aragorn kernel: DR0: 0000000000000000 DR1: 0000000000000000=
 DR2: 0000000000000000
Mar 11 22:35:46 aragorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0=
 DR7: 0000000000000400
Mar 11 22:35:46 aragorn kernel: Process kicker (pid: 5415, threadinfo ffff8=
800684ca000, task ffff88006ce40000)
Mar 11 22:35:46 aragorn kernel: Stack:
Mar 11 22:35:46 aragorn kernel:  ffff88007cfddc18 ffff8800686f7780 ffff8800=
684cbd48 ffffffff803225df
Mar 11 22:35:46 aragorn kernel:  0000000000000016 ffff880068648278 ffff8800=
5d3ce910 ffff8800686f7780
Mar 11 22:35:46 aragorn kernel:  ffff8800686f7738 ffff88007c43a580 ffff8800=
7cb5ed50 ffff88007cb5ed58
Mar 11 22:35:46 aragorn kernel: Call Trace:
Mar 11 22:35:46 aragorn kernel:  [<ffffffff803225df>] prio_tree_insert+0xab=
/0x22a
Mar 11 22:35:46 aragorn kernel:  [<ffffffff8027e90d>] vma_prio_tree_insert+=
0x23/0xc2
Mar 11 22:35:46 aragorn kernel:  [<ffffffff802864af>] __vma_link_file+0x70/=
0x72
Mar 11 22:35:46 aragorn kernel:  [<ffffffff80286c15>] vma_link+0x7d/0xab
Mar 11 22:35:46 aragorn kernel:  [<ffffffff802881ea>] mmap_region+0x313/0x4=
79
Mar 11 22:35:46 aragorn kernel:  [<ffffffff80288646>] do_mmap_pgoff+0x2f6/0=
x35c
Mar 11 22:35:46 aragorn kernel:  [<ffffffff802ea99a>] do_shmat+0x28a/0x36c
Mar 11 22:35:46 aragorn kernel:  [<ffffffff802eaa8d>] sys_shmat+0x11/0x1c
Mar 11 22:35:46 aragorn kernel:  [<ffffffff8020c25b>] system_call_fastpath+=
0x16/0x1b
Mar 11 22:35:46 aragorn kernel: Code: 9d 48 8b 4e 08 48 39 f1 75 ec 48 8b 4=
e 10 48 39 f1 75 18 48 39 33 74 04 0f 0b eb fe 48 c7 03 00 00 00 00 66 c7 4=
3 08 01 00 eb 2b <48> 8b 41 08 48 39 f0 75 06 48 89 49 08 eb 17 48 89 09 48=
 89 f0=20
Mar 11 22:35:46 aragorn kernel: RIP  [<ffffffff80322504>] prio_tree_remove+=
0x9c/0xcc
Mar 11 22:35:46 aragorn kernel:  RSP <ffff8800684cbce8>
Mar 11 22:35:46 aragorn kernel: CR2: 0000000000000008
Mar 11 22:35:46 aragorn kernel: ---[ end trace 4a77aee5423dd8bf ]---

--Boundary-00=_kaDuJjF3plyPMN+
Content-Type: text/plain;
  charset="us-ascii";
  name="config-2.6.29-rc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config-2.6.29-rc7"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc7
# Tue Mar 10 14:13:59 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
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
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
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
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
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
# CONFIG_MK8 is not set
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
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
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
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
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
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
# CONFIG_MTD_PARTITIONS is not set
# CONFIG_MTD_TESTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
# CONFIG_MTD_BLKDEVS is not set
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=m
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
# CONFIG_PATA_ATIIXP is not set
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
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_DELAY=m
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH9K is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

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
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
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
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
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
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_NVRAM=m
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
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
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
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
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
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
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
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_THMC50 is not set
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
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
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
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
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
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_INPUT_BEEP=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
# CONFIG_SND_HDA_CODEC_INTELHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=60
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
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
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
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
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
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
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
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
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_HP_WMI=m
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
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
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_HW_BRANCH_TRACER is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

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
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_kaDuJjF3plyPMN+--
