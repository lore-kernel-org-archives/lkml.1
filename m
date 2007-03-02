Return-Path: <linux-kernel-owner+w=401wt.eu-S1422738AbXCBCzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422738AbXCBCzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422734AbXCBCzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:55:22 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53719 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422733AbXCBCzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:55:04 -0500
Date: Thu, 1 Mar 2007 18:54:58 -0800
Message-Id: <200703020254.l222swlZ009676@zach-dev.vmware.com>
Subject: [PATCH 5/9] Paravirt drop udelay op
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: Pavel Machek <pavel@ucw.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-OriginalArrivalTime: 02 Mar 2007 02:55:01.0783 (UTC) FILETIME=[2C05EA70:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not respecting udelay causes problems with any virtual hardware that is
passed through to real hardware.  This can be noticed by any device that
interacts with the real world in real time - like AP startup, which takes
real time.  Or keyboard LEDs, which should blink in real-time.  Or floppy
drives, but only when passed through to a real floppy controller on OSes
which can't sufficiently buffer the floppy commands to emulate a zero
latency floppy.  Or IDE drives, when connecting to a physical CDROM.

This was mostly a hack to get the kernel to boot faster, but it introduced
a number of misvirtualization bugs, and Alan and Pavel argued pretty strongly
against it.  We were the only client, and now want to clean up this cruft.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 135d1b73c878 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Tue Feb 27 16:23:56 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Tue Feb 27 16:25:26 2007 -0800
@@ -538,7 +538,6 @@ struct paravirt_ops paravirt_ops = {
 
 	.set_iopl_mask = native_set_iopl_mask,
 	.io_delay = native_io_delay,
-	.const_udelay = __const_udelay,
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	.apic_write = native_apic_write,
diff -r 135d1b73c878 arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c	Tue Feb 27 16:23:56 2007 -0800
+++ b/arch/i386/kernel/smpboot.c	Tue Feb 27 16:27:16 2007 -0800
@@ -33,11 +33,6 @@
  *		Dave Jones	:	Report invalid combinations of Athlon CPUs.
 *		Rusty Russell	:	Hacked into shape for new "hotplug" boot process. */
 
-
-/* SMP boot always wants to use real time delay to allow sufficient time for
- * the APs to come online */
-#define USE_REAL_TIME_DELAY
-
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff -r 135d1b73c878 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Tue Feb 27 16:23:56 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Tue Feb 27 16:28:00 2007 -0800
@@ -48,7 +48,6 @@ typedef u64 __attribute__((regparm(2))) 
 
 static struct vrom_header *vmi_rom;
 static int license_gplok;
-static int disable_nodelay;
 static int disable_pge;
 static int disable_pse;
 static int disable_sep;
@@ -801,9 +800,6 @@ static inline int __init activate_vmi(vo
 
 	para_fill(set_iopl_mask, SetIOPLMask);
 	paravirt_ops.io_delay = (void *)vmi_nop;
-	if (!disable_nodelay) {
-		paravirt_ops.const_udelay = (void *)vmi_nop;
-	}
 
 	para_fill(set_lazy_mode, SetLazyMode);
 
@@ -947,9 +943,7 @@ static int __init parse_vmi(char *arg)
 	if (!arg)
 		return -EINVAL;
 
-	if (!strcmp(arg, "disable_nodelay"))
-		disable_nodelay = 1;
-	else if (!strcmp(arg, "disable_pge")) {
+	if (!strcmp(arg, "disable_pge")) {
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 		disable_pge = 1;
 	} else if (!strcmp(arg, "disable_pse")) {
diff -r 135d1b73c878 include/asm-i386/delay.h
--- a/include/asm-i386/delay.h	Tue Feb 27 16:23:56 2007 -0800
+++ b/include/asm-i386/delay.h	Tue Feb 27 16:26:01 2007 -0800
@@ -16,13 +16,6 @@ extern void __const_udelay(unsigned long
 extern void __const_udelay(unsigned long usecs);
 extern void __delay(unsigned long loops);
 
-#if defined(CONFIG_PARAVIRT) && !defined(USE_REAL_TIME_DELAY)
-#define udelay(n) paravirt_ops.const_udelay((n) * 0x10c7ul)
-
-#define ndelay(n) paravirt_ops.const_udelay((n) * 5ul)
-
-#else /* !PARAVIRT || USE_REAL_TIME_DELAY */
-
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
 #define udelay(n) (__builtin_constant_p(n) ? \
 	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
@@ -32,7 +25,6 @@ extern void __delay(unsigned long loops)
 #define ndelay(n) (__builtin_constant_p(n) ? \
 	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
 	__ndelay(n))
-#endif
 
 void use_tsc_delay(void);
 
diff -r 135d1b73c878 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Tue Feb 27 16:23:56 2007 -0800
+++ b/include/asm-i386/paravirt.h	Tue Feb 27 16:25:39 2007 -0800
@@ -117,7 +117,6 @@ struct paravirt_ops
 	void (*set_iopl_mask)(unsigned mask);
 
 	void (*io_delay)(void);
-	void (*const_udelay)(unsigned long loops);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
