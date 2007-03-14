Return-Path: <linux-kernel-owner+w=401wt.eu-S1751048AbXCNQxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbXCNQxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXCNQxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:53:05 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:39534 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXCNQxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:53:01 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Date: Wed, 14 Mar 2007 10:52:19 -0600
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703140911.16537.bjorn.helgaas@hp.com> <20070314161327.GA14416@skynet.ie>
In-Reply-To: <20070314161327.GA14416@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703141052.19792.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 10:13, Mel Gorman wrote:
> Ok. This looks like another case of HOLES_IN_ZONE hilarity with page_zone().
> As I take a new look at the BUG_ON check in move_freepages(), it isn't even
> necessary as move_freepages_block() already checks the zone boundaries.  At a
> later date when the code has survived a while without new bug reports, I'll
> submit a patch that simply deletes this check because it should be redundant.
> Just in case, I'd like to preserve the check in the non-HOLES_IN_ZONE
> case for now.
> 
> Can you try this patch please? It should apply on top of Yasunori Goto's
> patch.
> ...
> +#ifndef CONFIG_HOLES_IN_ZONE
> +	/*
> +	 * page_zone is not safe to call in this context when
> +	 * CONFIG_HOLES_IN_ZONE is set but this bug check is
> +	 * redundant anyway as we check zone boundaries in
> +	 * move_freepages_block()
> +	 */
>  	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
> +#endif
>  

Your patch applied fine, but I'm sorry to say it still doesn't
work.  I added this patch on top of yours:

--- work-mm10.orig/mm/page_alloc.c      2007-03-14 09:34:42.000000000 -0700
+++ work-mm10/mm/page_alloc.c   2007-03-14 09:42:31.000000000 -0700
@@ -707,6 +707,10 @@
        unsigned long order;
        int blocks_moved = 0;
 
+       printk("%s: zone %s zone_start_pfn 0x%lx start_page 0x%p end_page 0x%p\n",
+               __FUNCTION__, zone->name, zone->zone_start_pfn, start_page,
+               end_page);
+
 #ifndef CONFIG_HOLES_IN_ZONE
        /*
         * page_zone is not safe to call in this context when

and it crashed like this.  Let me know if I can collect more information
for you.


Linux version 2.6.21-rc3-mm2 (helgaas@tiger) (gcc version 4.0.3 (Debian 4.0.3-1)) #7 SMP Wed Mar 14 09:42:50 MST 2007
EFI v1.10 by HP: SALsystab=0x3fb38000 ACPI 2.0=0x3fb2e000 SMBIOS=0x3fb3a000 HCDP=0x3fb2c000
booting generic kernel on platform hpzx1
PCDP: v0 at 0x3fb2c000
Explicit "console="; ignoring PCDP
Early serial console at MMIO 0xff5e0000 (options '115200')
ACPI: RSDP 3FB2E000, 0028 (r2     HP)
ACPI: XSDT 3FB2E02C, 0094 (r1     HP   zx6000        0   HP        0)
ACPI: FACP 3FB36800, 00F4 (r3     HP   zx6000        0   HP        0)
ACPI: DSDT 3FB2E0E0, 5781 (r1     HP   zx6000        7 INTL  2012044)
ACPI: FACS 3FB368F8, 0040
ACPI: SPCR 3FB36938, 0050 (r1     HP   zx6000        0   HP        0)
ACPI: DBGP 3FB36988, 0034 (r1     HP   zx6000        0   HP        0)
ACPI: APIC 3FB36A48, 00B0 (r1     HP   zx6000        0   HP        0)
ACPI: SPMI 3FB369C0, 0050 (r4     HP   zx6000        0   HP        0)
ACPI: CPEP 3FB36A10, 0034 (r1     HP   zx6000        0   HP        0)
ACPI: SSDT 3FB33870, 01D6 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB33A50, 0342 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB33DA0, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB347C0, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB351E0, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB35C00, 0A16 (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB36620, 00EB (r1     HP   zx6000        6 INTL  2012044)
ACPI: SSDT 3FB36710, 00EF (r1     HP   zx6000        6 INTL  2012044)
SAL 3.1: HP version 2.31
SAL Platform features: None
SAL: AP wakeup using external interrupt vector 0xff
No logical to physical processor mapping available
ACPI: Local APIC address c0000000fee00000
GSI 36 (level, low) -> CPU 0 (0x0000) vector 48
2 CPUs available, 2 CPUs total
MCA related initialization done
Virtual mem_map starts at 0xa0007fffc7200000
Zone PFN ranges:
  DMA          1024 ->   262144
  Normal     262144 -> 17039360
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0:     1024 ->    64889
    0:    65216 ->    65227
    0: 16842752 -> 17039194
    0: 17039209 -> 17039236
    0: 17039264 -> 17039343
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Built 1 zonelists.  Total pages: 202189
Kernel command line: BOOT_IMAGE=net0:/helgaas/ia64/vmlinux.gz root=/dev/sda2 console=uart,mmio,0xff5e0000 debug ro
PID hash table entries: 4096 (order: 12, 32768 bytes)
CPU 0: base freq=200.000MHz, ITC ratio=9/2, ITC freq=900.000MHz+/-450ppm
Console: colour VGA+ 80x25
Memory: 4070112k/4150976k available (7303k code, 96672k reserved, 5072k data, 1856k init)
move_freepages: zone Normal zone_start_pfn 0x40000 start_page 0xa0007fffff900000 end_page 0xa0007fffffc80000
Leaving McKinley Errata 9 workaround enabled
Calibrating delay loop... 1347.58 BogoMIPS (lpj=2695168)
Dentry cache hash table entries: 524288 (order: 8, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 7, 2097152 bytes)
Mount-cache hash table entries: 1024
move_freepages: zone Normal zone_start_pfn 0x40000 start_page 0xa0007fffff900000 end_page 0xa0007fffffc80000
move_freepages: zone Normal zone_start_pfn 0x40000 start_page 0xa0007fffff580000 end_page 0xa0007fffff900000
ACPI: Core revision 20070126
Boot processor id 0x0/0x0
Fixed BSP b0 value from CPU 1
CPU 1: synchronized ITC with CPU 0 (last diff -4 cycles, maxerr 435 cycles)
CPU 1: base freq=200.000MHz, ITC ratio=9/2, ITC freq=900.000MHz+/-450ppm
Calibrating delay loop... 1347.58 BogoMIPS (lpj=2695168)
Brought up 2 CPUs
Total of 2 processors activated (2695.16 BogoMIPS).
migration_cost=1878
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
ACPI: Interpreter enabled
ACPI: Using IOSAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Firmware left 0000:00:03.0 e100 interrupts enabled, disabling
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:20)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI1._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:40)
Boot video device is 0000:41:05.0
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI2._PRT]
ACPI: PCI Root Bridge [PCI3] (0000:60)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI3._PRT]
ACPI: PCI Root Bridge [PCI4] (0000:80)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI4._PRT]
ACPI: PCI Root Bridge [PCI6] (0000:c0)
ACPI: PCI Interrupt Routing Table [\_SB_.SBA0.PCI6._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
GSI 34 (edge, high) -> CPU 1 (0x0100) vector 49
GSI 35 (edge, high) -> CPU 0 (0x0000) vector 50
pnp: PnP ACPI: found 10 devices
SCSI subsystem initialized
IOC: zx1 2.2 HPA 0xfed01000 IOVA space 1024Mb at 0x40000000
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 6, 1048576 bytes)
TCP established hash table entries: 524288 (order: 9, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 6, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
perfmon: version 2.0 IRQ 238
perfmon: Itanium 2 PMU detected, 16 PMCs, 18 PMDs, 4 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Total HugeTLB memory allocated, 0
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
EFI Time Services Driver v0.4
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:04: ttyS0 at MMIO 0xff5e0000 (irq = 49) is a 16550A
00:05: ttyS1 at MMIO 0xff5e2000 (irq = 50) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
tg3.c:v3.74 (February 20, 2007)
GSI 29 (level, low) -> CPU 1 (0x0100) vector 51
ACPI: PCI Interrupt 0000:20:02.0[A] -> GSI 29 (level, low) -> IRQ 51
eth0: Tigon3 [partno(BCM95700A6) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:30:6e:38:d9:67
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0] 
eth0: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
CMD649: IDE controller at PCI slot 0000:00:02.0
GSI 21 (level, low) -> CPU 0 (0x0000) vector 52
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 21 (level, low) -> IRQ 52
CMD649: chipset revision 2
CMD649: 100% native mode on irq 52
    ide0: BM-DMA at 0x0d40-0x0d47, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: DW-28E, ATAPI CD/DVD-ROM drive
hda: selected mode 0x42
ide0 at 0xd58-0xd5f,0xd66 on irq 52
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 1698kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
GSI 27 (level, low) -> CPU 1 (0x0100) vector 53
ACPI: PCI Interrupt 0000:20:01.0[A] -> GSI 27 (level, low) -> IRQ 53
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator,Target}
scsi0 : ioc0: LSI53C1030, FwRev=01032300h, Ports=1, MaxQ=255, IRQ=53
scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP04 PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
move_freepages: zone DMA zone_start_pfn 0x400 start_page 0xa0007fffc72e0000 end_page 0xa0007fffc7580000
Unable to handle kernel paging request at virtual address a0007fffc757c020
swapper[1]: Oops 11012296146944 [1]
Modules linked in:

Pid: 1, CPU 1, comm:              swapper
psr : 00001210084a2010 ifs : 800000000000040e ip  : [<a0000001000fe521>]    Not tainted
ip is at move_freepages+0x81/0x2c0
unat: 0000000000000000 pfs : 000000000000040e rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000005981
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a74433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000fe640 b6  : a0000001003f0500 b7  : a00000010000bb20
f6  : 0fffafffffffff0000000 f7  : 0ffdea000000000000000
f8  : 10002a000000000000000 f9  : 100038000000000000000
f10 : 0fffe9ffffffff6000000 f11 : 1003e0000000000000000
r1  : a000000100dfe280 r2  : 0000000000000000 r3  : e000000003101050
r8  : 0000000000000000 r9  : e000000003101070 r10 : e000000003100000
r11 : a0007fffc720e060 r12 : e00000406004fc10 r13 : e000004060048000
r14 : a0007fffc7577268 r15 : e000000003101050 r16 : a0007fffc720e068
r17 : 0000000000000001 r18 : 0000000000100100 r19 : a0007fffc757bc58
r20 : a0007fffc757bc60 r21 : 0000000000000000 r22 : 0000000000000000
r23 : 000000000030c4aa r24 : 000000000037bc30 r25 : 000000000037bc30
r26 : a0007fffc7200000 r27 : a000000100c16850 r28 : a000000100c16850
r29 : a000000100c16528 r30 : a000000100c16528 r31 : 0000000001040000

Call Trace:
 [<a000000100014980>] show_stack+0x40/0xa0
                                sp=e00000406004f7c0 bsp=e000004060049700
 [<a000000100015260>] show_regs+0x880/0x8a0
                                sp=e00000406004f990 bsp=e0000040600496a8
 [<a000000100038900>] die+0x1c0/0x2c0
                                sp=e00000406004f990 bsp=e000004060049660
 [<a00000010005e320>] ia64_do_page_fault+0x820/0x9c0
                                sp=e00000406004f9b0 bsp=e000004060049610
 [<a00000010000c320>] ia64_leave_kernel+0x0/0x270
                                sp=e00000406004fa40 bsp=e000004060049610
 [<a0000001000fe520>] move_freepages+0x80/0x2c0
                                sp=e00000406004fc10 bsp=e000004060049598
 [<a0000001000fe870>] move_freepages_block+0x110/0x140
                                sp=e00000406004fc10 bsp=e000004060049568
 [<a0000001000fed80>] __rmqueue+0x4e0/0x7e0
                                sp=e00000406004fc10 bsp=e000004060049508
 [<a0000001000ff0d0>] rmqueue_bulk+0x50/0x120
                                sp=e00000406004fc10 bsp=e0000040600494c0
 [<a0000001000ff600>] get_page_from_freelist+0x460/0xd40
                                sp=e00000406004fc10 bsp=e000004060049410
 [<a000000100101540>] __alloc_pages+0xa0/0x580
                                sp=e00000406004fc10 bsp=e000004060049398
 [<a000000100147c50>] kmem_getpages+0x150/0x3a0
                                sp=e00000406004fc20 bsp=e000004060049360
 [<a00000010014b060>] cache_grow+0x1e0/0x640
                                sp=e00000406004fc30 bsp=e0000040600492f8
 [<a00000010014b950>] cache_alloc_refill+0x490/0x580
                                sp=e00000406004fc30 bsp=e000004060049290
 [<a00000010014c8e0>] kmem_cache_alloc+0x120/0x1e0
                                sp=e00000406004fc30 bsp=e000004060049260
 [<a0000001005af5b0>] sd_revalidate_disk+0x90/0x1c20
                                sp=e00000406004fc30 bsp=e0000040600491e0
 [<a0000001005b1be0>] sd_probe+0x6c0/0x7c0
                                sp=e00000406004fc70 bsp=e000004060049188
 [<a0000001004c3510>] driver_probe_device+0x230/0x360
                                sp=e00000406004fc80 bsp=e000004060049150
 [<a0000001004c3670>] __device_attach+0x30/0x60
                                sp=e00000406004fc80 bsp=e000004060049128
 [<a0000001004c1340>] bus_for_each_drv+0x80/0x120
                                sp=e00000406004fc80 bsp=e0000040600490f0
 [<a0000001004c3e10>] device_attach+0x190/0x200
                                sp=e00000406004fca0 bsp=e0000040600490b8
 [<a0000001004c1520>] bus_attach_device+0x80/0x160
                                sp=e00000406004fca0 bsp=e000004060049080
 [<a0000001004be6a0>] device_add+0x940/0xf60
                                sp=e00000406004fca0 bsp=e000004060049018
 [<a00000010057d960>] scsi_sysfs_add_sdev+0x60/0x520
                                sp=e00000406004fca0 bsp=e000004060048fc8
 [<a000000100578ce0>] scsi_probe_and_add_lun+0x1000/0x1200
                                sp=e00000406004fca0 bsp=e000004060048f58
 [<a000000100579ab0>] __scsi_scan_target+0x150/0xae0
                                sp=e00000406004fcd0 bsp=e000004060048f00
 [<a00000010057a4a0>] scsi_scan_channel+0x60/0xe0
                                sp=e00000406004fd30 bsp=e000004060048ec0
 [<a00000010057a650>] scsi_scan_host_selected+0x130/0x200
                                sp=e00000406004fd30 bsp=e000004060048e78
 [<a00000010057a890>] do_scsi_scan_host+0x170/0x1a0
                                sp=e00000406004fd30 bsp=e000004060048e50
 [<a00000010057ab90>] scsi_scan_host+0x2d0/0x320
                                sp=e00000406004fd30 bsp=e000004060048e08
 [<a0000001005ca180>] mptspi_probe+0x680/0x6e0
                                sp=e00000406004fd30 bsp=e000004060048db8
 [<a0000001003fdbd0>] pci_device_probe+0x270/0x3a0
                                sp=e00000406004fd30 bsp=e000004060048d78
 [<a0000001004c3510>] driver_probe_device+0x230/0x360
                                sp=e00000406004fd80 bsp=e000004060048d40
 [<a0000001004c3900>] __driver_attach+0x100/0x1a0
                                sp=e00000406004fd80 bsp=e000004060048d10
 [<a0000001004c1120>] bus_for_each_dev+0x80/0x100
                                sp=e00000406004fd80 bsp=e000004060048cd8
 [<a0000001004c2f20>] driver_attach+0x40/0x60
                                sp=e00000406004fda0 bsp=e000004060048cb8
 [<a0000001004c1ff0>] bus_add_driver+0xf0/0x3a0
                                sp=e00000406004fda0 bsp=e000004060048c78
 [<a0000001004c4400>] driver_register+0x160/0x180
                                sp=e00000406004fda0 bsp=e000004060048c58
 [<a0000001003fcd40>] __pci_register_driver+0xc0/0x140
                                sp=e00000406004fda0 bsp=e000004060048c20
 [<a00000010090c800>] mptspi_init+0x180/0x1c0
                                sp=e00000406004fdb0 bsp=e000004060048c00
 [<a0000001008d5580>] init+0x420/0x6c0
                                sp=e00000406004fdb0 bsp=e000004060048bc8
 [<a000000100013610>] kernel_thread_helper+0xd0/0x100
                                sp=e00000406004fe30 bsp=e000004060048ba0
 [<a0000001000094c0>] start_kernel_thread+0x20/0x40
                                sp=e00000406004fe30 bsp=e000004060048ba0
Kernel panic - not syncing: Attempted to kill init!
