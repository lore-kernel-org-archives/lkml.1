Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYCAQLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYCAQLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYCAQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:11:32 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:2525 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbYCAQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:11:31 -0500
Date: Sat, 1 Mar 2008 17:09:12 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Mark McLoughlin <markmc@redhat.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
Message-ID: <20080301160911.GA13271@mailshack.com>
References: <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <1204232996.28798.8.camel@cthulhu.hellion.org.uk> <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com> <1204322819.6299.1.camel@muff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204322819.6299.1.camel@muff>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sat, 01 Mar 2008 17:10:21 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.2.215; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds explicit detection of the EBDA and reservation
of the rom and adapter address space 0xa0000-0x100000 to the
i386 kernels. Before this patch, the EBDA size was hardcoded
as 4Kb. Also, the reservation of the adapter range was done by
modifying the e820 map which is now not necessary any longer,
and that code is removed from copy_e820_map.

The amount of conventional memory and the start of the EBDA are
detected by reading the BIOS data area directly. Paravirtual
environments do not provide this area, so we bail out early
in that case. They will just have to set up a correct memory
map to start with.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi Ingo,

This is the second attempt at a i386-version of the ebda
patch. I hope that one of the Xen people will be able to
check that this does not break their setups, but I think
it will be fine after their patch to exclude the 0x9f000-
0x100000 area explicitly in their setup.

Greetings,
    Alexander

diff --git a/arch/x86/kernel/e820_32.c b/arch/x86/kernel/e820_32.c
index 4e16ef4..746d683 100644
--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -450,38 +450,25 @@ int __init sanitize_e820_map(struct e820entry * biosmap, char * pnr_map)
  * thinkpad 560x, for example, does not cooperate with the memory
  * detection code.)
  */
-int __init copy_e820_map(struct e820entry * biosmap, int nr_map)
+int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	/* Only one memory region (or negative)? Ignore it */
 	if (nr_map < 2)
 		return -1;
 
 	do {
-		unsigned long long start = biosmap->addr;
-		unsigned long long size = biosmap->size;
-		unsigned long long end = start + size;
-		unsigned long type = biosmap->type;
+		u64 start = biosmap->addr;
+		u64 size = biosmap->size;
+		u64 end = start + size;
+		u32 type = biosmap->type;
 
 		/* Overflow in 64 bits? Ignore the memory map. */
 		if (start > end)
 			return -1;
 
-		/*
-		 * Some BIOSes claim RAM in the 640k - 1M region.
-		 * Not right. Fix it up.
-		 */
-		if (type == E820_RAM) {
-			if (start < 0x100000ULL && end > 0xA0000ULL) {
-				if (start < 0xA0000ULL)
-					add_memory_region(start, 0xA0000ULL-start, type);
-				if (end <= 0x100000ULL)
-					continue;
-				start = 0x100000ULL;
-				size = end - start;
-			}
-		}
 		add_memory_region(start, size, type);
-	} while (biosmap++,--nr_map);
+	} while (biosmap++, --nr_map);
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index a1d7071..20e537b 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -385,15 +385,60 @@ unsigned long __init find_max_low_pfn(void)
 	return max_low_pfn;
 }
 
+#define BIOS_EBDA_SEGMENT 0x40E
+#define BIOS_LOWMEM_KILOBYTES 0x413
+
 /*
- * workaround for Dell systems that neglect to reserve EBDA
+ * The BIOS places the EBDA/XBDA at the top of conventional
+ * memory, and usually decreases the reported amount of
+ * conventional memory (int 0x12) too. This also contains a
+ * workaround for Dell systems that neglect to reserve EBDA.
+ * The same workaround also avoids a problem with the AMD768MPX
+ * chipset: reserve a page before VGA to prevent PCI prefetch
+ * into it (errata #56). Usually the page is reserved anyways,
+ * unless you have no PS/2 mouse plugged in.
  */
 static void __init reserve_ebda_region(void)
 {
-	unsigned int addr;
-	addr = get_bios_ebda();
-	if (addr)
-		reserve_bootmem(addr, PAGE_SIZE, BOOTMEM_DEFAULT);
+	unsigned int lowmem, ebda_addr;
+
+	/* To determine the position of the EBDA and the */
+	/* end of conventional memory, we need to look at */
+	/* the BIOS data area. In a paravirtual environment */
+	/* that area is absent. We'll just have to assume */
+	/* that the paravirt case can handle memory setup */
+	/* correctly, without our help. */
+#ifdef CONFIG_PARAVIRT
+	if ((boot_params.hdr.version >= 0x207) &&
+			(boot_params.hdr.hardware_subarch != 0)) {
+		return;
+	}
+#endif
+
+	/* end of low (conventional) memory */
+	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
+	lowmem <<= 10;
+
+	/* start of EBDA area */
+	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
+	ebda_addr <<= 4;
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
+	reserve_bootmem(lowmem, 0x100000 - lowmem, BOOTMEM_DEFAULT);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -619,16 +664,9 @@ void __init setup_bootmem_allocator(void)
 	 */
 	reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
 
-	/* reserve EBDA region, it's a 4K region */
+	/* reserve EBDA region */
 	reserve_ebda_region();
 
-    /* could be an AMD 768MPX chipset. Reserve a page  before VGA to prevent
-       PCI prefetch into it (errata #56). Usually the page is reserved anyways,
-       unless you have no PS/2 mouse plugged in. */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-	    boot_cpu_data.x86 == 6)
-	     reserve_bootmem(0xa0000 - 4096, 4096, BOOTMEM_DEFAULT);
-
 #ifdef CONFIG_SMP
 	/*
 	 * But first pinch a few for the stack/trampoline stuff

