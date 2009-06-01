Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZFAJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZFAJBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZFAJBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:01:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:36545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZFAJBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:01:30 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] s390: switch to dynamic percpu allocator
Date: Mon,  1 Jun 2009 17:58:28 +0900
Message-Id: <1243846708-805-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243846708-805-1-git-send-email-tj@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:58:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64bit s390 shares the same problem with percpu symbol addressing from
modules.  It needs assembly magic to force GOTENT reference when
building module as the percpu address will be outside the usual 4G
range from the module text.  Simiarly to alpha, this can be solved by
using the weak attribute.

This patch makes s390 use weak attribute instead and switch to dynamic
percpu allocator.  Please note that weak attribute is not added if
!SMP as percpu variables behave exactly the same as normal variables
on UP.

Compile tested.  Generation of GOTENT reference verified.

This patch is based on Ivan Kokshaysky's alpha percpu patch.

[ Impact: use dynamic percpu allocator ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig              |    3 ---
 arch/s390/include/asm/percpu.h |   32 ++++++++------------------------
 2 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 686909a..2eca5fe 100644
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
index 408d60b..36672ff 100644
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
+ * per cpu area, use "weak" attribute to force the compiler to
+ * generate an external reference.
+ */
+#if defined(CONFIG_SMP) && defined(__s390x__) && defined(MODULE)
+#define PER_CPU_ATTRIBUTES	__attribute__((weak))
 #endif
 
-#define __my_cpu_offset S390_lowcore.percpu_offset
-
 #include <asm-generic/percpu.h>
 
 #endif /* __ARCH_S390_PERCPU__ */
-- 
1.6.0.2

