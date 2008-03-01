Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbYCAQOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbYCAQOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYCAQOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:14:30 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:3005 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbYCAQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:14:29 -0500
Date: Sat, 1 Mar 2008 17:12:43 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Ian Campbell <ijc@hellion.org.uk>, Mark McLoughlin <markmc@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 64-bit add-on
Message-ID: <20080301161243.GA13301@mailshack.com>
References: <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <1204232996.28798.8.camel@cthulhu.hellion.org.uk> <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com> <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301160911.GA13271@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sat, 01 Mar 2008 17:13:21 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.2.215; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an add-on to the 64-bit ebda patch. It makes
the functions reserve_ebda_region (renamed from reserve_ebda)
and copy_e820_map equal to the 32-bit versions of the previous
patch.

Changes:

Use u64 and u32 for local variables in copy_e820_map.

The amount of conventional memory and the start of the EBDA are
detected by reading the BIOS data area directly. Paravirtual
environments do not provide this area, so we bail out early
in that case. They will just have to set up a correct memory
map to start with.

Add a safety net for zeroed out BIOS data area.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

diff --git a/arch/x86/kernel/e820_32.c b/arch/x86/kernel/e820_32.c
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index dd68cfd..baa4223 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -621,10 +621,10 @@ static int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
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
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b684552..269a6b4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -55,12 +55,30 @@ static void __init copy_bootdata(char *real_mode_data)
 /*
  * The BIOS places the EBDA/XBDA at the top of conventional
  * memory, and usually decreases the reported amount of
- * conventional memory (int 0x12) too.
+ * conventional memory (int 0x12) too. This also contains a
+ * workaround for Dell systems that neglect to reserve EBDA.
+ * The same workaround also avoids a problem with the AMD768MPX
+ * chipset: reserve a page before VGA to prevent PCI prefetch
+ * into it (errata #56). Usually the page is reserved anyways,
+ * unless you have no PS/2 mouse plugged in.
  */
-static __init void reserve_ebda(void)
+static void __init reserve_ebda_region(void)
 {
 	unsigned int lowmem, ebda_addr;
 
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
 	/* end of low (conventional) memory */
 	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
 	lowmem <<= 10;
@@ -80,8 +98,8 @@ static __init void reserve_ebda(void)
 		lowmem = 0x9f000;
 
 	/* Paranoia: should never happen, but... */
-	if (lowmem >= 0x100000)
-		lowmem = 0xa0000;
+	if ((lowmem == 0) || (lowmem >= 0x100000))
+		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
 	reserve_early(lowmem, 0x100000, "BIOS reserved");
@@ -140,7 +158,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 
-	reserve_ebda();
+	reserve_ebda_region();
 
 	/*
 	 * At this point everything still needed from the boot loader
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
