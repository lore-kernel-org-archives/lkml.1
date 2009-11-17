Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbZKQLoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbZKQLoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZKQLoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:44:54 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48661 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZKQLox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FjzbxVQNwl0W6hBY16FZ+E6wt2IoGwQzficarfmTwSPsQ6KD2HZ0jMkS1NASpf5/Rq
         gi1fgHNQNWs4O5Yn+W13lETJXLfFTx3wcC025viZCz/HBzPhpKJW/NfzowveOghjVGjn
         Z0HTZH6RjjQVNNFJTMhEofBP0BDqYU9a13a3g=
MIME-Version: 1.0
In-Reply-To: <1258372718.31356.10.camel@wall-e>
References: <1258372242.31356.1.camel@wall-e>
	 <1258372718.31356.10.camel@wall-e>
Date: Tue, 17 Nov 2009 17:14:57 +0530
Message-ID: <b90c0690911170344l23d4ca11x5f3d6b04fee89aab@mail.gmail.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Roger Quadros <quadros.roger@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani,

 minor typo.

> diff -u -N -r kfifo1/include/linux/kfifo.h kfifo2/include/linux/kfifo.h
> --- kfifo1/include/linux/kfifo.h        2009-10-19 20:39:24.000000000 +0200
> +++ kfifo2/include/linux/kfifo.h        2009-10-19 20:58:34.000000000 +0200
> @@ -30,13 +30,12 @@
>        unsigned int size;      /* the size of the allocated buffer */
>        unsigned int in;        /* data is added at offset (in % size) */
>        unsigned int out;       /* data is extracted from off. (out % size) */
> -       spinlock_t *lock;       /* protects concurrent modifications */
>  };
>
>  extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
> -                       unsigned int size, spinlock_t *lock);
> +                       unsigned int size);
>  extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
> -                       gfp_t gfp_mask, spinlock_t *lock);
> +                       gfp_t gfp_mask);
>  extern void kfifo_free(struct kfifo *fifo);
>  extern unsigned int __kfifo_put(struct kfifo *fifo,
>                                const unsigned char *buffer, unsigned int len);
> @@ -58,58 +57,67 @@
>  */
>  static inline void kfifo_reset(struct kfifo *fifo)
>  {
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(fifo->lock, flags);
> -
>        __kfifo_reset(fifo);
> +}
> +
> +/**
> + * __kfifo_len - returns the number of bytes available in the FIFO
> + * @fifo: the fifo to be used.
> + */
> +static inline unsigned int __kfifo_len(struct kfifo *fifo)
> +{
> +       register unsigned int   out;
>
> -       spin_unlock_irqrestore(fifo->lock, flags);
> +       out = fifo->out;
> +       smp_rmb();
> +       return fifo->in - out;
>  }
>
>  /**
> - * kfifo_put - puts some data into the FIFO
> + * kfifo_put_locked - puts some data into the FIFO using a spinlock for locking
>  * @fifo: the fifo to be used.
> - * @buffer: the data to be added.
> + * @from: the data to be added.
>  * @len: the length of the data to be added.

should be @n:

> + * @lock: pointer to the spinlock to use for locking.
>  *
> - * This function copies at most @len bytes from the @buffer into
> + * This function copies at most @len bytes from the @from buffer into
>  * the FIFO depending on the free space, and returns the number of
>  * bytes copied.
>  */
> -static inline unsigned int kfifo_put(struct kfifo *fifo,
> -                               const unsigned char *buffer, unsigned int len)
> +static inline __must_check unsigned int kfifo_put_locked(struct kfifo *fifo,
> +               const unsigned char *from, unsigned int n, spinlock_t *lock)
>  {
>        unsigned long flags;
>        unsigned int ret;
>
> -       spin_lock_irqsave(fifo->lock, flags);
> +       spin_lock_irqsave(lock, flags);
>
> -       ret = __kfifo_put(fifo, buffer, len);
> +       ret = __kfifo_put(fifo, from, n);
>
> -       spin_unlock_irqrestore(fifo->lock, flags);
> +       spin_unlock_irqrestore(lock, flags);
>
>        return ret;
>  }
>
>  /**
> - * kfifo_get - gets some data from the FIFO
> + * kfifo_get_locked - gets some data from the FIFO using a spinlock for locking
>  * @fifo: the fifo to be used.
> - * @buffer: where the data must be copied.
> + * @to: where the data must be copied.
>  * @len: the size of the destination buffer.

should be @n

> + * @lock: pointer to the spinlock to use for locking.
>  *
>  * This function copies at most @len bytes from the FIFO into the
> - * @buffer and returns the number of copied bytes.
> + * @to buffer and returns the number of copied bytes.
>  */
> -static inline unsigned int kfifo_get(struct kfifo *fifo,
> -                                    unsigned char *buffer, unsigned int len)
> +static inline __must_check unsigned int kfifo_get_locked(struct kfifo *fifo,
> +       unsigned char *to, unsigned int n, spinlock_t *lock)
>  {
>        unsigned long flags;
>        unsigned int ret;
>
> -       spin_lock_irqsave(fifo->lock, flags);
> +       spin_lock_irqsave(lock, flags);
>
> -       ret = __kfifo_get(fifo, buffer, len);
> +       ret = __kfifo_get(fifo, to, n);
>
>        /*
>         * optimization: if the FIFO is empty, set the indices to 0
> @@ -118,36 +126,18 @@
>        if (fifo->in == fifo->out)
>                fifo->in = fifo->out = 0;
>
> -       spin_unlock_irqrestore(fifo->lock, flags);
> +       spin_unlock_irqrestore(lock, flags);
>
>        return ret;
>  }
