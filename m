Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbZD1P55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbZD1P55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761973AbZD1P5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:57:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13178 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbZD1P5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=xSxuAw46lQ7N0fxEOFWehZhCYsNJ7PWZTiCoxjSP8aaJDzBumH8gv7sFJafyHws2oQ
         THzWDuyhimJFTKXqhZTUIt9l20GuVrnn62pbWUxJsEQAh67Qr/bTu3sC/PFRO9fjnrzU
         ZWzd+PhT2qoBEHVHMTjE2jyFM2JMy2N716Vek=
Subject: Re: "RT_PREEMPT for loongson" is updated to patch-2.6.29.1-rt8
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Zhang Le <r0bertz@gentoo.org>, linux-kernel@vger.kernel.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, zhangfx@lemote.com,
       loongson-dev@googlegroups.com, yanh@lemote.com,
       linux-mips@linux-mips.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090428122958.GA19160@linux-mips.org>
References: <1240193547.25532.52.camel@falcon>
	 <20090420050419.GA22520@adriano.hkcable.com.hk>
	 <1240211926.8884.27.camel@falcon> <20090420080155.GA11621@linux-mips.org>
	 <20090420131022.GA10183@linux-mips.org> <1240237323.8884.42.camel@falcon>
	 <20090428122958.GA19160@linux-mips.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 28 Apr 2009 23:57:30 +0800
Message-Id: <1240934250.10957.209.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 14:29 +0200, Ralf Baechle wrote:
> On Mon, Apr 20, 2009 at 10:22:03PM +0800, Wu Zhangjin wrote:
> 
> >From e67f78d663a84ef93aa12c3c8c1adf3033c4f9a1 Mon Sep 17 00:00:00 2001
> From: Wu Zhangjin <wuzj@lemote.com>
> Date: Sun, 19 Apr 2009 15:57:41 +0800
> Subject: [PATCH] basic RT_PREEMPT support for mips/loongson2f
> 
> This job is based on patch-2.6.24.7-rt27.bz2 & patch-2.6.26.8-rt16.bz2
> from http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 4401055..708fcc0 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -663,6 +663,10 @@ config RWSEM_GENERIC_SPINLOCK
>  config RWSEM_XCHGADD_ALGORITHM
>  	bool
>  
> +config ASM_SEMAPHORE
> +	bool
> +	default y
> +
> 
> This config symbol is not being referenced anywhere in the tree.
> 

Yes, this symbol seems not used currently, I just drop it, but it is
still stayed in arch/x86/Kconfig, drop it too?   

>  config ARCH_HAS_ILOG2_U32
>  	bool
>  	default n
> diff --git a/arch/mips/include/asm/asmmacro.h b/arch/mips/include/asm/asmmacro.h
> index 6c8342a..d3cc457 100644
> --- a/arch/mips/include/asm/asmmacro.h
> +++ b/arch/mips/include/asm/asmmacro.h
> @@ -21,7 +21,7 @@
>  #endif
>  
>  #ifdef CONFIG_MIPS_MT_SMTC
> -	.macro	local_irq_enable reg=t0
> +	.macro	raw_local_irq_enable reg=t0
> 
> Renaming this function and the others seems like a good cleanup but please
> break such cleanup out and submit them separatly.

get it, a new RT_PREEMPT git branch for MIPS will be created later(at
latest, tomorrow).

> 
>  	mfc0	\reg, CP0_TCSTATUS
>  	ori	\reg, \reg, TCSTATUS_IXMT
>  	xori	\reg, \reg, TCSTATUS_IXMT
> @@ -29,31 +29,31 @@
>  	_ehb
>  	.endm
>  
> -	.macro	local_irq_disable reg=t0
> +	.macro	raw_local_irq_disable reg=t0
>  	mfc0	\reg, CP0_TCSTATUS
>  	ori	\reg, \reg, TCSTATUS_IXMT
>  	mtc0	\reg, CP0_TCSTATUS
>  	_ehb
>  	.endm
>  #elif defined(CONFIG_CPU_MIPSR2)
> -	.macro	local_irq_enable reg=t0
> +	.macro	raw_local_irq_enable reg=t0
>  	ei
>  	irq_enable_hazard
>  	.endm
>  
> -	.macro	local_irq_disable reg=t0
> +	.macro	raw_local_irq_disable reg=t0
>  	di
>  	irq_disable_hazard
>  	.endm
>  #else
> -	.macro	local_irq_enable reg=t0
> +	.macro	raw_local_irq_enable reg=t0
>  	mfc0	\reg, CP0_STATUS
>  	ori	\reg, \reg, 1
>  	mtc0	\reg, CP0_STATUS
>  	irq_enable_hazard
>  	.endm
>  
> -	.macro	local_irq_disable reg=t0
> +	.macro	raw_local_irq_disable reg=t0
>  	mfc0	\reg, CP0_STATUS
>  	ori	\reg, \reg, 1
>  	xori	\reg, \reg, 1
> diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
> index 5dabc87..7891111 100644
> --- a/arch/mips/include/asm/i8253.h
> +++ b/arch/mips/include/asm/i8253.h
> @@ -14,7 +14,7 @@
>  
>  #define PIT_TICK_RATE		1193182UL
>  
> -extern spinlock_t i8253_lock;
> +extern raw_spinlock_t i8253_lock;
>  
>  extern void setup_pit_timer(void);
>  
> diff --git a/arch/mips/include/asm/i8259.h b/arch/mips/include/asm/i8259.h
> index 8572a2d..acafca9 100644
> --- a/arch/mips/include/asm/i8259.h
> +++ b/arch/mips/include/asm/i8259.h
> @@ -35,7 +35,7 @@
>  #define SLAVE_ICW4_DEFAULT	0x01
>  #define PIC_ICW4_AEOI		2
>  
> -extern spinlock_t i8259A_lock;
> +extern raw_spinlock_t i8259A_lock;
>  
>  extern int i8259A_irq_pending(unsigned int irq);
>  extern void make_8259A_irq(unsigned int irq);
> diff --git a/arch/mips/include/asm/kdebug.h b/arch/mips/include/asm/kdebug.h
> index 5bf62aa..3edbe56 100644
> --- a/arch/mips/include/asm/kdebug.h
> +++ b/arch/mips/include/asm/kdebug.h
> @@ -8,6 +8,7 @@ enum die_val {
>  	DIE_FP,
>  	DIE_TRAP,
>  	DIE_RI,
> +	DIE_NMI_IPI,
>  };
>  
>  #endif /* _ASM_MIPS_KDEBUG_H */
> 
> This patch only defines DIE_NMI_IPI but the only user is a x86-only
> watchdog driver.  Drop?
> 

dropped. (seems this is an old fix for an compiling error in
linux-2.6.29-rc6) 

> diff --git a/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h b/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
> index 01d08d6..1cb4aa3 100644
> --- a/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
> +++ b/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
> @@ -17,6 +17,9 @@
>  #ifndef __ASM_LEMOTE_CPU_FEATURE_OVERRIDES_H
>  #define __ASM_LEMOTE_CPU_FEATURE_OVERRIDES_H
>  
> +/* for RT_PREEMPT */
> +#define finish_arch_switch_empty
> +
> 
> The whole finish_arch_switch_empty thing looks broken.  Drop it.

get it.

> 
>  #define cpu_has_llsc 1
>  
>  #define cpu_has_tlb		1
> diff --git a/arch/mips/include/asm/mach-tx49xx/cpu-feature-overrides.h b/arch/mips/include/asm/mach-tx49xx/cpu-feature-overrides.h
> index 275eaf9..f703cc3 100644
> --- a/arch/mips/include/asm/mach-tx49xx/cpu-feature-overrides.h
> +++ b/arch/mips/include/asm/mach-tx49xx/cpu-feature-overrides.h
> @@ -1,6 +1,8 @@
>  #ifndef __ASM_MACH_TX49XX_CPU_FEATURE_OVERRIDES_H
>  #define __ASM_MACH_TX49XX_CPU_FEATURE_OVERRIDES_H
>  
> +#define finish_arch_switch_empty
> +
>  #define cpu_has_llsc	1
>  #define cpu_has_64bits	1
>  #define cpu_has_inclusive_pcaches	0
> diff --git a/arch/mips/include/asm/rwsem.h b/arch/mips/include/asm/rwsem.h
> new file mode 100644
> index 0000000..4e57263
> --- /dev/null
> +++ b/arch/mips/include/asm/rwsem.h
> 
> Your tree always defines RWSEM_GENERIC_SPINLOCK, so this file will never
> be included, not even when building a non-RT kernel.

fixed,

config RWSEM_GENERIC_SPINLOCK
bool
+ depends on PREEMPT_RT
default y

config RWSEM_XCHGADD_ALGORITHM
bool
+ depends on !RWSEM_GENERIC_SPINLOCK && !PREEMPT_RT
+ default y

some more fixes for compiling errors have been done on
include/asm-mips/rwsem.h, will go to the new git branch:

--- a/arch/mips/include/asm/rwsem.h
+++ b/arch/mips/include/asm/rwsem.h
@@ -31,41 +31,42 @@ struct compat_rw_semaphore {
#define RWSEM_ACTIVE_WRITE_BIAS (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
raw_spinlock_t wait_lock;
struct list_head wait_list;
-#if RWSEM_DEBUG
- int debug;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+ struct lockdep_map dep_map;
#endif
};

/*
* initialisation
*/
-#if RWSEM_DEBUG
-#define __RWSEM_DEBUG_INIT , 0
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name =
#lockname }
#else
-#define __RWSEM_DEBUG_INIT /* */
+# define __RWSEM_DEP_MAP_INIT(lockname)
#endif

-#define __COMPAT_RWSEM_INITIALIZER(name) \
- { RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
- LIST_HEAD_INIT((name).wait_list) \
- __RWSEM_DEBUG_INIT }
+#define __RWSEM_INITIALIZER(name) \
+ { RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
+ LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }

#define COMPAT_DECLARE_RWSEM(name) \
- struct compat_rw_semaphore name = __COMPAT_RWSEM_INITIALIZER(name)
+ struct compat_rw_semaphore name = __RWSEM_INITIALIZER(name)

-extern struct compat_rw_semaphore *rwsem_down_read_failed(struct
compat_rw_semaphore *sem);
-extern struct compat_rw_semaphore *rwsem_down_write_failed(struct
compat_rw_semaphore *sem);
-extern struct compat_rw_semaphore *rwsem_wake(struct
compat_rw_semaphore *sem);
-extern struct compat_rw_semaphore *rwsem_downgrade_wake(struct
compat_rw_semaphore *sem);
+extern asmregparm struct compat_rw_semaphore *
+ rwsem_down_read_failed(struct compat_rw_semaphore *sem);
+extern asmregparm struct compat_rw_semaphore *
+ rwsem_down_write_failed(struct compat_rw_semaphore *sem);
+extern asmregparm struct compat_rw_semaphore *
+ rwsem_wake(struct compat_rw_semaphore *);
+extern asmregparm struct compat_rw_semaphore *
+ rwsem_downgrade_wake(struct compat_rw_semaphore *sem);

static inline void compat_init_rwsem(struct compat_rw_semaphore *sem)
{
sem->count = RWSEM_UNLOCKED_VALUE;
spin_lock_init(&sem->wait_lock);
INIT_LIST_HEAD(&sem->wait_list);
-#if RWSEM_DEBUG
- sem->debug = 0;
-#endif
}

/*
@@ -172,5 +173,10 @@ static inline int rwsem_atomic_update(int delta,
struct compat_rw_semaphore *sem
return atomic_add_return(delta, (atomic_t *)(&sem->count));
}

+static inline int compat_rwsem_is_locked(struct compat_rw_semaphore
*sem)
+{
+ return (sem->count != 0);
+}
+
#endif /* __KERNEL__ */
#endif /* _MIPS_RWSEM_H */


> 
> @@ -0,0 +1,176 @@
> +/*
> + * include/asm-mips/rwsem.h: R/W semaphores for MIPS using the stuff
> + * in lib/rwsem.c.  Adapted largely from include/asm-ppc/rwsem.h
> + * by john.cooper@timesys.com
> + */
> +
> +#ifndef _MIPS_RWSEM_H
> +#define _MIPS_RWSEM_H
> +
> +#ifndef _LINUX_RWSEM_H
> +#error "please don't include asm/rwsem.h directly, use linux/rwsem.h instead"
> +#endif
> +
> +#ifdef __KERNEL__
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <asm/atomic.h>
> +#include <asm/system.h>
> +
> +/*
> + * the semaphore definition
> + */
> +struct compat_rw_semaphore {
> +	/* XXX this should be able to be an atomic_t  -- paulus */
> +	signed long		count;
> +#define RWSEM_UNLOCKED_VALUE		0x00000000
> +#define RWSEM_ACTIVE_BIAS		0x00000001
> +#define RWSEM_ACTIVE_MASK		0x0000ffff
> +#define RWSEM_WAITING_BIAS		(-0x00010000)
> +#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
> +#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
> +	raw_spinlock_t		wait_lock;
> +	struct list_head	wait_list;
> +#if RWSEM_DEBUG
> +	int			debug;
> +#endif
> +};
> +
> +/*
> + * initialisation
> + */
> +#if RWSEM_DEBUG
> +#define __RWSEM_DEBUG_INIT      , 0
> +#else
> +#define __RWSEM_DEBUG_INIT	/* */
> +#endif
> +
> +#define __COMPAT_RWSEM_INITIALIZER(name) \
> +	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
> +	  LIST_HEAD_INIT((name).wait_list) \
> +	  __RWSEM_DEBUG_INIT }
> +
> +#define COMPAT_DECLARE_RWSEM(name)		\
> +	struct compat_rw_semaphore name = __COMPAT_RWSEM_INITIALIZER(name)
> +
> +extern struct compat_rw_semaphore *rwsem_down_read_failed(struct compat_rw_semaphore *sem);
> +extern struct compat_rw_semaphore *rwsem_down_write_failed(struct compat_rw_semaphore *sem);
> +extern struct compat_rw_semaphore *rwsem_wake(struct compat_rw_semaphore *sem);
> +extern struct compat_rw_semaphore *rwsem_downgrade_wake(struct compat_rw_semaphore *sem);
> +
> +static inline void compat_init_rwsem(struct compat_rw_semaphore *sem)
> +{
> +	sem->count = RWSEM_UNLOCKED_VALUE;
> +	spin_lock_init(&sem->wait_lock);
> +	INIT_LIST_HEAD(&sem->wait_list);
> +#if RWSEM_DEBUG
> +	sem->debug = 0;
> +#endif
> +}
> +
> +/*
> + * lock for reading
> + */
> +static inline void __down_read(struct compat_rw_semaphore *sem)
> +{
> +	if (atomic_inc_return((atomic_t *)(&sem->count)) > 0)
> +		smp_wmb();
> +	else
> +		rwsem_down_read_failed(sem);
> +}
> +
> +static inline int __down_read_trylock(struct compat_rw_semaphore *sem)
> +{
> +	int tmp;
> +
> +	while ((tmp = sem->count) >= 0) {
> +		if (tmp == cmpxchg(&sem->count, tmp,
> +				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
> +			smp_wmb();
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * lock for writing
> + */
> +static inline void __down_write(struct compat_rw_semaphore *sem)
> +{
> +	int tmp;
> +
> +	tmp = atomic_add_return(RWSEM_ACTIVE_WRITE_BIAS,
> +				(atomic_t *)(&sem->count));
> +	if (tmp == RWSEM_ACTIVE_WRITE_BIAS)
> +		smp_wmb();
> +	else
> +		rwsem_down_write_failed(sem);
> +}
> +
> +static inline int __down_write_trylock(struct compat_rw_semaphore *sem)
> +{
> +	int tmp;
> +
> +	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
> +		      RWSEM_ACTIVE_WRITE_BIAS);
> +	smp_wmb();
> +	return tmp == RWSEM_UNLOCKED_VALUE;
> +}
> +
> +/*
> + * unlock after reading
> + */
> +static inline void __up_read(struct compat_rw_semaphore *sem)
> +{
> +	int tmp;
> +
> +	smp_wmb();
> +	tmp = atomic_dec_return((atomic_t *)(&sem->count));
> +	if (tmp < -1 && (tmp & RWSEM_ACTIVE_MASK) == 0)
> +		rwsem_wake(sem);
> +}
> +
> +/*
> + * unlock after writing
> + */
> +static inline void __up_write(struct compat_rw_semaphore *sem)
> +{
> +	smp_wmb();
> +	if (atomic_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
> +			      (atomic_t *)(&sem->count)) < 0)
> +		rwsem_wake(sem);
> +}
> +
> +/*
> + * implement atomic add functionality
> + */
> +static inline void rwsem_atomic_add(int delta, struct compat_rw_semaphore *sem)
> +{
> +	atomic_add(delta, (atomic_t *)(&sem->count));
> +}
> +
> +/*
> + * downgrade write lock to read lock
> + */
> +static inline void __downgrade_write(struct compat_rw_semaphore *sem)
> +{
> +	int tmp;
> +
> +	smp_wmb();
> +	tmp = atomic_add_return(-RWSEM_WAITING_BIAS, (atomic_t *)(&sem->count));
> +	if (tmp < 0)
> +		rwsem_downgrade_wake(sem);
> +}
> +
> +/*
> + * implement exchange and add functionality
> + */
> +static inline int rwsem_atomic_update(int delta, struct compat_rw_semaphore *sem)
> +{
> +	smp_mb();
> +	return atomic_add_return(delta, (atomic_t *)(&sem->count));
> +}
> +
> +#endif /* __KERNEL__ */
> +#endif /* _MIPS_RWSEM_H */
> diff --git a/arch/mips/include/asm/spinlock.h b/arch/mips/include/asm/spinlock.h
> index 0884947..6415b94 100644
> --- a/arch/mips/include/asm/spinlock.h
> +++ b/arch/mips/include/asm/spinlock.h
> @@ -34,7 +34,7 @@
>   * becomes equal to the the initial value of the tail.
>   */
>  
> -static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
> +static inline int __raw_spin_is_locked(__raw_spinlock_t *lock)
>  {
>  	unsigned int counters = ACCESS_ONCE(lock->lock);
>  
> @@ -45,7 +45,7 @@ static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
>  #define __raw_spin_unlock_wait(x) \
>  	while (__raw_spin_is_locked(x)) { cpu_relax(); }
>  
> -static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
> +static inline int __raw_spin_is_contended(__raw_spinlock_t *lock)
>  {
>  	unsigned int counters = ACCESS_ONCE(lock->lock);
>  
> @@ -53,7 +53,7 @@ static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
>  }
>  #define __raw_spin_is_contended	__raw_spin_is_contended
>  
> -static inline void __raw_spin_lock(raw_spinlock_t *lock)
> +static inline void __raw_spin_lock(__raw_spinlock_t *lock)
>  {
>  	int my_ticket;
>  	int tmp;
> @@ -134,7 +134,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
>  	smp_llsc_mb();
>  }
>  
> -static inline void __raw_spin_unlock(raw_spinlock_t *lock)
> +static inline void __raw_spin_unlock(__raw_spinlock_t *lock)
>  {
>  	int tmp;
>  
> @@ -174,7 +174,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
>  	}
>  }
>  
> -static inline unsigned int __raw_spin_trylock(raw_spinlock_t *lock)
> +static inline unsigned int __raw_spin_trylock(__raw_spinlock_t *lock)
>  {
>  	int tmp, tmp2, tmp3;
>  
> @@ -256,7 +256,7 @@ static inline unsigned int __raw_spin_trylock(raw_spinlock_t *lock)
>   */
>  #define __raw_write_can_lock(rw)	(!(rw)->lock)
>  
> -static inline void __raw_read_lock(raw_rwlock_t *rw)
> +static inline void __raw_read_lock(__raw_rwlock_t *rw)
>  {
>  	unsigned int tmp;
>  
> @@ -301,7 +301,7 @@ static inline void __raw_read_lock(raw_rwlock_t *rw)
>  /* Note the use of sub, not subu which will make the kernel die with an
>     overflow exception if we ever try to unlock an rwlock that is already
>     unlocked or is being held by a writer.  */
> -static inline void __raw_read_unlock(raw_rwlock_t *rw)
> +static inline void __raw_read_unlock(__raw_rwlock_t *rw)
>  {
>  	unsigned int tmp;
>  
> @@ -335,7 +335,7 @@ static inline void __raw_read_unlock(raw_rwlock_t *rw)
>  	}
>  }
>  
> -static inline void __raw_write_lock(raw_rwlock_t *rw)
> +static inline void __raw_write_lock(__raw_rwlock_t *rw)
>  {
>  	unsigned int tmp;
>  
> @@ -377,7 +377,7 @@ static inline void __raw_write_lock(raw_rwlock_t *rw)
>  	smp_llsc_mb();
>  }
>  
> -static inline void __raw_write_unlock(raw_rwlock_t *rw)
> +static inline void __raw_write_unlock(__raw_rwlock_t *rw)
>  {
>  	smp_mb();
>  
> @@ -389,7 +389,7 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
>  	: "memory");
>  }
>  
> -static inline int __raw_read_trylock(raw_rwlock_t *rw)
> +static inline int __raw_read_trylock(__raw_rwlock_t *rw)
>  {
>  	unsigned int tmp;
>  	int ret;
> @@ -433,7 +433,7 @@ static inline int __raw_read_trylock(raw_rwlock_t *rw)
>  	return ret;
>  }
>  
> -static inline int __raw_write_trylock(raw_rwlock_t *rw)
> +static inline int __raw_write_trylock(__raw_rwlock_t *rw)
>  {
>  	unsigned int tmp;
>  	int ret;
> diff --git a/arch/mips/include/asm/spinlock_types.h b/arch/mips/include/asm/spinlock_types.h
> index adeedaa..afdda81 100644
> --- a/arch/mips/include/asm/spinlock_types.h
> +++ b/arch/mips/include/asm/spinlock_types.h
> @@ -12,13 +12,13 @@ typedef struct {
>  	 * bits 15..28: ticket
>  	 */
>  	unsigned int lock;
> -} raw_spinlock_t;
> +} __raw_spinlock_t;
>  
>  #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
>  
>  typedef struct {
>  	volatile unsigned int lock;
> -} raw_rwlock_t;
> +} __raw_rwlock_t;
>  
>  #define __RAW_RW_LOCK_UNLOCKED		{ 0 }
>  
> diff --git a/arch/mips/include/asm/system.h b/arch/mips/include/asm/system.h
> index cd30f83..4fc1ea2 100644
> --- a/arch/mips/include/asm/system.h
> +++ b/arch/mips/include/asm/system.h
> @@ -71,6 +71,9 @@ do {									\
>  	(last) = resume(prev, next, task_thread_info(next));		\
>  } while (0)
>  
> +
> +/* preempt kernel barfs in kernel/sched.c ifdef finish_arch_switch */
> +#ifndef finish_arch_switch_empty
>  #define finish_arch_switch(prev)					\
>  do {									\
>  	if (cpu_has_dsp)						\
> @@ -79,6 +82,7 @@ do {									\
>  		write_c0_userlocal(current_thread_info()->tp_value);	\
>  	__restore_watch();						\
>  } while (0)
> +#endif
>  
>  static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
>  {
> diff --git a/arch/mips/include/asm/timeofday.h b/arch/mips/include/asm/timeofday.h
> new file mode 100644
> index 0000000..33dda85
> --- /dev/null
> +++ b/arch/mips/include/asm/timeofday.h
> @@ -0,0 +1,5 @@
> +#ifndef _ASM_MIPS_TIMEOFDAY_H
> +#define _ASM_MIPS_TIMEOFDAY_H
> +#include <asm-generic/timeofday.h>
> +#endif
> +
> diff --git a/arch/mips/include/asm/uaccess.h b/arch/mips/include/asm/uaccess.h
> index 09ff5bb..60149c6 100644
> --- a/arch/mips/include/asm/uaccess.h
> +++ b/arch/mips/include/asm/uaccess.h
> @@ -696,7 +696,6 @@ extern size_t __copy_user(void *__to, const void *__from, size_t __n);
>  	const void *__cu_from;						\
>  	long __cu_len;							\
>  									\
> -	might_sleep();							\
>  	__cu_to = (to);							\
>  	__cu_from = (from);						\
>  	__cu_len = (n);							\
> @@ -752,7 +751,6 @@ extern size_t __copy_user_inatomic(void *__to, const void *__from, size_t __n);
>  	const void *__cu_from;						\
>  	long __cu_len;							\
>  									\
> -	might_sleep();							\
>  	__cu_to = (to);							\
>  	__cu_from = (from);						\
>  	__cu_len = (n);							\
> @@ -831,7 +829,6 @@ extern size_t __copy_user_inatomic(void *__to, const void *__from, size_t __n);
>  	const void __user *__cu_from;					\
>  	long __cu_len;							\
>  									\
> -	might_sleep();							\
>  	__cu_to = (to);							\
>  	__cu_from = (from);						\
>  	__cu_len = (n);							\
> @@ -862,7 +859,6 @@ extern size_t __copy_user_inatomic(void *__to, const void *__from, size_t __n);
>  	const void __user *__cu_from;					\
>  	long __cu_len;							\
>  									\
> -	might_sleep();							\
>  	__cu_to = (to);							\
>  	__cu_from = (from);						\
>  	__cu_len = (n);							\
> @@ -880,7 +876,6 @@ extern size_t __copy_user_inatomic(void *__to, const void *__from, size_t __n);
>  	const void __user *__cu_from;					\
>  	long __cu_len;							\
>  									\
> -	might_sleep();							\
>  	__cu_to = (to);							\
>  	__cu_from = (from);						\
>  	__cu_len = (n);							\
> @@ -907,7 +902,6 @@ __clear_user(void __user *addr, __kernel_size_t size)
>  {
>  	__kernel_size_t res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		"move\t$5, $0\n\t"
> @@ -956,7 +950,6 @@ __strncpy_from_user(char *__to, const char __user *__from, long __len)
>  {
>  	long res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		"move\t$5, %2\n\t"
> @@ -993,7 +986,6 @@ strncpy_from_user(char *__to, const char __user *__from, long __len)
>  {
>  	long res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		"move\t$5, %2\n\t"
> @@ -1012,7 +1004,6 @@ static inline long __strlen_user(const char __user *s)
>  {
>  	long res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		__MODULE_JAL(__strlen_user_nocheck_asm)
> @@ -1042,7 +1033,6 @@ static inline long strlen_user(const char __user *s)
>  {
>  	long res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		__MODULE_JAL(__strlen_user_asm)
> @@ -1059,7 +1049,6 @@ static inline long __strnlen_user(const char __user *s, long n)
>  {
>  	long res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		"move\t$5, %2\n\t"
> @@ -1090,7 +1079,6 @@ static inline long strnlen_user(const char __user *s, long n)
>  {
>  	long res;
>  
> -	might_sleep();
>  	__asm__ __volatile__(
>  		"move\t$4, %1\n\t"
>  		"move\t$5, %2\n\t"
> 
> Why did you drop these annotations entirely?  They probably should be
> switched over to might_fault().  Whatever - there are more annotations in
> <asm/checksum.h> will need to be modified the same way.  And this
> should probably be submitted as a separate patch anyway.
> 

okay, will be fixed later.

> diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
> index 0015e44..8603d91 100644
> --- a/arch/mips/kernel/cevt-r4k.c
> +++ b/arch/mips/kernel/cevt-r4k.c
> @@ -82,7 +82,7 @@ out:
>  
>  struct irqaction c0_compare_irqaction = {
>  	.handler = c0_compare_interrupt,
> -	.flags = IRQF_DISABLED | IRQF_PERCPU,
> +	.flags = IRQF_DISABLED | IRQF_PERCPU | IRQF_NODELAY,
>  	.name = "timer",
>  };
>  
> diff --git a/arch/mips/kernel/entry.S b/arch/mips/kernel/entry.S
> index ffa3310..a993d0a 100644
> --- a/arch/mips/kernel/entry.S
> +++ b/arch/mips/kernel/entry.S
> @@ -30,7 +30,7 @@
>  	.align	5
>  #ifndef CONFIG_PREEMPT
>  FEXPORT(ret_from_exception)
> -	local_irq_disable			# preempt stop
> +	raw_local_irq_disable			# preempt stop
>  	b	__ret_from_irq
>  #endif
>  FEXPORT(ret_from_irq)
> @@ -41,7 +41,7 @@ FEXPORT(__ret_from_irq)
>  	beqz	t0, resume_kernel
>  
>  resume_userspace:
> -	local_irq_disable		# make sure we dont miss an
> +	raw_local_irq_disable		# make sure we dont miss an
>  					# interrupt setting need_resched
>  					# between sampling and return
>  	LONG_L	a2, TI_FLAGS($28)	# current->work
> @@ -51,7 +51,9 @@ resume_userspace:
>  
>  #ifdef CONFIG_PREEMPT
>  resume_kernel:
> -	local_irq_disable
> +	raw_local_irq_disable
> +	lw  t0, kernel_preemption
> +	beqz t0,restore_all
>  	lw	t0, TI_PRE_COUNT($28)
>  	bnez	t0, restore_all
>  need_resched:
> @@ -61,7 +63,9 @@ need_resched:
>  	LONG_L	t0, PT_STATUS(sp)		# Interrupts off?
>  	andi	t0, 1
>  	beqz	t0, restore_all
> +	raw_local_irq_disable
>  	jal	preempt_schedule_irq
> +	sw	zero, TI_PRE_COUNT($28)
>  	b	need_resched
>  #endif
>  
> @@ -69,7 +73,7 @@ FEXPORT(ret_from_fork)
>  	jal	schedule_tail		# a0 = struct task_struct *prev
>  
>  FEXPORT(syscall_exit)
> -	local_irq_disable		# make sure need_resched and
> +	raw_local_irq_disable		# make sure need_resched and
>  					# signals dont change between
>  					# sampling and return
>  	LONG_L	a2, TI_FLAGS($28)	# current->work
> @@ -145,9 +149,9 @@ work_pending:
>  	andi	t0, a2, _TIF_NEED_RESCHED # a2 is preloaded with TI_FLAGS
>  	beqz	t0, work_notifysig
>  work_resched:
> -	jal	schedule
> +	jal	__schedule
>  
> -	local_irq_disable		# make sure need_resched and
> +	raw_local_irq_disable		# make sure need_resched and
>  					# signals dont change between
>  					# sampling and return
>  	LONG_L	a2, TI_FLAGS($28)
> @@ -170,7 +174,7 @@ syscall_exit_work:
>  	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
>  	and	t0, a2			# a2 is preloaded with TI_FLAGS
>  	beqz	t0, work_pending	# trace bit set?
> -	local_irq_enable		# could let do_syscall_trace()
> +	raw_local_irq_enable		# could let do_syscall_trace()
>  					# call schedule() instead
>  	move	a0, sp
>  	li	a1, 1
> diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
> index f4d1878..8af4c8f 100644
> --- a/arch/mips/kernel/i8253.c
> +++ b/arch/mips/kernel/i8253.c
> @@ -14,7 +14,7 @@
>  #include <asm/io.h>
>  #include <asm/time.h>
>  
> -DEFINE_SPINLOCK(i8253_lock);
> +DEFINE_RAW_SPINLOCK(i8253_lock);
>  EXPORT_SYMBOL(i8253_lock);
>  
>  /*
> @@ -97,7 +97,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
>  
>  static struct irqaction irq0  = {
>  	.handler = timer_interrupt,
> -	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
> +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_NODELAY,
>  	.mask = CPU_MASK_NONE,
>  	.name = "timer"
>  };
> diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
> index 7f9e771..d3f1a15 100644
> --- a/arch/mips/kernel/i8259.c
> +++ b/arch/mips/kernel/i8259.c
> @@ -29,7 +29,7 @@
>   */
>  
>  static int i8259A_auto_eoi = -1;
> -DEFINE_SPINLOCK(i8259A_lock);
> +DEFINE_RAW_SPINLOCK(i8259A_lock);
>  static void disable_8259A_irq(unsigned int irq);
>  static void enable_8259A_irq(unsigned int irq);
>  static void mask_and_ack_8259A(unsigned int irq);
> @@ -310,6 +310,7 @@ static void init_8259A(int auto_eoi)
>   */
>  static struct irqaction irq2 = {
>  	.handler = no_action,
> +	.flags = IRQF_NODELAY,
>  	.mask = CPU_MASK_NONE,
>  	.name = "cascade",
>  };
> diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
> index 1f60e27..80b7a13 100644
> --- a/arch/mips/kernel/module.c
> +++ b/arch/mips/kernel/module.c
> @@ -41,7 +41,7 @@ struct mips_hi16 {
>  static struct mips_hi16 *mips_hi16_list;
>  
>  static LIST_HEAD(dbe_list);
> -static DEFINE_SPINLOCK(dbe_lock);
> +static DEFINE_RAW_SPINLOCK(dbe_lock);
>  
>  void *module_alloc(unsigned long size)
>  {
> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
> index ca2e402..048c829 100644
> --- a/arch/mips/kernel/process.c
> +++ b/arch/mips/kernel/process.c
> @@ -59,13 +59,17 @@ void __noreturn cpu_idle(void)
>  
>  			smtc_idle_loop_hook();
>  #endif
> +			stop_critical_timings();
>  			if (cpu_wait)
>  				(*cpu_wait)();
> +			start_critical_timings();
>  		}
>  		tick_nohz_restart_sched_tick();
> -		preempt_enable_no_resched();
> -		schedule();
> +		local_irq_disable();
> +		__preempt_enable_no_resched();
> +		__schedule();
>  		preempt_disable();
> +		local_irq_enable();
>  	}
>  }
>  
> diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
> index 9ab70c3..043b6ef 100644
> --- a/arch/mips/kernel/scall32-o32.S
> +++ b/arch/mips/kernel/scall32-o32.S
> @@ -69,7 +69,7 @@ stack_done:
>  1:	sw	v0, PT_R2(sp)		# result
>  
>  o32_syscall_exit:
> -	local_irq_disable		# make sure need_resched and
> +	raw_local_irq_disable		# make sure need_resched and
>  					# signals dont change between
>  					# sampling and return
>  	lw	a2, TI_FLAGS($28)	# current->work
> diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
> index 9b46986..caeb863 100644
> --- a/arch/mips/kernel/scall64-64.S
> +++ b/arch/mips/kernel/scall64-64.S
> @@ -72,7 +72,7 @@ NESTED(handle_sys64, PT_SIZE, sp)
>  1:	sd	v0, PT_R2(sp)		# result
>  
>  n64_syscall_exit:
> -	local_irq_disable		# make sure need_resched and
> +	raw_local_irq_disable		# make sure need_resched and
>  					# signals dont change between
>  					# sampling and return
>  	LONG_L	a2, TI_FLAGS($28)	# current->work
> diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
> index 7438e92..8c6dc72 100644
> --- a/arch/mips/kernel/scall64-n32.S
> +++ b/arch/mips/kernel/scall64-n32.S
> @@ -69,7 +69,7 @@ NESTED(handle_sysn32, PT_SIZE, sp)
>  	sd	v0, PT_R0(sp)		# set flag for syscall restarting
>  1:	sd	v0, PT_R2(sp)		# result
>  
> -	local_irq_disable		# make sure need_resched and
> +	raw_local_irq_disable		# make sure need_resched and
>  					# signals dont change between
>  					# sampling and return
>  	LONG_L  a2, TI_FLAGS($28)	# current->work
> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> index b0fef4f..115047c 100644
> --- a/arch/mips/kernel/scall64-o32.S
> +++ b/arch/mips/kernel/scall64-o32.S
> @@ -98,7 +98,7 @@ NESTED(handle_sys, PT_SIZE, sp)
>  1:	sd	v0, PT_R2(sp)		# result
>  
>  o32_syscall_exit:
> -	local_irq_disable		# make need_resched and
> +	raw_local_irq_disable		# make need_resched and
>  					# signals dont change between
>  					# sampling and return
>  	LONG_L	a2, TI_FLAGS($28)
> diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
> index 830c5ef..244f219 100644
> --- a/arch/mips/kernel/signal.c
> +++ b/arch/mips/kernel/signal.c
> @@ -549,6 +549,11 @@ static int setup_rt_frame(struct k_sigaction * ka, struct pt_regs *regs,
>  	if (err)
>  		goto give_sigsegv;
>  
> +#ifdef CONFIG_PREEMPT_RT
> +	local_irq_enable();
> +	preempt_check_resched();
> +#endif
> +
>  	/*
>  	 * Arguments to signal handler:
>  	 *
> diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
> index 2e74075..8f914b1 100644
> --- a/arch/mips/kernel/signal32.c
> +++ b/arch/mips/kernel/signal32.c
> @@ -667,6 +667,10 @@ static int setup_rt_frame_32(struct k_sigaction * ka, struct pt_regs *regs,
>  	if (err)
>  		goto give_sigsegv;
>  
> +#ifdef CONFIG_PREEMPT_RT
> +	local_irq_enable();
> +	preempt_check_resched();
> +#endif
>  	/*
>  	 * Arguments to signal handler:
>  	 *
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index 3da9470..19aab90 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -232,6 +232,8 @@ int setup_profiling_timer(unsigned int multiplier)
>  	return 0;
>  }
>  
> +static DEFINE_RAW_SPINLOCK(tlbstate_lock);
> +
>  static void flush_tlb_all_ipi(void *info)
>  {
>  	local_flush_tlb_all();
> @@ -289,6 +291,7 @@ static inline void smp_on_each_tlb(void (*func) (void *info), void *info)
>  void flush_tlb_mm(struct mm_struct *mm)
>  {
>  	preempt_disable();
> +	spin_lock(&tlbstate_lock);
>  
>  	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
>  		smp_on_other_tlbs(flush_tlb_mm_ipi, mm);
> @@ -301,6 +304,7 @@ void flush_tlb_mm(struct mm_struct *mm)
>  			if (cpu_context(cpu, mm))
>  				cpu_context(cpu, mm) = 0;
>  	}
> +	spin_unlock(&tlbstate_lock);
>  	local_flush_tlb_mm(mm);
>  
>  	preempt_enable();
> @@ -324,6 +328,8 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start, unsigned l
>  	struct mm_struct *mm = vma->vm_mm;
>  
>  	preempt_disable();
> +	spin_lock(&tlbstate_lock);
> +
>  	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
>  		struct flush_tlb_data fd = {
>  			.vma = vma,
> @@ -341,6 +347,7 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start, unsigned l
>  			if (cpu_context(cpu, mm))
>  				cpu_context(cpu, mm) = 0;
>  	}
> +	spin_unlock(&tlbstate_lock);
>  	local_flush_tlb_range(vma, start, end);
>  	preempt_enable();
>  }
> @@ -372,6 +379,7 @@ static void flush_tlb_page_ipi(void *info)
>  void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
>  {
>  	preempt_disable();
> +	spin_lock(&tlbstate_lock);
>  	if ((atomic_read(&vma->vm_mm->mm_users) != 1) || (current->mm != vma->vm_mm)) {
>  		struct flush_tlb_data fd = {
>  			.vma = vma,
> @@ -388,6 +396,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
>  			if (cpu_context(cpu, vma->vm_mm))
>  				cpu_context(cpu, vma->vm_mm) = 0;
>  	}
> +	spin_unlock(&tlbstate_lock);
>  	local_flush_tlb_page(vma, page);
>  	preempt_enable();
>  }
> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index b2d7041..63232be 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -351,7 +351,7 @@ void show_registers(const struct pt_regs *regs)
>  	printk("\n");
>  }
>  
> -static DEFINE_SPINLOCK(die_lock);
> +static DEFINE_RAW_SPINLOCK(die_lock);
>  
>  void __noreturn die(const char * str, const struct pt_regs * regs)
>  {
> diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
> index 3e0b7be..417faf4 100644
> --- a/arch/mips/lemote/lm2e/irq.c
> +++ b/arch/mips/lemote/lm2e/irq.c
> @@ -92,6 +92,7 @@ asmlinkage void plat_irq_dispatch(void)
>  
>  static struct irqaction cascade_irqaction = {
>  	.handler = no_action,
> +	.flags = IRQF_NODELAY,
>  	.mask = CPU_MASK_NONE,
>  	.name = "cascade",
>  };
> @@ -105,7 +106,8 @@ void __init arch_init_irq(void)
>  	 * int-handler is not on bootstrap
>  	 */
>  	clear_c0_status(ST0_IM | ST0_BEV);
> -	local_irq_disable();
> +	if (!irq_disabled())
> +		raw_local_irq_disable();
>  

ooh, an error here, irq_disabled should be irqs_disabled, just discover
it when compiling the kernel for fuloong2e.

>  	/* most bonito irq should be level triggered */
>  	BONITO_INTEDGE = BONITO_ICU_SYSTEMERR | BONITO_ICU_MASTERERR |
> diff --git a/arch/mips/lemote/lm2f/lmbook/irq.c b/arch/mips/lemote/lm2f/lmbook/irq.c
> index a0039eb..b7334ac 100644
> --- a/arch/mips/lemote/lm2f/lmbook/irq.c
> +++ b/arch/mips/lemote/lm2f/lmbook/irq.c
> @@ -174,6 +174,7 @@ asmlinkage void plat_irq_dispatch(void)
>  
>  static struct irqaction cascade_irqaction = {
>  	.handler = no_action,
> +	.flags = IRQF_NODELAY,
>  	.mask = CPU_MASK_NONE,
>  	.name = "cascade",
>  };
> @@ -187,7 +188,7 @@ static struct irqaction ip6_irqaction = {
>  	.handler = ip6_action,
>  	.mask = CPU_MASK_NONE,
>  	.name = "cascade",
> -	.flags = IRQF_SHARED,
> +	.flags = IRQF_SHARED | IRQF_NODELAY,
>  };
>  
>  void __init arch_init_irq(void)
> @@ -199,7 +200,8 @@ void __init arch_init_irq(void)
>  	 * int-handler is not on bootstrap
>  	 */
>  	clear_c0_status(ST0_IM | ST0_BEV);
> -	local_irq_disable();
> +	if (!irqs_disabled())
> +		raw_local_irq_disable();
>  	
>  	/* setup cs5536 as high level */
>  	BONITO_INTPOL  = (1 << 11 | 1 << 12);
> diff --git a/arch/mips/lemote/lm2f/lmbox/irq.c b/arch/mips/lemote/lm2f/lmbox/irq.c
> index d26da86..164e0f2 100644
> --- a/arch/mips/lemote/lm2f/lmbox/irq.c
> +++ b/arch/mips/lemote/lm2f/lmbox/irq.c
> @@ -174,6 +174,7 @@ asmlinkage void plat_irq_dispatch(void)
>  
>  static struct irqaction cascade_irqaction = {
>  	.handler = no_action,
> +	.flags = IRQF_NODELAY,
>  	.mask = CPU_MASK_NONE,
>  	.name = "cascade",
>  };
> @@ -187,7 +188,7 @@ static struct irqaction ip6_irqaction = {
>  	.handler = ip6_action,
>  	.mask = CPU_MASK_NONE,
>  	.name = "cascade",
> -	.flags = IRQF_SHARED,
> +	.flags = IRQF_SHARED | IRQF_NODELAY,
>  };
>  
>  void __init arch_init_irq(void)
> @@ -199,7 +200,8 @@ void __init arch_init_irq(void)
>  	 * int-handler is not on bootstrap
>  	 */
>  	clear_c0_status(ST0_IM | ST0_BEV);
> -	local_irq_disable();
> +	if (!irqs_disabled())
> +		raw_local_irq_disable();
>  	
>  	/* setup cs5536 as high level */
>  	BONITO_INTPOL  = (1 << 11 | 1 << 12);
> diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
> index 137c14b..e5e3028 100644
> --- a/arch/mips/mm/init.c
> +++ b/arch/mips/mm/init.c
> @@ -61,7 +61,7 @@
>  
>  #endif /* CONFIG_MIPS_MT_SMTC */
>  
> -DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> +DEFINE_PER_CPU_LOCKED(struct mmu_gather, mmu_gathers);
>  
>  /*
>   * We have up to 8 empty zeroed pages so we can map one of the right colour
> diff --git a/defconfig-fuloong-rt b/defconfig-fuloong-rt
> new file mode 100644
> index 0000000..becd80e
> --- /dev/null
> +++ b/defconfig-fuloong-rt
> @@ -0,0 +1,1038 @@
> +#
> +# Automatically generated make config: don't edit
> +# Linux kernel version: 2.6.29.1-rt8
> +# Sun Apr 19 15:47:09 2009
> +#
> +CONFIG_MIPS=y
> +
> +#
> +# Machine selection
> +#
> +# CONFIG_MACH_ALCHEMY is not set
> +# CONFIG_BASLER_EXCITE is not set
> +# CONFIG_BCM47XX is not set
> +# CONFIG_MIPS_COBALT is not set
> +# CONFIG_MACH_DECSTATION is not set
> +# CONFIG_MACH_JAZZ is not set
> +# CONFIG_LASAT is not set
> +# CONFIG_LEMOTE_FULONG is not set
> +CONFIG_MACH_LM2F=y
> +# CONFIG_MIPS_MALTA is not set
> +# CONFIG_MIPS_SIM is not set
> +# CONFIG_NEC_MARKEINS is not set
> +# CONFIG_MACH_VR41XX is not set
> +# CONFIG_NXP_STB220 is not set
> +# CONFIG_NXP_STB225 is not set
> +# CONFIG_PNX8550_JBS is not set
> +# CONFIG_PNX8550_STB810 is not set
> +# CONFIG_PMC_MSP is not set
> +# CONFIG_PMC_YOSEMITE is not set
> +# CONFIG_SGI_IP22 is not set
> +# CONFIG_SGI_IP27 is not set
> +# CONFIG_SGI_IP28 is not set
> +# CONFIG_SGI_IP32 is not set
> +# CONFIG_SIBYTE_CRHINE is not set
> +# CONFIG_SIBYTE_CARMEL is not set
> +# CONFIG_SIBYTE_CRHONE is not set
> +# CONFIG_SIBYTE_RHONE is not set
> +# CONFIG_SIBYTE_SWARM is not set
> +# CONFIG_SIBYTE_LITTLESUR is not set
> +# CONFIG_SIBYTE_SENTOSA is not set
> +# CONFIG_SIBYTE_BIGSUR is not set
> +# CONFIG_SNI_RM is not set
> +# CONFIG_MACH_TX39XX is not set
> +# CONFIG_MACH_TX49XX is not set
> +# CONFIG_MIKROTIK_RB532 is not set
> +# CONFIG_WR_PPMC is not set
> +# CONFIG_CAVIUM_OCTEON_SIMULATOR is not set
> +# CONFIG_CAVIUM_OCTEON_REFERENCE_BOARD is not set
> +CONFIG_LEMOTE_FULONG2F=y
> +# CONFIG_LEMOTE_2FNOTEBOOK is not set
> +CONFIG_CS5536_RTC_BUG=y
> +CONFIG_CS5536=y
> +# CONFIG_LEMOTE_NAS is not set
> +CONFIG_ARCH_SPARSEMEM_ENABLE=y
> +CONFIG_RWSEM_GENERIC_SPINLOCK=y
> +CONFIG_ASM_SEMAPHORE=y
> +# CONFIG_ARCH_HAS_ILOG2_U32 is not set
> +# CONFIG_ARCH_HAS_ILOG2_U64 is not set
> +CONFIG_ARCH_SUPPORTS_OPROFILE=y
> +CONFIG_GENERIC_FIND_NEXT_BIT=y
> +CONFIG_GENERIC_HWEIGHT=y
> +CONFIG_GENERIC_CALIBRATE_DELAY=y
> +CONFIG_GENERIC_CLOCKEVENTS=y
> +CONFIG_GENERIC_TIME=y
> +CONFIG_GENERIC_CMOS_UPDATE=y
> +CONFIG_SCHED_OMIT_FRAME_POINTER=y
> +CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
> +CONFIG_CEVT_R4K_LIB=y
> +CONFIG_CEVT_R4K=y
> +CONFIG_CSRC_R4K_LIB=y
> +CONFIG_CSRC_R4K=y
> +CONFIG_DMA_NONCOHERENT=y
> +CONFIG_DMA_NEED_PCI_MAP_STATE=y
> +CONFIG_EARLY_PRINTK=y
> +CONFIG_SYS_HAS_EARLY_PRINTK=y
> +# CONFIG_HOTPLUG_CPU is not set
> +CONFIG_I8259=y
> +# CONFIG_NO_IOPORT is not set
> +CONFIG_GENERIC_ISA_DMA=y
> +CONFIG_GENERIC_ISA_DMA_SUPPORT_BROKEN=y
> +# CONFIG_CPU_BIG_ENDIAN is not set
> +CONFIG_CPU_LITTLE_ENDIAN=y
> +CONFIG_SYS_SUPPORTS_LITTLE_ENDIAN=y
> +CONFIG_IRQ_CPU=y
> +CONFIG_BOOT_ELF32=y
> +CONFIG_MIPS_L1_CACHE_SHIFT=5
> +CONFIG_HAVE_STD_PC_SERIAL_PORT=y
> +
> +#
> +# CPU selection
> +#
> +CONFIG_CPU_LOONGSON2=y
> +# CONFIG_CPU_MIPS32_R1 is not set
> +# CONFIG_CPU_MIPS32_R2 is not set
> +# CONFIG_CPU_MIPS64_R1 is not set
> +# CONFIG_CPU_MIPS64_R2 is not set
> +# CONFIG_CPU_R3000 is not set
> +# CONFIG_CPU_TX39XX is not set
> +# CONFIG_CPU_VR41XX is not set
> +# CONFIG_CPU_R4300 is not set
> +# CONFIG_CPU_R4X00 is not set
> +# CONFIG_CPU_TX49XX is not set
> +# CONFIG_CPU_R5000 is not set
> +# CONFIG_CPU_R5432 is not set
> +# CONFIG_CPU_R5500 is not set
> +# CONFIG_CPU_R6000 is not set
> +# CONFIG_CPU_NEVADA is not set
> +# CONFIG_CPU_R8000 is not set
> +# CONFIG_CPU_R10000 is not set
> +# CONFIG_CPU_RM7000 is not set
> +# CONFIG_CPU_RM9000 is not set
> +# CONFIG_CPU_SB1 is not set
> +# CONFIG_CPU_CAVIUM_OCTEON is not set
> +CONFIG_SYS_HAS_CPU_LOONGSON2=y
> +CONFIG_SYS_SUPPORTS_32BIT_KERNEL=y
> +CONFIG_SYS_SUPPORTS_64BIT_KERNEL=y
> +CONFIG_CPU_SUPPORTS_32BIT_KERNEL=y
> +CONFIG_CPU_SUPPORTS_64BIT_KERNEL=y
> +
> +#
> +# Kernel type
> +#
> +# CONFIG_32BIT is not set
> +CONFIG_64BIT=y
> +# CONFIG_PAGE_SIZE_4KB is not set
> +# CONFIG_PAGE_SIZE_8KB is not set
> +CONFIG_PAGE_SIZE_16KB=y
> +# CONFIG_PAGE_SIZE_64KB is not set
> +CONFIG_BOARD_SCACHE=y
> +CONFIG_MIPS_MT_DISABLED=y
> +# CONFIG_MIPS_MT_SMP is not set
> +# CONFIG_MIPS_MT_SMTC is not set
> +CONFIG_CPU_HAS_WB=y
> +CONFIG_CPU_HAS_SYNC=y
> +CONFIG_GENERIC_HARDIRQS=y
> +CONFIG_GENERIC_IRQ_PROBE=y
> +CONFIG_CPU_SUPPORTS_HIGHMEM=y
> +CONFIG_SYS_SUPPORTS_HIGHMEM=y
> +CONFIG_ARCH_FLATMEM_ENABLE=y
> +CONFIG_ARCH_POPULATES_NODE_MAP=y
> +CONFIG_SELECT_MEMORY_MODEL=y
> +CONFIG_FLATMEM_MANUAL=y
> +# CONFIG_DISCONTIGMEM_MANUAL is not set
> +# CONFIG_SPARSEMEM_MANUAL is not set
> +CONFIG_FLATMEM=y
> +CONFIG_FLAT_NODE_MEM_MAP=y
> +CONFIG_SPARSEMEM_STATIC=y
> +CONFIG_PAGEFLAGS_EXTENDED=y
> +CONFIG_SPLIT_PTLOCK_CPUS=4
> +CONFIG_PHYS_ADDR_T_64BIT=y
> +CONFIG_ZONE_DMA_FLAG=0
> +CONFIG_VIRT_TO_BUS=y
> +CONFIG_UNEVICTABLE_LRU=y
> +CONFIG_TICK_ONESHOT=y
> +# CONFIG_NO_HZ is not set
> +CONFIG_HIGH_RES_TIMERS=y
> +CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> +# CONFIG_HZ_48 is not set
> +# CONFIG_HZ_100 is not set
> +# CONFIG_HZ_128 is not set
> +# CONFIG_HZ_250 is not set
> +# CONFIG_HZ_256 is not set
> +CONFIG_HZ_1000=y
> +# CONFIG_HZ_1024 is not set
> +CONFIG_SYS_SUPPORTS_ARBIT_HZ=y
> +CONFIG_HZ=1000
> +# CONFIG_PREEMPT_NONE is not set
> +# CONFIG_PREEMPT_VOLUNTARY is not set
> +# CONFIG_PREEMPT_DESKTOP is not set
> +CONFIG_PREEMPT_RT=y
> +CONFIG_PREEMPT=y
> +CONFIG_PREEMPT_SOFTIRQS=y
> +CONFIG_PREEMPT_HARDIRQS=y
> +# CONFIG_KEXEC is not set
> +# CONFIG_SECCOMP is not set
> +CONFIG_LOCKDEP_SUPPORT=y
> +CONFIG_STACKTRACE_SUPPORT=y
> +CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> +
> +#
> +# General setup
> +#
> +CONFIG_EXPERIMENTAL=y
> +CONFIG_BROKEN_ON_SMP=y
> +CONFIG_LOCK_KERNEL=y
> +CONFIG_INIT_ENV_ARG_LIMIT=32
> +CONFIG_LOCALVERSION="-fuloong2f"
> +# CONFIG_LOCALVERSION_AUTO is not set
> +# CONFIG_SWAP is not set
> +CONFIG_SYSVIPC=y
> +CONFIG_SYSVIPC_SYSCTL=y
> +CONFIG_POSIX_MQUEUE=y
> +# CONFIG_BSD_PROCESS_ACCT is not set
> +# CONFIG_TASKSTATS is not set
> +# CONFIG_AUDIT is not set
> +
> +#
> +# RCU Subsystem
> +#
> +# CONFIG_CLASSIC_RCU is not set
> +# CONFIG_TREE_RCU is not set
> +CONFIG_PREEMPT_RCU=y
> +# CONFIG_RCU_TRACE is not set
> +# CONFIG_TREE_RCU_TRACE is not set
> +# CONFIG_PREEMPT_RCU_TRACE is not set
> +# CONFIG_IKCONFIG is not set
> +CONFIG_LOG_BUF_SHIFT=15
> +# CONFIG_GROUP_SCHED is not set
> +# CONFIG_CGROUPS is not set
> +# CONFIG_RELAY is not set
> +# CONFIG_NAMESPACES is not set
> +# CONFIG_BLK_DEV_INITRD is not set
> +# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> +CONFIG_SYSCTL=y
> +CONFIG_ANON_INODES=y
> +CONFIG_EMBEDDED=y
> +# CONFIG_SYSCTL_SYSCALL is not set
> +# CONFIG_KALLSYMS is not set
> +# CONFIG_HOTPLUG is not set
> +CONFIG_PRINTK=y
> +CONFIG_BUG=y
> +# CONFIG_ELF_CORE is not set
> +# CONFIG_PCSPKR_PLATFORM is not set
> +CONFIG_BASE_FULL=y
> +CONFIG_FUTEX=y
> +CONFIG_EPOLL=y
> +CONFIG_SIGNALFD=y
> +CONFIG_TIMERFD=y
> +CONFIG_EVENTFD=y
> +# CONFIG_SHMEM is not set
> +CONFIG_AIO=y
> +
> +#
> +# Performance Counters
> +#
> +# CONFIG_VM_EVENT_COUNTERS is not set
> +CONFIG_PCI_QUIRKS=y
> +CONFIG_COMPAT_BRK=y
> +CONFIG_SLAB=y
> +# CONFIG_SLUB is not set
> +# CONFIG_SLOB is not set
> +# CONFIG_PROFILING is not set
> +# CONFIG_MARKERS is not set
> +CONFIG_HAVE_OPROFILE=y
> +CONFIG_HAVE_SYSCALL_WRAPPERS=y
> +# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> +CONFIG_SLABINFO=y
> +CONFIG_RT_MUTEXES=y
> +CONFIG_BASE_SMALL=0
> +# CONFIG_MODULES is not set
> +CONFIG_BLOCK=y
> +# CONFIG_BLK_DEV_BSG is not set
> +# CONFIG_BLK_DEV_INTEGRITY is not set
> +CONFIG_BLOCK_COMPAT=y
> +
> +#
> +# IO Schedulers
> +#
> +CONFIG_IOSCHED_NOOP=y
> +# CONFIG_IOSCHED_AS is not set
> +CONFIG_IOSCHED_DEADLINE=y
> +# CONFIG_IOSCHED_CFQ is not set
> +# CONFIG_DEFAULT_AS is not set
> +CONFIG_DEFAULT_DEADLINE=y
> +# CONFIG_DEFAULT_CFQ is not set
> +# CONFIG_DEFAULT_NOOP is not set
> +CONFIG_DEFAULT_IOSCHED="deadline"
> +# CONFIG_FREEZER is not set
> +
> +#
> +# Bus options (PCI, PCMCIA, EISA, ISA, TC)
> +#
> +CONFIG_HW_HAS_PCI=y
> +CONFIG_PCI=y
> +CONFIG_PCI_DOMAINS=y
> +# CONFIG_ARCH_SUPPORTS_MSI is not set
> +# CONFIG_PCI_LEGACY is not set
> +# CONFIG_PCI_STUB is not set
> +CONFIG_ISA=y
> +CONFIG_MMU=y
> +
> +#
> +# Executable file formats
> +#
> +CONFIG_BINFMT_ELF=y
> +# CONFIG_HAVE_AOUT is not set
> +# CONFIG_BINFMT_MISC is not set
> +CONFIG_MIPS32_COMPAT=y
> +CONFIG_COMPAT=y
> +CONFIG_SYSVIPC_COMPAT=y
> +CONFIG_MIPS32_O32=y
> +CONFIG_MIPS32_N32=y
> +CONFIG_BINFMT_ELF32=y
> +
> +#
> +# Power management options
> +#
> +CONFIG_ARCH_SUSPEND_POSSIBLE=y
> +# CONFIG_PM is not set
> +
> +#
> +# CPU Frequency scaling
> +#
> +# CONFIG_CPU_FREQ is not set
> +CONFIG_NET=y
> +
> +#
> +# Networking options
> +#
> +CONFIG_COMPAT_NET_DEV_OPS=y
> +CONFIG_PACKET=y
> +# CONFIG_PACKET_MMAP is not set
> +CONFIG_UNIX=y
> +# CONFIG_NET_KEY is not set
> +CONFIG_INET=y
> +# CONFIG_IP_MULTICAST is not set
> +# CONFIG_IP_ADVANCED_ROUTER is not set
> +CONFIG_IP_FIB_HASH=y
> +# CONFIG_IP_PNP is not set
> +# CONFIG_NET_IPIP is not set
> +# CONFIG_NET_IPGRE is not set
> +# CONFIG_ARPD is not set
> +# CONFIG_SYN_COOKIES is not set
> +# CONFIG_INET_AH is not set
> +# CONFIG_INET_ESP is not set
> +# CONFIG_INET_IPCOMP is not set
> +# CONFIG_INET_XFRM_TUNNEL is not set
> +# CONFIG_INET_TUNNEL is not set
> +# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> +# CONFIG_INET_XFRM_MODE_TUNNEL is not set
> +# CONFIG_INET_XFRM_MODE_BEET is not set
> +# CONFIG_INET_LRO is not set
> +# CONFIG_INET_DIAG is not set
> +# CONFIG_TCP_CONG_ADVANCED is not set
> +CONFIG_TCP_CONG_CUBIC=y
> +CONFIG_DEFAULT_TCP_CONG="cubic"
> +# CONFIG_TCP_MD5SIG is not set
> +# CONFIG_IPV6 is not set
> +# CONFIG_NETWORK_SECMARK is not set
> +# CONFIG_NETFILTER is not set
> +# CONFIG_IP_DCCP is not set
> +# CONFIG_IP_SCTP is not set
> +# CONFIG_TIPC is not set
> +# CONFIG_ATM is not set
> +# CONFIG_BRIDGE is not set
> +# CONFIG_NET_DSA is not set
> +# CONFIG_VLAN_8021Q is not set
> +# CONFIG_DECNET is not set
> +# CONFIG_LLC2 is not set
> +# CONFIG_IPX is not set
> +# CONFIG_ATALK is not set
> +# CONFIG_X25 is not set
> +# CONFIG_LAPB is not set
> +# CONFIG_ECONET is not set
> +# CONFIG_WAN_ROUTER is not set
> +# CONFIG_NET_SCHED is not set
> +# CONFIG_DCB is not set
> +
> +#
> +# Network testing
> +#
> +# CONFIG_NET_PKTGEN is not set
> +# CONFIG_HAMRADIO is not set
> +# CONFIG_CAN is not set
> +# CONFIG_IRDA is not set
> +# CONFIG_BT is not set
> +# CONFIG_AF_RXRPC is not set
> +# CONFIG_PHONET is not set
> +# CONFIG_WIRELESS is not set
> +# CONFIG_WIMAX is not set
> +# CONFIG_RFKILL is not set
> +
> +#
> +# Device Drivers
> +#
> +
> +#
> +# Generic Driver Options
> +#
> +CONFIG_STANDALONE=y
> +CONFIG_PREVENT_FIRMWARE_BUILD=y
> +# CONFIG_SYS_HYPERVISOR is not set
> +# CONFIG_CONNECTOR is not set
> +# CONFIG_MTD is not set
> +# CONFIG_PARPORT is not set
> +# CONFIG_PNP is not set
> +# CONFIG_BLK_DEV is not set
> +# CONFIG_MISC_DEVICES is not set
> +CONFIG_HAVE_IDE=y
> +CONFIG_IDE=y
> +
> +#
> +# Please see Documentation/ide/ide.txt for help/info on IDE drives
> +#
> +CONFIG_IDE_TIMINGS=y
> +# CONFIG_BLK_DEV_IDE_SATA is not set
> +CONFIG_IDE_GD=y
> +CONFIG_IDE_GD_ATA=y
> +# CONFIG_IDE_GD_ATAPI is not set
> +# CONFIG_BLK_DEV_IDECD is not set
> +# CONFIG_BLK_DEV_IDETAPE is not set
> +CONFIG_IDE_TASK_IOCTL=y
> +CONFIG_IDE_PROC_FS=y
> +
> +#
> +# IDE chipset support/bugfixes
> +#
> +# CONFIG_IDE_GENERIC is not set
> +# CONFIG_BLK_DEV_PLATFORM is not set
> +CONFIG_BLK_DEV_IDEDMA_SFF=y
> +
> +#
> +# PCI IDE chipsets support
> +#
> +CONFIG_BLK_DEV_IDEPCI=y
> +# CONFIG_IDEPCI_PCIBUS_ORDER is not set
> +# CONFIG_BLK_DEV_OFFBOARD is not set
> +CONFIG_BLK_DEV_GENERIC=y
> +# CONFIG_BLK_DEV_OPTI621 is not set
> +CONFIG_BLK_DEV_IDEDMA_PCI=y
> +# CONFIG_BLK_DEV_AEC62XX is not set
> +# CONFIG_BLK_DEV_ALI15X3 is not set
> +CONFIG_BLK_DEV_AMD74XX=y
> +# CONFIG_BLK_DEV_CMD64X is not set
> +# CONFIG_BLK_DEV_TRIFLEX is not set
> +# CONFIG_BLK_DEV_CS5520 is not set
> +# CONFIG_BLK_DEV_CS5530 is not set
> +# CONFIG_BLK_DEV_HPT366 is not set
> +CONFIG_BLK_DEV_JMICRON=y
> +# CONFIG_BLK_DEV_SC1200 is not set
> +# CONFIG_BLK_DEV_PIIX is not set
> +# CONFIG_BLK_DEV_IT8172 is not set
> +# CONFIG_BLK_DEV_IT8213 is not set
> +# CONFIG_BLK_DEV_IT821X is not set
> +# CONFIG_BLK_DEV_NS87415 is not set
> +# CONFIG_BLK_DEV_PDC202XX_OLD is not set
> +# CONFIG_BLK_DEV_PDC202XX_NEW is not set
> +# CONFIG_BLK_DEV_SVWKS is not set
> +# CONFIG_BLK_DEV_SIIMAGE is not set
> +# CONFIG_BLK_DEV_SLC90E66 is not set
> +# CONFIG_BLK_DEV_TRM290 is not set
> +# CONFIG_BLK_DEV_VIA82CXXX is not set
> +# CONFIG_BLK_DEV_TC86C001 is not set
> +
> +#
> +# Other IDE chipsets support
> +#
> +
> +#
> +# Note: most of these also require special kernel boot parameters
> +#
> +# CONFIG_BLK_DEV_4DRIVES is not set
> +# CONFIG_BLK_DEV_ALI14XX is not set
> +# CONFIG_BLK_DEV_DTC2278 is not set
> +# CONFIG_BLK_DEV_HT6560B is not set
> +# CONFIG_BLK_DEV_QD65XX is not set
> +# CONFIG_BLK_DEV_UMC8672 is not set
> +CONFIG_BLK_DEV_IDEDMA=y
> +
> +#
> +# SCSI device support
> +#
> +# CONFIG_RAID_ATTRS is not set
> +# CONFIG_SCSI is not set
> +# CONFIG_SCSI_DMA is not set
> +# CONFIG_SCSI_NETLINK is not set
> +# CONFIG_ATA is not set
> +# CONFIG_MD is not set
> +# CONFIG_FUSION is not set
> +
> +#
> +# IEEE 1394 (FireWire) support
> +#
> +
> +#
> +# Enable only one of the two stacks, unless you know what you are doing
> +#
> +# CONFIG_FIREWIRE is not set
> +# CONFIG_IEEE1394 is not set
> +# CONFIG_I2O is not set
> +CONFIG_NETDEVICES=y
> +# CONFIG_DUMMY is not set
> +# CONFIG_BONDING is not set
> +# CONFIG_MACVLAN is not set
> +# CONFIG_EQUALIZER is not set
> +# CONFIG_TUN is not set
> +# CONFIG_VETH is not set
> +# CONFIG_ARCNET is not set
> +# CONFIG_NET_ETHERNET is not set
> +CONFIG_MII=y
> +CONFIG_NETDEV_1000=y
> +# CONFIG_ACENIC is not set
> +# CONFIG_DL2K is not set
> +# CONFIG_E1000 is not set
> +# CONFIG_E1000E is not set
> +# CONFIG_IP1000 is not set
> +# CONFIG_IGB is not set
> +# CONFIG_NS83820 is not set
> +# CONFIG_HAMACHI is not set
> +# CONFIG_YELLOWFIN is not set
> +CONFIG_R8169=y
> +# CONFIG_SIS190 is not set
> +# CONFIG_SKGE is not set
> +# CONFIG_SKY2 is not set
> +# CONFIG_VIA_VELOCITY is not set
> +# CONFIG_TIGON3 is not set
> +# CONFIG_BNX2 is not set
> +# CONFIG_QLA3XXX is not set
> +# CONFIG_ATL1 is not set
> +# CONFIG_ATL1E is not set
> +# CONFIG_ATL1C is not set
> +# CONFIG_JME is not set
> +# CONFIG_NETDEV_10000 is not set
> +# CONFIG_TR is not set
> +
> +#
> +# Wireless LAN
> +#
> +# CONFIG_WLAN_PRE80211 is not set
> +# CONFIG_WLAN_80211 is not set
> +# CONFIG_IWLWIFI_LEDS is not set
> +
> +#
> +# Enable WiMAX (Networking options) to see the WiMAX drivers
> +#
> +
> +#
> +# USB Network Adapters
> +#
> +# CONFIG_USB_CATC is not set
> +# CONFIG_USB_KAWETH is not set
> +# CONFIG_USB_PEGASUS is not set
> +# CONFIG_USB_RTL8150 is not set
> +# CONFIG_USB_USBNET is not set
> +# CONFIG_WAN is not set
> +# CONFIG_FDDI is not set
> +# CONFIG_HIPPI is not set
> +# CONFIG_PPP is not set
> +# CONFIG_SLIP is not set
> +# CONFIG_NETCONSOLE is not set
> +# CONFIG_NETPOLL is not set
> +# CONFIG_NET_POLL_CONTROLLER is not set
> +# CONFIG_ISDN is not set
> +# CONFIG_PHONE is not set
> +
> +#
> +# Input device support
> +#
> +CONFIG_INPUT=y
> +# CONFIG_INPUT_FF_MEMLESS is not set
> +# CONFIG_INPUT_POLLDEV is not set
> +
> +#
> +# Userland interfaces
> +#
> +# CONFIG_INPUT_MOUSEDEV is not set
> +# CONFIG_INPUT_JOYDEV is not set
> +# CONFIG_INPUT_EVDEV is not set
> +# CONFIG_INPUT_EVBUG is not set
> +
> +#
> +# Input Device Drivers
> +#
> +CONFIG_INPUT_KEYBOARD=y
> +CONFIG_KEYBOARD_ATKBD=y
> +# CONFIG_KEYBOARD_SUNKBD is not set
> +# CONFIG_KEYBOARD_LKKBD is not set
> +# CONFIG_KEYBOARD_XTKBD is not set
> +# CONFIG_KEYBOARD_NEWTON is not set
> +# CONFIG_KEYBOARD_STOWAWAY is not set
> +CONFIG_INPUT_MOUSE=y
> +CONFIG_MOUSE_PS2=y
> +CONFIG_MOUSE_PS2_ALPS=y
> +CONFIG_MOUSE_PS2_LOGIPS2PP=y
> +CONFIG_MOUSE_PS2_SYNAPTICS=y
> +CONFIG_MOUSE_PS2_TRACKPOINT=y
> +# CONFIG_MOUSE_PS2_ELANTECH is not set
> +# CONFIG_MOUSE_PS2_TOUCHKIT is not set
> +# CONFIG_MOUSE_SERIAL is not set
> +# CONFIG_MOUSE_APPLETOUCH is not set
> +# CONFIG_MOUSE_BCM5974 is not set
> +# CONFIG_MOUSE_INPORT is not set
> +# CONFIG_MOUSE_LOGIBM is not set
> +# CONFIG_MOUSE_PC110PAD is not set
> +# CONFIG_MOUSE_VSXXXAA is not set
> +# CONFIG_INPUT_JOYSTICK is not set
> +# CONFIG_INPUT_TABLET is not set
> +# CONFIG_INPUT_TOUCHSCREEN is not set
> +# CONFIG_INPUT_MISC is not set
> +
> +#
> +# Hardware I/O ports
> +#
> +CONFIG_SERIO=y
> +# CONFIG_SERIO_I8042 is not set
> +CONFIG_SERIO_SERPORT=y
> +# CONFIG_SERIO_PCIPS2 is not set
> +CONFIG_SERIO_LIBPS2=y
> +# CONFIG_SERIO_RAW is not set
> +# CONFIG_GAMEPORT is not set
> +
> +#
> +# Character devices
> +#
> +CONFIG_VT=y
> +CONFIG_CONSOLE_TRANSLATIONS=y
> +CONFIG_VT_CONSOLE=y
> +CONFIG_HW_CONSOLE=y
> +# CONFIG_VT_HW_CONSOLE_BINDING is not set
> +# CONFIG_DEVKMEM is not set
> +CONFIG_SERIAL_NONSTANDARD=y
> +# CONFIG_COMPUTONE is not set
> +# CONFIG_ROCKETPORT is not set
> +# CONFIG_CYCLADES is not set
> +# CONFIG_DIGIEPCA is not set
> +# CONFIG_MOXA_INTELLIO is not set
> +# CONFIG_MOXA_SMARTIO is not set
> +# CONFIG_ISI is not set
> +# CONFIG_SYNCLINKMP is not set
> +# CONFIG_SYNCLINK_GT is not set
> +# CONFIG_N_HDLC is not set
> +# CONFIG_RISCOM8 is not set
> +# CONFIG_SPECIALIX is not set
> +# CONFIG_SX is not set
> +# CONFIG_RIO is not set
> +# CONFIG_STALDRV is not set
> +# CONFIG_NOZOMI is not set
> +
> +#
> +# Serial drivers
> +#
> +CONFIG_SERIAL_8250=y
> +CONFIG_SERIAL_8250_CONSOLE=y
> +CONFIG_SERIAL_8250_PCI=y
> +CONFIG_SERIAL_8250_NR_UARTS=16
> +CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> +# CONFIG_SERIAL_8250_EXTENDED is not set
> +
> +#
> +# Non-8250 serial port support
> +#
> +CONFIG_SERIAL_CORE=y
> +CONFIG_SERIAL_CORE_CONSOLE=y
> +# CONFIG_SERIAL_JSM is not set
> +CONFIG_UNIX98_PTYS=y
> +# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> +CONFIG_LEGACY_PTYS=y
> +CONFIG_LEGACY_PTY_COUNT=16
> +# CONFIG_IPMI_HANDLER is not set
> +# CONFIG_HW_RANDOM is not set
> +# CONFIG_RTC is not set
> +# CONFIG_DTLK is not set
> +# CONFIG_R3964 is not set
> +# CONFIG_APPLICOM is not set
> +# CONFIG_RAW_DRIVER is not set
> +# CONFIG_TCG_TPM is not set
> +CONFIG_DEVPORT=y
> +# CONFIG_I2C is not set
> +# CONFIG_SPI is not set
> +# CONFIG_W1 is not set
> +# CONFIG_POWER_SUPPLY is not set
> +# CONFIG_HWMON is not set
> +# CONFIG_THERMAL is not set
> +# CONFIG_THERMAL_HWMON is not set
> +# CONFIG_WATCHDOG is not set
> +CONFIG_SSB_POSSIBLE=y
> +
> +#
> +# Sonics Silicon Backplane
> +#
> +# CONFIG_SSB is not set
> +
> +#
> +# Multifunction device drivers
> +#
> +# CONFIG_MFD_CORE is not set
> +# CONFIG_MFD_SM501 is not set
> +# CONFIG_HTC_PASIC3 is not set
> +# CONFIG_MFD_TMIO is not set
> +# CONFIG_REGULATOR is not set
> +
> +#
> +# Multimedia devices
> +#
> +
> +#
> +# Multimedia core support
> +#
> +# CONFIG_VIDEO_DEV is not set
> +# CONFIG_DVB_CORE is not set
> +# CONFIG_VIDEO_MEDIA is not set
> +
> +#
> +# Multimedia drivers
> +#
> +# CONFIG_DAB is not set
> +
> +#
> +# Graphics support
> +#
> +# CONFIG_DRM is not set
> +CONFIG_VGASTATE=y
> +# CONFIG_VIDEO_OUTPUT_CONTROL is not set
> +CONFIG_FB=y
> +CONFIG_FIRMWARE_EDID=y
> +# CONFIG_FB_DDC is not set
> +CONFIG_FB_BOOT_VESA_SUPPORT=y
> +CONFIG_FB_CFB_FILLRECT=y
> +CONFIG_FB_CFB_COPYAREA=y
> +CONFIG_FB_CFB_IMAGEBLIT=y
> +# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> +CONFIG_FB_SYS_FILLRECT=y
> +CONFIG_FB_SYS_COPYAREA=y
> +CONFIG_FB_SYS_IMAGEBLIT=y
> +# CONFIG_FB_FOREIGN_ENDIAN is not set
> +CONFIG_FB_SYS_FOPS=y
> +# CONFIG_FB_SVGALIB is not set
> +# CONFIG_FB_MACMODES is not set
> +# CONFIG_FB_BACKLIGHT is not set
> +CONFIG_FB_MODE_HELPERS=y
> +CONFIG_FB_TILEBLITTING=y
> +
> +#
> +# Frame buffer hardware drivers
> +#
> +# CONFIG_FB_CIRRUS is not set
> +# CONFIG_FB_PM2 is not set
> +# CONFIG_FB_CYBER2000 is not set
> +# CONFIG_FB_ASILIANT is not set
> +# CONFIG_FB_IMSTT is not set
> +# CONFIG_FB_S1D13XXX is not set
> +# CONFIG_FB_NVIDIA is not set
> +CONFIG_FB_RIVA=y
> +# CONFIG_FB_RIVA_I2C is not set
> +# CONFIG_FB_RIVA_DEBUG is not set
> +# CONFIG_FB_RIVA_BACKLIGHT is not set
> +# CONFIG_FB_MATROX is not set
> +# CONFIG_FB_RADEON is not set
> +# CONFIG_FB_ATY128 is not set
> +# CONFIG_FB_ATY is not set
> +# CONFIG_FB_S3 is not set
> +# CONFIG_FB_SAVAGE is not set
> +CONFIG_FB_SIS=y
> +CONFIG_FB_SIS_300=y
> +CONFIG_FB_SIS_315=y
> +# CONFIG_FB_VIA is not set
> +# CONFIG_FB_NEOMAGIC is not set
> +# CONFIG_FB_KYRO is not set
> +# CONFIG_FB_3DFX is not set
> +# CONFIG_FB_VOODOO1 is not set
> +# CONFIG_FB_VT8623 is not set
> +# CONFIG_FB_TRIDENT is not set
> +# CONFIG_FB_ARK is not set
> +# CONFIG_FB_PM3 is not set
> +# CONFIG_FB_CARMINE is not set
> +# CONFIG_FB_SILICONMOTION is not set
> +CONFIG_FB_VIRTUAL=y
> +# CONFIG_FB_METRONOME is not set
> +# CONFIG_FB_MB862XX is not set
> +CONFIG_BACKLIGHT_LCD_SUPPORT=y
> +# CONFIG_LCD_CLASS_DEVICE is not set
> +CONFIG_BACKLIGHT_CLASS_DEVICE=y
> +CONFIG_BACKLIGHT_GENERIC=y
> +
> +#
> +# Display device support
> +#
> +# CONFIG_DISPLAY_SUPPORT is not set
> +
> +#
> +# Console display driver support
> +#
> +# CONFIG_VGA_CONSOLE is not set
> +# CONFIG_MDA_CONSOLE is not set
> +CONFIG_DUMMY_CONSOLE=y
> +CONFIG_FRAMEBUFFER_CONSOLE=y
> +# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> +CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> +# CONFIG_FONTS is not set
> +CONFIG_FONT_8x8=y
> +CONFIG_FONT_8x16=y
> +# CONFIG_LOGO is not set
> +# CONFIG_SOUND is not set
> +CONFIG_HID_SUPPORT=y
> +CONFIG_HID=y
> +# CONFIG_HID_DEBUG is not set
> +# CONFIG_HIDRAW is not set
> +
> +#
> +# USB Input Devices
> +#
> +CONFIG_USB_HID=y
> +# CONFIG_HID_PID is not set
> +# CONFIG_USB_HIDDEV is not set
> +
> +#
> +# Special HID drivers
> +#
> +CONFIG_HID_COMPAT=y
> +# CONFIG_HID_A4TECH is not set
> +# CONFIG_HID_APPLE is not set
> +# CONFIG_HID_BELKIN is not set
> +# CONFIG_HID_CHERRY is not set
> +# CONFIG_HID_CHICONY is not set
> +# CONFIG_HID_CYPRESS is not set
> +# CONFIG_HID_EZKEY is not set
> +# CONFIG_HID_GYRATION is not set
> +# CONFIG_HID_LOGITECH is not set
> +# CONFIG_HID_MICROSOFT is not set
> +# CONFIG_HID_MONTEREY is not set
> +# CONFIG_HID_NTRIG is not set
> +# CONFIG_HID_PANTHERLORD is not set
> +# CONFIG_HID_PETALYNX is not set
> +# CONFIG_HID_SAMSUNG is not set
> +# CONFIG_HID_SONY is not set
> +# CONFIG_HID_SUNPLUS is not set
> +# CONFIG_GREENASIA_FF is not set
> +# CONFIG_HID_TOPSEED is not set
> +# CONFIG_THRUSTMASTER_FF is not set
> +# CONFIG_ZEROPLUS_FF is not set
> +CONFIG_USB_SUPPORT=y
> +CONFIG_USB_ARCH_HAS_HCD=y
> +CONFIG_USB_ARCH_HAS_OHCI=y
> +CONFIG_USB_ARCH_HAS_EHCI=y
> +CONFIG_USB=y
> +# CONFIG_USB_DEBUG is not set
> +# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> +
> +#
> +# Miscellaneous USB options
> +#
> +CONFIG_USB_DEVICEFS=y
> +CONFIG_USB_DEVICE_CLASS=y
> +# CONFIG_USB_DYNAMIC_MINORS is not set
> +# CONFIG_USB_OTG is not set
> +# CONFIG_USB_OTG_WHITELIST is not set
> +# CONFIG_USB_OTG_BLACKLIST_HUB is not set
> +# CONFIG_USB_MON is not set
> +# CONFIG_USB_WUSB is not set
> +# CONFIG_USB_WUSB_CBAF is not set
> +
> +#
> +# USB Host Controller Drivers
> +#
> +# CONFIG_USB_C67X00_HCD is not set
> +CONFIG_USB_EHCI_HCD=y
> +CONFIG_USB_EHCI_ROOT_HUB_TT=y
> +# CONFIG_USB_EHCI_TT_NEWSCHED is not set
> +# CONFIG_USB_OXU210HP_HCD is not set
> +# CONFIG_USB_ISP116X_HCD is not set
> +# CONFIG_USB_ISP1760_HCD is not set
> +CONFIG_USB_OHCI_HCD=y
> +# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> +# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> +CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> +# CONFIG_USB_UHCI_HCD is not set
> +# CONFIG_USB_SL811_HCD is not set
> +# CONFIG_USB_R8A66597_HCD is not set
> +# CONFIG_USB_HWA_HCD is not set
> +
> +#
> +# USB Device Class drivers
> +#
> +# CONFIG_USB_ACM is not set
> +# CONFIG_USB_PRINTER is not set
> +# CONFIG_USB_WDM is not set
> +# CONFIG_USB_TMC is not set
> +
> +#
> +# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
> +#
> +
> +#
> +# see USB_STORAGE Help for more information
> +#
> +# CONFIG_USB_LIBUSUAL is not set
> +
> +#
> +# USB Imaging devices
> +#
> +# CONFIG_USB_MDC800 is not set
> +
> +#
> +# USB port drivers
> +#
> +# CONFIG_USB_SERIAL is not set
> +
> +#
> +# USB Miscellaneous drivers
> +#
> +# CONFIG_USB_EMI62 is not set
> +# CONFIG_USB_EMI26 is not set
> +# CONFIG_USB_ADUTUX is not set
> +# CONFIG_USB_SEVSEG is not set
> +# CONFIG_USB_RIO500 is not set
> +# CONFIG_USB_LEGOTOWER is not set
> +# CONFIG_USB_LCD is not set
> +# CONFIG_USB_BERRY_CHARGE is not set
> +# CONFIG_USB_LED is not set
> +# CONFIG_USB_CYPRESS_CY7C63 is not set
> +# CONFIG_USB_CYTHERM is not set
> +# CONFIG_USB_PHIDGET is not set
> +# CONFIG_USB_IDMOUSE is not set
> +# CONFIG_USB_FTDI_ELAN is not set
> +# CONFIG_USB_APPLEDISPLAY is not set
> +# CONFIG_USB_SISUSBVGA is not set
> +# CONFIG_USB_LD is not set
> +# CONFIG_USB_TRANCEVIBRATOR is not set
> +# CONFIG_USB_IOWARRIOR is not set
> +# CONFIG_USB_TEST is not set
> +# CONFIG_USB_ISIGHTFW is not set
> +# CONFIG_USB_VST is not set
> +
> +#
> +# OTG and related infrastructure
> +#
> +# CONFIG_UWB is not set
> +# CONFIG_MMC is not set
> +# CONFIG_MEMSTICK is not set
> +# CONFIG_NEW_LEDS is not set
> +# CONFIG_ACCESSIBILITY is not set
> +# CONFIG_RTC_CLASS is not set
> +# CONFIG_DMADEVICES is not set
> +# CONFIG_UIO is not set
> +# CONFIG_STAGING is not set
> +
> +#
> +# File systems
> +#
> +# CONFIG_EXT2_FS is not set
> +CONFIG_EXT3_FS=y
> +# CONFIG_EXT3_FS_XATTR is not set
> +# CONFIG_EXT4_FS is not set
> +CONFIG_JBD=y
> +# CONFIG_REISERFS_FS is not set
> +# CONFIG_JFS_FS is not set
> +# CONFIG_FS_POSIX_ACL is not set
> +CONFIG_FILE_LOCKING=y
> +# CONFIG_XFS_FS is not set
> +# CONFIG_GFS2_FS is not set
> +# CONFIG_BTRFS_FS is not set
> +# CONFIG_DNOTIFY is not set
> +# CONFIG_INOTIFY is not set
> +# CONFIG_QUOTA is not set
> +# CONFIG_AUTOFS_FS is not set
> +# CONFIG_AUTOFS4_FS is not set
> +# CONFIG_FUSE_FS is not set
> +
> +#
> +# CD-ROM/DVD Filesystems
> +#
> +# CONFIG_ISO9660_FS is not set
> +# CONFIG_UDF_FS is not set
> +
> +#
> +# DOS/FAT/NT Filesystems
> +#
> +# CONFIG_MSDOS_FS is not set
> +# CONFIG_VFAT_FS is not set
> +# CONFIG_NTFS_FS is not set
> +
> +#
> +# Pseudo filesystems
> +#
> +CONFIG_PROC_FS=y
> +CONFIG_PROC_KCORE=y
> +CONFIG_PROC_SYSCTL=y
> +CONFIG_PROC_PAGE_MONITOR=y
> +# CONFIG_SYSFS is not set
> +# CONFIG_TMPFS is not set
> +# CONFIG_HUGETLB_PAGE is not set
> +# CONFIG_MISC_FILESYSTEMS is not set
> +# CONFIG_NETWORK_FILESYSTEMS is not set
> +
> +#
> +# Partition Types
> +#
> +# CONFIG_PARTITION_ADVANCED is not set
> +CONFIG_MSDOS_PARTITION=y
> +# CONFIG_NLS is not set
> +
> +#
> +# Kernel hacking
> +#
> +CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> +# CONFIG_PRINTK_TIME is not set
> +CONFIG_ALLOW_WARNINGS=y
> +# CONFIG_ENABLE_WARN_DEPRECATED is not set
> +# CONFIG_ENABLE_MUST_CHECK is not set
> +CONFIG_FRAME_WARN=1024
> +# CONFIG_MAGIC_SYSRQ is not set
> +# CONFIG_UNUSED_SYMBOLS is not set
> +# CONFIG_HEADERS_CHECK is not set
> +# CONFIG_DEBUG_SECTION_MISMATCH is not set
> +# CONFIG_DEBUG_KERNEL is not set
> +# CONFIG_DEBUG_MEMORY_INIT is not set
> +CONFIG_TRACING_SUPPORT=y
> +
> +#
> +# Tracers
> +#
> +# CONFIG_IRQSOFF_TRACER is not set
> +# CONFIG_PREEMPT_TRACER is not set
> +# CONFIG_SCHED_TRACER is not set
> +# CONFIG_CONTEXT_SWITCH_TRACER is not set
> +# CONFIG_EVENT_TRACER is not set
> +# CONFIG_BOOT_TRACER is not set
> +# CONFIG_TRACE_BRANCH_PROFILING is not set
> +# CONFIG_KMEMTRACE is not set
> +# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
> +# CONFIG_SAMPLES is not set
> +CONFIG_HAVE_ARCH_KGDB=y
> +CONFIG_CMDLINE=""
> +
> +#
> +# Security options
> +#
> +# CONFIG_KEYS is not set
> +# CONFIG_SECURITYFS is not set
> +# CONFIG_SECURITY_FILE_CAPABILITIES is not set
> +# CONFIG_CRYPTO is not set
> +# CONFIG_BINARY_PRINTF is not set
> +
> +#
> +# Library routines
> +#
> +CONFIG_BITREVERSE=y
> +CONFIG_GENERIC_FIND_LAST_BIT=y
> +# CONFIG_CRC_CCITT is not set
> +# CONFIG_CRC16 is not set
> +# CONFIG_CRC_T10DIF is not set
> +# CONFIG_CRC_ITU_T is not set
> +CONFIG_CRC32=y
> +# CONFIG_CRC7 is not set
> +# CONFIG_LIBCRC32C is not set
> +CONFIG_HAS_IOMEM=y
> +CONFIG_HAS_IOPORT=y
> +CONFIG_HAS_DMA=y
> diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
> index d6a30ce..cfff67a 100644
> --- a/drivers/input/misc/pcspkr.c
> +++ b/drivers/input/misc/pcspkr.c
> @@ -29,7 +29,7 @@ MODULE_ALIAS("platform:pcspkr");
>  #include <asm/i8253.h>
>  #else
>  #include <asm/8253pit.h>
> -static DEFINE_SPINLOCK(i8253_lock);
> +static DEFINE_RAW_SPINLOCK(i8253_lock);
>  #endif
>  
>  static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 61fddc9..4b2c522 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -963,7 +963,7 @@ static inline u64 global_rt_runtime(void)
>  #ifndef prepare_arch_switch
>  # define prepare_arch_switch(next)	do { } while (0)
>  #endif
> -#ifndef finish_arch_switch
> +#ifndef _finish_arch_switch
>  # define _finish_arch_switch(prev)	do { } while (0)
>  #endif
>  

if we remove finish_arch_switch from arch/mips/include/asm/system.h, no
need to use the above patch in kernel/sched.c.

currently, there is no finish_arch_switch in x86, powerpc, so remove
mips specific finish_arch_switch directly?

> diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
> index cdef266..39dddc2 100644
> --- a/sound/drivers/pcsp/pcsp.h
> +++ b/sound/drivers/pcsp/pcsp.h
> @@ -15,7 +15,7 @@
>  #include <asm/i8253.h>
>  #else
>  #include <asm/8253pit.h>
> -static DEFINE_SPINLOCK(i8253_lock);
> +static DEFINE_RAW_SPINLOCK(i8253_lock);
>  #endif
>  
>  #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */

