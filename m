Return-Path: <linux-kernel-owner+w=401wt.eu-S1764212AbZAUK3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764212AbZAUK3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763921AbZAUK3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:29:34 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:65306 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763888AbZAUK3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:29:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SZn145e0U6rdp7UCSBYtOKSRUFll21HYcKhUtManq/19NUZ52sa+uRETzw98zp+t5G
         AWAm9xK9EnzuRE2pLfyhp2GWEi1HifG1clD8RAxrSHr8RSjIwfJuxcKPx2v2oWWmwFy3
         QbMxWIFfqyiZGfR9GmLFlBuvFExY0MMp1NwnU=
MIME-Version: 1.0
In-Reply-To: <4976EE0B.5090200@cn.fujitsu.com>
References: <4976EE0B.5090200@cn.fujitsu.com>
Date: Wed, 21 Jan 2009 11:29:30 +0100
Message-ID: <c62985530901210229o2acbc623j32cfff9f541d4e29@mail.gmail.com>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/21 Lai Jiangshan <laijs@cn.fujitsu.com>:
>
> allocating memory for every cpu for single workqueue is waste.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 2f44583..ecd693d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -99,7 +99,7 @@ static
>  struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
>  {
>        if (unlikely(is_wq_single_threaded(wq)))
> -               cpu = singlethread_cpu;
> +               return wq->cpu_wq;
>        return per_cpu_ptr(wq->cpu_wq, cpu);
>  }
>
> @@ -417,7 +417,7 @@ void flush_workqueue(struct workqueue_struct *wq)
>        lock_map_acquire(&wq->lockdep_map);
>        lock_map_release(&wq->lockdep_map);
>        for_each_cpu_mask_nr(cpu, *cpu_map)
> -               flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> +               flush_cpu_workqueue(wq_per_cpu(wq, cpu));
>  }
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>
> @@ -548,7 +548,7 @@ static void wait_on_work(struct work_struct *work)
>        cpu_map = wq_cpu_map(wq);
>
>        for_each_cpu_mask_nr(cpu, *cpu_map)
> -               wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
> +               wait_on_cpu_work(wq_per_cpu(wq, cpu), work);
>  }
>
>  static int __cancel_work_timer(struct work_struct *work,
> @@ -752,17 +752,13 @@ int current_is_keventd(void)
>
>  }
>
> -static struct cpu_workqueue_struct *
> -init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
> +static void init_cpu_workqueue(struct workqueue_struct *wq,
> +               struct cpu_workqueue_struct *cwq)
>  {
> -       struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> -
>        cwq->wq = wq;
>        spin_lock_init(&cwq->lock);
>        INIT_LIST_HEAD(&cwq->worklist);
>        init_waitqueue_head(&cwq->more_work);
> -
> -       return cwq;
>  }
>
>  static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
> @@ -816,7 +812,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>        if (!wq)
>                return NULL;
>
> -       wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
> +       if (singlethread)
> +               wq->cpu_wq = kmalloc(sizeof(*cwq), GFP_KERNEL);
> +       else
> +               wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
>        if (!wq->cpu_wq) {
>                kfree(wq);
>                return NULL;
> @@ -830,7 +829,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>        INIT_LIST_HEAD(&wq->list);
>
>        if (singlethread) {
> -               cwq = init_cpu_workqueue(wq, singlethread_cpu);
> +               cwq = wq->cpu_wq;
> +               init_cpu_workqueue(wq, cwq);
>                err = create_workqueue_thread(cwq, singlethread_cpu);
>                start_workqueue_thread(cwq, -1);
>        } else {
> @@ -851,7 +851,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>                 * lock.
>                 */
>                for_each_possible_cpu(cpu) {
> -                       cwq = init_cpu_workqueue(wq, cpu);
> +                       cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> +                       init_cpu_workqueue(wq, cwq);
>                        if (err || !cpu_online(cpu))
>                                continue;
>                        err = create_workqueue_thread(cwq, cpu);
> @@ -906,6 +907,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
>        const struct cpumask *cpu_map = wq_cpu_map(wq);
>        int cpu;
>
> +       if (is_wq_single_threaded(wq)) {
> +               cleanup_workqueue_thread(wq->cpu_wq);
> +               kfree(wq->cpu_wq);
> +               kfree(wq);
> +               return;
> +       }
> +
>        cpu_maps_update_begin();
>        spin_lock(&workqueue_lock);
>        list_del(&wq->list);
>


Looks like a nice catch!
