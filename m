Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYB1NSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYB1NSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYB1NSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:18:04 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:17674 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYB1NSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:18:02 -0500
Date: Thu, 28 Feb 2008 14:13:41 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
Message-ID: <20080228131341.GA25213@mailshack.com>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225180750.GA31054@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 28 Feb 2008 14:16:17 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.67; VDF: 7.0.2.206; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit code still uses reserve_bootmem, so this is not really
a unification with the 64-bit version of the ebda reservation code,
but at least it provides the same detection logic and reserves the
same areas.

This does not crash immediately on qemu. No further testing was
done! Otherwise:

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hello Ian, Ingo,

This patch should do the same reservations as the reserve_early
patch for 64 bit. Maybe you could try if this solves the problems
you are seeing with Xen?

On the other hand, Xen should be able to use those legacy ranges
as normal memory. Why doesn't it work? Does Xen use a special
bootloader? In that case it could just add the reservation to
the e820 memory map that is provided.

Another possible approach to the whole problem is just to ammend
the e820 memory map in the boot-code. Thanks to hpa, it is now easy
to change this code. Then the kernel can just trust the e820 memory
map, and only 'sophisticated' bootloaders need to do something
similar by themselves.

Greetings,
    Alexander

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index a1d7071..e12cc31 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -385,15 +385,47 @@ unsigned long __init find_max_low_pfn(void)
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
+	if (lowmem >= 0x100000)
+		lowmem = 0xa0000;
+
+	/* reserve all memory between lowmem and the 1MB mark */
+	reserve_bootmem(lowmem, 0x100000 - lowmem, BOOTMEM_DEFAULT);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -619,16 +651,9 @@ void __init setup_bootmem_allocator(void)
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
