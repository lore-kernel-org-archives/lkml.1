Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZFXGrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZFXGrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZFXGqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:46:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZFXGqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:46:18 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 10/10] s390: switch to dynamic percpu allocator
Date: Wed, 24 Jun 2009 15:45:24 +0900
Message-Id: <1245825924-30412-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245825924-30412-1-git-send-email-tj@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 06:45:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64bit s390 shares the same problem with alpha regarding percpu symbol
addressing from modules.  It needs assembly magic to force GOTENT
reference when building module as the percpu address will be outside
the usual 4G range from the module text.  This can be solved by using
weak percpu variable definitions.

This patch makes s390 use weak definitions and switch to dynamic
percpu allocator.  Please note that weak attribute is not added if
!SMP as percpu variables behave exactly the same as normal variables
on UP.

Compile tested.  Generation of GOTENT reference verified.

This patch is based on Ivan Kokshaysky's alpha percpu patch.

[ Impact: use dynamic percpu allocator ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig              |    3 ---
 arch/s390/include/asm/percpu.h |   32 ++++++++------------------------
 2 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f4a3cc6..a14dba0 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -75,9 +75,6 @@ config VIRT_CPU_ACCOUNTING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
-config HAVE_LEGACY_PER_CPU_AREA
-	def_bool y
-
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 408d60b..f7ad871 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -1,37 +1,21 @@
 #ifndef __ARCH_S390_PERCPU__
 #define __ARCH_S390_PERCPU__
 
-#include <linux/compiler.h>
-#include <asm/lowcore.h>
-
 /*
  * s390 uses its own implementation for per cpu data, the offset of
  * the cpu local data area is cached in the cpu's lowcore memory.
- * For 64 bit module code s390 forces the use of a GOT slot for the
- * address of the per cpu variable. This is needed because the module
- * may be more than 4G above the per cpu area.
  */
-#if defined(__s390x__) && defined(MODULE)
-
-#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
-	extern int simple_identifier_##var(void);	\
-	unsigned long *__ptr;				\
-	asm ( "larl %0, %1@GOTENT"		\
-	    : "=a" (__ptr) : "X" (ptr) );		\
-	(typeof(ptr))((*__ptr) + (offset));	}))
-
-#else
-
-#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
-	extern int simple_identifier_##var(void);		\
-	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
-	(typeof(ptr)) (__ptr + (offset)); }))
+#define __my_cpu_offset S390_lowcore.percpu_offset
 
+/*
+ * For 64 bit module code, the module may be more than 4G above the
+ * per cpu area, use weak definitions to force the compiler to
+ * generate external references.
+ */
+#if defined(CONFIG_SMP) && defined(__s390x__) && defined(MODULE)
+#define ARCH_NEEDS_WEAK_PER_CPU
 #endif
 
-#define __my_cpu_offset S390_lowcore.percpu_offset
-
 #include <asm-generic/percpu.h>
 
 #endif /* __ARCH_S390_PERCPU__ */
-- 
1.6.0.2

