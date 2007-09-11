Return-Path: <linux-kernel-owner+w=401wt.eu-S966889AbXIKUSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966889AbXIKUSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934091AbXIKUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:10:27 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:53548 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764253AbXIKUKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=Z4b+jxSXZVZqJ2uFcRdRKj/epU3MqJjQS9ph0NMdkOqu8149eawLCnijPGMDw65F5WXNNdKxdAsKkV9hDZEFSL2OL7XPV+TCZ5DvORIQuZmMugKXaj5RR6g+Iv3ZtydvZ33FddTFtVU5Wp3jy3Yml/AbMu6pjl61Sm23v/Vj21k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/4] build system: section garbage collection for vmlinux
Date: Tue, 11 Sep 2007 21:10:14 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <200709112107.53155.vda.linux@googlemail.com>
In-Reply-To: <200709112107.53155.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mYv5GsLW+Px+OPm"
Message-Id: <200709112110.14270.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mYv5GsLW+Px+OPm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch fixes x86_64 vdso image so that it builds with --gc-sections.

Then it fixes comment in arch/i386/kernel/vmlinux.lds.S
and adds comments to other linker scripts about .bss.

Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_mYv5GsLW+Px+OPm
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.2.lds.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.2.lds.patch"

--- linux-2.6.23-rc4.gc1/arch/x86_64/vdso/vdso.lds.S	Sat Sep  8 22:06:52 2007
+++ linux-2.6.23-rc4.gc2/arch/x86_64/vdso/vdso.lds.S	Sat Sep  8 22:07:05 2007
@@ -26,11 +26,11 @@
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
 
-  .text           : { *(.text) }		:text
+  .text           : { *(.text) *(.text.*) }	:text
   .ptr.text       : { *(.ptr.text) }		:text
   . = VDSO_PRELINK + 0x900;
-  .data           : { *(.data) }		:text
-  .bss            : { *(.bss) }			:text
+  .data           : { *(.data) *(.data.*) }	:text
+  .bss            : { *(.bss) *(.bss.*) }	:text
 
   .altinstructions : { *(.altinstructions) }			:text
   .altinstr_replacement  : { *(.altinstr_replacement) }	:text
diff -urpN linux-2.6.23-rc4.gc1/arch/i386/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc2/arch/i386/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc1/arch/i386/kernel/vmlinux.lds.S	2007-09-10 18:54:38.000000000 +0100
+++ linux-2.6.23-rc4.gc2/arch/i386/kernel/vmlinux.lds.S	2007-09-10 19:09:24.000000000 +0100
@@ -2,17 +2,10 @@
  * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
  *
  * Don't define absolute symbols until and unless you know that symbol
- * value is should remain constant even if kernel image is relocated
+ * value should remain constant even if kernel image is relocated
  * at run time. Absolute symbols are not relocated. If symbol value should
- * change if kernel is relocated, make the symbol section relative and
- * put it inside the section definition.
- */
-
-/* Don't define absolute symbols until and unless you know that symbol
- * value is should remain constant even if kernel image is relocated
- * at run time. Absolute symbols are not relocated. If symbol value should
- * change if kernel is relocated, make the symbol section relative and
- * put it inside the section definition.
+ * change if kernel is relocated, make the symbol section relative
+ * by putting it inside the section definition.
  */
 #define LOAD_OFFSET __PAGE_OFFSET
 
@@ -192,6 +185,9 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
+        /* We must use .bss.xxx section names for zero-initialized sections
+         * we want to combine into bss, otherwise gcc does not set
+         * 'nobits' flag for the section, and it cannot be merged into bss. */
 	*(.bss.k.page_aligned)
 	*(.bss)
 	. = ALIGN(4);
diff -urpN linux-2.6.23-rc4.gc1/arch/sh/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc2/arch/sh/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc1/arch/sh/kernel/vmlinux.lds.S	2007-09-10 18:54:38.000000000 +0100
+++ linux-2.6.23-rc4.gc2/arch/sh/kernel/vmlinux.lds.S	2007-09-10 19:09:24.000000000 +0100
@@ -104,6 +104,9 @@ SECTIONS
   .bss : {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
+        /* We must use .bss.xxx section names for zero-initialized sections
+         * we want to combine into bss, otherwise gcc does not set
+         * 'nobits' flag for the section, and it cannot be merged into bss. */
   	*(.bss.k.page_aligned)
   	*(.bss)
 	. = ALIGN(4);
diff -urpN linux-2.6.23-rc4.gc1/arch/xtensa/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc2/arch/xtensa/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc1/arch/xtensa/kernel/vmlinux.lds.S	2007-09-10 18:54:38.000000000 +0100
+++ linux-2.6.23-rc4.gc2/arch/xtensa/kernel/vmlinux.lds.S	2007-09-10 19:09:24.000000000 +0100
@@ -255,6 +255,9 @@ SECTIONS
 
   /* BSS section */
   _bss_start = .;
+  /* We must use .bss.xxx section names for zero-initialized sections
+   * we want to combine into bss, otherwise gcc does not set
+   * 'nobits' flag for the section, and it cannot be merged into bss. */
   .bss : { *(.bss.k.page_aligned) *(.bss) }
   _bss_end = .;
 

--Boundary-00=_mYv5GsLW+Px+OPm--
