Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbXFURmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbXFURmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXFURmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:42:39 -0400
Received: from arx.rabbit.us ([68.251.127.6]:4866 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbXFURmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:42:38 -0400
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 13:42:37 EDT
Message-ID: <467AB4CF.7030904@rabbit.us>
Date: Thu, 21 Jun 2007 19:26:39 +0200
From: Peter Rabbitson <rabbit@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Terrible IO performance when using 4GB of RAM on a 32 bit machine
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I hope this question is not too basic for the intended audience. I have 
a server with an Intel SE7210TP1-E motherboard[1] and a single 3.4GHz P4 
CPU[2]. I am currently running a vanilla 2.6.21.5 kernel with SMP/HT. 
Two patches are applied: one is a SATA driver[3] and the other is a 
stable kernel bugfix[4]. When I upgraded my memory to 4GB I experienced 
abysmal performance at the IO layer across all block devices. CPU and 
network performance seem to be unaffected. Booting the system with 
mem=3900M fixes the issue, but I wanted to get to the root of it.

I have a 4 drive raid array with LVM on top, which after tuning 
consistently delivers 210MB/s sequential read performance. If I omit the 
mem option and let the kernel autodetect all 4GB of memory, performance 
drops to about 4MB/s. A drop to 1MB/s is also observed on direct disk 
access (dd if=/dev/sdX). Two of the disks are connected the the on-board 
SATA ports and two to a Highpoint RocketRaid 1820A Card. A backup hard 
drive connected to the on-board IDE is suffering the same problems, so 
it should be something more fundamental.

What I have tried so far in various combinations:

o a kernel without SMP/HT support
o a kernel with HIGHPTE=y
o different timer frequencies (100, 1000)
o older kernel version (2.6.18)

I have captured dmesg output without mem[5], with mem=3900M[6] and 
mem=2048M[7].

Overall the system did not exhibit any problems in the last 2 years it 
operated, and it seems to be running fine with mem=3900M, which is in 
effect for about a month now. I would appreciate any suggestions on how 
to troubleshoot this further, or requests for additional information 
about the system.

TIA

Peter

[1] 
http://download.intel.com/support/motherboards/server/se7210tp1-e/sb/tpsse7210tp1e20.pdf
[2] http://rabbit.us/pool/4g/cpuinfo.txt
[3] 
http://www.highpoint-tech.com/BIOS_Driver/rr1820a/Linux/rr18xx-opensource-v1.17-0123.tgz
[4] http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08186.html
[5] http://rabbit.us/pool/4g/dmesg_nomem.txt
[6] http://rabbit.us/pool/4g/dmesg_3900.txt
[7] http://rabbit.us/pool/4g/dmesg_2048.txt

Follows a diff of [6] and [5]:

--- dmesg_3900.txt      2007-06-21 19:04:33.000000000 +0200
+++ dmesg_nomem.txt     2007-06-21 19:04:36.000000000 +0200
@@ -20,41 +20,24 @@
   BIOS-e820: 00000000fbeff000 - 00000000fbf00000 (ACPI NVS)
   BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
   BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
- limit_regions start: 0000000000000000 - 000000000009dc00 (usable)
- limit_regions start: 000000000009dc00 - 00000000000a0000 (reserved)
- limit_regions start: 00000000000e4000 - 0000000000100000 (reserved)
- limit_regions start: 0000000000100000 - 00000000fbef0000 (usable)
- limit_regions start: 00000000fbef0000 - 00000000fbeff000 (ACPI data)
- limit_regions start: 00000000fbeff000 - 00000000fbf00000 (ACPI NVS)
- limit_regions start: 00000000fee00000 - 00000000fee01000 (reserved)
- limit_regions start: 00000000ffb00000 - 0000000100000000 (reserved)
- limit_regions endfor: 0000000000000000 - 000000000009dc00 (usable)
- limit_regions endfor: 000000000009dc00 - 00000000000a0000 (reserved)
- limit_regions endfor: 00000000000e4000 - 0000000000100000 (reserved)
- limit_regions endfor: 0000000000100000 - 00000000f3c00000 (usable)
-user-defined physical RAM map:
- user: 0000000000000000 - 000000000009dc00 (usable)
- user: 000000000009dc00 - 00000000000a0000 (reserved)
- user: 00000000000e4000 - 0000000000100000 (reserved)
- user: 0000000000100000 - 00000000f3c00000 (usable)
-3004MB HIGHMEM available.
+3134MB HIGHMEM available.
  896MB LOWMEM available.
  found SMP MP-table at 000ff780
-Entering add_active_range(0, 0, 998400) 0 entries of 256 used
+Entering add_active_range(0, 0, 1031920) 0 entries of 256 used
  Zone PFN ranges:
    DMA             0 ->     4096
    Normal       4096 ->   229376
-  HighMem    229376 ->   998400
+  HighMem    229376 ->  1031920
  early_node_map[1] active PFN ranges
-    0:        0 ->   998400
-On node 0 totalpages: 998400
+    0:        0 ->  1031920
+On node 0 totalpages: 1031920
    DMA zone: 32 pages used for memmap
    DMA zone: 0 pages reserved
    DMA zone: 4064 pages, LIFO batch:0
    Normal zone: 1760 pages used for memmap
    Normal zone: 223520 pages, LIFO batch:31
-  HighMem zone: 6008 pages used for memmap
-  HighMem zone: 763016 pages, LIFO batch:31
+  HighMem zone: 6269 pages used for memmap
+  HighMem zone: 796275 pages, LIFO batch:31
  DMI 2.3 present.
  ACPI: RSDP 000F87E0, 0014 (r0 ACPIAM)
  ACPI: RSDT FBEF0000, 0030 (r1 A M I  OEMRSDT   7000529 MSFT       97)
@@ -83,9 +66,9 @@
  ACPI: IRQ10 used by override.
  Enabling APIC mode:  Flat.  Using 2 I/O APICs
  Using ACPI (MADT) for SMP configuration information
-Allocating PCI resources starting at f4000000 (gap: f3c00000:0c400000)
-Built 1 zonelists.  Total pages: 990600
-Kernel command line: root=/dev/md0 ro vga=307 mem=3900M
+Allocating PCI resources starting at fc000000 (gap: fbf00000:02f00000)
+Built 1 zonelists.  Total pages: 1023859
+Kernel command line: root=/dev/md0 ro vga=307
  mapped APIC to ffffd000 (fee00000)
  mapped IOAPIC to ffffc000 (fec00000)
  mapped IOAPIC to ffffb000 (fec10000)
@@ -93,11 +76,11 @@
  Enabling unmasked SIMD FPU exception support... done.
  Initializing CPU#0
  PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 3391.614 MHz processor.
+Detected 3391.760 MHz processor.
  Console: colour VGA+ 132x44
  Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
  Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 3955644k/3993600k available (2894k kernel code, 36912k 
reserved, 930k data, 252k init, 3076096k highmem)
+Memory: 4088536k/4127680k available (2894k kernel code, 37968k 
reserved, 930k data, 252k init, 3210176k highmem)
  virtual kernel memory layout:
      fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
      pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
@@ -107,7 +90,7 @@
        .data : 0xc03d3a6f - 0xc04bc34c   ( 930 kB)
        .text : 0xc0100000 - 0xc03d3a6f   (2894 kB)
  Checking if this processor honours the WP bit even in supervisor 
mode... Ok.
-Calibrating delay using timer specific routine.. 6785.46 BogoMIPS 
(lpj=3392734)
+Calibrating delay using timer specific routine.. 6785.48 BogoMIPS 
(lpj=3392744)
  Mount-cache hash table entries: 512
  CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 
0000441d 00000000 00000000
  monitor/mwait feature present.
@@ -126,7 +109,7 @@
  CPU0: Intel(R) Pentium(R) 4 CPU 3.40GHz stepping 04
  Booting processor 1/1 eip 2000
  Initializing CPU#1
-Calibrating delay using timer specific routine.. 6782.08 BogoMIPS 
(lpj=3391040)
+Calibrating delay using timer specific routine.. 6782.06 BogoMIPS 
(lpj=3391032)
  CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 
0000441d 00000000 00000000
  monitor/mwait feature present.
  CPU: Trace cache: 12K uops, L1 D cache: 16K
@@ -138,12 +121,14 @@
  CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
  CPU1: Thermal monitoring enabled
  CPU1: Intel(R) Pentium(R) 4 CPU 3.40GHz stepping 04
-Total of 2 processors activated (13567.54 BogoMIPS).
+Total of 2 processors activated (13567.55 BogoMIPS).
  ENABLING IO-APIC IRQs
  ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
+APIC calibration not consistent with PM Timer: 118ms instead of 100ms
+APIC delta adjusted to PM-Timer: 1246875 (1483551)
  checking TSC synchronization [CPU#0 -> CPU#1]: passed.
  Brought up 2 CPUs
-migration_cost=13
+migration_cost=312
  NET: Registered protocol family 16
  ACPI: bus type pci registered
  PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=3
@@ -180,13 +165,13 @@
  PCI: Using ACPI for IRQ routing
  PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post 
a report
  pnp: 00:0a: ioport range 0x680-0x6ff has been reserved
-Time: tsc clocksource has been installed.
  pnp: 00:0a: ioport range 0x295-0x296 has been reserved
  pnp: 00:0b: iomem range 0xfec10000-0xfec1ffff has been reserved
  pnp: 00:0b: iomem range 0xfed20000-0xfed8ffff has been reserved
-pnp: 00:0b: iomem range 0xffb00000-0xffbfffff has been reserved
+pnp: 00:0b: iomem range 0xffb00000-0xffbfffff could not be reserved
  pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
-pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
+pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
+Time: tsc clocksource has been installed.
  pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
  pnp: 00:0d: iomem range 0xc0000-0xdffff could not be reserved
  pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
@@ -202,7 +187,7 @@
  PCI: Bridge: 0000:00:1e.0
    IO window: c000-cfff
    MEM window: fc600000-fe6fffff
-  PREFETCH window: f4000000-f40fffff
+  PREFETCH window: fc000000-fc0fffff
  PCI: Setting latency timer of device 0000:00:1e.0 to 64
  NET: Registered protocol family 2
  IP route cache hash table entries: 32768 (order: 5, 131072 bytes)

