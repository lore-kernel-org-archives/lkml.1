Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXEJTMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXEJTMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbXEJTMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:12:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755115AbXEJTL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:11:59 -0400
Date: Thu, 10 May 2007 12:11:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: florin@iucha.net (Florin Iucha)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: Current git fails to compile on AMD64 for three days in a row
Message-Id: <20070510121143.6172a8aa.akpm@linux-foundation.org>
In-Reply-To: <20070510151642.GH26751@iucha.net>
References: <20070510151642.GH26751@iucha.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 10:16:43 -0500 florin@iucha.net (Florin Iucha) wrote:

> I just pulled the current git (de5603748af8bf7deac403e6ba92887f8d18e812)
> and tried to compile it on my AMD64 box, to test Chuck's RPC fix.  It
> fails:
> 
>    arch/x86_64/kernel/head64.c: In function ‘x86_64_start_kernel’:
>    arch/x86_64/kernel/head64.c:70: error: size of array ‘type name’ is negative
> 
> It is failing in the same way since Monday.
> 

Yeah, about twelve zillion people are hitting that and none appear to look
at the source to work out why it blew up.

I'll fast-track this:



From: Vivek Goyal <vgoyal@in.ibm.com>

o x86_64 kernel needs to be compiled for 2MB aligned addresses. Currently
  we are using BUILD_BUG_ON() to warn the user if he has not done so. But
  looks like folks are not finding message very intutive and don't open
  the respective c file to find problem source. (Bug 8439)

arch/x86_64/kernel/head64.c: In function 'x86_64_start_kernel':
arch/x86_64/kernel/head64.c:70: error: size of array 'type name' is negative

o Using preprocessor directive #error to print a better message if
  CONFIG_PHYSICAL_START is not aligned to 2MB boundary.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/head64.c |    7 -------
 include/asm-x86_64/page.h   |    9 +++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/head64.c~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned
+++ a/arch/x86_64/kernel/head64.c
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
 
diff -puN include/asm-x86_64/page.h~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned
+++ a/include/asm-x86_64/page.h
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
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 #define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
_

