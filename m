Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYIDIAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYIDIAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYIDIAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:00:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYIDIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:00:40 -0400
Date: Thu, 4 Sep 2008 01:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080904010029.6f21fd58.akpm@linux-foundation.org>
In-Reply-To: <86802c440809040014w5a6d2921k8c99b3978772e1fb@mail.gmail.com>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
	<20080903223318.84b6ce8b.akpm@linux-foundation.org>
	<86802c440809040014w5a6d2921k8c99b3978772e1fb@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 00:14:18 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> wonder if some pci code change cause that.... doesn't get pref mem assigned.
> 
> can you apply attached patches to get more dump?

Your fourth patch produces a great storm of printk warnings and the
machine immediately locks up.  Setting CONFIG_RESOURCES_64BIT=y fixes
this.

How many of these damn printk warnings do I have to fix?  They're not
just cosmetic!  They are real bugs which can cause callees to read
incoming arguments from incorrect stack offsets.  Sigh.

dmesg for mainline:
http://userweb.kernel.org/~akpm/dmesg-sony-without.txt

dmesg with the four patches applied:
http://userweb.kernel.org/~akpm/dmesg-sony-with.txt

roughly edited diff:

--- dmesg-sony-without.txt	2008-09-04 00:57:16.000000000 -0700
+++ dmesg-sony-with.txt	2008-09-04 00:50:06.000000000 -0700
@@ -1,4 +1,4 @@
-Linux version 2.6.27-rc5 (akpm@y.localdomain) (gcc version 4.1.0) #11 PREEMPT Thu Sep 4 00:52:48 PDT 2008
+Linux version 2.6.27-rc5 (akpm@y.localdomain) (gcc version 4.1.0) #10 PREEMPT Thu Sep 4 00:45:32 PDT 2008
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
@@ -13,9 +13,14 @@
  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 console [earlyvga0] enabled
 debug: ignoring loglevel setting.
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (Video ROM) [c0000, c7fff] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (System ROM) [f0000, fffff] conflict 0
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel code) [100000, 327f7a]
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel data) [327f7b, 467f9f]
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel bss) [4a3000, abfa93]
 last_pfn = 0x3f690 max_arch_pfn = 0x100000
 kernel direct mapping tables up to 38000000 @ 7000-c000
-RAMDISK: 37f0d000 - 37fef835
+RAMDISK: 37f0d000 - 37fef838
 DMI 2.3 present.
 ACPI: RSDP 000F6780, 0014 (r0 PTLTD )
 ACPI: RSDT 3F697449, 0048 (r1   Sony       V0 20051108 PTL         0)
@@ -39,7 +44,7 @@
 (7 early reservations) ==> bootmem [0000000000 - 0038000000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
   #1 [0000100000 - 0000abfa94]    TEXT DATA BSS ==> [0000100000 - 0000abfa94]
-  #2 [0037f0d000 - 0037fef835]          RAMDISK ==> [0037f0d000 - 0037fef835]
+  #2 [0037f0d000 - 0037fef838]          RAMDISK ==> [0037f0d000 - 0037fef838]
   #3 [0000ac0000 - 0000ac4000]    INIT_PG_TABLE ==> [0000ac0000 - 0000ac4000]
   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
   #5 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
@@ -53,7 +58,7 @@
     0: 0x00000000 -> 0x0000009f
     0: 0x00000100 -> 0x0003f690
 On node 0 totalpages: 259631
-free_area_init_node: node 0, pgdat c045ecc0, node_mem_map c1000000
+free_area_init_node: node 0, pgdat c045fcc0, node_mem_map c1000000
   DMA zone: 3967 pages, LIFO batch:0
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 30114 pages, LIFO batch:7
@@ -74,9 +79,32 @@
 Using ACPI (MADT) for SMP configuration information
 mapped APIC to ffffb000 (fee00000)
 mapped IOAPIC to ffffa000 (fec00000)
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (System RAM) [0, 9f7ff]
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (reserved) [9f800, 9ffff]
+  insert_resource: first: (System ROM) [f0000, fffff], new: (reserved) [d8000, fffff]
+  insert_resource: direct parent: (PCI mem) [0, ffffffffffffffff], new: (reserved) [d8000, fffff]
+    insert_resource: child: (System ROM) [f0000, fffff], new: (reserved) [d8000, fffff]
+  insert_resource: first: (Kernel code) [100000, 327f7a], new: (System RAM) [100000, 3f68ffff]
+  insert_resource: direct parent: (PCI mem) [0, ffffffffffffffff], new: (System RAM) [100000, 3f68ffff]
+    insert_resource: child: (Kernel code) [100000, 327f7a], new: (System RAM) [100000, 3f68ffff]
+    insert_resource: child: (Kernel data) [327f7b, 467f9f], new: (System RAM) [100000, 3f68ffff]
+    insert_resource: child: (Kernel bss) [4a3000, abfa93], new: (System RAM) [100000, 3f68ffff]
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (ACPI Tables) [3f690000, 3f69cfff]
+    insert_resource: good with request direct parent: (PCI mem) [0, ffffffffffffffff], new: (ACPI Non-volatile Storage) [3f69d000, 3f6fffff]
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
 PM: Registered nosave memory: 00000000000a0000 - 00000000000d8000
 PM: Registered nosave memory: 00000000000d8000 - 0000000000100000
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (Video RAM area) [a0000, bffff] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (dma1) [0, 1f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (pic1) [20, 21] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (timer0) [40, 43] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (timer1) [50, 53] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (keyboard) [60, 60] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (keyboard) [64, 64] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (dma page reg) [80, 8f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (pic2) [a0, a1] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (dma2) [c0, df] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (fpu) [f0, ff] conflict 0
 Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257601
 Kernel command line: ro root=LABEL=/ initcall_debug rhgb vga=0x263 netconsole=4444@192.168.2.10/eth0,5145@192.168.2.111/00:19:D1:04:8F:42 profile=1 earlyprintk=vga resume=8:5 lapic nmi_watchdog=2 ignore_loglevel
@@ -211,6 +239,7 @@
 calling  dmi_id_init+0x0/0x26b
 initcall dmi_id_init+0x0/0x26b returned 0 after 0 msecs
 calling  pci_arch_init+0x0/0x4a
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (PCI conf1) [cf8, cff]
 PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
 PCI: MCFG area at e0000000 reserved in E820
 PCI: Using MMCONFIG for extended config space
@@ -253,31 +282,63 @@
 initcall acpi_ec_init+0x0/0x55 returned 0 after 0 msecs
 calling  acpi_pci_root_init+0x0/0x25
 ACPI: PCI Root Bridge [PCI0] (0000:00)
+PCI: 0000:00:02.0 reg 10 32bit mmio: [b0080000, b00fffff]
+PCI: 0000:00:02.0 reg 14 io port: [1800, 1807]
+PCI: 0000:00:02.0 reg 18 32bit mmio: [c0000000, cfffffff]
+PCI: 0000:00:02.0 reg 1c 32bit mmio: [b0040000, b007ffff]
+PCI: 0000:00:02.1 reg 10 32bit mmio: [0, 7ffff]
+PCI: 0000:00:1b.0 reg 10 64bit mmio: [b0000000, b0003fff]
 pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
 pci 0000:00:1b.0: PME# disabled
+PCI: 0000:00:1d.0 reg 20 io port: [1820, 183f]
+PCI: 0000:00:1d.1 reg 20 io port: [1840, 185f]
+PCI: 0000:00:1d.2 reg 20 io port: [1860, 187f]
+PCI: 0000:00:1d.3 reg 20 io port: [1880, 189f]
+PCI: 0000:00:1d.7 reg 10 32bit mmio: [b0004000, b00043ff]
 pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
 pci 0000:00:1d.7: PME# disabled
 pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
+    insert_resource: good with request direct parent: (PCI IO) [0, ffff], new: (0000:00:1f.0) [1000, 107f]
 pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
+    insert_resource: good with request direct parent: (PCI IO) [0, ffff], new: (0000:00:1f.0) [1180, 11bf]
 pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
+PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
+PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
+PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
+PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
+PCI: 0000:00:1f.1 reg 20 io port: [1810, 181f]
+PCI: 0000:00:1f.2 reg 10 io port: [18c8, 18cf]
+PCI: 0000:00:1f.2 reg 14 io port: [18c0, 18c3]
+PCI: 0000:00:1f.2 reg 18 io port: [18a8, 18af]
+PCI: 0000:00:1f.2 reg 1c io port: [180c, 180f]
+PCI: 0000:00:1f.2 reg 20 io port: [18b0, 18bf]
+PCI: 0000:00:1f.2 reg 24 32bit mmio: [b0004400, b00047ff]
 pci 0000:00:1f.2: PME# supported from D3hot
 pci 0000:00:1f.2: PME# disabled
+PCI: 0000:00:1f.3 reg 20 io port: [18e0, 18ff]
+PCI: 0000:06:05.0 reg 10 32bit mmio: [0, fff]
 pci 0000:06:05.0: supports D1
 pci 0000:06:05.0: supports D2
 pci 0000:06:05.0: PME# supported from D0 D1 D2 D3hot
 pci 0000:06:05.0: PME# disabled
+PCI: 0000:06:05.2 reg 10 32bit mmio: [b0104000, b01047ff]
+PCI: 0000:06:05.2 reg 14 32bit mmio: [b0100000, b0103fff]
 pci 0000:06:05.2: supports D1
 pci 0000:06:05.2: supports D2
 pci 0000:06:05.2: PME# supported from D0 D1 D2 D3hot
 pci 0000:06:05.2: PME# disabled
+PCI: 0000:06:05.3 reg 10 32bit mmio: [b0105000, b0105fff]
 pci 0000:06:05.3: supports D1
 pci 0000:06:05.3: supports D2
 pci 0000:06:05.3: PME# supported from D0 D1 D2 D3hot
 pci 0000:06:05.3: PME# disabled
+PCI: 0000:06:08.0 reg 10 32bit mmio: [b0106000, b0106fff]
+PCI: 0000:06:08.0 reg 14 io port: [2000, 203f]
 pci 0000:06:08.0: supports D1
 pci 0000:06:08.0: supports D2
 pci 0000:06:08.0: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:06:08.0: PME# disabled
+PCI: 0000:06:0b.0 reg 10 32bit mmio: [b0107000, b0107fff]
 pci 0000:06:0b.0: PME# supported from D0 D3hot D3cold
 pci 0000:06:0b.0: PME# disabled
 pci 0000:00:1e.0: transparent bridge
@@ -337,6 +398,41 @@
 initcall thermal_init+0x0/0x46 returned 0 after 0 msecs
 calling  pci_subsys_init+0x0/0xe4
 PCI: Using ACPI for IRQ routing
+request_resource: root: (PCI IO) [0, ffff], new: (PCI Bus 0000:06) [2000, 2fff] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus 0000:06) [b0100000, b01fffff] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (0000:00:02.0) [b0080000, b00fffff] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:02.0) [1800, 1807] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (0000:00:02.0) [c0000000, cfffffff] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (0000:00:02.0) [b0040000, b007ffff] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (0000:00:1b.0) [b0000000, b0003fff] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1d.0) [1820, 183f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1d.1) [1840, 185f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1d.2) [1860, 187f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1d.3) [1880, 189f] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (0000:00:1d.7) [b0004000, b00043ff] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.1) [1f0, 1f7] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.1) [3f6, 3f6] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.1) [170, 177] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.1) [376, 376] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.1) [1810, 181f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.2) [18c8, 18cf] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.2) [18c0, 18c3] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.2) [18a8, 18af] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.2) [180c, 180f] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.2) [18b0, 18bf] conflict 0
+request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (0000:00:1f.2) [b0004400, b00047ff] conflict 0
+request_resource: root: (PCI IO) [0, ffff], new: (0000:00:1f.3) [18e0, 18ff] conflict 0
+request_resource: root: (PCI Bus 0000:06) [b0100000, b01fffff], new: (0000:06:05.2) [b0104000, b01047ff] conflict 0
+request_resource: root: (PCI Bus 0000:06) [b0100000, b01fffff], new: (0000:06:05.2) [b0100000, b0103fff] conflict 0
+request_resource: root: (PCI Bus 0000:06) [b0100000, b01fffff], new: (0000:06:05.3) [b0105000, b0105fff] conflict 0
+request_resource: root: (PCI Bus 0000:06) [b0100000, b01fffff], new: (0000:06:08.0) [b0106000, b0106fff] conflict 0
+request_resource: root: (PCI Bus 0000:06) [2000, 2fff], new: (0000:06:08.0) [2000, 203f] conflict 0
+request_resource: root: (PCI Bus 0000:06) [b0100000, b01fffff], new: (0000:06:0b.0) [b0107000, b0107fff] conflict 0
+    __reserve_region_with_split: good with request direct parent: (PCI mem) [0, ffffffffffffffff], res: (reserved) [3f700000, 3fffffff]
+    __reserve_region_with_split: good with request direct parent: (PCI mem) [0, ffffffffffffffff], res: (reserved) [e0000000, f0005fff]
+    __reserve_region_with_split: good with request direct parent: (PCI mem) [0, ffffffffffffffff], res: (reserved) [f0008000, f000bfff]
+    __reserve_region_with_split: good with request direct parent: (PCI mem) [0, ffffffffffffffff], res: (reserved) [fed20000, fed8ffff]
+    __reserve_region_with_split: good with request direct parent: (PCI mem) [0, ffffffffffffffff], res: (reserved) [ff000000, ffffffff]
 initcall pci_subsys_init+0x0/0xe4 returned 0 after 0 msecs
 calling  proto_init+0x0/0x27
 initcall proto_init+0x0/0x27 returned 0 after 0 msecs
@@ -387,21 +483,41 @@
 calling  acpi_event_init+0x0/0x6f
 initcall acpi_event_init+0x0/0x6f returned 0 after 0 msecs
 calling  pnp_system_init+0x0/0xf
+  __request_region: conflict: (reserved) [e0000000, f0005fff], res: (pnp 00:01) [e0000000, efffffff]
+busy flag
 system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
+  __request_region: conflict: (reserved) [e0000000, f0005fff], res: (pnp 00:01) [f0000000, f0003fff]
+busy flag
 system 00:01: iomem range 0xf0000000-0xf0003fff could not be reserved
+  __request_region: conflict: (reserved) [e0000000, f0005fff], res: (pnp 00:01) [f0004000, f0004fff]
+busy flag
 system 00:01: iomem range 0xf0004000-0xf0004fff could not be reserved
+  __request_region: conflict: (reserved) [e0000000, f0005fff], res: (pnp 00:01) [f0005000, f0005fff]
+busy flag
 system 00:01: iomem range 0xf0005000-0xf0005fff could not be reserved
+  __request_region: conflict: (reserved) [f0008000, f000bfff], res: (pnp 00:01) [f0008000, f000bfff]
+busy flag
 system 00:01: iomem range 0xf0008000-0xf000bfff could not be reserved
+  __request_region: conflict: (reserved) [fed20000, fed8ffff], res: (pnp 00:01) [fed20000, fed8ffff]
+busy flag
 system 00:01: iomem range 0xfed20000-0xfed8ffff could not be reserved
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (pnp 00:05) [680, 68f]
 system 00:05: ioport range 0x680-0x68f has been reserved
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (pnp 00:05) [800, 80f]
 system 00:05: ioport range 0x800-0x80f has been reserved
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (pnp 00:05) [1000, 107f]
+    __request_region: good with request direct parent: (0000:00:1f.0) [1000, 107f], res: (pnp 00:05) [1000, 107f]
 system 00:05: ioport range 0x1000-0x107f has been reserved
+  __request_region: conflict: (0000:00:1f.0) [1180, 11bf], res: (pnp 00:05) [1180, 11bf]
+    __request_region: good with request direct parent: (0000:00:1f.0) [1180, 11bf], res: (pnp 00:05) [1180, 11bf]
 system 00:05: ioport range 0x1180-0x11bf has been reserved
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (pnp 00:05) [fe00, fe01]
 system 00:05: ioport range 0xfe00-0xfe01 has been reserved
+    __request_region: good with request direct parent: (PCI mem) [0, ffffffffffffffff], res: (pnp 00:05) [d000c000, d000ffff]
 system 00:05: iomem range 0xd000c000-0xd000ffff has been reserved
 initcall pnp_system_init+0x0/0xf returned 0 after 0 msecs
 calling  chr_dev_init+0x0/0x8b
-initcall chr_dev_init+0x0/0x8b returned 0 after 4 msecs
+initcall chr_dev_init+0x0/0x8b returned 0 after 0 msecs
 calling  firmware_class_init+0x0/0x61
 initcall firmware_class_init+0x0/0x61 returned 0 after 0 msecs
 calling  loopback_init+0x0/0xf
@@ -634,36 +750,57 @@
 calling  fb_console_init+0x0/0xf5
 initcall fb_console_init+0x0/0xf5 returned 0 after 0 msecs
 calling  vesafb_init+0x0/0x1f3
+  __request_region: conflict: (0000:00:02.0) [c0000000, cfffffff], res: (vesafb) [c0000000, c07affff]
+    __request_region: good with request direct parent: (0000:00:02.0) [c0000000, cfffffff], res: (vesafb) [c0000000, c07affff]
 vesafb: framebuffer at 0xc0000000, mapped to 0xf8880000, using 2000k, total 7872k
 vesafb: mode is 1280x800x8, linelength=1280, pages=6
 vesafb: scrolling: redraw
 vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (vesafb) [3c0, 3df]
 Console: switching to colour frame buffer device 160x50
 fb0: VESA VGA frame buffer device
 initcall vesafb_init+0x0/0x1f3 returned 0 after 23 msecs
 calling  acpi_reserve_resources+0x0/0xc8
-initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 0 msecs
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (ACPI PM1a_EVT_BLK) [1000, 1003]
+  __request_region: conflict: (pnp 00:05) [1000, 107f], res: (ACPI PM1a_EVT_BLK) [1000, 1003]
+    __request_region: good with request direct parent: (pnp 00:05) [1000, 107f], res: (ACPI PM1a_EVT_BLK) [1000, 1003]
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (ACPI PM1a_CNT_BLK) [1004, 1005]
+  __request_region: conflict: (pnp 00:05) [1000, 107f], res: (ACPI PM1a_CNT_BLK) [1004, 1005]
+    __request_region: good with request direct parent: (pnp 00:05) [1000, 107f], res: (ACPI PM1a_CNT_BLK) [1004, 1005]
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (ACPI PM_TMR) [1008, 100b]
+  __request_region: conflict: (pnp 00:05) [1000, 107f], res: (ACPI PM_TMR) [1008, 100b]
+    __request_region: good with request direct parent: (pnp 00:05) [1000, 107f], res: (ACPI PM_TMR) [1008, 100b]
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (ACPI PM2_CNT_BLK) [1020, 1020]
+  __request_region: conflict: (pnp 00:05) [1000, 107f], res: (ACPI PM2_CNT_BLK) [1020, 1020]
+    __request_region: good with request direct parent: (pnp 00:05) [1000, 107f], res: (ACPI PM2_CNT_BLK) [1020, 1020]
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (ACPI GPE0_BLK) [1028, 102f]
+  __request_region: conflict: (pnp 00:05) [1000, 107f], res: (ACPI GPE0_BLK) [1028, 102f]
+    __request_region: good with request direct parent: (pnp 00:05) [1000, 107f], res: (ACPI GPE0_BLK) [1028, 102f]
+initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 2 msecs
 calling  acpi_ac_init+0x0/0x3d
 ACPI: AC Adapter [ACAD] (on-line)
-initcall acpi_ac_init+0x0/0x3d returned 0 after 1 msecs
+initcall acpi_ac_init+0x0/0x3d returned 0 after 5 msecs
 calling  acpi_battery_init+0x0/0x3d
 ACPI: Battery Slot [BAT1] (battery present)
-initcall acpi_battery_init+0x0/0x3d returned 0 after 5 msecs
+initcall acpi_battery_init+0x0/0x3d returned 0 after 10 msecs
 calling  acpi_fan_init+0x0/0x51
 initcall acpi_fan_init+0x0/0x51 returned 0 after 0 msecs
 calling  irqrouter_init_sysfs+0x0/0x33
 initcall irqrouter_init_sysfs+0x0/0x33 returned 0 after 0 msecs
 calling  acpi_processor_init+0x0/0x79
+  __request_region: conflict: (0000:00:1f.0) [1000, 107f], res: (ACPI CPU throttle) [1010, 1015]
+  __request_region: conflict: (pnp 00:05) [1000, 107f], res: (ACPI CPU throttle) [1010, 1015]
+    __request_region: good with request direct parent: (pnp 00:05) [1000, 107f], res: (ACPI CPU throttle) [1010, 1015]
 ACPI: CPU0 (power states: C1[C1] C2[C2])
 processor ACPI0007:00: registered as cooling_device0
 ACPI: Processor [CPU0] (supports 8 throttling states)
-initcall acpi_processor_init+0x0/0x79 returned 0 after 1 msecs
...
 calling  serial8250_init+0x0/0x10c
 Serial: 8250/16550 driver4 ports, IRQ sharing enabled
-initcall serial8250_init+0x0/0x10c returned 0 after 4 msecs
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial) [3f8, 3ff]
+  __request_region: conflict: (0000:00:1f.1) [3f6, 3f6], res: (serial-rsa) [3f0, 3f7]
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial) [2f8, 2ff]
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial-rsa) [2f0, 2f7]
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial) [3e8, 3ef]
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial-rsa) [3e0, 3e7]
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial) [2e8, 2ef]
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (serial-rsa) [2e0, 2e7]
+initcall serial8250_init+0x0/0x10c returned 0 after 31 msecs
 calling  serial8250_pnp_init+0x0/0xf
 initcall serial8250_pnp_init+0x0/0xf returned 0 after 0 msecs
 calling  serial8250_pci_init+0x0/0x16
@@ -696,15 +842,22 @@
 input: Sony Vaio Keys as /class/input/input0
 input: Sony Vaio Jogdial as /class/input/input1
 sony-laptop: device allocated minor is 63
+    __request_region: good with request direct parent: (PCI IO) [0, ffff], res: (Sony Programable I/O Device) [1080, 109f]
 sony-laptop: Sony Notebook Control Driver v0.6.
-initcall sony_laptop_init+0x0/0x6d returned 0 after 21 msecs
+initcall sony_laptop_init+0x0/0x6d returned 0 after 27 msecs
 calling  e100_init_module+0x0/0x4d
 e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
 e100: Copyright(c) 1999-2006 Intel Corporation
 e100 0000:06:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
+  __request_region: conflict: (PCI Bus 0000:06) [b0100000, b01fffff], res: (e100) [b0106000, b0106fff]
+  __request_region: conflict: (0000:06:08.0) [b0106000, b0106fff], res: (e100) [b0106000, b0106fff]
+    __request_region: good with request direct parent: (0000:06:08.0) [b0106000, b0106fff], res: (e100) [b0106000, b0106fff]
+  __request_region: conflict: (PCI Bus 0000:06) [2000, 2fff], res: (e100) [2000, 203f]
+  __request_region: conflict: (0000:06:08.0) [2000, 203f], res: (e100) [2000, 203f]
+    __request_region: good with request direct parent: (0000:06:08.0) [2000, 203f], res: (e100) [2000, 203f]
 e100: 0000:06:08.0: e100_probe: Error clearing wake event
 e100: eth0: e100_probe: addr 0xb0106000, irq 20, MAC addr 00:01:4a:9f:7c:79
-initcall e100_init_module+0x0/0x4d returned 0 after 41 msecs
+initcall e100_init_module+0x0/0x4d returned 0 after 64 msecs
 calling  net_olddevs_init+0x0/0x81
 initcall net_olddevs_init+0x0/0x81 returned 0 after 0 msecs
 calling  init_netconsole+0x0/0x185
@@ -717,16 +870,26 @@
 netconsole: device eth0 not up yet, forcing it
 e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
 netconsole: carrier detect appears untrustworthy, waiting 4 seconds
-Clocksource tsc unstable (delta = -499807911 ns)
+Clocksource tsc unstable (delta = -435377680 ns)
 console [netcon0] enabled
 netconsole: network logging started
-initcall init_netconsole+0x0/0x185 returned 0 after 5702 msecs
+initcall init_netconsole+0x0/0x185 returned 0 after 6403 msecs
 calling  init_sd+0x0/0xdf
 Driver 'sd' needs updating - please use bus_type methods
 initcall init_sd+0x0/0xdf returned 0 after 3 msecs
 calling  piix_init+0x0/0x27
 ata_piix 0000:00:1f.1: version 2.12
 ata_piix 0000:00:1f.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
+  __request_region: conflict: (0000:00:1f.1) [1f0, 1f7], res: (ata_piix) [1f0, 1f7]
+    __request_region: good with request direct parent: (0000:00:1f.1) [1f0, 1f7], res: (ata_piix) [1f0, 1f7]
+  __request_region: conflict: (0000:00:1f.1) [3f6, 3f6], res: (ata_piix) [3f6, 3f6]
+    __request_region: good with request direct parent: (0000:00:1f.1) [3f6, 3f6], res: (ata_piix) [3f6, 3f6]
+  __request_region: conflict: (0000:00:1f.1) [170, 177], res: (ata_piix) [170, 177]
+    __request_region: good with request direct parent: (0000:00:1f.1) [170, 177], res: (ata_piix) [170, 177]
+  __request_region: conflict: (0000:00:1f.1) [376, 376], res: (ata_piix) [376, 376]
+    __request_region: good with request direct parent: (0000:00:1f.1) [376, 376], res: (ata_piix) [376, 376]
+  __request_region: conflict: (0000:00:1f.1) [1810, 181f], res: (ata_piix) [1810, 181f]
+    __request_region: good with request direct parent: (0000:00:1f.1) [1810, 181f], res: (ata_piix) [1810, 181f]
 ata_piix 0000:00:1f.1: setting latency timer to 64
 scsi0 : ata_piix
 scsi1 : ata_piix
@@ -738,6 +901,16 @@
 scsi 0:0:0:0: CD-ROM            MATSHITA UJ-832D          1.02 PQ: 0 ANSI: 5
 ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
 ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
+  __request_region: conflict: (0000:00:1f.2) [18c8, 18cf], res: (ata_piix) [18c8, 18cf]
+    __request_region: good with request direct parent: (0000:00:1f.2) [18c8, 18cf], res: (ata_piix) [18c8, 18cf]
+  __request_region: conflict: (0000:00:1f.2) [18c0, 18c3], res: (ata_piix) [18c0, 18c3]
+    __request_region: good with request direct parent: (0000:00:1f.2) [18c0, 18c3], res: (ata_piix) [18c0, 18c3]
+  __request_region: conflict: (0000:00:1f.2) [18a8, 18af], res: (ata_piix) [18a8, 18af]
+    __request_region: good with request direct parent: (0000:00:1f.2) [18a8, 18af], res: (ata_piix) [18a8, 18af]
+  __request_region: conflict: (0000:00:1f.2) [180c, 180f], res: (ata_piix) [180c, 180f]
+    __request_region: good with request direct parent: (0000:00:1f.2) [180c, 180f], res: (ata_piix) [180c, 180f]
+  __request_region: conflict: (0000:00:1f.2) [18b0, 18bf], res: (ata_piix) [18b0, 18bf]
+    __request_region: good with request direct parent: (0000:00:1f.2) [18b0, 18bf], res: (ata_piix) [18b0, 18bf]
 ata_piix 0000:00:1f.2: setting latency timer to 64
 scsi2 : ata_piix
 scsi3 : ata_piix
@@ -757,10 +930,13 @@
 sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2 sda3 < sda5 sda6 >
 sd 2:0:0:0: [sda] Attached SCSI disk
-initcall piix_init+0x0/0x27 returned 0 after 1190 msecs
+initcall piix_init+0x0/0x27 returned 0 after 1274 msecs
 calling  nonstatic_sysfs_init+0x0/0xf
 initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 0 msecs
 calling  yenta_socket_init+0x0/0x16
+  __request_region: conflict: (PCI Bus 0000:06) [b0100000, b01fffff], res: (yenta_socket) [b0108000, b0108fff]
+  __request_region: conflict: (0000:06:05.0) [b0108000, b0108fff], res: (yenta_socket) [b0108000, b0108fff]
+    __request_region: good with request direct parent: (0000:06:05.0) [b0108000, b0108fff], res: (yenta_socket) [b0108000, b0108fff]
 Yenta: CardBus bridge found at 0000:06:05.0 [104d:818f]
 Yenta: Using CSCINT to route CSC interrupts to PCI
 Yenta: Routing CardBus interrupts to PCI
@@ -878,7 +1055,9 @@
 calling  memmap_init+0x0/0x8a
 initcall memmap_init+0x0/0x8a returned 0 after 0 msecs
 calling  pci_mmcfg_late_insert_resources+0x0/0x41
-initcall pci_mmcfg_late_insert_resources+0x0/0x41 returned 0 after 0 msecs
+  insert_resource: first: (reserved) [e0000000, f0005fff], new: (PCI MMCONFIG 0) [e0000000, efffffff]
+    insert_resource: good with request direct parent: (reserved) [e0000000, f0005fff], new: (PCI MMCONFIG 0) [e0000000, efffffff]
+initcall pci_mmcfg_late_insert_resources+0x0/0x41 returned 0 after 5 msecs
 calling  tcp_congestion_default+0x0/0xf
 initcall tcp_congestion_default+0x0/0xf returned 0 after 0 msecs
 Freeing unused kernel memory: 228k freed
-ACPI: Power Button (CM) [PWRB]
-initcall acpi_button_init+0x0/0x51 [button] returned 0 after 114 msecs
-initcall i2c_i801_init+0x0/0x19 [i2c_i801] returned 0 after 32 msecs
+  __request_region: conflict: (0000:00:1f.3) [18e0, 18ff], res: (i801_smbus) [18e0, 18ff]
+    __request_region: good with request direct parent: (0000:00:1f.3) [18e0, 18ff], res: (i801_smbus) [18e0, 18ff]
+initcall i2c_i801_init+0x0/0x19 [i2c_i801] returned 0 after 25 msecs
 calling  ieee80211_crypto_init+0x0/0xf [ieee80211_crypt]
 ieee80211_crypt: registered algorithm 'NULL'
-ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
-firmware: requesting ipw2200-bss.fw
+  __request_region: conflict: (PCI Bus 0000:06) [b0100000, b01fffff], res: (ipw2200) [b0107000, b0107fff]
+  __request_region: conflict: (0000:06:0b.0) [b0107000, b0107fff], res: (ipw2200) [b0107000, b0107fff]
+    __request_region: good with request direct parent: (0000:06:0b.0) [b0107000, b0107fff], res: (ipw2200) [b0107000, b0107fff]
 calling  alsa_pcm_oss_init+0x0/0x72 [snd_pcm_oss]
 initcall alsa_pcm_oss_init+0x0/0x72 [snd_pcm_oss] returned 0 after 0 msecs
 calling  alsa_seq_device_init+0x0/0x51 [snd_seq_device]
 initcall alsa_seq_device_init+0x0/0x51 [snd_seq_device] returned 0 after 0 msecs
 calling  alsa_card_azx_init+0x0/0x19 [snd_hda_intel]
 HDA Intel 0000:00:1b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
+  __request_region: conflict: (0000:00:1b.0) [b0000000, b0003fff], res: (ICH HD audio) [b0000000, b0003fff]
+    __request_region: good with request direct parent: (0000:00:1b.0) [b0000000, b0003fff], res: (ICH HD audio) [b0000000, b0003fff]
 HDA Intel 0000:00:1b.0: setting latency timer to 64
 calling  joydev_init+0x0/0xf [joydev]
 initcall joydev_init+0x0/0xf [joydev] returned 0 after 0 msecs
 calling  init_sg+0x0/0x139 [sg]
+initcall alsa_card_azx_init+0x0/0x19 [snd_hda_intel] returned 0 after 2960 msecs
 uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
+  __request_region: conflict: (0000:00:1d.0) [1820, 183f], res: (uhci_hcd) [1820, 183f]
+    __request_region: good with request direct parent: (0000:00:1d.0) [1820, 183f], res: (uhci_hcd) [1820, 183f]
+initcall alsa_seq_oss_init+0x0/0x149 [snd_seq_oss] returned 0 after 3189 msecs
+initcall ipw_init+0x0/0x71 [ipw2200] returned 0 after 3585 msecs
 uhci_hcd 0000:00:1d.0: setting latency timer to 64
 hub 1-0:1.0: 2 ports detected
 ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
+  __request_region: conflict: (0000:00:1d.7) [b0004000, b00043ff], res: (ehci_hcd) [b0004000, b00043ff]
+    __request_region: good with request direct parent: (0000:00:1d.7) [b0004000, b00043ff], res: (ehci_hcd) [b0004000, b00043ff]
 ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: EHCI Host Controller
 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
@@ -1047,6 +1237,8 @@
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 8 ports detected
 uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
+  __request_region: conflict: (0000:00:1d.1) [1840, 185f], res: (uhci_hcd) [1840, 185f]
+    __request_region: good with request direct parent: (0000:00:1d.1) [1840, 185f], res: (uhci_hcd) [1840, 185f]
 uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: UHCI Host Controller
 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
@@ -1055,34 +1247,41 @@
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 2 ports detected
 ohci1394 0000:06:05.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
+  __request_region: conflict: (PCI Bus 0000:06) [b0100000, b01fffff], res: (ohci1394) [b0104000, b01047ff]
+  __request_region: conflict: (0000:06:05.2) [b0104000, b01047ff], res: (ohci1394) [b0104000, b01047ff]
+    __request_region: good with request direct parent: (0000:06:05.2) [b0104000, b01047ff], res: (ohci1394) [b0104000, b01047ff]
 uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
+  __request_region: conflict: (0000:00:1d.2) [1860, 187f], res: (uhci_hcd) [1860, 187f]
+    __request_region: good with request direct parent: (0000:00:1d.2) [1860, 187f], res: (uhci_hcd) [1860, 187f]
 uhci_hcd 0000:00:1d.2: setting latency timer to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
+initcall ehci_hcd_init+0x0/0x19 [ehci_hcd] returned 0 after 1921 msecs
+initcall ohci1394_init+0x0/0x19 [ohci1394] returned 0 after 1764 msecs
 uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 17 (level, low) -> IRQ 17
+  __request_region: conflict: (0000:00:1d.3) [1880, 189f], res: (uhci_hcd) [1880, 189f]
+    __request_region: good with request direct parent: (0000:00:1d.3) [1880, 189f], res: (uhci_hcd) [1880, 189f]
+usb 3-1: configuration #1 chosen from 1 choice
 uhci_hcd 0000:00:1d.3: setting latency timer to 64
 uhci_hcd 0000:00:1d.3: UHCI Host Controller
 uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
 uhci_hcd 0000:00:1d.3: irq 17, io base 0x00001880
+input: Microsoft Microsoft Wireless Optical Mouse_ 1.00 as /class/input/input8
 usb usb5: configuration #1 chosen from 1 choice
 hub 5-0:1.0: USB hub found
 hub 5-0:1.0: 2 ports detected
-usb 3-1: configuration #1 chosen from 1 choice
-initcall uhci_hcd_init+0x0/0x94 [uhci_hcd] returned 0 after 1982 msecs
-input: Microsoft Microsoft Wireless Optical Mouse_ 1.00 as /class/input/input8
 input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse_ 1.00] on usb-0000:00:1d.1-1
+initcall uhci_hcd_init+0x0/0x94 [uhci_hcd] returned 0 after 2323 msecs
+ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0800460300efc55d]
 calling  nvram_init+0x0/0x75 [nvram]
 Non-volatile memory driver v1.2
-initcall nvram_init+0x0/0x75 [nvram] returned 0 after 4 msecs
-ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0800460300efc55d]
+initcall nvram_init+0x0/0x75 [nvram] returned 0 after 8 msecs
 calling  asus_acpi_init+0x0/0xe2 [asus_acpi]
 initcall asus_acpi_init+0x0/0xe2 [asus_acpi] returned -19 after 0 msecs
 calling  toshiba_acpi_init+0x0/0x156 [toshiba_acpi]
@@ -1108,7 +1307,7 @@
 CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
 nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
 sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
-initcall nf_conntrack_standalone_init+0x0/0xbd [nf_conntrack] returned 0 after 25 msecs
+initcall nf_conntrack_standalone_init+0x0/0xbd [nf_conntrack] returned 0 after 23 msecs
 calling  state_mt_init+0x0/0x14 [xt_state]
 initcall state_mt_init+0x0/0x14 [xt_state] returned 0 after 0 msecs
 calling  nf_conntrack_l3proto_ipv4_init+0x0/0x118 [nf_conntrack_ipv4]
@@ -1132,36 +1331,41 @@
 calling  l2cap_init+0x0/0xbc [l2cap]
 Bluetooth: L2CAP ver 2.10
 Bluetooth: L2CAP socket layer initialized
-initcall l2cap_init+0x0/0xbc [l2cap] returned 0 after 9 msecs
+initcall l2cap_init+0x0/0xbc [l2cap] returned 0 after 10 msecs
 calling  hidp_init+0x0/0x1e [hidp]
 Bluetooth: HIDP (Human Interface Emulation) ver 1.2
-initcall hidp_init+0x0/0x1e [hidp] returned 0 after 4 msecs
+initcall hidp_init+0x0/0x1e [hidp] returned 0 after 5 msecs
 calling  init_autofs4_fs+0x0/0xf [autofs4]
 initcall init_autofs4_fs+0x0/0xf [autofs4] returned 0 after 0 msecs
 SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
 calling  inet6_init+0x0/0x2f8 [ipv6]
 NET: Registered protocol family 10
-initcall inet6_init+0x0/0x2f8 [ipv6] returned 0 after 30 msecs
+initcall inet6_init+0x0/0x2f8 [ipv6] returned 0 after 31 msecs
 eth0: no IPv6 routers present
 calling  sonypi_init+0x0/0x93 [sonypi]
 sonypi: Sony Programmable I/O Controller Driver v1.26.
 sonypi: please try the sony-laptop module instead and report failures, see also http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
+  __request_region: conflict: (Sony Programable I/O Device) [1080, 109f], res: (Sony Programable I/O Device Check) [1080, 109f]
+busy flag
 sonypi: ioport 0x1080 busy, using sony-laptop? if not use check_ioport=0
 sonypi: failed to request ioports
 sonypi: probe of sonypi failed with error -16
-initcall sonypi_init+0x0/0x93 [sonypi] returned 0 after 63 msecs
+initcall sonypi_init+0x0/0x93 [sonypi] returned 0 after 71 msecs
 calling  ipw_init+0x0/0x71 [ipw2200]
 ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2k
 ipw2200: Copyright(c) 2003-2006 Intel Corporation
 ipw2200 0000:06:0b.0: power state changed by ACPI to D0
 ipw2200 0000:06:0b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
+  __request_region: conflict: (PCI Bus 0000:06) [b0100000, b01fffff], res: (ipw2200) [b0107000, b0107fff]
+  __request_region: conflict: (0000:06:0b.0) [b0107000, b0107fff], res: (ipw2200) [b0107000, b0107fff]
+    __request_region: good with request direct parent: (0000:06:0b.0) [b0107000, b0107fff], res: (ipw2200) [b0107000, b0107fff]
 ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
 firmware: requesting ipw2200-bss.fw
 ipw2200: Radio Frequency Kill Switch is On:
 Kill switch must be turned off for wireless networking to work.
 ipw2200: Detected geography ZZA (11 802.11bg channels, 13 802.11a channels)
-initcall ipw_init+0x0/0x71 [ipw2200] returned 0 after 240 msecs
-ipw2200: Failed to send WEP_KEY: Command timed out.
-ipw2200: Failed to send WEP_KEY: Command timed out.
+initcall ipw_init+0x0/0x71 [ipw2200] returned 0 after 236 msecs
+ipw2200: Failed to send WEP_KEY: Aborted due to RF kill switch.
 ADDRCONF(NETDEV_UP): eth1: link is not ready
 ipw2200: Failed to send WEP_KEY: Command timed out.
+ipw2200: Failed to send WEP_KEY: Command timed out.

