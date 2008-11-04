Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYKDQUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYKDQUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYKDQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:20:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:41444 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYKDQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:20:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:sender;
        b=CJNtKVRxl09UmKV+KXHrUCSJLhHsVDZNqi64P21rJZzCTDWt7yzNirEB9J/DyIwHIW
         TsQMUIBUNGGaO6+IJBsD4ytOFBoklmnrOx0fQ1QCltYXE7q6EnnjXtgUTSbRRyVsA9Fr
         It+4Mgts5CTtdw4QsEj1As+QcbuIAfEPMAU/s=
Message-ID: <491076BD.1030704@tuffmail.co.uk>
Date: Tue, 04 Nov 2008 16:22:21 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Add option to passively listen for PCIE hotplug events
References: <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk> <20081104155722.GA23314@srcf.ucam.org>
In-Reply-To: <20081104155722.GA23314@srcf.ucam.org>
Content-Type: multipart/mixed;
 boundary="------------060607040506070205010703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060607040506070205010703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Matthew Garrett wrote:
> On Tue, Nov 04, 2008 at 03:44:23PM +0000, Alan Jenkins wrote:
>
>   
>> I instrumented all the delays I could find. hpc_check_lnk_status() was
>> the only one that came up.  1000ms delay per call, and I get 6 such delays.
>>     
>
> Ok, which is getting called from pciehp_enable_slot(). I'm not quite 
> clear on why this is being called 6 times - any chance you can put a 
> dump_stack() in there? Some are probably directly from the resume code. 
> This confuses me a little, since there's a check for whether there's a 
> card in the slot first. If that fails, pciehp_enable_slot() isn't 
> called. If it succeeds, pciehp_enable_slot checks whether the slot is 
> already powered up. If it is, it bails before doing the link setup. So 
> something funny is going on here, since on the Eee I'd expect those 
> slots to either be empty or already powered up.
>
>   
[ 258.344326] ACPI: Waking up from system sleep state S3

A
[ 259.856649] [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[ 259.856649] [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[ 259.856649] [<e00630b5>] pciehp_power_thread+0x96/0xcd [pciehp]
[ 259.856649] [<e006301f>] pciehp_power_thread+0x0/0xcd [pciehp]
[ 259.856649] [<c01269e6>] run_workqueue+0x62/0xc9
...

B
[ 260.860020] [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[ 260.860020] [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[ 260.860020] [<c01c2270>] resume_iter+0x0/0x25
[ 260.860020] [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[ 260.860020] [<c01c2270>] resume_iter+0x0/0x25
[ 260.860020] [<e0062287>] pciehp_resume+0xce/0xde [pciehp]
[ 260.860020] [<c01c2292>] resume_iter+0x22/0x25
[ 260.860020] [<c02054fa>] device_for_each_child+0x1a/0x3b
[ 260.860020] [<c01bf003>] pci_legacy_resume+0x15/0x16
[ 260.860020] [<c020960f>] pm_op+0x52/0xac
[ 260.860020] [<c0209bd5>] device_resume+0x7d/0x2d2
[ 260.860020] [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
...

[ 263.393352] A

[ 264.396686] B

[ 265.466684] B

[ 266.470019] B

And there are two more during boot (see below), I'd like them to go away 
too please :).

[ 5.370046] [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[ 5.370046] [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[ 5.370046] [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[ 5.370046] [<e00629b8>] pciehp_probe+0x3b2/0x3ee [pciehp]
[ 5.370046] [<c0191e61>] sysfs_do_create_link+0x97/0xd7
[ 5.370046] [<c01c276d>] pcie_port_probe_service+0x29/0x63
[ 5.370046] [<c020759b>] driver_probe_device+0xa1/0x117
[ 5.370046] [<c020765a>] __driver_attach+0x49/0x67
[ 5.370046] [<c0206df8>] bus_for_each_dev+0x35/0x56
[ 5.370046] [<c020744a>] driver_attach+0x11/0x13
[ 5.370046] [<c0207611>] __driver_attach+0x0/0x67
[ 5.370046] [<c020713f>] bus_add_driver+0x91/0x192
[ 5.370046] [<c02077b1>] driver_register+0x6d/0xc2
[ 5.370046] [<c0191561>] sysfs_addrm_finish+0x13/0x16f
[ 5.370046] [<e0033000>] pcied_init+0x0/0x5c [pciehp]
[ 5.370046] [<e003300b>] pcied_init+0xb/0x5c [pciehp]

Thanks
Alan


--------------060607040506070205010703
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc3eeepc (alan@alan-desktop) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #128 Tue Nov 4 16:00:04 GMT 2008
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f780000 (usable)
[    0.000000]  BIOS-e820: 000000001f780000 - 000000001f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7d0000 - 000000001f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x1f780 max_arch_pfn = 0x1000000
[    0.000000] kernel direct mapping tables up to 1f780000 @ 10000-16000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 1f3e0000 - 1f76f13f
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1F780000, 0034 (r1 A M I  OEMRSDT   3000803 MSFT       97)
[    0.000000] ACPI: FACP 1F780200, 0081 (r1 A M I  OEMFACP   3000803 MSFT       97)
[    0.000000] ACPI: DSDT 1F780400, 5F61 (r1  A0797 A0797000        0 INTL 20051117)
[    0.000000] ACPI: FACS 1F790000, 0040
[    0.000000] ACPI: APIC 1F780390, 0068 (r1 A M I  OEMAPIC   3000803 MSFT       97)
[    0.000000] ACPI: OEMB 1F790040, 0046 (r1 A M I  AMI_OEM   3000803 MSFT       97)
[    0.000000] ACPI: MCFG 1F786370, 003C (r1 A M I  OEMMCFG   3000803 MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f780000
[    0.000000]   low ram: 00000000 - 1f780000
[    0.000000]   bootmap 00013000 - 00016ef0
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 001f780000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 00004648a4]    TEXT DATA BSS ==> [0000100000 - 00004648a4]
[    0.000000]   #2 [001f3e0000 - 001f76f13f]          RAMDISK ==> [001f3e0000 - 001f76f13f]
[    0.000000]   #3 [0000465000 - 000046c000]    INIT_PG_TABLE ==> [0000465000 - 000046c000]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #6 [0000013000 - 0000017000]          BOOTMAP ==> [0000013000 - 0000017000]
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f780
[    0.000000] On node 0 totalpages: 128783
[    0.000000] free_area_init_node: node 0, pgdat c03be708, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: Skipping IOAPIC probe due to 'noapic' option.
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: INTEL   
[    0.000000] MPTABLE: Product ID: 
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] I/O APIC #1 Version 32 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 1
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127776
[    0.000000] Kernel command line: root=/dev/sda1 resume=/dev/sda1 resume_offset=12453 ro vga=0xf07 noapic notsc 
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 630.098 MHz processor.
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [tty0] enabled
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Memory: 503408k/515584k available (1646k kernel code, 11620k reserved, 1208k data, 256k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
[    0.000000]     vmalloc : 0xdff80000 - 0xfffaa000   ( 512 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.000000]       .init : 0xc03cc000 - 0xc040c000   ( 256 kB)
[    0.000000]       .data : 0xc029b8d6 - 0xc03c9c70   (1208 kB)
[    0.000000]       .text : 0xc0100000 - 0xc029b8d6   (1646 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.70 BogoMIPS (lpj=2100326)
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 512K
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#0.
[    0.003333] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.003333] Checking 'hlt' instruction... OK.
[    0.016665] Freeing SMP alternatives: 0k freed
[    0.016665] ACPI: Core revision 20080926
[    0.036665] ACPI: setting ELCR to 0200 (from 0ca8)
[    0.039999] net_namespace: 740 bytes
[    0.039999] NET: Registered protocol family 16
[    0.039999] ACPI: bus type pci registered
[    0.039999] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.039999] PCI: Not using MMCONFIG.
[    0.039999] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.039999] PCI: Using configuration type 1 for base access
[    0.046665] ACPI: EC: Look up EC in DSDT
[    0.066665] ACPI: Interpreter enabled
[    0.066665] ACPI: (supports S0 S1 S3 S4 S5)
[    0.066665] ACPI: Using PIC for interrupt routing
[    0.066665] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.073332] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.073332] PCI: Using MMCONFIG for extended config space
[    0.089999] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.089999] ACPI: EC: driver started in poll mode
[    0.089999] ACPI: No dock devices found.
[    0.089999] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.089999] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.089999] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.089999] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.089999] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.089999] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.089999] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.089999] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.089999] pci 0000:00:1b.0: PME# disabled
[    0.089999] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.093332] pci 0000:00:1c.0: PME# disabled
[    0.093332] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.093332] pci 0000:00:1c.1: PME# disabled
[    0.093332] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.093332] pci 0000:00:1c.2: PME# disabled
[    0.093332] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.093332] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.093332] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.093332] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.093332] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.093332] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.093332] pci 0000:00:1d.7: PME# disabled
[    0.093332] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.093332] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.093332] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.093332] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.093332] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.093332] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.093332] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.093332] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.093332] pci 0000:00:1f.2: PME# supported from D3hot
[    0.093332] pci 0000:00:1f.2: PME# disabled
[    0.093332] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.093332] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.093332] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.093332] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.093332] pci 0000:03:00.0: PME# disabled
[    0.093332] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.093332] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.093332] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.093332] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.093332] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.093332] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.093332] pci 0000:00:1e.0: transparent bridge
[    0.093332] bus 00 -> node 0
[    0.093332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.096665] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.096665] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.096665] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.106665] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.109998] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.109998] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.109998] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.113332] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.113332] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.113332] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.116665] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.116665] SCSI subsystem initialized
[    0.116665] libata version 3.00 loaded.
[    0.116665] PCI: Using ACPI for IRQ routing
[    0.116665] hpet clockevent registered
[    0.116665] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.116665] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.119998] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.123332] pnp: PnP ACPI init
[    0.123332] ACPI: bus type pnp registered
[    0.126672] Switched to NOHz mode on CPU #0
[    0.130009] pnp: PnP ACPI: found 13 devices
[    0.130009] ACPI: ACPI bus type pnp unregistered
[    0.130009] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.130009] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.130009] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.130009] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.130009] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.130009] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.130009] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.130009] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.130009] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.130009] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.130009] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.137577] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.137577] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.137577] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.137577] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.137577] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[    0.173337] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.173337] pci 0000:00:1c.0:   IO window: disabled
[    0.173337] pci 0000:00:1c.0:   MEM window: disabled
[    0.173337] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.173337] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.173337] pci 0000:00:1c.1:   IO window: disabled
[    0.173337] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.173337] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.173337] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.173337] pci 0000:00:1c.2:   IO window: disabled
[    0.173337] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.173337] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.173337] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.173337] pci 0000:00:1e.0:   IO window: disabled
[    0.173337] pci 0000:00:1e.0:   MEM window: disabled
[    0.173337] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.173337] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
[    0.173337] PCI: setting IRQ 5 as level-triggered
[    0.173337] pci 0000:00:1c.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[    0.173337] pci 0000:00:1c.0: setting latency timer to 64
[    0.173337] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.176701] PCI: setting IRQ 11 as level-triggered
[    0.176701] pci 0000:00:1c.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[    0.176701] pci 0000:00:1c.1: setting latency timer to 64
[    0.176701] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.176701] PCI: setting IRQ 10 as level-triggered
[    0.176701] pci 0000:00:1c.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    0.176701] pci 0000:00:1c.2: setting latency timer to 64
[    0.176701] pci 0000:00:1e.0: setting latency timer to 64
[    0.176701] bus: 00 index 0 io port: [0x00-0xffff]
[    0.176701] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.176701] bus: 04 index 0 mmio: [0x0-0x0]
[    0.176701] bus: 04 index 1 mmio: [0x0-0x0]
[    0.176701] bus: 04 index 2 mmio: [0x0-0x0]
[    0.176701] bus: 04 index 3 mmio: [0x0-0x0]
[    0.176701] bus: 03 index 0 mmio: [0x0-0x0]
[    0.176701] bus: 03 index 1 mmio: [0xfbf00000-0xfbffffff]
[    0.176701] bus: 03 index 2 mmio: [0x0-0x0]
[    0.176701] bus: 03 index 3 mmio: [0x0-0x0]
[    0.176701] bus: 01 index 0 mmio: [0x0-0x0]
[    0.176701] bus: 01 index 1 mmio: [0xf8000000-0xfbefffff]
[    0.176701] bus: 01 index 2 mmio: [0xf0000000-0xf6ffffff]
[    0.176701] bus: 01 index 3 mmio: [0x0-0x0]
[    0.176701] bus: 05 index 0 mmio: [0x0-0x0]
[    0.176701] bus: 05 index 1 mmio: [0x0-0x0]
[    0.176701] bus: 05 index 2 mmio: [0x0-0x0]
[    0.176701] bus: 05 index 3 io port: [0x00-0xffff]
[    0.176701] bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.176701] NET: Registered protocol family 2
[    0.179669] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.183002] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.183002] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.183002] TCP: Hash tables configured (established 16384 bind 16384)
[    0.183002] TCP reno registered
[    0.183002] NET: Registered protocol family 1
[    0.183002] checking if image is initramfs... it is
[    1.030020] Freeing initrd memory: 3644k freed
[    1.030020] audit: initializing netlink socket (disabled)
[    1.030020] type=2000 audit(1225814774.030:1): initialized
[    1.050010] msgmni has been set to 990
[    1.050010] alg: No test for stdrng (krng)
[    1.050010] io scheduler noop registered
[    1.050010] io scheduler anticipatory registered
[    1.050010] io scheduler deadline registered
[    1.050010] io scheduler cfq registered (default)
[    1.050010] pci 0000:00:02.0: Boot video device
[    1.056679] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.056679] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.056679] pcieport-driver 0000:00:1c.0: irq 47 for MSI/MSI-X
[    1.056679] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.056679] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.056679] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.056679] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.056679] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.056679] pcieport-driver 0000:00:1c.1: irq 46 for MSI/MSI-X
[    1.056679] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.056679] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.056679] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.056679] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.056679] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.056679] pcieport-driver 0000:00:1c.2: irq 45 for MSI/MSI-X
[    1.056679] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.056679] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.056679] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.066678] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    1.070013] brd: module loaded
[    1.070013] Driver 'sd' needs updating - please use bus_type methods
[    1.070013] ahci 0000:00:1f.2: version 3.0
[    1.073348] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 7
[    1.073348] PCI: setting IRQ 7 as level-triggered
[    1.073348] ahci 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    1.073348] ahci 0000:00:1f.2: PCI INT B disabled
[    1.073348] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.073348] ata_piix 0000:00:1f.2: version 2.12
[    1.073348] ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    1.073348] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.073348] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.073348] scsi0 : ata_piix
[    1.073348] scsi1 : ata_piix
[    1.073348] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.073348] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.400001] ata2.00: ATA-4: SILICONMOTION SM223AC, , max UDMA/66
[    1.400001] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.413334] ata2.00: configured for UDMA/66
[    1.413334] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.413334] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[    1.413334] sd 1:0:0:0: [sda] Write Protect is off
[    1.413334] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.413334] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.413334] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[    1.413334] sd 1:0:0:0: [sda] Write Protect is off
[    1.413334] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.413334] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.413334]  sda: sda1
[    1.413334] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.415947] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.445629] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.445629] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.445629] mice: PS/2 mouse device common for all mice
[    1.445629] rtc_cmos 00:03: RTC can wake from S4
[    1.448963] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.448963] rtc0: alarms up to one month, 114 bytes nvram, , hpet irqs irqs
[    1.448963] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    1.448963] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x0860)
[    1.448963] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.448963] iTCO_vendor_support: vendor-support=0
[    1.448963] cpuidle: using governor ladder
[    1.448963] cpuidle: using governor menu
[    1.448963] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    1.448963] ALSA device list:
[    1.448963]   No soundcards found.
[    1.448963] TCP cubic registered
[    1.450470] Using IPI Shortcut mode
[    1.450885] rtc_cmos 00:03: setting system clock to 2008-11-04 16:06:15 UTC (1225814775)
[    1.450885] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    1.450885] Freeing unused kernel memory: 256k freed
[    1.496680] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.900004] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.903344] processor ACPI0007:00: registered as cooling_device0
[    1.903344] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.913831] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    1.913831] Marking TSC unstable due to TSC halts in idle
[    1.927730] thermal LNXTHERM:01: registered as thermal_zone0
[    1.940632] ACPI: Thermal Zone [TZ00] (42 C)
[    2.383353] PM: Starting manual resume from disk
[    3.393347] input: PC Speaker as /class/input/input1
[    3.393347] usbcore: registered new interface driver usbfs
[    3.393347] usbcore: registered new interface driver hub
[    3.393347] usbcore: registered new device driver usb
[    3.420009] usbcore: registered new interface driver libusual
[    3.433342] Initializing USB Mass Storage driver...
[    3.433342] usbcore: registered new interface driver usb-storage
[    3.433342] USB Mass Storage support registered.
[    3.450008] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.450008] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 3
[    3.450008] PCI: setting IRQ 3 as level-triggered
[    3.450008] ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[    3.450008] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.450008] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.450008] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.456710] ehci_hcd 0000:00:1d.7: debug port 1
[    3.456710] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.456710] ehci_hcd 0000:00:1d.7: irq 3, io mem 0xf7eb7c00
[    3.473122] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.473122] usb usb1: configuration #1 chosen from 1 choice
[    3.473122] hub 1-0:1.0: USB hub found
[    3.473122] hub 1-0:1.0: 8 ports detected
[    3.480010] uhci_hcd: USB Universal Host Controller Interface driver
[    3.480010] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[    3.480010] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.480010] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.480010] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.480010] uhci_hcd 0000:00:1d.0: irq 3, io base 0x0000e400
[    3.480010] usb usb2: configuration #1 chosen from 1 choice
[    3.480010] hub 2-0:1.0: USB hub found
[    3.480010] hub 2-0:1.0: 2 ports detected
[    3.480010] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    3.480010] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.480010] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.480010] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.480010] uhci_hcd 0000:00:1d.1: irq 7, io base 0x0000e480
[    3.483342] usb usb3: configuration #1 chosen from 1 choice
[    3.483342] hub 3-0:1.0: USB hub found
[    3.483342] hub 3-0:1.0: 2 ports detected
[    3.483342] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    3.483342] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.483342] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.483342] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.483342] uhci_hcd 0000:00:1d.2: irq 10, io base 0x0000e800
[    3.483342] usb usb4: configuration #1 chosen from 1 choice
[    3.483342] hub 4-0:1.0: USB hub found
[    3.483342] hub 4-0:1.0: 2 ports detected
[    3.483342] uhci_hcd 0000:00:1d.3: PCI INT D -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[    3.483342] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.483342] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.483342] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.483342] uhci_hcd 0000:00:1d.3: irq 5, io base 0x0000e880
[    3.483342] usb usb5: configuration #1 chosen from 1 choice
[    3.483342] hub 5-0:1.0: USB hub found
[    3.483342] hub 5-0:1.0: 2 ports detected
[    3.493681] udev: starting version 131
[    3.493681] udev: deprecated sysfs layout (kernel too old, or CONFIG_SYSFS_DEPRECATED) is unsupported, some udev features may fail
[    3.776689] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    3.900016] usb 1-5: configuration #1 chosen from 1 choice
[    3.906686] scsi2 : SCSI emulation for USB Mass Storage devices
[    3.913352] usb-storage: device found at 2
[    3.913352] usb-storage: waiting for device to settle before scanning
[    4.286673] Linux agpgart interface v0.103
[    4.296674] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    4.296674] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    4.303355] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.310019] input: Power Button (FF) as /class/input/input2
[    4.336684] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.343347] ACPI: Power Button (FF) [PWRF]
[    4.343347] input: Lid Switch as /class/input/input3
[    4.360013] pciehp 0000:00:1c.0:pcie02: HPC vendor_id 8086 device_id 2660 ss_vid 0 ss_did 0
[    4.360013] pciehp 0000:00:1c.0:pcie02: service driver pciehp loaded
[    4.363343] pciehp 0000:00:1c.1:pcie02: HPC vendor_id 8086 device_id 2662 ss_vid 0 ss_did 0
[    4.363343] ACPI: Lid Switch [LID]
[    4.363343] eeepc: Eee PC Hotkey Driver
[    4.363343] eeepc: Hotkey init flags 0x41
[    4.363343] eeepc: Get control methods supported: 0x101711
[    4.366753] input: Asus EeePC extra buttons as /class/input/input4
[    4.396684] input: Sleep Button (CM) as /class/input/input5
[    4.423350] ACPI: Sleep Button (CM) [SLPB]
[    4.423350] input: Power Button (CM) as /class/input/input6
[    4.450022] ACPI: Power Button (CM) [PWRB]
[    4.656689] intel_rng: FWH not detected
[    5.370046] pciehp 0000:00:1c.1:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[    5.370046] Pid: 1915, comm: modprobe Not tainted 2.6.28-rc3eeepc #128
[    5.370046] Call Trace:
[    5.370046]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[    5.370046]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[    5.370046]  [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[    5.370046]  [<e00629b8>] pciehp_probe+0x3b2/0x3ee [pciehp]
[    5.370046]  [<c0191e61>] sysfs_do_create_link+0x97/0xd7
[    5.370046]  [<c01c276d>] pcie_port_probe_service+0x29/0x63
[    5.370046]  [<c020759b>] driver_probe_device+0xa1/0x117
[    5.370046]  [<c020765a>] __driver_attach+0x49/0x67
[    5.370046]  [<c0206df8>] bus_for_each_dev+0x35/0x56
[    5.370046]  [<c020744a>] driver_attach+0x11/0x13
[    5.370046]  [<c0207611>] __driver_attach+0x0/0x67
[    5.370046]  [<c020713f>] bus_add_driver+0x91/0x192
[    5.370046]  [<c02077b1>] driver_register+0x6d/0xc2
[    5.370046]  [<c0191561>] sysfs_addrm_finish+0x13/0x16f
[    5.370046]  [<e0033000>] pcied_init+0x0/0x5c [pciehp]
[    5.370046]  [<e003300b>] pcied_init+0xb/0x5c [pciehp]
[    5.370046]  [<c0101134>] _stext+0x4c/0x136
[    5.370046]  [<c01576c3>] __vunmap+0x7c/0x8a
[    5.370046]  [<c0135324>] load_module+0xfe3/0x10e8
[    5.370046]  [<e0055000>] shpc_remove+0x0/0x1e [shpchp]
[    5.370046]  [<c0116acc>] place_entity+0x6d/0xa3
[    5.370046]  [<c0116979>] wakeup_preempt_entity+0x49/0x60
[    5.370046]  [<c0119973>] check_preempt_wakeup+0xe6/0x10d
[    5.370046]  [<c01354b0>] sys_init_module+0x87/0x177
[    5.374286]  [<c010376d>] sysenter_do_call+0x12/0x21
[    5.374286]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[    5.374286] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[    5.374286] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[    5.374286] pciehp 0000:00:1c.1:pcie02: service driver pciehp loaded
[    5.374286] pciehp 0000:00:1c.2:pcie02: HPC vendor_id 8086 device_id 2664 ss_vid 0 ss_did 0
[    5.374286] HDA Intel 0000:00:1b.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[    5.374286] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.446677] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    5.723355] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    5.850019] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[    6.380049] pciehp 0000:00:1c.2:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[    6.380049] Pid: 1915, comm: modprobe Not tainted 2.6.28-rc3eeepc #128
[    6.380049] Call Trace:
[    6.380049]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[    6.380049]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[    6.380049]  [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[    6.380049]  [<e00629b8>] pciehp_probe+0x3b2/0x3ee [pciehp]
[    6.380049]  [<c0191e61>] sysfs_do_create_link+0x97/0xd7
[    6.380049]  [<c01c276d>] pcie_port_probe_service+0x29/0x63
[    6.380049]  [<c020759b>] driver_probe_device+0xa1/0x117
[    6.380049]  [<c020765a>] __driver_attach+0x49/0x67
[    6.380049]  [<c0206df8>] bus_for_each_dev+0x35/0x56
[    6.380049]  [<c020744a>] driver_attach+0x11/0x13
[    6.380049]  [<c0207611>] __driver_attach+0x0/0x67
[    6.380049]  [<c020713f>] bus_add_driver+0x91/0x192
[    6.380049]  [<c02077b1>] driver_register+0x6d/0xc2
[    6.380049]  [<c0191561>] sysfs_addrm_finish+0x13/0x16f
[    6.380049]  [<e0033000>] pcied_init+0x0/0x5c [pciehp]
[    6.380049]  [<e003300b>] pcied_init+0xb/0x5c [pciehp]
[    6.380049]  [<c0101134>] _stext+0x4c/0x136
[    6.380049]  [<c01576c3>] __vunmap+0x7c/0x8a
[    6.380049]  [<c0135324>] load_module+0xfe3/0x10e8
[    6.380049]  [<e0055000>] shpc_remove+0x0/0x1e [shpchp]
[    6.380049]  [<c0116acc>] place_entity+0x6d/0xa3
[    6.380049]  [<c0116979>] wakeup_preempt_entity+0x49/0x60
[    6.380049]  [<c0119973>] check_preempt_wakeup+0xe6/0x10d
[    6.380049]  [<c01354b0>] sys_init_module+0x87/0x177
[    6.380049]  [<c010376d>] sysenter_do_call+0x12/0x21
[    6.380049]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[    6.380049] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[    6.380049] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[    6.380063] pciehp 0000:00:1c.2:pcie02: service driver pciehp loaded
[    6.380063] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    6.380063] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.390021] ACPI: AC Adapter [AC0] (on-line)
[    6.643347] cfg80211: Using static regulatory domain info
[    6.643347] cfg80211: Regulatory domain: US
[    6.643347] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    6.643347] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    6.643347] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.643347] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.643347] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.643347] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.643347] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    6.643347] cfg80211: Calling CRDA for country: US
[    6.766671] ath5k_pci 0000:01:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    6.766671] ath5k_pci 0000:01:00.0: setting latency timer to 64
[    6.766671] ath5k_pci 0000:01:00.0: registered as 'phy0'
[    6.843348] phy0: Selected rate control algorithm 'pid'
[    6.863370] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    6.876686] udev: renamed network interface wlan0 to ath0
[    7.001210] ACPI: Battery Slot [BAT0] (battery present)
[    7.001210] input: Video Bus as /class/input/input8
[    7.009736] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    7.206674] fuse init (API version 7.10)
[    7.523336] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    7.576210] aes_i586: Unknown symbol crypto_it_tab
[    7.576210] aes_i586: Unknown symbol crypto_aes_set_key
[    7.576210] aes_i586: Unknown symbol crypto_fl_tab
[    7.576210] aes_i586: Unknown symbol crypto_il_tab
[    7.576210] aes_i586: Unknown symbol crypto_ft_tab
[    7.636686] aes_i586: Unknown symbol crypto_it_tab
[    7.636686] aes_i586: Unknown symbol crypto_aes_set_key
[    7.636686] aes_i586: Unknown symbol crypto_fl_tab
[    7.640019] aes_i586: Unknown symbol crypto_il_tab
[    7.640019] aes_i586: Unknown symbol crypto_ft_tab
[    7.996805] Adding 409592k swap on /swapfile.  Priority:-1 extents:704 across:581464k
[    8.753362] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.813336] nf_conntrack version 0.5.0 (8056 buckets, 32224 max)
[    8.816682] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    8.816682] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[    8.816682] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.963348] usb-storage: device scan complete
[    8.963348] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[    8.983359] NET: Registered protocol family 10
[    8.986692] lo: Disabled Privacy Extensions
[    9.000017] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    9.332351] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    9.335685] sd 2:0:0:0: [sdb] Write Protect is off
[    9.335685] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    9.335685] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    9.341221] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    9.343097] sd 2:0:0:0: [sdb] Write Protect is off
[    9.343097] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    9.343097] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    9.346430]  sdb: sdb1
[    9.346430] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    9.346430] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    9.502044] sensors[3236]: segfault at 46 ip b7ecc2cd sp bf8fa590 error 4 in libc-2.7.so[b7e72000+149000]
[    9.502044] sensors[3238]: segfault at 46 ip b7f792cd sp bffa9450 error 4 in libc-2.7.so[b7f1f000+149000]
[   10.360506] ACPI: WMI: Mapper loaded
[   12.015464] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   13.823335] [drm] Initialized drm 1.1.0 20060810
[   13.843347] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[   13.843347] pci 0000:00:02.0: setting latency timer to 64
[   13.843347] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[   13.843347] [drm:i915_driver_load] *ERROR* failed to enable MSI
[   13.843347] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   14.549175] ADDRCONF(NETDEV_UP): ath0: link is not ready
[   15.422572] evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
[  141.479990] NET: Registered protocol family 17
[  142.833322] ath0: authenticate with AP 00:1b:9e:19:45:90
[  142.835861] ath0: authenticated
[  142.835861] ath0: associate with AP 00:1b:9e:19:45:90
[  142.839994] ath0: RX AssocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[  142.839994] ath0: associated
[  142.839994] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
[  162.063362] ath0: no IPv6 routers present
[  228.866647] ath0: No ProbeResp from current AP 00:1b:9e:19:45:90 - assume out of range
[  230.016657] ath0: authenticate with AP 00:1b:9e:19:45:90
[  230.023314] ath0: authenticated
[  230.023314] ath0: associate with AP 00:1b:9e:19:45:90
[  230.026652] ath0: RX ReassocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[  230.026652] ath0: associated
[  254.106660] ath0: deauthenticating by local choice (reason=3)
[  254.661011] ADDRCONF(NETDEV_UP): ath0: link is not ready
[  257.722015] PM: Syncing filesystems ... done.
[  257.722015] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  257.723327] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  257.723327] Suspending console(s) (use no_console_suspend to debug)
[  257.723327] pci 0000:00:02.0: PCI INT A disabled
[  258.276648] sd 1:0:0:0: [sda] Stopping disk
[  258.276648] pciehp 0000:00:1c.2:pcie02: pciehp_suspend ENTRY
[  258.276648] pciehp 0000:00:1c.1:pcie02: pciehp_suspend ENTRY
[  258.276648] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[  258.276648] ath5k_pci 0000:01:00.0: PCI INT A disabled
[  258.289982] ata_piix 0000:00:1f.2: PCI INT B disabled
[  258.303315] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  258.316648] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  258.316648] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  258.316648] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  258.316648] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  258.316648] pciehp 0000:00:1c.2:pcie02: pciehp_suspend ENTRY
[  258.316648] pciehp 0000:00:1c.1:pcie02: pciehp_suspend ENTRY
[  258.316648] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[  258.329981] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  258.343315] ACPI: Preparing to enter system sleep state S3
[  258.343315] Intel machine check architecture supported.
[  258.343315] Intel machine check reporting enabled on CPU#0.
[  258.343315] Back to C!
[  258.343315] Force enabled HPET at resume
[  258.344326] ACPI: Waking up from system sleep state S3
[  258.533309] ACPI: EC: non-query interrupt received, switching to interrupt mode
[  258.834767] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[  258.853356] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  258.853356] HDA Intel 0000:00:1b.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[  258.853356] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  258.853356] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  258.853356] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  258.853356] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  258.853356] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[  258.853356] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  258.853356] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x180106, writing 0x100506)
[  258.853356] pciehp 0000:00:1c.1:pcie02: Card present on Slot(2)
[  258.853356] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[  258.853356] pciehp 0000:00:1c.1:pcie02: pciehp_resume ENTRY
[  259.856649] pciehp 0000:00:1c.1:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  259.856649] Pid: 1918, comm: pciehpd Not tainted 2.6.28-rc3eeepc #128
[  259.856649] Call Trace:
[  259.856649]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  259.856649]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  259.856649]  [<e00630b5>] pciehp_power_thread+0x96/0xcd [pciehp]
[  259.856649]  [<e006301f>] pciehp_power_thread+0x0/0xcd [pciehp]
[  259.856649]  [<c01269e6>] run_workqueue+0x62/0xc9
[  259.856649]  [<c0126f90>] worker_thread+0x0/0xb7
[  259.856649]  [<c012703c>] worker_thread+0xac/0xb7
[  259.856649]  [<c0129029>] autoremove_wake_function+0x0/0x2b
[  259.856649]  [<c0126f90>] worker_thread+0x0/0xb7
[  259.856649]  [<c0128edb>] kthread+0x36/0x5b
[  259.856649]  [<c0128ea5>] kthread+0x0/0x5b
[  259.856649]  [<c0104453>] kernel_thread_helper+0x7/0x10
[  259.856649] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[  259.856649] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[  260.860020] pciehp 0000:00:1c.1:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  260.860020] Pid: 4946, comm: pm-suspend Not tainted 2.6.28-rc3eeepc #128
[  260.860020] Call Trace:
[  260.860020]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  260.860020]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  260.860020]  [<c01c2270>] resume_iter+0x0/0x25
[  260.860020]  [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[  260.860020]  [<c01c2270>] resume_iter+0x0/0x25
[  260.860020]  [<e0062287>] pciehp_resume+0xce/0xde [pciehp]
[  260.860020]  [<c01c2292>] resume_iter+0x22/0x25
[  260.860020]  [<c02054fa>] device_for_each_child+0x1a/0x3b
[  260.860020]  [<c01bf003>] pci_legacy_resume+0x15/0x16
[  260.860020]  [<c020960f>] pm_op+0x52/0xac
[  260.860020]  [<c0209bd5>] device_resume+0x7d/0x2d2
[  260.860020]  [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
[  260.860020]  [<c0135de6>] enter_state+0xdf/0x12e
[  260.860020]  [<c0135ec3>] state_store+0x8e/0xa4
[  260.860020]  [<c0135e35>] state_store+0x0/0xa4
[  260.860020]  [<c01b3bb7>] kobj_attr_store+0x18/0x1c
[  260.860020]  [<c0190b9e>] sysfs_write_file+0xaf/0xdc
[  260.860020]  [<c0190aef>] sysfs_write_file+0x0/0xdc
[  260.860020]  [<c0162964>] vfs_write+0x83/0xf6
[  260.860020]  [<c0162cf5>] sys_write+0x3c/0x63
[  260.860020]  [<c010376d>] sysenter_do_call+0x12/0x21
[  260.860020]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[  260.860020] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[  260.860020] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[  262.386647] irq 10: nobody cared (try booting with the "irqpoll" option)
[  262.386647] Pid: 4946, comm: pm-suspend Not tainted 2.6.28-rc3eeepc #128
[  262.386647] Call Trace:
[  262.386647]  [<c0142b38>] __report_bad_irq+0x24/0x69
[  262.386647]  [<c0142b3f>] __report_bad_irq+0x2b/0x69
[  262.386647]  [<c0142c6a>] note_interrupt+0xed/0x133
[  262.386647]  [<c01420bd>] handle_IRQ_event+0x1a/0x3f
[  262.386647]  [<c0143364>] handle_level_irq+0x4d/0x8d
[  262.386647]  [<c0104e95>] do_IRQ+0x55/0x6c
[  262.386647]  [<c010430b>] common_interrupt+0x23/0x28
[  262.386647]  [<c0230000>] atkbd_set_extra+0x77/0xfb
[  262.386647]  [<c011ec28>] __do_softirq+0x2a/0xbc
[  262.386647]  [<c011ecdc>] do_softirq+0x22/0x26
[  262.386647]  [<c011ef49>] irq_exit+0x25/0x55
[  262.386647]  [<c0104e9a>] do_IRQ+0x5a/0x6c
[  262.386647]  [<c010430b>] common_interrupt+0x23/0x28
[  262.386647]  [<c01bb518>] pci_bus_write_config_word+0x28/0x2e
[  262.386647]  [<c01bd0cb>] pci_restore_state+0x79/0x15c
[  262.386647]  [<c01c2270>] resume_iter+0x0/0x25
[  262.386647]  [<c01c2920>] pcie_portdrv_restore_config+0x9/0x22
[  262.386647]  [<c01c2975>] pcie_portdrv_resume+0x8/0x10
[  262.386647]  [<c01bf003>] pci_legacy_resume+0x15/0x16
[  262.386647]  [<c020960f>] pm_op+0x52/0xac
[  262.386647]  [<c0209bd5>] device_resume+0x7d/0x2d2
[  262.386647]  [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
[  262.386647]  [<c0135de6>] enter_state+0xdf/0x12e
[  262.386647]  [<c0135ec3>] state_store+0x8e/0xa4
[  262.386647]  [<c0135e35>] state_store+0x0/0xa4
[  262.386647]  [<c01b3bb7>] kobj_attr_store+0x18/0x1c
[  262.386647]  [<c0190b9e>] sysfs_write_file+0xaf/0xdc
[  262.386647]  [<c0190aef>] sysfs_write_file+0x0/0xdc
[  262.386647]  [<c0162964>] vfs_write+0x83/0xf6
[  262.386647]  [<c0162cf5>] sys_write+0x3c/0x63
[  262.386647]  [<c010376d>] sysenter_do_call+0x12/0x21
[  262.386647]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[  262.386647] handlers:
[  262.386647] [<e0018d79>] (usb_hcd_irq+0x0/0x57 [usbcore])
[  262.386647] Disabling IRQ #10
[  262.386647] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  262.386647] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x180106, writing 0x100506)
[  262.386647] pciehp 0000:00:1c.2:pcie02: Card present on Slot(3)
[  262.386647] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[  262.386647] pciehp 0000:00:1c.2:pcie02: pciehp_resume ENTRY
[  263.393352] pciehp 0000:00:1c.2:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  263.393352] Pid: 1918, comm: pciehpd Not tainted 2.6.28-rc3eeepc #128
[  263.393352] Call Trace:
[  263.393352]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  263.393352]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  263.393352]  [<e00630b5>] pciehp_power_thread+0x96/0xcd [pciehp]
[  263.393352]  [<e006301f>] pciehp_power_thread+0x0/0xcd [pciehp]
[  263.393352]  [<c01269e6>] run_workqueue+0x62/0xc9
[  263.393352]  [<c0126f90>] worker_thread+0x0/0xb7
[  263.393352]  [<c012703c>] worker_thread+0xac/0xb7
[  263.393352]  [<c0129029>] autoremove_wake_function+0x0/0x2b
[  263.393352]  [<c0126f90>] worker_thread+0x0/0xb7
[  263.393352]  [<c0128edb>] kthread+0x36/0x5b
[  263.393352]  [<c0128ea5>] kthread+0x0/0x5b
[  263.393352]  [<c0104453>] kernel_thread_helper+0x7/0x10
[  263.393352] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[  263.393352] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[  264.396686] pciehp 0000:00:1c.2:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  264.396686] Pid: 4946, comm: pm-suspend Not tainted 2.6.28-rc3eeepc #128
[  264.396686] Call Trace:
[  264.396686]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  264.396686]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  264.396686]  [<c01c2270>] resume_iter+0x0/0x25
[  264.396686]  [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[  264.396686]  [<c01c2270>] resume_iter+0x0/0x25
[  264.396686]  [<e0062287>] pciehp_resume+0xce/0xde [pciehp]
[  264.396686]  [<c01c2292>] resume_iter+0x22/0x25
[  264.396686]  [<c02054fa>] device_for_each_child+0x1a/0x3b
[  264.396686]  [<c01bf003>] pci_legacy_resume+0x15/0x16
[  264.396686]  [<c020960f>] pm_op+0x52/0xac
[  264.396686]  [<c0209bd5>] device_resume+0x7d/0x2d2
[  264.396686]  [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
[  264.396686]  [<c0135de6>] enter_state+0xdf/0x12e
[  264.396686]  [<c0135ec3>] state_store+0x8e/0xa4
[  264.396686]  [<c0135e35>] state_store+0x0/0xa4
[  264.396686]  [<c01b3bb7>] kobj_attr_store+0x18/0x1c
[  264.396686]  [<c0190b9e>] sysfs_write_file+0xaf/0xdc
[  264.396686]  [<c0190aef>] sysfs_write_file+0x0/0xdc
[  264.396686]  [<c0162964>] vfs_write+0x83/0xf6
[  264.396686]  [<c0162cf5>] sys_write+0x3c/0x63
[  264.396686]  [<c010376d>] sysenter_do_call+0x12/0x21
[  264.396686]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[  264.396686] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[  264.396686] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[  264.396686] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[  264.396686] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  264.396686] usb usb2: root hub lost power or was reset
[  264.396686] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[  264.396686] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  264.396686] usb usb3: root hub lost power or was reset
[  264.396686] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[  264.396686] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  264.396686] usb usb4: root hub lost power or was reset
[  264.396686] uhci_hcd 0000:00:1d.3: PCI INT D -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[  264.396686] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  264.396686] usb usb5: root hub lost power or was reset
[  264.410018] ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[  264.410018] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  264.410018] pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x60000, writing 0x600ff)
[  264.410018] pci 0000:00:1e.0: setting latency timer to 64
[  264.423352] ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[  264.423352] ata_piix 0000:00:1f.2: setting latency timer to 64
[  264.423352] ath5k_pci 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  264.423352] ath5k_pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfbef0004)
[  264.423352] ath5k_pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4)
[  264.423352] ath5k_pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  264.436684] ath5k_pci 0000:01:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[  264.456643] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[  264.456643] pciehp 0000:00:1c.1:pcie02: pciehp_resume ENTRY
[  264.600016] ata2.00: configured for UDMA/66
[  264.600016] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[  264.600016] sd 1:0:0:0: [sda] Write Protect is off
[  264.600016] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  264.600016] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  265.466684] pciehp 0000:00:1c.1:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  265.466684] Pid: 4946, comm: pm-suspend Not tainted 2.6.28-rc3eeepc #128
[  265.466684] Call Trace:
[  265.466684]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  265.466684]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  265.466684]  [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[  265.466684]  [<e0062287>] pciehp_resume+0xce/0xde [pciehp]
[  265.466684]  [<c01c2ae2>] pcie_port_bus_resume+0x1f/0x25
[  265.466684]  [<c0209be2>] device_resume+0x8a/0x2d2
[  265.466684]  [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
[  265.466684]  [<c0135de6>] enter_state+0xdf/0x12e
[  265.466684]  [<c0135ec3>] state_store+0x8e/0xa4
[  265.466684]  [<c0135e35>] state_store+0x0/0xa4
[  265.466684]  [<c01b3bb7>] kobj_attr_store+0x18/0x1c
[  265.466684]  [<c0190b9e>] sysfs_write_file+0xaf/0xdc
[  265.466684]  [<c0190aef>] sysfs_write_file+0x0/0xdc
[  265.466684]  [<c0162964>] vfs_write+0x83/0xf6
[  265.466684]  [<c0162cf5>] sys_write+0x3c/0x63
[  265.466684]  [<c010376d>] sysenter_do_call+0x12/0x21
[  265.466684]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[  265.466684] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[  265.466684] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[  265.466684] pciehp 0000:00:1c.2:pcie02: pciehp_resume ENTRY
[  266.470019] pciehp 0000:00:1c.2:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  266.470019] Pid: 4946, comm: pm-suspend Not tainted 2.6.28-rc3eeepc #128
[  266.470019] Call Trace:
[  266.470019]  [<e0064b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  266.470019]  [<e0062eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  266.470019]  [<e0064ded>] hpc_get_adapter_status+0x26/0x65 [pciehp]
[  266.470019]  [<e0062287>] pciehp_resume+0xce/0xde [pciehp]
[  266.470019]  [<c01c2ae2>] pcie_port_bus_resume+0x1f/0x25
[  266.470019]  [<c0209be2>] device_resume+0x8a/0x2d2
[  266.470019]  [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
[  266.470019]  [<c0135de6>] enter_state+0xdf/0x12e
[  266.470019]  [<c0135ec3>] state_store+0x8e/0xa4
[  266.470019]  [<c0135e35>] state_store+0x0/0xa4
[  266.470019]  [<c01b3bb7>] kobj_attr_store+0x18/0x1c
[  266.470019]  [<c0190b9e>] sysfs_write_file+0xaf/0xdc
[  266.470019]  [<c0190aef>] sysfs_write_file+0x0/0xdc
[  266.470019]  [<c0162964>] vfs_write+0x83/0xf6
[  266.470019]  [<c0162cf5>] sys_write+0x3c/0x63
[  266.470019]  [<c010376d>] sysenter_do_call+0x12/0x21
[  266.470019]  [<c0290000>] inet6_lookup_listener+0xac/0xd4
[  266.470019] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[  266.470019] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[  266.470019] sd 1:0:0:0: [sda] Starting disk
[  266.726685] usb 1-5: reset high speed USB device using ehci_hcd and address 2
[  267.963352] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[  267.963352] pci 0000:00:02.0: setting latency timer to 64
[  267.963352] Restarting tasks ... done.
[  269.007495] ADDRCONF(NETDEV_UP): ath0: link is not ready
[  271.646684] evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
[  282.273308] ath0: authenticate with AP 00:1b:9e:19:45:90
[  282.279980] ath0: authenticated
[  282.279980] ath0: associate with AP 00:1b:9e:19:45:90
[  282.279980] ath0: RX AssocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[  282.279980] ath0: associated
[  282.283315] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
[  302.506644] ath0: no IPv6 routers present
[  308.279984] ath0: No ProbeResp from current AP 00:1b:9e:19:45:90 - assume out of range
[  309.439973] ath0: authenticate with AP 00:1b:9e:19:45:90
[  309.444712] ath0: authenticated
[  309.444712] ath0: associate with AP 00:1b:9e:19:45:90
[  309.449984] ath0: RX ReassocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[  309.449984] ath0: associated
[  331.456648] ath0: No ProbeResp from current AP 00:1b:9e:19:45:90 - assume out of range
[  332.583303] ath0: authenticate with AP 00:1b:9e:19:45:90
[  332.589964] ath0: authenticated
[  332.589964] ath0: associate with AP 00:1b:9e:19:45:90
[  332.593308] ath0: RX ReassocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[  332.593308] ath0: associated

--------------060607040506070205010703--
