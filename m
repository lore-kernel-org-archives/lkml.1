Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXAVTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXAVTsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbXAVTsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:48:39 -0500
Received: from mtai03.charter.net ([209.225.8.183]:54512 "EHLO
	mtai03.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbXAVTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:48:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17844.15049.520863.214543@smtp.charter.net>
Date: Sun, 21 Jan 2007 23:17:13 -0500
From: "John Stoffel" <john@stoffel.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: ATA - pata_mpiix.c support for 82371AB chipsets?
In-Reply-To: <20070110171338.5cd555b1@localhost.localdomain>
References: <20070110171338.5cd555b1@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-Chzlrs: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan & Jeff,

I've finally got the new ATA drivers setup and working for my main
data disks, which is great.  But I'm also trying to get my CDRW/DVDROM
drive on the MPIIX (82371AB) chipset working.  I'm running 2.6.20-rc5
currently on a Debian system, using the pata_mpiix as a module.  The
rest of the ATA drivers are all builtin, since I have an HPT302 rev 1
using the pata_hpt37x driver.  

Here's my lspci info, along with the minor changes I made to the
pata_mpiix.c driver to at least try to recognize recognize my chipset.
I assume I'm missing more bits to actually enable it properly, or that
the IDE ports aren't turned on by default somewhere.  

Please let me know if there's any testing I can do here, or hacks or
error reports I can feed you.  

Thanks,
John


----------------------------------------------------------------------
# lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 440GX - 82443GX Host bridge [8086:71a0]
00:01.0 PCI bridge [0604]: Intel Corporation 440GX - 82443GX AGP bridge [8086:71a1]
00:07.0 ISA bridge [0601]: Intel Corporation 82371AB/EB/MB PIIX4 ISA [8086:7110] (rev 02)
00:07.1 IDE interface [0101]: Intel Corporation 82371AB/EB/MB PIIX4 IDE [8086:7111] (rev 01)
00:07.2 USB Controller [0c03]: Intel Corporation 82371AB/EB/MB PIIX4 USB [8086:7112] (rev 01)
00:07.3 Bridge [0680]: Intel Corporation 82371AB/EB/MB PIIX4 ACPI [8086:7113] (rev 02)
00:0e.0 Multimedia audio controller [0401]: Ensoniq ES1371 [AudioPCI-97] [1274:1371] (rev 06)
00:10.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) [3388:0021] (rev 13)
00:11.0 Ethernet controller [0200]: 3Com Corporation 3c905B 100BaseTX [Cyclone] [10b7:9055] (rev 24)
00:13.0 PCI bridge [0604]: Digital Equipment Corporation DECchip 21152 [1011:0024] (rev 03)
01:00.0 VGA compatible controller [0300]: Matrox Graphics, Inc. MGA G400/G450 [102b:0525] (rev 82)
02:08.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 41)
02:08.1 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 41)
02:08.2 USB Controller [0c03]: NEC Corporation USB 2.0 [1033:00e0] (rev 02)
02:0b.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB12LV26 IEEE-1394 Controller (Link) [104c:8020]
03:06.0 RAID bus controller [0104]: Triones Technologies, Inc. HPT302/302N [1103:0006] (rev 01)
03:0a.0 SCSI storage controller [0100]: Adaptec AHA-2940U2/U2W / 7890/7891 [9005:001f]
03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7880U [9004:8078] (rev 01)



----------------------------------------------------------------------
Stupid hack to drivers/ata/pata_mpiix.c
----------------------------------------------------------------------

# diff -u pata_mpiix.c.orig pata_mpiix.c
--- pata_mpiix.c.orig   2007-01-20 21:29:51.000000000 -0500
+++ pata_mpiix.c        2007-01-21 23:00:15.000000000 -0500
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_mpiix"
-#define DRV_VERSION "0.7.3"
+#define DRV_VERSION "0.7.3a"
 
 enum {
        IDETIM = 0x6C,          /* IDE control register */
@@ -214,8 +214,10 @@
           and use it */
 
        pci_read_config_word(dev, IDETIM, &idetim);
-       if (!(idetim & ENABLED))
+       if (!(idetim & ENABLED)) {
+               dev_printk(KERN_DEBUG, &dev->dev, " IDE not enabled on this MPIIX\n");
                return -ENODEV;
+       }
 
        /* We do our own plumbing to avoid leaking special cases for whacko
           ancient hardware into the core code. There are two issues to
@@ -277,6 +279,7 @@
 }
 
 static const struct pci_device_id mpiix[] = {
+       { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371AB), },
        { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371MX), },
 
        { },



----------------------------------------------------------------------------
dmesg bootu
----------------------------------------------------------------------------


[    0.000000] Linux version 2.6.20-rc5 (john@jfsnew) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #46 SMP Sun Jan 21 13:06:19 EST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000002fefe000 end: 000000002fffe000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000002fffe000 size: 0000000000002000 end: 0000000030000000 type: 2
[    0.000000] copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
[    0.000000] copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
[    0.000000] copy_e820_map() start: 00000000ffe00000 size: 0000000000200000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000002fffe000 (usable)
[    0.000000]  BIOS-e820: 000000002fffe000 - 0000000030000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] 767MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe710
[    0.000000] Entering add_active_range(0, 0, 196606) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   196606
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   196606
[    0.000000] On node 0 totalpages: 196606
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1503 pages used for memmap
[    0.000000]   Normal zone: 191007 pages, LIFO batch:31
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP (v000 DELL                                  ) @ 0x000fdee0
[    0.000000] ACPI: RSDT (v001 DELL    WS 610  0x00000002 ASL  0x00000061) @ 0x000fdef4
[    0.000000] ACPI: FADT (v001 DELL    WS 610  0x00000002 ASL  0x00000061) @ 0x000fdf20
[    0.000000] ACPI: MADT (v001 DELL    WS 610  0x00000002 ASL  0x00000061) @ 0x000fdf94
[    0.000000] ACPI: DSDT (v001   DELL    dt_ex 0x00001000 MSFT 0x0100000b) @ 0x00000000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:7 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:7 APIC version 17
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x4])
[    0.000000] ACPI: NMI not connected to LINT 1!
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 30000000:cec00000)
[    0.000000] Detected 547.204 MHz processor.
[  100.810373] Built 1 zonelists.  Total pages: 195071
[  100.868115] Kernel command line: root=/dev/sda2 ro console=tty0  console=ttyS0,9600n8 earlyprintk=serial
[  100.982248] mapped APIC to ffffd000 (fee00000)
[  100.982258] mapped IOAPIC to ffffc000 (fec00000)
[  100.982270] Enabling fast FPU save and restore... done.
[  101.043804] Enabling unmasked SIMD FPU exception support... done.
[  101.116599] Initializing CPU#0
[  101.153067] PID hash table entries: 4096 (order: 12, 16384 bytes)
[  101.225922] disabling early console
[  101.268550] Console: colour VGA+ 80x25
[  104.851500] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[  104.938920] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[  105.113255] Memory: 774140k/786424k available (3058k kernel code, 11760k reserved, 1114k data, 252k init, 0k highmem)
[  105.240320] virtual kernel memory layout:
[  105.240325]     fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
[  105.240331]     vmalloc : 0xf0800000 - 0xfffb5000   ( 247 MB)
[  105.240337]     lowmem  : 0xc0000000 - 0xefffe000   ( 767 MB)
[  105.240342]       .init : 0xc051b000 - 0xc055a000   ( 252 kB)
[  105.240348]       .data : 0xc03fc87f - 0xc051346c   (1114 kB)
[  105.240353]       .text : 0xc0100000 - 0xc03fc87f   (3058 kB)
[  105.701332] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[  105.858286] Calibrating delay using timer specific routine.. 1094.92 BogoMIPS (lpj=547460)
[  105.957644] Mount-cache hash table entries: 512
[  106.012187] CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
[  106.012234] CPU: L1 I cache: 16K, L1 D cache: 16K
[  106.068720] CPU: L2 cache: 512K
[  106.106356] CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
[  106.106379] Intel machine check architecture supported.
[  106.168944] Intel machine check reporting enabled on CPU#0.
[  106.235698] Compat vDSO mapped to ffffe000.
[  106.285820] Checking 'hlt' instruction... OK.
[  106.341939] Freeing SMP alternatives: 16k freed
[  106.396196] ACPI: Core revision 20060707
[  106.468015] CPU0: Intel Pentium III (Katmai) stepping 03
[  106.532336] Booting processor 1/1 eip 2000
[  106.591976] Initializing CPU#1
[  106.651982] Calibrating delay using timer specific routine.. 1094.18 BogoMIPS (lpj=547091)
[  106.652000] CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
[  106.652028] CPU: L1 I cache: 16K, L1 D cache: 16K
[  106.652036] CPU: L2 cache: 512K
[  106.652045] CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
[  106.652063] Intel machine check architecture supported.
[  106.652075] Intel machine check reporting enabled on CPU#1.
[  106.652671] CPU1: Intel Pentium III (Katmai) stepping 03
[  107.075776] Total of 2 processors activated (2189.10 BogoMIPS).
[  107.147691] ENABLING IO-APIC IRQs
[  107.187791] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[  107.370718] checking TSC synchronization across 2 CPUs: passed.
[    0.010450] Brought up 2 CPUs
[    0.523362] migration_cost=3612
[    0.562441] NET: Registered protocol family 16
[    0.615936] ACPI: bus type pci registered
[    0.694431] PCI: PCI BIOS revision 2.10 entry at 0xfca1e, last bus=3
[    0.770549] PCI: Using configuration type 1
[    0.820651] Setting up standard PCI resources
[    0.892395] ACPI: Interpreter enabled
[    0.936263] ACPI: Using IOAPIC for interrupt routing
[    0.997306] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.054688] PCI: Probing PCI hardware (bus 00)
[    1.054755] ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
[    1.120925] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
[    1.120932] * this clock source is slow. Consider trying other clock sources
[    1.291853] PCI quirk: region 0800-083f claimed by PIIX4 ACPI
[    1.360622] PCI quirk: region 0850-085f claimed by PIIX4 SMB
[    1.428828] Boot video device is 0000:01:00.0
[    1.429868] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.438217] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    1.447776] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.534915] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.622102] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    1.709216] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    1.795413] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.863184] pnp: PnP ACPI init
[    1.923718] pnp: PnP ACPI: found 13 devices
[    1.973773] PnPBIOS: Disabled by ACPI PNP
[    2.022299] SCSI subsystem initialized
[    2.067399] libata version 2.00 loaded.
[    2.067625] usbcore: registered new interface driver usbfs
[    2.133480] usbcore: registered new interface driver hub
[    2.197256] usbcore: registered new device driver usb
[    2.257888] PCI: Using ACPI for IRQ routing
[    2.307998] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    2.426248] pnp: 00:0c: ioport range 0x800-0x85f could not be reserved
[    2.505573] PCI: Bridge: 0000:00:01.0
[    2.549392]   IO window: disabled.
[    2.590141]   MEM window: fc000000-fdffffff
[    2.641015]   PREFETCH window: f2000000-f5ffffff
[    2.696287] PCI: Bridge: 0000:00:10.0
[    2.740150]   IO window: disabled.
[    2.780907]   MEM window: fa000000-fbffffff
[    2.831016]   PREFETCH window: f6000000-f6ffffff
[    2.886328] PCI: Bridge: 0000:00:13.0
[    2.930190]   IO window: e000-efff
[    2.970944]   MEM window: f8000000-f9ffffff
[    3.021053]   PREFETCH window: f1000000-f1ffffff
[    3.076496] NET: Registered protocol family 2
[    3.140433] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    3.226573] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    3.320140] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    3.401763] TCP: Hash tables configured (established 131072 bind 65536)
[    3.480985] TCP reno registered
[    3.524039] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[    3.613510] io scheduler noop registered
[    3.660701] io scheduler anticipatory registered (default)
[    3.726820] io scheduler deadline registered
[    3.778232] io scheduler cfq registered
[    3.825070] input: Power Button (FF) as /class/input/input0
[    3.891845] ACPI: Power Button (FF) [PWRF]
[    3.941426] ibm_acpi: ec object not found
[    3.989492] isapnp: Scanning for PnP cards...
[    4.398354] isapnp: No Plug & Play device found
[    4.565109] Cyclades driver 2.4
[    4.602831]         built Jan 20 2007 21:47:50
[    5.014692] Cyclom-Y/ISA #1: 0xc00de000-0xc00dffff, IRQ11, 8 channels starting from port 0.
[    5.115149] Real Time Clock Driver v1.12ac
[    5.164173] Linux agpgart interface v0.101 (c) Dave Jones
[    5.228957] agpgart: Detected an Intel 440GX Chipset.
[    5.298968] agpgart: AGP aperture is 64M @ 0xec000000
[    5.359618] [drm] Initialized drm 1.1.0 20060810
[    5.414973] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    5.505080] [drm] Initialized mga 3.2.1 20051102 on minor 0
[    5.571823] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    5.665830] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.738622] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.812981] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.880575] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.948141] Floppy drive(s): fd0 is 1.44M
[    6.009034] FDC 0 is a National Semiconductor PC87306
[    6.071839] loop: loaded (max 8 devices)
[    6.118997] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 17 (level, low) -> IRQ 17
[    6.207821] 3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
[    6.294323] 0000:00:11.0: 3Com PCI 3c905B Cyclone 100baseTx at f0802000.
[    6.396799] ACPI: PCI Interrupt 0000:03:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
[   21.690346] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   21.690353]         <Adaptec aic7890/91 Ultra2 SCSI adapter>
[   21.690359]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   21.690365] 
[   21.943182] ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 18 (level, low) -> IRQ 18
[   22.060035] scsi 0:0:0:0: Direct-Access     COMPAQ   HC01841729       3208 PQ: 0 ANSI: 2
[   22.156925] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   22.222825]  target0:0:0: Beginning Domain Validation
[   22.288883]  target0:0:0: wide asynchronous
[   22.343120]  target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   22.429978]  target0:0:0: Domain Validation skipping write tests
[   22.501938]  target0:0:0: Ending Domain Validation
[   22.562767] scsi 0:0:1:0: Direct-Access     COMPAQ   BD018222CA       B016 PQ: 0 ANSI: 2
[   22.659666] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   22.725574]  target0:0:1: Beginning Domain Validation
[   22.787945]  target0:0:1: wide asynchronous
[   22.839359]  target0:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 63)
[   22.923669]  target0:0:1: Domain Validation skipping write tests
[   22.995640]  target0:0:1: Ending Domain Validation
[   37.167547] scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   37.167555]         <Adaptec aic7880 Ultra SCSI adapter>
[   37.167560]         aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
[   37.167566] 
[   37.412031] st: Version 20061107, fixed bufsize 32768, s/g segs 256
[   37.488723]  target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   37.573489] SCSI device sda: 35566000 512-byte hdwr sectors (18210 MB)
[   37.653976] sda: Write Protect is off
[   37.697837] sda: Mode Sense: c7 00 10 08
[   37.699480] SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and FUA
[   37.802582] SCSI device sda: 35566000 512-byte hdwr sectors (18210 MB)
[   37.883096] sda: Write Protect is off
[   37.926959] sda: Mode Sense: c7 00 10 08
[   37.928604] SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and FUA
[   38.030730]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   38.117951] sd 0:0:0:0: Attached scsi disk sda
[   38.172131]  target0:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 63)
[   38.458572] SCSI device sdb: 35565080 512-byte hdwr sectors (18209 MB)
[   38.539909] sdb: Write Protect is off
[   38.583774] sdb: Mode Sense: af 00 10 08
[   38.585231] SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and FUA
[   38.687837] SCSI device sdb: 35565080 512-byte hdwr sectors (18209 MB)
[   38.769180] sdb: Write Protect is off
[   38.813001] sdb: Mode Sense: af 00 10 08
[   38.814452] SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and FUA
[   38.916564]  sdb:<5>scsi 1:0:5:0: Sequential-Access SUN      DLT7000          245F PQ: 0 ANSI: 2
[   38.943885] 
[   39.040918]  target1:0:5: Beginning Domain Validation
[   39.041050] sd 0:0:1:0: Attached scsi disk sdb
[   39.041245] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   39.041413] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   39.041610] pata_hpt37x: BIOS has not set timing clocks.
[   39.043839] hpt37x: HPT302: Bus clock 33MHz.
[   39.043873] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level, low) -> IRQ 18
[   39.044019] ata1: PATA max UDMA/133 cmd 0xECF8 ctl 0xECF2 bmdma 0xE800 irq 18
[   39.044141] ata2: PATA max UDMA/133 cmd 0xECE0 ctl 0xECDA bmdma 0xE808 irq 18
[   39.044165] scsi2 : pata_hpt37x
[   39.198276] ata1.00: ATA-5, max UDMA/100, 234441648 sectors: LBA 
[   39.198287] ata1.00: ata1: dev 0 multi count 16
[   39.198319] Find mode for 12 reports C829C62
[   39.198337] Find mode for DMA 69 reports 1C6DDC62
[   39.202284] ata1.00: configured for UDMA/100
[   39.202303] scsi3 : pata_hpt37x
[   39.357210] ata2.00: ATA-6, max UDMA/100, 234441648 sectors: LBA48 
[   39.357220] ata2.00: ata2: dev 0 multi count 16
[   39.357243] Find mode for 12 reports C829C62
[   39.357261] Find mode for DMA 69 reports 1C6DDC62
[   39.362225] ata2.00: configured for UDMA/100
[   39.362502] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1200JB-00C 17.0 PQ: 0 ANSI: 5
[   39.362908] SCSI device sdc: 234441648 512-byte hdwr sectors (120034 MB)
[   39.362954] sdc: Write Protect is off
[   39.362963] sdc: Mode Sense: 00 3a 00 00
[   39.363031] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.363190] SCSI device sdc: 234441648 512-byte hdwr sectors (120034 MB)
[   39.363232] sdc: Write Protect is off
[   39.363240] sdc: Mode Sense: 00 3a 00 00
[   39.363307] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.363323]  sdc: sdc1
[   40.893537] sd 2:0:0:0: Attached scsi disk sdc
[   40.897482]  target1:0:5: wide asynchronous
[   40.900398]  target1:0:5: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 8)
[   40.902531]  target1:0:5: Domain Validation skipping write tests
[   40.902540]  target1:0:5: Ending Domain Validation
[   41.209905] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   41.273771] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1200JB-00E 15.0 PQ: 0 ANSI: 5
[   41.371093] SCSI device sdd: 234441648 512-byte hdwr sectors (120034 MB)
[   41.451446] sdd: Write Protect is off
[   41.495355] sdd: Mode Sense: 00 3a 00 00
[   41.495494] SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   41.602961] SCSI device sdd: 234441648 512-byte hdwr sectors (120034 MB)
[   41.683249] sdd: Write Protect is off
[   41.727076] sdd: Mode Sense: 00 3a 00 00
[   41.727148] SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   41.834485]  sdd: sdd1
[   41.877496] sd 3:0:0:0: Attached scsi disk sdd
[   41.931028] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   41.994753] usbmon: debugfs is not available
[   42.046106] ACPI: PCI Interrupt 0000:02:08.2[C] -> GSI 17 (level, low) -> IRQ 17
[   42.134932] ehci_hcd 0000:02:08.2: EHCI Host Controller
[   42.197683] ehci_hcd 0000:02:08.2: new USB bus registered, assigned bus number 1
[   42.306630] ehci_hcd 0000:02:08.2: irq 17, io mem 0xfaffdc00
[   42.374439] ehci_hcd 0000:02:08.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
[   42.464521] usb usb1: configuration #1 chosen from 1 choice
[   42.531476] hub 1-0:1.0: USB hub found
[   42.576454] hub 1-0:1.0: 5 ports detected
[   42.725797] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
[   42.725960] ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 19 (level, low) -> IRQ 19
[   42.814713] ohci_hcd 0000:02:08.0: OHCI Host Controller
[   42.877450] ohci_hcd 0000:02:08.0: new USB bus registered, assigned bus number 2
[   42.966116] ohci_hcd 0000:02:08.0: irq 19, io mem 0xfafff000
[   43.074325] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   43.295708] usb 1-3: configuration #1 chosen from 1 choice
[   43.676944] usb usb2: configuration #1 chosen from 1 choice
[   43.707095] st 1:0:5:0: Attached scsi tape st0
[   43.707106] st 1:0:5:0: st0: try direct i/o: yes (alignment 512 B)
[   43.707395] st 1:0:5:0: Attached scsi generic sg4 type 1
[   43.935484] hub 2-0:1.0: USB hub found
[   43.980416] hub 2-0:1.0: 3 ports detected
[   44.539146] ACPI: PCI Interrupt 0000:02:08.1[B] -> GSI 16 (level, low) -> IRQ 16
[   44.627965] ohci_hcd 0000:02:08.1: OHCI Host Controller
[   44.690713] ohci_hcd 0000:02:08.1: new USB bus registered, assigned bus number 3
[   44.779363] ohci_hcd 0000:02:08.1: irq 16, io mem 0xfaffe000
[   45.408264] usb usb3: configuration #1 chosen from 1 choice
[   45.475168] hub 3-0:1.0: USB hub found
[   45.520047] hub 3-0:1.0: 2 ports detected
[   46.078536] USB Universal Host Controller Interface driver v3.0
[   46.149589] ACPI: PCI Interrupt 0000:00:07.2[D] -> GSI 19 (level, low) -> IRQ 19
[   46.238393] uhci_hcd 0000:00:07.2: UHCI Host Controller
[   46.301140] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 4
[   46.389791] uhci_hcd 0000:00:07.2: irq 19, io base 0x0000dce0
[   46.459031] usb usb4: configuration #1 chosen from 1 choice
[   46.506040] usb 3-2: new full speed USB device using ohci_hcd and address 2
[   46.609313] hub 4-0:1.0: USB hub found
[   46.641862] usb 3-2: configuration #1 chosen from 1 choice
[   46.644656] hub 3-2:1.0: USB hub found
[   46.647497] hub 3-2:1.0: 4 ports detected
[   46.812891] hub 4-0:1.0: 2 ports detected
[   46.948295] usb 3-2.1: new full speed USB device using ohci_hcd and address 3
[   47.034074] Initializing USB Mass Storage driver...
[   47.092845] scsi4 : SCSI emulation for USB Mass Storage devices
[   47.163966] usb-storage: device found at 2
[   47.163976] usb-storage: waiting for device to settle before scanning
[   47.176475] usb 3-2.1: configuration #1 chosen from 1 choice
[   47.256133] usbcore: registered new interface driver usb-storage
[   47.328083] USB Mass Storage support registered.
[   47.383514] usbcore: registered new interface driver hiddev
[   47.450356] usbcore: registered new interface driver usbhid
[   47.517083] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   47.591411] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   47.682144] serio: i8042 KBD port at 0x60,0x64 irq 1
[   47.741638] serio: i8042 AUX port at 0x60,0x64 irq 12
[   47.802465] mice: PS/2 mouse device common for all mice
[   47.888683] usb 3-2.2: new full speed USB device using ohci_hcd and address 4
[   47.898303] input: AT Translated Set 2 keyboard as /class/input/input1
[   48.052804] input: PC Speaker as /class/input/input2
[   48.213799] usb 3-2.2: configuration #1 chosen from 1 choice
[   48.639437] input: ImPS/2 Generic Wheel Mouse as /class/input/input3
[   48.718324] md: linear personality registered for level -1
[   48.784032] md: raid0 personality registered for level 0
[   48.847648] md: raid1 personality registered for level 1
[   48.911271] md: raid10 personality registered for level 10
[   48.994165] raid6: int32x1    144 MB/s
[   49.055943] raid6: int32x2    128 MB/s
[   49.117824] raid6: int32x4    140 MB/s
[   49.178917] raid6: int32x8    136 MB/s
[   49.240770] raid6: mmxx1      367 MB/s
[   49.301779] raid6: mmxx2      421 MB/s
[   49.362866] raid6: sse1x1     300 MB/s
[   49.424748] raid6: sse1x2     382 MB/s
[   49.469631] raid6: using algorithm sse1x2 (382 MB/s)
[   49.529103] md: raid6 personality registered for level 6
[   49.592723] md: raid5 personality registered for level 5
[   49.656345] md: raid4 personality registered for level 4
[   49.719971] raid5: automatically using best checksumming function: pIII_sse
[   49.807546]    pIII_sse  :  1132.000 MB/sec
[   49.857606] raid5: using function: pIII_sse (1132.000 MB/sec)
[   49.926716] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   50.027815] EDAC MC: Ver: 2.0.1 Jan 20 2007
[   50.108316] TCP cubic registered
[   50.147029] Initializing XFRM netlink socket
[   50.198238] NET: Registered protocol family 1
[   50.250385] NET: Registered protocol family 17
[   50.303599] NET: Registered protocol family 15
[   50.356995] Starting balanced_irq
[   50.396757] Using IPI Shortcut mode
[   50.439174] md: Autodetecting RAID arrays.
[   50.439306] Time: tsc clocksource has been installed.
[   50.558339] md: invalid raid superblock magic on sda1
[   50.618811] md: sda1 has invalid sb, not importing!
[   50.683927] md: invalid raid superblock magic on sda2
[   50.744391] md: sda2 has invalid sb, not importing!
[   50.813290] md: invalid raid superblock magic on sda5
[   50.873821] md: sda5 has invalid sb, not importing!
[   50.944968] md: invalid raid superblock magic on sda6
[   51.005429] md: sda6 has invalid sb, not importing!
[   51.087320] md: autorun ...
[   51.120818] md: considering sdd1 ...
[   51.163683] md:  adding sdd1 ...
[   51.202344] md:  adding sdc1 ...
[   51.241001] md: created md0
[   51.274469] md: bind<sdc1>
[   51.306948] md: bind<sdd1>
[   51.339360] md: running: <sdd1><sdc1>
[   51.384184] raid1: raid set md0 active with 2 out of 2 mirrors
[   51.477131] md0: bitmap initialized from disk: read 15/15 pages, set 0 bits, status: 0
[   51.571916] created bitmap (224 pages) for device md0
[   51.693323] md: ... autorun DONE.
[   51.752532] kjournald starting.  Commit interval 5 seconds
[   51.752556] EXT3-fs: mounted filesystem with ordered data mode.
[   51.752702] VFS: Mounted root (ext3 filesystem) readonly.
[   51.753560] Freeing unused kernel memory: 252k freed
[   53.990240] usb-storage: device scan complete
[   53.991836] scsi 4:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0001 PQ: 0 ANSI: 0
[   54.097642] scsi 4:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0001 PQ: 0 ANSI: 0
[   54.209968] scsi 4:0:0:2: Direct-Access     Generic  STORAGE DEVICE   0001 PQ: 0 ANSI: 0
[   54.323921] scsi 4:0:0:3: Direct-Access     Generic  STORAGE DEVICE   0001 PQ: 0 ANSI: 0
[   54.432339] sd 4:0:0:0: Attached scsi removable disk sde
[   54.496141] sd 4:0:0:0: Attached scsi generic sg5 type 0
[   54.568173] sd 4:0:0:1: Attached scsi removable disk sdf
[   54.646005] sd 4:0:0:1: Attached scsi generic sg6 type 0
[   54.728737] SCSI device sdg: 13280 512-byte hdwr sectors (7 MB)
[   54.809591] sdg: Write Protect is off
[   54.853435] sdg: Mode Sense: 02 00 00 00
[   54.853444] sdg: assuming drive cache: write through
[   54.917693] SCSI device sdg: 13280 512-byte hdwr sectors (7 MB)
[   54.990474] sdg: Write Protect is off
[   55.034332] sdg: Mode Sense: 02 00 00 00
[   55.034341] sdg: assuming drive cache: write through
[   55.093793]  sdg: sdg1
[   55.125721] sd 4:0:0:2: Attached scsi removable disk sdg
[   55.189482] sd 4:0:0:2: Attached scsi generic sg7 type 0
[   55.255949] sd 4:0:0:3: Attached scsi removable disk sdh
[   55.319734] sd 4:0:0:3: Attached scsi generic sg8 type 0
[   57.653323] pata_mpiix 0000:00:07.1: version 0.7.3
[   57.653342] pata_mpiix 0000:00:07.1:  IDE not enabled on this MPIIX
[   57.721966] piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
[   57.967435] usbcore: registered new interface driver usbserial
[   58.037430] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   58.132367] usbcore: registered new interface driver usbserial_generic
[   58.210804] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   58.345269] ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 18 (level, low) -> IRQ 18
[   58.484739] drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
[   58.485013] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[18]  MMIO=[faffd000-faffd7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   58.717208] pl2303 3-2.1:1.0: pl2303 converter detected
[   58.779990] drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
[   58.783388] usb 3-2.1: pl2303 converter now attached to ttyUSB0
[   58.783440] usbcore: registered new interface driver pl2303
[   58.783451] drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
[   59.110397] mct_u232 3-2.2:1.0: MCT U232 converter detected
[   59.179575] usb 3-2.2: MCT U232 converter now attached to ttyUSB1
[   59.252708] usbcore: registered new interface driver mct_u232
[   59.321504] drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232 converter driver z2.0
[   59.627665] ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 17 (level, low) -> IRQ 17
[   60.473339] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[005042b500016243]
[   61.642761] Adding 996020k swap on /dev/sda3.  Priority:-1 extents:1 across:996020k
[   61.900608] EXT3 FS on sda2, internal journal
[  951.116493]  target1:0:5: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 8)
[  951.214785] st0: Block limits 2 - 16777214 bytes.
[  951.597684] kjournald starting.  Commit interval 5 seconds
[  951.666049] EXT3 FS on sda5, internal journal
[  951.718447] EXT3-fs: mounted filesystem with ordered data mode.
[  951.823851] kjournald starting.  Commit interval 5 seconds
[  951.952919] EXT3 FS on sda1, internal journal
[  952.005270] EXT3-fs: mounted filesystem with ordered data mode.
[  952.096264] kjournald starting.  Commit interval 5 seconds
[  952.164870] EXT3 FS on sda6, internal journal
[  952.217242] EXT3-fs: mounted filesystem with ordered data mode.
[  952.382588] kjournald starting.  Commit interval 5 seconds
[  952.510563] EXT3 FS on dm-0, internal journal
[  952.590487] EXT3-fs: mounted filesystem with ordered data mode.
[  952.705804] kjournald starting.  Commit interval 5 seconds
[  952.799006] EXT3 FS on dm-1, internal journal
[  952.851606] EXT3-fs: mounted filesystem with ordered data mode.
[  952.958690] kjournald starting.  Commit interval 5 seconds
[  953.041315] EXT3 FS on dm-2, internal journal
[  953.093720] EXT3-fs: mounted filesystem with ordered data mode.
[  956.804184] eth0:  setting full-duplex.
[ 1046.902930] Bluetooth: Core ver 2.11
[ 1046.945938] NET: Registered protocol family 31
[ 1046.999068] Bluetooth: HCI device and connection manager initialized
[ 1047.075215] Bluetooth: HCI socket layer initialized
[ 1047.277342] Bluetooth: L2CAP ver 2.8
[ 1047.320155] Bluetooth: L2CAP socket layer initialized
[ 1047.643840] Bluetooth: RFCOMM socket layer initialized
[ 1047.705417] Bluetooth: RFCOMM TTY layer initialized
[ 1047.763801] Bluetooth: RFCOMM ver 1.8
[ 1049.292614] agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
[ 1049.371927] agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
[ 1049.451204] agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
[ 1049.538073] [drm] Initialized card for AGP DMA.
[11251.036029] agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
[11251.115274] agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
[11251.194508] agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
[11251.282879] [drm] Initialized card for AGP DMA.
[11263.600369] agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
[11263.679542] agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
[11263.758797] agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
[11263.847376] [drm] Initialized card for AGP DMA.
[34047.309040] pata_mpiix 0000:00:07.1: version 0.7.3
[34047.309064] pata_mpiix 0000:00:07.1:  IDE not enabled on this MPIIX
[35462.353095] pata_mpiix 0000:00:07.1: version 0.7.3
[35462.353121] pata_mpiix 0000:00:07.1:  IDE not enabled on this MPIIX
