Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZGHPu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZGHPu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZGHPur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:50:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:40595 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754604AbZGHPun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:50:43 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX1/GCuda5jDG1obqnz+vADX+70Jpz4zg7JBDKm6Vs6
	k/JNttgd1ICamb
Message-ID: <4A54C049.9080100@warlich.name>
Date: Wed, 08 Jul 2009 17:50:33 +0200
From: Christof Warlich <christof@warlich.name>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com> <4A52F39A.1030704@warlich.name> <4A5311C7.1020507@warlich.name> <4A535973.9090206@gmail.com> <4A5388EA.7030503@warlich.name> <4A53DA88.5080703@gmail.com> <4A543FA5.1090608@warlich.name> <4A54AD1A.1040009@kernel.org>
In-Reply-To: <4A54AD1A.1040009@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------090307070403060106010904"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090307070403060106010904
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo schrieb:
> Hello, Christof, Robert.
>
> Christof Warlich wrote:
>   
>> Robert Hancock schrieb:
>>     
>>> Hmm, so we tried to disable the HPA and enable the entire disk
>>> capacity, but the drive refused. But it somehow ends up in the HPA
>>> disabled state upon resume. According to the ATA spec, the drive will
>>> refuse SET MAX ADDRESS EXT commands after one has already been
>>> executed upon power-on or reset. That suggests that the BIOS is
>>> applying the HPA on bootup, but not on resume.
>>>       
>
> Arghhh... this is nasty.  Nasty.
>
> I can't find previous messages.  Can you please post full boot log and
> the output of "lspci -nn"?
>   
I've addached both the output of dmesg (I hope this is what you want 
when asking for the full boot log) and the output of "lspci -nn" while 
the kernel boot parameter libata.ignore_hpa=1 was set.
>   
>>> Is there a BIOS update available for this machine?
>>>       
>> Updating the BIOS was the first thing I did when I got the machine,
>> maybe two month ago. And only after that update suspend to disk began to
>> work at least.
>>
>> What about doing it the other way round: Forcing the kernel to apply the
>> HPA on resume? Whitout knowing if this is possible at all with
>> reasonable effort, it would bring us in sync having the HPA enabled for
>> both bootup and resume, right?
>> The only drawback would be that we stay having only the 128GiB available.
>>
>> I'd assume that Windows XP may do it this way, as suspend to ram does
>> work there and it also only sees the 128GiB.
>>     
>
> AFAIK, wxp doesn't revalidate or doesn't consider device size while
> revalidating disk after resume.  The size check during revalidation is
> safety net which is there because ATA devices sometimes don't have
> meaning identifiers and there are vendor specific configuration
> options which may offset sectors differently and writing to devices in
> such cases can lead to data loss.
>
> If the bios configured HPA during boot, it should be restoring it on
> resume too.  Maybe those commands have been filtered out.  Eh... no,
> all filtered out commands are transfer mode related.  Dang.
>
> One thing we can do is to make libata remember the native size on
> initial probing and let revalidation consider it.  Yeap, that would
> work.  Can you please test the attached patch and post full log
> including boot and suspend/resume?
>
> Thanks.
>   
Thanks for the (updated) patch, I'll go and test it asap; I hope I get 
it done today, otherwise it may take until Friday as I'm busy tomorrow.

--------------090307070403060106010904
Content-Type: text/x-log;
 name="lspci.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.log"

00:00.0 Host bridge [0600]: Intel Corporation 82855PM Processor to I/O Controller [8086:3340] (rev 03)
00:01.0 PCI bridge [0604]: Intel Corporation 82855PM Processor to AGP Controller [8086:3341] (rev 03)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 [8086:24c2] (rev 01)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 [8086:24c4] (rev 01)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 [8086:24c7] (rev 01)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller [8086:24cd] (rev 01)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 81)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge [8086:24cc] (rev 01)
00:1f.1 IDE interface [0101]: Intel Corporation 82801DBM (ICH4-M) IDE Controller [8086:24ca] (rev 01)
00:1f.3 SMBus [0c05]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller [8086:24c3] (rev 01)
00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller [8086:24c5] (rev 01)
00:1f.6 Modem [0703]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller [8086:24c6] (rev 01)
01:00.0 VGA compatible controller [0300]: nVidia Corporation NV17 [GeForce4 420 Go 32M] [10de:0176] (rev a3)
02:05.0 Network controller [0280]: Intel Corporation PRO/Wireless LAN 2100 3B Mini PCI Adapter [8086:1043] (rev 04)
02:06.0 CardBus bridge [0607]: Texas Instruments PCI1620 PC Card Controller [104c:ac54] (rev 01)
02:06.1 CardBus bridge [0607]: Texas Instruments PCI1620 PC Card Controller [104c:ac54] (rev 01)
02:06.2 System peripheral [0880]: Texas Instruments PCI1620 Firmware Loading Function [104c:8201] (rev 01)
02:07.0 Ethernet controller [0200]: Broadcom Corporation BCM4401 100Base-T [14e4:4401] (rev 01)

--------------090307070403060106010904
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-020630-generic (root@zinc) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #020630 SMP Wed Jun 10 09:45:40 UTC 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005ff70000 (usable)
[    0.000000]  BIOS-e820: 000000005ff70000 - 000000005ff7c000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005ff7c000 - 000000005ff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000005ff80000 - 0000000060000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffff000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x5ff70 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 05FF80000 mask FFFF80000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000005ff70000 (usable)
[    0.000000]  modified: 000000005ff70000 - 000000005ff7c000 (ACPI data)
[    0.000000]  modified: 000000005ff7c000 - 000000005ff80000 (ACPI NVS)
[    0.000000]  modified: 000000005ff80000 - 0000000060000000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  modified: 00000000fffff000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37873000 - 37fef743
[    0.000000] Allocated new RAMDISK: 00838000 - 00fb4743
[    0.000000] Move RAMDISK from 0000000037873000 - 0000000037fef742 to 00838000 - 00fb4742
[    0.000000] ACPI: RSDP 000f6500 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 5ff77a1d 00030 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 5ff7bed2 00074 (v01 HP     08B0     06040000 PTL  00000050)
[    0.000000] ACPI: DSDT 5ff77e73 0405F (v01 HP     08B0     06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 5ff7cfc0 00040
[    0.000000] ACPI: BOOT 5ff7bfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 5ff77a4d 0020E (v01  INTEL  EISTRef 00002000 INTL 20021002)
[    0.000000] 647MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000833454]    TEXT DATA BSS ==> [0000100000 - 0000833454]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [0000834000 - 00008370f3]              BRK ==> [0000834000 - 00008370f3]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000838000 - 0000fb4743]      NEW RAMDISK ==> [0000838000 - 0000fb4743]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0005ff70
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005ff70
[    0.000000] On node 0 totalpages: 392971
[    0.000000] free_area_init_node: node 0, pgdat c06ee2c0, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1295 pages used for memmap
[    0.000000]   HighMem zone: 164451 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:9f800000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c1c09000, static data 25884 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 389900
[    0.000000] Kernel command line: root=UUID=0cd94059-4d36-4b42-9c42-9ccf70206ce6 ro libata.ignore_hpa=1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 996.714 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] allocated 7861440 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Initializing HighMem for node 0 (000377fe:0005ff70)
[    0.004000] Memory: 1535104k/1572288k available (4179k kernel code, 35936k reserved, 2004k data, 528k init, 662984k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.004000]       .init : 0xc0714000 - 0xc0798000   ( 528 kB)
[    0.004000]       .data : 0xc0514e40 - 0xc0709ee8   (2004 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0514e40   (4179 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004021] Calibrating delay loop (skipped), value calculated using timer frequency.. 1993.42 BogoMIPS (lpj=3986856)
[    0.004207] Security Framework initialized
[    0.004286] SELinux:  Disabled at boot.
[    0.004361] Mount-cache hash table entries: 512
[    0.004725] Initializing cgroup subsys ns
[    0.004799] Initializing cgroup subsys cpuacct
[    0.004868] Initializing cgroup subsys memory
[    0.004942] Initializing cgroup subsys freezer
[    0.005035] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005139] CPU: L2 cache: 1024K
[    0.005226] Checking 'hlt' instruction... OK.
[    0.021271] SMP alternatives: switching to UP code
[    0.033335] Freeing SMP alternatives: 28k freed
[    0.033419] ACPI: Core revision 20090320
[    0.043165] ACPI: setting ELCR to 0200 (from 0c00)
[    0.044110] weird, boot CPU (#0) not listed by the BIOS.
[    0.044178] SMP motherboard not detected.
[    0.044242] Local APIC not detected. Using dummy APIC emulation.
[    0.044309] SMP disabled
[    0.044623] Brought up 1 CPUs
[    0.044688] Total of 1 processors activated (1993.42 BogoMIPS).
[    0.044775] CPU0 attaching NULL sched-domain.
[    0.045177] net_namespace: 1056 bytes
[    0.045264] Booting paravirtualized kernel on bare hardware
[    0.045800] regulator: core version 0.5
[    0.045894] Time: 17:39:38  Date: 07/08/09
[    0.046050] NET: Registered protocol family 16
[    0.046351] EISA bus registered
[    0.046436] ACPI: bus type pci registered
[    0.047219] PCI: PCI BIOS revision 2.10 entry at 0xfd9c3, last bus=2
[    0.047288] PCI: Using configuration type 1 for base access
[    0.049660] bio: create slab <bio-0> at 0
[    0.050792] ACPI: EC: Look up EC in DSDT
[    0.056196] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.068110] ACPI: Interpreter enabled
[    0.068183] ACPI: (supports S0 S3 S4 S5)
[    0.068431] ACPI: Using PIC for interrupt routing
[    0.076793] ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
[    0.076864] ACPI: EC: driver started in interrupt mode
[    0.077042] ACPI: Power Resource [LRP0] (off)
[    0.077180] ACPI: Power Resource [LRP1] (off)
[    0.077318] ACPI: Power Resource [LRP2] (off)
[    0.077669] ACPI: No dock devices found.
[    0.077753] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.077897] pci 0000:00:00.0: reg 10 32bit mmio: [0xe2000000-0xe3ffffff]
[    0.078034] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
[    0.078096] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
[    0.078160] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
[    0.078230] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd0000000-0xd00003ff]
[    0.078295] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.078367] pci 0000:00:1d.7: PME# disabled
[    0.078527] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.078615] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.078710] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.078720] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.078729] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.078739] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.078749] pci 0000:00:1f.1: reg 20 io port: [0x1860-0x186f]
[    0.078759] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.078819] pci 0000:00:1f.3: reg 20 io port: [0x1880-0x189f]
[    0.078871] pci 0000:00:1f.5: reg 10 io port: [0x1c00-0x1cff]
[    0.078881] pci 0000:00:1f.5: reg 14 io port: [0x18c0-0x18ff]
[    0.078890] pci 0000:00:1f.5: reg 18 32bit mmio: [0xd0000c00-0xd0000dff]
[    0.078900] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xd0000800-0xd00008ff]
[    0.078935] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.079005] pci 0000:00:1f.5: PME# disabled
[    0.079101] pci 0000:00:1f.6: reg 10 io port: [0x2400-0x24ff]
[    0.079111] pci 0000:00:1f.6: reg 14 io port: [0x2000-0x207f]
[    0.079155] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.079224] pci 0000:00:1f.6: PME# disabled
[    0.079331] pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xd8ffffff]
[    0.079341] pci 0000:01:00.0: reg 14 32bit mmio: [0xf0000000-0xf3ffffff]
[    0.079350] pci 0000:01:00.0: reg 18 32bit mmio: [0xe8000000-0xe807ffff]
[    0.079368] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.079430] pci 0000:00:01.0: bridge 32bit mmio: [0xd8000000-0xdfffffff]
[    0.079437] pci 0000:00:01.0: bridge 32bit mmio pref: [0xe8000000-0xf7ffffff]
[    0.079486] pci 0000:02:05.0: reg 10 32bit mmio: [0xe0002000-0xe0002fff]
[    0.079572] pci 0000:02:06.0: reg 10 32bit mmio: [0xe0003000-0xe0003fff]
[    0.079595] pci 0000:02:06.0: supports D1 D2
[    0.079600] pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.079671] pci 0000:02:06.0: PME# disabled
[    0.079770] pci 0000:02:06.1: reg 10 32bit mmio: [0xe0004000-0xe0004fff]
[    0.079793] pci 0000:02:06.1: supports D1 D2
[    0.079798] pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.079868] pci 0000:02:06.1: PME# disabled
[    0.079965] pci 0000:02:06.2: reg 10 io port: [0x4000-0x403f]
[    0.080063] pci 0000:02:07.0: reg 10 32bit mmio: [0xe0000000-0xe0001fff]
[    0.080095] pci 0000:02:07.0: reg 30 32bit mmio: [0x000000-0x003fff]
[    0.080116] pci 0000:02:07.0: supports D1 D2
[    0.080121] pci 0000:02:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.080191] pci 0000:02:07.0: PME# disabled
[    0.080290] pci 0000:00:1e.0: transparent bridge
[    0.080357] pci 0000:00:1e.0: bridge io port: [0x3000-0x4fff]
[    0.080365] pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xe05fffff]
[    0.080415] pci_bus 0000:00: on NUMA node 0
[    0.080426] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.080705] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
[    0.080801] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.087832] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.088187] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.088546] ACPI: PCI Interrupt Link [LNKC] (IRQs 12) *11
[    0.088944] ACPI: PCI Interrupt Link [LNKD] (IRQs 15) *10
[    0.089342] ACPI: PCI Interrupt Link [LNKE] (IRQs 9 10 11 12 15) *0, disabled.
[    0.089951] ACPI: PCI Interrupt Link [LNKF] (IRQs 9 10 11 12 15) *0, disabled.
[    0.090561] ACPI: PCI Interrupt Link [LNKG] (IRQs 9 10 11 12 15) *0, disabled.
[    0.092161] ACPI: PCI Interrupt Link [LNKH] (IRQs 9 *10 11 12 15)
[    0.092805] SCSI subsystem initialized
[    0.092965] libata version 3.00 loaded.
[    0.093103] usbcore: registered new interface driver usbfs
[    0.093204] usbcore: registered new interface driver hub
[    0.093319] usbcore: registered new device driver usb
[    0.093647] ACPI: WMI: Mapper loaded
[    0.093711] PCI: Using ACPI for IRQ routing
[    0.094016] Bluetooth: Core ver 2.15
[    0.094134] NET: Registered protocol family 31
[    0.094199] Bluetooth: HCI device and connection manager initialized
[    0.094268] Bluetooth: HCI socket layer initialized
[    0.094333] NET: Registered protocol family 8
[    0.094396] NET: Registered protocol family 20
[    0.094505] NetLabel: Initializing
[    0.094567] NetLabel:  domain hash size = 128
[    0.094631] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.094718] NetLabel:  unlabeled traffic allowed by default
[    0.094943] pnp: PnP ACPI init
[    0.095016] ACPI: bus type pnp registered
[    0.099380] pnp: PnP ACPI: found 8 devices
[    0.099445] ACPI: ACPI bus type pnp unregistered
[    0.099513] PnPBIOS: Disabled by ACPI PNP
[    0.099593] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.099663] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.099732] system 00:04: ioport range 0x800-0x807 has been reserved
[    0.099802] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.099871] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.099941] system 00:04: ioport range 0xfe00-0xfe7f has been reserved
[    0.100023] system 00:04: ioport range 0xfe80-0xfeff has been reserved
[    0.100094] system 00:04: iomem range 0xfebfe000-0xfebfefff has been reserved
[    0.100166] system 00:04: iomem range 0xfebff000-0xfebfffff has been reserved
[    0.100237] system 00:04: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.135091] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.135160] pci 0000:00:01.0:   IO window: disabled
[    0.135228] pci 0000:00:01.0:   MEM window: 0xd8000000-0xdfffffff
[    0.135298] pci 0000:00:01.0:   PREFETCH window: 0x000000e8000000-0x000000f7ffffff
[    0.135396] pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
[    0.135465] pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
[    0.135535] pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
[    0.135605] pci 0000:02:06.0:   PREFETCH window: 0x70000000-0x73ffffff
[    0.135676] pci 0000:02:06.0:   MEM window: 0x7c000000-0x7fffffff
[    0.135746] pci 0000:02:06.1: CardBus bridge, secondary bus 0000:07
[    0.135814] pci 0000:02:06.1:   IO window: 0x003800-0x0038ff
[    0.135883] pci 0000:02:06.1:   IO window: 0x003c00-0x003cff
[    0.135952] pci 0000:02:06.1:   PREFETCH window: 0x74000000-0x77ffffff
[    0.136032] pci 0000:02:06.1:   MEM window: 0x80000000-0x83ffffff
[    0.136102] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.136171] pci 0000:00:1e.0:   IO window: 0x3000-0x4fff
[    0.136241] pci 0000:00:1e.0:   MEM window: 0xe0000000-0xe05fffff
[    0.136311] pci 0000:00:1e.0:   PREFETCH window: 0x00000070000000-0x00000079ffffff
[    0.136415] pci 0000:00:1e.0: setting latency timer to 64
[    0.136426] pci 0000:02:06.0: enabling device (0006 -> 0007)
[    0.136775] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.136843] PCI: setting IRQ 11 as level-triggered
[    0.136851] pci 0000:02:06.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    0.136946] pci 0000:02:06.1: enabling device (0006 -> 0007)
[    0.137279] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.137346] PCI: setting IRQ 10 as level-triggered
[    0.137354] pci 0000:02:06.1: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[    0.137446] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.137452] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.137458] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xdfffffff]
[    0.137463] pci_bus 0000:01: resource 2 pref mem [0xe8000000-0xf7ffffff]
[    0.137469] pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
[    0.137474] pci_bus 0000:02: resource 1 mem: [0xe0000000-0xe05fffff]
[    0.137480] pci_bus 0000:02: resource 2 pref mem [0x70000000-0x79ffffff]
[    0.137485] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.137490] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    0.137496] pci_bus 0000:03: resource 0 io:  [0x3000-0x30ff]
[    0.137502] pci_bus 0000:03: resource 1 io:  [0x3400-0x34ff]
[    0.137508] pci_bus 0000:03: resource 2 pref mem [0x70000000-0x73ffffff]
[    0.137515] pci_bus 0000:03: resource 3 mem: [0x7c000000-0x7fffffff]
[    0.137521] pci_bus 0000:07: resource 0 io:  [0x3800-0x38ff]
[    0.137527] pci_bus 0000:07: resource 1 io:  [0x3c00-0x3cff]
[    0.137533] pci_bus 0000:07: resource 2 pref mem [0x74000000-0x77ffffff]
[    0.137540] pci_bus 0000:07: resource 3 mem: [0x80000000-0x83ffffff]
[    0.137609] NET: Registered protocol family 2
[    0.137876] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.138650] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.140556] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.141753] TCP: Hash tables configured (established 131072 bind 65536)
[    0.141825] TCP reno registered
[    0.142109] NET: Registered protocol family 1
[    0.142323] Trying to unpack rootfs image as initramfs...
[    0.839473] Freeing initrd memory: 7665k freed
[    0.853626] Simple Boot Flag at 0x36 set to 0x1
[    0.853746] cpufreq-nforce2: No nForce2 chipset.
[    0.853864] Scanning for low memory corruption every 60 seconds
[    0.854191] audit: initializing netlink socket (disabled)
[    0.854296] type=2000 audit(1247074778.852:1): initialized
[    0.868111] Switched to high resolution mode on CPU 0
[    0.876619] highmem bounce pool size: 64 pages
[    0.876695] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.879718] VFS: Disk quotas dquot_6.5.2
[    0.879907] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.881301] fuse init (API version 7.11)
[    0.881545] msgmni has been set to 1720
[    0.881977] alg: No test for stdrng (krng)
[    0.882064] io scheduler noop registered
[    0.882128] io scheduler anticipatory registered
[    0.882193] io scheduler deadline registered
[    0.882351] io scheduler cfq registered (default)
[    0.882524] pci 0000:01:00.0: Boot video device
[    0.882702] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.882818] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.883597] ACPI: AC Adapter [AC] (on-line)
[    0.883795] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.883882] ACPI: Power Button [PWRF]
[    0.884063] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.884154] ACPI: Power Button [PWRB]
[    0.884447] fan PNP0C0B:00: registered as cooling_device0
[    0.884521] ACPI: Fan [FAN0] (off)
[    0.884739] fan PNP0C0B:01: registered as cooling_device1
[    0.884813] ACPI: Fan [FAN1] (off)
[    0.885030] fan PNP0C0B:02: registered as cooling_device2
[    0.885103] ACPI: Fan [FAN2] (off)
[    0.885657] Marking TSC unstable due to TSC halts in idle
[    0.885749] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.885998] processor ACPI_CPU:00: registered as cooling_device3
[    0.886068] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.891276] thermal LNXTHERM:01: registered as thermal_zone0
[    0.891355] ACPI: Thermal Zone [THRM] (50 C)
[    0.891507] isapnp: Scanning for PnP cards...
[    1.245557] isapnp: No Plug & Play device found
[    1.247762] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.247988] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.250245] serial 00:06: activated
[    1.250452] 00:06: ttyS0 at I/O 0x300 (irq = 4) is a 16550A
[    1.250668] serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[    1.250761] serial 0000:00:1f.6: PCI INT B disabled
[    1.252223] brd: module loaded
[    1.252941] loop: module loaded
[    1.253167] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.253310] Driver 'sd' needs updating - please use bus_type methods
[    1.253392] Driver 'sr' needs updating - please use bus_type methods
[    1.253586] ata_piix 0000:00:1f.1: version 2.13
[    1.253601] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    1.253968] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
[    1.254036] PCI: setting IRQ 12 as level-triggered
[    1.254044] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
[    1.254193] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.254433] scsi0 : ata_piix
[    1.254684] scsi1 : ata_piix
[    1.255785] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
[    1.255857] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
[    1.257198] Fixed MDIO Bus: probed
[    1.257270] PPP generic driver version 2.4.2
[    1.257503] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.257879] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    1.257951] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
[    1.258057] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.258063] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.258233] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.262240] ehci_hcd 0000:00:1d.7: debug port 1
[    1.262310] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.262324] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xd0000000
[    1.275968] ACPI: Battery Slot [CMB0] (battery present)
[    1.276160] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.276417] usb usb1: configuration #1 chosen from 1 choice
[    1.276539] hub 1-0:1.0: USB hub found
[    1.276614] hub 1-0:1.0: 6 ports detected
[    1.276896] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.276994] uhci_hcd: USB Universal Host Controller Interface driver
[    1.277114] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    1.277206] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.277212] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.277377] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.277487] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
[    1.277707] usb usb2: configuration #1 chosen from 1 choice
[    1.277820] hub 2-0:1.0: USB hub found
[    1.277893] hub 2-0:1.0: 2 ports detected
[    1.278379] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 15
[    1.278447] PCI: setting IRQ 15 as level-triggered
[    1.278455] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
[    1.278548] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.278554] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.278694] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.278802] uhci_hcd 0000:00:1d.1: irq 15, io base 0x00001820
[    1.279020] usb usb3: configuration #1 chosen from 1 choice
[    1.279134] hub 3-0:1.0: USB hub found
[    1.279205] hub 3-0:1.0: 2 ports detected
[    1.279404] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
[    1.279498] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.279504] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.279652] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.279761] uhci_hcd 0000:00:1d.2: irq 12, io base 0x00001840
[    1.279980] usb usb4: configuration #1 chosen from 1 choice
[    1.280123] hub 4-0:1.0: USB hub found
[    1.280196] hub 4-0:1.0: 2 ports detected
[    1.280496] PNP: No PS/2 controller found. Probing ports directly.
[    1.482756] ata1.00: failed to set max address (err_mask=0x1)
[    1.482826] ata1.00: device aborted resize (268435456 -> 312581808), skipping HPA handling
[    1.483875] ata1.00: ATA-8: WDC WD1600BEVE-00WZT0, 01.01A01, max UDMA/100
[    1.483947] ata1.00: 268435456 sectors, multi 16: LBA48 
[    1.500267] ata1.00: configured for UDMA/100
[    1.500534] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVE-0 01.0 PQ: 0 ANSI: 5
[    1.500808] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.500973] sd 0:0:0:0: [sda] 268435456 512-byte hardware sectors: (137 GB/128 GiB)
[    1.501086] sd 0:0:0:0: [sda] Write Protect is off
[    1.501153] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.501199] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.501457]  sda:<7>ata2: port disabled. ignoring.
[    1.513372]  sda1 sda2 sda3
[    1.532357] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.532528] mice: PS/2 mouse device common for all mice
[    1.532797] rtc_cmos 00:01: RTC can wake from S4
[    1.532923] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.533009] rtc0: alarms up to one month, y3k, 242 bytes nvram
[    1.533315] device-mapper: uevent: version 1.0.3
[    1.533760] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.534010] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.534251] device-mapper: multipath: version 1.0.5 loaded
[    1.534320] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.534574] EISA: Probing bus 0 at eisa.0
[    1.534645] Cannot allocate resource for EISA slot 1
[    1.534713] Cannot allocate resource for EISA slot 2
[    1.534778] Cannot allocate resource for EISA slot 3
[    1.534844] Cannot allocate resource for EISA slot 4
[    1.534927] EISA: Detected 0 cards.
[    1.535142] cpuidle: using governor ladder
[    1.535318] cpuidle: using governor menu
[    1.536500] TCP cubic registered
[    1.536921] NET: Registered protocol family 10
[    1.537956] lo: Disabled Privacy Extensions
[    1.538771] NET: Registered protocol family 17
[    1.538876] Bluetooth: L2CAP ver 2.13
[    1.538939] Bluetooth: L2CAP socket layer initialized
[    1.539005] Bluetooth: SCO (Voice Link) ver 0.6
[    1.539068] Bluetooth: SCO socket layer initialized
[    1.539184] Bluetooth: RFCOMM socket layer initialized
[    1.539265] Bluetooth: RFCOMM TTY layer initialized
[    1.539330] Bluetooth: RFCOMM ver 1.11
[    1.539771] Using IPI No-Shortcut mode
[    1.539941] PM: Resume from disk failed.
[    1.539960] registered taskstats version 1
[    1.540256]   Magic number: 1:542:693
[    1.540449] rtc_cmos 00:01: setting system clock to 2009-07-08 17:39:40 UTC (1247074780)
[    1.540538] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.540605] EDD information not available.
[    1.540751] Freeing unused kernel memory: 528k freed
[    1.541333] Write protecting the kernel text: 4180k
[    1.541457] Write protecting the kernel read-only data: 1664k
[    1.542341] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.884072] usb 2-2: new low speed USB device using uhci_hcd and address 2
[    2.035723] b44 0000:02:07.0: PCI INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
[    2.066695] usb 2-2: configuration #1 chosen from 1 choice
[    2.096160] ssb: Sonics Silicon Backplane found on PCI device 0000:02:07.0
[    2.096275] b44.c:v2.0
[    2.117573] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:11:85:5d:db:ae
[    2.308125] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    2.412464] usbcore: registered new interface driver hiddev
[    2.428235] input: Jing-Mold USB K/B+Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
[    2.428922] generic-usb 0003:05AF:080A.0001: input,hidraw0: USB HID v1.10 Keyboard [Jing-Mold USB K/B+Mouse] on usb-0000:00:1d.0-2/input0
[    2.459682] input: Jing-Mold USB K/B+Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input5
[    2.459945] generic-usb 0003:05AF:080A.0002: input,hidraw1: USB HID v1.10 Mouse [Jing-Mold USB K/B+Mouse] on usb-0000:00:1d.0-2/input1
[    2.460098] usbcore: registered new interface driver usbhid
[    2.460167] usbhid: v2.6:USB HID core driver
[    2.537864] usb 4-2: configuration #1 chosen from 1 choice
[    2.750786] PM: Starting manual resume from disk
[    2.750856] PM: Resume from partition 8:2
[    2.750859] PM: Checking hibernation image.
[    2.751122] PM: Resume from disk failed.
[    2.755993] PM: Marking nosave pages: 0000000000002000 - 0000000000006000
[    2.756002] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.756104] PM: Basic memory bitmaps created
[    2.779243] PM: Basic memory bitmaps freed
[    2.809723] kjournald starting.  Commit interval 5 seconds
[    2.809809] EXT3-fs: mounted filesystem with writeback data mode.
[    8.120056] udev: starting version 141
[    8.340779] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    8.341030] usbcore: registered new interface driver btusb
[    8.369399] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    8.388482] Linux agpgart interface v0.103
[    8.405429] agpgart-intel 0000:00:00.0: Intel 855PM Chipset
[    8.407867] agpgart-intel 0000:00:00.0: AGP aperture is 32M @ 0xe2000000
[    8.454802] intel_rng: FWH not detected
[    8.570729] iTCO_vendor_support: vendor-support=0
[    8.595532] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.595715] iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
[    8.595877] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.657242] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/input/input6
[    8.657420] ACPI: Video Device [AGPB] (multi-head: yes  rom: no  post: no)
[    8.709800] irda_init()
[    8.709820] NET: Registered protocol family 23
[    8.841078] yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:08b0]
[    8.841172] yenta_cardbus 0000:02:06.0: Using CSCINT to route CSC interrupts to PCI
[    8.841258] yenta_cardbus 0000:02:06.0: Routing CardBus interrupts to PCI
[    8.841331] yenta_cardbus 0000:02:06.0: TI: mfunc 0x00001022, devctl 0x64
[    8.928451] lib80211: common routines for IEEE802.11 drivers
[    8.928528] lib80211_crypt: registered algorithm 'NULL'
[    8.945731] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    9.004596] ieee80211: 802.11 data/management/control stack, git-1.1.13
[    9.004673] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[    9.072865] yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x00f8, PCI irq 11
[    9.072944] yenta_cardbus 0000:02:06.0: Socket status: 30000086
[    9.073015] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #02 to #06
[    9.073113] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x4fff
[    9.073203] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x4fff: clean.
[    9.074192] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe05fffff
[    9.074283] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x70000000 - 0x79ffffff
[    9.074644] yenta_cardbus 0000:02:06.1: CardBus bridge found [103c:08b0]
[    9.074730] yenta_cardbus 0000:02:06.1: Using CSCINT to route CSC interrupts to PCI
[    9.074815] yenta_cardbus 0000:02:06.1: Routing CardBus interrupts to PCI
[    9.074888] yenta_cardbus 0000:02:06.1: TI: mfunc 0x00001022, devctl 0x64
[    9.093684] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    9.093763] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    9.115525] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; irq 3 ; dma 3.
[    9.115568] nsc-ircc, chip->init
[    9.115644] nsc-ircc, Found chip at base=0x04e
[    9.115731] nsc-ircc, driver loaded (Dag Brattli)
[    9.115801] nsc_ircc_open(), can't get iobase of 0x2f8
[    9.115894] nsc-ircc, Found chip at base=0x04e
[    9.115982] nsc-ircc, driver loaded (Dag Brattli)
[    9.116074] nsc_ircc_open(), can't get iobase of 0x2f8
[    9.116406] nsc-ircc 00:07: disabled
[    9.311622] yenta_cardbus 0000:02:06.1: ISA IRQ mask 0x00f8, PCI irq 10
[    9.311702] yenta_cardbus 0000:02:06.1: Socket status: 30000084
[    9.311772] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #06 to #0a
[    9.311869] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x4fff
[    9.311959] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3000-0x4fff: clean.
[    9.313007] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe05fffff
[    9.313098] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0x70000000 - 0x79ffffff
[    9.313721] ipw2100 0000:02:05.0: PCI INT A -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
[    9.314639] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
[    9.314739] ipw2100 0000:02:05.0: firmware: requesting ipw2100-1.3.fw
[    9.591488] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
[    9.594468] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[    9.595489] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
[    9.596336] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
[    9.597391] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
[    9.762261] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[    9.762406] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    9.941546] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af: clean.
[    9.943533] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[    9.944591] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff: clean.
[    9.945399] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7: clean.
[    9.946467] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff: clean.
[   10.688054] intel8x0_measure_ac97_clock: measured 55346 usecs (2667 samples)
[   10.688130] intel8x0: clocking to 48000
[   10.875976] lp: driver loaded but no devices found
[   10.974437] Adding 2104504k swap on /dev/sda2.  Priority:-1 extents:1 across:2104504k 
[   11.332968] EXT3 FS on sda3, internal journal
[   14.877364] ttyS1: LSR safety check engaged!
[   15.192110] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.192118] Bluetooth: BNEP filters: protocol multicast
[   15.239157] Bridge firewalling registered
[   16.140896] ppdev: user-space parallel port driver
[   20.045827] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.052279] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   21.164473] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   22.103380] lib80211_crypt: registered algorithm 'CCMP'
[   22.176778] padlock: VIA PadLock not detected.
[   22.208252] lib80211_crypt: registered algorithm 'TKIP'
[   31.392036] eth1: no IPv6 routers present
[   78.132040] Clocksource tsc unstable (delta = -99093793 ns)

--------------090307070403060106010904--
