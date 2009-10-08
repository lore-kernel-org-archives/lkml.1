Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbZJHSOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbZJHSOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZJHSOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:14:02 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52413 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757392AbZJHSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:14:01 -0400
Date: Thu, 8 Oct 2009 14:06:45 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Tejun Heo <tj@kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <200910062034.40864.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0910081403200.7735@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091002093453.GA21427@elte.hu> <alpine.DEB.1.10.0910021311440.26189@gentwo.org> <200910062034.40864.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Rusty Russell wrote:

> Does this mean we can kill local.h soon?

We can kill cpu_local_xx right now. this_cpu_xx is a superset of that
functionality and cpu_local_xx is not used at all. We have to wait for the
merging of other patches to do more.


Subject: [percpu next] Remove cpu_local_xx macros

These macros have not been used for awhile now.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>


---
 arch/alpha/include/asm/local.h   |   17 -----------------
 arch/m32r/include/asm/local.h    |   25 -------------------------
 arch/mips/include/asm/local.h    |   25 -------------------------
 arch/powerpc/include/asm/local.h |   25 -------------------------
 arch/x86/include/asm/local.h     |   37 -------------------------------------
 include/asm-generic/local.h      |   19 -------------------
 6 files changed, 148 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/local.h	2009-10-08 12:57:38.000000000 -0500
+++ linux-2.6/arch/alpha/include/asm/local.h	2009-10-08 12:57:40.000000000 -0500
@@ -98,21 +98,4 @@ static __inline__ long local_sub_return(
 #define __local_add(i,l)	((l)->a.counter+=(i))
 #define __local_sub(i,l)	((l)->a.counter-=(i))

-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
-#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
-
-#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
-#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
-#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
-#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
-
-#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
-#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
-#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
-#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
-
 #endif /* _ALPHA_LOCAL_H */
Index: linux-2.6/arch/m32r/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/local.h	2009-10-08 12:57:38.000000000 -0500
+++ linux-2.6/arch/m32r/include/asm/local.h	2009-10-08 12:57:40.000000000 -0500
@@ -338,29 +338,4 @@ static inline void local_set_mask(unsign
  * a variable, not an address.
  */

-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non local way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* __M32R_LOCAL_H */
Index: linux-2.6/arch/mips/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/local.h	2009-10-08 12:57:38.000000000 -0500
+++ linux-2.6/arch/mips/include/asm/local.h	2009-10-08 12:57:40.000000000 -0500
@@ -193,29 +193,4 @@ static __inline__ long local_sub_return(
 #define __local_add(i, l)	((l)->a.counter+=(i))
 #define __local_sub(i, l)	((l)->a.counter-=(i))

-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* _ARCH_MIPS_LOCAL_H */
Index: linux-2.6/arch/powerpc/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/local.h	2009-10-08 12:57:38.000000000 -0500
+++ linux-2.6/arch/powerpc/include/asm/local.h	2009-10-08 12:57:40.000000000 -0500
@@ -172,29 +172,4 @@ static __inline__ long local_dec_if_posi
 #define __local_add(i,l)	((l)->a.counter+=(i))
 #define __local_sub(i,l)	((l)->a.counter-=(i))

-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* _ARCH_POWERPC_LOCAL_H */
Index: linux-2.6/arch/x86/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/local.h	2009-10-08 12:57:38.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/local.h	2009-10-08 12:57:40.000000000 -0500
@@ -195,41 +195,4 @@ static inline long local_sub_return(long
 #define __local_add(i, l)	local_add((i), (l))
 #define __local_sub(i, l)	local_sub((i), (l))

-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- *
- * X86_64: This could be done better if we moved the per cpu data directly
- * after GS.
- */
-
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)		\
-({					\
-	local_t res__;			\
-	preempt_disable(); 		\
-	res__ = (l);			\
-	preempt_enable();		\
-	res__;				\
-})
-#define cpu_local_wrap(l)		\
-({					\
-	preempt_disable();		\
-	(l);				\
-	preempt_enable();		\
-})					\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var((l))))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var((l)), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var((l))))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var((l))))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var((l))))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var((l))))
-
-#define __cpu_local_inc(l)	cpu_local_inc((l))
-#define __cpu_local_dec(l)	cpu_local_dec((l))
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* _ASM_X86_LOCAL_H */
Index: linux-2.6/include/asm-generic/local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/local.h	2009-10-08 12:57:38.000000000 -0500
+++ linux-2.6/include/asm-generic/local.h	2009-10-08 12:57:40.000000000 -0500
@@ -52,23 +52,4 @@ typedef struct
 #define __local_add(i,l)	local_set((l), local_read(l) + (i))
 #define __local_sub(i,l)	local_set((l), local_read(l) - (i))

-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable (eg. mystruct.foo), not an address.
- */
-#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
-#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
-#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
-#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
-#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
-#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
-
-/* Non-atomic increments, ie. preemption disabled and won't be touched
- * in interrupt, etc.  Some archs can optimize this case well.
- */
-#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
-#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
-#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
-#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
-
 #endif /* _ASM_GENERIC_LOCAL_H */




