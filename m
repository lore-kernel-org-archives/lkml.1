Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYB2Lxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYB2Lxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYB2Lxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:53:34 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:24751 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYB2Lxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:53:33 -0500
Date: Fri, 29 Feb 2008 12:49:43 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
Message-ID: <20080229114943.GA1909@mailshack.com>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Fri, 29 Feb 2008 12:52:19 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.67; VDF: 7.0.2.211; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds explicit detection of the EBDA and reservation
of the rom and adapter address space 0xa0000-0x100000 to the
i386 kernels. It uses reserve_bootmem instead of reserve_early,
because reserve_early is not yet available on i386.

Before this patch, the EBDA size was hardcoded as 4Kb. Also, the 
reservation of the adapter range was done by modifying the e820
map which is now not necessary any longer, and the code is removed
from copy_e820_map.

The changes in e820_64.c are only a change in the comment above
copy_e820_map, and some changes of the types of local variables
in that function such that the 32 and 64 bit versions become equal.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Thu, Feb 28, 2008 at 09:09:56PM +0000, Ian Campbell wrote:
> On Thu, 2008-02-28 at 14:13 +0100, Alexander van Heukelum wrote:
> > The 32-bit code still uses reserve_bootmem, so this is not really
> > a unification with the 64-bit version of the ebda reservation code,
> > but at least it provides the same detection logic and reserves the
> > same areas.
> > 
> > This does not crash immediately on qemu. No further testing was
> > done! Otherwise:
> 
> I haven't tested extensively either but it does seem to solve the
> problem for Xen.
> 
> Thanks!
> Ian

Thank you!

Ingo,

I think this is ready for -x86#testing.
It boots to a small userspace in qemu (i386).
If I should separate the cleanups, let me know.

Greetings,
    Alexander

 arch/x86/kernel/e820_32.c  |   30 +++++++-------------------
 arch/x86/kernel/e820_64.c  |   15 +++++++++---
 arch/x86/kernel/setup_32.c |   51 ++++++++++++++++++++++++++++++++-----------
 3 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/e820_32.c b/arch/x86/kernel/e820_32.c
index 4e16ef4..8ea7db2 100644
--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -444,44 +444,30 @@ int __init sanitize_e820_map(struct e820entry * biosmap, char * pnr_map)
  * set up memory.  If we aren't, we'll fake a memory map.
  *
  * We check to see that the memory map contains at least 2 elements
- * before we'll use it, because the detection code in setup.S may
- * not be perfect and most every PC known to man has two memory
+ * before we'll use it, because the detection code in boot/memory.c
+ * may not be perfect and every PC known to man has two memory
  * regions: one from 0 to 640k, and one from 1mb up.  (The IBM
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
 	return 0;
 }
 
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index dd68cfd..e7f0400 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -613,6 +613,13 @@ static int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map)
  * If we're lucky and live on a modern system, the setup code
  * will have given us a memory map that we can use to properly
  * set up memory.  If we aren't, we'll fake a memory map.
+ *
+ * We check to see that the memory map contains at least 2 elements
+ * before we'll use it, because the detection code in boot/memory.c
+ * may not be perfect and every PC known to man has two memory
+ * regions: one from 0 to 640k, and one from 1mb up.  (The IBM
+ * thinkpad 560x, for example, does not cooperate with the memory
+ * detection code.)
  */
 static int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
 {
@@ -621,10 +628,10 @@ static int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
 		return -1;
 
 	do {
-		unsigned long start = biosmap->addr;
-		unsigned long size = biosmap->size;
-		unsigned long end = start + size;
-		unsigned long type = biosmap->type;
+		u64 start = biosmap->addr;
+		u64 size = biosmap->size;
+		u64 end = start + size;
+		u32 type = biosmap->type;
 
 		/* Overflow in 64 bits? Ignore the memory map. */
 		if (start > end)
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
