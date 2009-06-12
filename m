Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbZFLH2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbZFLH2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZFLH2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:28:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35325 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZFLH2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:28:24 -0400
Date: Fri, 12 Jun 2009 16:43:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: linux-next: manual merge of the asm-generic tree with Linus' tree
Message-Id: <20090612164351.af5204f7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the asm-generic tree got a conflict in
arch/x86/include/asm/atomic_32.h between commit
9b194e831fb2c322ed81a373e49620f34edc2778 ("x86: implement atomic64_t on
32-bit") from Linus' tree and commit
72099ed2719fc5829bd79c6ca9d1783ed026eb37 ("asm-generic: rename atomic.h
to atomic-long.h") from the asm-generic tree.

Just context changes (I think). I have fixed it up (see below).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/atomic_32.h
index aff9f1f,c83d314..0000000
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@@ -247,241 -247,5 +247,241 @@@ static inline int atomic_add_unless(ato
  #define smp_mb__before_atomic_inc()	barrier()
  #define smp_mb__after_atomic_inc()	barrier()
  
 +/* An 64bit atomic type */
 +
 +typedef struct {
 +	unsigned long long counter;
 +} atomic64_t;
 +
 +#define ATOMIC64_INIT(val)	{ (val) }
 +
 +/**
 + * atomic64_read - read atomic64 variable
 + * @v: pointer of type atomic64_t
 + *
 + * Atomically reads the value of @v.
 + * Doesn't imply a read memory barrier.
 + */
 +#define __atomic64_read(ptr)		((ptr)->counter)
 +
 +static inline unsigned long long
 +cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
 +{
 +	asm volatile(
 +
 +		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
 +
 +		     :		"=A" (old)
 +
 +		     : [ptr]	"D" (ptr),
 +				"A" (old),
 +				"b" (ll_low(new)),
 +				"c" (ll_high(new))
 +
 +		     : "memory");
 +
 +	return old;
 +}
 +
 +static inline unsigned long long
 +atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
 +		 unsigned long long new_val)
 +{
 +	return cmpxchg8b(&ptr->counter, old_val, new_val);
 +}
 +
 +/**
 + * atomic64_xchg - xchg atomic64 variable
 + * @ptr:      pointer to type atomic64_t
 + * @new_val:  value to assign
 + * @old_val:  old value that was there
 + *
 + * Atomically xchgs the value of @ptr to @new_val and returns
 + * the old value.
 + */
 +
 +static inline unsigned long long
 +atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
 +{
 +	unsigned long long old_val;
 +
 +	do {
 +		old_val = atomic_read(ptr);
 +	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
 +
 +	return old_val;
 +}
 +
 +/**
 + * atomic64_set - set atomic64 variable
 + * @ptr:      pointer to type atomic64_t
 + * @new_val:  value to assign
 + *
 + * Atomically sets the value of @ptr to @new_val.
 + */
 +static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
 +{
 +	atomic64_xchg(ptr, new_val);
 +}
 +
 +/**
 + * atomic64_read - read atomic64 variable
 + * @ptr:      pointer to type atomic64_t
 + *
 + * Atomically reads the value of @ptr and returns it.
 + */
 +static inline unsigned long long atomic64_read(atomic64_t *ptr)
 +{
 +	unsigned long long curr_val;
 +
 +	do {
 +		curr_val = __atomic64_read(ptr);
 +	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
 +
 +	return curr_val;
 +}
 +
 +/**
 + * atomic64_add_return - add and return
 + * @delta: integer value to add
 + * @ptr:   pointer to type atomic64_t
 + *
 + * Atomically adds @delta to @ptr and returns @delta + *@ptr
 + */
 +static inline unsigned long long
 +atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
 +{
 +	unsigned long long old_val, new_val;
 +
 +	do {
 +		old_val = atomic_read(ptr);
 +		new_val = old_val + delta;
 +
 +	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
 +
 +	return new_val;
 +}
 +
 +static inline long atomic64_sub_return(unsigned long long delta, atomic64_t *ptr)
 +{
 +	return atomic64_add_return(-delta, ptr);
 +}
 +
 +static inline long atomic64_inc_return(atomic64_t *ptr)
 +{
 +	return atomic64_add_return(1, ptr);
 +}
 +
 +static inline long atomic64_dec_return(atomic64_t *ptr)
 +{
 +	return atomic64_sub_return(1, ptr);
 +}
 +
 +/**
 + * atomic64_add - add integer to atomic64 variable
 + * @delta: integer value to add
 + * @ptr:   pointer to type atomic64_t
 + *
 + * Atomically adds @delta to @ptr.
 + */
 +static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
 +{
 +	atomic64_add_return(delta, ptr);
 +}
 +
 +/**
 + * atomic64_sub - subtract the atomic64 variable
 + * @delta: integer value to subtract
 + * @ptr:   pointer to type atomic64_t
 + *
 + * Atomically subtracts @delta from @ptr.
 + */
 +static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
 +{
 +	atomic64_add(-delta, ptr);
 +}
 +
 +/**
 + * atomic64_sub_and_test - subtract value from variable and test result
 + * @delta: integer value to subtract
 + * @ptr:   pointer to type atomic64_t
 + *
 + * Atomically subtracts @delta from @ptr and returns
 + * true if the result is zero, or false for all
 + * other cases.
 + */
 +static inline int
 +atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
 +{
 +	unsigned long long old_val = atomic64_sub_return(delta, ptr);
 +
 +	return old_val == 0;
 +}
 +
 +/**
 + * atomic64_inc - increment atomic64 variable
 + * @ptr: pointer to type atomic64_t
 + *
 + * Atomically increments @ptr by 1.
 + */
 +static inline void atomic64_inc(atomic64_t *ptr)
 +{
 +	atomic64_add(1, ptr);
 +}
 +
 +/**
 + * atomic64_dec - decrement atomic64 variable
 + * @ptr: pointer to type atomic64_t
 + *
 + * Atomically decrements @ptr by 1.
 + */
 +static inline void atomic64_dec(atomic64_t *ptr)
 +{
 +	atomic64_sub(1, ptr);
 +}
 +
 +/**
 + * atomic64_dec_and_test - decrement and test
 + * @ptr: pointer to type atomic64_t
 + *
 + * Atomically decrements @ptr by 1 and
 + * returns true if the result is 0, or false for all other
 + * cases.
 + */
 +static inline int atomic64_dec_and_test(atomic64_t *ptr)
 +{
 +	return atomic64_sub_and_test(1, ptr);
 +}
 +
 +/**
 + * atomic64_inc_and_test - increment and test
 + * @ptr: pointer to type atomic64_t
 + *
 + * Atomically increments @ptr by 1
 + * and returns true if the result is zero, or false for all
 + * other cases.
 + */
 +static inline int atomic64_inc_and_test(atomic64_t *ptr)
 +{
 +	return atomic64_sub_and_test(-1, ptr);
 +}
 +
 +/**
 + * atomic64_add_negative - add and test if negative
 + * @delta: integer value to add
 + * @ptr:   pointer to type atomic64_t
 + *
 + * Atomically adds @delta to @ptr and returns true
 + * if the result is negative, or false when
 + * result is greater than or equal to zero.
 + */
 +static inline int
 +atomic64_add_negative(unsigned long long delta, atomic64_t *ptr)
 +{
 +	long long old_val = atomic64_add_return(delta, ptr);
 +
 +	return old_val < 0;
 +}
 +
- #include <asm-generic/atomic.h>
+ #include <asm-generic/atomic-long.h>
  #endif /* _ASM_X86_ATOMIC_32_H */
