Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZBCO46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZBCO46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZBCO4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:56:52 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:56298 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752496AbZBCO4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:56:51 -0500
Date: Tue, 3 Feb 2009 17:56:49 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
Message-ID: <20090203145649.GA19955@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru> <1233534919.18767.69.camel@pasglop> <1233583455.16878.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233583455.16878.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to this discussion:

http://lkml.org/lkml/2008/7/25/338
http://lkml.org/lkml/2008/7/26/72

Frame pointers do nothing useful on PowerPC, so lib/Kconfig.debug
makes CONFIG_FRAME_POINTER unselectable on PPC targets. But ftrace.h
requires CONFIG_FRAME_POINTER for CALLER_ADDR macros. Therefore
tracing is completely useless on PowerPC:

[...]
  <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1733:120:S mvtsd
  <idle>-0       0X.h3    9us+: 0 (0)
  <idle>-0       0X..3   72us : 0 (0)
  <idle>-0       0X..3   73us :      0:140:R ==> [000]  1733:120:R mvtsd

This patch introduces a ARCH_HAS_NORMAL_FRAME_POINTERS Kconfig symbol,
when selected the CALLER_ADDR macros are available without the
FRAME_POINTER Kconfig symbol.

With this patch the trace output turns into:

[...]
  <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1740:120:S mvtsd
  <idle>-0       0X.h3    9us+: hrtimer_wakeup (__run_hrtimer)
  <idle>-0       0X..3   87us : cpu_idle (__got2_end)
  <idle>-0       0X..3   89us :      0:140:R ==> [000]  1740:120:R mvtsd

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Mon, Feb 02, 2009 at 09:04:15AM -0500, Steven Rostedt wrote:
[...]
> > > -#ifdef CONFIG_FRAME_POINTER
> > > +#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_PPC)
> 
> Perhaps we should add a HAVE_NORMAL_FRAME_POINTERS in 
> arch/powerpc/Kconfig under PPC and then we can change the above line to:
> 
> #if defined(CONFIG_FRAME_POINTERS) || \
> 		defined(CONFIG_HAVE_NORMAL_FRAME_POINTERS)
> 
> This way when another arch wants to belong to this, we do not need to
> have a list of archs here.

Would it be better if we introduce ARCH_HAS_NORMAL_FRAME_POINTERS
in lib/Kconfig.debug, along with ARCH_WANT_FRAME_POINTERS?

Note that we can't use ARCH_WANT_FRAME_POINTERS for our needs since
that symbol is used for other (mostly cosmetic) purposes: whether we
we want CONFIG_FRAME_POINTER depend on CONFIG_DEBUG_KERNEL, and
whether frame pointers should be default =y (see commit
da4276b8299a6544dc41ac2485d3ffca5811b3fb).

 arch/powerpc/Kconfig   |    1 +
 include/linux/ftrace.h |    3 ++-
 lib/Kconfig.debug      |    6 ++++++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 74cc312..d1c67bd 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -111,6 +111,7 @@ config PPC
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
+	select ARCH_HAS_NORMAL_FRAME_POINTERS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7840e71..ede3fe2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -237,7 +237,8 @@ static inline void __ftrace_enabled_restore(int enabled)
 #endif
 }
 
-#ifdef CONFIG_FRAME_POINTER
+#if defined(CONFIG_FRAME_POINTER) || \
+		defined(CONFIG_ARCH_HAS_NORMAL_FRAME_POINTERS)
 /* TODO: need to fix this for ARM */
 # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
 # define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..808f4e2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -579,6 +579,12 @@ config ARCH_WANT_FRAME_POINTERS
 	bool
 	help
 
+config ARCH_HAS_NORMAL_FRAME_POINTERS
+	bool
+	help
+	  Architectures should select this symbol if their ABI implies
+	  having a frame pointer.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
-- 
1.5.6.5

