Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYH2Q5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYH2Q5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYH2Q5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:57:32 -0400
Received: from mail.vyatta.com ([216.93.170.194]:32778 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbYH2Q5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:57:31 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.706
Date: Fri, 29 Aug 2008 09:57:29 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Subject: Re: [PATCH] seqlock: serialize against writers
Message-ID: <20080829095729.0966d38e@extreme>
In-Reply-To: <20080829154237.1196.66825.stgit@dev.haskins.net>
References: <20080829154237.1196.66825.stgit@dev.haskins.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 11:44:58 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> *Patch submitted for inclusion in PREEMPT_RT 26-rt4.  Applies to 2.6.26.3-rt3*
> 
> Hi Ingo, Steven, Thomas,
>   Please consider for -rt4.  This fixes a nasty deadlock on my systems under
>   heavy load.
> 
> -Greg
> 
> ----
> 
> Seqlocks have always advertised that readers do not "block", but this was
> never really true.  Readers have always logically blocked at the head of
> the critical section under contention with writers, regardless of whether
> they were allowed to run code or not.
> 
> Recent changes in this space (88a411c07b6fedcfc97b8dc51ae18540bd2beda0)
> have turned this into a more explicit blocking operation in mainline.
> However, this change highlights a short-coming in -rt because the
> normal seqlock_ts are preemptible.  This means that we can potentially
> deadlock should a reader spin waiting for a write critical-section to end
> while the writer is preempted.
> 
> This patch changes the internal implementation to use a rwlock and forces
> the readers to serialize with the writers under contention.  This will
> have the advantage that -rt seqlocks_t will sleep the reader if deadlock
> were imminent, and it will pi-boost the writer to prevent inversion.
> 
> This fixes a deadlock discovered under testing where all high prioritiy
> readers were hogging the cpus and preventing a writer from releasing the
> lock.
> 
> Since seqlocks are designed to be used as rarely-write locks, this should
> not affect the performance in the fast-path
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  include/linux/seqlock.h |   76 +++++++++++++++++++++++++----------------------
>  1 files changed, 40 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> index 345d726..7010169 100644
> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -3,9 +3,11 @@
>  /*
>   * Reader/writer consistent mechanism without starving writers. This type of
>   * lock for data where the reader wants a consistent set of information
> - * and is willing to retry if the information changes.  Readers never
> - * block but they may have to retry if a writer is in
> - * progress. Writers do not wait for readers. 
> + * and is willing to retry if the information changes. Readers block
> + * on write contention (and where applicable, pi-boost the writer).
> + * Readers without contention on entry acquire the critical section
> + * without any atomic operations, but they may have to retry if a writer
> + * enters before the critical section ends. Writers do not wait for readers.
>   *
>   * This is not as cache friendly as brlock. Also, this will not work
>   * for data that contains pointers, because any writer could
> @@ -24,6 +26,8 @@
>   *
>   * Based on x86_64 vsyscall gettimeofday 
>   * by Keith Owens and Andrea Arcangeli
> + *
> + * Priority inheritance and live-lock avoidance by Gregory Haskins
>   */
>  
>  #include <linux/spinlock.h>
> @@ -31,12 +35,12 @@
>  
>  typedef struct {
>  	unsigned sequence;
> -	spinlock_t lock;
> +	rwlock_t lock;
>  } __seqlock_t;
>  
>  typedef struct {
>  	unsigned sequence;
> -	raw_spinlock_t lock;
> +	raw_rwlock_t lock;
>  } __raw_seqlock_t;
>  
>  #define seqlock_need_resched(seq) lock_need_resched(&(seq)->lock)
> @@ -54,10 +58,10 @@ typedef __raw_seqlock_t raw_seqlock_t;
>   * OK now.  Be cautious.
>   */
>  #define __RAW_SEQLOCK_UNLOCKED(lockname) \
> -		{ 0, RAW_SPIN_LOCK_UNLOCKED(lockname) }
> +		{ 0, RAW_RW_LOCK_UNLOCKED(lockname) }
>  
>  #ifdef CONFIG_PREEMPT_RT
> -# define __SEQLOCK_UNLOCKED(lockname) { 0, __SPIN_LOCK_UNLOCKED(lockname) }
> +# define __SEQLOCK_UNLOCKED(lockname) { 0, __RW_LOCK_UNLOCKED(lockname) }
>  #else
>  # define __SEQLOCK_UNLOCKED(lockname) __RAW_SEQLOCK_UNLOCKED(lockname)
>  #endif
> @@ -66,10 +70,10 @@ typedef __raw_seqlock_t raw_seqlock_t;
>  		 __SEQLOCK_UNLOCKED(old_style_seqlock_init)
>  
>  #define raw_seqlock_init(x) \
> -	do { *(x) = (raw_seqlock_t) __RAW_SEQLOCK_UNLOCKED(x); spin_lock_init(&(x)->lock); } while (0)
> +	do { *(x) = (raw_seqlock_t) __RAW_SEQLOCK_UNLOCKED(x); rwlock_init(&(x)->lock); } while (0)
>  
>  #define seqlock_init(x) \
> -		do { *(x) = (seqlock_t) __SEQLOCK_UNLOCKED(x); spin_lock_init(&(x)->lock); } while (0)
> +		do { *(x) = (seqlock_t) __SEQLOCK_UNLOCKED(x); rwlock_init(&(x)->lock); } while (0)
>  
>  #define DEFINE_SEQLOCK(x) \
>  		seqlock_t x = __SEQLOCK_UNLOCKED(x)
> @@ -85,7 +89,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
>   */
>  static inline void __write_seqlock(seqlock_t *sl)
>  {
> -	spin_lock(&sl->lock);
> +	write_lock(&sl->lock);
>  	++sl->sequence;
>  	smp_wmb();
>  }
> @@ -103,14 +107,14 @@ static inline void __write_sequnlock(seqlock_t *sl)
>  {
>  	smp_wmb();
>  	sl->sequence++;
> -	spin_unlock(&sl->lock);
> +	write_unlock(&sl->lock);
>  }
>  
>  #define __write_sequnlock_irqrestore(sl, flags)	__write_sequnlock(sl)
>  
>  static inline int __write_tryseqlock(seqlock_t *sl)
>  {
> -	int ret = spin_trylock(&sl->lock);
> +	int ret = write_trylock(&sl->lock);
>  
>  	if (ret) {
>  		++sl->sequence;
> @@ -120,18 +124,25 @@ static inline int __write_tryseqlock(seqlock_t *sl)
>  }
>  
>  /* Start of read calculation -- fetch last complete writer token */
> -static __always_inline unsigned __read_seqbegin(const seqlock_t *sl)
> +static __always_inline unsigned __read_seqbegin(seqlock_t *sl)
>  {
>  	unsigned ret;
>  
> -repeat:
>  	ret = sl->sequence;
>  	smp_rmb();
>  	if (unlikely(ret & 1)) {
> -		cpu_relax();
> -		goto repeat;
> +		/*
> +		 * Serialze with the writer which will ensure they are
> +		 * pi-boosted if necessary and prevent us from starving
> +		 * them.
> +		 */
> +		read_lock(&sl->lock);
> +		ret = sl->sequence;
> +		read_unlock(&sl->lock);
>  	}
>  
> +	BUG_ON(ret & 1);
> +
>  	return ret;
>  }
>  
> @@ -142,25 +153,13 @@ repeat:
>   */
>  static inline int __read_seqretry(seqlock_t *sl, unsigned iv)
>  {
> -	int ret;
> -
>  	smp_rmb();
> -	ret = (sl->sequence != iv);
> -	/*
> -	 * If invalid then serialize with the writer, to make sure we
> -	 * are not livelocking it:
> -	 */
> -	if (unlikely(ret)) {
> -		unsigned long flags;
> -		spin_lock_irqsave(&sl->lock, flags);
> -		spin_unlock_irqrestore(&sl->lock, flags);
> -	}
> -	return ret;
> +	return (sl->sequence != iv);
>  }
>  
>  static __always_inline void __write_seqlock_raw(raw_seqlock_t *sl)
>  {
> -	spin_lock(&sl->lock);
> +	write_lock(&sl->lock);
>  	++sl->sequence;
>  	smp_wmb();
>  }
> @@ -191,7 +190,7 @@ static __always_inline void __write_sequnlock_raw(raw_seqlock_t *sl)
>  {
>  	smp_wmb();
>  	sl->sequence++;
> -	spin_unlock(&sl->lock);
> +	write_unlock(&sl->lock);
>  }
>  
>  static __always_inline void
> @@ -217,7 +216,7 @@ static __always_inline void __write_sequnlock_bh_raw(raw_seqlock_t *sl)
>  
>  static __always_inline int __write_tryseqlock_raw(raw_seqlock_t *sl)
>  {
> -	int ret = spin_trylock(&sl->lock);
> +	int ret = write_trylock(&sl->lock);
>  
>  	if (ret) {
>  		++sl->sequence;
> @@ -226,18 +225,23 @@ static __always_inline int __write_tryseqlock_raw(raw_seqlock_t *sl)
>  	return ret;
>  }
>  
> -static __always_inline unsigned __read_seqbegin_raw(const raw_seqlock_t *sl)
> +static __always_inline unsigned __read_seqbegin_raw(raw_seqlock_t *sl)
>  {
>  	unsigned ret;
>  
> -repeat:
>  	ret = sl->sequence;
>  	smp_rmb();
>  	if (unlikely(ret & 1)) {
> -		cpu_relax();
> -		goto repeat;
> +		/*
> +		 * Serialize with the writer
> +		 */
> +		read_lock(&sl->lock);
> +		ret = sl->sequence;
> +		read_unlock(&sl->lock);
>  	}
>  
> +	BUG_ON(ret & 1);
> +
>  	return ret;
>  }
>  

I have mixed feelings about this. The point of this primitive was for
cases where write contention was rare and writers only did small updates.
So what you did was fix the primitive for cases where it is being misused.
Do you have a real example where this is a problem? If so then the
user of seqlock should be fixed, rather than fixing seqlock.
