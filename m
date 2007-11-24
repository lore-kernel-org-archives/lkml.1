Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXKXMSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXKXMSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 07:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXKXMSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 07:18:39 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:55590 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXKXMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 07:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YDEadzPcg62mbJlYHEjFdxSKvrmBvCm9G48rX0+gF8iFoYsr6xHBVeSYqxjI54Gf5FpA+pJUXoOgFQkGErIo2kbOXGPSViIIF9JnRE3b63XYeqCJvLqGgGxUPeumFveX4zxu28ExoAov7aLFNDw0wONSZKdZEKBARvEpQSGseFI=
Message-ID: <64bb37e0711240418i2e90916dx3f1b622df0e2f8b3@mail.gmail.com>
Date: Sat, 24 Nov 2007 13:18:35 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] debug_check_no_locks_freed: fix in_range() checks
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alasdair G Kergon" <agk@redhat.com>,
       "Milan Broz" <mbroz@redhat.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071124105343.GA2044@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120234605.GG23667@elte.hu> <20071121155842.GA864@tv-sign.ru>
	 <20071124105343.GA2044@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007 11:53 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> Torsten, could you ack/nack this patch?

>From looking at the code I would ack it.
I will reapply agk-dm-dm-crypt-move-bio-submission-to-thread.patch and
this patch and boot several times, but as the message was not
triggered on every boot, this can't prove anything.

But if it happens again, I will notify you.

Torsten

> Torsten Kaiser wrote:
> >
> > static inline int in_range(const void *start, const void *addr, const void *end)
> > {
> >         return addr >= start && addr <= end;
> > }
> > This  will return true, if addr is in the range of start (including)
> > to end (including).
> >
> > But debug_check_no_locks_freed() seems does:
> > const void *mem_to = mem_from + mem_len
> > -> mem_to is the last byte of the freed range, that fits in_range
> > lock_from = (void *)hlock->instance;
> > -> first byte of the lock
> > lock_to = (void *)(hlock->instance + 1);
> > -> first byte of the next lock, not last byte of the lock that is being checked!
> >
> > The test is:
> > if (!in_range(mem_from, lock_from, mem_to) &&
> >                                         !in_range(mem_from, lock_to, mem_to))
> >                         continue;
> > So it tests, if the first byte of the lock is in the range that is freed ->OK
> > And if the first byte of the *next* lock is in the range that is freed
> > -> Not OK.
>
> We can also simplify in_range checks, we need only 2 comparisons, not 4.
> If the lock is not in memory range, it should be either at the left of range
> or at the right.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- 24/kernel/lockdep.c~        2007-11-09 12:57:31.000000000 +0300
> +++ 24/kernel/lockdep.c 2007-11-24 13:32:52.000000000 +0300
> @@ -3054,11 +3054,6 @@ void __init lockdep_info(void)
>  #endif
>  }
>
> -static inline int in_range(const void *start, const void *addr, const void *end)
> -{
> -       return addr >= start && addr <= end;
> -}
> -
>  static void
>  print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
>                      const void *mem_to, struct held_lock *hlock)
> @@ -3080,6 +3075,13 @@ print_freed_lock_bug(struct task_struct
>         dump_stack();
>  }
>
> +static inline int not_in_range(const void* mem_from, unsigned long mem_len,
> +                               const void* lock_from, unsigned long lock_len)
> +{
> +       return lock_from + lock_len <= mem_from ||
> +               mem_from + mem_len <= lock_from;
> +}
> +
>  /*
>   * Called when kernel memory is freed (or unmapped), or if a lock
>   * is destroyed or reinitialized - this code checks whether there is
> @@ -3087,7 +3089,6 @@ print_freed_lock_bug(struct task_struct
>   */
>  void debug_check_no_locks_freed(const void *mem_from, unsigned long mem_len)
>  {
> -       const void *mem_to = mem_from + mem_len, *lock_from, *lock_to;
>         struct task_struct *curr = current;
>         struct held_lock *hlock;
>         unsigned long flags;
> @@ -3100,14 +3101,11 @@ void debug_check_no_locks_freed(const vo
>         for (i = 0; i < curr->lockdep_depth; i++) {
>                 hlock = curr->held_locks + i;
>
> -               lock_from = (void *)hlock->instance;
> -               lock_to = (void *)(hlock->instance + 1);
> -
> -               if (!in_range(mem_from, lock_from, mem_to) &&
> -                                       !in_range(mem_from, lock_to, mem_to))
> +               if (not_in_range(mem_from, mem_len, hlock->instance,
> +                                       sizeof(*hlock->instance)))
>                         continue;
>
> -               print_freed_lock_bug(curr, mem_from, mem_to, hlock);
> +               print_freed_lock_bug(curr, mem_from, mem_from + mem_len, hlock);
>                 break;
>         }
>         local_irq_restore(flags);
>
>
