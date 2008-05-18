Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYERISs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYERISs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 04:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYERISb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 04:18:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:35738 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYERISZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 04:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rsomweFZm9Xhqbx+V/v9Q5zDc75stmMXfCDTK5HjMbpOo847cAp+jupj+PhwCGivAeY6PyfkAFeJu3C8i3l8vYo/in+LL+EwTw8rS1TADkeAgmwor5PQIJeMoLXfl6CC1s7cR+jyn5UHWPufvtoScBXAAbbhebr4GnMUR6zBSbg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: extend e820 ealy_res support 32bit
Date: Sun, 18 May 2008 01:18:57 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com>
In-Reply-To: <200805110030.15510.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805180118.57863.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move early_res related from e820_64.c to e820.c
make edba detection to be done in head32.c
remove smp_alloc_memory, because we have fixed trampoline address now.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

 arch/x86/kernel/e820.c              |  214 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/e820_64.c           |  196 --------------------------------
 arch/x86/kernel/head32.c            |   76 ++++++++++++
 arch/x86/kernel/setup_32.c          |  109 +++---------------
 arch/x86/kernel/smpboot.c           |   17 --
 arch/x86/kernel/trampoline.c        |    2
 arch/x86/mach-voyager/voyager_smp.c |    9 -
 include/asm-x86/e820.h              |    6 +
 include/asm-x86/e820_64.h           |    9 -
 include/asm-x86/smp.h               |    1
 10 files changed, 320 insertions(+), 319 deletions(-)


Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -22,7 +22,9 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/e820.h>
+#include <asm/proto.h>
 #include <asm/setup.h>
+#include <asm/trampoline.h>
 
 struct e820map e820;
 
@@ -493,3 +495,215 @@ __init void e820_setup_gap(void)
 	       pci_mem_start, gapstart, gapsize);
 }
 
+
+/*
+ * Early reserved memory areas.
+ */
+#define MAX_EARLY_RES 20
+
+struct early_res {
+	u64 start, end;
+	char name[16];
+};
+static struct early_res early_res[MAX_EARLY_RES] __initdata = {
+	{ 0, PAGE_SIZE, "BIOS data page" },	/* BIOS data page */
+#if defined(CONFIG_X86_64) && defined(CONFIG_X86_TRAMPOLINE)
+	{ TRAMPOLINE_BASE, TRAMPOLINE_BASE + 2 * PAGE_SIZE, "TRAMPOLINE" },
+#endif
+#if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
+	/*
+	 * But first pinch a few for the stack/trampoline stuff
+	 * FIXME: Don't need the extra page at 4K, but need to fix
+	 * trampoline before removing it. (see the GDT stuff)
+	 */
+	{ PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE" },
+	/*
+	 * Has to be in very low memory so we can execute
+	 * real-mode AP code.
+	 */
+	{ TRAMPOLINE_BASE, TRAMPOLINE_BASE + PAGE_SIZE, "TRAMPOLINE" },
+#endif
+	{}
+};
+
+void __init reserve_early(u64 start, u64 end, char *name)
+{
+	int i;
+	struct early_res *r;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (end > r->start && start < r->end)
+			panic("Overlapping early reservations %llx-%llx %s to %llx-%llx %s\n",
+			      start, end - 1, name?name:"", r->start,
+			      r->end - 1, r->name);
+	}
+	if (i >= MAX_EARLY_RES)
+		panic("Too many early reservations");
+	r = &early_res[i];
+	r->start = start;
+	r->end = end;
+	if (name)
+		strncpy(r->name, name, sizeof(r->name) - 1);
+}
+
+void __init free_early(u64 start, u64 end)
+{
+	struct early_res *r;
+	int i, j;
+
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (start == r->start && end == r->end)
+			break;
+	}
+	if (i >= MAX_EARLY_RES || !early_res[i].end)
+		panic("free_early on not reserved area: %llx-%llx!",
+			 start, end);
+
+	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
+		;
+
+	memmove(&early_res[i], &early_res[i + 1],
+	       (j - 1 - i) * sizeof(struct early_res));
+
+	early_res[j - 1].end = 0;
+}
+
+void __init early_res_to_bootmem(u64 start, u64 end)
+{
+	int i;
+	u64 final_start, final_end;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		final_start = max(start, r->start);
+		final_end = min(end, r->end);
+		if (final_start >= final_end)
+			continue;
+		printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
+			final_start, final_end - 1, r->name);
+#ifdef CONFIG_X86_64
+		reserve_bootmem_generic(final_start, final_end - final_start);
+#else
+		reserve_bootmem(final_start, final_end - final_start,
+				BOOTMEM_DEFAULT);
+#endif
+	}
+}
+
+/* Check for already reserved areas */
+static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
+{
+	int i;
+	u64 addr = *addrp, last;
+	int changed = 0;
+again:
+	last = addr + size;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		if (last >= r->start && addr < r->end) {
+			*addrp = addr = round_up(r->end, align);
+			changed = 1;
+			goto again;
+		}
+	}
+	return changed;
+}
+
+/* Check for already reserved areas */
+static inline int __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
+{
+	int i;
+	u64 addr = *addrp, last;
+	u64 size = *sizep;
+	int changed = 0;
+again:
+	last = addr + size;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		if (last > r->start && addr < r->start) {
+			size = r->start - addr;
+			changed = 1;
+			goto again;
+		}
+		if (last > r->end && addr < r->end) {
+			addr = round_up(r->end, align);
+			size = last - addr;
+			changed = 1;
+			goto again;
+		}
+		if (last <= r->end && addr >= r->start) {
+			(*sizep)++;
+			return 0;
+		}
+	}
+	if (changed) {
+		*addrp = addr;
+		*sizep = size;
+	}
+	return changed;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 addr, last;
+		u64 ei_last;
+
+		if (ei->type != E820_RAM)
+			continue;
+		addr = round_up(ei->addr, align);
+		ei_last = ei->addr + ei->size;
+		if (addr < start)
+			addr = round_up(start, align);
+		if (addr >= ei_last)
+			continue;
+		while (bad_addr(&addr, size, align) && addr+size <= ei_last)
+			;
+		last = addr + size;
+		if (last > ei_last)
+			continue;
+		if (last > end)
+			continue;
+		return addr;
+	}
+	return -1ULL;
+}
+
+/*
+ * Find next free range after *start
+ */
+u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 addr, last;
+		u64 ei_last;
+
+		if (ei->type != E820_RAM)
+			continue;
+		addr = round_up(ei->addr, align);
+		ei_last = ei->addr + ei->size;
+		if (addr < start)
+			addr = round_up(start, align);
+		if (addr >= ei_last)
+			continue;
+		*sizep = ei_last - addr;
+		while (bad_addr_size(&addr, sizep, align) &&
+			addr + *sizep <= ei_last)
+			;
+		last = addr + *sizep;
+		if (last > ei_last)
+			continue;
+		return addr;
+	}
+	return -1UL;
+
+}
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -48,202 +48,6 @@ unsigned long max_pfn_mapped;
 static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
 /*
- * Early reserved memory areas.
- */
-#define MAX_EARLY_RES 20
-
-struct early_res {
-	unsigned long start, end;
-	char name[16];
-};
-static struct early_res early_res[MAX_EARLY_RES] __initdata = {
-	{ 0, PAGE_SIZE, "BIOS data page" },			/* BIOS data page */
-#ifdef CONFIG_X86_TRAMPOLINE
-	{ TRAMPOLINE_BASE, TRAMPOLINE_BASE + 2 * PAGE_SIZE, "TRAMPOLINE" },
-#endif
-	{}
-};
-
-void __init reserve_early(unsigned long start, unsigned long end, char *name)
-{
-	int i;
-	struct early_res *r;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		r = &early_res[i];
-		if (end > r->start && start < r->end)
-			panic("Overlapping early reservations %lx-%lx %s to %lx-%lx %s\n",
-			      start, end - 1, name?name:"", r->start, r->end - 1, r->name);
-	}
-	if (i >= MAX_EARLY_RES)
-		panic("Too many early reservations");
-	r = &early_res[i];
-	r->start = start;
-	r->end = end;
-	if (name)
-		strncpy(r->name, name, sizeof(r->name) - 1);
-}
-
-void __init free_early(unsigned long start, unsigned long end)
-{
-	struct early_res *r;
-	int i, j;
-
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		r = &early_res[i];
-		if (start == r->start && end == r->end)
-			break;
-	}
-	if (i >= MAX_EARLY_RES || !early_res[i].end)
-		panic("free_early on not reserved area: %lx-%lx!", start, end);
-
-	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
-		;
-
-	memmove(&early_res[i], &early_res[i + 1],
-	       (j - 1 - i) * sizeof(struct early_res));
-
-	early_res[j - 1].end = 0;
-}
-
-void __init early_res_to_bootmem(unsigned long start, unsigned long end)
-{
-	int i;
-	unsigned long final_start, final_end;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		final_start = max(start, r->start);
-		final_end = min(end, r->end);
-		if (final_start >= final_end)
-			continue;
-		printk(KERN_INFO "  early res: %d [%lx-%lx] %s\n", i,
-			final_start, final_end - 1, r->name);
-		reserve_bootmem_generic(final_start, final_end - final_start);
-	}
-}
-
-/* Check for already reserved areas */
-static inline int __init
-bad_addr(unsigned long *addrp, unsigned long size, unsigned long align)
-{
-	int i;
-	unsigned long addr = *addrp, last;
-	int changed = 0;
-again:
-	last = addr + size;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		if (last >= r->start && addr < r->end) {
-			*addrp = addr = round_up(r->end, align);
-			changed = 1;
-			goto again;
-		}
-	}
-	return changed;
-}
-
-/* Check for already reserved areas */
-static inline int __init
-bad_addr_size(unsigned long *addrp, unsigned long *sizep, unsigned long align)
-{
-	int i;
-	unsigned long addr = *addrp, last;
-	unsigned long size = *sizep;
-	int changed = 0;
-again:
-	last = addr + size;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		if (last > r->start && addr < r->start) {
-			size = r->start - addr;
-			changed = 1;
-			goto again;
-		}
-		if (last > r->end && addr < r->end) {
-			addr = round_up(r->end, align);
-			size = last - addr;
-			changed = 1;
-			goto again;
-		}
-		if (last <= r->end && addr >= r->start) {
-			(*sizep)++;
-			return 0;
-		}
-	}
-	if (changed) {
-		*addrp = addr;
-		*sizep = size;
-	}
-	return changed;
-}
-
-/*
- * Find a free area with specified alignment in a specific range.
- */
-unsigned long __init find_e820_area(unsigned long start, unsigned long end,
-				    unsigned long size, unsigned long align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		unsigned long addr, last;
-		unsigned long ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-		addr = round_up(ei->addr, align);
-		ei_last = ei->addr + ei->size;
-		if (addr < start)
-			addr = round_up(start, align);
-		if (addr >= ei_last)
-			continue;
-		while (bad_addr(&addr, size, align) && addr+size <= ei_last)
-			;
-		last = addr + size;
-		if (last > ei_last)
-			continue;
-		if (last > end)
-			continue;
-		return addr;
-	}
-	return -1UL;
-}
-
-/*
- * Find next free range after *start
- */
-unsigned long __init find_e820_area_size(unsigned long start,
-					 unsigned long *sizep,
-					 unsigned long align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		unsigned long addr, last;
-		unsigned long ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-		addr = round_up(ei->addr, align);
-		ei_last = ei->addr + ei->size;
-		if (addr < start)
-			addr = round_up(start, align);
-		if (addr >= ei_last)
-			continue;
-		*sizep = ei_last - addr;
-		while (bad_addr_size(&addr, sizep, align) &&
-			addr + *sizep <= ei_last)
-			;
-		last = addr + *sizep;
-		if (last > ei_last)
-			continue;
-		return addr;
-	}
-	return -1UL;
-
-}
-/*
  * Find the highest page frame number we have available
  */
 unsigned long __init e820_end_of_ram(void)
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -8,7 +8,83 @@
 #include <linux/init.h>
 #include <linux/start_kernel.h>
 
+#include <asm/setup.h>
+#include <asm/sections.h>
+#include <asm/e820.h>
+#include <asm/bios_ebda.h>
+
+#define BIOS_LOWMEM_KILOBYTES 0x413
+
+/*
+ * The BIOS places the EBDA/XBDA at the top of conventional
+ * memory, and usually decreases the reported amount of
+ * conventional memory (int 0x12) too. This also contains a
+ * workaround for Dell systems that neglect to reserve EBDA.
+ * The same workaround also avoids a problem with the AMD768MPX
+ * chipset: reserve a page before VGA to prevent PCI prefetch
+ * into it (errata #56). Usually the page is reserved anyways,
+ * unless you have no PS/2 mouse plugged in.
+ */
+static void __init reserve_ebda_region(void)
+{
+	unsigned int lowmem, ebda_addr;
+
+	/* To determine the position of the EBDA and the */
+	/* end of conventional memory, we need to look at */
+	/* the BIOS data area. In a paravirtual environment */
+	/* that area is absent. We'll just have to assume */
+	/* that the paravirt case can handle memory setup */
+	/* correctly, without our help. */
+	if (paravirt_enabled())
+		return;
+
+	/* end of low (conventional) memory */
+	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
+	lowmem <<= 10;
+
+	/* start of EBDA area */
+	ebda_addr = get_bios_ebda();
+
+	/* Fixup: bios puts an EBDA in the top 64K segment */
+	/* of conventional memory, but does not adjust lowmem. */
+	if ((lowmem - ebda_addr) <= 0x10000)
+		lowmem = ebda_addr;
+
+	/* Fixup: bios does not report an EBDA at all. */
+	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
+	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
+		lowmem = 0x9f000;
+
+	/* Paranoia: should never happen, but... */
+	if ((lowmem == 0) || (lowmem >= 0x100000))
+		lowmem = 0x9f000;
+
+	/* reserve all memory between lowmem and the 1MB mark */
+	reserve_early(lowmem, 0x100000, "BIOS reserved");
+}
+
 void __init i386_start_kernel(void)
 {
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	/* Reserve INITRD */
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
+	}
+#endif
+	reserve_early(__pa_symbol(&_end), init_pg_tables_end, "INIT_PG_TABLE");
+
+	reserve_ebda_region();
+
+	/*
+	 * At this point everything still needed from the boot loader
+	 * or BIOS or kernel text should be early reserved or marked not
+	 * RAM in e820. All other memory is free game.
+	 */
+
 	start_kernel();
 }
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -359,56 +359,6 @@ unsigned long __init find_max_low_pfn(vo
 	return max_low_pfn;
 }
 
-#define BIOS_LOWMEM_KILOBYTES 0x413
-
-/*
- * The BIOS places the EBDA/XBDA at the top of conventional
- * memory, and usually decreases the reported amount of
- * conventional memory (int 0x12) too. This also contains a
- * workaround for Dell systems that neglect to reserve EBDA.
- * The same workaround also avoids a problem with the AMD768MPX
- * chipset: reserve a page before VGA to prevent PCI prefetch
- * into it (errata #56). Usually the page is reserved anyways,
- * unless you have no PS/2 mouse plugged in.
- */
-static void __init reserve_ebda_region(void)
-{
-	unsigned int lowmem, ebda_addr;
-
-	/* To determine the position of the EBDA and the */
-	/* end of conventional memory, we need to look at */
-	/* the BIOS data area. In a paravirtual environment */
-	/* that area is absent. We'll just have to assume */
-	/* that the paravirt case can handle memory setup */
-	/* correctly, without our help. */
-	if (paravirt_enabled())
-		return;
-
-	/* end of low (conventional) memory */
-	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
-	lowmem <<= 10;
-
-	/* start of EBDA area */
-	ebda_addr = get_bios_ebda();
-
-	/* Fixup: bios puts an EBDA in the top 64K segment */
-	/* of conventional memory, but does not adjust lowmem. */
-	if ((lowmem - ebda_addr) <= 0x10000)
-		lowmem = ebda_addr;
-
-	/* Fixup: bios does not report an EBDA at all. */
-	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
-	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
-		lowmem = 0x9f000;
-
-	/* Paranoia: should never happen, but... */
-	if ((lowmem == 0) || (lowmem >= 0x100000))
-		lowmem = 0x9f000;
-
-	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_bootmem(lowmem, 0x100000 - lowmem, BOOTMEM_DEFAULT);
-}
-
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 static void __init setup_bootmem_allocator(void);
 static unsigned long __init setup_memory(void)
@@ -522,25 +472,32 @@ static void __init reserve_initrd(void)
 	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 	unsigned long ramdisk_here;
 
-	initrd_start = 0;
-
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
 		return;		/* No initrd provided by bootloader */
 
+	initrd_start = 0;
+
 	if (ramdisk_end < ramdisk_image) {
+		free_bootmem(ramdisk_image, ramdisk_size);
 		printk(KERN_ERR "initrd wraps around end of memory, "
 		       "disabling initrd\n");
 		return;
 	}
 	if (ramdisk_size >= end_of_lowmem/2) {
+		free_bootmem(ramdisk_image, ramdisk_size);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
 		return;
 	}
+
 	if (ramdisk_end <= end_of_lowmem) {
 		/* All in lowmem, easy case */
-		reserve_bootmem(ramdisk_image, ramdisk_size, BOOTMEM_DEFAULT);
+		/*
+		 * don't need to reserve again, already reserved early
+		 * in i386_start_kernel, and early_res_to_bootmem
+		 * convert that to reserved in bootmem
+		 */
 		initrd_start = ramdisk_image + PAGE_OFFSET;
 		initrd_end = initrd_start+ramdisk_size;
 		return;
@@ -582,6 +539,8 @@ static void __init relocate_initrd(void)
 		p = (char *)__va(ramdisk_image);
 		memcpy(q, p, clen);
 		q += clen;
+		/* need to free these low pages...*/
+		free_bootmem(ramdisk_image, clen);
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
 	}
@@ -600,47 +559,28 @@ static void __init relocate_initrd(void)
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
 	}
+	/* high pages is not converted by early_res_to_bootmem */
 }
 
 #endif /* CONFIG_BLK_DEV_INITRD */
 
 void __init setup_bootmem_allocator(void)
 {
-	unsigned long bootmap_size;
+	unsigned long bootmap_size, bootmap;
 	/*
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
-	bootmap_size = init_bootmem(min_low_pfn, max_low_pfn);
-
+	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
+	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+				 max_low_pfn<<PAGE_SHIFT, bootmap_size,
+				 PAGE_SIZE);
+	if (bootmap == -1L)
+		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
+	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
 	register_bootmem_low_pages(max_low_pfn);
+	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 
-	/*
-	 * Reserve the bootmem bitmap itself as well. We do this in two
-	 * steps (first step was init_bootmem()) because this catches
-	 * the (very unlikely) case of us accidentally initializing the
-	 * bootmem allocator with an invalid RAM area.
-	 */
-	reserve_bootmem(__pa_symbol(_text), (PFN_PHYS(min_low_pfn) +
-			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text),
-			 BOOTMEM_DEFAULT);
-
-	/*
-	 * reserve physical page 0 - it's a special BIOS page on many boxes,
-	 * enabling clean reboots, SMP operation, laptop functions.
-	 */
-	reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
-
-	/* reserve EBDA region */
-	reserve_ebda_region();
-
-#ifdef CONFIG_SMP
-	/*
-	 * But first pinch a few for the stack/trampoline stuff
-	 * FIXME: Don't need the extra page at 4K, but need to fix
-	 * trampoline before removing it. (see the GDT stuff)
-	 */
-	reserve_bootmem(PAGE_SIZE, PAGE_SIZE, BOOTMEM_DEFAULT);
-#endif
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
@@ -791,9 +731,6 @@ void __init setup_arch(char **cmdline_p)
 	 * not to exceed the 8Mb limit.
 	 */
 
-#ifdef CONFIG_SMP
-	smp_alloc_memory(); /* AP processor realmode stacks in low memory*/
-#endif
 	paging_init();
 
 	/*
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -538,23 +538,6 @@ cpumask_t cpu_coregroup_map(int cpu)
 		return c->llc_shared_map;
 }
 
-#ifdef CONFIG_X86_32
-/*
- * We are called very early to get the low memory for the
- * SMP bootup trampoline page.
- */
-void __init smp_alloc_memory(void)
-{
-	trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
-	/*
-	 * Has to be in very low memory so we can execute
-	 * real-mode AP code.
-	 */
-	if (__pa(trampoline_base) >= 0x9F000)
-		BUG();
-}
-#endif
-
 static void impress_friends(void)
 {
 	int cpu;
Index: linux-2.6/arch/x86/kernel/trampoline.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/trampoline.c
+++ linux-2.6/arch/x86/kernel/trampoline.c
@@ -2,7 +2,7 @@
 
 #include <asm/trampoline.h>
 
-/* ready for x86_64, no harm for x86, since it will overwrite after alloc */
+/* ready for x86_64 and x86 */
 unsigned char *trampoline_base = __va(TRAMPOLINE_BASE);
 
 /*
Index: linux-2.6/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6/arch/x86/mach-voyager/voyager_smp.c
@@ -1137,15 +1137,6 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, 0, 1, 1);
 }
 
-/* used to set up the trampoline for other CPUs when the memory manager
- * is sorted out */
-void __init smp_alloc_memory(void)
-{
-	trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
-	if (__pa(trampoline_base) >= 0x93000)
-		BUG();
-}
-
 /* send a reschedule CPI to one CPU by physical CPU number*/
 static void voyager_smp_send_reschedule(int cpu)
 {
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -70,6 +70,12 @@ extern u64 update_memory_range(u64 start
 extern void update_e820(void);
 extern void e820_setup_gap(void);
 
+extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
+extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
+extern void reserve_early(u64 start, u64 end, char *name);
+extern void free_early(u64 start, u64 end);
+extern void early_res_to_bootmem(u64 start, u64 end);
+
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -14,11 +14,6 @@
 #include <linux/ioport.h>
 
 #ifndef __ASSEMBLY__
-extern unsigned long find_e820_area(unsigned long start, unsigned long end,
-				    unsigned long size, unsigned long align);
-extern unsigned long find_e820_area_size(unsigned long start,
-					 unsigned long *sizep,
-					 unsigned long align);
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
 extern unsigned long e820_end_of_ram(void);
@@ -35,10 +30,6 @@ extern void e820_register_active_regions
 
 extern void finish_e820_parsing(void);
 
-extern void reserve_early(unsigned long start, unsigned long end, char *name);
-extern void free_early(unsigned long start, unsigned long end);
-extern void early_res_to_bootmem(unsigned long start, unsigned long end);
-
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
Index: linux-2.6/include/asm-x86/smp.h
===================================================================
--- linux-2.6.orig/include/asm-x86/smp.h
+++ linux-2.6/include/asm-x86/smp.h
@@ -192,7 +192,6 @@ extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
 
-extern void smp_alloc_memory(void);
 extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
 #endif /* __ASSEMBLY__ */
