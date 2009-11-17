Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbZKQUGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbZKQUGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZKQUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:06:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33704 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbZKQUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:05:58 -0500
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
References: <20090924154023.GA27480@localhost>
	<20091003140902.38628d8a@lxorguk.ukuu.org.uk>
	<m13a4df19g.fsf@fess.ebiederm.org>
	<200911171941.34781.oliver@neukum.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 12:05:55 -0800
In-Reply-To: <200911171941.34781.oliver@neukum.org> (Oliver Neukum's message of "Tue\, 17 Nov 2009 19\:41\:34 +0100")
Message-ID: <m1hbssex24.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Oliver Neukum <oliver@neukum.org> writes:

> Am Dienstag, 17. November 2009 19:35:07 schrieb Eric W. Biederman:
>> Boiled down.  ftdi_chars_in_buffer is essentially
>>  priv->tx_outstanding_bytes. tx_outstanding_bytes is incremented when an
>>  urb request is sent and tx_outstanding_bytes is decremented when an urb
>>  request completes.
>> 
>> It turns out I have a moderately noisy usb line, and so I occasionally
>> get messages like:
>> 
>> ehci_hcd 0000:00:0a.1: detected XactErr len 0/7 retry 31
>> 
>> Which as best as I can tell result in the urb getting abandoned and
>> neither completed nor canceled (because we have hit the maximum
>> retry count and they still don't succeed).
>
> The URB should be finished with an error code in urb->status.
> ftdi_write_bulk_callback() does decrement the counter even in
> the error case.
>
>> Which appears to result in tx_outstanding_bytes getting stuck at
>> some positive number.
>
> Do you see this message
>
>  	if (status) {
> 		dbg("nonzero write bulk status received: %d", status);
> 		return;
> 	}
>
> if you enable debugging output?
>
> 	Regards
> 		Oliver

I think I have enabled debug output but I don't see anything extra
coming out.  Below is the patch I am running against 2.6.32-rc5.  The
full dmesg is attached.

The highlights seem to be:

ehci_hcd 0000:00:0a.1: 9.2 detected XactErr len 0/7 retry 1
ehci_hcd 0000:00:0a.1: devpath 9.2 ep4out 3strikes

The fact that "stty -F /dev/ttyUSB15 9600" hangs forever in
tty_wait_until sent.

Eric


diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 00ad9ce..0766f1b 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -389,9 +389,10 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 						++qh->xacterrs < QH_XACTERR_MAX &&
 						!urb->unlinked) {
 					ehci_dbg(ehci,
-	"detected XactErr len %zu/%zu retry %d\n",
+	"%s detected XactErr len %zu/%zu retry %d\n",
+	qtd->urb->dev->devpath,
 	qtd->length - QTD_LENGTH(token), qtd->length, qh->xacterrs);
-
+#if 0
 					/* reset the token in the qtd and the
 					 * qh overlay (which still contains
 					 * the qtd) so that we pick up from
@@ -406,6 +407,7 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					hw->hw_token = cpu_to_hc32(ehci,
 							token);
 					goto retry_xacterr;
+#endif
 				}
 				stopped = 1;
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9c60d6d..1e1933e 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -29,6 +29,7 @@
 /* Thanx to gkh and the rest of the usb dev group for all code I have
    assimilated :-) */
 
+#define DEBUG 1
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>



--=-=-=
Content-Disposition: inline; filename=dmesg-hang1.txt

Initializing cgroup subsys cpuset
Linux version 2.6.32-rc5 (ebiederm@maxwell.aristanetworks.com.) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #8 SMP Tue Nov 17 07:29:09 PST 2009
Command line: ro root=LABEL=/ rhgb quiet 8250.nr_uarts=16 crashkernel=128M
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
 BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)
 BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)
 BIOS-e820: 000000003fef0000 - 000000003ff00000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x3fee0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 base 003FF00000 mask FFFFF00000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000003fee0000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003fee0000 page 4k
kernel direct mapping tables up to 3fee0000 @ 10000-13000
RAMDISK: 37cfc000 - 37feff45
ACPI: RSDP 00000000000f7d30 00014 (v00 Nvidia)
ACPI: RSDT 000000003fee3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 000000003fee30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 000000003fee3180 06848 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 000000003fee0000 00040
ACPI: SSDT 000000003fee9b00 00182 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
ACPI: MCFG 000000003fee9d00 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: APIC 000000003fee9a40 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003fee0000
Bootmem setup node 0 0000000000000000-000000003fee0000
  NODE_DATA [0000000000011000 - 0000000000025fff]
  bootmap [0000000000026000 -  000000000002dfdf] pages 8
(7 early reservations) ==> bootmem [0000000000 - 003fee0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00017f48d4]    TEXT DATA BSS ==> [0001000000 - 00017f48d4]
  #3 [0037cfc000 - 0037feff45]          RAMDISK ==> [0037cfc000 - 0037feff45]
  #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #5 [00017f5000 - 00017f5082]              BRK ==> [00017f5000 - 00017f5082]
  #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
found SMP MP-table at [ffff8800000f3d10] f3d10
Reserving 128MB of memory at 32MB for crashkernel (System RAM: 1022MB)
 [ffffea0000000000-ffffea00003fffff] PMD -> [ffff880001c00000-ffff880001ffffff] on node 0
 [ffffea0000400000-ffffea0000dfffff] PMD -> [ffff88000a000000-ffff88000a9fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fee0
On node 0 totalpages: 261743
  DMA zone: 56 pages used for memmap
  DMA zone: 101 pages reserved
  DMA zone: 3826 pages, LIFO batch:0
  DMA32 zone: 3525 pages used for memmap
  DMA32 zone: 254235 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 3ff00000 (gap: 3ff00000:b0100000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff88000aa00000 s82520 r8192 d23976 u1048576
pcpu-alloc: s82520 r8192 d23976 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258061
Policy zone: DMA32
Kernel command line: ro root=LABEL=/ rhgb quiet 8250.nr_uarts=16 crashkernel=128M
PID hash table entries: 4096 (order: 3, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 1e80000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 889964k/1047424k available (3916k kernel code, 452k absent, 157008k reserved, 2171k data, 1328k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:424
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1808.171 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3616.34 BogoMIPS (lpj=7232684)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 003ff00000
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
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3400+ stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3616.92 BogoMIPS (lpj=7233857)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3400+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (7233.27 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
node 0 link 0: io port [ff8000, ffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, efffffff]
node 0 link 0: mmio [f4000000, fe02ffff]
node 0 link 0: mmio [f0000000, f1afffff]
bus: [00,1a] on node 0 link 0
bus: 00 index 0 io port: [ff8000, ffff]
bus: 00 index 1 io port: [0, ffff]
bus: 00 index 2 mmio: [a0000, bffff]
bus: 00 index 3 mmio: [40000000, f3ffffff]
bus: 00 index 4 mmio: [f4000000, fcffffffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:09.1: reg 20 io port: [0x1c00-0x1c3f]
pci 0000:00:09.1: reg 24 io port: [0x1c40-0x1c7f]
pci 0000:00:09.1: PME# supported from D3hot D3cold
pci 0000:00:09.1: PME# disabled
pci 0000:00:0a.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0a.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
pci 0000:00:0a.1: supports D1 D2
pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0c.0: reg 20 io port: [0xf400-0xf40f]
pci 0000:00:0d.0: reg 10 io port: [0x9f0-0x9f7]
pci 0000:00:0d.0: reg 14 io port: [0xbf0-0xbf3]
pci 0000:00:0d.0: reg 18 io port: [0x970-0x977]
pci 0000:00:0d.0: reg 1c io port: [0xb70-0xb73]
pci 0000:00:0d.0: reg 20 io port: [0xe000-0xe00f]
pci 0000:00:0d.0: reg 24 32bit mmio: [0xfe02d000-0xfe02dfff]
pci 0000:00:0d.1: reg 10 io port: [0x9e0-0x9e7]
pci 0000:00:0d.1: reg 14 io port: [0xbe0-0xbe3]
pci 0000:00:0d.1: reg 18 io port: [0x960-0x967]
pci 0000:00:0d.1: reg 1c io port: [0xb60-0xb63]
pci 0000:00:0d.1: reg 20 io port: [0xcc00-0xcc0f]
pci 0000:00:0d.1: reg 24 32bit mmio: [0xfe02c000-0xfe02cfff]
pci 0000:00:0d.2: reg 10 io port: [0xc800-0xc807]
pci 0000:00:0d.2: reg 14 io port: [0xc400-0xc403]
pci 0000:00:0d.2: reg 18 io port: [0xc000-0xc007]
pci 0000:00:0d.2: reg 1c io port: [0xbc00-0xbc03]
pci 0000:00:0d.2: reg 20 io port: [0xb800-0xb80f]
pci 0000:00:0d.2: reg 24 32bit mmio: [0xfe02b000-0xfe02bfff]
pci 0000:00:0e.1: reg 10 32bit mmio: [0xfe020000-0xfe023fff]
pci 0000:00:0e.1: PME# supported from D3hot D3cold
pci 0000:00:0e.1: PME# disabled
pci 0000:00:10.0: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
pci 0000:00:10.0: reg 14 io port: [0xb400-0xb407]
pci 0000:00:10.0: reg 18 32bit mmio: [0xfe029000-0xfe0290ff]
pci 0000:00:10.0: reg 1c 32bit mmio: [0xfe028000-0xfe02800f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:11.0: reg 10 32bit mmio: [0xfe027000-0xfe027fff]
pci 0000:00:11.0: reg 14 io port: [0xb000-0xb007]
pci 0000:00:11.0: reg 18 32bit mmio: [0xfe026000-0xfe0260ff]
pci 0000:00:11.0: reg 1c 32bit mmio: [0xfe025000-0xfe02500f]
pci 0000:00:11.0: supports D1 D2
pci 0000:00:11.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:11.0: PME# disabled
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:00:13.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:13.0: PME# disabled
pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:15.0: PME# disabled
pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:00:17.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:17.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xf8000000-0xf8ffffff]
pci 0000:01:00.0: reg 14 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xf9000000-0xf9ffffff]
pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:04.0: bridge io port: [0xa000-0xafff]
pci 0000:00:04.0: bridge 32bit mmio: [0xf8000000-0xfaffffff]
pci 0000:00:04.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:02:09.0: reg 10 32bit mmio: [0xfdeff000-0xfdeff7ff]
pci 0000:02:09.0: reg 14 io port: [0x9c00-0x9c7f]
pci 0000:02:09.0: supports D2
pci 0000:02:09.0: PME# supported from D2 D3hot D3cold
pci 0000:02:09.0: PME# disabled
pci 0000:00:0e.0: transparent bridge
pci 0000:00:0e.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
pci 0000:00:0e.0: bridge 32bit mmio pref: [0xfdf00000-0xfdffffff]
pci 0000:00:12.0: bridge io port: [0x8000-0x8fff]
pci 0000:00:12.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
pci 0000:00:12.0: bridge 64bit mmio pref: [0xfdc00000-0xfdcfffff]
pci 0000:04:00.0: reg 10 64bit mmio: [0xfdbff000-0xfdbff07f]
pci 0000:04:00.0: reg 18 64bit mmio: [0xfdbf8000-0xfdbfbfff]
pci 0000:04:00.0: reg 20 io port: [0x7c00-0x7c7f]
pci 0000:04:00.0: reg 30 32bit mmio pref: [0x000000-0x07ffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:13.0: bridge io port: [0x7000-0x7fff]
pci 0000:00:13.0: bridge 32bit mmio: [0xfdb00000-0xfdbfffff]
pci 0000:00:13.0: bridge 64bit mmio pref: [0xfda00000-0xfdafffff]
pci 0000:00:15.0: bridge io port: [0x6000-0x6fff]
pci 0000:00:15.0: bridge 32bit mmio: [0xfd900000-0xfd9fffff]
pci 0000:00:15.0: bridge 64bit mmio pref: [0xfd800000-0xfd8fffff]
pci 0000:00:16.0: bridge io port: [0x5000-0x5fff]
pci 0000:00:16.0: bridge 32bit mmio: [0xfd700000-0xfd7fffff]
pci 0000:00:16.0: bridge 64bit mmio pref: [0xfd600000-0xfd6fffff]
pci 0000:07:00.0: reg 10 32bit mmio: [0xfd5e0000-0xfd5fffff]
pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
pci 0000:07:00.0: PME# disabled
pci 0000:00:17.0: bridge 32bit mmio: [0xfc400000-0xfd5fffff]
pci 0000:00:17.0: bridge 64bit mmio pref: [0xfb400000-0xfc3fffff]
pci 0000:08:01.0: PME# supported from D0 D3hot D3cold
pci 0000:08:01.0: PME# disabled
pci 0000:08:02.0: PME# supported from D0 D3hot D3cold
pci 0000:08:02.0: PME# disabled
pci 0000:08:03.0: PME# supported from D0 D3hot D3cold
pci 0000:08:03.0: PME# disabled
pci 0000:08:05.0: PME# supported from D0 D3hot D3cold
pci 0000:08:05.0: PME# disabled
pci 0000:08:07.0: PME# supported from D0 D3hot D3cold
pci 0000:08:07.0: PME# disabled
pci 0000:08:09.0: PME# supported from D0 D3hot D3cold
pci 0000:08:09.0: PME# disabled
pci 0000:08:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:08:0a.0: PME# disabled
pci 0000:08:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:08:0b.0: PME# disabled
pci 0000:08:0c.0: PME# supported from D0 D3hot D3cold
pci 0000:08:0c.0: PME# disabled
pci 0000:08:0d.0: PME# supported from D0 D3hot D3cold
pci 0000:08:0d.0: PME# disabled
pci 0000:08:0e.0: PME# supported from D0 D3hot D3cold
pci 0000:08:0e.0: PME# disabled
pci 0000:08:0f.0: PME# supported from D0 D3hot D3cold
pci 0000:08:0f.0: PME# disabled
pci 0000:07:00.0: bridge 32bit mmio: [0xfc400000-0xfd4fffff]
pci 0000:07:00.0: bridge 64bit mmio pref: [0xfb400000-0xfc3fffff]
pci 0000:09:00.0: reg 10 32bit mmio: [0xfd4e0000-0xfd4fffff]
pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
pci 0000:09:00.0: PME# disabled
pci 0000:08:01.0: bridge io port: [0x00-0x4fff]
pci 0000:08:01.0: bridge 32bit mmio: [0xfcf00000-0xfd4fffff]
pci 0000:08:01.0: bridge 64bit mmio pref: [0xfbf00000-0xfc3fffff]
pci 0000:0a:01.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:01.0: PME# disabled
pci 0000:0a:04.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:04.0: PME# disabled
pci 0000:0a:05.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:05.0: PME# disabled
pci 0000:0a:07.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:07.0: PME# disabled
pci 0000:0a:09.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:09.0: PME# disabled
pci 0000:09:00.0: bridge io port: [0x00-0x4fff]
pci 0000:09:00.0: bridge 32bit mmio: [0xfcf00000-0xfd3fffff]
pci 0000:09:00.0: bridge 64bit mmio pref: [0xfbf00000-0xfc3fffff]
pci 0000:0b:00.0: reg 10 32bit mmio: [0xfd3e0000-0xfd3fffff]
pci 0000:0b:00.0: reg 14 32bit mmio: [0xfd3c0000-0xfd3dffff]
pci 0000:0b:00.0: reg 18 io port: [0x4c00-0x4c1f]
pci 0000:0b:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0b:00.0: PME# disabled
pci 0000:0b:00.1: reg 10 32bit mmio: [0xfd3a0000-0xfd3bffff]
pci 0000:0b:00.1: reg 14 32bit mmio: [0xfd380000-0xfd39ffff]
pci 0000:0b:00.1: reg 18 io port: [0x4800-0x481f]
pci 0000:0b:00.1: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:0b:00.1: PME# supported from D0 D3hot D3cold
pci 0000:0b:00.1: PME# disabled
pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:0a:01.0: bridge io port: [0x4000-0x4fff]
pci 0000:0a:01.0: bridge 32bit mmio: [0xfd300000-0xfd3fffff]
pci 0000:0a:01.0: bridge 64bit mmio pref: [0xfc300000-0xfc3fffff]
pci 0000:0c:00.0: reg 10 32bit mmio: [0xfd2e0000-0xfd2fffff]
pci 0000:0c:00.0: reg 14 32bit mmio: [0xfd2c0000-0xfd2dffff]
pci 0000:0c:00.0: reg 18 io port: [0x3c00-0x3c1f]
pci 0000:0c:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0c:00.0: PME# disabled
pci 0000:0c:00.1: reg 10 32bit mmio: [0xfd2a0000-0xfd2bffff]
pci 0000:0c:00.1: reg 14 32bit mmio: [0xfd280000-0xfd29ffff]
pci 0000:0c:00.1: reg 18 io port: [0x3800-0x381f]
pci 0000:0c:00.1: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:0c:00.1: PME# supported from D0 D3hot D3cold
pci 0000:0c:00.1: PME# disabled
pci 0000:0c:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:0a:04.0: bridge io port: [0x3000-0x3fff]
pci 0000:0a:04.0: bridge 32bit mmio: [0xfd200000-0xfd2fffff]
pci 0000:0a:04.0: bridge 64bit mmio pref: [0xfc200000-0xfc2fffff]
pci 0000:0a:05.0: bridge io port: [0x2000-0x2fff]
pci 0000:0a:05.0: bridge 32bit mmio: [0xfd100000-0xfd1fffff]
pci 0000:0a:05.0: bridge 64bit mmio pref: [0xfc100000-0xfc1fffff]
pci 0000:0a:09.0: bridge io port: [0x00-0xfff]
pci 0000:0a:09.0: bridge 32bit mmio: [0xfcf00000-0xfcffffff]
pci 0000:0a:09.0: bridge 64bit mmio pref: [0xfbf00000-0xfbffffff]
pci 0000:0a:07.0: bridge io port: [0x1000-0x1fff]
pci 0000:0a:07.0: bridge 32bit mmio: [0xfd000000-0xfd0fffff]
pci 0000:0a:07.0: bridge 64bit mmio pref: [0xfc000000-0xfc0fffff]
pci 0000:0a:07.0: bridge io port: [0x1000-0x1fff]
pci 0000:0a:07.0: bridge 32bit mmio: [0xfd000000-0xfd0fffff]
pci 0000:0a:07.0: bridge 64bit mmio pref: [0xfc000000-0xfc0fffff]
pci 0000:08:03.0: bridge io port: [0xffffffffffffe000-0xffffffffffffefff]
pci 0000:08:03.0: bridge 32bit mmio: [0xfcd00000-0xfcdfffff]
pci 0000:08:03.0: bridge 64bit mmio pref: [0xfbd00000-0xfbdfffff]
pci 0000:08:05.0: bridge io port: [0xffffffffffffd000-0xffffffffffffdfff]
pci 0000:08:05.0: bridge 32bit mmio: [0xfcc00000-0xfccfffff]
pci 0000:08:05.0: bridge 64bit mmio pref: [0xfbc00000-0xfbcfffff]
pci 0000:08:09.0: bridge io port: [0xffffffffffffb000-0xffffffffffffbfff]
pci 0000:08:09.0: bridge 32bit mmio: [0xfca00000-0xfcafffff]
pci 0000:08:09.0: bridge 64bit mmio pref: [0xfba00000-0xfbafffff]
pci 0000:08:0a.0: bridge io port: [0xffffffffffffa000-0xffffffffffffafff]
pci 0000:08:0a.0: bridge 32bit mmio: [0xfc900000-0xfc9fffff]
pci 0000:08:0a.0: bridge 64bit mmio pref: [0xfb900000-0xfb9fffff]
pci 0000:08:0b.0: bridge io port: [0xffffffffffff9000-0xffffffffffff9fff]
pci 0000:08:0b.0: bridge 32bit mmio: [0xfc800000-0xfc8fffff]
pci 0000:08:0b.0: bridge 64bit mmio pref: [0xfb800000-0xfb8fffff]
pci 0000:08:0c.0: bridge io port: [0xffffffffffff8000-0xffffffffffff8fff]
pci 0000:08:0c.0: bridge 32bit mmio: [0xfc700000-0xfc7fffff]
pci 0000:08:0c.0: bridge 64bit mmio pref: [0xfb700000-0xfb7fffff]
pci 0000:08:0d.0: bridge io port: [0xffffffffffff7000-0xffffffffffff7fff]
pci 0000:08:0d.0: bridge 32bit mmio: [0xfc600000-0xfc6fffff]
pci 0000:08:0d.0: bridge 64bit mmio pref: [0xfb600000-0xfb6fffff]
pci 0000:08:0e.0: bridge io port: [0xffffffffffff6000-0xffffffffffff6fff]
pci 0000:08:0e.0: bridge 32bit mmio: [0xfc500000-0xfc5fffff]
pci 0000:08:0e.0: bridge 64bit mmio pref: [0xfb500000-0xfb5fffff]
pci 0000:08:0f.0: bridge io port: [0xffffffffffff5000-0xffffffffffff5fff]
pci 0000:08:0f.0: bridge 32bit mmio: [0xfc400000-0xfc4fffff]
pci 0000:08:0f.0: bridge 64bit mmio pref: [0xfb400000-0xfb4fffff]
pci 0000:08:07.0: bridge io port: [0xffffffffffffc000-0xffffffffffffcfff]
pci 0000:08:07.0: bridge 32bit mmio: [0xfcb00000-0xfcbfffff]
pci 0000:08:07.0: bridge 64bit mmio pref: [0xfbb00000-0xfbbfffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK7] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:08:01.0: BAR 13: can't allocate resource
pci 0000:09:00.0: BAR 13: can't allocate resource
pci 0000:0a:01.0: BAR 13: no parent found for of bridge [0x4000-0x4fff]
pci 0000:0a:01.0: BAR 13: can't allocate resource
pci 0000:0a:04.0: BAR 13: no parent found for of bridge [0x3000-0x3fff]
pci 0000:0a:04.0: BAR 13: can't allocate resource
pci 0000:0a:05.0: BAR 13: no parent found for of bridge [0x2000-0x2fff]
pci 0000:0a:05.0: BAR 13: can't allocate resource
pci 0000:0a:09.0: BAR 13: can't allocate resource
pci 0000:0a:07.0: BAR 13: no parent found for of bridge [0x1000-0x1fff]
pci 0000:0a:07.0: BAR 13: can't allocate resource
pci 0000:08:03.0: BAR 13: no parent found for of bridge [0xffffffffffffe000-0xffffffffffffefff]
pci 0000:08:03.0: BAR 13: can't allocate resource
pci 0000:08:05.0: BAR 13: no parent found for of bridge [0xffffffffffffd000-0xffffffffffffdfff]
pci 0000:08:05.0: BAR 13: can't allocate resource
pci 0000:08:09.0: BAR 13: no parent found for of bridge [0xffffffffffffb000-0xffffffffffffbfff]
pci 0000:08:09.0: BAR 13: can't allocate resource
pci 0000:08:0a.0: BAR 13: no parent found for of bridge [0xffffffffffffa000-0xffffffffffffafff]
pci 0000:08:0a.0: BAR 13: can't allocate resource
pci 0000:08:0b.0: BAR 13: no parent found for of bridge [0xffffffffffff9000-0xffffffffffff9fff]
pci 0000:08:0b.0: BAR 13: can't allocate resource
pci 0000:08:0c.0: BAR 13: no parent found for of bridge [0xffffffffffff8000-0xffffffffffff8fff]
pci 0000:08:0c.0: BAR 13: can't allocate resource
pci 0000:08:0d.0: BAR 13: no parent found for of bridge [0xffffffffffff7000-0xffffffffffff7fff]
pci 0000:08:0d.0: BAR 13: can't allocate resource
pci 0000:08:0e.0: BAR 13: no parent found for of bridge [0xffffffffffff6000-0xffffffffffff6fff]
pci 0000:08:0e.0: BAR 13: can't allocate resource
pci 0000:08:0f.0: BAR 13: no parent found for of bridge [0xffffffffffff5000-0xffffffffffff5fff]
pci 0000:08:0f.0: BAR 13: can't allocate resource
pci 0000:08:07.0: BAR 13: no parent found for of bridge [0xffffffffffffc000-0xffffffffffffcfff]
pci 0000:08:07.0: BAR 13: can't allocate resource
pci 0000:0b:00.0: BAR 2: no parent found for of device [0x4c00-0x4c1f]
pci 0000:0b:00.0: BAR 2: can't allocate resource
pci 0000:0b:00.1: BAR 2: no parent found for of device [0x4800-0x481f]
pci 0000:0b:00.1: BAR 2: can't allocate resource
pci 0000:0c:00.0: BAR 2: no parent found for of device [0x3c00-0x3c1f]
pci 0000:0c:00.0: BAR 2: can't allocate resource
pci 0000:0c:00.1: BAR 2: no parent found for of device [0x3800-0x381f]
pci 0000:0c:00.1: BAR 2: can't allocate resource
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource jiffies
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:02: io resource (0x10-0x1f) overlaps 0000:0b:00.0 BAR 2 (0x0-0x1f), disabling
pnp 00:02: io resource (0x10-0x1f) overlaps 0000:0b:00.1 BAR 2 (0x0-0x1f), disabling
pnp 00:02: io resource (0x10-0x1f) overlaps 0000:0c:00.0 BAR 2 (0x0-0x1f), disabling
pnp 00:02: io resource (0x10-0x1f) overlaps 0000:0c:00.1 BAR 2 (0x0-0x1f), disabling
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1080-0x10ff has been reserved
system 00:01: ioport range 0x1400-0x147f has been reserved
system 00:01: ioport range 0x1480-0x14ff has been reserved
system 00:01: ioport range 0x1800-0x187f has been reserved
system 00:01: ioport range 0x1880-0x18ff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x295-0x296 has been reserved
system 00:02: ioport range 0x800-0x87f has been reserved
system 00:09: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:0a: iomem range 0xd1800-0xd3fff has been reserved
system 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0a: iomem range 0xfc000-0xfffff could not be reserved
system 00:0a: iomem range 0x3fee0000-0x3fefffff could not be reserved
system 00:0a: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0a: iomem range 0x0-0x9ffff could not be reserved
system 00:0a: iomem range 0x100000-0x3fedffff could not be reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0a: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:0a: iomem range 0xfefff000-0xfeffffff has been reserved
system 00:0a: iomem range 0xfff80000-0xfff80fff has been reserved
system 00:0a: iomem range 0xfff90000-0xfffbffff has been reserved
system 00:0a: iomem range 0xfffed000-0xfffeffff has been reserved
Switching to clocksource acpi_pm
kstop/0 used greatest stack depth: 6992 bytes left
kstop/1 used greatest stack depth: 6944 bytes left
pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
pci 0000:00:04.0:   IO window: disabled
pci 0000:00:04.0:   MEM window: 0xf8000000-0xfaffffff
pci 0000:00:04.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: 0x9000-0x9fff
pci 0000:00:0e.0:   MEM window: 0xfde00000-0xfdefffff
pci 0000:00:0e.0:   PREFETCH window: disabled
pci 0000:00:12.0: PCI bridge, secondary bus 0000:03
pci 0000:00:12.0:   IO window: disabled
pci 0000:00:12.0:   MEM window: disabled
pci 0000:00:12.0:   PREFETCH window: disabled
pci 0000:00:13.0: PCI bridge, secondary bus 0000:04
pci 0000:00:13.0:   IO window: 0x7000-0x7fff
pci 0000:00:13.0:   MEM window: 0xfdb00000-0xfdbfffff
pci 0000:00:13.0:   PREFETCH window: 0x40000000-0x400fffff
pci 0000:00:15.0: PCI bridge, secondary bus 0000:05
pci 0000:00:15.0:   IO window: disabled
pci 0000:00:15.0:   MEM window: disabled
pci 0000:00:15.0:   PREFETCH window: disabled
pci 0000:00:16.0: PCI bridge, secondary bus 0000:06
pci 0000:00:16.0:   IO window: disabled
pci 0000:00:16.0:   MEM window: disabled
pci 0000:00:16.0:   PREFETCH window: disabled
pci 0000:0a:01.0: PCI bridge, secondary bus 0000:0b
pci 0000:0a:01.0:   IO window: 0x2000-0x2fff
pci 0000:0a:01.0:   MEM window: 0xfd300000-0xfd3fffff
pci 0000:0a:01.0:   PREFETCH window: 0x40100000-0x402fffff
pci 0000:0a:04.0: PCI bridge, secondary bus 0000:0c
pci 0000:0a:04.0:   IO window: 0x3000-0x3fff
pci 0000:0a:04.0:   MEM window: 0xfd200000-0xfd2fffff
pci 0000:0a:04.0:   PREFETCH window: 0x40300000-0x403fffff
pci 0000:0a:05.0: PCI bridge, secondary bus 0000:0d
pci 0000:0a:05.0:   IO window: disabled
pci 0000:0a:05.0:   MEM window: disabled
pci 0000:0a:05.0:   PREFETCH window: disabled
pci 0000:0a:07.0: PCI bridge, secondary bus 0000:10
pci 0000:0a:07.0:   IO window: disabled
pci 0000:0a:07.0:   MEM window: disabled
pci 0000:0a:07.0:   PREFETCH window: disabled
pci 0000:0a:09.0: PCI bridge, secondary bus 0000:0f
pci 0000:0a:09.0:   IO window: disabled
pci 0000:0a:09.0:   MEM window: disabled
pci 0000:0a:09.0:   PREFETCH window: disabled
pci 0000:09:00.0: PCI bridge, secondary bus 0000:0a
pci 0000:09:00.0:   IO window: 0x2000-0x3fff
pci 0000:09:00.0:   MEM window: 0xfcf00000-0xfd3fffff
pci 0000:09:00.0:   PREFETCH window: 0x40100000-0x403fffff
pci 0000:08:01.0: PCI bridge, secondary bus 0000:09
pci 0000:08:01.0:   IO window: 0x2000-0x4fff
pci 0000:08:01.0:   MEM window: 0xfcf00000-0xfd4fffff
pci 0000:08:01.0:   PREFETCH window: 0x40100000-0x403fffff
pci 0000:08:03.0: PCI bridge, secondary bus 0000:11
pci 0000:08:03.0:   IO window: disabled
pci 0000:08:03.0:   MEM window: disabled
pci 0000:08:03.0:   PREFETCH window: disabled
pci 0000:08:05.0: PCI bridge, secondary bus 0000:12
pci 0000:08:05.0:   IO window: disabled
pci 0000:08:05.0:   MEM window: disabled
pci 0000:08:05.0:   PREFETCH window: disabled
pci 0000:08:07.0: PCI bridge, secondary bus 0000:1b
pci 0000:08:07.0:   IO window: disabled
pci 0000:08:07.0:   MEM window: disabled
pci 0000:08:07.0:   PREFETCH window: disabled
pci 0000:08:09.0: PCI bridge, secondary bus 0000:14
pci 0000:08:09.0:   IO window: disabled
pci 0000:08:09.0:   MEM window: disabled
pci 0000:08:09.0:   PREFETCH window: disabled
pci 0000:08:0a.0: PCI bridge, secondary bus 0000:15
pci 0000:08:0a.0:   IO window: disabled
pci 0000:08:0a.0:   MEM window: disabled
pci 0000:08:0a.0:   PREFETCH window: disabled
pci 0000:08:0b.0: PCI bridge, secondary bus 0000:16
pci 0000:08:0b.0:   IO window: disabled
pci 0000:08:0b.0:   MEM window: disabled
pci 0000:08:0b.0:   PREFETCH window: disabled
pci 0000:08:0c.0: PCI bridge, secondary bus 0000:17
pci 0000:08:0c.0:   IO window: disabled
pci 0000:08:0c.0:   MEM window: disabled
pci 0000:08:0c.0:   PREFETCH window: disabled
pci 0000:08:0d.0: PCI bridge, secondary bus 0000:18
pci 0000:08:0d.0:   IO window: disabled
pci 0000:08:0d.0:   MEM window: disabled
pci 0000:08:0d.0:   PREFETCH window: disabled
pci 0000:08:0e.0: PCI bridge, secondary bus 0000:19
pci 0000:08:0e.0:   IO window: disabled
pci 0000:08:0e.0:   MEM window: disabled
pci 0000:08:0e.0:   PREFETCH window: disabled
pci 0000:08:0f.0: PCI bridge, secondary bus 0000:1a
pci 0000:08:0f.0:   IO window: disabled
pci 0000:08:0f.0:   MEM window: disabled
pci 0000:08:0f.0:   PREFETCH window: disabled
pci 0000:07:00.0: PCI bridge, secondary bus 0000:08
pci 0000:07:00.0:   IO window: 0x2000-0x4fff
pci 0000:07:00.0:   MEM window: 0xfc400000-0xfd4fffff
pci 0000:07:00.0:   PREFETCH window: 0x40100000-0x403fffff
pci 0000:00:17.0: PCI bridge, secondary bus 0000:07
pci 0000:00:17.0:   IO window: 0x2000-0x4fff
pci 0000:00:17.0:   MEM window: 0xfc400000-0xfd5fffff
pci 0000:00:17.0:   PREFETCH window: 0x40100000-0x403fffff
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:00:12.0: setting latency timer to 64
pci 0000:00:13.0: setting latency timer to 64
pci 0000:00:15.0: setting latency timer to 64
pci 0000:00:16.0: setting latency timer to 64
pci 0000:00:17.0: setting latency timer to 64
ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
  alloc irq_desc for 16 on node 0
  alloc kstat_irqs on node 0
pci 0000:07:00.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
pci 0000:07:00.0: setting latency timer to 64
ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
pci 0000:08:01.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:01.0: setting latency timer to 64
pci 0000:09:00.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
pci 0000:09:00.0: setting latency timer to 64
ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
pci 0000:0a:01.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:01.0: setting latency timer to 64
pci 0000:0a:04.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:04.0: setting latency timer to 64
pci 0000:0a:05.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:05.0: setting latency timer to 64
pci 0000:0a:07.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:07.0: setting latency timer to 64
pci 0000:0a:09.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:09.0: setting latency timer to 64
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
pci 0000:08:03.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:03.0: setting latency timer to 64
pci 0000:08:05.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:05.0: setting latency timer to 64
pci 0000:08:07.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:07.0: setting latency timer to 64
pci 0000:08:09.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:09.0: setting latency timer to 64
pci 0000:08:0a.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:0a.0: setting latency timer to 64
pci 0000:08:0b.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:0b.0: setting latency timer to 64
pci 0000:08:0c.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:0c.0: setting latency timer to 64
pci 0000:08:0d.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:0d.0: setting latency timer to 64
pci 0000:08:0e.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:0e.0: setting latency timer to 64
pci 0000:08:0f.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
pci 0000:08:0f.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 mem: [0xa000-0xafff]
pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfaffffff]
pci_bus 0000:01: resource 2 pref mem [0xe0000000-0xefffffff]
pci_bus 0000:02: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:02: resource 1 mem: [0xfde00000-0xfdefffff]
pci_bus 0000:02: resource 2 mem: [0xfdf00000-0xfdffffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:03: resource 0 mem: [0x8000-0x8fff]
pci_bus 0000:03: resource 1 mem: [0xfdd00000-0xfddfffff]
pci_bus 0000:03: resource 2 mem: [0xfdc00000-0xfdcfffff]
pci_bus 0000:04: resource 0 io:  [0x7000-0x7fff]
pci_bus 0000:04: resource 1 mem: [0xfdb00000-0xfdbfffff]
pci_bus 0000:04: resource 2 pref mem [0x40000000-0x400fffff]
pci_bus 0000:05: resource 0 mem: [0x6000-0x6fff]
pci_bus 0000:05: resource 1 mem: [0xfd900000-0xfd9fffff]
pci_bus 0000:05: resource 2 mem: [0xfd800000-0xfd8fffff]
pci_bus 0000:06: resource 0 mem: [0x5000-0x5fff]
pci_bus 0000:06: resource 1 mem: [0xfd700000-0xfd7fffff]
pci_bus 0000:06: resource 2 mem: [0xfd600000-0xfd6fffff]
pci_bus 0000:07: resource 0 io:  [0x2000-0x4fff]
pci_bus 0000:07: resource 1 mem: [0xfc400000-0xfd5fffff]
pci_bus 0000:07: resource 2 pref mem [0x40100000-0x403fffff]
pci_bus 0000:08: resource 0 io:  [0x2000-0x4fff]
pci_bus 0000:08: resource 1 mem: [0xfc400000-0xfd4fffff]
pci_bus 0000:08: resource 2 pref mem [0x40100000-0x403fffff]
pci_bus 0000:09: resource 0 io:  [0x2000-0x4fff]
pci_bus 0000:09: resource 1 mem: [0xfcf00000-0xfd4fffff]
pci_bus 0000:09: resource 2 pref mem [0x40100000-0x403fffff]
pci_bus 0000:0a: resource 0 io:  [0x2000-0x3fff]
pci_bus 0000:0a: resource 1 mem: [0xfcf00000-0xfd3fffff]
pci_bus 0000:0a: resource 2 pref mem [0x40100000-0x403fffff]
pci_bus 0000:0b: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:0b: resource 1 mem: [0xfd300000-0xfd3fffff]
pci_bus 0000:0b: resource 2 pref mem [0x40100000-0x402fffff]
pci_bus 0000:0c: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:0c: resource 1 mem: [0xfd200000-0xfd2fffff]
pci_bus 0000:0c: resource 2 pref mem [0x40300000-0x403fffff]
pci_bus 0000:0d: resource 0 mem: [0x2000-0x2fff]
pci_bus 0000:0d: resource 1 mem: [0xfd100000-0xfd1fffff]
pci_bus 0000:0d: resource 2 mem: [0xfc100000-0xfc1fffff]
pci_bus 0000:10: resource 0 mem: [0x1000-0x1fff]
pci_bus 0000:10: resource 1 mem: [0xfd000000-0xfd0fffff]
pci_bus 0000:10: resource 2 mem: [0xfc000000-0xfc0fffff]
pci_bus 0000:0f: resource 0 mem: [0x0-0xfff]
pci_bus 0000:0f: resource 1 mem: [0xfcf00000-0xfcffffff]
pci_bus 0000:0f: resource 2 mem: [0xfbf00000-0xfbffffff]
pci_bus 0000:11: resource 0 mem: [0xffffffffffffe000-0xffffffffffffefff]
pci_bus 0000:11: resource 1 mem: [0xfcd00000-0xfcdfffff]
pci_bus 0000:11: resource 2 mem: [0xfbd00000-0xfbdfffff]
pci_bus 0000:12: resource 0 mem: [0xffffffffffffd000-0xffffffffffffdfff]
pci_bus 0000:12: resource 1 mem: [0xfcc00000-0xfccfffff]
pci_bus 0000:12: resource 2 mem: [0xfbc00000-0xfbcfffff]
pci_bus 0000:1b: resource 0 mem: [0xffffffffffffc000-0xffffffffffffcfff]
pci_bus 0000:1b: resource 1 mem: [0xfcb00000-0xfcbfffff]
pci_bus 0000:1b: resource 2 mem: [0xfbb00000-0xfbbfffff]
pci_bus 0000:14: resource 0 mem: [0xffffffffffffb000-0xffffffffffffbfff]
pci_bus 0000:14: resource 1 mem: [0xfca00000-0xfcafffff]
pci_bus 0000:14: resource 2 mem: [0xfba00000-0xfbafffff]
pci_bus 0000:15: resource 0 mem: [0xffffffffffffa000-0xffffffffffffafff]
pci_bus 0000:15: resource 1 mem: [0xfc900000-0xfc9fffff]
pci_bus 0000:15: resource 2 mem: [0xfb900000-0xfb9fffff]
pci_bus 0000:16: resource 0 mem: [0xffffffffffff9000-0xffffffffffff9fff]
pci_bus 0000:16: resource 1 mem: [0xfc800000-0xfc8fffff]
pci_bus 0000:16: resource 2 mem: [0xfb800000-0xfb8fffff]
pci_bus 0000:17: resource 0 mem: [0xffffffffffff8000-0xffffffffffff8fff]
pci_bus 0000:17: resource 1 mem: [0xfc700000-0xfc7fffff]
pci_bus 0000:17: resource 2 mem: [0xfb700000-0xfb7fffff]
pci_bus 0000:18: resource 0 mem: [0xffffffffffff7000-0xffffffffffff7fff]
pci_bus 0000:18: resource 1 mem: [0xfc600000-0xfc6fffff]
pci_bus 0000:18: resource 2 mem: [0xfb600000-0xfb6fffff]
pci_bus 0000:19: resource 0 mem: [0xffffffffffff6000-0xffffffffffff6fff]
pci_bus 0000:19: resource 1 mem: [0xfc500000-0xfc5fffff]
pci_bus 0000:19: resource 2 mem: [0xfb500000-0xfb5fffff]
pci_bus 0000:1a: resource 0 mem: [0xffffffffffff5000-0xffffffffffff5fff]
pci_bus 0000:1a: resource 1 mem: [0xfc400000-0xfc4fffff]
pci_bus 0000:1a: resource 2 mem: [0xfb400000-0xfb4fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:01:00.0: Boot video device
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 3023k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1258486762.540:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1744
SELinux:  Registering netfilter hooks
cryptomgr_test used greatest stack depth: 6128 bytes left
cryptomgr_test used greatest stack depth: 5944 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
  alloc irq_desc for 24 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:04.0: irq 24 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
  alloc irq_desc for 25 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:12.0: irq 25 for MSI/MSI-X
pcieport 0000:00:12.0: setting latency timer to 64
  alloc irq_desc for 26 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:13.0: irq 26 for MSI/MSI-X
pcieport 0000:00:13.0: setting latency timer to 64
  alloc irq_desc for 27 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:15.0: irq 27 for MSI/MSI-X
pcieport 0000:00:15.0: setting latency timer to 64
  alloc irq_desc for 28 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:16.0: irq 28 for MSI/MSI-X
pcieport 0000:00:16.0: setting latency timer to 64
  alloc irq_desc for 29 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:17.0: irq 29 for MSI/MSI-X
pcieport 0000:00:17.0: setting latency timer to 64
  alloc irq_desc for 30 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:07:00.0: irq 30 for MSI/MSI-X
pcieport 0000:07:00.0: setting latency timer to 64
  alloc irq_desc for 31 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:01.0: irq 31 for MSI/MSI-X
pcieport 0000:08:01.0: setting latency timer to 64
  alloc irq_desc for 32 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:02.0: irq 32 for MSI/MSI-X
pcieport 0000:08:02.0: setting latency timer to 64
  alloc irq_desc for 33 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:03.0: irq 33 for MSI/MSI-X
pcieport 0000:08:03.0: setting latency timer to 64
  alloc irq_desc for 34 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:05.0: irq 34 for MSI/MSI-X
pcieport 0000:08:05.0: setting latency timer to 64
work_for_cpu used greatest stack depth: 5936 bytes left
  alloc irq_desc for 35 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:07.0: irq 35 for MSI/MSI-X
pcieport 0000:08:07.0: setting latency timer to 64
  alloc irq_desc for 36 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:09.0: irq 36 for MSI/MSI-X
pcieport 0000:08:09.0: setting latency timer to 64
  alloc irq_desc for 37 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:0a.0: irq 37 for MSI/MSI-X
pcieport 0000:08:0a.0: setting latency timer to 64
  alloc irq_desc for 38 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:0b.0: irq 38 for MSI/MSI-X
pcieport 0000:08:0b.0: setting latency timer to 64
  alloc irq_desc for 39 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:0c.0: irq 39 for MSI/MSI-X
pcieport 0000:08:0c.0: setting latency timer to 64
  alloc irq_desc for 40 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:0d.0: irq 40 for MSI/MSI-X
pcieport 0000:08:0d.0: setting latency timer to 64
  alloc irq_desc for 41 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:0e.0: irq 41 for MSI/MSI-X
pcieport 0000:08:0e.0: setting latency timer to 64
  alloc irq_desc for 42 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:08:0f.0: irq 42 for MSI/MSI-X
pcieport 0000:08:0f.0: setting latency timer to 64
  alloc irq_desc for 43 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:09:00.0: irq 43 for MSI/MSI-X
pcieport 0000:09:00.0: setting latency timer to 64
  alloc irq_desc for 44 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:0a:01.0: irq 44 for MSI/MSI-X
pcieport 0000:0a:01.0: setting latency timer to 64
  alloc irq_desc for 45 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:0a:04.0: irq 45 for MSI/MSI-X
pcieport 0000:0a:04.0: setting latency timer to 64
  alloc irq_desc for 46 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:0a:05.0: irq 46 for MSI/MSI-X
pcieport 0000:0a:05.0: setting latency timer to 64
  alloc irq_desc for 47 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:0a:07.0: irq 47 for MSI/MSI-X
pcieport 0000:0a:07.0: setting latency timer to 64
  alloc irq_desc for 48 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:0a:09.0: irq 48 for MSI/MSI-X
pcieport 0000:0a:09.0: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
processor LNXCPU:00: registered as cooling_device1
processor LNXCPU:01: registered as cooling_device2
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (38 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 16 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input2
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
sbc_fitpc2_wdt WATCHDOG: board name is: LP UT NF590 SLI. Should be SBC-FITPC2
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
Freeing unused kernel memory: 1328k freed
Write protecting the kernel read-only data: 5576k
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
plymouthd used greatest stack depth: 5832 bytes left
modprobe used greatest stack depth: 5592 bytes left
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
  alloc irq_desc for 23 on node 0
  alloc kstat_irqs on node 0
ehci_hcd 0000:00:0a.1: PCI INT B -> Link[APCL] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:0a.1: setting latency timer to 64
ehci_hcd 0000:00:0a.1: EHCI Host Controller
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file 'devices'
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0a.1: reset hcs_params 0x101a8a dbg=1 cc=1 pcc=10 !ppc ports=10
ehci_hcd 0000:00:0a.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
ehci_hcd 0000:00:0a.1: reset hcc_params a086 caching frame 256/512/1024 park
ehci_hcd 0000:00:0a.1: park 0
ehci_hcd 0000:00:0a.1: debug port 1
ehci_hcd 0000:00:0a.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:0a.1: cache line size of 64 is not supported
ehci_hcd 0000:00:0a.1: supports USB remote wakeup
ehci_hcd 0000:00:0a.1: irq 23, io mem 0xfe02e000
ehci_hcd 0000:00:0a.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:0a.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:0a.1: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-rc5 ehci_hcd
usb usb1: SerialNumber: 0000:00:0a.1
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '001'
work_for_cpu used greatest stack depth: 4800 bytes left
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
  alloc irq_desc for 22 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:0a.0: PCI INT A -> Link[APCF] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:0a.0: setting latency timer to 64
ohci_hcd 0000:00:0a.0: OHCI Host Controller
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0a.0: created debug files
ohci_hcd 0000:00:0a.0: supports USB remote wakeup
ohci_hcd 0000:00:0a.0: irq 22, io mem 0xfe02f000
ohci_hcd 0000:00:0a.0: OHCI controller state
ohci_hcd 0000:00:0a.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:0a.0: control 0x683 RWE RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:0a.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:0a.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:0a.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:0a.0: hcca frame #0003
ohci_hcd 0000:00:0a.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
ohci_hcd 0000:00:0a.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:0a.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:0a.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [4] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [5] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [6] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [7] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [8] 0x00000100 PPS
ohci_hcd 0000:00:0a.0: roothub.portstatus [9] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-rc5 ohci_hcd
usb usb2: SerialNumber: 0000:00:0a.0
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '001'
uhci_hcd: USB Universal Host Controller Interface driver
ehci_hcd 0000:00:0a.1: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 5: status 0501 change 0001
ehci_hcd 0000:00:0a.1: GetStatus port 9 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 9: status 0501 change 0001
SCSI subsystem initialized
libata version 3.00 loaded.
sata_nv 0000:00:0d.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
  alloc irq_desc for 21 on node 0
  alloc kstat_irqs on node 0
sata_nv 0000:00:0d.0: PCI INT A -> Link[APSI] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0d.0: Using SWNCQ mode
sata_nv 0000:00:0d.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xe000 irq 21
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xe008 irq 21
work_for_cpu used greatest stack depth: 4704 bytes left
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
  alloc irq_desc for 20 on node 0
  alloc kstat_irqs on node 0
sata_nv 0000:00:0d.1: PCI INT B -> Link[APSJ] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:0d.1: Using SWNCQ mode
sata_nv 0000:00:0d.1: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xcc00 irq 20
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xcc08 irq 20
ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
sata_nv 0000:00:0d.2: PCI INT C -> Link[ASA2] -> GSI 23 (level, low) -> IRQ 23
sata_nv 0000:00:0d.2: Using SWNCQ mode
sata_nv 0000:00:0d.2: setting latency timer to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb800 irq 23
ata6: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb808 irq 23
ata3: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 10 chg 0220 evt 0000
hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:0a.1: port 5 high speed
ehci_hcd 0000:00:0a.1: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Maxtor 6L080M0, BANC1GA0, max UDMA/133
ata1.00: 160836480 sectors, multi 16: LBA48 NCQ (not used)
usb 1-5: new high speed USB device using ehci_hcd and address 2
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   BANC PQ: 0 ANSI: 5
ata1.00: Disabling SWNCQ mode (depth 1)
sd 0:0:0:0: [sda] 160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
ata2: SATA link down (SStatus 0 SControl 300)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
ata4: SATA link down (SStatus 0 SControl 300)
 sda1 sda2 sda3
ata6: SATA link down (SStatus 0 SControl 300)
sd 0:0:0:0: [sda] Attached SCSI disk
pata_acpi 0000:00:0c.0: setting latency timer to 64
ehci_hcd 0000:00:0a.1: port 5 high speed
ehci_hcd 0000:00:0a.1: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: udev 2, busnum 1, minor = 1
usb 1-5: New USB device found, idVendor=0424, idProduct=2507
usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-5: uevent
usb 1-5: usb_probe_device
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: adding 1-5:1.0 (config #1, interface 0)
usb 1-5:1.0: uevent
hub 1-5:1.0: usb_probe_interface
hub 1-5:1.0: usb_probe_interface - got id
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 7 ports detected
hub 1-5:1.0: standalone hub
hub 1-5:1.0: individual port power switching
hub 1-5:1.0: individual port over-current protection
hub 1-5:1.0: TT per port
hub 1-5:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-5:1.0: power on to power good time: 100ms
hub 1-5:1.0: local power source is good
hub 1-5:1.0: enabling power on all ports
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '002'
hub 1-0:1.0: port 9, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:0a.1: port 9 high speed
ehci_hcd 0000:00:0a.1: GetStatus port 9 status 001005 POWER sig=se0 PE CONNECT
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
hub 1-5:1.0: port 1: status 0101 change 0001
hub 1-5:1.0: port 2: status 0101 change 0001
hub 1-5:1.0: port 3: status 0101 change 0001
hub 1-5:1.0: port 4: status 0101 change 0001
hub 1-5:1.0: port 5: status 0101 change 0001
hub 1-5:1.0: port 6: status 0101 change 0001
hub 1-5:1.0: port 7: status 0101 change 0001
usb 1-9: new high speed USB device using ehci_hcd and address 3
ehci_hcd 0000:00:0a.1: port 9 high speed
ehci_hcd 0000:00:0a.1: GetStatus port 9 status 001005 POWER sig=se0 PE CONNECT
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
usb 1-5: link qh256-0001/ffff880037d12480 start 1 [1/0 us]
type=1404 audit(1258486763.841:2): selinux=0 auid=4294967295 ses=4294967295
usb 1-9: udev 3, busnum 1, minor = 2
usb 1-9: New USB device found, idVendor=0424, idProduct=2507
usb 1-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-9: uevent
usb 1-9: usb_probe_device
usb 1-9: configuration #1 chosen from 1 choice
usb 1-9: adding 1-9:1.0 (config #1, interface 0)
usb 1-9:1.0: uevent
hub 1-9:1.0: usb_probe_interface
hub 1-9:1.0: usb_probe_interface - got id
hub 1-9:1.0: USB hub found
hub 1-9:1.0: 7 ports detected
hub 1-9:1.0: standalone hub
hub 1-9:1.0: individual port power switching
hub 1-9:1.0: individual port over-current protection
hub 1-9:1.0: TT per port
hub 1-9:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-9:1.0: power on to power good time: 100ms
hub 1-9:1.0: local power source is good
hub 1-9:1.0: enabling power on all ports
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '003'
hub 1-5:1.0: state 7 ports 7 chg 00fe evt 0000
hub 1-5:1.0: port 1, status 0101, change 0000, 12 Mb/s
hub 1-5:1.0: port 1 not reset yet, waiting 10ms
usb 1-5.1: new full speed USB device using ehci_hcd and address 4
hub 1-9:1.0: port 1: status 0101 change 0001
hub 1-9:1.0: port 2: status 0101 change 0001
hub 1-9:1.0: port 3: status 0101 change 0001
hub 1-9:1.0: port 4: status 0101 change 0001
hub 1-9:1.0: port 5: status 0101 change 0001
hub 1-9:1.0: port 6: status 0101 change 0001
hub 1-9:1.0: port 7: status 0101 change 0001
hub 1-5:1.0: port 1 not reset yet, waiting 10ms
usb 1-5.1: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 1, a4 ep0 t800a0d42
usb 1-5: clear tt buffer port 1, a4 ep0 t800a0d42
usb 1-5: clear tt buffer port 1, a4 ep0 t800a0d42
usb 1-9: link qh256-0001/ffff880037d12600 start 2 [1/0 us]
usb 1-5.1: default language 0x0409
usb 1-5.1: udev 4, busnum 1, minor = 3
usb 1-5.1: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.1: Product: USB FAST SERIAL ADAPTER
usb 1-5.1: Manufacturer: FTDI
usb 1-5.1: SerialNumber: FT5SQ75V
usb 1-5.1: uevent
usb 1-5.1: usb_probe_device
usb 1-5.1: configuration #1 chosen from 1 choice
usb 1-5.1: adding 1-5.1:1.0 (config #1, interface 0)
usb 1-5.1:1.0: uevent
usb 1-5.1: adding 1-5.1:1.1 (config #1, interface 1)
usb 1-5.1:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '004'
hub 1-5:1.0: port 2, status 0101, change 0000, 12 Mb/s
hub 1-5:1.0: port 2 not reset yet, waiting 10ms
usb 1-5.2: new full speed USB device using ehci_hcd and address 5
usb 1-5.2: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 2, a5 ep0 t800a0d42
usb 1-5: clear tt buffer port 2, a5 ep0 t800a0d42
usb 1-5: clear tt buffer port 2, a5 ep0 t800a0d42
usb 1-5.2: default language 0x0409
usb 1-5.2: udev 5, busnum 1, minor = 4
usb 1-5.2: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.2: Product: USB FAST SERIAL ADAPTER
usb 1-5.2: Manufacturer: FTDI
usb 1-5.2: SerialNumber: FT5SQ764
usb 1-5.2: uevent
usb 1-5.2: usb_probe_device
usb 1-5.2: configuration #1 chosen from 1 choice
usb 1-5.2: adding 1-5.2:1.0 (config #1, interface 0)
usb 1-5.2:1.0: uevent
usb 1-5.2: adding 1-5.2:1.1 (config #1, interface 1)
usb 1-5.2:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '005'
hub 1-5:1.0: port 3, status 0101, change 0000, 12 Mb/s
hub 1-5:1.0: port 3 not reset yet, waiting 10ms
usb 1-5.3: new full speed USB device using ehci_hcd and address 6
runlevel used greatest stack depth: 4424 bytes left
ohci_hcd 0000:00:0a.0: auto-stop root hub
usb 1-5.3: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 3, a6 ep0 t800a0d42
usb 1-5: clear tt buffer port 3, a6 ep0 t800a0d42
usb 1-5: clear tt buffer port 3, a6 ep0 t800a0d42
usb 1-5.3: default language 0x0409
usb 1-5.3: udev 6, busnum 1, minor = 5
usb 1-5.3: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.3: Product: USB FAST SERIAL ADAPTER
usb 1-5.3: Manufacturer: FTDI
usb 1-5.3: SerialNumber: FT5SQ76C
usb 1-5.3: uevent
usb 1-5.3: usb_probe_device
usb 1-5.3: configuration #1 chosen from 1 choice
usb 1-5.3: adding 1-5.3:1.0 (config #1, interface 0)
usb 1-5.3:1.0: uevent
usb 1-5.3: adding 1-5.3:1.1 (config #1, interface 1)
usb 1-5.3:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '006'
hub 1-5:1.0: port 4, status 0101, change 0000, 12 Mb/s
hub 1-5:1.0: port 4 not reset yet, waiting 10ms
sh used greatest stack depth: 3576 bytes left
usb 1-5.4: new full speed USB device using ehci_hcd and address 7
hub 1-5:1.0: port 4 not reset yet, waiting 10ms
mount used greatest stack depth: 3544 bytes left
usb 1-5.4: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 4, a7 ep0 t800a0d42
usb 1-5: clear tt buffer port 4, a7 ep0 t800a0d42
usb 1-5: clear tt buffer port 4, a7 ep0 t800a0d42
usb 1-5.4: default language 0x0409
usb 1-5.4: udev 7, busnum 1, minor = 6
usb 1-5.4: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.4: Product: USB FAST SERIAL ADAPTER
usb 1-5.4: Manufacturer: FTDI
usb 1-5.4: SerialNumber: FT5SQ76K
usb 1-5.4: uevent
usb 1-5.4: usb_probe_device
usb 1-5.4: configuration #1 chosen from 1 choice
usb 1-5.4: adding 1-5.4:1.0 (config #1, interface 0)
usb 1-5.4:1.0: uevent
usb 1-5.4: adding 1-5.4:1.1 (config #1, interface 1)
usb 1-5.4:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '007'
hub 1-5:1.0: port 5, status 0101, change 0000, 12 Mb/s
usb 1-5.5: new full speed USB device using ehci_hcd and address 8
hub 1-5:1.0: port 5 not reset yet, waiting 10ms
usb 1-5.5: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 5, a8 ep0 t800a0d42
usb 1-5: clear tt buffer port 5, a8 ep0 t800a0d42
usb 1-5: clear tt buffer port 5, a8 ep0 t800a0d42
usb 1-5.5: default language 0x0409
usb 1-5.5: udev 8, busnum 1, minor = 7
usb 1-5.5: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.5: Product: USB FAST SERIAL ADAPTER
usb 1-5.5: Manufacturer: FTDI
usb 1-5.5: SerialNumber: FT5SQ76U
usb 1-5.5: uevent
usb 1-5.5: usb_probe_device
usb 1-5.5: configuration #1 chosen from 1 choice
usb 1-5.5: adding 1-5.5:1.0 (config #1, interface 0)
usb 1-5.5:1.0: uevent
usb 1-5.5: adding 1-5.5:1.1 (config #1, interface 1)
usb 1-5.5:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '008'
hub 1-5:1.0: port 6, status 0101, change 0000, 12 Mb/s
usb 1-5.6: new full speed USB device using ehci_hcd and address 9
hub 1-5:1.0: port 6 not reset yet, waiting 10ms
usb 1-5.6: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 6, a9 ep0 t800a0d42
usb 1-5: clear tt buffer port 6, a9 ep0 t800a0d42
usb 1-5: clear tt buffer port 6, a9 ep0 t800a0d42
usb 1-5.6: default language 0x0409
usb 1-5.6: udev 9, busnum 1, minor = 8
usb 1-5.6: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.6: Product: USB FAST SERIAL ADAPTER
usb 1-5.6: Manufacturer: FTDI
usb 1-5.6: SerialNumber: FT5SQ772
usb 1-5.6: uevent
usb 1-5.6: usb_probe_device
usb 1-5.6: configuration #1 chosen from 1 choice
usb 1-5.6: adding 1-5.6:1.0 (config #1, interface 0)
usb 1-5.6:1.0: uevent
usb 1-5.6: adding 1-5.6:1.1 (config #1, interface 1)
usb 1-5.6:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '009'
hub 1-5:1.0: port 7, status 0101, change 0000, 12 Mb/s
hub 1-5:1.0: port 7 not reset yet, waiting 10ms
usb 1-5.7: new full speed USB device using ehci_hcd and address 10
usb 1-5.7: ep0 maxpacket = 8
usb 1-5.7: default language 0x0409
usb 1-5.7: udev 10, busnum 1, minor = 9
usb 1-5.7: New USB device found, idVendor=05e3, idProduct=0604
usb 1-5.7: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-5.7: Product: USB Hub
usb 1-5.7: uevent
usb 1-5.7: usb_probe_device
usb 1-5.7: configuration #1 chosen from 1 choice
usb 1-5.7: adding 1-5.7:1.0 (config #1, interface 0)
usb 1-5.7:1.0: uevent
hub 1-5.7:1.0: usb_probe_interface
hub 1-5.7:1.0: usb_probe_interface - got id
hub 1-5.7:1.0: USB hub found
hub 1-5.7:1.0: 4 ports detected
hub 1-5.7:1.0: standalone hub
hub 1-5.7:1.0: ganged power switching
hub 1-5.7:1.0: global over-current protection
hub 1-5.7:1.0: power on to power good time: 100ms
hub 1-5.7:1.0: local power source is good
hub 1-5.7:1.0: no over-current condition exists
hub 1-5.7:1.0: enabling power on all ports
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '010'
hub 1-5:1.0: state 7 ports 7 chg 0000 evt ff80
hub 1-9:1.0: state 7 ports 7 chg 00fe evt 0000
hub 1-9:1.0: port 1, status 0101, change 0000, 12 Mb/s
udev: starting version 141
usb 1-5.7: uevent
usb 1-9.1: new full speed USB device using ehci_hcd and address 11
hub 1-9:1.0: port 1 not reset yet, waiting 10ms
hub 1-5.7:1.0: port 1: status 0101 change 0001
hub 1-5.7:1.0: port 2: status 0101 change 0001
usb 1-9.1: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 1, a11 ep0 t800a0d42
usb 1-9: clear tt buffer port 1, a11 ep0 t800a0d42
usb 1-9: clear tt buffer port 1, a11 ep0 t800a0d42
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-5: uevent
usb 1-5.1: uevent
usb 1-5.1:1.0: uevent
usb 1-5.1:1.1: uevent
usb 1-5.2: uevent
usb 1-5.2:1.0: uevent
usb 1-5.2:1.1: uevent
usb 1-5.3: uevent
usb 1-5.3:1.0: uevent
usb 1-5.3:1.1: uevent
usb 1-5.4: uevent
usb 1-5.4:1.0: uevent
usb 1-5.4:1.1: uevent
usb 1-5.5: uevent
usb 1-5.5:1.0: uevent
usb 1-5.5:1.1: uevent
usb 1-5.6: uevent
usb 1-5.6:1.0: uevent
usb 1-5.6:1.1: uevent
usb 1-5.7: uevent
usb 1-5.7:1.0: uevent
usb 1-5:1.0: uevent
usb 1-9: uevent
usb 1-9:1.0: uevent
usb 1-9.1: default language 0x0409
usb 1-9.1: udev 11, busnum 1, minor = 10
usb 1-9.1: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.1: Product: USB FAST SERIAL ADAPTER
usb 1-9.1: Manufacturer: FTDI
usb 1-9.1: SerialNumber: FT5PAFU7
usb 1-9.1: uevent
usb 1-9.1: usb_probe_device
usb 1-9.1: configuration #1 chosen from 1 choice
usb 1-9.1: adding 1-9.1:1.0 (config #1, interface 0)
usb 1-9.1:1.0: uevent
usb 1-9.1: adding 1-9.1:1.1 (config #1, interface 1)
usb 1-9.1:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '011'
hub 1-9:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb 1-5.7: link qh128-0e01/ffff88003e9ce680 start 3 [1/2 us]
usb usb2: uevent
hub 1-9:1.0: port 2 not reset yet, waiting 10ms
usb usb1: uevent
usb 1-9: uevent
usb 1-5: uevent
usb 1-5.3: uevent
usb 1-5.1: uevent
usb 1-5.4: uevent
usb 1-5.2: uevent
usb 1-5.6: uevent
usb 1-5.5: uevent
usb 1-5.7: uevent
usb 1-9.2: new full speed USB device using ehci_hcd and address 12
hub 1-9:1.0: port 2 not reset yet, waiting 10ms
usb 1-9.1: uevent
sd 0:0:0:0: Attached scsi generic sg0 type 0
usb 1-9.2: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 2, a12 ep0 t800a0d42
usb 1-9: clear tt buffer port 2, a12 ep0 t800a0d42
usb 1-9: clear tt buffer port 2, a12 ep0 t800a0d42
usb 1-9.2: default language 0x0409
usb 1-9.2: udev 12, busnum 1, minor = 11
usb 1-9.2: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.2: Product: USB FAST SERIAL ADAPTER
usb 1-9.2: Manufacturer: FTDI
usb 1-9.2: SerialNumber: FT5PAFUG
usb 1-9.2: uevent
usb 1-9.2: usb_probe_device
usb 1-9.2: configuration #1 chosen from 1 choice
usb 1-9.2: adding 1-9.2:1.0 (config #1, interface 0)
usb 1-9.2:1.0: uevent
usb 1-9.2: adding 1-9.2:1.1 (config #1, interface 1)
usb 1-9.2:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '012'
hub 1-9:1.0: port 3, status 0101, change 0000, 12 Mb/s
usb 1-9.3: new full speed USB device using ehci_hcd and address 13
sata_sil24 0000:04:00.0: version 1.1
sata_sil24 0000:04:00.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
sata_sil24 0000:04:00.0: setting latency timer to 64
scsi6 : sata_sil24
pata_amd 0000:00:0c.0: version 0.4.1
pata_amd 0000:00:0c.0: setting latency timer to 64
scsi7 : sata_sil24
ata7: SATA max UDMA/100 host m128@0xfdbff000 port 0xfdbf8000 irq 16
ata8: SATA max UDMA/100 host m128@0xfdbff000 port 0xfdbfa000 irq 16
scsi8 : pata_amd
scsi9 : pata_amd
usb 1-9.3: ep0 maxpacket = 8
ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf400 irq 14
ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf408 irq 15
usb 1-9: clear tt buffer port 3, a13 ep0 t800a0d42
usb 1-9: clear tt buffer port 3, a13 ep0 t800a0d42
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ohci_hcd 0000:00:0a.0: suspend root hub
usb 1-9: clear tt buffer port 3, a13 ep0 t800a0d42
usb 1-9.3: default language 0x0409
usb 1-9.3: udev 13, busnum 1, minor = 12
usb 1-9.3: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.3: Product: USB FAST SERIAL ADAPTER
usb 1-9.3: Manufacturer: FTDI
usb 1-9.3: SerialNumber: FT5PAFUT
usb 1-9.3: uevent
usb 1-9.3: usb_probe_device
usb 1-9.3: configuration #1 chosen from 1 choice
usb 1-9.3: adding 1-9.3:1.0 (config #1, interface 0)
usb 1-9.3:1.0: uevent
usb 1-9.3: adding 1-9.3:1.1 (config #1, interface 1)
usb 1-9.3:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '013'
hub 1-9:1.0: port 4, status 0101, change 0000, 12 Mb/s
hub 1-9:1.0: port 4 not reset yet, waiting 10ms
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
forcedeth 0000:00:10.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low) -> IRQ 22
forcedeth 0000:00:10.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
ata9: port disabled. ignoring.
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usb 1-9.4: new full speed USB device using ehci_hcd and address 14
hub 1-9:1.0: port 4 not reset yet, waiting 10ms
usb 1-9.4: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 4, a14 ep0 t800a0d42
usb 1-9: clear tt buffer port 4, a14 ep0 t800a0d42
usb 1-9: clear tt buffer port 4, a14 ep0 t800a0d42
usb 1-9.4: default language 0x0409
usb 1-9.4: udev 14, busnum 1, minor = 13
usb 1-9.4: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.4: Product: USB FAST SERIAL ADAPTER
usb 1-9.4: Manufacturer: FTDI
usb 1-9.4: SerialNumber: FT5PAFV2
usb 1-9.4: uevent
usb 1-9.4: usb_probe_device
usb 1-9.4: configuration #1 chosen from 1 choice
usb 1-9.4: adding 1-9.4:1.0 (config #1, interface 0)
usb 1-9.4:1.0: uevent
usb 1-9.4: adding 1-9.4:1.1 (config #1, interface 1)
usb 1-9.4:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '014'
hub 1-9:1.0: port 5, status 0101, change 0000, 12 Mb/s
usb 1-9.2: uevent
usb 1-9.3: uevent
usb 1-9.4: uevent
usb 1-9.5: new full speed USB device using ehci_hcd and address 15
input: PC Speaker as /devices/platform/pcspkr/input/input4
hub 1-9:1.0: port 5 not reset yet, waiting 10ms
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:0b:00.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:0b:00.0: setting latency timer to 64
  alloc irq_desc for 49 on node 0
  alloc kstat_irqs on node 0
e1000e 0000:0b:00.0: irq 49 for MSI/MSI-X
usb 1-9.5: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 5, a15 ep0 t800a0d42
usb 1-9: clear tt buffer port 5, a15 ep0 t800a0d42
usb 1-9: clear tt buffer port 5, a15 ep0 t800a0d42
usb 1-9.5: default language 0x0409
usb 1-9.5: udev 15, busnum 1, minor = 14
usb 1-9.5: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.5: Product: USB FAST SERIAL ADAPTER
usb 1-9.5: Manufacturer: FTDI
usb 1-9.5: SerialNumber: FT5PAFVC
usb 1-9.5: uevent
usb 1-9.5: usb_probe_device
usb 1-9.5: configuration #1 chosen from 1 choice
usb 1-9.5: adding 1-9.5:1.0 (config #1, interface 0)
usb 1-9.5:1.0: uevent
usb 1-9.5: adding 1-9.5:1.1 (config #1, interface 1)
usb 1-9.5: uevent
usb 1-9.5:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '015'
hub 1-9:1.0: port 6, status 0101, change 0000, 12 Mb/s
usb 1-9.6: new full speed USB device using ehci_hcd and address 16
hub 1-9:1.0: port 6 not reset yet, waiting 10ms
forcedeth 0000:00:10.0: ifname eth0, PHY OUI 0x1c1 @ 1, addr 00:01:29:d6:df:ee
forcedeth 0000:00:10.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 21
forcedeth 0000:00:11.0: PCI INT A -> Link[AMC1] -> GSI 21 (level, low) -> IRQ 21
forcedeth 0000:00:11.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
0000:0b:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:15:17:67:73:a0
0000:0b:00.0: eth1: Intel(R) PRO/1000 Network Connection
0000:0b:00.0: eth1: MAC: 0, PHY: 4, PBA No: d50868-003
e1000e 0000:0b:00.1: PCI INT B -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:0b:00.1: setting latency timer to 64
  alloc irq_desc for 50 on node 0
  alloc kstat_irqs on node 0
e1000e 0000:0b:00.1: irq 50 for MSI/MSI-X
usb 1-9.6: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 6, a16 ep0 t800a0d42
usb 1-9: clear tt buffer port 6, a16 ep0 t800a0d42
usb 1-9: clear tt buffer port 6, a16 ep0 t800a0d42
usb 1-9.6: default language 0x0409
usb 1-9.6: udev 16, busnum 1, minor = 15
usb 1-9.6: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.6: Product: USB FAST SERIAL ADAPTER
usb 1-9.6: Manufacturer: FTDI
usb 1-9.6: SerialNumber: FT5PAFVO
usb 1-9.6: uevent
usb 1-9.6: usb_probe_device
usb 1-9.6: configuration #1 chosen from 1 choice
usb 1-9.6: adding 1-9.6:1.0 (config #1, interface 0)
usb 1-9.6:1.0: uevent
usb 1-9.6: adding 1-9.6:1.1 (config #1, interface 1)
usb 1-9.6: uevent
usb 1-9.6:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '016'
hub 1-9:1.0: port 7, status 0101, change 0000, 12 Mb/s
usb 1-9.7: new full speed USB device using ehci_hcd and address 17
hub 1-9:1.0: port 7 not reset yet, waiting 10ms
0000:0b:00.1: eth2: (PCI Express:2.5GB/s:Width x1) 00:15:17:67:73:a1
0000:0b:00.1: eth2: Intel(R) PRO/1000 Network Connection
0000:0b:00.1: eth2: MAC: 0, PHY: 4, PBA No: d50868-003
e1000e 0000:0c:00.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:0c:00.0: setting latency timer to 64
  alloc irq_desc for 51 on node 0
  alloc kstat_irqs on node 0
e1000e 0000:0c:00.0: irq 51 for MSI/MSI-X
usb 1-9.7: ep0 maxpacket = 8
usb 1-9.7: default language 0x0409
usb 1-9.7: udev 17, busnum 1, minor = 16
usb 1-9.7: New USB device found, idVendor=05e3, idProduct=0604
usb 1-9.7: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-9.7: Product: USB Hub
usb 1-9.7: uevent
usb 1-9.7: usb_probe_device
usb 1-9.7: configuration #1 chosen from 1 choice
usb 1-9.7: adding 1-9.7:1.0 (config #1, interface 0)
usb 1-9.7:1.0: uevent
hub 1-9.7:1.0: usb_probe_interface
hub 1-9.7:1.0: usb_probe_interface - got id
hub 1-9.7:1.0: USB hub found
hub 1-9.7:1.0: 4 ports detected
hub 1-9.7:1.0: standalone hub
hub 1-9.7:1.0: ganged power switching
hub 1-9.7:1.0: global over-current protection
hub 1-9.7:1.0: power on to power good time: 100ms
hub 1-9.7:1.0: local power source is good
hub 1-9.7:1.0: no over-current condition exists
hub 1-9.7:1.0: enabling power on all ports
usb 1-9.7: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '017'
hub 1-5.7:1.0: state 7 ports 4 chg 0006 evt 0000
usbserial_generic 1-5.1:1.0: usb_probe_interface
usbserial_generic 1-5.1:1.0: usb_probe_interface - got id
usbserial_generic 1-5.1:1.1: usb_probe_interface
usbserial_generic 1-5.1:1.1: usb_probe_interface - got id
usbserial_generic 1-5.2:1.0: usb_probe_interface
usbserial_generic 1-5.2:1.0: usb_probe_interface - got id
usbserial_generic 1-5.2:1.1: usb_probe_interface
usbserial_generic 1-5.2:1.1: usb_probe_interface - got id
usbserial_generic 1-5.3:1.0: usb_probe_interface
usbserial_generic 1-5.3:1.0: usb_probe_interface - got id
usbserial_generic 1-5.3:1.1: usb_probe_interface
usbserial_generic 1-5.3:1.1: usb_probe_interface - got id
usbserial_generic 1-5.4:1.0: usb_probe_interface
usbserial_generic 1-5.4:1.0: usb_probe_interface - got id
usbserial_generic 1-5.4:1.1: usb_probe_interface
usbserial_generic 1-5.4:1.1: usb_probe_interface - got id
usbserial_generic 1-5.5:1.0: usb_probe_interface
usbserial_generic 1-5.5:1.0: usb_probe_interface - got id
usbserial_generic 1-5.5:1.1: usb_probe_interface
usbserial_generic 1-5.5:1.1: usb_probe_interface - got id
usbserial_generic 1-5.6:1.0: usb_probe_interface
usbserial_generic 1-5.6:1.0: usb_probe_interface - got id
usbserial_generic 1-5.6:1.1: usb_probe_interface
usbserial_generic 1-5.6:1.1: usb_probe_interface - got id
hub 1-5.7:1.0: port 1, status 0101, change 0000, 12 Mb/s
udev: renamed network interface eth2 to eth4
usb 1-5.7.1: new full speed USB device using ehci_hcd and address 18
hub 1-9.7:1.0: port 1: status 0101 change 0001
hub 1-9.7:1.0: port 2: status 0101 change 0001
udev: renamed network interface eth1 to eth2
0000:0c:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:15:17:00:4f:b0
0000:0c:00.0: eth1: Intel(R) PRO/1000 Network Connection
0000:0c:00.0: eth1: MAC: 0, PHY: 4, PBA No: d33923-003
e1000e 0000:0c:00.1: PCI INT B -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:0c:00.1: setting latency timer to 64
  alloc irq_desc for 52 on node 0
  alloc kstat_irqs on node 0
e1000e 0000:0c:00.1: irq 52 for MSI/MSI-X
usb 1-5.7.1: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 7, a18 ep0 t800a0d42
usb 1-5: clear tt buffer port 7, a18 ep0 t800a0d42
usb 1-5: clear tt buffer port 7, a18 ep0 t800a0d42
usb 1-5.7.1: default language 0x0409
usb 1-5.7.1: udev 18, busnum 1, minor = 17
usb 1-5.7.1: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.7.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.7.1: Product: USB FAST SERIAL ADAPTER
usb 1-5.7.1: Manufacturer: FTDI
usb 1-5.7.1: SerialNumber: FT5SQ779
usb 1-5.7.1: uevent
usb 1-5.7.1: usb_probe_device
usb 1-5.7.1: configuration #1 chosen from 1 choice
usb 1-5.7.1: adding 1-5.7.1:1.0 (config #1, interface 0)
usb 1-5.7.1: uevent
usb 1-5.7.1:1.0: uevent
usb 1-5.7.1: adding 1-5.7.1:1.1 (config #1, interface 1)
usb 1-5.7.1:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '018'
hub 1-5.7:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb 1-9.7: link qh128-0e01/ffff88003fa89a00 start 4 [1/2 us]
usb 1-5.7.2: new full speed USB device using ehci_hcd and address 19
forcedeth 0000:00:11.0: ifname eth3, PHY OUI 0x1c1 @ 0, addr 00:01:29:d6:df:ed
forcedeth 0000:00:11.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
0000:0c:00.1: eth5: (PCI Express:2.5GB/s:Width x1) 00:15:17:00:4f:b1
0000:0c:00.1: eth5: Intel(R) PRO/1000 Network Connection
0000:0c:00.1: eth5: MAC: 0, PHY: 4, PBA No: d33923-003
usb 1-5.7.2: ep0 maxpacket = 8
usb 1-5: clear tt buffer port 7, a19 ep0 t800a0d42
ehci_hcd 0000:00:0a.1: 5.7 detected XactErr len 0/1 retry 1
ehci_hcd 0000:00:0a.1: devpath 5.7 ep1in 3strikes
hub 1-5.7:1.0: transfer --> -71
usb 1-5.7: unlink qh128-0e01/ffff88003e9ce680 start 3 [1/2 us]
ehci_hcd 0000:00:0a.1: reused qh ffff88003e9ce680 schedule
usb 1-5.7: link qh128-0e01/ffff88003e9ce680 start 3 [1/2 us]
usb 1-5: clear tt buffer port 7, a19 ep0 t800a0d42
usb 1-5: clear tt buffer port 7, a19 ep0 t800a0d42
usb 1-5.7.2: default language 0x0409
usb 1-5.7.2: udev 19, busnum 1, minor = 18
usb 1-5.7.2: New USB device found, idVendor=0403, idProduct=6010
usb 1-5.7.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.7.2: Product: USB FAST SERIAL ADAPTER
usb 1-5.7.2: Manufacturer: FTDI
usb 1-5.7.2: SerialNumber: FT5SQ77L
usb 1-5.7.2: uevent
usb 1-5.7.2: usb_probe_device
usb 1-5.7.2: configuration #1 chosen from 1 choice
usb 1-5.7.2: adding 1-5.7.2:1.0 (config #1, interface 0)
usb 1-5.7.2: uevent
usb 1-5.7.2:1.0: uevent
usb 1-5.7.2: adding 1-5.7.2:1.1 (config #1, interface 1)
usb 1-5.7.2:1.1: uevent
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '019'
hub 1-9:1.0: state 7 ports 7 chg 0000 evt ff80
usbserial_generic 1-9.1:1.0: usb_probe_interface
usbserial_generic 1-9.1:1.0: usb_probe_interface - got id
usbserial_generic 1-9.1:1.1: usb_probe_interface
usbserial_generic 1-9.1:1.1: usb_probe_interface - got id
usbserial_generic 1-9.2:1.0: usb_probe_interface
usbserial_generic 1-9.2:1.0: usb_probe_interface - got id
usbserial_generic 1-9.2:1.1: usb_probe_interface
usbserial_generic 1-9.2:1.1: usb_probe_interface - got id
usbserial_generic 1-9.3:1.0: usb_probe_interface
usbserial_generic 1-9.3:1.0: usb_probe_interface - got id
usbserial_generic 1-9.3:1.1: usb_probe_interface
usbserial_generic 1-9.3:1.1: usb_probe_interface - got id
usbserial_generic 1-9.4:1.0: usb_probe_interface
usbserial_generic 1-9.4:1.0: usb_probe_interface - got id
usbserial_generic 1-9.4:1.1: usb_probe_interface
usbserial_generic 1-9.4:1.1: usb_probe_interface - got id
usbserial_generic 1-9.5:1.0: usb_probe_interface
usbserial_generic 1-9.5:1.0: usb_probe_interface - got id
usbserial_generic 1-9.5:1.1: usb_probe_interface
usbserial_generic 1-9.5:1.1: usb_probe_interface - got id
usbserial_generic 1-9.6:1.0: usb_probe_interface
usbserial_generic 1-9.6:1.0: usb_probe_interface - got id
usbserial_generic 1-9.6:1.1: usb_probe_interface
usbserial_generic 1-9.6:1.1: usb_probe_interface - got id
usbserial_generic 1-5.7.1:1.0: usb_probe_interface
usbserial_generic 1-5.7.1:1.0: usb_probe_interface - got id
usbserial_generic 1-5.7.1:1.1: usb_probe_interface
usbserial_generic 1-5.7.1:1.1: usb_probe_interface - got id
usbserial_generic 1-5.7.2:1.0: usb_probe_interface
usbserial_generic 1-5.7.2:1.0: usb_probe_interface - got id
usbserial_generic 1-5.7.2:1.1: usb_probe_interface
usbserial_generic 1-5.7.2:1.1: usb_probe_interface - got id
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for FTDI USB Serial Device
ftdi_sio 1-5.1:1.0: usb_probe_interface
ftdi_sio 1-5.1:1.0: usb_probe_interface - got id
ftdi_sio 1-5.1:1.0: FTDI USB Serial Device converter detected
usb 1-5.1: Detected FT2232C
usb 1-5.1: Number of endpoints 2
usb 1-5.1: Endpoint 1 MaxPacketSize 64
usb 1-5.1: Endpoint 2 MaxPacketSize 64
usb 1-5.1: Setting MaxPacketSize 64
hub 1-5.7:1.0: state 7 ports 4 chg 0000 evt 0004
hub 1-9.7:1.0: state 7 ports 4 chg 0006 evt 0000
hub 1-9.7:1.0: port 1, status 0101, change 0000, 12 Mb/s
usb 1-5.1: FTDI USB Serial Device converter now attached to ttyUSB0
ftdi_sio 1-5.1:1.1: usb_probe_interface
ftdi_sio 1-5.1:1.1: usb_probe_interface - got id
ftdi_sio 1-5.1:1.1: FTDI USB Serial Device converter detected
usb 1-5.1: Detected FT2232C
usb 1-5.1: Number of endpoints 2
usb 1-5.1: Endpoint 1 MaxPacketSize 64
usb 1-5.1: Endpoint 2 MaxPacketSize 64
usb 1-5.1: Setting MaxPacketSize 64
usb 1-5.1: FTDI USB Serial Device converter now attached to ttyUSB1
ftdi_sio 1-5.2:1.0: usb_probe_interface
ftdi_sio 1-5.2:1.0: usb_probe_interface - got id
ftdi_sio 1-5.2:1.0: FTDI USB Serial Device converter detected
usb 1-5.2: Detected FT2232C
usb 1-5.2: Number of endpoints 2
usb 1-5.2: Endpoint 1 MaxPacketSize 64
usb 1-5.2: Endpoint 2 MaxPacketSize 64
usb 1-5.2: Setting MaxPacketSize 64
usb 1-5.2: FTDI USB Serial Device converter now attached to ttyUSB2
ftdi_sio 1-5.2:1.1: usb_probe_interface
ftdi_sio 1-5.2:1.1: usb_probe_interface - got id
ftdi_sio 1-5.2:1.1: FTDI USB Serial Device converter detected
usb 1-5.2: Detected FT2232C
usb 1-5.2: Number of endpoints 2
usb 1-5.2: Endpoint 1 MaxPacketSize 64
usb 1-5.2: Endpoint 2 MaxPacketSize 64
usb 1-5.2: Setting MaxPacketSize 64
usb 1-5.2: FTDI USB Serial Device converter now attached to ttyUSB3
ftdi_sio 1-5.3:1.0: usb_probe_interface
ftdi_sio 1-5.3:1.0: usb_probe_interface - got id
ftdi_sio 1-5.3:1.0: FTDI USB Serial Device converter detected
usb 1-5.3: Detected FT2232C
usb 1-5.3: Number of endpoints 2
usb 1-5.3: Endpoint 1 MaxPacketSize 64
usb 1-5.3: Endpoint 2 MaxPacketSize 64
usb 1-5.3: Setting MaxPacketSize 64
usb 1-5.3: FTDI USB Serial Device converter now attached to ttyUSB4
ftdi_sio 1-5.3:1.1: usb_probe_interface
ftdi_sio 1-5.3:1.1: usb_probe_interface - got id
ftdi_sio 1-5.3:1.1: FTDI USB Serial Device converter detected
usb 1-5.3: Detected FT2232C
usb 1-5.3: Number of endpoints 2
usb 1-5.3: Endpoint 1 MaxPacketSize 64
usb 1-5.3: Endpoint 2 MaxPacketSize 64
usb 1-5.3: Setting MaxPacketSize 64
usb 1-5.3: FTDI USB Serial Device converter now attached to ttyUSB5
ftdi_sio 1-5.4:1.0: usb_probe_interface
ftdi_sio 1-5.4:1.0: usb_probe_interface - got id
ftdi_sio 1-5.4:1.0: FTDI USB Serial Device converter detected
usb 1-5.4: Detected FT2232C
usb 1-5.4: Number of endpoints 2
usb 1-5.4: Endpoint 1 MaxPacketSize 64
usb 1-5.4: Endpoint 2 MaxPacketSize 64
usb 1-5.4: Setting MaxPacketSize 64
usb 1-5.4: FTDI USB Serial Device converter now attached to ttyUSB6
ftdi_sio 1-5.4:1.1: usb_probe_interface
ftdi_sio 1-5.4:1.1: usb_probe_interface - got id
ftdi_sio 1-5.4:1.1: FTDI USB Serial Device converter detected
usb 1-5.4: Detected FT2232C
usb 1-5.4: Number of endpoints 2
usb 1-5.4: Endpoint 1 MaxPacketSize 64
usb 1-5.4: Endpoint 2 MaxPacketSize 64
usb 1-5.4: Setting MaxPacketSize 64
usb 1-5.4: FTDI USB Serial Device converter now attached to ttyUSB7
ftdi_sio 1-5.5:1.0: usb_probe_interface
ftdi_sio 1-5.5:1.0: usb_probe_interface - got id
ftdi_sio 1-5.5:1.0: FTDI USB Serial Device converter detected
usb 1-5.5: Detected FT2232C
usb 1-5.5: Number of endpoints 2
usb 1-5.5: Endpoint 1 MaxPacketSize 64
usb 1-5.5: Endpoint 2 MaxPacketSize 64
usb 1-5.5: Setting MaxPacketSize 64
usb 1-5.5: FTDI USB Serial Device converter now attached to ttyUSB8
ftdi_sio 1-5.5:1.1: usb_probe_interface
ftdi_sio 1-5.5:1.1: usb_probe_interface - got id
ftdi_sio 1-5.5:1.1: FTDI USB Serial Device converter detected
usb 1-5.5: Detected FT2232C
usb 1-5.5: Number of endpoints 2
usb 1-5.5: Endpoint 1 MaxPacketSize 64
usb 1-5.5: Endpoint 2 MaxPacketSize 64
usb 1-5.5: Setting MaxPacketSize 64
usb 1-5.5: FTDI USB Serial Device converter now attached to ttyUSB9
ftdi_sio 1-5.6:1.0: usb_probe_interface
ftdi_sio 1-5.6:1.0: usb_probe_interface - got id
ftdi_sio 1-5.6:1.0: FTDI USB Serial Device converter detected
usb 1-5.6: Detected FT2232C
usb 1-5.6: Number of endpoints 2
usb 1-5.6: Endpoint 1 MaxPacketSize 64
usb 1-5.6: Endpoint 2 MaxPacketSize 64
usb 1-5.6: Setting MaxPacketSize 64
usb 1-5.6: FTDI USB Serial Device converter now attached to ttyUSB10
ftdi_sio 1-5.6:1.1: usb_probe_interface
ftdi_sio 1-5.6:1.1: usb_probe_interface - got id
ftdi_sio 1-5.6:1.1: FTDI USB Serial Device converter detected
usb 1-5.6: Detected FT2232C
usb 1-5.6: Number of endpoints 2
usb 1-5.6: Endpoint 1 MaxPacketSize 64
usb 1-5.6: Endpoint 2 MaxPacketSize 64
usb 1-5.6: Setting MaxPacketSize 64
usb 1-5.6: FTDI USB Serial Device converter now attached to ttyUSB11
ftdi_sio 1-9.1:1.0: usb_probe_interface
ftdi_sio 1-9.1:1.0: usb_probe_interface - got id
ftdi_sio 1-9.1:1.0: FTDI USB Serial Device converter detected
usb 1-9.1: Detected FT2232C
usb 1-9.1: Number of endpoints 2
usb 1-9.1: Endpoint 1 MaxPacketSize 64
usb 1-9.1: Endpoint 2 MaxPacketSize 64
usb 1-9.1: Setting MaxPacketSize 64
usb 1-9.1: FTDI USB Serial Device converter now attached to ttyUSB12
ftdi_sio 1-9.1:1.1: usb_probe_interface
ftdi_sio 1-9.1:1.1: usb_probe_interface - got id
ftdi_sio 1-9.1:1.1: FTDI USB Serial Device converter detected
usb 1-9.1: Detected FT2232C
usb 1-9.1: Number of endpoints 2
usb 1-9.1: Endpoint 1 MaxPacketSize 64
usb 1-9.1: Endpoint 2 MaxPacketSize 64
usb 1-9.1: Setting MaxPacketSize 64
usb 1-9.1: FTDI USB Serial Device converter now attached to ttyUSB13
ftdi_sio 1-9.2:1.0: usb_probe_interface
ftdi_sio 1-9.2:1.0: usb_probe_interface - got id
ftdi_sio 1-9.2:1.0: FTDI USB Serial Device converter detected
usb 1-9.2: Detected FT2232C
usb 1-9.2: Number of endpoints 2
usb 1-9.2: Endpoint 1 MaxPacketSize 64
usb 1-9.2: Endpoint 2 MaxPacketSize 64
usb 1-9.2: Setting MaxPacketSize 64
usb 1-9.2: FTDI USB Serial Device converter now attached to ttyUSB14
ftdi_sio 1-9.2:1.1: usb_probe_interface
ftdi_sio 1-9.2:1.1: usb_probe_interface - got id
ftdi_sio 1-9.2:1.1: FTDI USB Serial Device converter detected
usb 1-9.2: Detected FT2232C
usb 1-9.2: Number of endpoints 2
usb 1-9.2: Endpoint 1 MaxPacketSize 64
usb 1-9.2: Endpoint 2 MaxPacketSize 64
usb 1-9.2: Setting MaxPacketSize 64
usb 1-9.2: FTDI USB Serial Device converter now attached to ttyUSB15
ftdi_sio 1-9.3:1.0: usb_probe_interface
ftdi_sio 1-9.3:1.0: usb_probe_interface - got id
ftdi_sio 1-9.3:1.0: FTDI USB Serial Device converter detected
usb 1-9.3: Detected FT2232C
usb 1-9.3: Number of endpoints 2
usb 1-9.3: Endpoint 1 MaxPacketSize 64
usb 1-9.3: Endpoint 2 MaxPacketSize 64
usb 1-9.3: Setting MaxPacketSize 64
usb 1-9.3: FTDI USB Serial Device converter now attached to ttyUSB16
ftdi_sio 1-9.3:1.1: usb_probe_interface
ftdi_sio 1-9.3:1.1: usb_probe_interface - got id
ftdi_sio 1-9.3:1.1: FTDI USB Serial Device converter detected
usb 1-9.3: Detected FT2232C
usb 1-9.3: Number of endpoints 2
usb 1-9.3: Endpoint 1 MaxPacketSize 64
usb 1-9.3: Endpoint 2 MaxPacketSize 64
usb 1-9.3: Setting MaxPacketSize 64
usb 1-9.3: FTDI USB Serial Device converter now attached to ttyUSB17
ftdi_sio 1-9.4:1.0: usb_probe_interface
ftdi_sio 1-9.4:1.0: usb_probe_interface - got id
ftdi_sio 1-9.4:1.0: FTDI USB Serial Device converter detected
usb 1-9.4: Detected FT2232C
usb 1-9.4: Number of endpoints 2
usb 1-9.4: Endpoint 1 MaxPacketSize 64
usb 1-9.4: Endpoint 2 MaxPacketSize 64
usb 1-9.4: Setting MaxPacketSize 64
usb 1-9.4: FTDI USB Serial Device converter now attached to ttyUSB18
ftdi_sio 1-9.4:1.1: usb_probe_interface
ftdi_sio 1-9.4:1.1: usb_probe_interface - got id
ftdi_sio 1-9.4:1.1: FTDI USB Serial Device converter detected
usb 1-9.4: Detected FT2232C
usb 1-9.4: Number of endpoints 2
usb 1-9.4: Endpoint 1 MaxPacketSize 64
usb 1-9.4: Endpoint 2 MaxPacketSize 64
usb 1-9.4: Setting MaxPacketSize 64
usb 1-9.4: FTDI USB Serial Device converter now attached to ttyUSB19
ftdi_sio 1-9.5:1.0: usb_probe_interface
ftdi_sio 1-9.5:1.0: usb_probe_interface - got id
ftdi_sio 1-9.5:1.0: FTDI USB Serial Device converter detected
usb 1-9.5: Detected FT2232C
usb 1-9.5: Number of endpoints 2
usb 1-9.5: Endpoint 1 MaxPacketSize 64
usb 1-9.5: Endpoint 2 MaxPacketSize 64
usb 1-9.5: Setting MaxPacketSize 64
usb 1-9.5: FTDI USB Serial Device converter now attached to ttyUSB20
ftdi_sio 1-9.5:1.1: usb_probe_interface
ftdi_sio 1-9.5:1.1: usb_probe_interface - got id
ftdi_sio 1-9.5:1.1: FTDI USB Serial Device converter detected
usb 1-9.5: Detected FT2232C
usb 1-9.5: Number of endpoints 2
usb 1-9.5: Endpoint 1 MaxPacketSize 64
usb 1-9.5: Endpoint 2 MaxPacketSize 64
usb 1-9.5: Setting MaxPacketSize 64
usb 1-9.5: FTDI USB Serial Device converter now attached to ttyUSB21
ftdi_sio 1-9.6:1.0: usb_probe_interface
ftdi_sio 1-9.6:1.0: usb_probe_interface - got id
ftdi_sio 1-9.6:1.0: FTDI USB Serial Device converter detected
usb 1-9.6: Detected FT2232C
usb 1-9.6: Number of endpoints 2
usb 1-9.6: Endpoint 1 MaxPacketSize 64
usb 1-9.6: Endpoint 2 MaxPacketSize 64
usb 1-9.6: Setting MaxPacketSize 64
usb 1-9.6: FTDI USB Serial Device converter now attached to ttyUSB22
ftdi_sio 1-9.6:1.1: usb_probe_interface
ftdi_sio 1-9.6:1.1: usb_probe_interface - got id
ftdi_sio 1-9.6:1.1: FTDI USB Serial Device converter detected
usb 1-9.6: Detected FT2232C
usb 1-9.6: Number of endpoints 2
usb 1-9.6: Endpoint 1 MaxPacketSize 64
usb 1-9.6: Endpoint 2 MaxPacketSize 64
usb 1-9.6: Setting MaxPacketSize 64
usb 1-9.6: FTDI USB Serial Device converter now attached to ttyUSB23
ftdi_sio 1-5.7.1:1.0: usb_probe_interface
ftdi_sio 1-5.7.1:1.0: usb_probe_interface - got id
ftdi_sio 1-5.7.1:1.0: FTDI USB Serial Device converter detected
usb 1-5.7.1: Detected FT2232C
usb 1-5.7.1: Number of endpoints 2
usb 1-5.7.1: Endpoint 1 MaxPacketSize 64
usb 1-5.7.1: Endpoint 2 MaxPacketSize 64
usb 1-5.7.1: Setting MaxPacketSize 64
usb 1-5.7.1: FTDI USB Serial Device converter now attached to ttyUSB24
ftdi_sio 1-5.7.1:1.1: usb_probe_interface
ftdi_sio 1-5.7.1:1.1: usb_probe_interface - got id
ftdi_sio 1-5.7.1:1.1: FTDI USB Serial Device converter detected
usb 1-5.7.1: Detected FT2232C
usb 1-5.7.1: Number of endpoints 2
usb 1-5.7.1: Endpoint 1 MaxPacketSize 64
usb 1-5.7.1: Endpoint 2 MaxPacketSize 64
usb 1-5.7.1: Setting MaxPacketSize 64
usb 1-5.7.1: FTDI USB Serial Device converter now attached to ttyUSB25
ftdi_sio 1-5.7.2:1.0: usb_probe_interface
ftdi_sio 1-5.7.2:1.0: usb_probe_interface - got id
ftdi_sio 1-5.7.2:1.0: FTDI USB Serial Device converter detected
usb 1-5.7.2: Detected FT2232C
usb 1-5.7.2: Number of endpoints 2
usb 1-5.7.2: Endpoint 1 MaxPacketSize 64
usb 1-5.7.2: Endpoint 2 MaxPacketSize 64
usb 1-5.7.2: Setting MaxPacketSize 64
usb 1-5.7.2: FTDI USB Serial Device converter now attached to ttyUSB26
ftdi_sio 1-5.7.2:1.1: usb_probe_interface
ftdi_sio 1-5.7.2:1.1: usb_probe_interface - got id
ftdi_sio 1-5.7.2:1.1: FTDI USB Serial Device converter detected
usb 1-5.7.2: Detected FT2232C
usb 1-5.7.2: Number of endpoints 2
usb 1-5.7.2: Endpoint 1 MaxPacketSize 64
usb 1-5.7.2: Endpoint 2 MaxPacketSize 64
usb 1-5.7.2: Setting MaxPacketSize 64
usb 1-5.7.2: FTDI USB Serial Device converter now attached to ttyUSB27
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
usb 1-9.7.1: new full speed USB device using ehci_hcd and address 20
usb 1-9.7.1: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 7, a20 ep0 t800a0d42
usb 1-9: clear tt buffer port 7, a20 ep0 t800a0d42
usb 1-9: clear tt buffer port 7, a20 ep0 t800a0d42
usb 1-9.7.1: default language 0x0409
usb 1-9.7.1: udev 20, busnum 1, minor = 19
usb 1-9.7.1: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.7.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.7.1: Product: USB FAST SERIAL ADAPTER
usb 1-9.7.1: Manufacturer: FTDI
usb 1-9.7.1: SerialNumber: FT5PAFVZ
usb 1-9.7.1: uevent
usb 1-9.7.1: usb_probe_device
usb 1-9.7.1: configuration #1 chosen from 1 choice
usb 1-9.7.1: adding 1-9.7.1:1.0 (config #1, interface 0)
usb 1-9.7.1:1.0: uevent
usbserial_generic 1-9.7.1:1.0: usb_probe_interface
usbserial_generic 1-9.7.1:1.0: usb_probe_interface - got id
ftdi_sio 1-9.7.1:1.0: usb_probe_interface
ftdi_sio 1-9.7.1:1.0: usb_probe_interface - got id
ftdi_sio 1-9.7.1:1.0: FTDI USB Serial Device converter detected
usb 1-9.7.1: Detected FT2232C
usb 1-9.7.1: Number of endpoints 2
usb 1-9.7.1: Endpoint 1 MaxPacketSize 64
usb 1-9.7.1: Endpoint 2 MaxPacketSize 64
usb 1-9.7.1: Setting MaxPacketSize 64
usb 1-9.7.1: FTDI USB Serial Device converter now attached to ttyUSB28
usb 1-9.7.1: adding 1-9.7.1:1.1 (config #1, interface 1)
usb 1-9.7.1:1.1: uevent
usbserial_generic 1-9.7.1:1.1: usb_probe_interface
usbserial_generic 1-9.7.1:1.1: usb_probe_interface - got id
ftdi_sio 1-9.7.1:1.1: usb_probe_interface
ftdi_sio 1-9.7.1:1.1: usb_probe_interface - got id
ftdi_sio 1-9.7.1:1.1: FTDI USB Serial Device converter detected
usb 1-9.7.1: Detected FT2232C
usb 1-9.7.1: Number of endpoints 2
usb 1-9.7.1: Endpoint 1 MaxPacketSize 64
usb 1-9.7.1: Endpoint 2 MaxPacketSize 64
usb 1-9.7.1: Setting MaxPacketSize 64
usb 1-9.7.1: FTDI USB Serial Device converter now attached to ttyUSB29
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '020'
hub 1-9.7:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb 1-5.6:1.0: uevent
usb 1-5.6: uevent
usb 1-5.5:1.1: uevent
usb 1-5.5: uevent
usb 1-5.4:1.1: uevent
usb 1-5.4: uevent
usb 1-5.1:1.1: uevent
usb 1-5.1: uevent
usb 1-5.2:1.1: uevent
usb 1-5.2: uevent
usb 1-5.1:1.0: uevent
usb 1-5.1: uevent
usb 1-5.6:1.1: uevent
usb 1-5.6: uevent
usb 1-5.5:1.0: uevent
usb 1-5.5: uevent
usb 1-5.3:1.1: uevent
usb 1-5.3: uevent
usb 1-9.7.1: uevent
usb 1-9.1:1.0: uevent
usb 1-9.1: uevent
usb 1-9.1:1.1: uevent
usb 1-9.1: uevent
usb 1-5.4:1.0: uevent
usb 1-5.4: uevent
usb 1-5.7.2:1.1: uevent
usb 1-5.7.2: uevent
usb 1-9.7.2: new full speed USB device using ehci_hcd and address 21
usb 1-5.7.2:1.0: uevent
usb 1-5.7.2: uevent
usb 1-9.6:1.1: uevent
usb 1-9.6: uevent
usb 1-9.5:1.1: uevent
usb 1-9.5: uevent
usb 1-9.6:1.0: uevent
usb 1-9.6: uevent
usb 1-9.2:1.1: uevent
usb 1-9.2: uevent
usb 1-9.5:1.0: uevent
usb 1-9.5: uevent
usb 1-9.2:1.0: uevent
usb 1-9.2: uevent
usb 1-9.3:1.1: uevent
usb 1-9.3: uevent
usb 1-9.4:1.0: uevent
usb 1-9.4: uevent
usb 1-9.4:1.1: uevent
usb 1-9.4: uevent
usb 1-5.7.1:1.1: uevent
usb 1-5.7.1: uevent
usb 1-5.7.1:1.0: uevent
usb 1-5.7.1: uevent
usb 1-9.3:1.0: uevent
usb 1-9.3: uevent
usb 1-9.7.2: ep0 maxpacket = 8
usb 1-9: clear tt buffer port 7, a21 ep0 t800a0d42
usb 1-9: clear tt buffer port 7, a21 ep0 t800a0d42
usb 1-9: clear tt buffer port 7, a21 ep0 t800a0d42
usb 1-9.7.1:1.1: uevent
usb 1-9.7.1: uevent
usb 1-9.7.2: default language 0x0409
usb 1-9.7.1:1.0: uevent
usb 1-9.7.1: uevent
usb 1-9.7.2: udev 21, busnum 1, minor = 20
usb 1-9.7.2: New USB device found, idVendor=0403, idProduct=6010
usb 1-9.7.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9.7.2: Product: USB FAST SERIAL ADAPTER
usb 1-9.7.2: Manufacturer: FTDI
usb 1-9.7.2: SerialNumber: FT5PAFW7
usb 1-9.7.2: uevent
usb 1-9.7.2: usb_probe_device
usb 1-9.7.2: configuration #1 chosen from 1 choice
usb 1-9.7.2: adding 1-9.7.2:1.0 (config #1, interface 0)
usb 1-9.7.2: uevent
usb 1-9.7.2:1.0: uevent
usbserial_generic 1-9.7.2:1.0: usb_probe_interface
usbserial_generic 1-9.7.2:1.0: usb_probe_interface - got id
ftdi_sio 1-9.7.2:1.0: usb_probe_interface
ftdi_sio 1-9.7.2:1.0: usb_probe_interface - got id
ftdi_sio 1-9.7.2:1.0: FTDI USB Serial Device converter detected
usb 1-9.7.2: Detected FT2232C
usb 1-9.7.2: Number of endpoints 2
usb 1-9.7.2: Endpoint 1 MaxPacketSize 64
usb 1-9.7.2: Endpoint 2 MaxPacketSize 64
usb 1-9.7.2: Setting MaxPacketSize 64
usb 1-9.7.2: FTDI USB Serial Device converter now attached to ttyUSB30
usb 1-9.7.2: adding 1-9.7.2:1.1 (config #1, interface 1)
usb 1-9.7.2:1.1: uevent
usbserial_generic 1-9.7.2:1.1: usb_probe_interface
usbserial_generic 1-9.7.2:1.1: usb_probe_interface - got id
ftdi_sio 1-9.7.2:1.1: usb_probe_interface
ftdi_sio 1-9.7.2:1.1: usb_probe_interface - got id
ftdi_sio 1-9.7.2:1.1: FTDI USB Serial Device converter detected
usb 1-9.7.2: Detected FT2232C
usb 1-9.7.2: Number of endpoints 2
usb 1-9.7.2: Endpoint 1 MaxPacketSize 64
usb 1-9.7.2: Endpoint 2 MaxPacketSize 64
usb 1-9.7.2: Setting MaxPacketSize 64
usb 1-9.7.2: FTDI USB Serial Device converter now attached to ttyUSB31
/home/ebiederm/projects/linux/linux-2.6.32-Arora/drivers/usb/core/inode.c: creating file '021'
hub 1-9.7:1.0: state 7 ports 4 chg 0000 evt 0004
usb 1-9.7.2:1.0: uevent
usb 1-9.7.2: uevent
usb 1-9.7.2:1.1: uevent
usb 1-9.7.2: uevent
ata7: SATA link down (SStatus 0 SControl 0)
ata8: SATA link down (SStatus 0 SControl 0)
ata10: port disabled. ignoring.
udev: renamed network interface eth3 to eth1
udev: renamed network interface eth1_rename to eth3
usb 1-5.2:1.0: uevent
usb 1-5.2: uevent
usb 1-5.3:1.0: uevent
usb 1-5.3: uevent
EDAC MC: Ver: 2.1.0 Nov  4 2009
i2c i2c-0: nForce2 SMBus adapter at 0x1c00
i2c i2c-1: nForce2 SMBus adapter at 0x1c40
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
firewire_ohci 0000:02:09.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
firewire_ohci 0000:02:09.0: setting latency timer to 64
EDAC amd64_edac:  Ver: 3.2.0 Nov  4 2009
EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:18.2 failed with error -22
firewire_ohci: Added fw-ohci device 0000:02:09.0, OHCI version 1.10
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 20 (level, low) -> IRQ 20
HDA Intel 0000:00:0e.1: setting latency timer to 64
firewire_core: created device fw0: GUID 000129200005c048, S400
hda_codec: ALC889A: BIOS auto-probing.
ALSA hda_codec.c:3881: autoconfig: line_outs=4 (0x14/0x16/0x15/0x17/0x0)
ALSA hda_codec.c:3885:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA hda_codec.c:3889:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA hda_codec.c:3890:    mono: mono_out=0x0
ALSA hda_codec.c:3893:    dig-out=0x1e/0x0
ALSA hda_codec.c:3901:    inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x1c, aux=0x0
ALSA hda_codec.c:3903:    dig-in=0x1f
ALSA patch_realtek.c:1298: realtek: Enabling init ASM_ID=0x0885 CODEC_ID=10ec0885
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
nf_conntrack version 0.5.0 (6986 buckets, 27944 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
fuse init (API version 7.13)
kvm: Nested Virtualization enabled
kvm: already loaded the other module
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)
bonding: MII link monitoring set to 100 ms
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.1.0 loaded
lvm used greatest stack depth: 3304 bytes left
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k 
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3400+ processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x12
powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x16
bonding: bond1 is being created...
Clocksource tsc unstable (delta = -222563807 ns)
  alloc irq_desc for 53 on node 0
  alloc kstat_irqs on node 0
forcedeth 0000:00:10.0: irq 53 for MSI/MSI-X
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-5: uevent
usb 1-5.1: uevent
usb 1-5.1:1.0: uevent
usb 1-5.1:1.1: uevent
usb 1-5.2: uevent
usb 1-5.2:1.0: uevent
usb 1-5.2:1.1: uevent
usb 1-5.3: uevent
usb 1-5.3:1.0: uevent
usb 1-5.3:1.1: uevent
usb 1-5.4: uevent
usb 1-5.4:1.0: uevent
usb 1-5.4:1.1: uevent
usb 1-5.5: uevent
usb 1-5.5:1.0: uevent
usb 1-5.5:1.1: uevent
usb 1-5.6: uevent
usb 1-5.6:1.0: uevent
usb 1-5.6:1.1: uevent
usb 1-5.7: uevent
usb 1-5.7.1: uevent
usb 1-5.7.1:1.0: uevent
usb 1-5.7.1:1.1: uevent
usb 1-5.7.2: uevent
usb 1-5.7.2:1.0: uevent
usb 1-5.7.2:1.1: uevent
usb 1-5.7:1.0: uevent
usb 1-5:1.0: uevent
usb 1-9: uevent
usb 1-9.1: uevent
usb 1-9.1:1.0: uevent
usb 1-9.1:1.1: uevent
usb 1-9.2: uevent
usb 1-9.2:1.0: uevent
usb 1-9.2:1.1: uevent
usb 1-9.3: uevent
usb 1-9.3:1.0: uevent
usb 1-9.3:1.1: uevent
usb 1-9.4: uevent
usb 1-9.4:1.0: uevent
usb 1-9.4:1.1: uevent
usb 1-9.5: uevent
usb 1-9.5:1.0: uevent
usb 1-9.5:1.1: uevent
usb 1-9.6: uevent
usb 1-9.6:1.0: uevent
usb 1-9.6:1.1: uevent
usb 1-9.7: uevent
usb 1-9.7.1: uevent
usb 1-9.7.1:1.0: uevent
usb 1-9.7.1:1.1: uevent
usb 1-9.7.2: uevent
usb 1-9.7.2:1.0: uevent
usb 1-9.7.2:1.1: uevent
usb 1-9.7:1.0: uevent
usb 1-9:1.0: uevent
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
rpc.nfsd used greatest stack depth: 2808 bytes left
ehci_hcd 0000:00:0a.1: 9.2 detected XactErr len 0/7 retry 1
ehci_hcd 0000:00:0a.1: devpath 9.2 ep4out 3strikes
usb 1-9: clear tt buffer port 2, a12 ep4 t00078048
usb usb2: usb auto-resume
ohci_hcd 0000:00:0a.0: resume root hub
hub 2-0:1.0: hub_resume
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
ohci_hcd 0000:00:0a.0: auto-stop root hub
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ohci_hcd 0000:00:0a.0: suspend root hub
ehci_hcd 0000:00:0a.1: 9.6 detected XactErr len 0/7 retry 1
ehci_hcd 0000:00:0a.1: devpath 9.6 ep4out 3strikes
usb 1-9: clear tt buffer port 6, a16 ep4 t00078048
ehci_hcd 0000:00:0a.1: 9.6 detected XactErr len 0/7 retry 1
ehci_hcd 0000:00:0a.1: devpath 9.6 ep4out 3strikes
usb 1-9: clear tt buffer port 6, a16 ep4 t00078048

--=-=-=--
