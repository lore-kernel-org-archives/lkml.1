Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYFOLcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYFOLcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 07:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbYFOLcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 07:32:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39927 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbYFOLcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 07:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mogR0VLNRBVKSq7p5yBEjNEvubV3XtLvlAqUYos4n/PJcKTySbZ/BY4L7+xd5As5zx
         AweYUONf3GZveMxGeBQEbyMKcXCwgPVcACuDYxxmrTm7hzDc45bRl9zWAo60KF4/mfR8
         57ty8/ZQqKdHFH0DTHonX6E/VmxJe8Wpv+LeY=
Message-ID: <6278d2220806150432i6f8265bfra7d0e5ff6e130303@mail.gmail.com>
Date: Sun, 15 Jun 2008 12:32:15 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [2.6.26-rc6] section/warning fixes...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes [2] some warnings [1] introduced in recent -rc series; please apply.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

--- [1]

WARNING: arch/x86/mm/built-in.o(.text+0x3a1): Section mismatch in
reference from the function set_pte_phys() to the function
.init.text:spp_getpage()
The function set_pte_phys() references
the function __init spp_getpage().
This is often because set_pte_phys lacks a __init
annotation or the annotation of spp_getpage is wrong.

arch/x86/mm/init_64.c: In function 'early_memtest':
arch/x86/mm/init_64.c:520: warning: passing argument 2 of
'find_e820_area_size' from incompatible pointer type

--- [2]

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 156e6d7..f6d20be 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -135,7 +135,7 @@ static __init void *spp_getpage(void)
 	return ptr;
 }

-static void
+static __init void
 set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 {
 	pgd_t *pgd;
@@ -214,7 +214,7 @@ void __init cleanup_highmap(void)
 }

 /* NOTE: this is meant to be run only at boot */
-void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
+void __init __set_fixmap(enum fixed_addresses idx, unsigned long
phys, pgprot_t prot)
 {
 	unsigned long address = __fix_to_virt(idx);

@@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);

 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	u64 t_start, t_size;
+	unsigned long t_start, t_size;
 	unsigned pattern;

 	if (!memtest_pattern)
@@ -525,7 +525,7 @@ static void __init early_memtest(unsigned long
start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;

-			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
+			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
 				t_start, t_start + t_size, pattern);

 			memtest(t_start, t_size, pattern);
-- 
Daniel J Blueman
