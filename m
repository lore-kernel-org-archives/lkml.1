Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbYD0SbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbYD0SbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759061AbYD0Sa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:30:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60997 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758940AbYD0Sa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:30:58 -0400
Date: Sun, 27 Apr 2008 20:31:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all architectures
Message-ID: <20080427183131.GA26937@uranus.ravnborg.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org> <20080427180957.GA25964@uranus.ravnborg.org> <20080427181411.GA31667@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427181411.GA31667@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 02:14:12PM -0400, Christoph Hellwig wrote:
> On Sun, Apr 27, 2008 at 08:09:57PM +0200, Sam Ravnborg wrote:
> > With the config option we pass the inline hint to gcc (if enabled).
> > So with the config option we have the possibility to pass a _hint_ to
> > gcc about inlining.
> > 
> > Before the config option there were no difference between
> > static int alwyas_inline foo() {}
> > and
> > static int inline foo() {}
> > 
> > With the config option we now have a situation where they actually
> > differ as they should do (assuming gcc > 4.x).
> 
> As Linus mentioned the hint doesn't make any sense because gcc will
> get it wrong anyway.  In fact when you look at kernel code it tends
> to inline the everything and the kitchensink as long as there's just
> one caller and this bloat the stack but doesn't inline where it needs
> to.  Better don't try to mess with that and do it explicit.

The tendency is that gcc inline *more than we whish* - not less.
Which is why we have noinline - to cover the cases where we do not
want stuff inlined.

What the patch in question does is to make a difference
between always_inle and inline.
Previously they were the same. With the patch applied and
with a gcc > 4.0 inline is now a hint.

Did you actually read the patch?

> 
> > So you say that it is safe to assume all places where we really need
> > always_inline are annotedted such - and we do not need a simple
> > config option that the user can uncheck.
> 
> I don't say it is that, it certainly isn't on powerpc and probably most
> other architectures right now, because only x86 got the fixup so far.
> But making it a user-visible option instead of an architecture opt
> in/out selection doesn't make any sense.
If you read the patch you will see that the architectures that
want to enable this has to do an explicit HAVE_CC_INLINE_HINT
so powerpc is not impacted by this until they request it.
Exactly the reason why this was not widely enabled in the
first place (but implemnted in a too x86 specific way).


Updated patch below. I btw. renamed the option to say this is
about a INLINE_HINT.

	Sam

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 49590f8..9645a6f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -68,6 +68,7 @@ config SPARC
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_CC_INLINE_HINT
 
 # Identify this as a Sparc32 build
 config SPARC32
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 8acc5cc..3c8ba36 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -9,6 +9,7 @@ config SPARC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_CC_INLINE_HINT
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2fadf79..48e352b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_CC_INLINE_HINT
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
index b2fd754..e49fade 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -31,8 +31,7 @@
 /*
  * Force always-inline if the user requests it so via the .config:
  */
-#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
-    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
+#if !(defined(CONFIG_HAVE_CC_INLINE_HINT) && (__GNUC__ >= 4))
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
diff --git a/init/Kconfig b/init/Kconfig
index ba3a389..3568647 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -508,6 +508,13 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+# archs shall "select HAVE_CC_INLINE_HINT"
+# to avoid forcing all function annotated inline
+# to be inline.
+# Note: This is only enforced for gcc > 4.0
+config HAVE_CC_INLINE_HINT
+	def_bool n
+
 config SYSCTL
 	bool
 
