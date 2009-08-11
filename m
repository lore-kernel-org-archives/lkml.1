Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZHKMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZHKMRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZHKMRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:17:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:23738 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZHKMRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,359,1246863600"; 
   d="scan'208";a="715687324"
Date: Tue, 11 Aug 2009 15:48:50 +0800
From: Feng Tang <feng.tang@intel.com>
To: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH]x86/RTC: introduce a new generic rtc_ops for x86
Message-ID: <20090811154850.3127fff0@feng-desktop>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please help to review this patch, thanks!

It is generated against kernel 2.6.31-rc5 

- Feng

>From a8ee2a78bcc1df57f2f43ff526269d69a2801a64 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 17 Jun 2009 10:31:17 +0800
Subject: [PATCH] x86/RTC: introduce a new generic rtc_ops for x86

System time keeping needs get_wallclock/set_wallclock supports,
currently this support comes from Motorola 146818 like RTC device
or EFI, or even virtualization, but in the future, there will be
other x86 platforms which don't have these options and have their
own RTC devices other than the 146818. So a more generic structure
is needed to support all platforms' need

This patch adds a arch_rtc_ops structure, which only has 2 API
pointers of get/set wall clock, each platform can register its own
desired RTC ops to be the one to use

Current patch only modifies the rtc.c and efi.c to incorporate
this change, further on we can think about to use it for the
paravirt code, which could make the asm/time.h much cleaner

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/time.h |   45 +++++++++++-------------------------------
 arch/x86/kernel/efi.c       |   12 +++++++++++
 arch/x86/kernel/rtc.c       |    5 ++++
 3 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
index 50c733a..3665a9c 100644
--- a/arch/x86/include/asm/time.h
+++ b/arch/x86/include/asm/time.h
@@ -1,53 +1,32 @@
 #ifndef _ASM_X86_TIME_H
 #define _ASM_X86_TIME_H
 
+#include <asm/mc146818rtc.h>
+
 extern void hpet_time_init(void);
+extern void time_init(void);
 
-#include <asm/mc146818rtc.h>
-#ifdef CONFIG_X86_32
-#include <linux/efi.h>
+struct arch_rtc_dev_ops {
+	unsigned long	(*get_wall_time)(void);
+	int		(*set_wall_time)(unsigned long);
+};
+extern struct arch_rtc_dev_ops *x86_rtc_ops;
 
 static inline unsigned long native_get_wallclock(void)
 {
-	unsigned long retval;
-
-	if (efi_enabled)
-		retval = efi_get_time();
-	else
-		retval = mach_get_cmos_time();
-
-	return retval;
+	return x86_rtc_ops->get_wall_time();
 }
 
 static inline int native_set_wallclock(unsigned long nowtime)
 {
-	int retval;
-
-	if (efi_enabled)
-		retval = efi_set_rtc_mmss(nowtime);
-	else
-		retval = mach_set_rtc_mmss(nowtime);
-
-	return retval;
+	return x86_rtc_ops->set_wall_time(nowtime);
 }
 
-#else
-extern void native_time_init_hook(void);
-
-static inline unsigned long native_get_wallclock(void)
-{
-	return mach_get_cmos_time();
-}
-
-static inline int native_set_wallclock(unsigned long nowtime)
+static inline void register_rtc_ops(struct arch_rtc_dev_ops *ops)
 {
-	return mach_set_rtc_mmss(nowtime);
+	x86_rtc_ops = ops;
 }
 
-#endif
-
-extern void time_init(void);
-
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else /* !CONFIG_PARAVIRT */
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 96f7ac0..67ec1a6 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -224,6 +224,15 @@ unsigned long efi_get_time(void)
 		      eft.minute, eft.second);
 }
 
+static struct arch_rtc_dev_ops efi_rtc_ops = {
+	.get_wall_time = efi_get_time,
+	.set_wall_time = efi_set_rtc_mmss,
+};
+
+static void efi_wall_time_init(void)
+{
+	register_rtc_ops(&efi_rtc_ops);
+}
 /*
  * Tell the kernel about the EFI memory map.  This might include
  * more than the max 128 entries that can fit in the e820 legacy
@@ -453,6 +462,9 @@ void __init efi_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	/* use efi to get/set hw time */
+	efi_wall_time_init();
+
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;
 
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 5d465b2..b906a18 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -200,6 +200,11 @@ unsigned long long native_read_tsc(void)
 }
 EXPORT_SYMBOL(native_read_tsc);
 
+struct arch_rtc_dev_ops rtc_ops = {
+	.get_wall_time = mach_get_cmos_time,
+	.set_wall_time = mach_set_rtc_mmss,
+};
+struct arch_rtc_dev_ops *x86_rtc_ops = &rtc_ops;
 
 static struct resource rtc_resources[] = {
 	[0] = {
-- 
1.5.6.3
