Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZEHKp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZEHKp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZEHKpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:45:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:57826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZEHKpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:45:17 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping around
Date: Fri, 8 May 2009 16:16:53 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <20090507172316.20a95642.akpm@linux-foundation.org> <200905081610.50202.knikanth@suse.de>
In-Reply-To: <200905081610.50202.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905081616.53684.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009 16:10:49 Nikanth Karthikesan wrote:
> On Friday 08 May 2009 05:53:16 Andrew Morton wrote:
> > On Thu, 30 Apr 2009 19:39:50 +0530
> >
> > Nikanth Karthikesan <knikanth@novell.com> wrote:
> > > Detect and warn on atomic_inc/atomic_dec overflow.
> > >
> > > Add a debug option to detect and warn when the 32-bit atomic_t
> > > overflows during atomic_inc and atomic_dec.
> > >
> > >
> > > ...
> > >
> > > --- a/include/asm-generic/atomic.h
> > > +++ b/include/asm-generic/atomic.h
> > > @@ -4,15 +4,51 @@
> > >   * Copyright (C) 2005 Silicon Graphics, Inc.
> > >   *	Christoph Lameter
> > >   *
> > > - * Allows to provide arch independent atomic definitions without the
> > > need to - * edit all arch specific atomic.h files.
> > >   */
> > >
> > > +#include <linux/kernel.h>
> > >  #include <asm/types.h>
> > > +#include <asm/bug.h>
> >
> > We're going to have real trouble making changes like this to a
> > low-level header file - sparc64 results below.
> >
> > > +/**
> > > + * atomic_inc - increment atomic variable
> > > + * @v: pointer of type atomic_t
> > > + *
> > > + * Atomically increments @v by 1.
> > > + */
> > > +static inline void atomic_inc(atomic_t *v)
> > > +{
> > > +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> > > +	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),
> > > +		KERN_ERR "atomic inc overflow!");
> > > +#endif
> > > +	raw_atomic_inc(v);
> > > +}
> >
> > Are we allowed to assume that atomic_inc==raw_atomic_inc for all
> > architectures which use this definition?
>
> No. Only for architectures that have HAVE_ARCH_DEBUG_ATOMIC. I missed
> enclosing the change with #ifdef HAVE_ARCH_DEBUG_ATOMIC. That should solve
> the problem as it wont be built for other architectures at all.
>
> > Do we know that atomic_read() is defined at this point?
>
> Yes.
>
> > We can avoid the problematic includes via
> >
> > extern void atomic_inc_screwed_up(atomic_t *v);
>
> This and even having atomic_inc defined as a c function instead of a macro
> has a problem. WARN_ONCE would warn only once even if more than 1 variable
> wraps around. So should we have atomic_inc itself as a macro instead?
>
> Also it would report the location in source as include/asm-generic/atomic.h
> instead of the caller. But it should be fine as stack trace would be
> printed.
>
> Anyway I have converted warn_once as an extern function.
>
> Changes from the previous version:
> 1. Enclose everything with #ifdef CONFIG_HAVE_ARCH_DEBUG_ATOMIC.
> 2. Make the warn_once as an extern function and remove the
> #include<asm/bug.h>. This is not required as CONFIG_HAVE_ARCH_DEBUG_ATOMIC
> is defined onlf for x86 and it does not have problem with this include. I
> think we could remove this and also make everything as macro?
>
If you think this would be better, here is a patch that does this. Having it 
as a macro would warn for every variable that could overflow.

Thanks
Nikanth

Subject: atomic: detect and warn on atomic_inc/atomic_dec wrapping around
From: Nikanth Karthikesan <knikanth@novell.com>

Add a debug option to detect and warn when the 32-bit atomic_t overflows
during atomic_inc and atomic_dec.

We expect that overflow and underflow of an atomic_t is usually a bug. 
There was a patch of this nature in -mm for a long time and it never
triggered false positives and it did find a couple of real bugs.

The option is default-y for now.  It will have a fairly nasty impact on
.text size so we may decide to switch it to default-n prior to a kernel
release.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..dd49be3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -46,6 +46,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_ARCH_DEBUG_ATOMIC
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/atomic_32.h 
b/arch/x86/include/asm/atomic_32.h
index 85b46fb..c6a17bb 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -78,24 +78,24 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 }
 
 /**
- * atomic_inc - increment atomic variable
+ * raw_atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically increments @v by 1.
  */
-static inline void atomic_inc(atomic_t *v)
+static inline void raw_atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
 		     : "+m" (v->counter));
 }
 
 /**
- * atomic_dec - decrement atomic variable
+ * raw_atomic_dec - decrement atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically decrements @v by 1.
  */
-static inline void atomic_dec(atomic_t *v)
+static inline void raw_atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
 		     : "+m" (v->counter));
diff --git a/arch/x86/include/asm/atomic_64.h 
b/arch/x86/include/asm/atomic_64.h
index 8c21731..1183b85 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -77,12 +77,12 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 }
 
 /**
- * atomic_inc - increment atomic variable
+ * raw_atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically increments @v by 1.
  */
-static inline void atomic_inc(atomic_t *v)
+static inline void raw_atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
 		     : "=m" (v->counter)
@@ -90,12 +90,12 @@ static inline void atomic_inc(atomic_t *v)
 }
 
 /**
- * atomic_dec - decrement atomic variable
+ * raw_atomic_dec - decrement atomic variable
  * @v: pointer of type atomic_t
  *
  * Atomically decrements @v by 1.
  */
-static inline void atomic_dec(atomic_t *v)
+static inline void raw_atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
 		     : "=m" (v->counter)
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 3673a13..004b018 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -4,15 +4,56 @@
  * Copyright (C) 2005 Silicon Graphics, Inc.
  *	Christoph Lameter
  *
- * Allows to provide arch independent atomic definitions without the need to
- * edit all arch specific atomic.h files.
  */
 
 #include <asm/types.h>
 
+#ifdef CONFIG_HAVE_ARCH_DEBUG_ATOMIC
+
+#include <linux/kernel.h>
+#include <asm/bug.h>
+
+#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+#define atomic_inc(v) ({				\
+	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),	\
+		KERN_ERR "atomic inc overflow!");	\
+	raw_atomic_inc(v);				\
+})
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+#define atomic_dec(v) ({				\
+	WARN_ONCE((atomic_read(v) < (INT_MIN / 2)),	\
+		KERN_ERR "atomic dec underflow!");	\
+	raw_atomic_dec(v);				\
+})
+
+#else /* CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP */
+
+#define atomic_inc(v) raw_atomic_inc(v)
+#define atomic_dec(v) raw_atomic_dec(v)
+
+#endif /* !CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP */
+
+#endif /* CONFIG_HAVE_ARCH_DEBUG_ATOMIC */
+
 /*
  * Suppport for atomic_long_t
  *
+ * Allows to provide arch independent atomic definitions without the need to
+ * edit all arch specific atomic.h files.
+ *
  * Casts for parameters are avoided for existing atomic functions in order to
  * avoid issues with cast-as-lval under gcc 4.x and other limitations that 
the
  * macros of a platform may have.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 812c282..773c1a4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -17,6 +17,17 @@ config ENABLE_WARN_DEPRECATED
 	  Disable this to suppress the "warning: 'foo' is deprecated
 	  (declared at kernel/power/somefile.c:1234)" messages.
 
+config HAVE_ARCH_DEBUG_ATOMIC
+	bool
+
+config ENABLE_WARN_ATOMIC_INC_WRAP
+	bool "Enable warning on atomic_inc()/atomic_dec() wrap"
+	depends on HAVE_ARCH_DEBUG_ATOMIC
+	default y
+	help
+	  Enable printing a warning when atomic_inc() or atomic_dec()
+	  operation wraps around the 32-bit value.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y

