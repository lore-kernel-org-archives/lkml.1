Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYESNHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYESNHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYESNHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:07:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41065 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYESNHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:07:22 -0400
Date: Mon, 19 May 2008 15:08:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@codemonkey.org.uk>
Subject: factor out common parts of aperture_valid
Message-ID: <20080519130815.GA29023@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move duplicated parts of aperture_valid into gart.h.

This however brings some questions:

1) amd64-agp requires 32MB aperture, while aperture_64.c asks for
64MB. Is the difference valid, or is that some kind of mistake.

2) amd64-agp does request_mem_region "to protect from very broken
BIOSes". Should aperture_64.c do that, too?

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit e6aed5173490843d59f739b1f760ef611f201ff6
tree 507ac6c9908ccbbcbed56ef43a905bc59116c5f7
parent 4cc4fa2a3ff78277430201c74580e99bbaf7a1d0
author Pavel <pavel@amd.ucw.cz> Mon, 19 May 2008 15:06:58 +0200
committer Pavel <pavel@amd.ucw.cz> Mon, 19 May 2008 15:06:58 +0200

 arch/x86/kernel/aperture_64.c |   16 ++--------------
 drivers/char/agp/amd64-agp.c  |   16 +---------------
 include/asm-x86/gart.h        |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 6b3757e..885e498 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -85,22 +85,10 @@ static u32 __init allocate_aperture(void
 
 static int __init aperture_valid(u64 aper_base, u32 aper_size)
 {
-	if (!aper_base)
+	if (!__aperture_valid(aper_base, aper_size, 64*1024*1024))
 		return 0;
 
-	if (aper_base + aper_size > 0x100000000UL) {
-		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
-		return 0;
-	}
-	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
-		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
-		return 0;
-	}
-	if (aper_size < 64*1024*1024) {
-		printk(KERN_ERR "Aperture too small (%d MB)\n", aper_size>>20);
-		return 0;
-	}
-
+	/* Do we need to request_mem_region, like amd64-agp does? */
 	return 1;
 }
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 7e64c3c..858b9e8 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -227,23 +227,9 @@ static const struct agp_bridge_driver am
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-/* Some basic sanity checks for the aperture. */
 static int __devinit aperture_valid(u64 aper, u32 size)
 {
-	if (aper == 0) {
-		printk(KERN_ERR PFX "No aperture\n");
-		return 0;
-	}
-	if (size < 32*1024*1024) {
-		printk(KERN_ERR PFX "Aperture too small (%d MB)\n", size>>20);
-		return 0;
-	}
-       if ((u64)aper + size > 0x100000000ULL) {
-		printk(KERN_ERR PFX "Aperture out of bounds\n");
-		return 0;
-	}
-	if (e820_any_mapped(aper, aper + size, E820_RAM)) {
-		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
+	if (!__aperture_valid(aper, size, 32*1024*1024)) {
 		return 0;
 	}
 
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 6f22786..f37d83b 100644
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
@@ -69,4 +71,27 @@ static inline void enable_gart_translati
         pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
 
+static inline int __aperture_valid(u64 aper, u32 size, u32 min_size)
+{
+	if (aper == 0) {
+		printk(KERN_ERR "No aperture\n");
+		return 0;
+	}
+	if (size < min_size) {
+		printk(KERN_ERR "Aperture too small (%d MB)\n", size>>20);
+		return 0;
+	}
+	if (aper + size > 0x100000000ULL) {
+		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
+		return 0;
+	}
+	if (e820_any_mapped(aper, aper + size, E820_RAM)) {
+		printk(KERN_ERR "Aperture pointing to RAM\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
