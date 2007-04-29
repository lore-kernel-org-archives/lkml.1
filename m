Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXD2LFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXD2LFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXD2LAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:52115 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbXD2KxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:13 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [23/48] i386: VDSO_PRELINK warning fix
Message-Id: <20070429105312.33E8015108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

The lguest patches somehow managed to trigger this:

In file included from arch/i386/lguest/lguest.c:38:
include/asm/asm-offsets.h:67:1: warning: "VDSO_PRELINK" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/device.h:21,
                 from include/linux/interrupt.h:15,
                 from arch/i386/lguest/lguest.c:27:
include/asm/elf.h:140:1: warning: this is the location of the previous definition

I assume that using the same identifier twice was a bad idea..

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/asm-offsets.c  |    2 +-
 arch/i386/kernel/vsyscall.lds.S |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux.orig/arch/i386/kernel/asm-offsets.c
+++ linux/arch/i386/kernel/asm-offsets.c
@@ -97,7 +97,7 @@ void foo(void)
 		 sizeof(struct tss_struct));
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-	DEFINE(VDSO_PRELINK, VDSO_PRELINK);
+	DEFINE(VDSO_PRELINK_asm, VDSO_PRELINK);
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
Index: linux/arch/i386/kernel/vsyscall.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vsyscall.lds.S
+++ linux/arch/i386/kernel/vsyscall.lds.S
@@ -7,7 +7,7 @@
 
 SECTIONS
 {
-  . = VDSO_PRELINK + SIZEOF_HEADERS;
+  . = VDSO_PRELINK_asm + SIZEOF_HEADERS;
 
   .hash           : { *(.hash) }		:text
   .gnu.hash       : { *(.gnu.hash) }
@@ -21,7 +21,7 @@ SECTIONS
      For the layouts to match, we need to skip more than enough
      space for the dynamic symbol table et al.  If this amount
      is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = VDSO_PRELINK + 0x400;
+  . = VDSO_PRELINK_asm + 0x400;
 
   .text           : { *(.text) }		:text =0x90909090
   .note		  : { *(.note.*) }		:text :note
