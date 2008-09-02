Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYIBNEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYIBNEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYIBNE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:04:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40181 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYIBNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:04:25 -0400
Message-ID: <48BD393C.8040308@novell.com>
Date: Tue, 02 Sep 2008 09:01:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       andi@firstfloor.org, shemminger@vyatta.com
Subject: Re: [RT PATCH v3] seqlock: serialize against writers
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <20080902124252.26097.34310.stgit@dev.haskins.net>
In-Reply-To: <20080902124252.26097.34310.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3156684676D33E87E7F62445"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3156684676D33E87E7F62445
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Hi Guys,
>
> I realized the prologue was not sufficiently descriptive based on the
> feedback I received.  Therefore, here is a V3 with a new description.
> The patch content itself is identical to v2.
>  =20
/me grumbles.

Just realized I was in the wrong git branch when I updated this, so this
will not apply to 26.3-rt3.  I will correct and send a v4.  Sorry for
the noise.

-Greg


> -Greg
>
> ---------------------------------
>
> seqlock: serialize against writers
>
> There are currently several problems in -rt w.r.t. seqlock objects. RT
> moves mainline seqlock_t to "raw_seqlock_t", and creates a new seqlock_=
t
> object that is fully preemptible.  Being preemptible is a great step
> towards deterministic behavior, but there are a few areas that need
> additional measures to protect new vulnerabilities created by the
> preemptible code. For the purposes of demonstration, consider three tas=
ks
> of different priority: A, B, and C.  A is the logically highest, and C =
is
> the lowest.  A is trying to acquire a seqlock read critical section, wh=
ile
> C is involved in write locks.
>
> Problem 1) If A spins in seqbegin due to writer contention retries, it =
may
> prevent C from running even if C currently holds the write lock.  This
> is a deadlock.
>
> Problem 2) B may preempt C, preventing it from releasing the write
> critical section.  In this case, A becomes inverted behind B.
>
> Problem 3) Lower priority tasks such as C may continually acquire the w=
rite
> section which subsequently causes A to continually retry and thus fail =
to
> make forward progress.  Since C is lower priority it ideally should not=

> cause delays in A. E.g. C should block if A is in a read-lock and C is =
<=3D A.
>
> This patch addresses Problems 1 & 2, and leaves 3 for a later time.
>
> This patch changes the internal seqlock_t implementation to substitute
> a rwlock for the basic spinlock previously used, and forces the readers=

> to serialize with the writers under contention.  Blocking on the read_l=
ock
> simultaneously sleeps A (preventing problem 1), while boosting C to A's=

> priority (preventing problem 2).  Non reader-to-writer contended
> acquisitions, which are the predominant mode, remain free of atomic
> operations.  Therefore the fast path should not be perturbed by this
> change.
>
> This fixes a real-world deadlock discovered under testing where all
> high priority readers were hogging the cpus and preventing a writer
> from releasing the lock (i.e. problem 1).
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  include/linux/seqlock.h |   67 +++++++++++++++++++++++----------------=
--------
>  1 files changed, 33 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> index b172277..003d6e4 100644
> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -3,9 +3,11 @@
>  /*
>   * Reader/writer consistent mechanism without starving writers. This t=
ype of
>   * lock for data where the reader wants a consistent set of informatio=
n
> - * and is willing to retry if the information changes.  Readers never
> - * block but they may have to retry if a writer is in
> - * progress. Writers do not wait for readers.=20
> + * and is willing to retry if the information changes. Readers block
> + * on write contention (and where applicable, pi-boost the writer).
> + * Readers without contention on entry acquire the critical section
> + * without any atomic operations, but they may have to retry if a writ=
er
> + * enters before the critical section ends. Writers do not wait for re=
aders.
>   *
>   * This is not as cache friendly as brlock. Also, this will not work
>   * for data that contains pointers, because any writer could
> @@ -24,6 +26,8 @@
>   *
>   * Based on x86_64 vsyscall gettimeofday=20
>   * by Keith Owens and Andrea Arcangeli
> + *
> + * Priority inheritance and live-lock avoidance by Gregory Haskins
>   */
> =20
>  #include <linux/spinlock.h>
> @@ -31,7 +35,7 @@
> =20
>  typedef struct {
>  	unsigned sequence;
> -	spinlock_t lock;
> +	rwlock_t lock;
>  } __seqlock_t;
> =20
>  typedef struct {
> @@ -57,7 +61,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
>  		{ 0, RAW_SPIN_LOCK_UNLOCKED(lockname) }
> =20
>  #ifdef CONFIG_PREEMPT_RT
> -# define __SEQLOCK_UNLOCKED(lockname) { 0, __SPIN_LOCK_UNLOCKED(lockna=
me) }
> +# define __SEQLOCK_UNLOCKED(lockname) { 0, __RW_LOCK_UNLOCKED(lockname=
) }
>  #else
>  # define __SEQLOCK_UNLOCKED(lockname) __RAW_SEQLOCK_UNLOCKED(lockname)=

>  #endif
> @@ -69,7 +73,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
>  	do { *(x) =3D (raw_seqlock_t) __RAW_SEQLOCK_UNLOCKED(x); spin_lock_in=
it(&(x)->lock); } while (0)
> =20
>  #define seqlock_init(x) \
> -		do { *(x) =3D (seqlock_t) __SEQLOCK_UNLOCKED(x); spin_lock_init(&(x)=
->lock); } while (0)
> +		do { *(x) =3D (seqlock_t) __SEQLOCK_UNLOCKED(x); rwlock_init(&(x)->l=
ock); } while (0)
> =20
>  #define DEFINE_SEQLOCK(x) \
>  		seqlock_t x =3D __SEQLOCK_UNLOCKED(x)
> @@ -85,7 +89,7 @@ typedef __raw_seqlock_t raw_seqlock_t;
>   */
>  static inline void __write_seqlock(seqlock_t *sl)
>  {
> -	spin_lock(&sl->lock);
> +	write_lock(&sl->lock);
>  	++sl->sequence;
>  	smp_wmb();
>  }
> @@ -94,12 +98,12 @@ static inline void __write_sequnlock(seqlock_t *sl)=

>  {
>  	smp_wmb();
>  	sl->sequence++;
> -	spin_unlock(&sl->lock);
> +	write_unlock(&sl->lock);
>  }
> =20
>  static inline int __write_tryseqlock(seqlock_t *sl)
>  {
> -	int ret =3D spin_trylock(&sl->lock);
> +	int ret =3D write_trylock(&sl->lock);
> =20
>  	if (ret) {
>  		++sl->sequence;
> @@ -109,18 +113,25 @@ static inline int __write_tryseqlock(seqlock_t *s=
l)
>  }
> =20
>  /* Start of read calculation -- fetch last complete writer token */
> -static __always_inline unsigned __read_seqbegin(const seqlock_t *sl)
> +static __always_inline unsigned __read_seqbegin(seqlock_t *sl)
>  {
>  	unsigned ret;
> =20
> -repeat:
>  	ret =3D sl->sequence;
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
> +		ret =3D sl->sequence;
> +		read_unlock(&sl->lock);
>  	}
> =20
> +	BUG_ON(ret & 1);
> +
>  	return ret;
>  }
> =20
> @@ -132,20 +143,8 @@ repeat:
>   */
>  static inline int __read_seqretry(seqlock_t *sl, unsigned start)
>  {
> -	int ret;
> -
>  	smp_rmb();
> -	ret =3D (sl->sequence !=3D start);
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
> +	return (sl->sequence !=3D start);
>  }
> =20
>  static __always_inline void __write_seqlock_raw(raw_seqlock_t *sl)
> @@ -173,7 +172,7 @@ static __always_inline int __write_tryseqlock_raw(r=
aw_seqlock_t *sl)
>  	return ret;
>  }
> =20
> -static __always_inline unsigned __read_seqbegin_raw(const raw_seqlock_=
t *sl)
> +static __always_inline unsigned __read_seqbegin_raw(raw_seqlock_t *sl)=

>  {
>  	unsigned ret;
> =20
> @@ -188,7 +187,7 @@ repeat:
>  	return ret;
>  }
> =20
> -static __always_inline int __read_seqretry_raw(const raw_seqlock_t *sl=
, unsigned start)
> +static __always_inline int __read_seqretry_raw(raw_seqlock_t *sl, unsi=
gned start)
>  {
>  	smp_rmb();
>  	return (sl->sequence !=3D start);
> @@ -218,12 +217,12 @@ do {								\
>  	__ret;							\
>  })
> =20
> -#define PICK_SEQOP_CONST_RET(op, lock)				\
> +#define PICK_SEQOP_RET(op, lock)				\
>  ({								\
>  	unsigned long __ret;					\
>  								\
>  	if (TYPE_EQUAL((lock), raw_seqlock_t))			\
> -		__ret =3D op##_raw((const raw_seqlock_t *)(lock));\
> +		__ret =3D op##_raw((raw_seqlock_t *)(lock));\
>  	else if (TYPE_EQUAL((lock), seqlock_t))			\
>  		__ret =3D op((seqlock_t *)(lock));		\
>  	else __ret =3D __bad_seqlock_type();			\
> @@ -231,12 +230,12 @@ do {								\
>  	__ret;							\
>  })
> =20
> -#define PICK_SEQOP2_CONST_RET(op, lock, arg)				\
> +#define PICK_SEQOP2_RET(op, lock, arg)					\
>   ({									\
>  	unsigned long __ret;						\
>  									\
>  	if (TYPE_EQUAL((lock), raw_seqlock_t))				\
> -		__ret =3D op##_raw((const raw_seqlock_t *)(lock), (arg));	\
> +		__ret =3D op##_raw((raw_seqlock_t *)(lock), (arg));	\
>  	else if (TYPE_EQUAL((lock), seqlock_t))				\
>  		__ret =3D op((seqlock_t *)(lock), (arg));			\
>  	else __ret =3D __bad_seqlock_type();				\
> @@ -248,8 +247,8 @@ do {								\
>  #define write_seqlock(sl)	PICK_SEQOP(__write_seqlock, sl)
>  #define write_sequnlock(sl)	PICK_SEQOP(__write_sequnlock, sl)
>  #define write_tryseqlock(sl)	PICK_SEQOP_RET(__write_tryseqlock, sl)
> -#define read_seqbegin(sl)	PICK_SEQOP_CONST_RET(__read_seqbegin, sl)
> -#define read_seqretry(sl, iv)	PICK_SEQOP2_CONST_RET(__read_seqretry, s=
l, iv)
> +#define read_seqbegin(sl)	PICK_SEQOP_RET(__read_seqbegin, sl)
> +#define read_seqretry(sl, iv)	PICK_SEQOP2_RET(__read_seqretry, sl, iv)=

> =20
>  /*
>   * Version using sequence counter only.
>
>  =20



--------------enig3156684676D33E87E7F62445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki9OTwACgkQlOSOBdgZUxmSKQCfY5pi6GlkzcPbIHvm+LEqwP99
RSoAnR6cIZIDDI17hfQ28ukefADjAaa2
=5bW3
-----END PGP SIGNATURE-----

--------------enig3156684676D33E87E7F62445--
