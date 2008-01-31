Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbYAaCfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbYAaCfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYAaCfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:35:24 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:3402 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYAaCeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:34:15 -0500
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bzolnier@gmail.com, bbpetkov@yahoo.de, nai.xia@gmail.com, flo@rfc822.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
X-Message-Flag: Warning: May contain useful information
References: <20080129.151353.48534987.k-ueda@ct.jp.nec.com>
	<adar6g0e0g2.fsf@cisco.com>
	<20080129.182356.70224412.k-ueda@ct.jp.nec.com>
	<20080130.202659.104027826.k-ueda@ct.jp.nec.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 Jan 2008 18:34:00 -0800
In-Reply-To: <20080130.202659.104027826.k-ueda@ct.jp.nec.com> (Kiyoshi Ueda's message of "Wed, 30 Jan 2008 20:26:59 -0500 (EST)")
Message-ID: <adamyqmafl3.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-OriginalArrivalTime: 31 Jan 2008 02:34:01.0206 (UTC) FILETIME=[BD0B6160:01C863B1]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

 > Could you try the patch below and give me all boot messages again?

Sure, no problem, see below for full log (I updated to the latest git,
which seems to have some other unrelated problems with things timing
out earlier in the boot, but it does get to the ide-cd init); here's
the relevant looking debug info:

    [  163.990058] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
    [  163.990060] 
    [  163.990061] sector 1987647, nr/cnr 0/0
    [  163.990063] bio ffff8101c418c200, biotail ffff8101c418c200, buffer 0000000000000000, data 0000000000000000, len 158
    [  163.990064] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 
    [  163.990069] backup: data_len=158  bi_size=158
    [  163.994021] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
    [  163.994023] 
    [  163.994024] sector 1987647, nr/cnr 0/0
    [  163.994025] bio ffff8101c418c200, biotail ffff8101c418c200, buffer 0000000000000000, data 0000000000000000, len 158
    [  163.994027] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 
    [  163.994032] backup: data_len=158  bi_size=158

 > This patch displays debug messages against requests still having bio,
 > then tries to unlink all bios from the rq before the rq is completed.
 > So your system may be able to continue to work correctly
 > after displaying debug messages.

By the way, even with your first debug patch, I had no problem using
the box once it booted.  I didn't try the CD-ROM but everything else
seemed fine.

Also, I saw the same issue on a different box (Dell SC1435 with
serverworks IDE):

    [    1.367648] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
    [    1.371649] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
    [    2.612417] SvrWks HT1000: IDE controller (0x1166:0x0214 rev 0x00) at  PCI slot 0000:00:02.1
    [    2.612439] SvrWks HT1000: not 100% native mode: will probe irqs later
    [    2.616427]     ide0: BM-DMA at 0x08c0-0x08c7, BIOS settings: hda:DMA, hdb:pio
    [    2.623505] Probing IDE interface ide0...
    [    4.037070] hda: PHILIPS DVD-ROM SDR089, ATAPI CD/DVD-ROM drive
    [    4.041801] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
    [    4.058447] hda: UDMA/33 mode selected
    [    4.061278] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
    [    4.632739] hda: ATAPI 24X DVD-ROM drive, 2048kB Cache
    ...
    [    8.631615] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
    [    8.631615] 
    [    8.631615] sector 2867855, nr/cnr 0/0
    [    8.631615] bio ffff81021fba3f40, biotail ffff81021fba3f40, buffer 0000000000000000, data 0000000000000000, len 158
    [    8.631615] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 
    [    8.660505] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
    [    8.660505] 
    [    8.660505] sector 2867855, nr/cnr 0/0
    [    8.660505] bio ffff81021fba3f40, biotail ffff81021fba3f40, buffer 0000000000000000, data 0000000000000000, len 62
    [    8.660505] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 

Let me know if you'd like debug info from that too.


--=-=-=
Content-Disposition: inline; filename=bootlog.txt

[    0.000000] Linux version 2.6.24 (rdreier@roland-microway-4) (gcc version 4.2.3 20080114 (prerelease) (Debian 4.2.2-7)) #5 SMP Wed Jan 30 18:25:58 PST 2008
[    0.000000] Command line: root=/dev/sda1 ro console=ttyS0,38400n8 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009fff0000 (usable)
[    0.000000]  BIOS-e820: 000000009fff0000 - 000000009fffe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000009fffe000 - 00000000a0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000245000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 655344) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 2379776) 2 entries of 3200 used
[    0.000000] end_pfn_map = 2379776
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA190, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 9FFF0100, 0044 (r1 A M I  OEMXSDT  12000505 MSFT       97)
[    0.000000] ACPI: FACP 9FFF0290, 00F4 (r3 A M I  OEMFACP  12000505 MSFT       97)
[    0.000000] ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 00000000000044A0/0 [20070126]
[    0.000000] ACPI: DSDT 9FFF0440, 5544 (r1  1HQC8 1HQC8003        3 INTL  2002026)
[    0.000000] ACPI: FACS 9FFFE000, 0040
[    0.000000] ACPI: APIC 9FFF0390, 00A4 (r1 A M I  OEMAPIC  12000505 MSFT       97)
[    0.000000] ACPI: OEMB 9FFFE040, 0071 (r1 A M I  AMI_OEM  12000505 MSFT       97)
[    0.000000] ACPI: SRAT 9FFF5990, 01A0 (r1 A M I  OEMSRAT  12000505 MSFT       97)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] Entering add_active_range(0, 256, 524288) 0 entries of 3200 used
[    0.000000] SRAT: Node 1 PXM 1 80000000-a0000000
[    0.000000] Entering add_active_range(1, 524288, 655344) 1 entries of 3200 used
[    0.000000] SRAT: Node 2 PXM 2 145000000-1c5000000
[    0.000000] Entering add_active_range(2, 1331200, 1855488) 2 entries of 3200 used
[    0.000000] SRAT: Node 3 PXM 3 1c5000000-245000000
[    0.000000] Entering add_active_range(3, 1855488, 2379776) 3 entries of 3200 used
[    0.000000] SRAT: Node 1 PXM 1 80000000-145000000
[    0.000000] Entering add_active_range(1, 524288, 655344) 4 entries of 3200 used
[    0.000000] Entering add_active_range(1, 1048576, 1331200) 4 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] Entering add_active_range(0, 0, 159) 5 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 524288) 6 entries of 3200 used
[    0.000000] NUMA: Allocated memnodemap from 13000 - 134cb
[    0.000000] NUMA: Using 24 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000] Bootmem setup node 1 0000000080000000-0000000145000000
[    0.000000] Bootmem setup node 2 0000000145000000-00000001c5000000
[    0.000000] Bootmem setup node 3 00000001c5000000-0000000245000000
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810080200000 on node 1
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810080400000 on node 1
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810080600000 on node 1
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810080800000 on node 1
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810080a00000 on node 1
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810080c00000 on node 1
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810080e00000 on node 1
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810081000000 on node 1
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810081200000 on node 1
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810081400000 on node 1
[    0.000000]  [ffffe20004400000-ffffe200045fffff] PMD ->ffff810081600000 on node 1
[    0.000000]  [ffffe20004600000-ffffe200047fffff] PMD ->ffff810145200000 on node 2
[    0.000000]  [ffffe20004800000-ffffe200049fffff] PMD ->ffff810145400000 on node 2
[    0.000000]  [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff810145600000 on node 2
[    0.000000]  [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff810145800000 on node 2
[    0.000000]  [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff810145a00000 on node 2
[    0.000000]  [ffffe20005000000-ffffe200051fffff] PMD ->ffff810145c00000 on node 2
[    0.000000]  [ffffe20005200000-ffffe200053fffff] PMD ->ffff810145e00000 on node 2
[    0.000000]  [ffffe20005400000-ffffe200055fffff] PMD ->ffff810146000000 on node 2
[    0.000000]  [ffffe20005600000-ffffe200057fffff] PMD ->ffff810146200000 on node 2
[    0.000000]  [ffffe20005800000-ffffe200059fffff] PMD ->ffff810146400000 on node 2
[    0.000000]  [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff810146600000 on node 2
[    0.000000]  [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff810146800000 on node 2
[    0.000000]  [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff810146a00000 on node 2
[    0.000000]  [ffffe20006000000-ffffe200061fffff] PMD ->ffff810146c00000 on node 2
[    0.000000]  [ffffe20006200000-ffffe200063fffff] PMD ->ffff810146e00000 on node 2
[    0.000000] [ffffe200063c0000-ffffe200063fffff] potential offnode page_structs
[    0.000000]  [ffffe20006400000-ffffe200065fffff] PMD ->ffff8101c5200000 on node 3
[    0.000000]  [ffffe20006600000-ffffe200067fffff] PMD ->ffff8101c5400000 on node 3
[    0.000000]  [ffffe20006800000-ffffe200069fffff] PMD ->ffff8101c5600000 on node 3
[    0.000000]  [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff8101c5800000 on node 3
[    0.000000]  [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff8101c5a00000 on node 3
[    0.000000]  [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff8101c5c00000 on node 3
[    0.000000]  [ffffe20007000000-ffffe200071fffff] PMD ->ffff8101c5e00000 on node 3
[    0.000000]  [ffffe20007200000-ffffe200073fffff] PMD ->ffff8101c6000000 on node 3
[    0.000000]  [ffffe20007400000-ffffe200075fffff] PMD ->ffff8101c6200000 on node 3
[    0.000000]  [ffffe20007600000-ffffe200077fffff] PMD ->ffff8101c6400000 on node 3
[    0.000000]  [ffffe20007800000-ffffe200079fffff] PMD ->ffff8101c6600000 on node 3
[    0.000000]  [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff8101c6800000 on node 3
[    0.000000]  [ffffe20007c00000-ffffe20007dfffff] PMD ->ffff8101c6a00000 on node 3
[    0.000000]  [ffffe20007e00000-ffffe20007ffffff] PMD ->ffff8101c6c00000 on node 3
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  2379776
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524288
[    0.000000]     1:   524288 ->   655344
[    0.000000]     1:  1048576 ->  1331200
[    0.000000]     2:  1331200 ->  1855488
[    0.000000]     3:  1855488 ->  2379776
[    0.000000] On node 0 totalpages: 524191
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1059 pages reserved
[    0.000000]   DMA zone: 2884 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7112 pages used for memmap
[    0.000000]   DMA32 zone: 513080 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 413680
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 7168 pages used for memmap
[    0.000000]   DMA32 zone: 123888 pages, LIFO batch:31
[    0.000000]   Normal zone: 3864 pages used for memmap
[    0.000000]   Normal zone: 278760 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 2 totalpages: 524288
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 7168 pages used for memmap
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 3 totalpages: 524288
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 7168 pages used for memmap
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] Processor #4
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] Processor #5
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] Processor #6
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] Processor #7
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xbf9fe000] gsi_base[40])
[    0.000000] IOAPIC[1]: apic_id 13, address 0xbf9fe000, GSI 40-46
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xbf9ff000] gsi_base[47])
[    0.000000] IOAPIC[2]: apic_id 14, address 0xbf9ff000, GSI 47-53
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at a8000000 (gap: a0000000:5ec00000)
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 36392 bytes of per cpu data
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 1952852
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro console=ttyS0,38400n8 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000002] Marking TSC unstable due to TSCs unsynchronized
[    0.000004] time.c: Detected 2600.008 MHz processor.
[    0.000012] spurious 8259A interrupt: IRQ7.
[    0.003624] Console: colour VGA+ 80x25
[    0.003639] console [ttyS0] enabled
[    0.004000] Checking aperture...
[    0.004000] Node 0: aperture @ 4000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] No AGP bridge found
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 8000000
[    0.004000] Memory: 7764500k/9519104k available (2214k kernel code, 181288k reserved, 1024k data, 292k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=8, Nodes=4
[    0.084007] Calibrating delay using timer specific routine.. 5203.27 BogoMIPS (lpj=10406546)
[    0.093144] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.102952] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.107254] Mount-cache hash table entries: 256
[    0.108323] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.112008] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.116009] CPU 0/0 -> Node 0
[    0.120009] CPU: Physical Processor ID: 0
[    0.124009] CPU: Processor Core ID: 0
[    0.128025] ACPI: Core revision 20070126
[    0.185707] Using local APIC timer interrupts.
[    0.192013] APIC timer calibration result 12500052
[    0.192014] Detected 12.500 MHz APIC timer.
[    0.196138] Booting processor 1/8 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=10400277)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.288291] Booting processor 2/8 APIC 0x2
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=10400277)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 2/2 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.384254] Booting processor 3/8 APIC 0x3
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5200.12 BogoMIPS (lpj=10400255)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 3/3 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.480290] Booting processor 4/8 APIC 0x4
[    0.004000] Initializing CPU#4
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=10400260)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 4/4 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.576246] Booting processor 5/8 APIC 0x5
[    0.004000] Initializing CPU#5
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=10400278)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 5/5 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.672293] Booting processor 6/8 APIC 0x6
[    0.004000] Initializing CPU#6
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=10400273)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 6/6 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.768325] Booting processor 7/8 APIC 0x7
[    0.004000] Initializing CPU#7
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=10400261)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 7/7 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.864232] Brought up 8 CPUs
[    0.868670] net_namespace: 416 bytes
[    0.872214] NET: Registered protocol family 16
[    0.876153] ACPI: bus type pci registered
[    0.880061] PCI: Using configuration type 1
[    0.890168] ACPI: EC: Look up EC in DSDT
[    0.896451] ACPI: Interpreter enabled
[    0.900058] ACPI: (supports S0 S5)
[    0.905690] ACPI: Using IOAPIC for interrupt routing
[    0.917105] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.924237] PCI: Transparent bridge - 0000:00:09.0
[    0.928210] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.928405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.938109] ACPI: PCI Root Bridge [PCIB] (0000:04)
[    0.940483] ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.POGA._PRT]
[    0.940575] ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.POGB._PRT]
[    0.941094] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *9
[    0.952803] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *9
[    0.963528] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    0.970150] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *9
[    0.980805] ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *0, disabled.
[    0.992803] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *5
[    1.000236] ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0, disabled.
[    1.012806] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
[    1.022674] ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *0, disabled.
[    1.031712] ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
[    1.040238] ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
[    1.052783] ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
[    1.064810] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *11
[    1.076247] ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *9
[    1.085942] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
[    1.096287] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.100086] pnp: PnP ACPI init
[    1.104078] ACPI: bus type pnp registered
[    1.108198] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.108231] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.108268] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.108295] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.108327] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.108839] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.109353] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.112557] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.113353] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.113674] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.113783] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.113924] pnp 00:0b: Plug and Play ACPI device, IDs PNP0f12 PNP0f13 (active)
[    1.114354] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.114476] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.114718] pnp 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.115017] pnp 00:0f: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.115816] pnp: PnP ACPI: found 16 devices
[    1.116071] ACPI: ACPI bus type pnp unregistered
[    1.120186] SCSI subsystem initialized
[    1.124236] libata version 3.00 loaded.
[    1.124303] usbcore: registered new interface driver usbfs
[    1.128092] usbcore: registered new interface driver hub
[    1.132102] usbcore: registered new device driver usb
[    1.136137] PCI: Using ACPI for IRQ routing
[    1.140073] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    1.164073] PCI-DMA: Disabling AGP.
[    1.165466] PCI-DMA: aperture base @ 8000000 size 65536 KB
[    1.168074] PCI-DMA: using GART IOMMU.
[    1.172076] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.196075] pnp: the driver 'system' has been registered
[    1.196075] system 00:09: ioport range 0x190-0x193 has been reserved
[    1.196077] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    1.200078] system 00:09: iomem range 0xffb80000-0xfffffffe could not be reserved
[    1.204078] system 00:09: iomem range 0xdfefc000-0xdfefcfff has been reserved
[    1.208078] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.212078] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.216078] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.220079] system 00:09: iomem range 0xfefff000-0xfeffffff has been reserved
[    1.224078] system 00:09: driver attached
[    1.224082] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.228079] system 00:0a: iomem range 0xfee00000-0xfeefffff could not be reserved
[    1.232078] system 00:0a: driver attached
[    1.232083] system 00:0c: ioport range 0x680-0x6ff has been reserved
[    1.236079] system 00:0c: ioport range 0x295-0x296 has been reserved
[    1.240080] system 00:0c: ioport range 0x778-0x77f has been reserved
[    1.244080] system 00:0c: ioport range 0xb78-0xb7f has been reserved
[    1.248080] system 00:0c: ioport range 0xf78-0xf7f has been reserved
[    1.252080] system 00:0c: driver attached
[    1.252084] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    1.256080] system 00:0d: driver attached
[    1.256084] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    1.260081] system 00:0e: iomem range 0xc0000-0xdffff has been reserved
[    1.264081] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    1.268081] system 00:0e: iomem range 0x100000-0x9fffffff could not be reserved
[    1.272081] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    1.276081] system 00:0e: driver attached
[    1.276361] PCI: Bridge: 0000:00:09.0
[    1.280081] Time: acpi_pm clocksource has been installed.
[    1.988178] Switched to high resolution mode on CPU 4
[    2.436219] Switched to high resolution mode on CPU 2
[    2.212484] Switched to high resolution mode on CPU 3
[    1.540205] Switched to high resolution mode on CPU 6
[    1.760521] Switched to high resolution mode on CPU 5
[    1.328232] Switched to high resolution mode on CPU 7
[    1.284277] Switched to high resolution mode on CPU 0
[    2.656336] Switched to high resolution mode on CPU 1
[    1.284293]   IO window: a000-afff
[    1.288085]   MEM window: bd200000-bf2fffff
[    1.292085]   PREFETCH window: disabled.
[    1.296085] PCI: Bridge: 0000:00:0d.0
[    1.300084]   IO window: disabled.
[    1.304086]   MEM window: bce00000-bd1fffff
[    1.308085]   PREFETCH window: disabled.
[    1.312086] PCI: Bridge: 0000:00:0e.0
[    1.316085]   IO window: disabled.
[    1.320086]   MEM window: bbd00000-bcdfffff
[    1.324086]   PREFETCH window: disabled.
[    1.328091] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    1.328097] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    1.328102] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    1.328106] PCI: Bridge: 0000:04:01.0
[    1.332087]   IO window: f000-ffff
[    1.336088]   MEM window: bf600000-bf8fffff
[    1.340088]   PREFETCH window: bfa00000-dfefffff
[    1.344089] PCI: Bridge: 0000:04:02.0
[    1.348088]   IO window: e000-efff
[    1.352089]   MEM window: bf500000-bf5fffff
[    1.356089]   PREFETCH window: disabled.
[    1.360126] NET: Registered protocol family 2
[    1.408103] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.413154] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.425358] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.428777] TCP: Hash tables configured (established 524288 bind 65536)
[    1.432108] TCP reno registered
[    1.731961] Total HugeTLB memory allocated, 0
[    1.736648] VFS: Disk quotas dquot_6.5.1
[    1.740060] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.748784] io scheduler noop registered
[    1.751966] io scheduler anticipatory registered (default)
[    1.755965] io scheduler deadline registered
[    1.760129] io scheduler cfq registered
[    1.783987] PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
[    1.784003] PCI: Found enabled HT MSI Mapping on 0000:00:00.0
[    1.787994] PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
[    1.791995] PCI: Found enabled HT MSI Mapping on 0000:00:00.0
[    1.650262] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    1.650262] assign_interrupt_mode Found MSI capability
[    1.650289] Allocate Port Service[0000:00:0d.0:pcie00]
[    1.650392] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    1.650409] assign_interrupt_mode Found MSI capability
[    1.654277] Allocate Port Service[0000:00:0e.0:pcie00]
[    2.216346] Real Time Clock Driver v1.12ac
[    2.217576] Linux agpgart interface v0.102
[    2.221398] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    2.225546] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.229535] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.233696] pnp: the driver 'serial' has been registered
[    2.233940] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.237476] serial 00:05: driver attached
[    2.237649] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.241473] serial 00:06: driver attached
[    2.243195] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    2.245407] console [netcon0] enabled
[    2.253414] netconsole: network logging started
[    2.257468] Driver 'sd' needs updating - please use bus_type methods
[    6.543378] sata_nv 0000:00:07.0: version 3.5
[    6.543378] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 22
[    6.543395] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 22 (level, low) -> IRQ 22
[    6.555381] sata_nv 0000:00:07.0: Using ADMA mode
[    6.563412] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    6.563549] scsi0 : sata_nv
[    6.567503] scsi1 : sata_nv
[    6.571541] ata1: SATA max UDMA/133 cmd 0xdc00 ctl 0xd800 bmdma 0xcc00 irq 22
[    6.575383] ata2: SATA max UDMA/133 cmd 0xd400 ctl 0xd000 bmdma 0xcc08 irq 22
[    8.861240] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.364025] ata1.00: ATA-7: ST3808110AS, 3.AAD, max UDMA/133
[    7.364034] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.421685] ata1.00: configured for UDMA/133
[    9.313519] ata2: SATA link down (SStatus 0 SControl 300)
[    7.532842] scsi 0:0:0:0: Direct-Access     ATA      ST3808110AS      3.AA PQ: 0 ANSI: 5
[    7.532853] ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[    7.537038] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    7.540857] sd 0:0:0:0: [sda] Write Protect is off
[    7.544847] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.544867] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.548895] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    7.552855] sd 0:0:0:0: [sda] Write Protect is off
[    7.556847] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.556865] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.560848]  sda: sda1 sda2 < sda5 sda6 >
[    7.616521] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.620400] ACPI: PCI Interrupt Link [LTIE] enabled at IRQ 21
[    7.624026] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LTIE] -> GSI 21 (level, low) -> IRQ 21
[    7.636022] sata_nv 0000:00:08.0: Using ADMA mode
[    7.640183] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    7.640281] scsi2 : sata_nv
[    7.644126] scsi3 : sata_nv
[    7.648175] ata3: SATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb800 irq 21
[    7.652023] ata4: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb808 irq 21
[   10.012790] ata3: SATA link down (SStatus 0 SControl 300)
[   10.331935] ata4: SATA link down (SStatus 0 SControl 300)
[    8.315933] pnp: the driver 'i8042 kbd' has been registered
[    8.315966] pnp: the driver 'i8042 aux' has been registered
[    8.315966] i8042 aux 00:0b: driver attached
[    8.316002] PNP: PS/2 Controller [PNP0f12:PS2M] at 0x60,0x64 irq 12
[    8.316006] PNP: PS/2 controller doesn't have KBD irq; using default 1
[    8.827608] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.827616] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.831755] mice: PS/2 mouse device common for all mice
[    8.836048] TCP bic registered
[    8.839647] NET: Registered protocol family 1
[    8.843630] NET: Registered protocol family 17
[   10.803895] kjournald starting.  Commit interval 5 seconds
[    9.186780] EXT3-fs: mounted filesystem with ordered data mode.
[    9.186780] VFS: Mounted root (ext3 filesystem) readonly.
[    9.186780] Freeing unused kernel memory: 292k freed
[   11.664916] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   11.664926] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   11.749089] input: Power Button (FF) as /devices/virtual/input/input0
[   11.175795] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   11.175937] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   11.799403] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.196261] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 20
[   11.199872] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 20 (level, low) -> IRQ 20
[   11.211882] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   11.211885] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   11.216202] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[   11.219879] ohci_hcd 0000:00:02.0: irq 20, io mem 0xbf3fd000
[   11.902962] ACPI: Power Button (FF) [PWRF]
[   11.904447] input: Power Button (CM) as /devices/virtual/input/input1
[   11.925018] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   11.296180] usb usb1: configuration #1 chosen from 1 choice
[   11.940307] ACPI: Power Button (CM) [PWRB]
[   11.297528] hub 1-0:1.0: USB hub found
[   11.301509] hub 1-0:1.0: 10 ports detected
[   20.020086] Clocksource tsc unstable (delta = 4686945245 ns)
[   41.949198] shpchp: gave up waiting for init of module pci_hotplug.
[   41.949202] shpchp: Unknown symbol acpi_run_oshp
[   71.966729] shpchp: gave up waiting for init of module pci_hotplug.
[   71.966734] shpchp: Unknown symbol pci_hp_change_slot_info
[  101.971400] shpchp: gave up waiting for init of module pci_hotplug.
[  101.971403] shpchp: Unknown symbol pci_hp_register
[  131.978051] shpchp: gave up waiting for init of module pci_hotplug.
[  131.978055] shpchp: Unknown symbol pci_hp_deregister
[  149.095278] INFO: task modprobe:1161 blocked for more than 120 seconds.
[  149.095286] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.099281] modprobe      D 0000000000000000     0  1161   1160
[  149.111281]  ffff81007eca5da0 0000000000000082 0000000000000000 ffffc20001732b78
[  149.127846]  ffff810243082f00 ffff81007eca5d50 ffffffff802bb60f ffffffff80596580
[  149.143847]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff81007ec7a9d0
[  149.159284] Call Trace:
[  149.163294]  [<ffffffff802bb60f>] sysfs_addrm_finish+0x1d/0x209
[  149.167287]  [<ffffffff802bae96>] sysfs_add_file+0x5b/0x81
[  149.171288]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.175287]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.179288]  [<ffffffff8024bc7c>] sys_init_module+0x1956/0x19f2
[  149.183290]  [<ffffffff8039a605>] usb_root_hub_lost_power+0x0/0x31
[  149.187289]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.191287] 
[  149.195287] INFO: task modprobe:1163 blocked for more than 120 seconds.
[  149.199287] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.203287] modprobe      D 0000000000000000     0  1163   1162
[  149.215287]  ffff810144173e00 0000000000000086 0000000000000000 ffffffff8024077e
[  149.231852]  0000000000000001 ffff810144173db0 ffff810144173dc0 ffffffff80596580
[  149.251290]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101440009d0
[  149.267291] Call Trace:
[  149.271293]  [<ffffffff8024077e>] ktime_get_ts+0x17/0x48
[  149.275294]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.279293]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.283293]  [<ffffffff802492e9>] m_start+0x10/0x20
[  149.287294]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  149.291296]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  149.295295]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  149.299294]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  149.303294]  [<ffffffff8020bec4>] sysret_signal+0x1c/0x27
[  149.307295]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.311295] 
[  149.315294] INFO: task modprobe:1166 blocked for more than 120 seconds.
[  149.319294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.323294] modprobe      D 0000000000000000     0  1166   1164
[  149.335295]  ffff8101c40b1da0 0000000000000086 0000000000000000 ffff8102446eafa0
[  149.351860]  ffff8102446eafa0 ffff8101c40b1d50 ffffffff802bb60f ffffffff80596580
[  149.371297]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101c405e9d0
[  149.387298] Call Trace:
[  149.391300]  [<ffffffff802bb60f>] sysfs_addrm_finish+0x1d/0x209
[  149.395301]  [<ffffffff802bae96>] sysfs_add_file+0x5b/0x81
[  149.399301]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.403301]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.407300]  [<ffffffff8024bc7c>] sys_init_module+0x1956/0x19f2
[  149.411305]  [<ffffffff8022d2d4>] printk+0x0/0x56
[  149.415303]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.419302] 
[  149.423301] INFO: task modprobe:1178 blocked for more than 120 seconds.
[  149.427301] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.431301] modprobe      D 0000000000000000     0  1178   1176
[  149.443302]  ffff8102434a3e00 0000000000000082 0000000000000000 0000000000000000
[  149.463303]  ffff8101c5000c10 ffff8102434a3db0 00000044434a4680 ffffffff80596580
[  149.479868]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff81024410a9d0
[  149.495305] Call Trace:
[  149.499309]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  149.503307]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.507307]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.511307]  [<ffffffff802492e9>] m_start+0x10/0x20
[  149.515307]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  149.519309]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  149.523308]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  149.527309]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  149.531309]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.535309] 
[  149.539308] INFO: task modprobe:1219 blocked for more than 120 seconds.
[  149.543308] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.547308] modprobe      D ffffffffffffffff     0  1219   1218
[  149.559309]  ffff8101c413bda0 0000000000000082 ffffffff88065a80 ffffffff88065a80
[  149.575874]  ffff810244171000 ffff8101c413bd50 ffff8102430ce5a0 ffffffff80596580
[  149.591875]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101c4138240
[  149.607312] Call Trace:
[  149.611316]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.615314]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.619314]  [<ffffffff8024bc7c>] sys_init_module+0x1956/0x19f2
[  149.623317]  [<ffffffff8031ae00>] kobject_put+0x0/0x16
[  149.627316]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.631315] 
[  149.635314] INFO: task modprobe:1227 blocked for more than 120 seconds.
[  149.639314] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.643314] modprobe      D 0000000000000000     0  1227   1224
[  149.655315]  ffff8101c4161da0 0000000000000082 0000000000000000 ffffffff8051fb58
[  149.671880]  0000000000000000 ffff8101c4161d50 ffffffff8023dd8e ffffffff80596580
[  149.691317]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101c415e240
[  149.707318] Call Trace:
[  149.711322]  [<ffffffff8023dd8e>] autoremove_wake_function+0x9/0x2e
[  149.715322]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.719321]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.723320]  [<ffffffff8024bc7c>] sys_init_module+0x1956/0x19f2
[  149.727324]  [<ffffffff803703ad>] device_remove_file+0x0/0x36
[  149.731323]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.735321] 
[  149.739321] INFO: task modprobe:1624 blocked for more than 120 seconds.
[  149.743321] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.747322] modprobe      D 0000000000000000     0  1624   1622
[  149.759322]  ffff810143d39e00 0000000000000086 0000000000000000 0000000000000000
[  149.775886]  ffff810145000c10 ffff810143d39db0 00000044c4039a00 ffffffff80596580
[  149.791887]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff81014348e240
[  149.807324] Call Trace:
[  149.811328]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  149.815327]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.819327]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.823326]  [<ffffffff802492e9>] m_start+0x10/0x20
[  149.827327]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  149.831328]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  149.835328]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  149.839328]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  149.843328]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.847329] 
[  149.851328] INFO: task modprobe:1626 blocked for more than 120 seconds.
[  149.855328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.859328] modprobe      D ffffffffffffffff     0  1626   1625
[  149.871329]  ffff81014400de00 0000000000000082 0000000180264e83 0000000000000000
[  149.891330]  ffff810145000c10 ffff81014400ddb0 000000447e86f380 ffffffff80596580
[  149.907895]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101441309d0
[  149.923332] Call Trace:
[  149.927335]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  149.931334]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  149.935334]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  149.939334]  [<ffffffff802492e9>] m_start+0x10/0x20
[  149.943334]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  149.947336]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  149.951335]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  149.955335]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  149.959336]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  149.963335] 
[  149.967335] INFO: task modprobe:1628 blocked for more than 120 seconds.
[  149.971335] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  149.975335] modprobe      D ffffffffffffffff     0  1628   1627
[  149.987336]  ffff810143c7fe00 0000000000000082 0000000180264e83 0000000000000000
[  150.007337]  ffff810145000c10 ffff810143c7fdb0 0000004444ffd380 ffffffff80596580
[  150.023904]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101441318f0
[  150.039339] Call Trace:
[  150.043342]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.047341]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.051342]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.055341]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.059341]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.063343]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.067343]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.071342]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.075343]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.079343] 
[  150.083343] INFO: task modprobe:1630 blocked for more than 120 seconds.
[  150.087342] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.091342] modprobe      D 0000000000000000     0  1630   1629
[  150.103343]  ffff810143df3e00 0000000000000082 0000000000000000 0000000000000000
[  150.119908]  ffff810145000c10 ffff810143df3db0 000000444419d380 ffffffff80596580
[  150.135909]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff810143cfb8f0
[  150.151346] Call Trace:
[  150.155349]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.159348]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.163349]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.167348]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.171348]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.175350]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.179349]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.183349]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.187350]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.191350] 
[  150.195350] INFO: task modprobe:1635 blocked for more than 120 seconds.
[  150.199349] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.203350] modprobe      D 0000000000000000     0  1635   1631
[  150.215350]  ffff8102435c1e00 0000000000000082 0000000000000000 0000000000000000
[  150.231915]  ffff8101c5000c10 ffff8102435c1db0 00000044435af040 ffffffff80596580
[  150.247916]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff81024404c9d0
[  150.263353] Call Trace:
[  150.267356]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.271355]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.275356]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.279355]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.283356]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.287357]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.291356]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.295356]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.299357]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.303357] 
[  150.307357] INFO: task modprobe:1639 blocked for more than 120 seconds.
[  150.311356] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.315356] modprobe      D ffffffffffffffff     0  1639   1636
[  150.327357]  ffff8101c40d3e00 0000000000000086 0000000180264e83 0000000000000000
[  150.343922]  ffff810145000c10 ffff8101c40d3db0 00000044c41cb6c0 ffffffff80596580
[  150.363359]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101c41c7160
[  150.379360] Call Trace:
[  150.383364]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.387363]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.391364]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.395362]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.399363]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.403364]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.407364]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.411364]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.415364]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.419364] 
[  150.423364] INFO: task modprobe:1646 blocked for more than 120 seconds.
[  150.427364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.431364] modprobe      D 0000000000000000     0  1646   1643
[  150.443365]  ffff810243527e00 0000000000000086 0000000000000000 0000000000000000
[  150.459929]  ffff810000013b1b ffff810243527db0 000000447e86e000 ffffffff80596580
[  150.475930]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff810244140240
[  150.491367] Call Trace:
[  150.495371]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.499370]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.503370]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.507369]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.511370]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.515371]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.519371]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.523371]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.527371]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.531371] 
[  150.535371] INFO: task modprobe:1662 blocked for more than 120 seconds.
[  150.539371] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.543371] modprobe      D 0000000000000000     0  1662   1634
[  150.555372]  ffff8102435abda0 0000000000000086 0000000000000000 0000000000000000
[  150.571936]  ffffffff8031bb60 ffff8102435abd50 00000000430da498 ffffffff80596580
[  150.587937]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8102440fd160
[  150.603374] Call Trace:
[  150.607377]  [<ffffffff8031bb60>] kobject_uevent_env+0x3ae/0x3d9
[  150.611378]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.615377]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.619376]  [<ffffffff8024bc7c>] sys_init_module+0x1956/0x19f2
[  150.623380]  [<ffffffff80349084>] acpi_bus_register_driver+0x0/0x3c
[  150.627379]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.631377] 
[  150.635377] INFO: task modprobe:1701 blocked for more than 120 seconds.
[  150.639377] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.643377] modprobe      D 0000000000000000     0  1701   1633
[  150.655378]  ffff8102434c9e00 0000000000000082 0000000000000000 0000000000000000
[  150.671943]  ffff810145000c10 ffff8102434c9db0 00000044c41ca680 ffffffff80596580
[  150.687944]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8102434aa9d0
[  150.703381] Call Trace:
[  150.707385]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.711383]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.715383]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.719382]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.723383]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.727385]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.731384]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.735384]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.739385]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.743384] 
[  150.747384] INFO: task modprobe:2254 blocked for more than 120 seconds.
[  150.751384] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.755384] modprobe      D 0000000000000000     0  2254   2253
[  150.767385]  ffff8101c41c9e00 0000000000000082 0000000000000000 0000000000000000
[  150.783950]  ffff810080000c10 ffff8101c41c9db0 0000004444ffc680 ffffffff80596580
[  150.803388]  ffffffff80596580 ffffffff80592cd0 ffffffff80596580 ffff8101c41c6240
[  150.819388] Call Trace:
[  150.823391]  [<ffffffff80258e57>] __alloc_pages+0xa7/0x338
[  150.827390]  [<ffffffff804230f1>] __mutex_lock_slowpath+0x68/0xa0
[  150.831391]  [<ffffffff80422f65>] mutex_lock+0xa/0xb
[  150.835390]  [<ffffffff802492e9>] m_start+0x10/0x20
[  150.839390]  [<ffffffff802926d7>] seq_read+0xe0/0x289
[  150.843392]  [<ffffffff802b27c0>] proc_reg_read+0x76/0x91
[  150.847391]  [<ffffffff8027b300>] vfs_read+0xaa/0x132
[  150.851391]  [<ffffffff8027b694>] sys_read+0x45/0x6e
[  150.855392]  [<ffffffff8020be3b>] system_call_after_swapgs+0x7b/0x80
[  150.859392] 
[  161.988216] shpchp: gave up waiting for init of module pci_hotplug.
[  161.988220] shpchp: Unknown symbol acpi_get_hp_params_from_firmware
[  162.033861] shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
[  162.033872] shpchp: shpc_init: cannot reserve MMIO region
[  162.037875] shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
[  162.041865] shpchp: shpc_init: cannot reserve MMIO region
[  162.045889] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  158.957794] NFORCE-CK804: IDE controller (0x10de:0x0053 rev 0xf2) at  PCI slot 0000:00:06.0
[  158.957876] NFORCE-CK804: not 100% native mode: will probe irqs later
[  158.961859] NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
[  158.965861]     ide0: BM-DMA at 0x3000-0x3007, BIOS settings: hda:DMA, hdb:DMA
[  158.977858]     ide1: BM-DMA at 0x3008-0x300f, BIOS settings: hdc:DMA, hdd:DMA
[  158.986425] Probing IDE interface ide0...
[  162.222985] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[  162.226184] Copyright (c) 1999-2006 Intel Corporation.
[  160.069963] hda: MATSHITADVD-ROM SR-8178, ATAPI CD/DVD-ROM drive
[  160.080109] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[  160.080369] hda: UDMA/66 mode selected
[  160.082218] Probing IDE interface ide1...
[  160.650886] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[  163.830896] ACPI: PCI Interrupt 0000:05:03.0[A] -> ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[  165.731033] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 22 (level, low) -> IRQ 22
[  165.782052] PCI: Setting latency timer of device 0000:00:02.1 to 64
[  165.782057] ehci_hcd 0000:00:02.1: EHCI Host Controller
[  163.830911] GSI 47 (level, low) -> IRQ 47
[  165.783119] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
[  165.787066] ehci_hcd 0000:00:02.1: debug port 1
[  165.791041] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[  165.791048] ehci_hcd 0000:00:02.1: irq 22, io mem 0xbf3e0000
[  165.810984] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  159.695346] hda: ATAPI 24X DVD-ROM drive, 256kB Cache
[  159.695346] Uniform CD-ROM driver Revision: 3.20
[  165.814842] usb usb2: configuration #1 chosen from 1 choice
[  163.990058] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[  163.990060] 
[  163.990061] sector 1987647, nr/cnr 0/0
[  163.990063] bio ffff8101c418c200, biotail ffff8101c418c200, buffer 0000000000000000, data 0000000000000000, len 158
[  163.990064] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 
[  163.990069] backup: data_len=158  bi_size=158
[  163.994021] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[  163.994023] 
[  163.994024] sector 1987647, nr/cnr 0/0
[  163.994025] bio ffff8101c418c200, biotail ffff8101c418c200, buffer 0000000000000000, data 0000000000000000, len 158
[  163.994027] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 
[  163.994032] backup: data_len=158  bi_size=158
[  164.169411] e1000: 0000:05:03.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:57:44:1e
[  164.189567] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[  164.189584] ACPI: PCI Interrupt 0000:05:03.1[B] -> GSI 48 (level, low) -> IRQ 48
[  165.818779] hub 2-0:1.0: USB hub found
[  165.822753] hub 2-0:1.0: 10 ports detected
[  165.934499] PCI: Setting latency timer of device 0000:02:00.0 to 64
[  165.939232] ib_ipath 0000:02:00.0: infinipath0: Board SN 1256100059 did not pass functional test: Testing
[  165.958764] ib_ipath 0000:02:00.0: infinipath0: Performance problem: bandwidth to PIO buffers is only 144 MiB/sec
[  164.524362] e1000: 0000:05:03.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:57:44:1f
[  164.569938] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[  165.102691] Adding 3992112k swap on /dev/sda6.  Priority:-1 extents:1 across:3992112k
[  165.503878] EXT3 FS on sda1, internal journal
[  166.124805] loop: module loaded
[  166.183745] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[  168.964076] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[  169.199551] NET: Registered protocol family 10
[  169.201451] lo: Disabled Privacy Extensions
[  170.048824] RPC: Registered udp transport module.
[  170.051274] RPC: Registered tcp transport module.
[  179.958149] eth0: no IPv6 routers present

--=-=-=--
