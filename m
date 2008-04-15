Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbYDOTg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbYDOTg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYDOTgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:36:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbYDOTgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:36:18 -0400
Date: Tue, 15 Apr 2008 21:35:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415193540.GA22094@elte.hu>
References: <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> > 
> > btw., now with a second full day spent on this regression, i have 
> > figured out a workaround the hard way: increasing SECTION_SIZE_BITS 
> > in include/asm-x86/sparsemem.h from 26 to 27 makes it go away.
> 
> Interesting.
> 
> I wonder..
> 
> So since you don't have NUMA, you have NODES_SHIFT == 0.
> 
> That in turn means that NODE_NOT_IN_PAGE_FLAGS is _not_ set.
> 
> That, in turn, means that ZONEID_SHIFT does *not* contain 
> SECTIONS_SHIFT. Is that really what is supposed to happen?
> 
> Because then "page_is_buddy()" will not even test the section, as far 
> as I can tell.
> 
> But I'm probably missing something. Why would we not need to test the 
> section in page_zone_id() when the node ID is in the page flags (but 
> has zero size)?

still crashes with the patch below - find the crash-log further below.

(the kernel has a few more non-destructive debug printouts and debug 
checks included as well, which you can see in the log, but it's a 
vanilla kernel otherwise.)

	Ingo

----------------------->
Subject: nodes: shift fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 15 21:15:21 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -424,7 +424,7 @@ static inline void set_compound_order(st
  * We are going to use the flags for the page to node mapping if its in
  * there.  This includes the case where there is no node, so it is implicit.
  */
-#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#if NODES_WIDTH <= 0 || NODES_SHIFT == 0
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 

[    0.000000] Linux version 2.6.25-rc9 (mingo@dione) (gcc version 4.2.2) #960 SMP Tue Apr 15 21:16:23 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000efff8000 (usable)
[    0.000000]  BIOS-e820: 00000000efff8000 - 00000000f0000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000110000000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] Warning only 4GB will be used.
[    0.000000] Use a HIGHMEM64G enabled kernel.
[    0.000000] 3200MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f4fd0] 000f4fd0
[    0.000000] sparse_init()
[    0.000000] section  0: sparse_mem_map_populate2(#0, (nd:0)): c1000000
[    0.000000] map: c1000000, usemap: c1100000 [content: c1000003]
[    0.000000] section  1: sparse_mem_map_populate2(#1, (nd:0)): c1180000
[    0.000000] map: c1180000, usemap: c1280000 [content: c1100003]
[    0.000000] section  2: sparse_mem_map_populate2(#2, (nd:0)): c1300000
[    0.000000] map: c1300000, usemap: c1400000 [content: c1200003]
[    0.000000] section  3: sparse_mem_map_populate2(#3, (nd:0)): c1480000
[    0.000000] map: c1480000, usemap: c1580000 [content: c1300003]
[    0.000000] section  4: sparse_mem_map_populate2(#4, (nd:0)): c1600000
[    0.000000] map: c1600000, usemap: c1700000 [content: c1400003]
[    0.000000] section  5: sparse_mem_map_populate2(#5, (nd:0)): c1780000
[    0.000000] map: c1780000, usemap: c1880000 [content: c1500003]
[    0.000000] section  6: sparse_mem_map_populate2(#6, (nd:0)): c1900000
[    0.000000] map: c1900000, usemap: c1a00000 [content: c1600003]
[    0.000000] section  7: sparse_mem_map_populate2(#7, (nd:0)): c1a80000
[    0.000000] map: c1a80000, usemap: c1b80000 [content: c1700003]
[    0.000000] section  8: sparse_mem_map_populate2(#8, (nd:0)): c1c00000
[    0.000000] map: c1c00000, usemap: c1d00000 [content: c1800003]
[    0.000000] section  9: sparse_mem_map_populate2(#9, (nd:0)): c1d80000
[    0.000000] map: c1d80000, usemap: c1e80000 [content: c1900003]
[    0.000000] section 10: sparse_mem_map_populate2(#10, (nd:0)): c1f00000
[    0.000000] map: c1f00000, usemap: c2000000 [content: c1a00003]
[    0.000000] section 11: sparse_mem_map_populate2(#11, (nd:0)): c2080000
[    0.000000] map: c2080000, usemap: c2180000 [content: c1b00003]
[    0.000000] section 12: sparse_mem_map_populate2(#12, (nd:0)): c2200000
[    0.000000] map: c2200000, usemap: c2300000 [content: c1c00003]
[    0.000000] section 13: sparse_mem_map_populate2(#13, (nd:0)): c2380000
[    0.000000] map: c2380000, usemap: c2480000 [content: c1d00003]
[    0.000000] section 14: sparse_mem_map_populate2(#14, (nd:0)): c2500000
[    0.000000] map: c2500000, usemap: c2600000 [content: c1e00003]
[    0.000000] section 15: sparse_mem_map_populate2(#15, (nd:0)): c2680000
[    0.000000] map: c2680000, usemap: c2780000 [content: c1f00003]
[    0.000000] section 16: sparse_mem_map_populate2(#16, (nd:0)): c2800000
[    0.000000] map: c2800000, usemap: c2900000 [content: c2000003]
[    0.000000] section 17: sparse_mem_map_populate2(#17, (nd:0)): c2980000
[    0.000000] map: c2980000, usemap: c2a80000 [content: c2100003]
[    0.000000] section 18: sparse_mem_map_populate2(#18, (nd:0)): c2b00000
[    0.000000] map: c2b00000, usemap: c2c00000 [content: c2200003]
[    0.000000] section 19: sparse_mem_map_populate2(#19, (nd:0)): c2c80000
[    0.000000] map: c2c80000, usemap: c2d80000 [content: c2300003]
[    0.000000] section 20: sparse_mem_map_populate2(#20, (nd:0)): c2e00000
[    0.000000] map: c2e00000, usemap: c2f00000 [content: c2400003]
[    0.000000] section 21: sparse_mem_map_populate2(#21, (nd:0)): c2f80000
[    0.000000] map: c2f80000, usemap: c3080000 [content: c2500003]
[    0.000000] section 22: sparse_mem_map_populate2(#22, (nd:0)): c3100000
[    0.000000] map: c3100000, usemap: c3200000 [content: c2600003]
[    0.000000] section 23: sparse_mem_map_populate2(#23, (nd:0)): c3280000
[    0.000000] map: c3280000, usemap: c3380000 [content: c2700003]
[    0.000000] section 24: sparse_mem_map_populate2(#24, (nd:0)): c3400000
[    0.000000] map: c3400000, usemap: c3500000 [content: c2800003]
[    0.000000] section 25: sparse_mem_map_populate2(#25, (nd:0)): c3580000
[    0.000000] map: c3580000, usemap: c3680000 [content: c2900003]
[    0.000000] section 26: sparse_mem_map_populate2(#26, (nd:0)): c3700000
[    0.000000] map: c3700000, usemap: c3800000 [content: c2a00003]
[    0.000000] section 27: sparse_mem_map_populate2(#27, (nd:0)): c3880000
[    0.000000] map: c3880000, usemap: c3980000 [content: c2b00003]
[    0.000000] section 28: sparse_mem_map_populate2(#28, (nd:0)): c3a00000
[    0.000000] map: c3a00000, usemap: c3b00000 [content: c2c00003]
[    0.000000] section 29: sparse_mem_map_populate2(#29, (nd:0)): c3b80000
[    0.000000] map: c3b80000, usemap: c3c80000 [content: c2d00003]
[    0.000000] section 30: sparse_mem_map_populate2(#30, (nd:0)): c3d00000
[    0.000000] map: c3d00000, usemap: c3e00000 [content: c2e00003]
[    0.000000] section 31: sparse_mem_map_populate2(#31, (nd:0)): c3e80000
[    0.000000] map: c3e80000, usemap: c3f80000 [content: c2f00003]
[    0.000000] section 32: sparse_mem_map_populate2(#32, (nd:0)): c4000000
[    0.000000] map: c4000000, usemap: c4100000 [content: c3000003]
[    0.000000] section 33: sparse_mem_map_populate2(#33, (nd:0)): c4180000
[    0.000000] map: c4180000, usemap: c4280000 [content: c3100003]
[    0.000000] section 34: sparse_mem_map_populate2(#34, (nd:0)): c4300000
[    0.000000] map: c4300000, usemap: c4400000 [content: c3200003]
[    0.000000] section 35: sparse_mem_map_populate2(#35, (nd:0)): c4480000
[    0.000000] map: c4480000, usemap: c4580000 [content: c3300003]
[    0.000000] section 36: sparse_mem_map_populate2(#36, (nd:0)): c4600000
[    0.000000] map: c4600000, usemap: c4700000 [content: c3400003]
[    0.000000] section 37: sparse_mem_map_populate2(#37, (nd:0)): c4780000
[    0.000000] map: c4780000, usemap: c4880000 [content: c3500003]
[    0.000000] section 38: sparse_mem_map_populate2(#38, (nd:0)): c4900000
[    0.000000] map: c4900000, usemap: c4a00000 [content: c3600003]
[    0.000000] section 39: sparse_mem_map_populate2(#39, (nd:0)): c4a80000
[    0.000000] map: c4a80000, usemap: c4b80000 [content: c3700003]
[    0.000000] section 40: sparse_mem_map_populate2(#40, (nd:0)): c4c00000
[    0.000000] map: c4c00000, usemap: c4d00000 [content: c3800003]
[    0.000000] section 41: sparse_mem_map_populate2(#41, (nd:0)): c4d80000
[    0.000000] map: c4d80000, usemap: c4e80000 [content: c3900003]
[    0.000000] section 42: sparse_mem_map_populate2(#42, (nd:0)): c4f00000
[    0.000000] map: c4f00000, usemap: c5000000 [content: c3a00003]
[    0.000000] section 43: sparse_mem_map_populate2(#43, (nd:0)): c5080000
[    0.000000] map: c5080000, usemap: c5180000 [content: c3b00003]
[    0.000000] section 44: sparse_mem_map_populate2(#44, (nd:0)): c5200000
[    0.000000] map: c5200000, usemap: c5300000 [content: c3c00003]
[    0.000000] section 45: sparse_mem_map_populate2(#45, (nd:0)): c5380000
[    0.000000] map: c5380000, usemap: c5480000 [content: c3d00003]
[    0.000000] section 46: sparse_mem_map_populate2(#46, (nd:0)): c5500000
[    0.000000] map: c5500000, usemap: c5600000 [content: c3e00003]
[    0.000000] section 47: sparse_mem_map_populate2(#47, (nd:0)): c5680000
[    0.000000] map: c5680000, usemap: c5780000 [content: c3f00003]
[    0.000000] section 48: sparse_mem_map_populate2(#48, (nd:0)): c5800000
[    0.000000] map: c5800000, usemap: c5900000 [content: c4000003]
[    0.000000] section 49: sparse_mem_map_populate2(#49, (nd:0)): c5980000
[    0.000000] map: c5980000, usemap: c5a80000 [content: c4100003]
[    0.000000] section 50: sparse_mem_map_populate2(#50, (nd:0)): c5b00000
[    0.000000] map: c5b00000, usemap: c5c00000 [content: c4200003]
[    0.000000] section 51: sparse_mem_map_populate2(#51, (nd:0)): c5c80000
[    0.000000] map: c5c80000, usemap: c5d80000 [content: c4300003]
[    0.000000] section 52: sparse_mem_map_populate2(#52, (nd:0)): c5e00000
[    0.000000] map: c5e00000, usemap: c5f00000 [content: c4400003]
[    0.000000] section 53: sparse_mem_map_populate2(#53, (nd:0)): c5f80000
[    0.000000] map: c5f80000, usemap: c6080000 [content: c4500003]
[    0.000000] section 54: sparse_mem_map_populate2(#54, (nd:0)): c6100000
[    0.000000] map: c6100000, usemap: c6200000 [content: c4600003]
[    0.000000] section 55: sparse_mem_map_populate2(#55, (nd:0)): c6280000
[    0.000000] map: c6280000, usemap: c6380000 [content: c4700003]
[    0.000000] section 56: sparse_mem_map_populate2(#56, (nd:0)): c6400000
[    0.000000] map: c6400000, usemap: c6500000 [content: c4800003]
[    0.000000] section 57: sparse_mem_map_populate2(#57, (nd:0)): c6580000
[    0.000000] map: c6580000, usemap: c6680000 [content: c4900003]
[    0.000000] section 58: sparse_mem_map_populate2(#58, (nd:0)): c6700000
[    0.000000] map: c6700000, usemap: c6800000 [content: c4a00003]
[    0.000000] section 59: sparse_mem_map_populate2(#59, (nd:0)): c6880000
[    0.000000] map: c6880000, usemap: c6980000 [content: c4b00003]
[    0.000000] section 60: !present
[    0.000000] section 61: !present
[    0.000000] section 62: !present
[    0.000000] section 63: !present
[    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
[    0.000000] max_zone_pfn[max:4]:
[    0.000000] # 0:                 4096 [0000000000001000]
[    0.000000] # 1:               229376 [0000000000038000]
[    0.000000] # 2:              1048576 [0000000000100000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000] mem_init: 0 -> 4096
[    0.000000] mem_init: Checking pfn <-> page mappings
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000] mem_init: 4096 -> 229376
[    0.000000] mem_init: Checking pfn <-> page mappings
[    0.000000]   HighMem zone: 6400 pages used for memmap
[    0.000000]   HighMem zone: 812800 pages, LIFO batch:31
[    0.000000] mem_init: 229376 -> 1048576
[    0.000000] mem_init: Checking pfn <-> page mappings
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F4F70, 0014 (r0 COMPAQ)
[    0.000000] ACPI: RSDT EFFF8000, 002C (r1 Compaq 8500____        1   �     162E)
[    0.000000] ACPI: FACP EFFF8040, 0074 (r1 Compaq 8500____        1   �     162E)
[    0.000000] ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 0000000000000000/2 [20070126]
[    0.000000] ACPI: DSDT EFFF81C0, 3D9E (r1 COMPAQ     8500       16 MSFT  100000B)
[    0.000000] ACPI: FACS EFFF80C0, 0040
[    0.000000] ACPI: APIC EFFF8100, 00B2 (r1 Compaq 8500____        1             0)
[    0.000000] ACPI: PM-Timer IO Port: 0x240
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x02] enabled)
[    0.000000] Processor #2 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] Processor #3 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] Processor #4 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] Processor #5 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] Processor #6 6:10 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x07] enabled)
[    0.000000] Processor #7 6:10 APIC version 17
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-34
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:0ec00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
[    0.000000] Kernel command line: root=/dev/ida/c0d0p3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 nmi_watchdog=0 debug initcall_debug selinux=0 panic=10
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 700.070 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console handover: boot [earlyser0] -> real [tty0]
[    0.000999] console [ttyS0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] set_highmem_pages_init(bad_ppro:0)
[    0.000999] sizeof(struct page):        32
[    0.000999] sizeof(struct mem_section): 8
[    0.000999] PFN_SECTION_SHIFT:          14
[    0.000999] mem_map: 00000000
[    0.000999]   highstart_pfn:    229376 [page: c2500000]
[    0.000999]     highend_pfn:   1048576 [page: 02000000]
[    0.000999]   highend_pfn-1:   1048575 [page: 01ffffe0]
[    0.000999] NR_MEM_SECTIONS: 64
[    0.000999] pfn_to_section_nr(highstart_pfn):        14
[    0.000999] pfn_to_section_nr(highend_pfn):          64
[    0.000999] pfn_to_section_nr(highend_pfn-1):        63
[    0.000999] totalhigh_pages:         0
[    0.000999]  totalram_pages:    210525
[    0.000999] bad pfn: 983040
[    0.000999] totalhigh_pages:    753656
[    0.000999]  totalram_pages:    210525
[    0.000999] Memory: 3855384k/4194304k available (6672k kernel code, 75012k reserved, 3667k data, 456k init, 3014624k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000999]       .init : 0xc0b23000 - 0xc0b95000   ( 456 kB)
[    0.000999]       .data : 0xc0784383 - 0xc0b19124   (3667 kB)
[    0.000999]       .text : 0xc0100000 - 0xc0784383   (6672 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] CPA: page pool initialized 0 of 1 pages preallocated
[    0.000999] BUG: unable to handle kernel paging request at b0030b10
[    0.000999] IP: [<c015dbd2>] __kmalloc+0x8f/0xd8
[    0.000999] *pde = 00000000 
[    0.000999] Oops: 0000 [#0] SMP 
[    0.000999] 
[    0.000999] Pid: 0, comm: swapper Not tainted (2.6.25-rc9 #960)
[    0.000999] EIP: 0060:[<c015dbd2>] EFLAGS: 00010082 CPU: 0
[    0.000999] EIP is at __kmalloc+0x8f/0xd8
[    0.000999] EAX: f0009bd0 EBX: 00000000 ECX: c0b13268 EDX: f0009bd0
[    0.000999] ESI: c0b13268 EDI: f0009bd0 EBP: c0b1bf4c ESP: c0b1bf30
[    0.000999]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000999] Process swapper (pid: 0, ti=c0b1a000 task=c0a22300 task.ti=c0b1a000)
[    0.000999] Stack: f0009bd0 000000d0 00000240 00000282 00000000 000000d0 c0b13268 c0b1bf60 
[    0.000999]        c015e3ea 00000000 000000d0 c0b13268 c0b1bf8c c015e4e1 00000026 c0942ab1 
[    0.000999]        c0b13268 000000d0 000eb655 000eb506 20000000 c0b13268 00000060 c0b1bfb4 
[    0.000999] Call Trace:
[    0.000999]  [<c015e3ea>] ? alloc_kmem_cache_cpu+0x3a/0x6a
[    0.000999]  [<c015e4e1>] ? kmem_cache_open+0xc7/0x128
[    0.000999]  [<c015e583>] ? create_kmalloc_cache+0x41/0x90
[    0.000999]  [<c0b34721>] ? kmem_cache_init+0x4e/0x123
[    0.000999]  [<c0b23b55>] ? start_kernel+0x29e/0x323
[    0.000999]  =======================
[    0.000999] Code: b8 c0 8b 5c 86 78 8b 3b 89 7d e4 85 ff 75 16 53 52 83 c9 ff 8b 55 e8 89 f0 e8 43 ee ff ff 89 45 e4 58 5a eb 0e 8b 43 0c 8b 55 e4 <8b> 04 82 89 03 ff 43 14 8b 45 f0 51 52 ff 15 c8 4e a2 c0 5a 59 
[    0.000999] EIP: [<c015dbd2>] __kmalloc+0x8f/0xd8 SS:ESP 0068:c0b1bf30
[    0.000999] ---[ end trace ca143223eefdc828 ]---
[    0.000999] Kernel panic - not syncing: Attempted to kill the idle task!
