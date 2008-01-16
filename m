Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYAPS7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYAPS7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYAPS7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:59:17 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:15839 "EHLO
	outbound2-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbYAPS7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:59:13 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 16 Jan 2008 19:57:48 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: venkatesh.pallipadi@intel.com
cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080116185748.GA11244@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
MIME-Version: 1.0
In-Reply-To: <20080116023955.597433000@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Jan 2008 18:57:38.0879 (UTC)
 FILETIME=[AA1F5CF0:01C85871]
X-WSS-ID: 6B908C2C07S8206862-01-01
Content-Type: multipart/mixed;
 boundary=IS0zKkzwUGydFO0o
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi,

I just want to report that the PAT support in x86/mm causes crashes
on two of my test machines. On both boxes the SATA detection does
not work when the PAT support is patched into the kernel.

Symptoms are as follows -- best described by a diff between the
two boot.logs:

# diff boot-failing.log boot-working.log

-Linux version 2.6.24-rc8-ga9f7faa5 (root@hunter) (gcc version ...
+Linux version 2.6.24-rc8-g2ea3cf43 (root@hunter) (gcc version ...
...
 early_iounmap(ffffffff82a0b000, 00001000)
-early_ioremap(000000000000c000, 00001000) => -000002103394304
-early_iounmap(ffffffff82a0c000, 00001000)
 early_iounmap(ffffffff82808000, 00001000)
...
-ACPI: PCI interrupt for device 0000:00:12.0 disabled
-sata_sil: probe of 0000:00:12.0 failed with error -12
+scsi0 : sata_sil
+scsi1 : sata_sil
+ata1: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc0403080 irq 22
...
-AC'97 space ioremap problem
-ACPI: PCI interrupt for device 0000:00:14.5 disabled
-ATI IXP AC97 controller: probe of 0000:00:14.5 failed with error -5
 ALSA device list:
-  No soundcards found.
+  #0: ATI IXP rev 80 with ALC655 at 0xc0403800, irq 17
...
-VFS: Cannot open root device "sda1" or unknown-block(0,0)
-Please append a correct "root=" boot option; here are the available partitions:
-1600    4194302 hdc driver: ide-cdrom
-Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
+kjournald starting.  Commit interval 5 seconds
+EXT3-fs: mounted filesystem with ordered data mode.
+VFS: Mounted root (ext3 filesystem) readonly.
...

   <snip>
 
The second test machine uses ahci. But the symptoms are similar.

I performed a git-bisect on x86/mm. Last commit that worked for me was

2ea3cf43fddecbfd66353caafdf73ec21ea3760b (x86: fix early_ioremap() ISA window)

The subsequent commits for PAT support introduced the problem.
I noticed that PAT should be disabled by default, but obviously the patches
still have some side-effect. (Maybe ioremap changes lead to the problem?)

Boot-logs are attached:

  boot-failing.log for x86/mm as of v2.6.24-rc8-672-ga9f7faa
  boot-working.log for x86/mm as of v2.6.24-rc8-621-g2ea3cf4

Hopefully it helps to track down the problem.
Maybe someone has an idea why the PAT patches are causing that
ominous "PCI interrupt for device ... disabled" messages.


Thanks and regards,

Andreas

--IS0zKkzwUGydFO0o
Content-Type: text/plain;
 charset=utf-8
Content-Disposition: attachment;
 filename=boot-failing.log
Content-Transfer-Encoding: quoted-printable

  Booting command-list

kernel=3D/tftpboot/aherrma3/hunter-x86-mm root=3D/dev/sda1 console=3DttyS0,=
115200
   [Linux-bzImage, setup=3D0x2a00, size=3D0x24bb58]
boot
Issuing RESET:
Linux version 2.6.24-rc8-ga9f7faa5 (root@hunter) (gcc version 4.1.2 (Gentoo=
 4.1.2 p1.0.2)) #1 SMP Wed Jan 16 18:26:59 CET 2008
Command line: root=3D/dev/sda1 console=3DttyS0,115200
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008dc00 (usable)
 BIOS-e820: 000000000008dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077e70000 (usable)
 BIOS-e820: 0000000077e70000 - 0000000077e7a000 (ACPI data)
 BIOS-e820: 0000000077e7a000 - 0000000077f00000 (ACPI NVS)
 BIOS-e820: 0000000077f00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
end_pfn_map =3D 1048576
early_ioremap(000000000000040e, 00000002) =3D> -000002105539570
early_iounmap(ffffffff8280040e, 00000002)
early_ioremap(000000000009e000, 00000002) =3D> -000002104893440
early_iounmap(ffffffff8289e000, 00000002)
early_ioremap(0000000000008000, 00001000) =3D> -000002105507840
early_ioremap(0000000000009000, 00001000) =3D> -000002103406592
early_iounmap(ffffffff82a09000, 00001000)
early_ioremap(000000000000a000, 00001000) =3D> -000002103402496
early_iounmap(ffffffff82a0a000, 00001000)
early_ioremap(000000000000b000, 00001000) =3D> -000002103398400
early_iounmap(ffffffff82a0b000, 00001000)
early_ioremap(000000000000c000, 00001000) =3D> -000002103394304
early_iounmap(ffffffff82a0c000, 00001000)
early_iounmap(ffffffff82808000, 00001000)
early_ioremap(00000000000f0000, 00010000) =3D> -000002104557568
DMI present.
early_ioremap(0000000077eec000, 00000491) =3D> -000002102476800
early_iounmap(ffffffff82aec000, 00000491)
early_ioremap(00000000000e0000, 00020000) =3D> -000002102525952
early_iounmap(ffffffff82ae0000, 00020000)
early_ioremap(00000000000f7870, 00000024) =3D> -000002102429584
ACPI: RSDP 000F7870, 0024 (r2 PTLTD )
early_iounmap(ffffffff82af7870, 00000024)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
ACPI: XSDT 77E72CC4, 004C (r1 PTLTD      XSDT    6040000  LTP        0)
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e7985c, 00000024) =3D> -000002102945700
ACPI: FACP 77E7985C, 00F4 (r3 AMD    DUNE      6040000 ATI     F4240)
early_iounmap(ffffffff82a7985c, 00000024)
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002102945700
early_iounmap(ffffffff82a7985c, 000000f4)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
ACPI: DSDT 77E72D10, 6AD8 (r1    ATI    SB400  6040000 MSFT  100000E)
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e7afc0, 00000024) =3D> -000002102939712
ACPI: FACS 77E7AFC0, 0040
early_iounmap(ffffffff82a7afc0, 00000024)
early_ioremap(0000000077e79950, 00000024) =3D> -000002102945456
ACPI: TCPA 77E79950, 0032 (r1 Phoeni  x        6040000  TL         0)
early_iounmap(ffffffff82a79950, 00000024)
early_ioremap(0000000077e79982, 00000024) =3D> -000002102945406
ACPI: SSDT 77E79982, 0544 (r1 AMD    POWERNOW  6040000 AMD         1)
early_iounmap(ffffffff82a79982, 00000024)
early_ioremap(0000000077e79ec6, 00000024) =3D> -000002102944058
ACPI: SRAT 77E79EC6, 00C0 (r1 AMD    HAMMER    6040000 AMD         1)
early_iounmap(ffffffff82a79ec6, 00000024)
early_ioremap(0000000077e79f86, 00000024) =3D> -000002102943866
ACPI: APIC 77E79F86, 007A (r1 PTLTD      APIC    6040000  LTP        0)
early_iounmap(ffffffff82a79f86, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002102944058
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002100846906
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002098749754
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000077e70000
early_ioremap(0000000000000000, 00000400) =3D> -000002097152000
early_iounmap(ffffffff83000000, 00000400)
early_ioremap(000000000009fc00, 00000400) =3D> -000002096497664
early_iounmap(ffffffff8309fc00, 00000400)
early_ioremap(00000000000f0000, 00010000) =3D> -000002096168960
early_iounmap(ffffffff830f0000, 00010000)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      141
    0:      256 ->   491120
ATI board detected. Disabling timer routing over 8254.
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002096654244
ACPI: PM-Timer IO Port: 0x8008
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002094555258
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002092458106
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002090360954
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002088263802
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002086166650
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002084069498
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002081972346
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30368 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 484281
Policy zone: DMA32
Kernel command line: root=3D/dev/sda1 console=3DttyS0,115200
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2288.275 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Memory: 1928912k/1964480k available (3073k kernel code, 35108k reserved, 17=
37k data, 308k init)
Calibrating delay using timer specific routine.. 4581.21 BogoMIPS (lpj=3D91=
62431)
Dentry cache hash table entries: 262144 (orde=EF=BF=BD=EF=BF=BD=02=EF=BF=BD=
b=02=EF=BF=BD=EF=BF=BD=CA=BA=EF=BF=BD=EF=BF=BD=EF=BF=BD=02=D1=95=CD=A5
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Detected 12.436 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4576.70 BogoMIPS (lpj=3D91=
53416)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4576.71 BogoMIPS (lpj=3D91=
53428)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4576.73 BogoMIPS (lpj=3D91=
53467)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
Brought up 4 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=3DLinux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
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
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:09: iomem range 0x0-0xfff could not be reserved
PCI: Bridge: 0000:00:01.0
Time: acpi_pm clocksource has been installed.
  IO window: 9000-9fff
  MEM window: c0000000-c00fffff
  PREFETCH window: c8000000-cfffffff
PCI: Bridge: 0000:00:14.4
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [C000] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 16 (level, low) -> IRQ 16
3c59x: Donald Becker and others.
0000:02:04.0: 3Com PCI 3c905C Tornado at ffffc200008aa000.
console [netcon0] enabled
Linux version 2.6.24-rc8-ga9f7faa5 (root@hunter) (gcc version 4.1.2 (Gentoo=
 4.1.2 p1.0.2)) #1 SMP Wed Jan 16 18:26:59 CET 2008
Command line: root=3D/dev/sda1 console=3DttyS0,115200
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008dc00 (usable)
 BIOS-e820: 000000000008dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077e70000 (usable)
 BIOS-e820: 0000000077e70000 - 0000000077e7a000 (ACPI data)
 BIOS-e820: 0000000077e7a000 - 0000000077f00000 (ACPI NVS)
 BIOS-e820: 0000000077f00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
end_pfn_map =3D 1048576
early_ioremap(000000000000040e, 00000002) =3D> -000002105539570
early_iounmap(ffffffff8280040e, 00000002)
early_ioremap(000000000009e000, 00000002) =3D> -000002104893440
early_iounmap(ffffffff8289e000, 00000002)
early_ioremap(0000000000008000, 00001000) =3D> -000002105507840
early_ioremap(0000000000009000, 00001000) =3D> -000002103406592
early_iounmap(ffffffff82a09000, 00001000)
early_ioremap(000000000000a000, 00001000) =3D> -000002103402496
early_iounmap(ffffffff82a0a000, 00001000)
early_ioremap(000000000000b000, 00001000) =3D> -000002103398400
early_iounmap(ffffffff82a0b000, 00001000)
early_ioremap(000000000000c000, 00001000) =3D> -000002103394304
early_iounmap(ffffffff82a0c000, 00001000)
early_iounmap(ffffffff82808000, 00001000)
early_ioremap(00000000000f0000, 00010000) =3D> -000002104557568
DMI present.
early_ioremap(0000000077eec000, 00000491) =3D> -000002102476800
early_iounmap(ffffffff82aec000, 00000491)
early_ioremap(00000000000e0000, 00020000) =3D> -000002102525952
early_iounmap(ffffffff82ae0000, 00020000)
early_ioremap(00000000000f7870, 00000024) =3D> -000002102429584
ACPI: RSDP 000F7870, 0024 (r2 PTLTD )
early_iounmap(ffffffff82af7870, 00000024)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
ACPI: XSDT 77E72CC4, 004C (r1 PTLTD      XSDT    6040000  LTP        0)
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e7985c, 00000024) =3D> -000002102945700
ACPI: FACP 77E7985C, 00F4 (r3 AMD    DUNE      6040000 ATI     F4240)
early_iounmap(ffffffff82a7985c, 00000024)
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002102945700
early_iounmap(ffffffff82a7985c, 000000f4)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
ACPI: DSDT 77E72D10, 6AD8 (r1    ATI    SB400  6040000 MSFT  100000E)
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e7afc0, 00000024) =3D> -000002102939712
ACPI: FACS 77E7AFC0, 0040
early_iounmap(ffffffff82a7afc0, 00000024)
early_ioremap(0000000077e79950, 00000024) =3D> -000002102945456
ACPI: TCPA 77E79950, 0032 (r1 Phoeni  x        6040000  TL         0)
early_iounmap(ffffffff82a79950, 00000024)
early_ioremap(0000000077e79982, 00000024) =3D> -000002102945406
ACPI: SSDT 77E79982, 0544 (r1 AMD    POWERNOW  6040000 AMD         1)
early_iounmap(ffffffff82a79982, 00000024)
early_ioremap(0000000077e79ec6, 00000024) =3D> -000002102944058
ACPI: SRAT 77E79EC6, 00C0 (r1 AMD    HAMMER    6040000 AMD         1)
early_iounmap(ffffffff82a79ec6, 00000024)
early_ioremap(0000000077e79f86, 00000024) =3D> -000002102943866
ACPI: APIC 77E79F86, 007A (r1 PTLTD      APIC    6040000  LTP        0)
early_iounmap(ffffffff82a79f86, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002102944058
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002100846906
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002098749754
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000077e70000
early_ioremap(0000000000000000, 00000400) =3D> -000002097152000
early_iounmap(ffffffff83000000, 00000400)
early_ioremap(000000000009fc00, 00000400) =3D> -000002096497664
early_iounmap(ffffffff8309fc00, 00000400)
early_ioremap(00000000000f0000, 00010000) =3D> -000002096168960
early_iounmap(ffffffff830f0000, 00010000)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      141
    0:      256 ->   491120
ATI board detected. Disabling timer routing over 8254.
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002096654244
ACPI: PM-Timer IO Port: 0x8008
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002094555258
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002092458106
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002090360954
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002088263802
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002086166650
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002084069498
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002081972346
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30368 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 484281
Policy zone: DMA32
Kernel command line: root=3D/dev/sda1 console=3DttyS0,115200
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2288.275 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Memory: 1928912k/1964480k available (3073k kernel code, 35108k reserved, 17=
37k data, 308k init)
Calibrating delay using timer specific routine.. 4581.21 BogoMIPS (lpj=3D91=
62431)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Detected 12.436 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4576.70 BogoMIPS (lpj=3D91=
53416)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4576.71 BogoMIPS (lpj=3D91=
53428)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4576.73 BogoMIPS (lpj=3D91=
53467)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
Brought up 4 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=3DLinux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
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
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:09: iomem range 0x0-0xfff could not be reserved
PCI: Bridge: 0000:00:01.0
Time: acpi_pm clocksource has been installed.
  IO window: 9000-9fff
  MEM window: c0000000-c00fffff
  PREFETCH window: c8000000-cfffffff
PCI: Bridge: 0000:00:14.4
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [C000] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 16 (level, low) -> IRQ 16
3c59x: Donald Becker and others.
0000:02:04.0: 3Com PCI 3c905C Tornado at ffffc200008aa000.
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1060-0x1067, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1068-0x106f, BIOS settings: hdc:DMA, hdd:pio
hdc: SONY DVD-ROM DDU1615, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 40X DVD-ROM drive, 254kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ACPI: PCI interrupt for device 0000:00:12.0 disabled
sata_sil: probe of 0000:00:12.0 failed with error -12
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SAS Host driver 3.04.06
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xc0402000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 19, io mem 0xc0400000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 19, io mem 0xc0401000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:4=
2 2007 UTC).
ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
AC'97 space ioremap problem
ACPI: PCI interrupt for device 0000:00:14.5 disabled
ATI IXP AC97 controller: probe of 0000:00:14.5 failed with error -5
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Phenom(tm) 9600 Quad-Core Processor processors (4 =
cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x0 did 0x0 (2300 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (1150 MHz)
VFS: Cannot open root device "sda1" or unknown-block(0,0)
Please append a correct "root=3D" boot option; here are the available parti=
tions:
1600    4194302 hdc driver: ide-cdrom
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0=
,0)




--IS0zKkzwUGydFO0o
Content-Type: text/plain;
 charset=utf-8
Content-Disposition: attachment;
 filename=boot-working.log
Content-Transfer-Encoding: quoted-printable

  Booting '(hunter) x86/mm (last working)'

kernel=3D/tftpboot/aherrma3/hunter-x86-mm-working root=3D/dev/sda1 consol=
e=3DttyS0,11
5200
   [Linux-bzImage, setup=3D0x2a00, size=3D0x24a578]
boot
Issuing RESET:
Linux version 2.6.24-rc8-g2ea3cf43 (root@hunter) (gcc version 4.1.2 (Gent=
oo 4.1.2 p1.0.2)) #3 SMP Wed Jan 16 19:17:19 CET 2008
Command line: root=3D/dev/sda1 console=3DttyS0,115200
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008dc00 (usable)
 BIOS-e820: 000000000008dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077e70000 (usable)
 BIOS-e820: 0000000077e70000 - 0000000077e7a000 (ACPI data)
 BIOS-e820: 0000000077e7a000 - 0000000077f00000 (ACPI NVS)
 BIOS-e820: 0000000077f00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
end_pfn_map =3D 1048576
early_ioremap(000000000000040e, 00000002) =3D> -000002105539570
early_iounmap(ffffffff8280040e, 00000002)
early_ioremap(000000000009e000, 00000002) =3D> -000002104893440
early_iounmap(ffffffff8289e000, 00000002)
early_ioremap(0000000000008000, 00001000) =3D> -000002105507840
early_ioremap(0000000000009000, 00001000) =3D> -000002103406592
early_iounmap(ffffffff82a09000, 00001000)
early_ioremap(000000000000a000, 00001000) =3D> -000002103402496
early_iounmap(ffffffff82a0a000, 00001000)
early_ioremap(000000000000b000, 00001000) =3D> -000002103398400
early_iounmap(ffffffff82a0b000, 00001000)
early_iounmap(ffffffff82808000, 00001000)
early_ioremap(00000000000f0000, 00010000) =3D> -000002104557568
DMI present.
early_ioremap(0000000077eec000, 00000491) =3D> -000002102476800
early_iounmap(ffffffff82aec000, 00000491)
early_ioremap(00000000000e0000, 00020000) =3D> -000002102525952
early_iounmap(ffffffff82ae0000, 00020000)
early_ioremap(00000000000f7870, 00000024) =3D> -000002102429584
ACPI: RSDP 000F7870, 0024 (r2 PTLTD )
early_iounmap(ffffffff82af7870, 00000024)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
ACPI: XSDT 77E72CC4, 004C (r1 PTLTD      XSDT    6040000  LTP        0)
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e7985c, 00000024) =3D> -000002102945700
ACPI: FACP 77E7985C, 00F4 (r3 AMD    DUNE      6040000 ATI     F4240)
early_iounmap(ffffffff82a7985c, 00000024)
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002102945700
early_iounmap(ffffffff82a7985c, 000000f4)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
ACPI: DSDT 77E72D10, 6AD8 (r1    ATI    SB400  6040000 MSFT  100000E)
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e7afc0, 00000024) =3D> -000002102939712
ACPI: FACS 77E7AFC0, 0040
early_iounmap(ffffffff82a7afc0, 00000024)
early_ioremap(0000000077e79950, 00000024) =3D> -000002102945456
ACPI: TCPA 77E79950, 0032 (r1 Phoeni  x        6040000  TL         0)
early_iounmap(ffffffff82a79950, 00000024)
early_ioremap(0000000077e79982, 00000024) =3D> -000002102945406
ACPI: SSDT 77E79982, 0544 (r1 AMD    POWERNOW  6040000 AMD         1)
early_iounmap(ffffffff82a79982, 00000024)
early_ioremap(0000000077e79ec6, 00000024) =3D> -000002102944058
ACPI: SRAT 77E79EC6, 00C0 (r1 AMD    HAMMER    6040000 AMD         1)
early_iounmap(ffffffff82a79ec6, 00000024)
early_ioremap(0000000077e79f86, 00000024) =3D> -000002102943866
ACPI: APIC 77E79F86, 007A (r1 PTLTD      APIC    6040000  LTP        0)
early_iounmap(ffffffff82a79f86, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002102944058
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002100846906
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002098749754
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000077e70000
early_ioremap(0000000000000000, 00000400) =3D> -000002097152000
early_iounmap(ffffffff83000000, 00000400)
early_ioremap(000000000009fc00, 00000400) =3D> -000002096497664
early_iounmap(ffffffff8309fc00, 00000400)
early_ioremap(00000000000f0000, 00010000) =3D> -000002096168960
early_iounmap(ffffffff830f0000, 00010000)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      141
    0:      256 ->   491120
ATI board detected. Disabling timer routing over 8254.
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002096654244
ACPI: PM-Timer IO Port: 0x8008
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002094555258
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002092458106
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002090360954
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002088263802
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002086166650
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002084069498
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002081972346
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30112 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 4842=
82
Policy zone: DMA32
Kernel command line: root=3D/dev/sda1 console=3DttyS0,115200
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2288.366 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Memory: 1928920k/1964480k available (3069k kernel code, 35100k reserved, =
1738k data, 304k init)
Calibrating delay using timer specific routine.. 4581.34 BogoMIPS (lpj=3D=
9162692)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Detected 12.436 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4576.90 BogoMIPS (lpj=3D=
9153811)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4576.92 BogoMIPS (lpj=3D=
9153854)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4576.93 BogoMIPS (lpj=3D=
9153875)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
Brought up 4 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=3DLinux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a=
 report
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
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
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:09: iomem range 0x0-0xfff could not be reserved
PCI: Bridge: 0000:00:01.0
Time: acpi_pm clocksource has been installed.
  IO window: 9000-9fff
  MEM window: c0000000-c00fffff
  PREFETCH window: c8000000-cfffffff
PCI: Bridge: 0000:00:14.4
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [C000] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
=EF=BF=BD=D2=82
  =EF=BF=BD ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 16 (level, low) -> IRQ 16
3c59x: Donald Becker and others.
0000:02:04.0: 3Com PCI 3c905C Tornado at ffffc200008aa000.
console [netcon0] enabled
Linux version 2.6.24-rc8-g2ea3cf43 (root@hunter) (gcc version 4.1.2 (Gent=
oo 4.1.2 p1.0.2)) #3 SMP Wed Jan 16 19:17:19 CET 2008
Command line: root=3D/dev/sda1 console=3DttyS0,115200
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008dc00 (usable)
 BIOS-e820: 000000000008dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077e70000 (usable)
 BIOS-e820: 0000000077e70000 - 0000000077e7a000 (ACPI data)
 BIOS-e820: 0000000077e7a000 - 0000000077f00000 (ACPI NVS)
 BIOS-e820: 0000000077f00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
end_pfn_map =3D 1048576
early_ioremap(000000000000040e, 00000002) =3D> -000002105539570
early_iounmap(ffffffff8280040e, 00000002)
early_ioremap(000000000009e000, 00000002) =3D> -000002104893440
early_iounmap(ffffffff8289e000, 00000002)
early_ioremap(0000000000008000, 00001000) =3D> -000002105507840
early_ioremap(0000000000009000, 00001000) =3D> -000002103406592
early_iounmap(ffffffff82a09000, 00001000)
early_ioremap(000000000000a000, 00001000) =3D> -000002103402496
early_iounmap(ffffffff82a0a000, 00001000)
early_ioremap(000000000000b000, 00001000) =3D> -000002103398400
early_iounmap(ffffffff82a0b000, 00001000)
early_iounmap(ffffffff82808000, 00001000)
early_ioremap(00000000000f0000, 00010000) =3D> -000002104557568
DMI present.
early_ioremap(0000000077eec000, 00000491) =3D> -000002102476800
early_iounmap(ffffffff82aec000, 00000491)
early_ioremap(00000000000e0000, 00020000) =3D> -000002102525952
early_iounmap(ffffffff82ae0000, 00020000)
early_ioremap(00000000000f7870, 00000024) =3D> -000002102429584
ACPI: RSDP 000F7870, 0024 (r2 PTLTD )
early_iounmap(ffffffff82af7870, 00000024)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e72cc4, 00000024) =3D> -000002102973244
ACPI: XSDT 77E72CC4, 004C (r1 PTLTD      XSDT    6040000  LTP        0)
early_iounmap(ffffffff82a72cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) =3D> -000002102973244
early_iounmap(ffffffff82a72cc4, 0000004c)
early_ioremap(0000000077e7985c, 00000024) =3D> -000002102945700
ACPI: FACP 77E7985C, 00F4 (r3 AMD    DUNE      6040000 ATI     F4240)
early_iounmap(ffffffff82a7985c, 00000024)
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002102945700
early_iounmap(ffffffff82a7985c, 000000f4)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
ACPI: DSDT 77E72D10, 6AD8 (r1    ATI    SB400  6040000 MSFT  100000E)
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e7afc0, 00000024) =3D> -000002102939712
ACPI: FACS 77E7AFC0, 0040
early_iounmap(ffffffff82a7afc0, 00000024)
early_ioremap(0000000077e79950, 00000024) =3D> -000002102945456
ACPI: TCPA 77E79950, 0032 (r1 Phoeni  x        6040000  TL         0)
early_iounmap(ffffffff82a79950, 00000024)
early_ioremap(0000000077e79982, 00000024) =3D> -000002102945406
ACPI: SSDT 77E79982, 0544 (r1 AMD    POWERNOW  6040000 AMD         1)
early_iounmap(ffffffff82a79982, 00000024)
early_ioremap(0000000077e79ec6, 00000024) =3D> -000002102944058
ACPI: SRAT 77E79EC6, 00C0 (r1 AMD    HAMMER    6040000 AMD         1)
early_iounmap(ffffffff82a79ec6, 00000024)
early_ioremap(0000000077e79f86, 00000024) =3D> -000002102943866
ACPI: APIC 77E79F86, 007A (r1 PTLTD      APIC    6040000  LTP        0)
early_iounmap(ffffffff82a79f86, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) =3D> -000002102973168
early_iounmap(ffffffff82a72d10, 00000024)
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002102944058
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002100846906
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
early_ioremap(0000000077e79ec6, 000000c0) =3D> -000002098749754
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000077e70000
early_ioremap(0000000000000000, 00000400) =3D> -000002097152000
early_iounmap(ffffffff83000000, 00000400)
early_ioremap(000000000009fc00, 00000400) =3D> -000002096497664
early_iounmap(ffffffff8309fc00, 00000400)
early_ioremap(00000000000f0000, 00010000) =3D> -000002096168960
early_iounmap(ffffffff830f0000, 00010000)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      141
    0:      256 ->   491120
ATI board detected. Disabling timer routing over 8254.
early_ioremap(0000000077e7985c, 000000f4) =3D> -000002096654244
ACPI: PM-Timer IO Port: 0x8008
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002094555258
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002092458106
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002090360954
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x0=EF=BF=BD=EF=BF=BD=EF=BF=BDlapic_id[0x01] enabled=
)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002088263802
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002086166650
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002084069498
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
early_ioremap(0000000077e79f86, 0000007a) =3D> -000002081972346
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30112 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 4842=
82
Policy zone: DMA32
Kernel command line: root=3D/dev/sda1 console=3DttyS0,115200
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2288.366 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Memory: 1928920k/1964480k available (3069k kernel code, 35100k reserved, =
1738k data, 304k init)
Calibrating delay using timer specific routine.. 4581.34 BogoMIPS (lpj=3D=
9162692)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Detected 12.436 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4576.90 BogoMIPS (lpj=3D=
9153811)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4576.92 BogoMIPS (lpj=3D=
9153854)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4576.93 BogoMIPS (lpj=3D=
9153875)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
Brought up 4 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=3DLinux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a=
 report
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
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
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:09: iomem range 0x0-0xfff could not be reserved
PCI: Bridge: 0000:00:01.0
Time: acpi_pm clocksource has been installed.
  IO window: 9000-9fff
  MEM window: c0000000-c00fffff
  PREFETCH window: c8000000-cfffffff
PCI: Bridge: 0000:00:14.4
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [C000] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 16 (level, low) -> IRQ 16
3c59x: Donald Becker and others.
0000:02:04.0: 3Com PCI 3c905C Tornado at ffffc200008aa000.
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1060-0x1067, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1068-0x106f, BIOS settings: hdc:DMA, hdd:pio
hdc: SONY DVD-ROM DDU1615, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 40X DVD-ROM drive, 254kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc0403080 irq 22
ata2: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc04030c0 irq 22
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3120811AS, 3.AAE, max UDMA/133
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3120811AS      3.AA PQ: 0 ANSI=
: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SAS Host driver 3.04.06
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xc0402000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 19, io mem 0xc0400000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 19, io mem 0xc0401000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16=
:42 2007 UTC).
ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
ALSA device list:
  #0: ATI IXP rev 80 with ALC655 at 0xc0403800, irq 17
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Phenom(tm) 9600 Quad-Core Processor processors (=
4 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x0 did 0x0 (2300 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (1150 MHz)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 304k freed
INIT: version 2.86 booting

Gentoo Linux; http://www.gentoo.org/
 Copyright 1999-2007 Gentoo Foundation; Distributed under the GPLv2

Press I to enter interactive boot mode

 * Mounting proc at /proc ...                                            =
 [ ok ]
 * Mounting sysfs at /sys ...                                            =
 [ ok ]
 * Mounting /dev for udev ...                                            =
 [ ok ]
 * Seeding /dev with needed nodes ...                                    =
 [ ok ]
 * Starting udevd ...                                                    =
 [ ok ]
 * Populating /dev with existing devices through uevents ...             =
 [ ok ]
 * Letting udev process events ...                                       =
 [ ok ]
 * Finalizing udev configuration ...                                     =
 [ ok ]
 * Mounting devpts at /dev/pts ...                                       =
 [ ok ]
 * Checking root filesystem .../dev/sda1: clean, 596867/2443200 files, 34=
03917/4885760 blocks
                                           [ ok ]
 * Remounting root filesystem read/write ...                             =
 [ ok ]

    <snip>

--IS0zKkzwUGydFO0o--


