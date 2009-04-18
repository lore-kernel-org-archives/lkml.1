Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZDRT31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZDRT31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZDRT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:29:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:51394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbZDRT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:29:16 -0400
Message-ID: <49EA2983.3070003@kernel.org>
Date: Sat, 18 Apr 2009 12:26:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <20090418092216.GP7678@elte.hu> <alpine.LFD.2.00.0904181151230.4042@localhost.localdomain> <20090418191425.GA19565@elte.hu>
In-Reply-To: <20090418191425.GA19565@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Sat, 18 Apr 2009, Ingo Molnar wrote:
>>> Am i missing something?
>> We also try to avoid random motherboard resources etc that aren't 
>> reserved or documented by the BIOS. It's better to go into big 
>> holes. It's also better to try to keep as close to the old 
>> (tested) behavior.
> 
> Yeah - i'm not suggesting any change in behavior, nor am i 
> suggesting any risky behavior. The current code seems to work quite 
> well.
> 
> I'm just suggesting (maybe foolishly) that instead of having any 
> gap-rounding logic at all, add artificial entries to the e820 map to 
> 'extend' and round up any odd ending entries.
> 
> I.e. explicitly manage all the 'hole' space to be nicely rounded and 
> to be far away from any T-Seg or other sekrit motherboard resource 
> danger area.
> 
> We'd do this after PCI static allocations (so we dont ever stomp on 
> real, known resources) but before PCI dynamic allocations.
> 
> The e820 printout would look literally like this:
> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)       0.639 MB RAM
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)     0.001 MB
>                                                 [ hole ]       0.250 MB
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)     0.125 MB
>  BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)    1004.5   MB RAM
>  BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)     0.7   MB
>  BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)      16.3   MB RAM
>  BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)     0.3   MB
>  BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)       0.15  MB RAM
>  BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data     0.07  MB
>  BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)       0.004 MB RAM
>  BIOS-e820: 000000003ff00000 - 0000000040000000 (guard)        1.0   MB
>                                                	[ hole ]    3072.0   MB
> 
> The '(guard)' entry at the end i added above.
> 
> This way we intentionally create a 'free physical address space' 
> hole space that is the same as the rounding logic. No rounding 
> needed anywhere - as all the remaining address space is well-rounded 
> already. Plus we'd also _see_ all our rounding logic by looking at 
> the '(guard)' entries.
> 
> Or maybe there's some aspect of gap-rounding that cannot be 
> expressed in such a static way?
> 

please check following patch.

From: Linus Torvalds <torvalds@linux-foundation.org>

[PATCH] x86: reserve range near the ram -v2

some BIOS use ram near end, but don't state it, just try to reserve them
as RAM buffer

v2: make it in e820 table early instead of resource tree.

[Impact: protect stolen RAM]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/e820.h |    2 +
 arch/x86/kernel/e820.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c     |    6 +++++
 3 files changed, 60 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -150,6 +150,9 @@ static void __init e820_print_type(u32 t
 	case E820_UNUSABLE:
 		printk(KERN_CONT "(unusable)");
 		break;
+	case E820_RAM_BUFFER:
+		printk(KERN_CONT "(RAM buffer)");
+		break;
 	default:
 		printk(KERN_CONT "type %u", type);
 		break;
@@ -1314,6 +1317,54 @@ void __init finish_e820_parsing(void)
 	}
 }
 
+/* How much should we pad RAM ending depending on where it is? */
+static unsigned long __init ram_alignment(resource_size_t pos)
+{
+	unsigned long mb = pos >> 20;
+
+	/* To 64kB in the first megabyte */
+	if (!mb)
+		return 64*1024;
+
+	/* To 1MB in the first 16MB */
+	if (mb < 16)
+		return 1024*1024;
+
+	/* To 32MB for anything above that */
+	return 32*1024*1024;
+}
+
+void __init e820_reserve_stolen_ram(void)
+{
+	int i;
+	int changed = 0;
+
+	/*
+	 * Try to bump up RAM regions to reasonable boundaries to
+	 * avoid stolen RAM
+	 */
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *entry = &e820_saved.map[i];
+		resource_size_t start, end;
+
+		if (entry->type != E820_RAM)
+			continue;
+		start = entry->addr + entry->size;
+		end = round_up(start, ram_alignment(start));
+		if (start == end)
+			continue;
+		e820_add_region(start, end - start, E820_RAM_BUFFER);
+		changed = 1;
+	}
+
+	if (!changed)
+		return;
+
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	printk(KERN_INFO "fixed physical RAM map:\n");
+	e820_print_map("reserve_stolen_range");
+}
+
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
@@ -1322,6 +1373,7 @@ static inline const char *e820_type_to_s
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
+	case E820_RAM_BUFFER:	return "RAM Buffer";
 	default:	return "reserved";
 	}
 }
Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -44,6 +44,7 @@
 #define E820_ACPI	3
 #define E820_NVS	4
 #define E820_UNUSABLE	5
+#define E820_RAM_BUFFER	6
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
@@ -78,6 +79,7 @@ extern u64 e820_update_range(u64 start,
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
 			     int checktype);
 extern void update_e820(void);
+extern void e820_reserve_stolen_ram(void);
 extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			unsigned long start_addr, unsigned long long end_addr);
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -812,6 +812,12 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
+	/*
+	 * some systems use end of ram to for acpi or video ram
+	 * but doesn't state that in reserved in e820
+	 * try to round of ram etc and reserve them
+	 */
+	e820_reserve_stolen_ram();
 
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
