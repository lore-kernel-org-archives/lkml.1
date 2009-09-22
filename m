Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZIVGVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZIVGVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZIVGVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:21:18 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:38097 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbZIVGVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VV5j9dVgXQehhCVWlFgConBc14ryEowH43ZEgS+oZrGyqPrpX3YlYRxa+4o03glt56
         AFOKPDkxPFIr1cDp0+doQ01fJI10ScPD41luuhmzXAYwhs3d//PNy7EtBjTe8ozoFPF4
         +AusqIo92V02b4MHbS0Br5VZY7bSTfsT51zWA=
MIME-Version: 1.0
In-Reply-To: <d36bb30d0909212310p1195f52eu3d6c53ff1d0c0113@mail.gmail.com>
References: <d36bb30d0909212310p1195f52eu3d6c53ff1d0c0113@mail.gmail.com>
Date: Tue, 22 Sep 2009 16:13:09 +1000
Message-ID: <d36bb30d0909212313h3e0fab01xe041aeb92bd7c1@mail.gmail.com>
Subject: Re: [PATCH]lock_stat: Adding "nr_contender" and "max_contender" to 
	show the degree of contention on ticket spinlock
From: Yang Xi <yangxilkm@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, make wrong Signed-off-by.
Should be
Signed-off-by: Xi Yang <yangxilkm@gmail.com>

On Tue, Sep 22, 2009 at 4:10 PM, Yang Xi <yangxilkm@gmail.com> wrote:
> The cost of spin lock operations is increased as the number of threads
> who wait for the spinlock increased. We are able to record the number
> of threads which includes the holder and waiters for the ticket
> spinlock when the contention happened (The spinlock is not free when a
> thread wants to lock it). So, we introduces two parameters to
> lock_stat: "nr_contender" and "max_contender".
> nr_contender is the sum of the number of holder and waiters when
> contention happened. So, "nr_contender / contentions" represent the
> average degree of contention.
> Max_contender is the biggest number of holder and waiters when
> contention happened. So, max_contender represents the highest degree
> of contention.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/spinlock.h |    9 +++++++++
>  include/linux/lockdep.h         |    2 ++
>  include/linux/spinlock.h        |    4 ++++
>  kernel/lockdep.c                |   21 ++++++++++++++++++++-
>  kernel/lockdep_proc.c           |    8 ++++++--
>  5 files changed, 41 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 4e77853..a2396d8 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -172,6 +172,15 @@ static inline int
> __ticket_spin_is_contended(raw_spinlock_t *lock)
>        return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
>  }
>
> +static inline int __ticket_spin_nr_contender(raw_spinlock_t *lock)
> +{
> +       int tmp = ACCESS_ONCE(lock->slock);
> +
> +       return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) + 1;
> +}
> +
> +#define spin_nr_contender(lock) __ticket_spin_nr_contender(&(lock)->raw_lock)
> +
>  #ifndef CONFIG_PARAVIRT_SPINLOCKS
>
>  static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 9ccf0e2..0627706 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -106,6 +106,8 @@ enum bounce_type {
>        bounce_acquired_read,
>        bounce_contended_write,
>        bounce_contended_read,
> +       nr_contender,
> +       max_contender,
>        nr_bounce_types,
>
>        bounce_acquired = bounce_acquired_write,
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index f0ca7a7..3d86966 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -132,6 +132,10 @@ do {                                                               \
>  #endif /*__raw_spin_is_contended*/
>  #endif
>
> +#ifndef spin_nr_contender
> +#define spin_nr_contender(lock) (spin_is_contended(lock) ? 1 : 0)
> +#endif
> +
>  /* The lock does not imply full memory barrier. */
>  #ifndef ARCH_HAS_SMP_MB_AFTER_LOCK
>  static inline void smp_mb__after_lock(void) { smp_mb(); }
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index f74d2d7..e4b9f80 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -200,8 +200,14 @@ struct lock_class_stats lock_stats(struct
> lock_class *class)
>                lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
>                lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);
>
> -               for (i = 0; i < ARRAY_SIZE(stats.bounces); i++)
> +               for (i = 0; i < ARRAY_SIZE(stats.bounces); i++) {
> +                       if (i == max_contender) {
> +                               if (stats.bounces[i] < pcs->bounces[i])
> +                                       stats.bounces[i] = pcs->bounces[i];
> +                               continue;
> +                       }
>                        stats.bounces[i] += pcs->bounces[i];
> +               }
>        }
>
>        return stats;
> @@ -3293,9 +3299,15 @@ __lock_contended(struct lockdep_map *lock,
> unsigned long ip)
>        struct task_struct *curr = current;
>        struct held_lock *hlock, *prev_hlock;
>        struct lock_class_stats *stats;
> +       unsigned long contender;
> +       spinlock_t *lock_ptr;
>        unsigned int depth;
>        int i, contention_point, contending_point;
>
> +       lock_ptr = container_of(lock, spinlock_t, dep_map);
> +       if (lock_ptr->magic == SPINLOCK_MAGIC)
> +               contender = spin_nr_contender(lock_ptr);
> +
>        depth = curr->lockdep_depth;
>        if (DEBUG_LOCKS_WARN_ON(!depth))
>                return;
> @@ -3332,6 +3344,13 @@ found_it:
>                stats->contending_point[contending_point]++;
>        if (lock->cpu != smp_processor_id())
>                stats->bounces[bounce_contended + !!hlock->read]++;
> +
> +       if (lock_ptr->magic == SPINLOCK_MAGIC) {
> +               stats->bounces[nr_contender] += contender;
> +               if (stats->bounces[max_contender] < contender)
> +                       stats->bounces[max_contender] = contender;
> +       }
> +
>        put_lock_stats(stats);
>  }
>
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index d4b3dbc..a3d0910 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -472,6 +472,8 @@ static void seq_stats(struct seq_file *m, struct
> lock_stat_data *data)
>                        seq_printf(m, "%40s:", name);
>
>                seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
> +               seq_printf(m, "%14lu ", stats->bounces[nr_contender]);
> +               seq_printf(m, "%14lu ", stats->bounces[max_contender]);
>                seq_lock_time(m, &stats->write_waittime);
>                seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_write]);
>                seq_lock_time(m, &stats->write_holdtime);
> @@ -541,11 +543,13 @@ static void seq_header(struct seq_file *m)
>        if (unlikely(!debug_locks))
>                seq_printf(m, "*WARNING* lock debugging disabled!! - possibly due
> to a lockdep warning\n");
>
> -       seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
> -       seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
> +       seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
> +       seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s %14s "
>                        "%14s %14s\n",
>                        "class name",
>                        "con-bounces",
> +                       "nr-contender",
> +                       "contender-max",
>                        "contentions",
>                        "waittime-min",
>                        "waittime-max",
>
