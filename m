Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbZJINsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbZJINsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZJINsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:48:52 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62628 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760835AbZJINsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=wYtAvoFIWjc6Rs4S2ipBeg0Dus3tt0UHnAad7Q7i5uzozmxB5or4YC+cW5Z/Xm6Hzq
         KUZHFCNcevSLmgnT8eI5COtqhnyxhioV2qZml3RDK3aiOjzaurS/wuyx4QpEvBH0Hca3
         +xBCWv8eFrmlf4mHqRxoONN50j56hX43WBvFU=
Message-ID: <4ACF3F10.9040907@tuffmail.co.uk>
Date: Fri, 09 Oct 2009 14:48:00 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: unexport symbols used to implement floating point emulation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Same deal as before - I'd like to have your Acked-by on this patch so I
can submit it as part of a series to Rusty.   It should be the last
ARM-specific issue, although I haven't finished the series yet so I
could be wrong.

This time I removed the the offending feature, since it appears unused. 
I'm hoping you can confirm this :-).

While I was looking, I found a few other cleanup opportunities.  They're
independent from my needs, so I'll submit them separately for inclusion
in the ARM tree.

Thanks
Alan

-------------------------------->
>From 9fcf8cc0417c601171ccee83598310eea69b90a9 Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Fri, 9 Oct 2009 13:35:13 +0100
Subject: [PATCH] ARM: unexport symbols used to implement floating point emulation

The Kconfig for in-tree floating point emulation does not allow building
as a module. That leaves the Acorn FPEmulator module. I found two public
releases of this as a binary module for 2.1 and 2.2 kernels.[1] If there
is a resurgence of interest in this, the symbols can always be exported
again.

The real purpose here is to remove the EXPORT_SYMBOL_ALIAS() hack.
EXPORT_SYMBOL_ALIAS() makes it harder to sort the resulting kernel
symbol tables.  Sorted symbol tables will allow for faster symbol
resolution during module loading.


Note that fp_send_sigs() and fp_printk() are simply aliases for existing
exports and add no obvious value.  Similarly fp_enter could easily be
renamed to kern_fp_enter at the point of definition.  So removing
EXPORT_SYMBOL_ALIAS() would not serve as a material obstacle to
re-adding these exports in future.

Build tested only.

[1] http://ftp.arm.linux.org.uk/pub/linux/arm/fpemulator/

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
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



