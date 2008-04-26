Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYDZQLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYDZQLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYDZQLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:11:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYDZQLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:11:35 -0400
Date: Sat, 26 Apr 2008 18:11:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [git pull] x86, generic: optimized inlining
Message-ID: <20080426161119.GA13954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the "optimized inlining" feature from:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-optimized-inlining.git for-linus

this is from x86.git but touches include/linux/compiler-gcc.h and can be 
enabled by other architectures as well. The motivation of this feature 
is a 2.3% kernel text size reduction on generic x86 distro kernel 
configs. (Perhaps gcc will also get smarter about inlining decisions if 
the kernel gives it leeway about it.)

This change makes __always_inline more meaningful (and more critical). 
Testing so far showed no ill effects.

Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      x86: add optimized inlining
      generic: make optimized inlining arch-opt-in

 arch/x86/Kconfig                  |    3 +++
 arch/x86/Kconfig.debug            |   13 +++++++++++++
 arch/x86/configs/i386_defconfig   |    1 +
 arch/x86/configs/x86_64_defconfig |    1 +
 include/linux/compiler-gcc.h      |   13 ++++++++++---
 5 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4d350b5..3b6ff3b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -142,6 +142,9 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPTIMIZED_INLINING
+	def_bool y
+
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 239fd9f..5b1979a 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -257,3 +257,16 @@ config CPA_DEBUG
 	  Do change_page_attr() self-tests every 30 seconds.
 
 endmenu
+
+config OPTIMIZE_INLINING
+	bool "Allow gcc to uninline functions marked 'inline'"
+	default y
+	help
+	  This option determines if the kernel forces gcc to inline the functions
+	  developers have marked 'inline'. Doing so takes away freedom from gcc to
+	  do what it thinks is best, which is desirable for the gcc 3.x series of
+	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
+	  disabling this option will generate a smaller kernel there. Hopefully
+	  this algorithm is so good that allowing gcc4 to make the decision can
+	  become the default in the future, until then this option is there to
+	  test gcc for this.
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 3df340b..ad7ddaa 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1421,6 +1421,7 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
+CONFIG_OPTIMIZE_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index eef98cb..2d6f5b2 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1346,6 +1346,7 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
+CONFIG_OPTIMIZE_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index fe23792..b2fd754 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -28,9 +28,16 @@
 #define __must_be_array(a) \
   BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
 
-#define inline		inline		__attribute__((always_inline))
-#define __inline__	__inline__	__attribute__((always_inline))
-#define __inline	__inline	__attribute__((always_inline))
+/*
+ * Force always-inline if the user requests it so via the .config:
+ */
+#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
+    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
+# define inline		inline		__attribute__((always_inline))
+# define __inline__	__inline__	__attribute__((always_inline))
+# define __inline	__inline	__attribute__((always_inline))
+#endif
+
 #define __deprecated			__attribute__((deprecated))
 #define __packed			__attribute__((packed))
 #define __weak				__attribute__((weak))
