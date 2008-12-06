Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYLFMQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYLFMQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYLFMQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:16:47 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:49679 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbYLFMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:16:43 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ohci1394: "irq 19: nobody cared" during resume from suspend to ram
Date: Sat, 6 Dec 2008 13:16:37 +0100
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, Jarod Wilson <jwilson@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_m0mOJL6UpiStai2"
Message-Id: <200812061316.38460.elendil@planet.nl>
X-OriginalArrivalTime: 06 Dec 2008 12:16:39.0144 (UTC) FILETIME=[7DA7E680:01C9579C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_m0mOJL6UpiStai2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

After resume from suspend to RAM dmesg on my HP 2510p notebook shows:

irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #67
Call Trace:
 <IRQ>  [<ffffffffa00ee9e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
 [<ffffffff8026aa4d>] __report_bad_irq+0x38/0x87
 [<ffffffff8026abaa>] note_interrupt+0x10e/0x174
 [<ffffffff8026b262>] handle_fasteoi_irq+0xa7/0xd1
 [<ffffffff8020eb87>] do_IRQ+0x73/0xe4
 [<ffffffff8020c626>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffffa0012606>] ? acpi_idle_enter_bm+0x26b/0x2b2 [processor]
 [<ffffffffa00125fc>] ? acpi_idle_enter_bm+0x261/0x2b2 [processor]
 [<ffffffff8024f30f>] ? notifier_call_chain+0x33/0x5b
 [<ffffffff803b9c64>] ? cpuidle_idle_call+0x8c/0xc4
 [<ffffffff8020b312>] ? cpu_idle+0x4a/0x9a
 [<ffffffff8042c5c8>] ? rest_init+0x5c/0x5e
handlers:
[<ffffffffa00ee981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
Disabling IRQ #19

Attached a dmesg that includes one suspend/resume cycle.
I only get the error once on resume, not at any other time.

While looking at the suspend and resume functions I noticed that the
suspend function calls free_irq before saving the PCI config, but there
is no corresponding request_irq in the resume function.

So I naively tried the following patch:

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 46610b0..3f283df 100644
=2D-- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -2570,6 +2570,14 @@ static int pci_resume(struct pci_dev *dev)
 		fw_error("pci_enable_device failed\n");
 		return err;
 	}
+	if (request_irq(dev->irq, irq_handler,
+			IRQF_SHARED, ohci_driver_name, ohci)) {
+		fw_error("Failed to allocate shared interrupt %d.\n",
+			 dev->irq);
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  ohci->config_rom, ohci->config_rom_bus);
+		return -EIO;
+	}
=20
 	return ohci_enable(&ohci->card, NULL, 0);
 }

And, h=E9 presto, the error disappeared, and that's the only relevant diff
with a kernel without the patch.

Only after testing that did I notice that I had copied the call to
request_irq from ohci_enable, but that function is already getting called
immediately afterwards!

So it seems that the real problem is a timing issue and request_irq is
somehow being called too late during resume?

Could it be that the device is left in a half-active state (or that its
PCI config is saved while in a half-active state), resulting in IRQs
getting through before request_irq is executed in ohci_enable?

Note that I don't actually use firewire.

Note also that both with and without the error IRQ 19 is listed the same
in /proc/interrupts (and even with rather a high count for a device that
is not in use; this is shortly after a clean reboot + suspend/resume).

Cheers,
=46JP

$ cat /proc/interrupts
           CPU0       CPU1
  0:      18744      10269   IO-APIC-edge      timer
  1:        115         41   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:        454        152   IO-APIC-fasteoi   acpi
 12:        342        139   IO-APIC-edge      i8042
 14:       4243       3517   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         46         11   IO-APIC-fasteoi   uhci_hcd:usb1, i915@pci:0000=
:00:02.0
 17:       1780       1583   IO-APIC-fasteoi   uhci_hcd:usb3, HDA Intel
 18:          2          2   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb7=
, yenta
 19:      99968         33   IO-APIC-fasteoi   ohci1394
 20:         33         12   IO-APIC-fasteoi   ehci_hcd:usb4, uhci_hcd:usb5=
, mmc0
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
508:       1335       1039   PCI-MSI-edge      iwlagn
NMI:          0          0   Non-maskable interrupts
LOC:      10382      14256   Local timer interrupts
RES:      10016       9596   Rescheduling interrupts
CAL:        173         36   Function call interrupts
TLB:         41         23   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0

--Boundary-00=_m0mOJL6UpiStai2
Content-Type: text/plain;
  charset="iso-8859-1";
  name="2.6.28-rc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="2.6.28-rc7"

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc7-test (root@faramir) (gcc version 4.3.2 (Debian 4.3.2-1) ) #66 SMP Thu Dec 4 00:22:46 CET 2008
Command line: root=/dev/mapper/main-root ro vga=791 quiet
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e7b0000 (usable)
 BIOS-e820: 000000007e7b0000 - 000000007e7c5400 (reserved)
 BIOS-e820: 000000007e7c5400 - 000000007e7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007e7e7fb8 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7e7b0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000007e7b0000
 0000000000 - 007e600000 page 2M
 007e600000 - 007e7b0000 page 4k
kernel direct mapping tables up to 7e7b0000 @ 8000-c000
last_map_addr: 7e7b0000 end: 7e7b0000
RAMDISK: 37ab7000 - 37fef5ef
ACPI: RSDP 000F7960, 0024 (r2 HP    )
ACPI: XSDT 7E7C81C8, 007C (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 7E7C8084, 00F4 (r4 HP     30C9            3 HP          1)
ACPI: DSDT 7E7C8538, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
ACPI: FACS 7E7E7D80, 0040
ACPI: SLIC 7E7C8244, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 7E7C83BC, 0038 (r1 HP     30C9            1 HP          1)
ACPI: APIC 7E7C83F4, 0068 (r1 HP     30C9            1 HP          1)
ACPI: MCFG 7E7C845C, 003C (r1 HP     30C9            1 HP          1)
ACPI: TCPA 7E7C8498, 0032 (r2 HP     30C9            1 HP          1)
ACPI: ASF! 7E7C84CC, 0069 (r16 HP     CHIMAYU         1 HP          0)
ACPI: SSDT 7E7DB9BC, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
ACPI: SSDT 7E7DC640, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT 7E7DC89F, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT 7E7DC945, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 007e7b0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000074c510]    TEXT DATA BSS ==> [0000200000 - 000074c510]
  #3 [0037ab7000 - 0037fef5ef]          RAMDISK ==> [0037ab7000 - 0037fef5ef]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
 [ffffe20000000000-ffffe20001ffffff] PMD -> [ffff880001200000-ffff8800031fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007e7b0
On node 0 totalpages: 517967
  DMA zone: 64 pages used for memmap
  DMA zone: 1457 pages reserved
  DMA zone: 2478 pages, LIFO batch:0
  DMA32 zone: 8031 pages used for memmap
  DMA32 zone: 505937 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7f000000:7fc00000)
PERCPU: Allocating 49152 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 508415
Kernel command line: root=/dev/mapper/main-root ro vga=791 quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1329.894 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 2024352k/2072256k available (2302k kernel code, 388k absent, 46896k reserved, 1507k data, 316k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 2659.78 BogoMIPS (lpj=5319576)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2659.97 BogoMIPS (lpj=5319944)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (5319.76 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 1400 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at f8000000 - fbffffff
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [C003] (0000:00)
pci 0000:00:02.0: reg 10 64bit mmio: [0xe0400000-0xe04fffff]
pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 20 io port: [0x2000-0x2007]
pci 0000:00:02.1: reg 10 64bit mmio: [0xe0500000-0xe05fffff]
pci 0000:00:03.0: reg 10 64bit mmio: [0xe0600000-0xe060000f]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: reg 10 io port: [0x2008-0x200f]
pci 0000:00:03.2: reg 14 io port: [0x2010-0x2013]
pci 0000:00:03.2: reg 18 io port: [0x2018-0x201f]
pci 0000:00:03.2: reg 1c io port: [0x2020-0x2023]
pci 0000:00:03.2: reg 20 io port: [0x2030-0x203f]
pci 0000:00:03.3: reg 10 io port: [0x2040-0x2047]
pci 0000:00:03.3: reg 14 32bit mmio: [0xe0601000-0xe0601fff]
pci 0000:00:19.0: reg 10 32bit mmio: [0xe0620000-0xe063ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xe0640000-0xe0640fff]
pci 0000:00:19.0: reg 18 io port: [0x2060-0x207f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x2080-0x209f]
pci 0000:00:1a.1: reg 20 io port: [0x20a0-0x20bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xe0641000-0xe06413ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xe0644000-0xe0647fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x20c0-0x20df]
pci 0000:00:1d.1: reg 20 io port: [0x20e0-0x20ff]
pci 0000:00:1d.2: reg 20 io port: [0x2100-0x211f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xe0648000-0xe06483ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x2120-0x212f]
pci 0000:10:00.0: reg 10 64bit mmio: [0xe0000000-0xe0001fff]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xe0000000-0xe00fffff]
pci 0000:02:06.0: reg 10 32bit mmio: [0xe0100000-0xe0100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: reg 10 32bit mmio: [0xe0101000-0xe01017ff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: reg 10 32bit mmio: [0xe0102000-0xe01020ff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: reg 10 32bit mmio: [0xe0103000-0xe01030ff]
pci 0000:02:06.3: supports D1 D2
pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.3: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xe0100000-0xe03fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception (pci_link-0189): AE_NOT_FOUND, Evaluating _PRS [20080926]
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD GART found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved
system 00:0a: ioport range 0x500-0x55f has been reserved
system 00:0a: ioport range 0x800-0x80f has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x2f8-0x2ff has been reserved
system 00:0c: ioport range 0x3f8-0x3ff has been reserved
system 00:0c: ioport range 0x1000-0x107f has been reserved
system 00:0c: ioport range 0x1100-0x113f has been reserved
system 00:0c: ioport range 0x1200-0x121f has been reserved
system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:0c: iomem range 0xfed90000-0xfed99fff has been reserved
system 00:0d: iomem range 0xcee00-0xcffff has been reserved
system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
system 00:0d: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xe0000000-0xe00fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
pci 0000:02:06.0:   PREFETCH window: 0x80000000-0x83ffffff
pci 0000:02:06.0:   MEM window: 0x84000000-0x87ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xe0100000-0xe03fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000080000000-0x00000083ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 08 index 0 mmio: [0x0-0x0]
bus: 08 index 1 mmio: [0x0-0x0]
bus: 08 index 2 mmio: [0x0-0x0]
bus: 08 index 3 mmio: [0x0-0x0]
bus: 10 index 0 mmio: [0x0-0x0]
bus: 10 index 1 mmio: [0xe0000000-0xe00fffff]
bus: 10 index 2 mmio: [0x0-0x0]
bus: 10 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0x3000-0x3fff]
bus: 02 index 1 mmio: [0xe0100000-0xe03fffff]
bus: 02 index 2 mmio: [0x80000000-0x83ffffff]
bus: 02 index 3 io port: [0x00-0xffff]
bus: 02 index 4 mmio: [0x000000-0xffffffffffffffff]
bus: 03 index 0 io port: [0x3000-0x30ff]
bus: 03 index 1 io port: [0x3400-0x34ff]
bus: 03 index 2 mmio: [0x80000000-0x83ffffff]
bus: 03 index 3 mmio: [0x84000000-0x87ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 5345k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1228383321.133:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3965
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 511 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pcieport-driver 0000:00:1c.1: irq 510 for MSI/MSI-X
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20004100000, using 3072k, total 7616k
vesafb: mode is 1024x768x16, linelength=2048, pages=3
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS0 at I/O 0x2040 (irq = 17) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 17
rtc_cmos 00:06: setting system clock to 2008-12-04 09:35:21 UTC (1228383321)
Freeing unused kernel memory: 316k freed
input: AT Translated Set 2 keyboard as /class/input/input0
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [C3B1] (off)
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [C3B2] (off)
fan PNP0C0B:02: registered as cooling_device2
ACPI: Fan [C3C8] (off)
fan PNP0C0B:03: registered as cooling_device3
ACPI: Fan [C3C9] (off)
fan PNP0C0B:04: registered as cooling_device4
ACPI: Fan [C3CA] (off)
fan PNP0C0B:05: registered as cooling_device5
ACPI: Fan [C3CB] (off)
fan PNP0C0B:06: registered as cooling_device6
ACPI: Fan [C3CC] (off)
ACPI: SSDT 7E7DBD42, 027F (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT 7E7DC046, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device7
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7E7DBC7A, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT 7E7DBFC1, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device8
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (50 C)
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (48 C)
thermal LNXTHERM:04: registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (36 C)
thermal LNXTHERM:05: registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (28 C)
thermal LNXTHERM:06: registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (0 C)
SCSI subsystem initialized
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 509 for MSI/MSI-X
uhci_hcd: USB Universal Host Controller Interface driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
libata version 3.00 loaded.
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
ricoh-mmc: Controller is now disabled.
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
mmc0: SDHCI controller on PCI [0000:02:06.2] using PIO
ohci1394 0000:02:06.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:5e:3b:04
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002080
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000020a0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0648000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020c0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020e0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002100
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
pata_acpi 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pata_acpi 0000:00:03.2: setting latency timer to 64
pata_acpi 0000:00:03.2: PCI INT C disabled
pata_acpi 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_acpi 0000:00:1f.1: setting latency timer to 64
pata_acpi 0000:00:1f.1: PCI INT A disabled
Uniform Multi-Platform E-IDE driver
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: quirky BIOS, skipping spindown on poweroff and hibernation
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2120 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2128 irq 15
ata1.00: ATA-7: SAMSUNG HS122JC, GQ100-04, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA 
ata1.01: ATAPI: MATSHITADVD-RAM UJ-852S, 1.02, max MWDMA2
ata1.00: configured for UDMA/100
ata1.01: configured for MWDMA2
ata2: port disabled. ignoring.
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HS122JC  GQ10 PQ: 0 ANSI: 5
scsi 0:0:1:0: CD-ROM            MATSHITA DVD-RAM UJ-852S  1.02 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 <<4>Driver 'sr' needs updating - please use bus_type methods
 sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 0:0:1:0: Attached scsi generic sg1 type 5
Clocksource tsc unstable (delta = -103132180 ns)
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 5-2: new full speed USB device using uhci_hcd and address 2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929192210]
usb 5-2: configuration #1 chosen from 1 choice
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [C2BF]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [C155]
ACPI: AC Adapter [C23B] (off-line)
ACPI: Battery Slot [C23D] (battery present)
acpi device:02: registered as cooling_device9
input: Video Bus as /class/input/input4
ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
Registered led device: hp:red:hddprotection
leds-hp-disk driver loaded.
ACPI: WMI: Mapper loaded
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: EU
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /class/input/input5
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x80000000 - 0x83ffffff
input: PS/2 Generic Mouse as /class/input/input6
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:10:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
iwlagn 0000:10:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: SynPS/2 Synaptics TouchPad as /class/input/input7
EXT3 FS on dm-1, internal journal
loop: module loaded
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2097144k swap on /dev/mapper/main-swap.  Priority:-1 extents:1 across:2097144k
iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
iwlagn 0000:10:00.0: irq 508 for MSI/MSI-X
iwlagn 0000:10:00.0: firmware: requesting iwlwifi-4965-2.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: authenticate with AP 00:14:c1:38:e5:15
wlan0: authenticated
wlan0: associate with AP 00:14:c1:38:e5:15
wlan0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
wlan0: associated
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
wlan0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level CPU
   groups: 0-1
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
pci 0000:00:02.0: PCI INT A disabled
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI handle has no context!
sdhci-pci 0000:02:06.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
iwlagn 0000:10:00.0: PCI INT A disabled
ata2: port disabled. ignoring.
ata_piix 0000:00:1f.1: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
e1000e 0000:00:19.0: PCI INT A disabled
ACPI handle has no context!
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2659.98 BogoMIPS (lpj=5319961)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 is up
ACPI: Waking up from system sleep state S3
APIC error on CPU1: 00(40)
ACPI: EC: non-query interrupt received, switching to interrupt mode
pci 0000:00:02.0: restoring config space at offset 0x8 (was 0x1, writing 0x2001)
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe0500004)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
pci 0000:00:03.2: restoring config space at offset 0x8 (was 0x1, writing 0x2031)
pci 0000:00:03.2: restoring config space at offset 0x7 (was 0x1, writing 0x2021)
pci 0000:00:03.2: restoring config space at offset 0x6 (was 0x1, writing 0x2019)
pci 0000:00:03.2: restoring config space at offset 0x5 (was 0x1, writing 0x2011)
pci 0000:00:03.2: restoring config space at offset 0x4 (was 0x1, writing 0x2009)
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00001)
serial 0000:00:03.3: restoring config space at offset 0xf (was 0x200, writing 0x20a)
serial 0000:00:03.3: restoring config space at offset 0x5 (was 0x0, writing 0xe0601000)
serial 0000:00:03.3: restoring config space at offset 0x4 (was 0x1, writing 0x2041)
serial 0000:00:03.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x2061)
e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xe0640000)
e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 509 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
usb usb1: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
usb usb3: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30b)
ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0641000)
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x4010a)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x80800)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x4020a)
pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xe000e000)
pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
pcieport-driver 0000:00:1c.1: setting latency timer to 64
uhci_hcd 0000:00:1d.0: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x20c1)
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x20e1)
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x83f18001)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x22803030)
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x10a)
ata_piix 0000:00:1f.1: restoring config space at offset 0x8 (was 0xc01, writing 0x2121)
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
ata2: port disabled. ignoring.
ACPI Exception (exoparg2-0444): AE_AML_PACKAGE_LIMIT, Index (000000005) is beyond end of object [20080926]
ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.C2C3] (Node ffff88007e01de80), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007e043dc0), AE_AML_PACKAGE_LIMIT
ata1: ACPI set timing mode failed (status=0x300b)
iwlagn 0000:10:00.0: enabling device (0000 -> 0002)
iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:10:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
iwlagn 0000:10:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xe0000004)
iwlagn 0000:10:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
iwlagn 0000:10:00.0: irq 508 for MSI/MSI-X
yenta_cardbus 0000:02:06.0: restoring config space at offset 0xf (was 0x3000100, writing 0x580010b)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 0x87fff000)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 0x84000000)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 0x83fff000)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 0x80000000)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0060302)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 0xe0100000)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, writing 0x82a800)
yenta_cardbus 0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
ohci1394 0000:02:06.1: restoring config space at offset 0xf (was 0x4020200, writing 0x4020205)
ohci1394 0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 0xe0101000)
ohci1394 0000:02:06.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
ohci1394 0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
sd 0:0:0:0: [sda] Starting disk
ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
ata1.01: ACPI cmd ef/03:40:00:00:00:b0 filtered out
ata1.00: ACPI cmd ef/03:01:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: configured for UDMA/100
ata1.01: configured for MWDMA2
ata1.00: configured for UDMA/100
ata1.01: configured for MWDMA2
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb 1-1: reset full speed USB device using uhci_hcd and address 2
irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.28-rc7-test #66
Call Trace:
 <IRQ>  [<ffffffffa01039e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
 [<ffffffff8026aa4d>] __report_bad_irq+0x38/0x87
 [<ffffffff8026abaa>] note_interrupt+0x10e/0x174
 [<ffffffff8026b262>] handle_fasteoi_irq+0xa7/0xd1
 [<ffffffff8020eb87>] do_IRQ+0x73/0xe4
 [<ffffffff8020c626>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffffa0012606>] ? acpi_idle_enter_bm+0x26b/0x2b2 [processor]
 [<ffffffffa00125fc>] ? acpi_idle_enter_bm+0x261/0x2b2 [processor]
 [<ffffffff8024f30f>] ? notifier_call_chain+0x33/0x5b
 [<ffffffff803b9c64>] ? cpuidle_idle_call+0x8c/0xc4
 [<ffffffff8020b312>] ? cpu_idle+0x4a/0x9a
 [<ffffffff8042c5c8>] ? rest_init+0x5c/0x5e
handlers:
[<ffffffffa0103981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
Disabling IRQ #19
usb 5-2: reset full speed USB device using uhci_hcd and address 2
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
Restarting tasks ... done.

--Boundary-00=_m0mOJL6UpiStai2--
