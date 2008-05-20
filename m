Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbYETO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbYETO0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbYETO0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:26:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49981 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbYETO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:26:23 -0400
Date: Tue, 20 May 2008 16:27:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: aperture_64: use symbolic constants
Message-ID: <20080520142717.GA22794@elf.ucw.cz>
References: <20080519123952.GA23118@elf.ucw.cz> <20080519125425.GD13546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519125425.GD13546@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > Use symbolic constants in aperture_64.c where possible (and make a 
> > comment slightly more helpful).
> 
> this code has already been changed in the latest -tip tree:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> iommu/gart code is covered by the tip/x86/gart subtopic, which carries 7 
> commits right now:

Thanks, I have a copy now. And this one is relative to it:

--- 

Factor-out common aperture_valid code.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 02f4dba..5373f78 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -109,27 +109,6 @@ static u32 __init allocate_aperture(void
 	return (u32)__pa(p);
 }
 
-static int __init aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
-{
-	if (!aper_base)
-		return 0;
-
-	if (aper_base + aper_size > 0x100000000UL) {
-		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
-		return 0;
-	}
-	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
-		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
-		return 0;
-	}
-	if (aper_size < min_size) {
-		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
-				 aper_size>>20, min_size>>20);
-		return 0;
-	}
-
-	return 1;
-}
 
 /* Find a PCI capability */
 static __u32 __init find_cap(int bus, int slot, int func, int cap)
@@ -344,7 +323,7 @@ out:
 	if (gart_fix_e820 && !fix && aper_enabled) {
 		if (!e820_all_mapped(aper_base, aper_base + aper_size,
 				    E820_RESERVED)) {
-			/* reserved it, so we can resuse it in second kernel */
+			/* reserve it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
 			add_memory_region(aper_base, aper_size, E820_RESERVED);
 			update_e820();
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index fea1313..3b53ea0 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -228,24 +228,10 @@ static const struct agp_bridge_driver am
 };
 
 /* Some basic sanity checks for the aperture. */
-static int __devinit aperture_valid(u64 aper, u32 size)
+static int __devinit agp_aperture_valid(u64 aper, u32 size)
 {
-	if (aper == 0) {
-		printk(KERN_ERR PFX "No aperture\n");
+	if (!aperture_valid(aper, size, 32*1024*1024))
 		return 0;
-	}
-	if ((u64)aper + size > 0x100000000ULL) {
-		printk(KERN_ERR PFX "Aperture out of bounds\n");
-		return 0;
-	}
-	if (e820_any_mapped(aper, aper + size, E820_RAM)) {
-		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
-		return 0;
-	}
-	if (size < 32*1024*1024) {
-		printk(KERN_ERR PFX "Aperture too small (%d MB)\n", size>>20);
-		return 0;
-	}
 
 	/* Request the Aperture. This catches cases when someone else
 	   already put a mapping in there - happens with some very broken BIOS
@@ -282,7 +268,7 @@ static __devinit int fix_northbridge(str
 	nb_order = (nb_order >> 1) & 7;
 	pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
 	nb_aper = nb_base << 25;
-	if (aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
+	if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
 		return 0;
 	}
 
@@ -313,7 +299,7 @@ static __devinit int fix_northbridge(str
 	}
 
 	printk(KERN_INFO PFX "Aperture from AGP @ %Lx size %u MB\n", aper, 32 << order);
-	if (order < 0 || !aperture_valid(aper, (32*1024*1024)<<order))
+	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
 
 	pci_write_config_dword(nb, AMD64_GARTAPERTURECTL, order << 1);
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 6f22786..854cf7f 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X8664_IOMMU_H
 #define _ASM_X8664_IOMMU_H 1
 
+#include <asm/e820.h>
+
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
@@ -69,4 +71,26 @@ static inline void enable_gart_translati
         pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
 
+static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
+{
+	if (!aper_base)
+		return 0;
+
+	if (aper_base + aper_size > 0x100000000ULL) {
+		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
+		return 0;
+	}
+	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
+		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
+		return 0;
+	}
+	if (aper_size < min_size) {
+		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
+				 aper_size>>20, min_size>>20);
+		return 0;
+	}
+
+	return 1;
+}
+
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
