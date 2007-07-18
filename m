Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbXGRQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbXGRQev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXGRQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:34:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:45315 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761AbXGRQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:34:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, caglar@pardus.org.tr, andi@firstfloor.org,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH] i386: Decouple PAE from CONFIG_CMPXCHG64
Date: Wed, 18 Jul 2007 19:34:47 +0300
Message-Id: <11847764879-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9d9bbd4d247a674deb43565582151acdc22e90d1 makes CONFIG_CMPXCHG64
dependent on CONFIG_HIGHMEM64G, but KVM guest SMP support now also
requires CMPXCHG64 while not being tied to PAE.  So the effect of that patch
is to disable KVM on non-PAE configs.

Untangle those dependencies by:
 - having KVM select CMPXCHG64
 - having HIGHMEM64G select CMPXCHG64_REQUIRED, a variant that also
   checks for the feature at early boot

No processors that support KVM exist that also do not support CMPXCHG64,
so no additional check is necessary.  This setup allows for a single kernel
that will boot on i486 and also support KVM if available.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index c7c9c2a..d894cb2 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -542,6 +542,7 @@ config HIGHMEM4G
 config HIGHMEM64G
 	bool "64GB"
 	depends on !M386 && !M486
+	select X86_CMPXCHG64_REQUIRED
 	help
 	  Select this if you have a 32-bit processor and more than 4
 	  gigabytes of physical RAM.
diff --git a/arch/i386/Kconfig.cpu b/arch/i386/Kconfig.cpu
index 9cbe76c..e11870b 100644
--- a/arch/i386/Kconfig.cpu
+++ b/arch/i386/Kconfig.cpu
@@ -299,8 +299,11 @@ config X86_POPAD_OK
 
 config X86_CMPXCHG64
 	bool
-	depends on X86_PAE
-	default y
+	depends on !M386 && !M486
+
+config X86_CMPXCHG64_REQUIRED
+	bool
+	select X86_CMPXCHG64
 
 config X86_ALIGNMENT_16
 	bool
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 33fa28a..6d53316 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,7 +11,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
-	depends on X86_CMPXCHG64 || 64BIT
+	select X86_CMPXCHG64 if X86_32
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/include/asm-i386/required-features.h b/include/asm-i386/required-features.h
index 65848a0..e4746fd 100644
--- a/include/asm-i386/required-features.h
+++ b/include/asm-i386/required-features.h
@@ -29,7 +29,7 @@
 # define NEED_CMOV	0
 #endif
 
-#ifdef CONFIG_X86_CMPXCHG64
+#ifdef CONFIG_X86_CMPXCHG64_REQUIRED
 # define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
 #else
 # define NEED_CX8	0
