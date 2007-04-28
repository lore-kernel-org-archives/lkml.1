Return-Path: <linux-kernel-owner+w=401wt.eu-S1163379AbXD1SCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163379AbXD1SCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163354AbXD1SBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:39025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163356AbXD1R7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:08 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [20/22] x86_64: build-time checking
Message-Id: <20070428175908.019A7151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>

o X86_64 kernel should run from 2MB aligned address for two reasons.
	- Performance.
	- For relocatable kernels, page tables are updated based on difference
	  between compile time address and load time physical address.
	  This difference should be multiple of 2MB as kernel text and data
	  is mapped using 2MB pages and PMD should be pointing to a 2MB
	  aligned address. Life is simpler if both compile time and load time
	  kernel addresses are 2MB aligned.

o Flag the error at compile time if one is trying to build a kernel which
  does not meet alignment restrictions.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/boot/compressed/misc.c |    2 +-
 arch/x86_64/kernel/head64.c        |    7 +++++++
 include/asm-x86_64/page.h          |    1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/boot/compressed/misc.c
===================================================================
--- linux.orig/arch/x86_64/boot/compressed/misc.c
+++ linux/arch/x86_64/boot/compressed/misc.c
@@ -358,7 +358,7 @@ asmlinkage void decompress_kernel(void *
 	insize = input_len;
 	inptr  = 0;
 
-	if ((ulg)output & 0x1fffffUL)
+	if ((ulg)output & (__KERNEL_ALIGN - 1))
 		error("Destination address not 2M aligned");
 	if ((ulg)output >= 0xffffffffffUL)
 		error("Destination address too large");
Index: linux/arch/x86_64/kernel/head64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/head64.c
+++ linux/arch/x86_64/kernel/head64.c
@@ -62,6 +62,13 @@ void __init x86_64_start_kernel(char * r
 {
 	int i;
 
+	/*
+	 * Make sure kernel is aligned to 2MB address. Catching it at compile
+	 * time is better. Change your config file and compile the kernel
+	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+	 */
+	BUILD_BUG_ON(CONFIG_PHYSICAL_START & (__KERNEL_ALIGN - 1));
+
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
Index: linux/include/asm-x86_64/page.h
===================================================================
--- linux.orig/include/asm-x86_64/page.h
+++ linux/include/asm-x86_64/page.h
@@ -78,6 +78,7 @@ extern unsigned long phys_base;
 #endif /* !__ASSEMBLY__ */
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
+#define __KERNEL_ALIGN		0x200000
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
 #define __PAGE_OFFSET           0xffff810000000000
