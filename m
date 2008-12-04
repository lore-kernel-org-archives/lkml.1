Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYLDXcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYLDXcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYLDXcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:32:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYLDXcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:32:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 00:31:26 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812042309.11540.rjw@sisk.pl> <alpine.LFD.2.00.0812041415020.3543@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041415020.3543@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PhGOJwi5vvqInnV"
Message-Id: <200812050031.27287.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_PhGOJwi5vvqInnV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, 4 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > However, this one appears to work reliably for me (on top of vanilla current
> > mainline):
> 
> Not very interesting. It just does the same thing your previous patches 
> have done - ignores the cardbus slot for sizing. It just does it 
> differently and more explicitly.

There's a difference, though.  It doesn't cause the resources flags to be
cleared for the cardbus bridge and the cardbus bridge gets the correct sizes
of both prefetchable and non-prefetchable windows (64 MB).

> Your original patch did it by simply giving the resources invalid 
> alignments (in a very non-obvious way). This one does it by being explicit 
> and saying "we won't care about cardbus resources behind transparent 
> bridges". But it's still a very hacky thing, and thus not really 
> interesting at all as a patch.
> 
> IOW, it's not a patch that makes sense - it's just a patch that ON YOUR 
> PARTICULAR MACHINE causes us to get the layout you want in order to hide 
> the bug.

I know that. :-)  Still, I find it important to notice that the memory windows
of the cardbus bridge can be 64 MB-wide and things work in that case too.
Also, I like it more than the previous patch. ;-)

Moreover, I _think_ it would work for Frans too, because I _suspect_ the
problem is related to a cardbus bridge being located behind that "transparent"
thing somehow.

> And it doesn't really even do anything new - it's just doing the  
> same thing in an old way.
> 
> But it's interesting that the "don't size _anything_ behind a transparent 
> bridge" apparently made no difference for you.
> 
> Can you send "lspci -vv" and "dmesg" output for that kernel?

No prob, both attached along with the contents of /proc/iomem .

> Even if it failed the suspend/resume, it's interesting, because I would
> actually have expected that one to have the same layout as the successful
> ones. 

Well, not exactly.  Actually, with this patch the graphics and "ICH HD audio"
get their memory ranges before the ranges of _all_ devices behind the
transparent bridge, while in the "working" case their memory ranges are located
_after_ the memory ranges of devices behind the transparent bridge _except_
for the cardbus bridge's memory windows.

Thanks,
Rafael

--Boundary-00=_PhGOJwi5vvqInnV
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg.log"

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.28-rc7-rjw (rafael@chimera) (gcc version 4.2.1 (SUSE Linux)) #57 SMP Thu Dec 4 23:55:55 CET 2008
[    0.000000] Command line: root=/dev/disk/by-id/scsi-SATA_Hitachi_HTS5425080611BB6300ACJRP5TG-part3 edd=off resume=/dev/sda2 vga=0x314
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f750000 (usable)
[    0.000000]  BIOS-e820: 000000007f750000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec18000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec20000 - 00000000fec28000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7f750 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000007f750000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @ 8000-c000
[    0.000000] last_map_addr: 7f750000 end: 7f750000
[    0.000000] RAMDISK: 37770000 - 37feff02
[    0.000000] ACPI: RSDP 000F0210, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 7F750000, 004C (r1 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: FACP 7F750078, 0084 (r2 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: DSDT 7F7500FC, 5CA1 (r2 TOSHIB A0058    20070822 MSFT  100000E)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: SSDT 7F755D9D, 0306 (r2 TOSHIB A0058    20060907 MSFT  100000E)
[    0.000000] ACPI: BOOT 7F750050, 0028 (r1 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: APIC 7F756955, 0068 (r1 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: MCFG 7F7569BD, 003C (r1 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: HPET 7F756A2D, 0038 (r1 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: TCPA 7F756A65, 0032 (r2 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: SLIC 7F756A97, 0176 (r1 TOSHIB A0058    20070822 TASM  4010000)
[    0.000000] ACPI: SSDT 7F756C0D, 016C (r2 TOSHIB A0058    20070309 MSFT  100000E)
[    0.000000] ACPI: SSDT 7F7576BF, 0081 (r2 TOSHIB A0058    20060907 MSFT  100000E)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007f750000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000784d3c]    TEXT DATA BSS ==> [0000200000 - 0000784d3c]
[    0.000000]   #3 [0037770000 - 0037feff02]          RAMDISK ==> [0037770000 - 0037feff02]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f750
[    0.000000] On node 0 totalpages: 521967
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1513 pages reserved
[    0.000000]   DMA zone: 2430 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7082 pages used for memmap
[    0.000000]   DMA32 zone: 510886 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0xd808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 513316
[    0.000000] Kernel command line: root=/dev/disk/by-id/scsi-SATA_Hitachi_HTS5425080611BB6300ACJRP5TG-part3 edd=off resume=/dev/sda2 vga=0x314
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1330.112 MHz processor.
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Memory: 2040900k/2088256k available (2369k kernel code, 388k absent, 46340k reserved, 1741k data, 356k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 2660.22 BogoMIPS (lpj=5320448)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring handled by SMI
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.014425] Setting APIC routing to flat
[    0.014850] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054558] CPU0: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
[    0.056001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 2659.97 BogoMIPS (lpj=5319951)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.141643] CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
[    0.141709] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.144033] Brought up 2 CPUs
[    0.144040] Total of 2 processors activated (5320.19 BogoMIPS).
[    0.144103] CPU0 attaching sched-domain:
[    0.144107]  domain 0: span 0-1 level MC
[    0.144111]   groups: 0 1
[    0.144119] CPU1 attaching sched-domain:
[    0.144121]  domain 0: span 0-1 level MC
[    0.144124]   groups: 1 0
[    0.144213] net_namespace: 1376 bytes
[    0.144297] Time: 23:00:06  Date: 12/04/08
[    0.144297] NET: Registered protocol family 16
[    0.144297] ACPI: bus type pci registered
[    0.144297] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.144297] PCI: Not using MMCONFIG.
[    0.144297] PCI: Using configuration type 1 for base access
[    0.149237] ACPI: EC: Look up EC in DSDT
[    0.154570] ACPI Warning (dsobject-0501): Package List length (C) larger than NumElements count (3), truncated
[    0.154584]  [20080926]
[    0.158240] ACPI: Interpreter enabled
[    0.158247] ACPI: (supports S0 S3 S4 S5)
[    0.158286] ACPI: Using IOAPIC for interrupt routing
[    0.158371] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.163833] PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
[    0.168551] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.181279] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.181308] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.181353] pci 0000:00:02.0: reg 10 32bit mmio: [0xffc80000-0xffcfffff]
[    0.181353] pci 0000:00:02.0: reg 14 io port: [0xcff8-0xcfff]
[    0.181353] pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]
[    0.181353] pci 0000:00:02.0: reg 1c 32bit mmio: [0xffc40000-0xffc7ffff]
[    0.181353] pci 0000:00:02.1: reg 10 32bit mmio: [0x000000-0x07ffff]
[    0.181353] pci 0000:00:1b.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.181353] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.181353] pci 0000:00:1b.0: PME# disabled
[    0.181353] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.181353] pci 0000:00:1c.0: PME# disabled
[    0.181353] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.181353] pci 0000:00:1c.2: PME# disabled
[    0.181353] pci 0000:00:1d.0: reg 20 io port: [0xafe0-0xafff]
[    0.181353] pci 0000:00:1d.1: reg 20 io port: [0xaf80-0xaf9f]
[    0.181353] pci 0000:00:1d.2: reg 20 io port: [0xaf60-0xaf7f]
[    0.181353] pci 0000:00:1d.3: reg 20 io port: [0xaf40-0xaf5f]
[    0.181353] pci 0000:00:1d.7: reg 10 32bit mmio: [0xffc3fc00-0xffc3ffff]
[    0.181353] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.181353] pci 0000:00:1d.7: PME# disabled
[    0.181353] pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH6 ACPI/GPIO/TCO
[    0.181353] pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH6 GPIO
[    0.181353] pci 0000:00:1f.2: reg 10 io port: [0xaf38-0xaf3f]
[    0.181353] pci 0000:00:1f.2: reg 14 io port: [0xaf34-0xaf37]
[    0.181353] pci 0000:00:1f.2: reg 18 io port: [0xaf28-0xaf2f]
[    0.181356] pci 0000:00:1f.2: reg 1c io port: [0xaf24-0xaf27]
[    0.181366] pci 0000:00:1f.2: reg 20 io port: [0xaf10-0xaf1f]
[    0.181377] pci 0000:00:1f.2: reg 24 32bit mmio: [0xffc3f800-0xffc3fbff]
[    0.181402] pci 0000:00:1f.2: PME# supported from D3hot
[    0.181411] pci 0000:00:1f.2: PME# disabled
[    0.181523] pci 0000:01:00.0: reg 10 32bit mmio: [0xff9e0000-0xff9fffff]
[    0.181551] pci 0000:01:00.0: reg 18 io port: [0xbfe0-0xbfff]
[    0.181623] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.181636] pci 0000:01:00.0: PME# disabled
[    0.181696] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.181766] pci 0000:00:1c.0: bridge io port: [0xb000-0xbfff]
[    0.181772] pci 0000:00:1c.0: bridge 32bit mmio: [0xff900000-0xff9fffff]
[    0.181942] pci 0000:02:00.0: reg 10 64bit mmio: [0xff8fe000-0xff8fffff]
[    0.182062] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.182093] pci 0000:02:00.0: PME# disabled
[    0.182550] pci 0000:00:1c.2: bridge 32bit mmio: [0xff800000-0xff8fffff]
[    0.184005] pci 0000:03:0b.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.184020] pci 0000:03:0b.0: supports D1 D2
[    0.184023] pci 0000:03:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.184033] pci 0000:03:0b.0: PME# disabled
[    0.184087] pci 0000:03:0b.1: reg 10 32bit mmio: [0x000000-0x0007ff]
[    0.184098] pci 0000:03:0b.1: reg 14 32bit mmio: [0x000000-0x003fff]
[    0.184149] pci 0000:03:0b.1: supports D1 D2
[    0.184152] pci 0000:03:0b.1: PME# supported from D0 D1 D2 D3hot
[    0.184162] pci 0000:03:0b.1: PME# disabled
[    0.184217] pci 0000:03:0b.3: reg 10 32bit mmio: [0x000000-0x0000ff]
[    0.184276] pci 0000:03:0b.3: supports D1 D2
[    0.184279] pci 0000:03:0b.3: PME# supported from D0 D1 D2 D3hot
[    0.184289] pci 0000:03:0b.3: PME# disabled
[    0.184346] pci 0000:00:1e.0: transparent bridge
[    0.184415] bus 00 -> node 0
[    0.184425] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.184750] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.185003] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.185223] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MPEX._PRT]
[    0.188573] ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
[    0.192116] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
[    0.192410] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
[    0.192699] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
[    0.192987] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
[    0.193274] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
[    0.193562] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
[    0.193850] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
[    0.193948] SCSI subsystem initialized
[    0.193948] PCI: Using ACPI for IRQ routing
[    0.208013] NetLabel: Initializing
[    0.208019] NetLabel:  domain hash size = 128
[    0.208024] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.208058] NetLabel:  unlabeled traffic allowed by default
[    0.208090] PCI-GART: No AMD GART found.
[    0.208105] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.208115] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.228011] pnp: PnP ACPI init
[    0.228028] ACPI: bus type pnp registered
[    0.235698] pnp: PnP ACPI: found 12 devices
[    0.235706] ACPI: ACPI bus type pnp unregistered
[    0.235724] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.235732] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.235741] system 00:00: iomem range 0x100000-0x7f74ffff could not be reserved
[    0.235750] system 00:00: iomem range 0x7f750000-0x7f75ffff has been reserved
[    0.235758] system 00:00: iomem range 0x7f760000-0x7f7fffff has been reserved
[    0.235766] system 00:00: iomem range 0x7f800000-0x7fffffff has been reserved
[    0.235774] system 00:00: iomem range 0xfec00000-0xfec17fff has been reserved
[    0.235783] system 00:00: iomem range 0xfec20000-0xfec27fff has been reserved
[    0.235791] system 00:00: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.235799] system 00:00: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.235807] system 00:00: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.235815] system 00:00: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.235823] system 00:00: iomem range 0xfeda0000-0xfedbffff has been reserved
[    0.235831] system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.235839] system 00:00: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.235848] system 00:00: iomem range 0xffd00000-0xffffffff has been reserved
[    0.235860] system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.235876] system 00:09: ioport range 0x1e0-0x1ef has been reserved
[    0.235884] system 00:09: ioport range 0x480-0x48f has been reserved
[    0.235891] system 00:09: ioport range 0xe000-0xe07f has been reserved
[    0.235899] system 00:09: ioport range 0xe080-0xe0ff has been reserved
[    0.235907] system 00:09: ioport range 0xe400-0xe47f has been reserved
[    0.235914] system 00:09: ioport range 0xe480-0xe4ff has been reserved
[    0.235922] system 00:09: ioport range 0xe800-0xe87f has been reserved
[    0.235930] system 00:09: ioport range 0xe880-0xe8ff has been reserved
[    0.235937] system 00:09: ioport range 0xec00-0xec7f has been reserved
[    0.235945] system 00:09: ioport range 0xec80-0xecff has been reserved
[    0.235953] system 00:09: ioport range 0xd800-0xd87f has been reserved
[    0.235960] system 00:09: ioport range 0xd880-0xd89f has been reserved
[    0.235968] system 00:09: ioport range 0xeeb0-0xeebf has been reserved
[    0.235976] system 00:09: ioport range 0xeec0-0xeeff has been reserved
[    0.235984] system 00:09: ioport range 0x690-0x6ff has been reserved
[    0.235994] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    0.241200] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.241210] pci 0000:00:1c.0:   IO window: 0xb000-0xbfff
[    0.241221] pci 0000:00:1c.0:   MEM window: 0xff900000-0xff9fffff
[    0.241231] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.241245] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.241251] pci 0000:00:1c.2:   IO window: disabled
[    0.241262] pci 0000:00:1c.2:   MEM window: 0xff800000-0xff8fffff
[    0.241272] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.241307] pci 0000:03:0b.0: CardBus bridge, secondary bus 0000:04
[    0.241314] pci 0000:03:0b.0:   IO window: 0x001000-0x0010ff
[    0.241324] pci 0000:03:0b.0:   IO window: 0x001400-0x0014ff
[    0.241333] pci 0000:03:0b.0:   PREFETCH window: 0x8c000000-0x8fffffff
[    0.241344] pci 0000:03:0b.0:   MEM window: 0x90000000-0x93ffffff
[    0.241354] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.241360] pci 0000:00:1e.0:   IO window: disabled
[    0.241371] pci 0000:00:1e.0:   MEM window: disabled
[    0.241380] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.241406] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.241418] pci 0000:00:1c.0: setting latency timer to 64
[    0.241430] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.241441] pci 0000:00:1c.2: setting latency timer to 64
[    0.241451] pci 0000:00:1e.0: setting latency timer to 64
[    0.241462] pci 0000:03:0b.0: enabling device (0000 -> 0003)
[    0.241472] pci 0000:03:0b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.241485] bus: 00 index 0 io port: [0x00-0xffff]
[    0.241492] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.241499] bus: 01 index 0 io port: [0xb000-0xbfff]
[    0.241505] bus: 01 index 1 mmio: [0xff900000-0xff9fffff]
[    0.241511] bus: 01 index 2 mmio: [0x0-0x0]
[    0.241516] bus: 01 index 3 mmio: [0x0-0x0]
[    0.241521] bus: 02 index 0 mmio: [0x0-0x0]
[    0.241527] bus: 02 index 1 mmio: [0xff800000-0xff8fffff]
[    0.241533] bus: 02 index 2 mmio: [0x0-0x0]
[    0.241538] bus: 02 index 3 mmio: [0x0-0x0]
[    0.241543] bus: 03 index 0 mmio: [0x0-0x0]
[    0.241548] bus: 03 index 1 mmio: [0x0-0x0]
[    0.241553] bus: 03 index 2 mmio: [0x0-0x0]
[    0.241558] bus: 03 index 3 io port: [0x00-0xffff]
[    0.241564] bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.241571] bus: 04 index 0 io port: [0x1000-0x10ff]
[    0.241577] bus: 04 index 1 io port: [0x1400-0x14ff]
[    0.241583] bus: 04 index 2 mmio: [0x8c000000-0x8fffffff]
[    0.241589] bus: 04 index 3 mmio: [0x90000000-0x93ffffff]
[    0.241632] NET: Registered protocol family 2
[    0.280082] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.280646] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.283847] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.284834] TCP: Hash tables configured (established 262144 bind 65536)
[    0.284843] TCP reno registered
[    0.296131] NET: Registered protocol family 1
[    0.296308] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.503972] Switched to high resolution mode on CPU 0
[    0.783076]  it is
[    1.298597] Freeing initrd memory: 8703k freed
[    1.305128] Simple Boot Flag value 0xb read from CMOS RAM was invalid
[    1.305142] Simple Boot Flag at 0x7c set to 0x1
[    1.306461] audit: initializing netlink socket (disabled)
[    1.306491] type=2000 audit(1228431607.305:1): initialized
[    1.306856] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.307036] VFS: Disk quotas dquot_6.5.1
[    1.307086] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.307189] msgmni has been set to 4004
[    1.307464] alg: No test for stdrng (krng)
[    1.307481] io scheduler noop registered
[    1.307488] io scheduler anticipatory registered
[    1.307494] io scheduler deadline registered
[    1.307518] io scheduler cfq registered (default)
[    1.308057] pci 0000:00:02.0: Boot video device
[    1.313171] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.313229] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.313280] pcieport-driver 0000:00:1c.0: irq 319 for MSI/MSI-X
[    1.313301] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.313360] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.313589] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.313647] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.313799] pcieport-driver 0000:00:1c.2: irq 318 for MSI/MSI-X
[    1.313819] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.313874] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.314399] vesafb: framebuffer at 0xe0000000, mapped to 0xffffc20004100000, using 1875k, total 7872k
[    1.314410] vesafb: mode is 800x600x16, linelength=1600, pages=7
[    1.314416] vesafb: scrolling: redraw
[    1.314422] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.327854] Console: switching to colour frame buffer device 100x37
[    1.338710] fb0: VESA VGA frame buffer device
[    1.353232] Non-volatile memory driver v1.2
[    1.353428] Linux agpgart interface v0.103
[    1.353588] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    1.356635] brd: module loaded
[    1.356889] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.362155] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.364006] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.365933] mice: PS/2 mouse device common for all mice
[    1.367995] input: PC Speaker as /class/input/input0
[    1.378485] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.397117] cpuidle: using governor ladder
[    1.399494] cpuidle: using governor menu
[    1.402721] registered taskstats version 1
[    1.405441]   Magic number: 4:738:48
[    1.408226] Freeing unused kernel memory: 356k freed
[    1.411246] Write protecting the kernel read-only data: 3820k
[    1.471233] ACPI: SSDT 7F7563E5, 00F3 (r2 TOSHIB A0058    20060907 MSFT  100000E)
[    1.475513] ACPI: SSDT 7F75654E, 034E (r2 TOSHIB A0058    20060907 MSFT  100000E)
[    1.479893] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.483809] processor ACPI_CPU:00: registered as cooling_device0
[    1.488084] ACPI: SSDT 7F7564D8, 0076 (r2 TOSHIB A0058    20060907 MSFT  100000E)
[    1.492875] ACPI: SSDT 7F75689C, 0079 (r2 TOSHIB A0058    20060907 MSFT  100000E)
[    1.497917] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.502467] processor ACPI_CPU:01: registered as cooling_device1
[    1.506447] Marking TSC unstable due to TSC halts in idle
[    1.516663] thermal LNXTHERM:01: registered as thermal_zone0
[    1.521930] ACPI: Thermal Zone [THRM] (66 C)
[    1.547500] libata version 3.00 loaded.
[    1.552220] ahci 0000:00:1f.2: version 3.0
[    1.552249] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.557597] ahci 0000:00:1f.2: irq 317 for MSI/MSI-X
[    1.557685] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    1.562910] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    1.568215] ahci 0000:00:1f.2: setting latency timer to 64
[    1.568408] scsi0 : ahci
[    1.573773] scsi1 : ahci
[    1.578904] scsi2 : ahci
[    1.583949] scsi3 : ahci
[    1.589196] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 317
[    1.594142] ata2: DUMMY
[    1.599067] ata3: DUMMY
[    1.603817] ata4: DUMMY
[    2.000172] Clocksource tsc unstable (delta = -385447840 ns)
[    2.332153] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.337822] ACPI Error (nspredef-0163): \_SB_.PCI0.FNC2.PRT0._GTF: Missing expected return value [20080926]
[    2.348206] ata1.00: ATA-8: Hitachi HTS542516K9SA00, BBCOC33P, max UDMA/133
[    2.353573] ata1.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.360202] ata1.00: configured for UDMA/133
[    2.380464] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54251 BBCO PQ: 0 ANSI: 5
[    2.414442] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.419900] EDD information not available.
[    2.725174] usbcore: registered new interface driver usbfs
[    2.731201] usbcore: registered new interface driver hub
[    2.733432] Driver 'sd' needs updating - please use bus_type methods
[    2.733590] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.733614] sd 0:0:0:0: [sda] Write Protect is off
[    2.733618] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.733656] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.733749] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.733771] sd 0:0:0:0: [sda] Write Protect is off
[    2.733774] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.733812] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.733816]  sda: sda1 sda2 sda3 sda4 < sda5<6>usbcore: registered new device driver usb
[    2.799812] uhci_hcd: USB Universal Host Controller Interface driver
[    2.803584] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.803642] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.819116] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.819122] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.825507]  sda6<6>ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.839762] ehci_hcd 0000:00:1d.7: debug port 1
[    2.846456] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.846479]  sda7 >
[    2.853306] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.860085] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffc3fc00
[    2.884044] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.890788] usb usb1: configuration #1 chosen from 1 choice
[    2.897207] hub 1-0:1.0: USB hub found
[    2.903664] hub 1-0:1.0: 8 ports detected
[    2.909999] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.916314] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.922437] usb usb1: Product: EHCI Host Controller
[    2.928492] usb usb1: Manufacturer: Linux 2.6.28-rc7-rjw ehci_hcd
[    2.928494] usb usb1: SerialNumber: 0000:00:1d.7
[    2.932071] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.932085] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.932090] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.932141] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.932182] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000afe0
[    2.932339] usb usb2: configuration #1 chosen from 1 choice
[    2.932386] hub 2-0:1.0: USB hub found
[    2.932395] hub 2-0:1.0: 2 ports detected
[    2.932533] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.932536] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.932539] usb usb2: Product: UHCI Host Controller
[    2.932541] usb usb2: Manufacturer: Linux 2.6.28-rc7-rjw uhci_hcd
[    2.932543] usb usb2: SerialNumber: 0000:00:1d.0
[    2.932574] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.932582] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.932586] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.932619] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.932670] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000af80
[    2.932788] usb usb3: configuration #1 chosen from 1 choice
[    2.932828] hub 3-0:1.0: USB hub found
[    2.932837] hub 3-0:1.0: 2 ports detected
[    2.932968] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.932971] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.932974] usb usb3: Product: UHCI Host Controller
[    2.932976] usb usb3: Manufacturer: Linux 2.6.28-rc7-rjw uhci_hcd
[    2.932978] usb usb3: SerialNumber: 0000:00:1d.1
[    2.933005] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.933013] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.933017] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.933049] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.933092] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000af60
[    2.933212] usb usb4: configuration #1 chosen from 1 choice
[    2.933252] hub 4-0:1.0: USB hub found
[    2.933261] hub 4-0:1.0: 2 ports detected
[    2.933391] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.933394] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.933397] usb usb4: Product: UHCI Host Controller
[    2.933399] usb usb4: Manufacturer: Linux 2.6.28-rc7-rjw uhci_hcd
[    2.933401] usb usb4: SerialNumber: 0000:00:1d.2
[    2.933432] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.933440] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.933444] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.933483] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.933526] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000af40
[    2.933641] usb usb5: configuration #1 chosen from 1 choice
[    2.933685] hub 5-0:1.0: USB hub found
[    2.933693] hub 5-0:1.0: 2 ports detected
[    2.933829] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.933832] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.933835] usb usb5: Product: UHCI Host Controller
[    2.933837] usb usb5: Manufacturer: Linux 2.6.28-rc7-rjw uhci_hcd
[    2.933839] usb usb5: SerialNumber: 0000:00:1d.3
[    3.461236] PM: Starting manual resume from disk
[    3.628069] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    3.766296] usb 1-4: configuration #1 chosen from 1 choice
[    3.774690] usb 1-4: New USB device found, idVendor=0930, idProduct=0c05
[    3.781178] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.787119] usb 1-4: Product: Optical Drive Controller
[    3.792932] usb 1-4: Manufacturer: TOSHIBA
[    3.855769] kjournald starting.  Commit interval 5 seconds
[    3.862448] EXT3 FS on sda3, internal journal
[    3.868884] EXT3-fs: mounted filesystem with ordered data mode.
[    4.148124] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    4.317422] usb 2-2: configuration #1 chosen from 1 choice
[    4.335436] usb 2-2: New USB device found, idVendor=0930, idProduct=1302
[    4.342122] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=2
[    4.348852] usb 2-2: Product: Novatel Wireless HSDPA Modem
[    4.355510] usb 2-2: Manufacturer: Novatel Wireless
[    4.362125] usb 2-2: SerialNumber: Novatel Wireless HSDPA Modem
[    4.608065] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    4.777838] usb 3-1: configuration #1 chosen from 1 choice
[    4.786985] usb 3-1: New USB device found, idVendor=08ff, idProduct=1600
[    4.793693] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    4.800401] usb 3-1: Product: Fingerprint Sensor
[    5.044063] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    5.225297] usb 4-1: configuration #1 chosen from 1 choice
[    5.237431] usb 4-1: New USB device found, idVendor=046d, idProduct=c526
[    5.243894] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.250257] usb 4-1: Product: USB Receiver
[    5.256375] usb 4-1: Manufacturer: Logitech
[    6.910048] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.086238] iTCO_vendor_support: vendor-support=0
[    7.221463] ACPI Warning (nspredef-0858): \_SB_.BAT1._BIF: Return Package type mismatch at index 12 - found Integer, expected String/Buffer [20080926]
[    7.233732] ACPI: Battery Slot [BAT1] (battery present)
[    7.241393] input: Power Button (FF) as /class/input/input2
[    7.261012] ACPI: AC Adapter [ADP1] (on-line)
[    7.284152] ACPI: Power Button (FF) [PWRF]
[    7.290161] input: Lid Switch as /class/input/input3
[    7.308268] ACPI: Lid Switch [LID]
[    7.314191] input: Power Button (CM) as /class/input/input4
[    7.330658] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    7.336353] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    7.342666] e1000e 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.348572] e1000e 0000:01:00.0: setting latency timer to 64
[    7.348871] e1000e 0000:01:00.0: irq 316 for MSI/MSI-X
[    7.369154] ACPI: Power Button (CM) [PWRB]
[    7.380199] cfg80211: Calling CRDA to update world regulatory domain
[    7.409338] e1000e 0000:01:00.0: Warning: detected ASPM enabled in EEPROM
[    7.472822] 0000:01:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:7e:af:dd:ac
[    7.478447] 0000:01:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    7.484235] 0000:01:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
[    7.509464] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
[    7.515348] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0xd860)
[    7.521224] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.531674] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    7.538278] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    7.547561] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    7.700568] Initializing USB Mass Storage driver...
[    7.708456] scsi4 : SCSI emulation for USB Mass Storage devices
[    7.714637] usbcore: registered new interface driver usb-storage
[    7.720799] USB Mass Storage support registered.
[    7.720975] usb-storage: device found at 4
[    7.720977] usb-storage: waiting for device to settle before scanning
[    7.726997] input: PS/2 Mouse as /class/input/input5
[    7.795742] input: AlpsPS/2 ALPS GlidePoint as /class/input/input6
[    7.925834] rtc_cmos 00:08: RTC can wake from S4
[    7.931808] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    7.938495] rtc0: alarms up to one year, 114 bytes nvram, hpet irqs
[    8.748797] yenta_cardbus 0000:03:0b.0: CardBus bridge found [1179:0001]
[    8.754473] yenta_cardbus 0000:03:0b.0: Enabling burst memory read transactions
[    8.760298] yenta_cardbus 0000:03:0b.0: Using CSCINT to route CSC interrupts to PCI
[    8.765927] yenta_cardbus 0000:03:0b.0: Routing CardBus interrupts to PCI
[    8.771566] yenta_cardbus 0000:03:0b.0: TI: mfunc 0x01aa1022, devctl 0x64
[    8.794719] usbcore: registered new interface driver hiddev
[    8.803607] input: Logitech USB Receiver as /class/input/input7
[    8.840166] generic-usb 0003:046D:C526.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.2-1/input0
[    8.857322] input: Logitech USB Receiver as /class/input/input8
[    8.885028] acpi device:0a: registered as cooling_device2
[    8.891840] input: Video Bus as /class/input/input9
[    8.900251] generic-usb 0003:046D:C526.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.2-1/input1
[    8.912591] usbcore: registered new interface driver usbhid
[    8.918943] usbhid: v2.6:USB HID core driver
[    8.946265] sdhci: Secure Digital Host Controller Interface driver
[    8.952289] sdhci: Copyright(c) Pierre Ossman
[    8.952425] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
[    9.032874] yenta_cardbus 0000:03:0b.0: ISA IRQ mask 0x0cf8, PCI irq 21
[    9.039193] yenta_cardbus 0000:03:0b.0: Socket status: 30000006
[    9.045169] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[    9.065819] firewire_ohci 0000:03:0b.1: enabling device (0000 -> 0002)
[    9.072353] firewire_ohci 0000:03:0b.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    9.152069] firewire_ohci: Added fw-ohci device 0000:03:0b.1, OHCI version 1.10
[    9.158403] sdhci-pci 0000:03:0b.3: SDHCI controller found [104c:803c] (rev 0)
[    9.164857] sdhci-pci 0000:03:0b.3: enabling device (0000 -> 0002)
[    9.171094] sdhci-pci 0000:03:0b.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    9.172574] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[    9.172577] toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
[    9.187726] input: Toshiba RFKill Switch as /class/input/input10
[    9.218430] mmc0: SDHCI controller on PCI [0000:03:0b.3] using DMA
[    9.551971] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    9.558305] HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    9.564851] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.571358] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.656214] firewire_core: created device fw0: GUID 0000390000be012e, S400
[    9.680080] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    9.872681] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[    9.878934] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.879130] usb 5-2: configuration #1 chosen from 1 choice
[    9.891964] iwlagn 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.892354] usb 5-2: New USB device found, idVendor=0930, idProduct=0508
[    9.892358] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.911106] iwlagn 0000:02:00.0: setting latency timer to 64
[    9.914819] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[    9.971524] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
[    9.977853] iwlagn 0000:02:00.0: PCI INT A disabled
[    9.984485] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   10.249982] Bluetooth: Core ver 2.13
[   10.258034] NET: Registered protocol family 31
[   10.263837] Bluetooth: HCI device and connection manager initialized
[   10.269873] Bluetooth: HCI socket layer initialized
[   10.578379] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   10.584301] usbcore: registered new interface driver btusb
[   11.520616] Bluetooth: L2CAP ver 2.11
[   11.526480] Bluetooth: L2CAP socket layer initialized
[   11.563289] Bluetooth: RFCOMM socket layer initialized
[   11.569021] Bluetooth: RFCOMM TTY layer initialized
[   11.574616] Bluetooth: RFCOMM ver 1.10
[   11.674873] Adding 4200988k swap on /dev/sda2.  Priority:-1 extents:1 across:4200988k
[   12.716152] isa bounce pool size: 16 pages
[   12.722950] scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-844S  1.10 PQ: 0 ANSI: 0
[   12.729928] scsi 4:0:0:0: Attached scsi generic sg1 type 5
[   12.743701] usb-storage: device scan complete
[   12.808924] Driver 'sr' needs updating - please use bus_type methods
[   12.822035] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.828086] Uniform CD-ROM driver Revision: 3.20
[   12.834121] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   13.531610] device-mapper: uevent: version 1.0.3
[   13.538112] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   15.022438] loop: module loaded
[   15.066028] kjournald starting.  Commit interval 5 seconds
[   15.066299] EXT3 FS on sda7, internal journal
[   15.066306] EXT3-fs: mounted filesystem with ordered data mode.
[   15.111438] kjournald starting.  Commit interval 5 seconds
[   15.111703] EXT3 FS on sda6, internal journal
[   15.111708] EXT3-fs: mounted filesystem with ordered data mode.
[   15.179126] kjournald starting.  Commit interval 5 seconds
[   15.179408] EXT3 FS on sda5, internal journal
[   15.179413] EXT3-fs: mounted filesystem with ordered data mode.
[   15.373458] fuse init (API version 7.10)
[   19.313397] platform microcode: firmware: requesting intel-ucode/06-0f-0d
[   19.388051] platform microcode: firmware: requesting intel-ucode/06-0f-0d
[   19.398786] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   20.285818] NET: Registered protocol family 10
[   20.291080] lo: Disabled Privacy Extensions
[   20.643977] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   21.067004] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.515617] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   21.522388] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   21.527818] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   21.533190] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   22.066794] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   22.072350] Bluetooth: BNEP filters: protocol multicast
[   24.959113] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   24.959117] EDD information not available.
[   28.017836] e1000e 0000:01:00.0: irq 316 for MSI/MSI-X
[   28.073159] e1000e 0000:01:00.0: irq 316 for MSI/MSI-X
[   28.076079] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   28.086868] iwlagn 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   28.087006] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
[   28.087172] iwlagn 0000:02:00.0: irq 315 for MSI/MSI-X
[   28.087299] iwlagn 0000:02:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   28.457373] Registered led device: iwl-phy0:radio
[   28.458072] Registered led device: iwl-phy0:assoc
[   28.462528] Registered led device: iwl-phy0:RX
[   28.462605] Registered led device: iwl-phy0:TX
[   28.506242] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   28.824609] NET: Registered protocol family 17
[   34.537881] [drm] Initialized drm 1.1.0 20060810
[   34.621165] pci 0000:00:02.0: power state changed by ACPI to D0
[   34.621183] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   34.621192] pci 0000:00:02.0: setting latency timer to 64
[   34.621597] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   37.648145] evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
[  457.782731] CPU0 attaching NULL sched-domain.
[  457.782742] CPU1 attaching NULL sched-domain.
[  457.793186] CPU0 attaching sched-domain:
[  457.793194]  domain 0: span 0-1 level MC
[  457.793199]   groups: 0 1
[  457.793208]   domain 1: span 0-1 level CPU
[  457.793213]    groups: 0-1
[  457.793222] CPU1 attaching sched-domain:
[  457.793227]  domain 0: span 0-1 level MC
[  457.793231]   groups: 1 0
[  457.793238]   domain 1: span 0-1 level CPU
[  457.793243]    groups: 0-1
[  458.838671] wlan0: direct probe to AP 00:1d:7e:aa:87:ee try 1
[  458.843799] wlan0 direct probe responded
[  458.843809] wlan0: authenticate with AP 00:1d:7e:aa:87:ee
[  458.845708] wlan0: authenticated
[  458.845718] wlan0: associate with AP 00:1d:7e:aa:87:ee
[  458.848476] wlan0: RX AssocResp from 00:1d:7e:aa:87:ee (capab=0x411 status=0 aid=1)
[  458.848482] wlan0: associated
[  458.877940] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  462.725909] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  462.877927] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=468 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=448 
[  462.928382] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=242 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=222 
[  463.128769] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=468 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=448 
[  463.379176] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=468 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=448 
[  468.956114] wlan0: no IPv6 routers present
[  469.730168] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  470.608643] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6211 PROTO=2 
[  477.735086] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  480.733900] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=34144 PROTO=2 
[  493.748617] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  525.760640] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  531.279188] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6233 PROTO=2 
[  535.222619] CE: hpet increasing min_delta_ns to 15000 nsec
[  540.934330] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=37454 PROTO=2 
[  589.780169] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  591.189410] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6270 PROTO=2 
[  601.072925] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=41154 PROTO=2 
[  608.068229] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6271 PROTO=UDP SPT=2224 DPT=137 LEN=58 
[  619.154128] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6282 PROTO=UDP SPT=2224 DPT=137 LEN=58 
[  629.164217] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6283 PROTO=UDP SPT=2225 DPT=137 LEN=58 
[  631.551246] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6284 PROTO=UDP SPT=2225 DPT=137 LEN=58 
[  638.804178] CE: hpet increasing min_delta_ns to 22500 nsec
[  643.846962] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6295 PROTO=UDP SPT=2225 DPT=137 LEN=58 
[  650.259141] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6296 PROTO=UDP SPT=2226 DPT=137 LEN=58 
[  656.194406] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6298 PROTO=UDP SPT=2226 DPT=137 LEN=58 
[  668.622210] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6309 PROTO=UDP SPT=2226 DPT=137 LEN=58 
[  711.018111] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6320 PROTO=2 
[  717.847346] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  721.378919] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=49397 PROTO=2 
[  771.777958] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6359 PROTO=2 
[  781.797633] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=52938 PROTO=2 
[  797.932181] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6370 PROTO=UDP SPT=2230 DPT=137 LEN=58 
[  803.982015] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6371 PROTO=UDP SPT=2230 DPT=137 LEN=58 
[  816.428242] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6382 PROTO=UDP SPT=2230 DPT=137 LEN=58 
[  819.032711] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6383 PROTO=UDP SPT=2231 DPT=137 LEN=58 
[  828.810006] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6384 PROTO=UDP SPT=2231 DPT=137 LEN=58 
[  831.689495] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6385 PROTO=2 
[  840.127230] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6386 PROTO=UDP SPT=2232 DPT=137 LEN=58 
[  841.128815] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=00:1f:3b:c3:38:e7:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=192.168.100.100 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=6397 PROTO=UDP SPT=2232 DPT=137 LEN=58 
[  892.444899] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6419 PROTO=2 
[  902.129978] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=60532 PROTO=2 
[  952.360345] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6440 PROTO=2 
[  962.200380] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=63631 PROTO=2 
[  973.927221] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1012.275976] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6461 PROTO=2 
[ 1022.283353] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=16577 PROTO=2 
[ 1072.187524] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6492 PROTO=2 
[ 1082.294164] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=20510 PROTO=2 
[ 1132.103381] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6513 PROTO=2 
[ 1142.424284] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=23675 PROTO=2 
[ 1192.861176] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6534 PROTO=2 
[ 1202.990844] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=27461 PROTO=2 
[ 1253.620878] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=192.168.100.254 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=6565 PROTO=2 
[ 1263.273181] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:1d:7e:aa:87:ee:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=30511 PROTO=2 

--Boundary-00=_PhGOJwi5vvqInnV
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci-vv.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="lspci-vv.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Toshiba America Info Systems Device 0022
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ffc80000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at cff8 [size=8]
	Region 2: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at ffc40000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: intelfb

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device 0022
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 88000000 (32-bit, non-prefetchable) [disabled] [size=512K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at 88080000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: ff900000-ff9fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4161
	Capabilities: [90] Subsystem: Toshiba America Info Systems Device 0001
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: ff800000-ff8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Toshiba America Info Systems Device 0001
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at afe0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at af80 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at af60 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at af40 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at ffc3fc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Toshiba America Info Systems Device 0001

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 317
	Region 0: I/O ports at af38 [size=8]
	Region 1: I/O ports at af34 [size=4]
	Region 2: I/O ports at af28 [size=8]
	Region 3: I/O ports at af24 [size=4]
	Region 4: I/O ports at af10 [size=16]
	Region 5: Memory at ffc3f800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4179
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ahci
	Kernel modules: ahci

01:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 316
	Region 0: Memory at ff9e0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at bfe0 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0100c  Data: 41b1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number ac-dd-af-ff-ff-7e-1c-00
	Kernel driver in use: e1000e
	Kernel modules: e1000e

02:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
	Subsystem: Intel Corporation Device 1101
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 315
	Region 0: Memory at ff8fe000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 41b9
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number e7-38-c3-ff-ff-3b-1f-00
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

03:0b.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at 88088000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: 8c000000-8ffff000 (prefetchable)
	Memory window 1: 90000000-93fff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

03:0b.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller (prog-if 10 [OHCI])
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 20
	Region 0: Memory at 88089000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at 88084000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

03:0b.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller (prog-if 01)
	Subsystem: Toshiba America Info Systems Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at 88089800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci


--Boundary-00=_PhGOJwi5vvqInnV
Content-Type: text/plain;
  charset="iso-8859-1";
  name="proc_iomem.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="proc_iomem.txt"

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000e0000-000eedff : reserved
000eee00-000eefff : ACPI Non-volatile Storage
000ef000-000fffff : reserved
00100000-7f74ffff : System RAM
  00200000-00450686 : Kernel code
  00450687-00603c37 : Kernel data
  00678000-00784d3b : Kernel bss
7f750000-7fffffff : reserved
  7f750000-7f75ffff : pnp 00:00
  7f760000-7f7fffff : pnp 00:00
  7f800000-7fffffff : pnp 00:00
88000000-8807ffff : 0000:00:02.1
88080000-88083fff : 0000:00:1b.0
  88080000-88083fff : ICH HD audio
88084000-88087fff : 0000:03:0b.1
88088000-88088fff : 0000:03:0b.0
  88088000-88088fff : yenta_socket
88089000-880897ff : 0000:03:0b.1
  88089000-880897ff : firewire_ohci
88089800-880898ff : 0000:03:0b.3
  88089800-880898ff : mmc0
8808a000-8808afff : Intel Flush Page
8c000000-8fffffff : PCI CardBus 0000:04
90000000-93ffffff : PCI CardBus 0000:04
e0000000-efffffff : 0000:00:02.0
  e0000000-e07affff : vesafb
f0000000-f3ffffff : PCI MMCONFIG 0
  f0000000-f3ffffff : pnp 00:01
fec00000-fec17fff : reserved
  fec00000-fec17fff : pnp 00:00
    fec00000-fec00fff : IOAPIC 0
fec20000-fec27fff : reserved
  fec20000-fec27fff : pnp 00:00
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
  fed14000-fed19fff : pnp 00:00
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:00
  fed20000-fed3ffff : pnp 00:00
  fed45000-fed8ffff : pnp 00:00
feda0000-fedbffff : reserved
  feda0000-fedbffff : pnp 00:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:00
ff800000-ff8fffff : PCI Bus 0000:02
  ff8fe000-ff8fffff : 0000:02:00.0
    ff8fe000-ff8fffff : iwlagn
ff900000-ff9fffff : PCI Bus 0000:01
  ff9e0000-ff9fffff : 0000:01:00.0
    ff9e0000-ff9fffff : e1000e
ffa00000-ffbfffff : reserved
  ffa00000-ffbfffff : pnp 00:00
ffc3f800-ffc3fbff : 0000:00:1f.2
  ffc3f800-ffc3fbff : ahci
ffc3fc00-ffc3ffff : 0000:00:1d.7
  ffc3fc00-ffc3ffff : ehci_hcd
ffc40000-ffc7ffff : 0000:00:02.0
ffc80000-ffcfffff : 0000:00:02.0
ffd00000-ffffffff : reserved
  ffd00000-ffffffff : pnp 00:00

--Boundary-00=_PhGOJwi5vvqInnV--
