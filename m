Return-Path: <linux-kernel-owner+w=401wt.eu-S1030223AbXAZQga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223AbXAZQga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030620AbXAZQga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:36:30 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:49818 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030223AbXAZQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:36:29 -0500
Date: Fri, 26 Jan 2007 11:36:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 05/10] local_t : mips extension
Message-ID: <20070126163623.GB26138@Krystal>
References: <1169741777507-git-send-email-mathieu.desnoyers@polymtl.ca> <1169741780423-git-send-email-mathieu.desnoyers@polymtl.ca> <20070126120437.GA18778@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070126120437.GA18778@linux-mips.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 11:02:45 up 156 days, 13:09,  4 users,  load average: 2.74, 3.27, 3.02
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

* Ralf Baechle (ralf@linux-mips.org) wrote:
> On Thu, Jan 25, 2007 at 11:16:12AM -0500, Mathieu Desnoyers wrote:
> > From:	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > To:	linux-kernel@vger.kernel.org
> > Cc:	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
> > 	Ingo Molnar <mingo@redhat.com>,
> > 	Greg Kroah-Hartman <gregkh@suse.de>,
> > 	Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
> > 	systemtap@sources.redhat.com,
> > 	Douglas Niehaus <niehaus@eecs.ku.edu>,
> > 	"Martin J. Bligh" <mbligh@mbligh.org>,
> > 	Thomas Gleixner <tglx@linutronix.de>,
> > 	Paul Mackerras <paulus@samba.org>,
> > 	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> How about copying the MIPS maintainer or linux-mips mailing list instead
> of a zillion people who probably don't care?
> 

Although you are right about the correctness of sending the MIPS related
work to linux-mips, the other people I sent it to seemed interested in
my work. Thanks for the precision.

> > Subject: [PATCH 05/10] local_t : mips extension
> > Date:	Thu, 25 Jan 2007 11:16:12 -0500
> > 
> > local_t : mips extension
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > --- a/include/asm-mips/local.h
> > +++ b/include/asm-mips/local.h
> > @@ -1,60 +1,524 @@
> > -#ifndef _ASM_LOCAL_H
> > -#define _ASM_LOCAL_H
> > +#ifndef _ARCH_POWERPC_LOCAL_H
> > +#define _ARCH_POWERPC_LOCAL_H
> 
> The subject claims this is a MIPS patch ;-)
> 

"oops", will fix.

> >  #include <linux/percpu.h>
> >  #include <asm/atomic.h>
> >  
> > -#ifdef CONFIG_32BIT
> > +typedef struct
> > +{
> > +	local_long_t a;
> > +} local_t;
> >  
> > -typedef atomic_t local_t;
> > +#define LOCAL_INIT(i)	{ local_LONG_INIT(i) }
> >  
> > -#define LOCAL_INIT(i)	ATOMIC_INIT(i)
> > -#define local_read(v)	atomic_read(v)
> > -#define local_set(v,i)	atomic_set(v,i)
> > +#define local_read(l)	local_long_read(&(l)->a)
> > +#define local_set(l,i)	local_long_set(&(l)->a, (i))
> >  
> > -#define local_inc(v)	atomic_inc(v)
> > -#define local_dec(v)	atomic_dec(v)
> > -#define local_add(i, v)	atomic_add(i, v)
> > -#define local_sub(i, v)	atomic_sub(i, v)
> > +#define local_add(i,l)	local_long_add((i),(&(l)->a))
> > +#define local_sub(i,l)	local_long_sub((i),(&(l)->a))
> > +#define local_inc(l)	local_long_inc(&(l)->a)
> > +#define local_dec(l)	local_long_dec(&(l)->a)
> >  
> > -#endif
> >  
> > -#ifdef CONFIG_64BIT
> > +#ifndef CONFIG_64BITS
> 
> There is no CONFIG_64BITS
> 

Right, will fix (CONFIG_64BIT)

> > -typedef atomic64_t local_t;
> > +/*
> > + * Same as above, but return the result value
> > + */
> > +static __inline__ int local_add_return(int i, local_t * l)
> > +{
> > +	unsigned long result;
> > +
> > +	if (cpu_has_llsc && R10000_LLSC_WAR) {
> 
> Missing #include  <asm/war.h>.
> 
ok, I will add it, but it worked because of :
#include <asm/atomic.h> -> #include <asm/war.h>

> > +		unsigned long temp;
> > +
> > +		__asm__ __volatile__(
> > +		"	.set	mips3					\n"
> > +		"1:	ll	%1, %2		# local_add_return	\n"
> > +		"	addu	%0, %1, %3				\n"
> > +		"	sc	%0, %2					\n"
> > +		"	beqzl	%0, 1b					\n"
> > +		"	addu	%0, %1, %3				\n"
> > +		"	.set	mips0					\n"
> > +		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
> > +		: "Ir" (i), "m" (&(l->a.counter))
> > +		: "memory");
> > +	} else if (cpu_has_llsc) {
> > +		unsigned long temp;
> > +
> > +		__asm__ __volatile__(
> > +		"	.set	mips3					\n"
> > +		"1:	ll	%1, %2		# local_add_return	\n"
> > +		"	addu	%0, %1, %3				\n"
> > +		"	sc	%0, %2					\n"
> > +		"	beqz	%0, 1b					\n"
> > +		"	addu	%0, %1, %3				\n"
> > +		"	.set	mips0					\n"
> > +		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
> > +		: "Ir" (i), "m" (&(l->a.counter))
> > +		: "memory");
> > +	} else {
> > +		unsigned long flags;
> > +
> > +		local_irq_save(flags);
> > +		result = &(l->a.counter);
> > +		local_irq_restore(flags);
> > +	}
> 
> Asigning some pointer value to an integer variable with no cast?
> 

Yes, this whole file is wrong about this, I will change &(l->a.counter)
for l->a.counter (for variable assignment and for asm operands).

> > +		result += i;
> > +		&(l->a.counter) = result;
> 
> Invalid lvalue in assignment.
> 

Same problem as above.

> What I generally dislike about this patch is that several fairly large
> functions have been duplicated with only little change.
> 

Yeah, I know. Until we find some way to share atomic operation code for
both operation on local and shared data, we have to duplicate this. We
could think about a header that would support multiple inclusion and
behave differently (different function prefix and LOCKing/memory
barriers) depending on defines set by the top level header.

Something like

asm/atomic.h
  #define ATOMIC_SHARED
  #include <asm/atomic-ops.h>  /* shared */
  #undef ATOMIC_SHARED
  #include <asm/atomic-ops.h>  /* local */

asm/atomic-ops.h 
  #ifdef ATOMIC_SHARED
  #define ATOMIC_PREFIX atomic
  #define ATOMIC_BARRIER() smp_mb()
  #define ATOMIC_TYPE atomic_t
  #define ATOMIC_VAR (v->counter)
  #else
  #define ATOMIC_PREFIX local
  #define ATOMIC_BARRIER()
  #define ATOMIC_TYPE local_t
  #define ATOMIC_VAR (v->a.counter)
  #endif
  
  static __inline__ ATOMIC_PREFIX##_add_return(int i, ATOMIC_TYPE *v)
  .....
  #undef ATOMIC_PREFIX
  #undef ATOMIC_BARRIER
  #undef ATOMIC_TYPE
  #undef ATOMIC_VAR

What do you think about this ?

Thanks!

Mathieu


Correction of MIPS variables and config options.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-mips/local.h
+++ b/include/asm-mips/local.h
@@ -1,8 +1,9 @@
-#ifndef _ARCH_POWERPC_LOCAL_H
-#define _ARCH_POWERPC_LOCAL_H
+#ifndef _ARCH_MIPS_LOCAL_H
+#define _ARCH_MIPSRPC_LOCAL_H
 
 #include <linux/percpu.h>
 #include <asm/atomic.h>
+#include <asm/war.h>
 
 typedef struct
 {
@@ -20,7 +21,7 @@ typedef struct
 #define local_dec(l)	local_long_dec(&(l)->a)
 
 
-#ifndef CONFIG_64BITS
+#ifndef CONFIG_64BIT
 
 /*
  * Same as above, but return the result value
@@ -40,8 +41,8 @@ static __inline__ int local_add_return(int i, local_t * l)
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -54,16 +55,16 @@ static __inline__ int local_add_return(int i, local_t * l)
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result += i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -85,8 +86,8 @@ static __inline__ int local_sub_return(int i, local_t * l)
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -99,16 +100,16 @@ static __inline__ int local_sub_return(int i, local_t * l)
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -142,8 +143,8 @@ static __inline__ int local_sub_if_positive(int i, local_t * l)
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -160,17 +161,17 @@ static __inline__ int local_sub_if_positive(int i, local_t * l)
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
 		if (result >= 0)
-			&(l->a.counter) = result;
+			l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -251,7 +252,7 @@ static __inline__ int local_sub_if_positive(int i, local_t * l)
  */
 #define local_add_negative(i,l) (local_add_return(i, (l)) < 0)
 
-#else /* CONFIG_64BITS */
+#else /* CONFIG_64BIT */
 
 /*
  * Same as above, but return the result value
@@ -271,8 +272,8 @@ static __inline__ long local_add_return(long i, local_t * l)
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -285,16 +286,16 @@ static __inline__ long local_add_return(long i, local_t * l)
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result += i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -316,8 +317,8 @@ static __inline__ long local_sub_return(long i, local_t * l)
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -330,16 +331,16 @@ static __inline__ long local_sub_return(long i, local_t * l)
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -373,8 +374,8 @@ static __inline__ long local_sub_if_positive(long i, local_t * l)
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -391,17 +392,17 @@ static __inline__ long local_sub_if_positive(long i, local_t * l)
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
 		if (result >= 0)
-			&(l->a.counter) = result;
+			l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -483,7 +484,7 @@ static __inline__ long local_sub_if_positive(long i, local_t * l)
  */
 #define local_add_negative(i,l) (local_add_return(i, (l)) < 0)
 
-#endif /* !CONFIG_64BITS */
+#endif /* !CONFIG_64BIT */
 
 
 /* Use these for per-cpu local_t variables: on some archs they are
@@ -521,4 +522,4 @@ static __inline__ long local_sub_if_positive(long i, local_t * l)
 #define __cpu_local_add(i, l)	cpu_local_add((i), (l))
 #define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
 
-#endif /* _ARCH_POWERPC_LOCAL_H */
+#endif /* _ARCH_MIPS_LOCAL_H */


-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
