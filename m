Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXEUQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXEUQr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXEUQrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:47:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:19666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743AbXEUQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UPNL7jin6zelP90r5mqHhyrzLR1uR1dxlGmfy1HoLEZAB1MizoZw1To4I0XapHywXgkA+vMziZo0Vns54pti7Eps0zUa6EGUGsfkP4SxlPsqpUoBnjtbmLchbOosHBBG3ZKW/0iXBsj0n8FbSwnHciPEa318riXxmVK6dEGg5Ws=
Message-ID: <21d7e9970705210947o6db30e6ib37bb96b3cf77e4b@mail.gmail.com>
Date: Mon, 21 May 2007 17:47:33 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [PATCH] shrink task_struct by 16 bytes
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Dave Airlie" <airlied@linux.ie>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4651C8CA.7020001@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464FC31B.9000609@haxent.com.br>
	 <20070521100400.GA11351@infradead.org>
	 <4651C8CA.7020001@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Shrink task_struct by replacing the notifier callback with a notifier
> list that allows for multiple clients to register notifiers. It also
> saves one cacheline on i386.
>
> The patch also renames the un/block_all_signals() functions to more
> descriptive names signal_notifier_add/del() and updates the kerneldoc
> comments accordingly. The only in-tree user (drm) is converted.
>
> Thanks to Christoph Hellwig for useful comments and review.
>
> Pahole output for task_struct:
>
> i386 before:
>
>    /* size: 2640, cachelines: 42 */
>    /* sum members: 2619, holes: 3, sum holes: 9 */
>    /* bit holes: 2, sum bit holes: 62 bits */
>    /* padding: 12 */
>    /* paddings: 1, sum paddings: 8 */
>    /* last cacheline: 16 bytes */
>
> i386 after:
>
>    /* size: 2624, cachelines: 41 */
>    /* sum members: 2611, holes: 3, sum holes: 9 */
>    /* bit holes: 2, sum bit holes: 62 bits */
>    /* padding: 4 */
>    /* paddings: 1, sum paddings: 8 */
>
> x86_64 before:
>
>    /* size: 3632, cachelines: 57 */
>    /* sum members: 3579, holes: 10, sum holes: 45 */
>    /* bit holes: 2, sum bit holes: 62 bits */
>    /* padding: 8 */
>    /* last cacheline: 48 bytes */
>
> x86_64 after:
>
>    /* size: 3616, cachelines: 57 */
>    /* sum members: 3563, holes: 10, sum holes: 45 */
>    /* bit holes: 2, sum bit holes: 62 bits */
>    /* padding: 8 */
>    /* last cacheline: 32 bytes */
>
> Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
> Cc: Dave Airlie <airlied@linux.ie>

Signed-off-by: Dave Airlie <airlied@linux.ie>

No problems from me either..

Dave.

> Cc: Christoph Hellwig <hch@infradead.org>
>
> ---
>  drivers/char/drm/drmP.h     |    4 +-
>  drivers/char/drm/drm_lock.c |   16 ++++++----
>  include/linux/init_task.h   |    1
>  include/linux/sched.h       |   10 ++----
>  include/linux/signal.h      |   21 ++++++++++++++
>  kernel/fork.c               |    1
>  kernel/signal.c             |   66 ++++++++++++++++++++++----------------------
>  7 files changed, 71 insertions(+), 48 deletions(-)
>
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -963,10 +963,9 @@ struct task_struct {
>
>         unsigned long sas_ss_sp;
>         size_t sas_ss_size;
> -       int (*notifier)(void *priv);
> -       void *notifier_data;
> -       sigset_t *notifier_mask;
> -
> +       /* struct signal_notifier callback list */
> +       struct hlist_head signal_notifier_list;
> +
>         void *security;
>         struct audit_context *audit_context;
>         seccomp_t seccomp;
> @@ -1339,9 +1338,6 @@ static inline int dequeue_signal_lock(st
>         return ret;
>  }
>
> -extern void block_all_signals(int (*notifier)(void *priv), void *priv,
> -                             sigset_t *mask);
> -extern void unblock_all_signals(void);
>  extern void release_task(struct task_struct * p);
>  extern int send_sig_info(int, struct siginfo *, struct task_struct *);
>  extern int send_group_sig_info(int, struct siginfo *, struct task_struct *);
> Index: linux-2.6/include/linux/init_task.h
> ===================================================================
> --- linux-2.6.orig/include/linux/init_task.h
> +++ linux-2.6/include/linux/init_task.h
> @@ -157,6 +157,7 @@ extern struct group_info init_groups;
>                 .list = LIST_HEAD_INIT(tsk.pending.list),               \
>                 .signal = {{0}}},                                       \
>         .blocked        = {{0}},                                        \
> +       .signal_notifier_list = HLIST_HEAD_INIT,                        \
>         .alloc_lock     = __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),         \
>         .journal_info   = NULL,                                         \
>         .cpu_timers     = INIT_CPU_TIMERS(tsk.cpu_timers),              \
> Index: linux-2.6/include/linux/signal.h
> ===================================================================
> --- linux-2.6.orig/include/linux/signal.h
> +++ linux-2.6/include/linux/signal.h
> @@ -27,6 +27,27 @@ struct sigpending {
>         sigset_t signal;
>  };
>
> +/**
> + * struct signal_notifier - the signal notifier struct
> + * @node: hash list node to enqueue into the process notifier list
> + * @func: notifier callback function. if the callback routine returns 0
> + * then then signal will be blocked.
> + * @data: pointer to private data that the notifier routine can use to
> + * determine if the signal should be blocked or not.
> + * @mask: mask of signals to call the callback routine upon
> + */
> +struct signal_notifier {
> +       struct hlist_node node;
> +       int (*func)(void *priv);
> +       void *data;
> +       sigset_t mask;
> +};
> +
> +/* Add a signal notifier struct to the current process notifier list  */
> +extern void signal_notifier_add(struct signal_notifier *);
> +/* Remove a signal notifier struct from the current process notifier list */
> +extern void signal_notifier_del(struct signal_notifier *);
> +
>  /*
>   * Define some primitives to manipulate sigset_t.
>   */
> Index: linux-2.6/kernel/fork.c
> ===================================================================
> --- linux-2.6.orig/kernel/fork.c
> +++ linux-2.6/kernel/fork.c
> @@ -1034,6 +1034,7 @@ static struct task_struct *copy_process(
>         p->vfork_done = NULL;
>         spin_lock_init(&p->alloc_lock);
>
> +       INIT_HLIST_HEAD(&p->signal_notifier_list);
>         clear_tsk_thread_flag(p, TIF_SIGPENDING);
>         init_sigpending(&p->pending);
>
> Index: linux-2.6/drivers/char/drm/drm_lock.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/drm/drm_lock.c
> +++ linux-2.6/drivers/char/drm/drm_lock.c
> @@ -110,14 +110,16 @@ int drm_lock(struct inode *inode, struct
>         DRM_DEBUG( "%d %s\n", lock.context, ret ? "interrupted" : "has lock" );
>         if (ret) return ret;
>
> -       sigemptyset(&dev->sigmask);
> -       sigaddset(&dev->sigmask, SIGSTOP);
> -       sigaddset(&dev->sigmask, SIGTSTP);
> -       sigaddset(&dev->sigmask, SIGTTIN);
> -       sigaddset(&dev->sigmask, SIGTTOU);
> +       sigemptyset(&dev->notifier.mask);
> +       sigaddset(&dev->notifier.mask, SIGSTOP);
> +       sigaddset(&dev->notifier.mask, SIGTSTP);
> +       sigaddset(&dev->notifier.mask, SIGTTIN);
> +       sigaddset(&dev->notifier.mask, SIGTTOU);
>         dev->sigdata.context = lock.context;
>         dev->sigdata.lock = dev->lock.hw_lock;
> -       block_all_signals(drm_notifier, &dev->sigdata, &dev->sigmask);
> +       dev->notifier.data = &dev->sigdata;
> +       dev->notifier.func = drm_notifier;
> +       signal_notifier_add(&dev->notifier);
>
>         if (dev->driver->dma_ready && (lock.flags & _DRM_LOCK_READY))
>                 dev->driver->dma_ready(dev);
> @@ -189,7 +191,7 @@ int drm_unlock(struct inode *inode, stru
>                 }
>         }
>
> -       unblock_all_signals();
> +       signal_notifier_del(&dev->notifier);
>         return 0;
>  }
>
> Index: linux-2.6/drivers/char/drm/drmP.h
> ===================================================================
> --- linux-2.6.orig/drivers/char/drm/drmP.h
> +++ linux-2.6/drivers/char/drm/drmP.h
> @@ -750,8 +750,8 @@ typedef struct drm_device {
>         drm_sg_mem_t *sg;       /**< Scatter gather memory */
>         unsigned long *ctx_bitmap;      /**< context bitmap */
>         void *dev_private;              /**< device private data */
> -       drm_sigdata_t sigdata;     /**< For block_all_signals */
> -       sigset_t sigmask;
> +       drm_sigdata_t sigdata;     /**< Signal notifier data */
> +       struct signal_notifier notifier;        /**< For block_signals */
>
>         struct drm_driver *driver;
>         drm_local_map_t *agp_buffer_map;
> Index: linux-2.6/kernel/signal.c
> ===================================================================
> --- linux-2.6.orig/kernel/signal.c
> +++ linux-2.6/kernel/signal.c
> @@ -237,37 +237,35 @@ flush_signal_handlers(struct task_struct
>         }
>  }
>
> -
> -/* Notify the system that a driver wants to block all signals for this
> - * process, and wants to be notified if any signals at all were to be
> - * sent/acted upon.  If the notifier routine returns non-zero, then the
> - * signal will be acted upon after all.  If the notifier routine returns 0,
> - * then then signal will be blocked.  Only one block per process is
> - * allowed.  priv is a pointer to private data that the notifier routine
> - * can use to determine if the signal should be blocked or not.  */
> -
> -void
> -block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
> +/**
> + * signal_notifier_add - Add a signal notifier callback to the current process
> + * @notifier: the signal_notifier struct to add
> + *
> + * Notify the system that a driver wants to block a set of signals for this
> + * process and wants to be notified if any signals at all were to be sent or
> + * acted upon. If the notifier routine returns non-zero, then the signal will
> + * be acted upon after all. If the notifier routine returns 0, the signal will
> + * be blocked.
> + */
> +void signal_notifier_add(struct signal_notifier *notifier)
>  {
>         unsigned long flags;
>
>         spin_lock_irqsave(&current->sighand->siglock, flags);
> -       current->notifier_mask = mask;
> -       current->notifier_data = priv;
> -       current->notifier = notifier;
> +       hlist_add_head(&notifier->node, &current->signal_notifier_list);
>         spin_unlock_irqrestore(&current->sighand->siglock, flags);
>  }
>
> -/* Notify the system that blocking has ended. */
> -
> -void
> -unblock_all_signals(void)
> +/**
> + * signal_notifier_del - Notify the system that blocking has ended
> + * @notifier: the signal_notifier struct to remove
> + */
> +void signal_notifier_del(struct signal_notifier *notifier)
>  {
>         unsigned long flags;
>
>         spin_lock_irqsave(&current->sighand->siglock, flags);
> -       current->notifier = NULL;
> -       current->notifier_data = NULL;
> +       hlist_del(&notifier->node);
>         recalc_sigpending();
>         spin_unlock_irqrestore(&current->sighand->siglock, flags);
>  }
> @@ -318,22 +316,26 @@ static int collect_signal(int sig, struc
>  static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
>                         siginfo_t *info)
>  {
> +       struct hlist_node *entry, *next;
> +       struct signal_notifier *notifier;
>         int sig = next_signal(pending, mask);
> +       struct hlist_head *hash_list = &current->signal_notifier_list;
>
> -       if (sig) {
> -               if (current->notifier) {
> -                       if (sigismember(current->notifier_mask, sig)) {
> -                               if (!(current->notifier)(current->notifier_data)) {
> -                                       clear_thread_flag(TIF_SIGPENDING);
> -                                       return 0;
> -                               }
> +       if (unlikely(!sig))
> +               return 0;
> +
> +       hlist_for_each_entry_safe(notifier, entry, next, hash_list, node) {
> +               if (sigismember(&notifier->mask, sig)) {
> +                       if (!notifier->func(notifier->data)) {
> +                               clear_thread_flag(TIF_SIGPENDING);
> +                               return 0;
>                         }
>                 }
> -
> -               if (!collect_signal(sig, pending, info))
> -                       sig = 0;
>         }
>
> +       if (!collect_signal(sig, pending, info))
> +               sig = 0;
> +
>         return sig;
>  }
>
> @@ -1860,8 +1862,8 @@ EXPORT_SYMBOL(ptrace_notify);
>  EXPORT_SYMBOL(send_sig);
>  EXPORT_SYMBOL(send_sig_info);
>  EXPORT_SYMBOL(sigprocmask);
> -EXPORT_SYMBOL(block_all_signals);
> -EXPORT_SYMBOL(unblock_all_signals);
> +EXPORT_SYMBOL(signal_notifier_add);
> +EXPORT_SYMBOL(signal_notifier_del);
>
>
>  /*
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
