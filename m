Return-Path: <linux-kernel-owner+w=401wt.eu-S1030231AbXAaQZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbXAaQZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030232AbXAaQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:25:45 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:57786 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030231AbXAaQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:25:44 -0500
Date: Wed, 31 Jan 2007 11:25:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] atomic.h : standardizing atomic primitives
Message-ID: <20070131162539.GA31985@Krystal>
References: <11685657414033-git-send-email-mathieu.desnoyers@polymtl.ca> <1170257321.9516.42.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1170257321.9516.42.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 11:16:11 up 161 days, 13:23,  4 users,  load average: 0.13, 0.27, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for testing Andrew's fixes. I am wondering about what happened to
the Powerpc recursive include problems Andrew experienced. Quoting him :

"OK, I fixed eight separate compile errors in this patch series and
now powerpc is being very ugly with a twisty maze of include
dependencies.

I'm giving up.  Someone should publish a suite of cross-compilers for us
so stuff like this doesn't need to happen."

I see that you have removed the include <asm/atomic.h> from bitops.h and
system.h in powerpc. If it compiles on every architectures, then it's a
good approach.

I planned to post a new patch which uses macros for cmpxchg and xchg in
asm-generic/atomic.h instead of inline functions. It would remove the
dependency on system.h. However, if your modifications work well on
every architecture, my fix might not be needed. Anyone has a preferred
solution ? I have not been able to setup my cross-compiler test bench
yet due to some hardware issues and waited for it before I released
further fixes, but if you want to try my macro-based fix, I could post
it.

And about the alpha build, Does the assembler errors also happen without
this patch ?

Regards,

Mathieu


* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> 
> atomic.h : standardizing atomic primitives
> 
> It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
> unless. Therefore, principally 64 bits architectures are targeted by these
> patches. It also adds the complete list of atomic operations on the atomic_long
> type.
> 
> build tested on:
> 
> arm-pxa255-idp_defconfig-xbuild
> i386-defconfig-xbuild
> ia64-defconfig-xbuild
> mips-ip32_defconfig-xbuild
> mips-yosemite_defconfig-xbuild
> parisc-a500_defconfig-xbuild  -- needs parisc-2.6 tree
> powerpc-ppc64_defconfig-xbuild
> sparc64-defconfig-xbuild
> sparc-defconfig-xbuild
> um-x86_64-defconfig-xbuild
> x86_64-defconfig-xbuild
> 
> notable exception: alpha (assembler errors, guess binutils funkyness)
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  include/asm-alpha/atomic.h   |   51 ++++++++++++
>  include/asm-generic/atomic.h |  169 +++++++++++++++++++++++++++++++++++++++++++
>  include/asm-i386/atomic.h    |    7 +
>  include/asm-ia64/atomic.h    |   25 +++++-
>  include/asm-mips/atomic.h    |   28 ++++++-
>  include/asm-parisc/atomic.h  |   29 ++++++-
>  include/asm-powerpc/atomic.h |   40 +++++++++-
>  include/asm-powerpc/bitops.h |    1 
>  include/asm-powerpc/system.h |    1 
>  include/asm-sparc64/atomic.h |   25 +++++-
>  include/asm-x86_64/atomic.h  |   38 ++++++++-
>  11 files changed, 392 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/include/asm-alpha/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-alpha/atomic.h
> +++ linux-2.6/include/asm-alpha/atomic.h
> @@ -175,19 +175,64 @@ static __inline__ long atomic64_sub_retu
>  	return result;
>  }
>  
> -#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic64_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
> +
> +#define atomic_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
>  #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
>  
> +/**
> + * atomic_add_unless - add unless the number is a given value
> + * @v: pointer of type atomic_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as it was not @u.
> + * Returns non-zero if @v was not @u, and zero otherwise.
> + */
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;			\
>  	c = atomic_read(v);					\
> -	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
> +	for (;;) {						\
> +		if (unlikely(c == (u)))				\
> +			break;					\
> +		old = atomic_cmpxchg((v), c, c + (a));		\
> +		if (likely(old == c))				\
> +			break;					\
>  		c = old;					\
> +	}							\
>  	c != (u);						\
>  })
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
>  
> +/**
> + * atomic64_add_unless - add unless the number is a given value
> + * @v: pointer of type atomic64_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as it was not @u.
> + * Returns non-zero if @v was not @u, and zero otherwise.
> + */
> +#define atomic64_add_unless(v, a, u)				\
> +({								\
> +	__typeof__((v)->counter) c, old;			\
> +	c = atomic64_read(v);					\
> +	for (;;) {						\
> +		if (unlikely(c == (u)))				\
> +			break;					\
> +		old = atomic64_cmpxchg((v), c, c + (a));	\
> +		if (likely(old == c))				\
> +			break;					\
> +		c = old;					\
> +	}							\
> +	c != (u);						\
> +})
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
>  #define atomic64_add_negative(a, v) (atomic64_add_return((a), (v)) < 0)
>  
> Index: linux-2.6/include/asm-generic/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-generic/atomic.h
> +++ linux-2.6/include/asm-generic/atomic.h
> @@ -8,6 +8,7 @@
>   * edit all arch specific atomic.h files.
>   */
>  
> +#include <asm/system.h>
>  #include <asm/types.h>
>  
>  /*
> @@ -66,6 +67,90 @@ static inline void atomic_long_sub(long 
>  	atomic64_sub(i, v);
>  }
>  
> +static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return atomic64_sub_and_test(i, v);
> +}
> +
> +static inline int atomic_long_dec_and_test(atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return atomic64_dec_and_test(v);
> +}
> +
> +static inline int atomic_long_inc_and_test(atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return atomic64_inc_and_test(v);
> +}
> +
> +static inline int atomic_long_add_negative(long i, atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return atomic64_add_negative(i, v);
> +}
> +
> +static inline long atomic_long_add_return(long i, atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_add_return(i, v);
> +}
> +
> +static inline long atomic_long_sub_return(long i, atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_sub_return(i, v);
> +}
> +
> +static inline long atomic_long_inc_return(atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_inc_return(v);
> +}
> +
> +static inline long atomic_long_dec_return(atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_dec_return(v);
> +}
> +
> +static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_add_unless(v, a, u);
> +}
> +
> +static inline long atomic_long_inc_not_zero(atomic_long_t *l)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_inc_not_zero(v);
> +}
> +
> +static inline long atomic_long_cmpxchg(atomic_long_t *l, long old, long new)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_cmpxchg(v, old, new);
> +}
> +
> +static inline long atomic_long_xchg(atomic_long_t *l, long new)
> +{
> +	atomic64_t *v = (atomic64_t *)l;
> +
> +	return (long)atomic64_xchg(v, new);
> +}
> +
>  #else  /*  BITS_PER_LONG == 64  */
>  
>  typedef atomic_t atomic_long_t;
> @@ -113,6 +198,90 @@ static inline void atomic_long_sub(long 
>  	atomic_sub(i, v);
>  }
>  
> +static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return atomic_sub_and_test(i, v);
> +}
> +
> +static inline int atomic_long_dec_and_test(atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return atomic_dec_and_test(v);
> +}
> +
> +static inline int atomic_long_inc_and_test(atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return atomic_inc_and_test(v);
> +}
> +
> +static inline int atomic_long_add_negative(long i, atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return atomic_add_negative(i, v);
> +}
> +
> +static inline long atomic_long_add_return(long i, atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_add_return(i, v);
> +}
> +
> +static inline long atomic_long_sub_return(long i, atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_sub_return(i, v);
> +}
> +
> +static inline long atomic_long_inc_return(atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_inc_return(v);
> +}
> +
> +static inline long atomic_long_dec_return(atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_dec_return(v);
> +}
> +
> +static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_add_unless(v, a, u);
> +}
> +
> +static inline long atomic_long_inc_not_zero(atomic_long_t *l)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_inc_not_zero(v);
> +}
> +
> +static inline long atomic_long_cmpxchg(atomic_long_t *l, long old, long new)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_cmpxchg(v, old, new);
> +}
> +
> +static inline long atomic_long_xchg(atomic_long_t *l, long new)
> +{
> +	atomic_t *v = (atomic_t *)l;
> +
> +	return (long)atomic_xchg(v, new);
> +}
> +
>  #endif  /*  BITS_PER_LONG == 64  */
>  
>  #endif  /*  _ASM_GENERIC_ATOMIC_H  */
> Index: linux-2.6/include/asm-i386/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-i386/atomic.h
> +++ linux-2.6/include/asm-i386/atomic.h
> @@ -207,8 +207,9 @@ static __inline__ int atomic_sub_return(
>  	return atomic_add_return(-i,v);
>  }
>  
> -#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
> -#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
> +#define atomic_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (old), (new)))
> +#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
>  
>  /**
>   * atomic_add_unless - add unless the number is a given value
> @@ -221,7 +222,7 @@ static __inline__ int atomic_sub_return(
>   */
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;			\
>  	c = atomic_read(v);					\
>  	for (;;) {						\
>  		if (unlikely(c == (u)))				\
> Index: linux-2.6/include/asm-ia64/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-ia64/atomic.h
> +++ linux-2.6/include/asm-ia64/atomic.h
> @@ -88,12 +88,17 @@ ia64_atomic64_sub (__s64 i, atomic64_t *
>  	return new;
>  }
>  
> -#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
> +#define atomic_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
>  #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
>  
> +#define atomic64_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
> +
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__(v->counter) c, old;				\
>  	c = atomic_read(v);					\
>  	for (;;) {						\
>  		if (unlikely(c == (u)))				\
> @@ -107,6 +112,22 @@ ia64_atomic64_sub (__s64 i, atomic64_t *
>  })
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
>  
> +#define atomic64_add_unless(v, a, u)				\
> +({								\
> +	__typeof__(v->counter) c, old;				\
> +	c = atomic64_read(v);					\
> +	for (;;) {						\
> +		if (unlikely(c == (u)))				\
> +			break;					\
> +		old = atomic64_cmpxchg((v), c, c + (a));	\
> +		if (likely(old == c))				\
> +			break;					\
> +		c = old;					\
> +	}							\
> +	c != (u);						\
> +})
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  #define atomic_add_return(i,v)						\
>  ({									\
>  	int __ia64_aar_i = (i);						\
> Index: linux-2.6/include/asm-mips/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-mips/atomic.h
> +++ linux-2.6/include/asm-mips/atomic.h
> @@ -291,8 +291,8 @@ static __inline__ int atomic_sub_if_posi
>  	return result;
>  }
>  
> -#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
> -#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
> +#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
>  
>  /**
>   * atomic_add_unless - add unless the number is a given value
> @@ -305,7 +305,7 @@ static __inline__ int atomic_sub_if_posi
>   */
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;			\
>  	c = atomic_read(v);					\
>  	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
>  		c = old;					\
> @@ -651,6 +651,28 @@ static __inline__ long atomic64_sub_if_p
>  	return result;
>  }
>  
> +#define atomic64_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), (new)))
> +
> +/**
> + * atomic64_add_unless - add unless the number is a given value
> + * @v: pointer of type atomic64_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as it was not @u.
> + * Returns non-zero if @v was not @u, and zero otherwise.
> + */
> +#define atomic64_add_unless(v, a, u)				\
> +({								\
> +	__typeof__((v)->counter) c, old;			\
> +	c = atomic_read(v);					\
> +	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
> +		c = old;					\
> +	c != (u);						\
> +})
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  #define atomic64_dec_return(v) atomic64_sub_return(1,(v))
>  #define atomic64_inc_return(v) atomic64_add_return(1,(v))
>  
> Index: linux-2.6/include/asm-parisc/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-parisc/atomic.h
> +++ linux-2.6/include/asm-parisc/atomic.h
> @@ -163,7 +163,8 @@ static __inline__ int atomic_read(const 
>  }
>  
>  /* exported interface */
> -#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic_cmpxchg(v, o, n) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
>  #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
>  
>  /**
> @@ -177,7 +178,7 @@ static __inline__ int atomic_read(const 
>   */
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;						\
>  	c = atomic_read(v);					\
>  	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
>  		c = old;					\
> @@ -270,6 +271,30 @@ atomic64_read(const atomic64_t *v)
>  #define atomic64_dec_and_test(v)	(atomic64_dec_return(v) == 0)
>  #define atomic64_sub_and_test(i,v)	(atomic64_sub_return((i),(v)) == 0)
>  
> +/* exported interface */
> +#define atomic64_cmpxchg(v, o, n) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
> +
> +/**
> + * atomic64_add_unless - add unless the number is a given value
> + * @v: pointer of type atomic64_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as it was not @u.
> + * Returns non-zero if @v was not @u, and zero otherwise.
> + */
> +#define atomic64_add_unless(v, a, u)				\
> +({								\
> +	__typeof__((v)->counter) c, old;						\
> +	c = atomic64_read(v);					\
> +	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
> +		c = old;					\
> +	c != (u);						\
> +})
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  #endif /* CONFIG_64BIT */
>  
>  #include <asm-generic/atomic.h>
> Index: linux-2.6/include/asm-powerpc/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/atomic.h
> +++ linux-2.6/include/asm-powerpc/atomic.h
> @@ -165,7 +165,8 @@ static __inline__ int atomic_dec_return(
>  	return t;
>  }
>  
> -#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic_cmpxchg(v, o, n) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
>  #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
>  
>  /**
> @@ -413,6 +414,43 @@ static __inline__ long atomic64_dec_if_p
>  	return t;
>  }
>  
> +#define atomic64_cmpxchg(v, o, n) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
> +
> +/**
> + * atomic64_add_unless - add unless the number is a given value
> + * @v: pointer of type atomic64_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as it was not @u.
> + * Returns non-zero if @v was not @u, and zero otherwise.
> + */
> +static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
> +{
> +	long t;
> +
> +	__asm__ __volatile__ (
> +	LWSYNC_ON_SMP
> +"1:	ldarx	%0,0,%1		# atomic_add_unless\n\
> +	cmpd	0,%0,%3 \n\
> +	beq-	2f \n\
> +	add	%0,%2,%0 \n"
> +"	stdcx.	%0,0,%1 \n\
> +	bne-	1b \n"
> +	ISYNC_ON_SMP
> +"	subf	%0,%2,%0 \n\
> +2:"
> +	: "=&r" (t)
> +	: "r" (&v->counter), "r" (a), "r" (u)
> +	: "cc", "memory");
> +
> +	return t != u;
> +}
> +
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  #endif /* __powerpc64__ */
>  
>  #include <asm-generic/atomic.h>
> Index: linux-2.6/include/asm-powerpc/bitops.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/bitops.h
> +++ linux-2.6/include/asm-powerpc/bitops.h
> @@ -39,7 +39,6 @@
>  #ifdef __KERNEL__
>  
>  #include <linux/compiler.h>
> -#include <asm/atomic.h>
>  #include <asm/asm-compat.h>
>  #include <asm/synch.h>
>  
> Index: linux-2.6/include/asm-powerpc/system.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/system.h
> +++ linux-2.6/include/asm-powerpc/system.h
> @@ -7,7 +7,6 @@
>  #include <linux/kernel.h>
>  
>  #include <asm/hw_irq.h>
> -#include <asm/atomic.h>
>  
>  /*
>   * Memory barrier.
> Index: linux-2.6/include/asm-sparc64/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-sparc64/atomic.h
> +++ linux-2.6/include/asm-sparc64/atomic.h
> @@ -70,12 +70,13 @@ extern int atomic64_sub_ret(int, atomic6
>  #define atomic_add_negative(i, v) (atomic_add_ret(i, v) < 0)
>  #define atomic64_add_negative(i, v) (atomic64_add_ret(i, v) < 0)
>  
> -#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic_cmpxchg(v, o, n) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
>  #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
>  
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;			\
>  	c = atomic_read(v);					\
>  	for (;;) {						\
>  		if (unlikely(c == (u)))				\
> @@ -89,6 +90,26 @@ extern int atomic64_sub_ret(int, atomic6
>  })
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
>  
> +#define atomic64_cmpxchg(v, o, n) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
> +
> +#define atomic64_add_unless(v, a, u)				\
> +({								\
> +	__typeof__((v)->counter) c, old;			\
> +	c = atomic64_read(v);					\
> +	for (;;) {						\
> +		if (unlikely(c == (u)))				\
> +			break;					\
> +		old = atomic64_cmpxchg((v), c, c + (a));	\
> +		if (likely(old == c))				\
> +			break;					\
> +		c = old;					\
> +	}							\
> +	likely(c != (u));					\
> +})
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  /* Atomic operations are already serializing */
>  #ifdef CONFIG_SMP
>  #define smp_mb__before_atomic_dec()	membar_storeload_loadload();
> Index: linux-2.6/include/asm-x86_64/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86_64/atomic.h
> +++ linux-2.6/include/asm-x86_64/atomic.h
> @@ -375,8 +375,8 @@ static __inline__ long atomic64_add_retu
>  	long __i = i;
>  	__asm__ __volatile__(
>  		LOCK_PREFIX "xaddq %0, %1;"
> -		:"=r"(i)
> -		:"m"(v->counter), "0"(i));
> +		:"+r" (i), "+m" (v->counter)
> +		: : "memory");
>  	return i + __i;
>  }
>  
> @@ -388,7 +388,12 @@ static __inline__ long atomic64_sub_retu
>  #define atomic64_inc_return(v)  (atomic64_add_return(1,v))
>  #define atomic64_dec_return(v)  (atomic64_sub_return(1,v))
>  
> -#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
> +#define atomic64_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
> +#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
> +
> +#define atomic_cmpxchg(v, old, new) \
> +	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
>  #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
>  
>  /**
> @@ -402,7 +407,7 @@ static __inline__ long atomic64_sub_retu
>   */
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;			\
>  	c = atomic_read(v);					\
>  	for (;;) {						\
>  		if (unlikely(c == (u)))				\
> @@ -416,6 +421,31 @@ static __inline__ long atomic64_sub_retu
>  })
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
>  
> +/**
> + * atomic64_add_unless - add unless the number is a given value
> + * @v: pointer of type atomic64_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as it was not @u.
> + * Returns non-zero if @v was not @u, and zero otherwise.
> + */
> +#define atomic64_add_unless(v, a, u)				\
> +({								\
> +	__typeof__((v)->counter) c, old;			\
> +	c = atomic64_read(v);					\
> +	for (;;) {						\
> +		if (unlikely(c == (u)))				\
> +			break;					\
> +		old = atomic64_cmpxchg((v), c, c + (a));	\
> +		if (likely(old == c))				\
> +			break;					\
> +		c = old;					\
> +	}							\
> +	c != (u);						\
> +})
> +#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +
>  /* These are x86-specific, used by some header files */
>  #define atomic_clear_mask(mask, addr) \
>  __asm__ __volatile__(LOCK_PREFIX "andl %0,%1" \
> 
> 

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
