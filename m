Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXEGLjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXEGLjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXEGLjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:39:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52207 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXEGLjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:39:08 -0400
Date: Mon, 7 May 2007 17:08:54 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Morton Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] x86_64: Display more intutive error message if kernel is not 2MB aligned
Message-ID: <20070507113854.GA4899@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



o x86_64 kernel needs to be compiled for 2MB aligned addresses. Currently
  we are using BUILD_BUG_ON() to warn the user if he has not done so. But
  looks like folks are not finding message very intutive and don't open
  the respective c file to find problem source. (Bug 8439)

arch/x86_64/kernel/head64.c: In function 'x86_64_start_kernel':
arch/x86_64/kernel/head64.c:70: error: size of array 'type name' is negative

o Using preprocessor directive #error to print a better message if
  CONFIG_PHYSICAL_START is not aligned to 2MB boundary. 

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 linux-2.6.21-rc7-mm2-root/arch/x86_64/kernel/head64.c |    7 -------
 linux-2.6.21-rc7-mm2-root/include/asm-x86_64/page.h   |    9 +++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/head64.c~x86_64-warn-if-kernel-is-not-2MB-aligned arch/x86_64/kernel/head64.c
--- linux-2.6.21-rc7-mm2/arch/x86_64/kernel/head64.c~x86_64-warn-if-kernel-is-not-2MB-aligned	2007-05-07 16:17:21.000000000 +0530
+++ linux-2.6.21-rc7-mm2-root/arch/x86_64/kernel/head64.c	2007-05-07 16:25:42.000000000 +0530
@@ -62,13 +62,6 @@ void __init x86_64_start_kernel(char * r
 {
 	int i;
 
-	/*
-	 * Make sure kernel is aligned to 2MB address. Catching it at compile
-	 * time is better. Change your config file and compile the kernel
-	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
-	 */
-	BUILD_BUG_ON(CONFIG_PHYSICAL_START & (__KERNEL_ALIGN - 1));
-
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
diff -puN include/asm-x86_64/page.h~x86_64-warn-if-kernel-is-not-2MB-aligned include/asm-x86_64/page.h
--- linux-2.6.21-rc7-mm2/include/asm-x86_64/page.h~x86_64-warn-if-kernel-is-not-2MB-aligned	2007-05-07 16:24:16.000000000 +0530
+++ linux-2.6.21-rc7-mm2-root/include/asm-x86_64/page.h	2007-05-07 16:25:29.000000000 +0530
@@ -80,6 +80,15 @@ extern unsigned long phys_base;
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000
+/*
+ * Make sure kernel is aligned to 2MB address. Catching it at compile
+ * time is better. Change your config file and compile the kernel
+ * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+ */
+#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
+#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
+#endif
+
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
 #define __PAGE_OFFSET           0xffff810000000000
_
