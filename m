Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYKISNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYKISNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 13:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYKISMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 13:12:55 -0500
Received: from voyager.telenet.dn.ua ([195.39.211.35]:53703 "EHLO
	voyager.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYKISMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 13:12:51 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2008 13:12:50 EST
Message-ID: <4917263D.2090904@telenet.dn.ua>
Date: Sun, 09 Nov 2008 20:04:45 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Slow file transfer speeds with CFQ IO scheduler in some cases
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm building small server system with openvz kernel and have ran into
some IO performance problems. Reading a single file via NFS delivers
around 9 MB/s over gigabit network, but while reading, say, 2 different
or same file 2 times at the same time I get >60MB/s.

Changing IO scheduler to deadline or anticipatory fixes problem.

Tested kernels:
  OpenVZ RHEL5 028stab059.3 (9 MB/s with HZ=100, 20MB/s with HZ=1000
                 fast local reads)
  Vanilla 2.6.27.5 (40 MB/s with HZ=100, slow local reads)

Vanilla performs better in worst case but I believe 40 is still low
concerning test results below.


Server-side Hardware:
Athlon X2, PCI-E motherboard Gigabyte GA-MA74GM-S2H
Onboard PCI-E RTL8111C
Onboard Southbridge SATA controller
Two SATA drives in degraded RAID5, AHCI+NCQ.

Client:
Athlon X2, PCI motherboard, Asus A8V Deluxe
Onboard PCI Marvell 88E8001
Onboard Southbridge SATA controller
Kernel: 2.6.27-gentoo-r2  (2.6.27.4 + some Gentoo patches)

RTL8111C driver does not support TX checksum offloading - this
can be the source of relatively high sys CPU load below.

No readahead, etc. tuning - all are defaults.


I realize, this is not typical setup (degraded raid5, e.g.) and I can not
test non-degraded 3 disk variant right now, but this setup may exploit some
cfs+md weakness...

No other tasks are performed on server.

Tests performed on vanilla 2.6.27.5 kernel.

Client NFS mount options does not make significant difference,
so as NFSv2/NFSv3.

All iostat results are 10 seconds average when test case was performed.

=================================================
iostat output. cfq io scheduler, "dd of=/dev/null bs=1M" over nfs
file was not in cache on server

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00    4,25   52,10    0,00   43,65

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            2819,60     0,00  450,60    0,00 47413,60     0,00   105,22     7,42   16,40   2,00  90,20
sdb            2818,30     0,00  453,20    0,00 47525,60     0,00   104,87     3,79    8,35   1,42  64,20

=================================================
iostat output. deadline io scheduler, "dd of=/dev/null bs=1M" over nfs:
file was not in cache on server

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,05    0,00   27,40   22,35    0,00   50,20

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            6971,70     0,00 1357,50    0,00 120888,00     0,00    89,05     5,73    4,22   0,35  47,50
sdb            6997,10     0,00 1328,00    0,00 120894,40     0,00    91,03     5,41    4,07   0,35  46,70

Anticipatory IO scheduler provides similar performance.

=================================================
cfq io scheduler, "dd of=/dev/null bs=1M" over nfs
file was cached on server

As there was no HDD IO activity, there's client's dd output:
$ LANG=C LC_ALL=C dd if=testfile of=/dev/null bs=1M
2721+1 records in
2721+1 records out
2853588692 bytes (2.9 GB) copied, 29.4541 s, 96.9 MB/s

=================================================
cfq io scheduler, reading two different files with "dd of=/dev/null bs=1M" over nfs
files were not in cache on server

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   25,10   40,20    0,00   34,70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            7595,90     0,00 1342,30    0,00 129604,00     0,00    96,55     5,27    3,92   0,59  78,80
sdb            7599,80     0,00 1337,80    0,00 129571,20     0,00    96,85     4,99    3,73   0,58  78,10

Copying of first file finished with 59,6 MB/s average, and now:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00    3,65   48,60    0,00   47,75

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            2816,40     0,00  461,70    0,00 47561,60     0,00   103,01     3,48    7,54   1,27  58,80
sdb            2819,20     0,00  458,80    0,00 47684,80     0,00   103,93     7,81   17,13   2,06  94,60

Second file finished with 43,1 MB/s




Tests on OpenVZ RHEL5 028stab059.3
=================================================
iostat output when performance is low with cfq io scheduler, "dd of=/dev/null bs=1M" over nfs:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,10    0,00    0,90   49,60    0,00   49,40

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda             919,56     0,00  195,01    0,00  8905,39     0,00    45,67     3,25   16,64   5,10  99,40
sdb             947,90     0,00  169,86    0,00  8942,12     0,00    52,64     0,85    4,99   2,07  35,13

Other case lead to pretty much alike results except for reading files locally on server.

With OpenVZ kernel files are read pretty fast:
*deadline:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   32,72   30,02    0,00   37,27

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda           19026,50     0,00  759,10    0,00 158289,60     0,00   208,52     0,63    0,84   0,79  60,03
sdb           19034,30     0,00  751,10    0,00 158262,40     0,00   210,71     0,64    0,85   0,80  60,13

*cfq:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,05    0,00   43,61   25,62    0,00   30,72

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda           19553,10     0,00 3089,50    0,00 181121,60     0,00    58,62     1,53    0,49   0,25  76,46
sdb           19475,20     0,00 3168,90    0,00 181152,00     0,00    57,17     1,63    0,52   0,24  76,90



with vanilla:


Reading files locally with cfq:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00    0,10   49,90    0,00   50,00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            1975,50     0,00  385,10    0,00 34176,00     0,00    88,75     1,23    3,18   2,58  99,30
sdb            1982,20     0,00  377,20    0,00 34181,60     0,00    90,62     1,23    3,26   2,64  99,60


... and with deadline:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,40    0,00   33,25   18,10    0,00   48,25

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda           15077,70     0,00 2952,70    0,00 260654,40     0,00    88,28     2,25    0,76   0,31  93,00
sdb           15011,50     0,00 2962,60    0,00 260648,00     0,00    87,98     2,11    0,71   0,31  93,30


Processess state when things go slowly:

# ps -eo pid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm | grep nfs
13177 TS       -  -5  29   0  0.0 S<   worker_thread  nfsd4
13179 TS       -   0  24   0  0.7 S    -              nfsd
13180 TS       -   0  23   1  0.8 D    sync_page      nfsd
13181 TS       -   0  24   1  0.8 D    sync_page      nfsd
13182 TS       -   0  24   1  0.8 D    sync_page      nfsd
13183 TS       -   0  24   1  0.8 D    sync_page      nfsd
13184 TS       -   0  24   1  0.8 D    sync_page      nfsd
13185 TS       -   0  21   1  0.7 D    sync_page      nfsd
13186 TS       -   0  23   0  0.8 D    sync_page      nfsd

and for dd
5586 TS       -   0  19   1  4.2 D+   sync_page      dd

CPU load by top:

Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.3%sy,  0.0%ni,  0.0%id, 99.3%wa,  0.3%hi,  0.0%si,  0.0%st



dmesg and kernel config follow
=================================================
[    0.000000] Linux version 2.6.27.5 (root@vortex) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #1 SMP Sun Nov 9 17:23:39
EET 2008
[    0.000000] Command line: BOOT_IMAGE=(md0)/boot/vmlinuz-2.6.27.5 iommu=memaper=3 root=/dev/md0 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dbde0000 (usable)
[    0.000000]  BIOS-e820: 00000000dbde0000 - 00000000dbde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dbde3000 - 00000000dbdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dbdf0000 - 00000000dbe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xdbde0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00dbc00000 page 2M
[    0.000000]  00dbc00000 - 00dbde0000 page 4k
[    0.000000] kernel direct mapping tables up to dbde0000 @ 8000-e000
[    0.000000] last_map_addr: dbde0000 end: dbde0000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
[    0.000000] last_map_addr: 120000000 end: 120000000
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F7200, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT DBDE3000, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: FACP DBDE3040, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: DSDT DBDE30C0, 41A8 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
[    0.000000] ACPI: FACS DBDE0000, 0040
[    0.000000] ACPI: SSDT DBDE7340, 01C4 (r1 PTLTD  POWERNOW        1  LTP        1)
[    0.000000] ACPI: HPET DBDE7540, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
[    0.000000] ACPI: MCFG DBDE7580, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: APIC DBDE7280, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001454014]    TEXT DATA BSS ==> [0001000000 - 0001454014]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #5 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000] found SMP MP-table at [ffff8800000f5840] 000f5840
[    0.000000]  [ffffe20000000000-ffffe20003ffffff] PMD -> [ffff880028200000-ffff88002c1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dbde0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1031551
[    0.000000]   DMA zone: 3837 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 882200 pages, LIFO batch:31
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
[    0.000000] PERCPU: Allocating 41888 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1015317
[    0.000000] Kernel command line: BOOT_IMAGE=(md0)/boot/vmlinuz-2.6.27.5 iommu=memaper=3 root=/dev/md0 ro
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PIT calibration value
[    0.000000] Detected 1908.813 MHz processor.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.010000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010000] Checking aperture...
[    0.010000] Node 0: aperture @ 10000000 size 32 MB
[    0.010000] Aperture pointing to e820 RAM. Ignoring.
[    0.010000] Your BIOS doesn't leave a aperture memory hole
[    0.010000] Please enable the IOMMU option in the BIOS setup
[    0.010000] This costs you 256 MB of RAM
[    0.010000] Mapping aperture over 262144 KB of RAM @ 30000000
[    0.010000] Memory: 3786696k/4718592k available (2399k kernel code, 338632k reserved, 1267k data, 268k init)
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] hpet clockevent registered
[    0.010008] Calibrating delay loop (skipped), value calculated using timer frequency.. 3817.62 BogoMIPS (lpj=19088130)
[    0.010210] Mount-cache hash table entries: 256
[    0.010434] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.010510] CPU: L2 Cache: 512K (64 bytes/line)
[    0.010583] tseg: 00dbe00000
[    0.010585] CPU: Physical Processor ID: 0
[    0.010658] CPU: Processor Core ID: 0
[    0.010739] using C1E aware idle routine
[    0.010830] ACPI: Core revision 20080609
[    0.020552] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.126459] CPU0: AMD Athlon(tm) X2 Dual Core Processor BE-2300 stepping 02
[    0.126599] Using local APIC timer interrupts.
[    0.130001] APIC timer calibration result 12557978
[    0.130003] Detected 12.557 MHz APIC timer.
[    0.130229] Booting processor 1/1 ip 6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 3817.70 BogoMIPS (lpj=19088540)
[    0.010000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.010000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.290187] CPU1: AMD Athlon(tm) X2 Dual Core Processor BE-2300 stepping 02
[    0.290810] Brought up 2 CPUs
[    0.290884] Total of 2 processors activated (7635.33 BogoMIPS).
[    0.291037] CPU0 attaching sched-domain:
[    0.291040]  domain 0: span 0-1 level CPU
[    0.291042]   groups: 0 1
[    0.291047] CPU1 attaching sched-domain:
[    0.291049]  domain 0: span 0-1 level CPU
[    0.291051]   groups: 1 0
[    0.291307] net_namespace: 1456 bytes
[    0.291408] xor: automatically using best checksumming function: generic_sse
[    0.340002]    generic_sse:  5886.000 MB/sec
[    0.340075] xor: using function: generic_sse (5886.000 MB/sec)
[    0.340188] NET: Registered protocol family 16
[    0.340482] node 0 link 0: io port [c000, ffff]
[    0.340485] TOM: 00000000e0000000 aka 3584M
[    0.340560] node 0 link 0: mmio [a0000, bffff]
[    0.340563] node 0 link 0: mmio [fc000000, fe02ffff]
[    0.340566] node 0 link 0: mmio [e0000000, f7ffffff]
[    0.340569] node 0 link 0: mmio [f8000000, fbffffff]
[    0.340572] node 0 link 0: mmio [e0000000, efffffff]
[    0.340575] TOM2: 0000000120000000 aka 4608M
[    0.340649] bus: [00,03] on node 0 link 0
[    0.340651] bus: 00 index 0 io port: [0, ffff]
[    0.340653] bus: 00 index 1 mmio: [a0000, bffff]
[    0.340656] bus: 00 index 2 mmio: [f8000000, ffffffff]
[    0.340659] bus: 00 index 3 mmio: [e0000000, f7ffffff]
[    0.340661] bus: 00 index 4 mmio: [120000000, fcffffffff]
[    0.340669] ACPI: bus type pci registered
[    0.340839] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.340915] PCI: MCFG area at e0000000 reserved in E820
[    0.347486] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.347562] PCI: Using configuration type 1 for base access
[    0.349147] ACPI: EC: Look up EC in DSDT
[    0.355565] ACPI: Interpreter enabled
[    0.355645] ACPI: (supports S0 S1 S5)
[    0.355828] ACPI: Using IOAPIC for interrupt routing
[    0.361023] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.361209] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.361285] pci 0000:00:06.0: PME# disabled
[    0.361413] PCI: 0000:00:11.0 reg 10 io port: [ff00, ff07]
[    0.361420] PCI: 0000:00:11.0 reg 14 io port: [fe00, fe03]
[    0.361427] PCI: 0000:00:11.0 reg 18 io port: [fd00, fd07]
[    0.361433] PCI: 0000:00:11.0 reg 1c io port: [fc00, fc03]
[    0.361440] PCI: 0000:00:11.0 reg 20 io port: [fb00, fb0f]
[    0.361447] PCI: 0000:00:11.0 reg 24 32bit mmio: [fe02f000, fe02f3ff]
[    0.361488] PCI: 0000:00:12.0 reg 10 32bit mmio: [fe02e000, fe02efff]
[    0.361540] PCI: 0000:00:12.1 reg 10 32bit mmio: [fe02d000, fe02dfff]
[    0.361610] PCI: 0000:00:12.2 reg 10 32bit mmio: [fe02c000, fe02c0ff]
[    0.361655] pci 0000:00:12.2: supports D1
[    0.361657] pci 0000:00:12.2: supports D2
[    0.361659] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.361736] pci 0000:00:12.2: PME# disabled
[    0.361832] PCI: 0000:00:13.0 reg 10 32bit mmio: [fe02b000, fe02bfff]
[    0.361884] PCI: 0000:00:13.1 reg 10 32bit mmio: [fe02a000, fe02afff]
[    0.361954] PCI: 0000:00:13.2 reg 10 32bit mmio: [fe029000, fe0290ff]
[    0.361999] pci 0000:00:13.2: supports D1
[    0.362001] pci 0000:00:13.2: supports D2
[    0.362003] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.362080] pci 0000:00:13.2: PME# disabled
[    0.362250] PCI: 0000:00:14.1 reg 10 io port: [0, 7]
[    0.362256] PCI: 0000:00:14.1 reg 14 io port: [0, 3]
[    0.362263] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
[    0.362270] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
[    0.362276] PCI: 0000:00:14.1 reg 20 io port: [fa00, fa0f]
[    0.362394] PCI: 0000:00:14.5 reg 10 32bit mmio: [fe028000, fe028fff]
[    0.362513] PCI: 0000:01:05.0 reg 10 64bit mmio: [f8000000, fbffffff]
[    0.362519] PCI: 0000:01:05.0 reg 18 64bit mmio: [fdef0000, fdefffff]
[    0.362523] PCI: 0000:01:05.0 reg 20 io port: [ee00, eeff]
[    0.362527] PCI: 0000:01:05.0 reg 24 32bit mmio: [fdd00000, fddfffff]
[    0.362535] pci 0000:01:05.0: supports D1
[    0.362537] pci 0000:01:05.0: supports D2
[    0.362549] PCI: bridge 0000:00:01.0 io port: [e000, efff]
[    0.362552] PCI: bridge 0000:00:01.0 32bit mmio: [fdd00000, fdefffff]
[    0.362556] PCI: bridge 0000:00:01.0 64bit mmio pref: [f8000000, fbffffff]
[    0.362590] PCI: 0000:02:00.0 reg 10 io port: [de00, deff]
[    0.362605] PCI: 0000:02:00.0 reg 18 64bit mmio: [fdfff000, fdffffff]
[    0.362616] PCI: 0000:02:00.0 reg 20 64bit mmio: [fdfe0000, fdfeffff]
[    0.362622] PCI: 0000:02:00.0 reg 30 32bit mmio: [0, ffff]
[    0.362643] pci 0000:02:00.0: supports D1
[    0.362645] pci 0000:02:00.0: supports D2
[    0.362647] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.362723] pci 0000:02:00.0: PME# disabled
[    0.362835] PCI: bridge 0000:00:06.0 io port: [d000, dfff]
[    0.362837] PCI: bridge 0000:00:06.0 32bit mmio: [fda00000, fdafffff]
[    0.362841] PCI: bridge 0000:00:06.0 64bit mmio pref: [fdf00000, fdffffff]
[    0.362898] pci 0000:00:14.4: transparent bridge
[    0.362973] PCI: bridge 0000:00:14.4 io port: [c000, cfff]
[    0.362978] PCI: bridge 0000:00:14.4 32bit mmio: [fdc00000, fdcfffff]
[    0.362982] PCI: bridge 0000:00:14.4 32bit mmio pref: [fdb00000, fdbfffff]
[    0.362994] bus 00 -> node 0
[    0.363001] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.363388] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.363531] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.363640] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.380108] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.380697] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.381281] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.381864] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.382448] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.383031] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.383615] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.384198] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.384872] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.384988] pnp: PnP ACPI init
[    0.385069] ACPI: bus type pnp registered
[    0.388621] pnp: PnP ACPI: found 13 devices
[    0.388696] ACPI: ACPI bus type pnp unregistered
[    0.389070] SCSI subsystem initialized
[    0.389204] libata version 3.00 loaded.
[    0.389349] usbcore: registered new interface driver usbfs
[    0.389502] usbcore: registered new interface driver hub
[    0.389637] usbcore: registered new device driver usb
[    0.389965] PCI: Using ACPI for IRQ routing
[    0.450159] PCI-DMA: Disabling AGP.
[    0.453299] PCI-DMA: aperture base @ 30000000 size 262144 KB
[    0.453374] PCI-DMA: using GART IOMMU.
[    0.453454] PCI-DMA: Reserving 256MB of IOMMU area in the AGP aperture
[    0.455179] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.455423] hpet0: 4 32-bit timers, 14318180 Hz
[    0.460016] Switched to high resolution mode on CPU 0
[    0.460130] Switched to high resolution mode on CPU 1
[    0.490040] system 00:01: ioport range 0x4100-0x411f has been reserved
[    0.490116] system 00:01: ioport range 0x228-0x22f has been reserved
[    0.490192] system 00:01: ioport range 0x40b-0x40b has been reserved
[    0.490268] system 00:01: ioport range 0x4d6-0x4d6 has been reserved
[    0.490343] system 00:01: ioport range 0xc00-0xc01 has been reserved
[    0.490418] system 00:01: ioport range 0xc14-0xc14 has been reserved
[    0.490493] system 00:01: ioport range 0xc50-0xc52 has been reserved
[    0.490568] system 00:01: ioport range 0xc6c-0xc6d has been reserved
[    0.490643] system 00:01: ioport range 0xc6f-0xc6f has been reserved
[    0.490717] system 00:01: ioport range 0xcd0-0xcd1 has been reserved
[    0.493648] system 00:01: ioport range 0xcd2-0xcd3 has been reserved
[    0.493724] system 00:01: ioport range 0xcd4-0xcdf has been reserved
[    0.493800] system 00:01: ioport range 0x4000-0x40fe has been reserved
[    0.493877] system 00:01: ioport range 0x4210-0x4217 has been reserved
[    0.493953] system 00:01: ioport range 0xb10-0xb1f has been reserved
[    0.494039] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.494115] system 00:07: ioport range 0x220-0x225 has been reserved
[    0.494194] system 00:07: ioport range 0x290-0x294 has been reserved
[    0.494278] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.494398] system 00:0c: iomem range 0xd2a00-0xd3fff has been reserved
[    0.494474] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[    0.494550] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.494625] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.494701] system 00:0c: iomem range 0xdbde0000-0xdbdfffff could not be reserved
[    0.494816] system 00:0c: iomem range 0xffff0000-0xffffffff could not be reserved
[    0.494932] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.495007] system 00:0c: iomem range 0x100000-0xdbddffff could not be reserved
[    0.495122] system 00:0c: iomem range 0xdbef0000-0xdfeeffff has been reserved
[    0.495198] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.495312] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.495427] system 00:0c: iomem range 0xfff80000-0xfffeffff could not be reserved
[    0.500725] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.500801] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[    0.500877] pci 0000:00:01.0:   MEM window: 0xfdd00000-0xfdefffff
[    0.500953] pci 0000:00:01.0:   PREFETCH window: 0x000000f8000000-0x000000fbffffff
[    0.501071] pci 0000:00:06.0: PCI bridge, secondary bus 0000:02
[    0.501146] pci 0000:00:06.0:   IO window: 0xd000-0xdfff
[    0.501222] pci 0000:00:06.0:   MEM window: 0xfda00000-0xfdafffff
[    0.501298] pci 0000:00:06.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.501413] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
[    0.501489] pci 0000:00:14.4:   IO window: 0xc000-0xcfff
[    0.501567] pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
[    0.501644] pci 0000:00:14.4:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.501771] pci 0000:00:06.0: setting latency timer to 64
[    0.501779] bus: 00 index 0 io port: [0, ffff]
[    0.501853] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.501928] bus: 01 index 0 io port: [e000, efff]
[    0.502002] bus: 01 index 1 mmio: [fdd00000, fdefffff]
[    0.502076] bus: 01 index 2 mmio: [f8000000, fbffffff]
[    0.502150] bus: 01 index 3 mmio: [0, 0]
[    0.502224] bus: 02 index 0 io port: [d000, dfff]
[    0.502298] bus: 02 index 1 mmio: [fda00000, fdafffff]
[    0.502372] bus: 02 index 2 mmio: [fdf00000, fdffffff]
[    0.502446] bus: 02 index 3 mmio: [0, 0]
[    0.502524] bus: 03 index 0 io port: [c000, cfff]
[    0.502599] bus: 03 index 1 mmio: [fdc00000, fdcfffff]
[    0.502673] bus: 03 index 2 mmio: [fdb00000, fdbfffff]
[    0.502748] bus: 03 index 3 io port: [0, ffff]
[    0.502822] bus: 03 index 4 mmio: [0, ffffffffffffffff]
[    0.502932] NET: Registered protocol family 2
[    0.600050] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.600961] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.603237] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.603891] TCP: Hash tables configured (established 262144 bind 65536)
[    0.603969] TCP reno registered
[    0.630087] NET: Registered protocol family 1
[    0.631558] audit: initializing netlink socket (disabled)
[    0.631643] type=2000 audit(1226244422.630:1): initialized
[    0.632005] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.632198] VFS: Disk quotas dquot_6.5.1
[    0.632289] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.632455] msgmni has been set to 7397
[    0.632553] async_tx: api initialized (sync-only)
[    0.632629] io scheduler noop registered
[    0.632702] io scheduler anticipatory registered
[    0.632776] io scheduler deadline registered
[    0.632862] io scheduler cfq registered (default)
[    0.780034] pci 0000:01:05.0: Boot video device
[    0.780181] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    0.780200] pcieport-driver 0000:00:06.0: found MSI capability
[    0.780298] pci_express 0000:00:06.0:pcie00: allocate port service
[    0.780348] pci_express 0000:00:06.0:pcie03: allocate port service
[    0.780605] input: Power Button (FF) as /class/input/input0
[    0.780681] ACPI: Power Button (FF) [PWRF]
[    0.780849] input: Power Button (CM) as /class/input/input1
[    0.780924] ACPI: Power Button (CM) [PWRB]
[    0.871084] Real Time Clock Driver v1.12ac
[    0.871325] hpet_resources: 0xfed00000 is busy
[    0.871449] Non-volatile memory driver v1.2
[    0.871523] Linux agpgart interface v0.103
[    0.871597] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.871712] Hangcheck: Using get_cycles().
[    0.871789] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.150130] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.151081] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.151434] Driver 'sd' needs updating - please use bus_type methods
[    1.151556] ahci 0000:00:11.0: version 3.0
[    1.151578] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.151842] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.151958] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
[    1.152656] scsi0 : ahci
[    1.152874] scsi1 : ahci
[    1.153031] scsi2 : ahci
[    1.153186] scsi3 : ahci
[    1.153342] scsi4 : ahci
[    1.153499] scsi5 : ahci
[    1.153634] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 318
[    1.153750] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 318
[    1.153866] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 318
[    1.153981] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 318
[    1.154097] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 318
[    1.154212] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 318
[    1.682512] ata1: softreset failed (device not ready)
[    1.682593] ata1: failed due to HW bug, retry pmp=0
[    1.862521] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.868882] ata1.00: HPA detected: current 1953523055, native 1953525168
[    1.868961] ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01113, max UDMA7
[    1.869037] ata1.00: 1953523055 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.875463] ata1.00: configured for UDMA/133
[    2.242526] ata2: SATA link down (SStatus 0 SControl 300)
[    2.792511] ata3: softreset failed (device not ready)
[    2.792587] ata3: failed due to HW bug, retry pmp=0
[    2.972520] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.978923] ata3.00: HPA detected: current 1953523055, native 1953525168
[    2.979000] ata3.00: ATA-7: SAMSUNG HD103UJ, 1AA01113, max UDMA7
[    2.979075] ata3.00: 1953523055 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.985551] ata3.00: configured for UDMA/133
[    3.352525] ata4: SATA link down (SStatus 0 SControl 300)
[    3.722525] ata5: SATA link down (SStatus 0 SControl 300)
[    4.092525] ata6: SATA link down (SStatus 0 SControl 300)
[    4.112606] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    4.112875] sd 0:0:0:0: [sda] 1953523055 512-byte hardware sectors (1000204 MB)
[    4.113001] sd 0:0:0:0: [sda] Write Protect is off
[    4.113076] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.113098] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.113261] sd 0:0:0:0: [sda] 1953523055 512-byte hardware sectors (1000204 MB)
[    4.113385] sd 0:0:0:0: [sda] Write Protect is off
[    4.113460] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.113480] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.113596]  sda: sda1 sda2 sda3 sda4
[    4.124313] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.124528] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    4.124787] sd 2:0:0:0: [sdb] 1953523055 512-byte hardware sectors (1000204 MB)
[    4.124915] sd 2:0:0:0: [sdb] Write Protect is off
[    4.124992] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.125014] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.125176] sd 2:0:0:0: [sdb] 1953523055 512-byte hardware sectors (1000204 MB)
[    4.125302] sd 2:0:0:0: [sdb] Write Protect is off
[    4.125379] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.125398] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.125516]  sdb: sdb1 sdb2 sdb3 sdb4
[    4.129368] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.129649] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    4.129725] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    4.129972] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.130184] mice: PS/2 mouse device common for all mice
[    4.219707] input: AT Translated Set 2 keyboard as /class/input/input2
[    4.292615] md: raid1 personality registered for level 1
[    4.292690] md: raid10 personality registered for level 10
[    4.460014] raid6: int64x1   1717 MB/s
[    4.630006] raid6: int64x2   2319 MB/s
[    4.800017] raid6: int64x4   2172 MB/s
[    4.970004] raid6: int64x8   1878 MB/s
[    5.140001] raid6: sse2x1    2656 MB/s
[    5.310012] raid6: sse2x2    3526 MB/s
[    5.480003] raid6: sse2x4    3664 MB/s
[    5.480077] raid6: using algorithm sse2x4 (3664 MB/s)
[    5.480152] md: raid6 personality registered for level 6
[    5.480226] md: raid5 personality registered for level 5
[    5.483152] md: raid4 personality registered for level 4
[    5.483354] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    5.483535] TCP cubic registered
[    5.483609] Initializing XFRM netlink socket
[    5.483690] NET: Registered protocol family 17
[    5.483795] powernow-k8: Found 1 AMD Athlon(tm) X2 Dual Core Processor BE-2300 processors (2 cpu cores) (version 2.20.00)
[    5.483919] powernow-k8: ACPI Processor support is required for SMP systems but is absent. Please load the ACPI
Processor module before starting this driver.
[    5.484054] powernow-k8: ACPI Processor support is required for SMP systems but is absent. Please load the ACPI
Processor module before starting this driver.
[    5.484385] registered taskstats version 1
[    5.484779] md: Autodetecting RAID arrays.
[    5.500911] md: Scanned 2 and added 2 devices.
[    5.500985] md: autorun ...
[    5.501059] md: considering sdb1 ...
[    5.501138] md:  adding sdb1 ...
[    5.501215] md:  adding sda1 ...
[    5.501289] md: created md0
[    5.501363] md: bind<sda1>
[    5.501444] md: bind<sdb1>
[    5.501524] md: running: <sdb1><sda1>
[    5.501853] raid1: raid set md0 active with 2 out of 2 mirrors
[    5.501979] md: ... autorun DONE.
[    5.514774] kjournald starting.  Commit interval 5 seconds
[    5.514855] EXT3-fs: mounted filesystem with ordered data mode.
[    5.514936] VFS: Mounted root (ext3 filesystem) readonly.
[    5.515025] Freeing unused kernel memory: 268k freed
[    5.515215] Write protecting the kernel read-only data: 3436k
[    6.601962] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.602068] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.602158] r8169 0000:02:00.0: setting latency timer to 64
[    6.602383] eth0: RTL8168c/8111c at 0xffffc20000018000, 00:1f:d0:53:66:c4, XID 3c2000c0 IRQ 317
[    6.618466] parport_pc 00:09: reported by Plug and Play ACPI
[    6.618599] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.693110] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.693434] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    6.706708] processor ACPI0007:00: registered as cooling_device0
[    6.706828] processor ACPI0007:01: registered as cooling_device1
[    6.724161] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.724257] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    6.724385] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    6.724551] ehci_hcd 0000:00:12.2: debug port 1
[    6.724650] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    6.740062] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.740340] usb usb1: configuration #1 chosen from 1 choice
[    6.740445] hub 1-0:1.0: USB hub found
[    6.740528] hub 1-0:1.0: 6 ports detected
[    6.749810] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.777002] ppdev: user-space parallel port driver
[    6.960309] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.960400] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    6.960499] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    6.960657] ehci_hcd 0000:00:13.2: debug port 1
[    6.960754] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    7.040014] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.040279] usb usb2: configuration #1 chosen from 1 choice
[    7.040384] hub 2-0:1.0: USB hub found
[    7.040466] hub 2-0:1.0: 6 ports detected
[    7.150207] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.150300] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    7.150417] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    7.150574] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    7.216650] usb usb3: configuration #1 chosen from 1 choice
[    7.216757] hub 3-0:1.0: USB hub found
[    7.216841] hub 3-0:1.0: 3 ports detected
[    7.322761] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.322853] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    7.322953] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    7.323092] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    7.386700] usb usb4: configuration #1 chosen from 1 choice
[    7.386817] hub 4-0:1.0: USB hub found
[    7.386902] hub 4-0:1.0: 3 ports detected
[    7.602780] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.602874] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    7.602984] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    7.603136] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    7.666670] usb usb5: configuration #1 chosen from 1 choice
[    7.666778] hub 5-0:1.0: USB hub found
[    7.666863] hub 5-0:1.0: 3 ports detected
[    7.772695] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.772784] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    7.772882] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    7.773019] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    7.836651] usb usb6: configuration #1 chosen from 1 choice
[    7.836762] hub 6-0:1.0: USB hub found
[    7.836846] hub 6-0:1.0: 3 ports detected
[    7.902513] usb 4-1: new low speed USB device using ohci_hcd and address 2
[    7.943745] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.943845] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    7.943967] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    7.944109] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    8.006678] usb usb7: configuration #1 chosen from 1 choice
[    8.006793] hub 7-0:1.0: USB hub found
[    8.006877] hub 7-0:1.0: 2 ports detected
[    8.086867] usb 4-1: configuration #1 chosen from 1 choice
[    8.350077] EXT3 FS on md0, internal journal
[    8.542056] it87: Found IT8718F chip at 0x228, revision 5
[    8.542143] it87: in3 is VCC (+5V)
[    8.562188] usbcore: registered new interface driver usbserial
[    8.562281] usbserial: USB Serial support registered for generic
[    8.562475] usbcore: registered new interface driver usbserial_generic
[    8.562553] usbserial: USB Serial Driver core
[    8.580004] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    8.580135] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    8.580261] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    8.580395] cypress 4-1:1.0: HID->COM RS232 Adapter converter detected
[    8.581889] usb 4-1: HID->COM RS232 Adapter converter now attached to ttyUSB0
[    8.581985] usbcore: registered new interface driver cypress
[    8.582061] cypress_m8: Cypress USB to Serial Driver v1.09
[    8.603590] md: md1 stopped.
[    8.661705] md: bind<sdb2>
[    8.661923] md: bind<sda2>
[    8.668856] raid5: device sda2 operational as raid disk 0
[    8.668931] raid5: device sdb2 operational as raid disk 1
[    8.669450] raid5: allocated 3218kB for md1
[    8.669526] raid5: raid level 5 set md1 active with 2 out of 3 devices, algorithm 2
[    8.669642] RAID5 conf printout:
[    8.669716]  --- rd:3 wd:2
[    8.669790]  disk 0, o:1, dev:sda2
[    8.669864]  disk 1, o:1, dev:sdb2
[    8.670568] md: md2 stopped.
[    8.718563] md: bind<sdb3>
[    8.718793] md: bind<sda3>
[    8.725965] raid10: raid set md2 active with 2 out of 3 devices
[    8.738709] md: md3 stopped.
[    8.772635] md: bind<sdb4>
[    8.782628] md: bind<sda4>
[    8.789594] raid5: device sda4 operational as raid disk 0
[    8.789669] raid5: device sdb4 operational as raid disk 1
[    8.790157] raid5: allocated 3218kB for md3
[    8.790232] raid5: raid level 5 set md3 active with 2 out of 3 devices, algorithm 2
[    8.790346] RAID5 conf printout:
[    8.790420]  --- rd:3 wd:2
[    8.790493]  disk 0, o:1, dev:sda4
[    8.790567]  disk 1, o:1, dev:sdb4
[    9.424724] kjournald starting.  Commit interval 300 seconds
[    9.424746] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    9.442815] EXT3 FS on dm-5, internal journal
[    9.442928] EXT3-fs: mounted filesystem with ordered data mode.
[    9.505202] kjournald starting.  Commit interval 300 seconds
[    9.532774] EXT3 FS on dm-6, internal journal
[    9.532885] EXT3-fs: mounted filesystem with ordered data mode.
[    9.563486] kjournald starting.  Commit interval 300 seconds
[    9.578137] EXT3 FS on dm-0, internal journal
[    9.578247] EXT3-fs: mounted filesystem with ordered data mode.
[    9.596801] kjournald starting.  Commit interval 300 seconds
[    9.598381] EXT3 FS on dm-1, internal journal
[    9.598492] EXT3-fs: mounted filesystem with ordered data mode.
[    9.610668] kjournald starting.  Commit interval 300 seconds
[    9.610810] EXT3 FS on dm-4, internal journal
[    9.610921] EXT3-fs: mounted filesystem with ordered data mode.
[    9.701946] kjournald starting.  Commit interval 300 seconds
[    9.701947] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    9.721344] EXT3 FS on dm-8, internal journal
[    9.721456] EXT3-fs: mounted filesystem with ordered data mode.
[   10.010326] Adding 1048568k swap on /dev/mapper/storage10-swap.  Priority:-1 extents:1 across:1048568k
[   17.363353] r8169: eth0: link up
[   17.363442] r8169: eth0: link up
[   23.839883] RPC: Registered udp transport module.
[   23.839963] RPC: Registered tcp transport module.
[   24.770802] NET: Registered protocol family 10
[   24.771482] lo: Disabled Privacy Extensions
[   34.962510] eth0: no IPv6 routers present
[  141.370364] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  141.407514] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  141.425114] NFSD: starting 90-second grace period
=================================================
# $ cat .config | grep -v '^#'
CONFIG_64BIT=y
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLOCK_COMPAT=y

CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y

CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
CONFIG_MK8=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=2
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

CONFIG_PM=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=y


CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y

CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_DEFAULT_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m

CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
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
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

CONFIG_IP_DCCP_CCID2=m
CONFIG_IP_DCCP_CCID3=m
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

CONFIG_IP_SCTP=m
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_LLC=m
CONFIG_NET_SCHED=y

CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

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
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

CONFIG_FIB_RULES=y

CONFIG_IEEE80211=m
CONFIG_IEEE80211_CRYPT_WEP=m


CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y

CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_ATA_OVER_ETH=m
CONFIG_MISC_DEVICES=y
CONFIG_HAVE_IDE=y

CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_WAIT_SCAN=m

CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ATA=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m


CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_TUN=m
CONFIG_PHYLIB=m

CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_EEPRO100=m
CONFIG_E100=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_NETDEV_1000=y
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SKY2=m
CONFIG_NETDEV_10000=y


CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_SLHC=m
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y

CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y

CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_UINPUT=m

CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m

CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y

CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y







CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THERMAL=m
CONFIG_WATCHDOG=y

CONFIG_SOFT_WATCHDOG=m



CONFIG_SSB_POSSIBLE=y



CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_MEDIA=m

CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_DAB=y

CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m


CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MPU401=m
CONFIG_SND_PCI=y
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_INTEL8X0=m
CONFIG_SND_USB=y
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y

CONFIG_USB_HID=m
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_USB_HIDDEV=y

CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y

CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y

CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m

CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m


CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y

CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m

CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_LD=m

CONFIG_EDD=m
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y

CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m

CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=866
CONFIG_FAT_DEFAULT_IOCHARSET="koi8-r"

CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

CONFIG_CRAMFS=m
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
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_CIFS=m
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y

CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="koi8-r"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_RODATA=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0

CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_AUTHENC=m


CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_ECB=m

CONFIG_CRYPTO_HMAC=y

CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m

CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_HW=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y

CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
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
=================================================



I'm wondering if it's supposed to work this way? More data/tests needed?

-- 
Please CC me, I'm not at the list.
Thanks,
Vitaly
