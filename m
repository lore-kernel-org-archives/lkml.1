Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbYD0Mto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbYD0Mto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYD0Mtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:49:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbYD0Mtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:49:31 -0400
Date: Sun, 27 Apr 2008 14:49:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427124902.GA31813@elte.hu>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <20080427115603.GA23493@uranus.ravnborg.org> <20080427123642.GA28005@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427123642.GA28005@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> It goes along the same line as CC_OPTIMIZE_FOR_SIZE=y. Perhaps rename 
> it to CC_OPTIMIZE_INLINING=y?

i.e. like the patch below.

	Ingo

-------------------->
Subject: enable gcc inline optimization for all architectures
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 27 Apr 2008 13:56:04 +0200

architectures that want to enable this feature should select 
HAVE_CC_OPTIMIZE_INLINING.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/sparc/Kconfig           |    1 +
 arch/sparc64/Kconfig         |    1 +
 arch/x86/Kconfig             |    4 +---
 arch/x86/Kconfig.debug       |   12 ------------
 include/linux/compiler-gcc.h |    3 +--
 init/Kconfig                 |   19 +++++++++++++++++++
 6 files changed, 23 insertions(+), 17 deletions(-)

Index: linux/arch/sparc/Kconfig
===================================================================
--- linux.orig/arch/sparc/Kconfig
+++ linux/arch/sparc/Kconfig
@@ -68,6 +68,7 @@ config SPARC
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_CC_OPTIMIZE_INLINING
 
 # Identify this as a Sparc32 build
 config SPARC32
Index: linux/arch/sparc64/Kconfig
===================================================================
--- linux.orig/arch/sparc64/Kconfig
+++ linux/arch/sparc64/Kconfig
@@ -9,6 +9,7 @@ config SPARC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_CC_OPTIMIZE_INLINING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_CC_OPTIMIZE_INLINING
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
Index: linux/arch/x86/Kconfig.debug
===================================================================
--- linux.orig/arch/x86/Kconfig.debug
+++ linux/arch/x86/Kconfig.debug
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
Index: linux/include/linux/compiler-gcc.h
===================================================================
--- linux.orig/include/linux/compiler-gcc.h
+++ linux/include/linux/compiler-gcc.h
@@ -31,8 +31,7 @@
 /*
  * Force always-inline if the user requests it so via the .config:
  */
-#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
-    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
+#if !(defined(CONFIG_CC_OPTIMIZE_INLINING) && (__GNUC__ >= 4))
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -508,6 +508,25 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+# archs shall "select HAVE_CC_OPTIMIZE_INLINING" to be offered the
+# possibility to enable CC_OPTIMIZE_INLINING
+config HAVE_CC_OPTIMIZE_INLINING
+	def_bool n
+
+config CC_OPTIMIZE_INLINING
+	bool "Allow gcc to uninline functions marked 'inline'"
+	depends on HAVE_CC_OPTIMIZE_INLINING
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
 
