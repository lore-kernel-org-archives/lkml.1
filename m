Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZD3ONE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZD3ONE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbZD3OML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:12:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:38742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089AbZD3OMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:12:09 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping around
Date: Thu, 30 Apr 2009 19:39:50 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <200904301921.44615.knikanth@novell.com> <20090430140559.GA14696@elte.hu>
In-Reply-To: <20090430140559.GA14696@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301939.51022.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009 19:35:59 Ingo Molnar wrote:
> * Nikanth Karthikesan <knikanth@novell.com> wrote:
> > On Thursday 30 April 2009 19:07:57 Ingo Molnar wrote:
> > > * Nikanth Karthikesan <knikanth@novell.com> wrote:
> > > > > Then there could be a single, straightforward value check:
> > > > >
> > > > > static inline void atomic_inc(atomic_t *v)
> > > > > {
> > > > > 	debug_atomic_check_value(v);
> > > > > 	raw_atomic_inc(v);
> > > > > }
> > > > >
> > > > > Where debug_atomic_check_value() is just an atomic_read():
> > > > >
> > > > > static inline void debug_atomic_check_value(atomic_t *v)
> > > > > {
> > > > > 	WARN_ONCE(in_range(atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
> > > > > 		  KERN_ERR "atomic counter check failure!");
> > > > > }
> > > >
> > > > I do not understand, why UINT_MAX/4 to UINT_MAX/4*3?
> > > > Roughly,
> > > > UINT_MAX/4 = INT_MAX/2
> > > > UINT_MAX/4*3 = INT_MAX/2*3 which we will never reach with an int.
> > >
> > > i mean:
> > >
> > >  	WARN_ONCE(in_range((u32)atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
> > >  		  KERN_ERR "atomic counter check failure!");
> > >
> > > that's a single range check on an u32, selecting 'too large' and
> > > 'too small' s32 values.
> > >
> > > > > It's a constant check.
> > > > >
> > > > > If are overflowing on such a massive rate, it doesnt matter how
> > > > > early or late we check the value.
> > > >
> > > > UINT_MAX/4 early, might be too early. And if it doesn't matter how
> > > > early or late, why try to be over-cautious and produce false
> > > > warnings. ;-)
> > >
> > > UINT_MAX/4 is ~1 billion. If we reach a value of 1 billion we are
> > > leaking. Your check basically is a sharp test for the specific case
> > > of overflowing the boundary - but it makes the code slower (it uses
> > > more complex atomic ops) and uglifies it via #ifdefs as well.
> > >
> > > It doesnt matter whether we wrap over at around +2 billion into -2
> > > billion, or treat the whole above-1-billion and
> > > below-minus-1-billion range as invalid. (other than we'll catch bugs
> > > sooner via this method, and have faster and cleaner code)
> >
> > Ah.. got it. But, range checking is not required as we are just
> > verifying it during increment and decrement, not atomic_add,
> > atomic_sub etc... Should we add debug checks to those operations
> > as well? If we want to test those operations as well, range check
> > would be useful.
>
> Good point! Indeed the checks can be even simpler that way - a
> single test.
>
> > Here is a patch, without the overhead of a costly atomic operation
> > which would warn if it goes out of [INT_MIN/2 .. INT_MAX/2].
> >
> > +static inline void atomic_inc(atomic_t *v)
> > +{
> > +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> > +	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),
> > +		KERN_ERR "atomic counter check failure!");
>
> here the message can be more specific i think:
>
> 		KERN_ERR "atomic inc overflow!");
>
> > +#endif
> > +	raw_atomic_inc(v);
> > +}
> > +
> > +/**
> > + * atomic_dec - decrement atomic variable
> > + * @v: pointer of type atomic_t
> > + *
> > + * Atomically decrements @v by 1.
> > + */
> > +static inline void atomic_dec(atomic_t *v)
> > +{
> > +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> > +	WARN_ONCE((atomic_read(v) < (INT_MIN / 2)),
> > +		KERN_ERR "atomic counter check failure!");
> > +#endif
>
> and here:
>
> 		KERN_ERR "atomic inc underflow!");
>
> other than these two small details this is looking really nice now.
>

Done.

Thanks
Nikanth

Detect and warn on atomic_inc/atomic_dec overflow.

Add a debug option to detect and warn when the 32-bit atomic_t overflows
during atomic_inc and atomic_dec.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

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
index 7abdaa9..e0ffa32 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -4,15 +4,51 @@
  * Copyright (C) 2005 Silicon Graphics, Inc.
  *	Christoph Lameter
  *
- * Allows to provide arch independent atomic definitions without the need to
- * edit all arch specific atomic.h files.
  */
 
+#include <linux/kernel.h>
 #include <asm/types.h>
+#include <asm/bug.h>
+
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic_inc(atomic_t *v)
+{
+#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
+	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),
+		KERN_ERR "atomic inc overflow!");
+#endif
+	raw_atomic_inc(v);
+}
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic_dec(atomic_t *v)
+{
+#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
+	WARN_ONCE((atomic_read(v) < (INT_MIN / 2)),
+		KERN_ERR "atomic dec underflow!");
+#endif
+	raw_atomic_dec(v);
+
+}
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

