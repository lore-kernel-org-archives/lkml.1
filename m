Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYD0Kuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYD0Kuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYD0Ku2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:50:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60302 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbYD0Ku1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:50:27 -0400
Date: Sun, 27 Apr 2008 12:51:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] prepare kconfig inline optimization for all architectures
Message-ID: <20080427105100.GA14795@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the OPTIMIZE inline functionality such that it can be used
by all architectures.
To use it the arch maintainers shall add a
"select HAVE_OPTIMIZE_INLINING" in their arch specific
Kconfig file.

This patch enables OPTIMIZE_INLINING for x86, sparc and sparc64.
If all archs by into the approach the requirment for the select
can be dropped.

The indirection with ARCH__SUPPORTS_OPTIMIZED_INLINING was
killed as this is not needed when using select to
decide what archs supports this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
---
Largely untested.
This patch was made as a consequence of the CONFIG_OPTIMIZE_INLINING
thread on lkml.

	Sam


diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 49590f8..f08509e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -68,6 +68,7 @@ config SPARC
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_OPTIMIZE_INLINING
 
 # Identify this as a Sparc32 build
 config SPARC32
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 8acc5cc..01ecd33 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -9,6 +9,7 @@ config SPARC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_OPTIMIZE_INLINING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2fadf79..d5e22ef 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_OPTIMIZE_INLINING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
@@ -142,9 +143,6 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
-config ARCH_SUPPORTS_OPTIMIZED_INLINING
-	def_bool y
-
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 5b1979a..23956ea 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -258,15 +258,3 @@ config CPA_DEBUG
 
 endmenu
 
-config OPTIMIZE_INLINING
-	bool "Allow gcc to uninline functions marked 'inline'"
-	default y
-	help
-	  This option determines if the kernel forces gcc to inline the functions
-	  developers have marked 'inline'. Doing so takes away freedom from gcc to
-	  do what it thinks is best, which is desirable for the gcc 3.x series of
-	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
-	  disabling this option will generate a smaller kernel there. Hopefully
-	  this algorithm is so good that allowing gcc4 to make the decision can
-	  become the default in the future, until then this option is there to
-	  test gcc for this.
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index b2fd754..79b7a34 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -31,8 +31,7 @@
 /*
  * Force always-inline if the user requests it so via the .config:
  */
-#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
-    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
+#if !(defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4))
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
diff --git a/init/Kconfig b/init/Kconfig
index ba3a389..5d8ef89 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -508,6 +508,25 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+# archs shall "select HAVE_OPTIMIZE_INLINING" to be offered the
+# possibility to enable OPTIMIZE_INLINING
+config HAVE_OPTIMIZE_INLINING
+	def_bool n
+
+config OPTIMIZE_INLINING
+	bool "Enable gcc 4.0 inline algorithm for functions marked 'inline'"
+	depends on HAVE_OPTIMIZE_INLINING
+	help
+	  This option determines if the kernel forces gcc to inline the
+	  functions developers have marked 'inline'. Doing so takes away
+	  freedom from gcc to do what it thinks is best, which is desirable
+	  for the gcc 3.x series of compilers.
+	  The gcc 4.x series have a rewritten inlining algorithm and
+	  enabling this option will generate a smaller kernel there.
+	  Hopefully this algorithm is so good that allowing gcc4 to
+	  make the decision can become the default in the future,
+	  until then this option is there to test gcc for this.
+
 config SYSCTL
 	bool
 
