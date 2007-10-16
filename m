Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXJPIfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXJPIfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbXJPIfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:35:20 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:12466 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbXJPIfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=nxjDnMY6UX0pLDO+ToIngrs+oQ4wIF0EKW5fipx9awqnbj8X5FZON2vjiqOAxjO7GPBVSJ4x6RaP0WIFx287yJzby+Wahzm9L84MpSGzL9fU+5UB9HSxZL2MDwPGIjaazgS+sEtdx0gkw3UxWjWXW7Di2KeL0QlZw1Br6bRJxaA=
Message-ID: <3efb10970710160135q31fd3982h17fa23768960186d@mail.gmail.com>
Date: Tue, 16 Oct 2007 10:35:15 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: [RT] seqlocks: use of PICK_FUNCTION breaks kernel compile when CONFIG_GENERIC_TIME is NOT set
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_64028_6183109.1192523715754"
X-Google-Sender-Auth: 4d8dc42bc11e0e1d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_64028_6183109.1192523715754
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Daniel and Ingo,

I use 2.6.23-rt1 and the patch of Daniel below which seems to be in
there breaks the compilation of the RT-kernel when CONFIG_GENERIC_TIME
is NOT set.

It breaks in the do_gettimeofday(struct timeval *tv) code in the
architecture specific code
where there is a call to: seq = read_seqbegin_irqsave(&xtime_lock, flags);
The PICK_FUNCTION implementation does not return anything, so the
compile breaks here.

I am figuring out how to solve this problem nicely, but I have not
found a nice solution yet. Attached I have put my hack to make it
compile on ARM again, but maybe one of you can do a better proposal to
fix this.

Here is a list of files that will probably all fail to build: (I only
tested ARM)
linux-2.6.23/arch/arm/kernel/time.c:254
linux-2.6.23/arch/xtensa/kernel/time.c:132
linux-2.6.23/arch/sparc/kernel/time.c:453
linux-2.6.23/arch/sparc/kernel/pcic.c:776
linux-2.6.23/arch/blackfin/kernel/time.c:269
linux-2.6.23/arch/m68knommu/kernel/time.c:130
linux-2.6.23/arch/sh64/kernel/time.c:193
linux-2.6.23/arch/alpha/kernel/time.c:408
linux-2.6.23/arch/sh/kernel/time.c:65
linux-2.6.23/arch/m68k/kernel/time.c:104
linux-2.6.23/arch/ppc/kernel/time.c:207
linux-2.6.23/arch/s390/kernel/time.c:197


Kind Regards,

Remy Bohmer


2007/8/28, Daniel Walker <dwalker@mvista.com>:
> Replace the old PICK_OP style macros with PICK_FUNCTION. Although,
> seqlocks has some alien code, which I also replaced as can be seen
> from the line count below.
>
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
>
> ---
>  include/linux/pickop.h  |    4
>  include/linux/seqlock.h |  235 +++++++++++++++++++++++++++---------------------
>  2 files changed, 135 insertions(+), 104 deletions(-)
>
> Index: linux-2.6.22/include/linux/pickop.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/pickop.h
> +++ linux-2.6.22/include/linux/pickop.h
> @@ -1,10 +1,6 @@
>  #ifndef _LINUX_PICKOP_H
>  #define _LINUX_PICKOP_H
>
> -#undef TYPE_EQUAL
> -#define TYPE_EQUAL(var, type) \
> -               __builtin_types_compatible_p(typeof(var), type *)
> -
>  #undef PICK_TYPE_EQUAL
>  #define PICK_TYPE_EQUAL(var, type) \
>                 __builtin_types_compatible_p(typeof(var), type)
> Index: linux-2.6.22/include/linux/seqlock.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/seqlock.h
> +++ linux-2.6.22/include/linux/seqlock.h
> @@ -90,6 +90,12 @@ static inline void __write_seqlock(seqlo
>         smp_wmb();
>  }
>
> +static __always_inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
> +{
> +       __write_seqlock(sl);
> +       return 0;
> +}
> +
>  static inline void __write_sequnlock(seqlock_t *sl)
>  {
>         smp_wmb();
> @@ -97,6 +103,8 @@ static inline void __write_sequnlock(seq
>         spin_unlock(&sl->lock);
>  }
>
> +#define __write_sequnlock_irqrestore(sl, flags)        __write_sequnlock(sl)
> +
>  static inline int __write_tryseqlock(seqlock_t *sl)
>  {
>         int ret = spin_trylock(&sl->lock);
> @@ -149,6 +157,28 @@ static __always_inline void __write_seql
>         smp_wmb();
>  }
>
> +static __always_inline unsigned long
> +__write_seqlock_irqsave_raw(raw_seqlock_t *sl)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       __write_seqlock_raw(sl);
> +       return flags;
> +}
> +
> +static __always_inline void __write_seqlock_irq_raw(raw_seqlock_t *sl)
> +{
> +       local_irq_disable();
> +       __write_seqlock_raw(sl);
> +}
> +
> +static __always_inline void __write_seqlock_bh_raw(raw_seqlock_t *sl)
> +{
> +       local_bh_disable();
> +       __write_seqlock_raw(sl);
> +}
> +
>  static __always_inline void __write_sequnlock_raw(raw_seqlock_t *sl)
>  {
>         smp_wmb();
> @@ -156,6 +186,27 @@ static __always_inline void __write_sequ
>         spin_unlock(&sl->lock);
>  }
>
> +static __always_inline void
> +__write_sequnlock_irqrestore_raw(raw_seqlock_t *sl, unsigned long flags)
> +{
> +       __write_sequnlock_raw(sl);
> +       local_irq_restore(flags);
> +       preempt_check_resched();
> +}
> +
> +static __always_inline void __write_sequnlock_irq_raw(raw_seqlock_t *sl)
> +{
> +       __write_sequnlock_raw(sl);
> +       local_irq_enable();
> +       preempt_check_resched();
> +}
> +
> +static __always_inline void __write_sequnlock_bh_raw(raw_seqlock_t *sl)
> +{
> +       __write_sequnlock_raw(sl);
> +       local_bh_enable();
> +}
> +
>  static __always_inline int __write_tryseqlock_raw(raw_seqlock_t *sl)
>  {
>         int ret = spin_trylock(&sl->lock);
> @@ -182,60 +233,93 @@ static __always_inline int __read_seqret
>
>  extern int __bad_seqlock_type(void);
>
> -#define PICK_SEQOP(op, lock)                                   \
> +/*
> + * PICK_SEQ_OP() is a small redirector to allow less typing of the lock
> + * types raw_seqlock_t, seqlock_t, at the front of the PICK_FUNCTION
> + * macro.
> + */
> +#define PICK_SEQ_OP(...)       \
> +       PICK_FUNCTION(raw_seqlock_t *, seqlock_t *, ##__VA_ARGS__)
> +#define PICK_SEQ_OP_RET(...) \
> +       PICK_FUNCTION_RET(raw_seqlock_t *, seqlock_t *, ##__VA_ARGS__)
> +
> +#define write_seqlock(sl) PICK_SEQ_OP(__write_seqlock_raw, __write_seqlock, sl)
> +
> +#define write_sequnlock(sl)    \
> +       PICK_SEQ_OP(__write_sequnlock_raw, __write_sequnlock, sl)
> +
> +#define write_tryseqlock(sl)   \
> +       PICK_SEQ_OP_RET(__write_tryseqlock_raw, __write_tryseqlock, sl)
> +
> +#define read_seqbegin(sl)      \
> +       PICK_SEQ_OP_RET(__read_seqbegin_raw, __read_seqbegin, sl)
> +
> +#define read_seqretry(sl, iv)  \
> +       PICK_SEQ_OP_RET(__read_seqretry_raw, __read_seqretry, sl, iv)
> +
> +#define write_seqlock_irqsave(lock, flags)                     \
>  do {                                                           \
> -       if (TYPE_EQUAL((lock), raw_seqlock_t))                  \
> -               op##_raw((raw_seqlock_t *)(lock));              \
> -       else if (TYPE_EQUAL((lock), seqlock_t))                 \
> -               op((seqlock_t *)(lock));                        \
> -       else __bad_seqlock_type();                              \
> +       flags = PICK_SEQ_OP_RET(__write_seqlock_irqsave_raw,    \
> +               __write_seqlock_irqsave, lock);                 \
>  } while (0)
>
> -#define PICK_SEQOP_RET(op, lock)                               \
> -({                                                             \
> -       unsigned long __ret;                                    \
> -                                                               \
> -       if (TYPE_EQUAL((lock), raw_seqlock_t))                  \
> -               __ret = op##_raw((raw_seqlock_t *)(lock));      \
> -       else if (TYPE_EQUAL((lock), seqlock_t))                 \
> -               __ret = op((seqlock_t *)(lock));                \
> -       else __ret = __bad_seqlock_type();                      \
> -                                                               \
> -       __ret;                                                  \
> -})
> -
> -#define PICK_SEQOP_CONST_RET(op, lock)                         \
> -({                                                             \
> -       unsigned long __ret;                                    \
> -                                                               \
> -       if (TYPE_EQUAL((lock), raw_seqlock_t))                  \
> -               __ret = op##_raw((const raw_seqlock_t *)(lock));\
> -       else if (TYPE_EQUAL((lock), seqlock_t))                 \
> -               __ret = op((seqlock_t *)(lock));                \
> -       else __ret = __bad_seqlock_type();                      \
> -                                                               \
> -       __ret;                                                  \
> -})
> -
> -#define PICK_SEQOP2_CONST_RET(op, lock, arg)                           \
> - ({                                                                    \
> -       unsigned long __ret;                                            \
> -                                                                       \
> -       if (TYPE_EQUAL((lock), raw_seqlock_t))                          \
> -               __ret = op##_raw((const raw_seqlock_t *)(lock), (arg)); \
> -       else if (TYPE_EQUAL((lock), seqlock_t))                         \
> -               __ret = op((seqlock_t *)(lock), (arg));                 \
> -       else __ret = __bad_seqlock_type();                              \
> -                                                                       \
> -       __ret;                                                          \
> -})
> -
> -
> -#define write_seqlock(sl)      PICK_SEQOP(__write_seqlock, sl)
> -#define write_sequnlock(sl)    PICK_SEQOP(__write_sequnlock, sl)
> -#define write_tryseqlock(sl)   PICK_SEQOP_RET(__write_tryseqlock, sl)
> -#define read_seqbegin(sl)      PICK_SEQOP_CONST_RET(__read_seqbegin, sl)
> -#define read_seqretry(sl, iv)  PICK_SEQOP2_CONST_RET(__read_seqretry, sl, iv)
> +#define write_seqlock_irq(lock)        \
> +       PICK_SEQ_OP(__write_seqlock_irq_raw, __write_seqlock, lock)
> +
> +#define write_seqlock_bh(lock) \
> +       PICK_SEQ_OP(__write_seqlock_bh_raw, __write_seqlock, lock)
> +
> +#define write_sequnlock_irqrestore(lock, flags)                \
> +       PICK_SEQ_OP(__write_sequnlock_irqrestore_raw,   \
> +               __write_sequnlock_irqrestore, lock, flags)
> +
> +#define write_sequnlock_bh(lock)       \
> +       PICK_SEQ_OP(__write_sequnlock_bh_raw, __write_sequnlock, lock)
> +
> +#define write_sequnlock_irq(lock)      \
> +       PICK_SEQ_OP(__write_sequnlock_irq_raw, __write_sequnlock, lock)
> +
> +static __always_inline
> +unsigned long __read_seqbegin_irqsave_raw(raw_seqlock_t *sl)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       __read_seqbegin_raw(sl);
> +       return flags;
> +}
> +
> +static __always_inline unsigned long __read_seqbegin_irqsave(seqlock_t *sl)
> +{
> +       __read_seqbegin(sl);
> +       return 0;
> +}
> +
> +#define read_seqbegin_irqsave(lock, flags)                     \
> +do {                                                           \
> +       flags = PICK_SEQ_OP_RET(__read_seqbegin_irqsave_raw,    \
> +               __read_seqbegin_irqsave, lock);                 \
> +} while (0)
> +
> +static __always_inline int
> +__read_seqretry_irqrestore(seqlock_t *sl, unsigned iv, unsigned long flags)
> +{
> +       return __read_seqretry(sl, iv);
> +}
> +
> +static __always_inline int
> +__read_seqretry_irqrestore_raw(raw_seqlock_t *sl, unsigned iv,
> +                              unsigned long flags)
> +{
> +       int ret = read_seqretry(sl, iv);
> +       local_irq_restore(flags);
> +       preempt_check_resched();
> +       return ret;
> +}
> +
> +#define read_seqretry_irqrestore(lock, iv, flags)                      \
> +       PICK_SEQ_OP_RET(__read_seqretry_irqrestore_raw,                 \
> +               __read_seqretry_irqrestore, lock, iv, flags)
>
>  /*
>   * Version using sequence counter only.
> @@ -286,53 +370,4 @@ static inline void write_seqcount_end(se
>         smp_wmb();
>         s->sequence++;
>  }
> -
> -#define PICK_IRQOP(op, lock)                                   \
> -do {                                                           \
> -       if (TYPE_EQUAL((lock), raw_seqlock_t))                  \
> -               op();                                           \
> -       else if (TYPE_EQUAL((lock), seqlock_t))                 \
> -               { /* nothing */ }                               \
> -       else __bad_seqlock_type();                              \
> -} while (0)
> -
> -#define PICK_IRQOP2(op, arg, lock)                             \
> -do {                                                           \
> -       if (TYPE_EQUAL((lock), raw_seqlock_t))                  \
> -               op(arg);                                        \
> -       else if (TYPE_EQUAL(lock, seqlock_t))                   \
> -               { /* nothing */ }                               \
> -       else __bad_seqlock_type();                              \
> -} while (0)
> -
> -
> -
> -/*
> - * Possible sw/hw IRQ protected versions of the interfaces.
> - */
> -#define write_seqlock_irqsave(lock, flags)                             \
> -       do { PICK_IRQOP2(local_irq_save, flags, lock); write_seqlock(lock); } while (0)
> -#define write_seqlock_irq(lock)                                                \
> -       do { PICK_IRQOP(local_irq_disable, lock); write_seqlock(lock); } while (0)
> -#define write_seqlock_bh(lock)                                         \
> -        do { PICK_IRQOP(local_bh_disable, lock); write_seqlock(lock); } while (0)
> -
> -#define write_sequnlock_irqrestore(lock, flags)                                \
> -       do { write_sequnlock(lock); PICK_IRQOP2(local_irq_restore, flags, lock); preempt_check_resched(); } while(0)
> -#define write_sequnlock_irq(lock)                                      \
> -       do { write_sequnlock(lock); PICK_IRQOP(local_irq_enable, lock); preempt_check_resched(); } while(0)
> -#define write_sequnlock_bh(lock)                                       \
> -       do { write_sequnlock(lock); PICK_IRQOP(local_bh_enable, lock); } while(0)
> -
> -#define read_seqbegin_irqsave(lock, flags)                             \
> -       ({ PICK_IRQOP2(local_irq_save, flags, lock); read_seqbegin(lock); })
> -
> -#define read_seqretry_irqrestore(lock, iv, flags)                      \
> -       ({                                                              \
> -               int ret = read_seqretry(lock, iv);                      \
> -               PICK_IRQOP2(local_irq_restore, flags, lock);            \
> -               preempt_check_resched();                                \
> -               ret;                                                    \
> -       })
> -
>  #endif /* __LINUX_SEQLOCK_H */
>
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

------=_Part_64028_6183109.1192523715754
Content-Type: text/x-patch; name="fix-compile-error-non-rt.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fix-compile-error-non-rt.patch";
 filename="fix-compile-error-non-rt.patch"
X-Attachment-Id: f_f7u5u95w

VGhpcyBwYXRjaCBpcyBoYWNrIHRoYXQgbWFrZXMgdGhlIFJULWtlcm5lbCBjb21waWxlIGFnYWlu
IHdoZW4KQ09ORklHX0dFTkVSSUNfVElNRSBpcyBOT1Qgc2V0LiBQcm9iYWJseSBldmVyeSBhcmNo
aXRlY3R1cmUKaGFzIHRoZSBzYW1lIHByb2JsZW0gYmVjYXVzZSB0aGUgcmVhZF9zZXFiZWdpbl9p
cnFzYXZlKCkgbWFjcm8KaGFzIGJlZW4gY2hhbmdlZCB0byBzb21ldGhpbmcgbm90IHJldHVybmlu
ZyBhbnl0aGluZy4KClNpZ25lZC1vZmYtYnk6IFJlbXkgQm9obWVyIDxsaW51eEBib2htZXIubmV0
PgotLS0KIGFyY2gvYXJtL2tlcm5lbC90aW1lLmMgfCAgICAzICsrLQogMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi4yMy9hcmNo
L2FybS9rZXJuZWwvdGltZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yMy5vcmlnL2FyY2gv
YXJtL2tlcm5lbC90aW1lLmMJMjAwNy0xMC0xNiAwOToxNzoyNS4wMDAwMDAwMDAgKzAyMDAKKysr
IGxpbnV4LTIuNi4yMy9hcmNoL2FybS9rZXJuZWwvdGltZS5jCTIwMDctMTAtMTYgMTA6MDg6MDIu
MDAwMDAwMDAwICswMjAwCkBAIC0yNTEsNyArMjUxLDggQEAgdm9pZCBkb19nZXR0aW1lb2ZkYXko
c3RydWN0IHRpbWV2YWwgKnR2KQogCXVuc2lnbmVkIGxvbmcgdXNlYywgc2VjOwogCiAJZG8gewot
CQlzZXEgPSByZWFkX3NlcWJlZ2luX2lycXNhdmUoJnh0aW1lX2xvY2ssIGZsYWdzKTsKKwkJcmVh
ZF9zZXFiZWdpbl9pcnFzYXZlKCZ4dGltZV9sb2NrLCBmbGFncyk7CisJCXNlcSA9IHh0aW1lX2xv
Y2suc2VxdWVuY2U7CiAJCXVzZWMgPSBzeXN0ZW1fdGltZXItPm9mZnNldCgpOwogCQlzZWMgPSB4
dGltZS50dl9zZWM7CiAJCXVzZWMgKz0geHRpbWUudHZfbnNlYyAvIDEwMDA7Cg==
------=_Part_64028_6183109.1192523715754--
