Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZKCKHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZKCKHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZKCKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:07:38 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:58149 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbZKCKHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:07:36 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: greg@kroah.com
Cc: linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 02/10] ARM: unexport symbols used to implement floating point emulation
Date: Tue,  3 Nov 2009 10:06:14 +0000
Message-Id: <1257242782-10496-3-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfigs for in-tree floating point emulation do not allow building
as modules. That leaves the Acorn FPEmulator module. I found two public
releases of this as a binary module for 2.1 and 2.2 kernels, optimized
for ARMV4.[1] If there is a resurgence of interest in this, the symbols
can always be re-exported.

This allows the EXPORT_SYMBOL_ALIAS() hack to be removed. The ulterior
motive here is that EXPORT_SYMBOL_ALIAS() makes it harder to sort the
resulting kernel symbol tables.  Sorted symbol tables will allow faster
symbol resolution during module loading.

Note that fp_send_sigs() and fp_printk() are simply aliases for existing
exports and add no obvious value.  Similarly fp_enter could easily be
renamed to kern_fp_enter at the point of definition. Therefore removing
EXPORT_SYMBOL_ALIAS will not serve as a material obstacle to re-adding
the exports should they be desired in future.

Build tested only.

[1] http://ftp.arm.linux.org.uk/pub/linux/arm/fpemulator/

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/armksyms.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 0e62770..8214bfe 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -48,27 +48,7 @@ extern void __aeabi_uidivmod(void);
 extern void __aeabi_ulcmp(void);
 
 extern void fpundefinstr(void);
-extern void fp_enter(void);
 
-/*
- * This has a special calling convention; it doesn't
- * modify any of the usual registers, except for LR.
- */
-#define EXPORT_CRC_ALIAS(sym) __CRC_SYMBOL(sym, "")
-
-#define EXPORT_SYMBOL_ALIAS(sym,orig)		\
- EXPORT_CRC_ALIAS(sym)				\
- static const struct kernel_symbol __ksymtab_##sym	\
-  __used __attribute__((section("__ksymtab"))) =	\
-    { (unsigned long)&orig, #sym };
-
-/*
- * floating point math emulator support.
- * These symbols will never change their calling convention...
- */
-EXPORT_SYMBOL_ALIAS(kern_fp_enter,fp_enter);
-EXPORT_SYMBOL_ALIAS(fp_printk,printk);
-EXPORT_SYMBOL_ALIAS(fp_send_sig,send_sig);
 
 EXPORT_SYMBOL(__backtrace);
 
-- 
1.6.3.2

