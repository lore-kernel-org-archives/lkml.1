Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbXLMJVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbXLMJVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXLMJVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:21:23 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:55818 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXLMJVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:21:22 -0500
Date: Thu, 13 Dec 2007 12:21:23 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [patch] alpha: build fixes
Message-ID: <20071213122123.D21124@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some of the alpha-specific build problems, except a) modpost
warning about COMMON symbol "saved_config" and b) nasty final link
failure with gcc-4.x, -Os and scsi-disk driver configured built-in
(due to jump table in .rodata referencing discarded .exit.text).

- build failure with gcc-4.2.x: fix up casts in cia_io* routines to avoid
  warnings ('discards qualifiers from pointer target type'), which are
  failures, thanks to -Werror;
- modpost warnings: add missing __init qualifier for titan and marvel;
  for non-generic build, move machine vectors from .data to .data.init.refok
  section;
- unbreak CPU-specific optimization: rearrange cpuflags-y assignments
  so that extended -mcpu value (ev56, pca56, ev67) overrides basic
  one (ev5, ev6) and not vice versa.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.

--- 2.6.24-rc5/arch/alpha/Makefile	2007-12-04 13:08:46.000000000 +0300
+++ linux/arch/alpha/Makefile	2007-12-04 13:24:22.000000000 +0300
@@ -14,13 +14,13 @@ LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
 cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
 
-cpuflags-$(CONFIG_ALPHA_EV67)		:= -mcpu=ev67
-cpuflags-$(CONFIG_ALPHA_EV6)		:= -mcpu=ev6
+cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
+cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
+cpuflags-$(CONFIG_ALPHA_EV56)		:= -mcpu=ev56
 cpuflags-$(CONFIG_ALPHA_POLARIS)	:= -mcpu=pca56
 cpuflags-$(CONFIG_ALPHA_SX164)		:= -mcpu=pca56
-cpuflags-$(CONFIG_ALPHA_EV56)		:= -mcpu=ev56
-cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
-cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
+cpuflags-$(CONFIG_ALPHA_EV6)		:= -mcpu=ev6
+cpuflags-$(CONFIG_ALPHA_EV67)		:= -mcpu=ev67
 # If GENERIC, make sure to turn off any instruction set extensions that
 # the host compiler might have on by default.  Given that EV4 and EV5
 # have the same instruction set, prefer EV5 because an EV5 schedule is
--- 2.6.24-rc5/include/asm-alpha/io_trivial.h	2007-10-10 00:31:38.000000000 +0400
+++ linux/include/asm-alpha/io_trivial.h	2007-12-04 14:30:13.000000000 +0300
@@ -72,25 +72,29 @@ IO_CONCAT(__IO_PREFIX,writew)(u16 b, vol
 __EXTERN_INLINE u8
 IO_CONCAT(__IO_PREFIX,readb)(const volatile void __iomem *a)
 {
-	return IO_CONCAT(__IO_PREFIX,ioread8)((void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	return IO_CONCAT(__IO_PREFIX,ioread8)(addr);
 }
 
 __EXTERN_INLINE u16
 IO_CONCAT(__IO_PREFIX,readw)(const volatile void __iomem *a)
 {
-	return IO_CONCAT(__IO_PREFIX,ioread16)((void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	return IO_CONCAT(__IO_PREFIX,ioread16)(addr);
 }
 
 __EXTERN_INLINE void
 IO_CONCAT(__IO_PREFIX,writeb)(u8 b, volatile void __iomem *a)
 {
-	IO_CONCAT(__IO_PREFIX,iowrite8)(b, (void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	IO_CONCAT(__IO_PREFIX,iowrite8)(b, addr);
 }
 
 __EXTERN_INLINE void
 IO_CONCAT(__IO_PREFIX,writew)(u16 b, volatile void __iomem *a)
 {
-	IO_CONCAT(__IO_PREFIX,iowrite16)(b, (void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	IO_CONCAT(__IO_PREFIX,iowrite16)(b, addr);
 }
 #endif
 
--- 2.6.24-rc5/arch/alpha/kernel/err_marvel.c	Thu Dec  6 14:33:58 2007
+++ linux/arch/alpha/kernel/err_marvel.c	Thu Dec  6 20:14:17 2007
@@ -1152,7 +1152,7 @@ marvel_machine_check(u64 vector, u64 la_
 	mb();
 }
 
-void
+void __init
 marvel_register_error_handlers(void)
 {
 	ev7_register_error_handlers();
--- 2.6.24-rc5/arch/alpha/kernel/machvec_impl.h	Wed Oct 10 00:31:38 2007
+++ linux/arch/alpha/kernel/machvec_impl.h	Thu Dec  6 12:14:57 2007
@@ -134,7 +134,7 @@
 #define __initmv __initdata
 #define ALIAS_MV(x)
 #else
-#define __initmv
+#define __initmv __initdata_refok
 
 /* GCC actually has a syntax for defining aliases, but is under some
    delusion that you shouldn't be able to declare it extern somewhere
--- 2.6.24-rc5/arch/alpha/kernel/err_titan.c	Thu Dec  6 02:11:54 2007
+++ linux/arch/alpha/kernel/err_titan.c	Thu Dec  6 20:03:15 2007
@@ -564,7 +564,7 @@ static struct el_subpacket_handler titan
 	SUBPACKET_HANDLER_INIT(EL_CLASS__REGATTA_FAMILY, 
 			       el_process_regatta_subpacket);
 
-void
+void __init
 titan_register_error_handlers(void)
 {
 	size_t i;
--- 2.6.24-rc5/arch/alpha/kernel/err_ev7.c	Wed Oct 10 00:31:38 2007
+++ linux/arch/alpha/kernel/err_ev7.c	Thu Dec  6 20:02:28 2007
@@ -273,7 +273,7 @@ ev7_process_pal_subpacket(struct el_subp
 struct el_subpacket_handler ev7_pal_subpacket_handler =
 	SUBPACKET_HANDLER_INIT(EL_CLASS__PAL, ev7_process_pal_subpacket);
 
-void
+void __init
 ev7_register_error_handlers(void)
 {
 	int i;
