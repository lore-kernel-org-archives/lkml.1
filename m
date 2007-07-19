Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbXGSLaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbXGSLaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbXGSLaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:30:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:39196 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbXGSLaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:30:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, caglar@pardus.org.tr,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH] i386: Allow KVM on i386 nonpae
Date: Thu, 19 Jul 2007 14:30:14 +0300
Message-Id: <11848446144085-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, CONFIG_X86_CMPXCHG64 both enables boot-time checking of
the cmpxchg64b feature and enables compilation of the set_64bit() family.
Since the option is dependent on PAE, and since KVM depends on set_64bit(),
this effectively disables KVM on i386 nopae.

Simplify by removing the config option altogether: the boot check is made
dependent on CONFIG_X86_PAE directly, and the set_64bit() family is exposed
without constraints.  It is up to users to check for the feature flag (KVM
does not as virtualiation extensions imply its existence).

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/i386/Kconfig.cpu b/arch/i386/Kconfig.cpu
index 9cbe76c..11a24d5 100644
--- a/arch/i386/Kconfig.cpu
+++ b/arch/i386/Kconfig.cpu
@@ -297,11 +297,6 @@ config X86_POPAD_OK
 	depends on !M386
 	default y
 
-config X86_CMPXCHG64
-	bool
-	depends on X86_PAE
-	default y
-
 config X86_ALIGNMENT_16
 	bool
 	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
diff --git a/arch/i386/defconfig b/arch/i386/defconfig
index 1a3a221..0ac62cd 100644
--- a/arch/i386/defconfig
+++ b/arch/i386/defconfig
@@ -166,7 +166,6 @@ CONFIG_X86_WP_WORKS_OK=y
 CONFIG_X86_INVLPG=y
 CONFIG_X86_BSWAP=y
 CONFIG_X86_POPAD_OK=y
-CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_GOOD_APIC=y
 CONFIG_X86_INTEL_USERCOPY=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
diff --git a/arch/um/defconfig b/arch/um/defconfig
index a25cd25..1e0f677 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -52,7 +52,6 @@ CONFIG_X86_WP_WORKS_OK=y
 CONFIG_X86_INVLPG=y
 CONFIG_X86_BSWAP=y
 CONFIG_X86_POPAD_OK=y
-CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_GOOD_APIC=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
 CONFIG_X86_TSC=y
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 33fa28a..2f661e5 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,7 +11,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
-	depends on X86_CMPXCHG64 || 64BIT
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/include/asm-i386/cmpxchg.h b/include/asm-i386/cmpxchg.h
index 7adcef0..64dcdf4 100644
--- a/include/asm-i386/cmpxchg.h
+++ b/include/asm-i386/cmpxchg.h
@@ -3,14 +3,16 @@
 
 #include <linux/bitops.h> /* for LOCK_PREFIX */
 
+/*
+ * Note: if you use set64_bit(), __cmpxchg64(), or their variants, you
+ *       you need to test for the feature in boot_cpu_data.
+ */
+
 #define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
-
-#ifdef CONFIG_X86_CMPXCHG64
-
 /*
  * The semantics of XCHGCMP8B are a bit strange, this is why
  * there is a loop and the loading of %%eax and %%edx has to
@@ -65,8 +67,6 @@ static inline void __set_64bit_var (unsigned long long *ptr,
  __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
  __set_64bit(ptr, ll_low(value), ll_high(value)) )
 
-#endif
-
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
  * Note 2: xchg has side effect, so that attribute volatile is necessary,
@@ -252,8 +252,6 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 })
 #endif
 
-#ifdef CONFIG_X86_CMPXCHG64
-
 static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
 				      unsigned long long new)
 {
@@ -289,5 +287,3 @@ static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
 	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
 					(unsigned long long)(n)))
 #endif
-
-#endif
diff --git a/include/asm-i386/required-features.h b/include/asm-i386/required-features.h
index 65848a0..618feb9 100644
--- a/include/asm-i386/required-features.h
+++ b/include/asm-i386/required-features.h
@@ -29,7 +29,7 @@
 # define NEED_CMOV	0
 #endif
 
-#ifdef CONFIG_X86_CMPXCHG64
+#ifdef CONFIG_X86_PAE
 # define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
 #else
 # define NEED_CX8	0
