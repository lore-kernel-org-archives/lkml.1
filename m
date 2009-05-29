Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbZE2NRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbZE2NRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760167AbZE2NQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:16:51 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44688 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142AbZE2NQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rPO1HtUzOIAKj3EGlzHTn3xQ2PUdmaSL/n278WugTRKOZWsWvgmW7hjL3AhkA+WzQ4
         FkzC2JasG+1ze7LfSWCb8SydcN2AD2ApA1TKn/8cQT7X5bsAsicceV087z2YRu3/8AmW
         6OeenVKXrt6ae03UioQBktEyMnS/j+eFC2540=
MIME-Version: 1.0
In-Reply-To: <20090526043123.GC19728@kryten>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten>
	 <20090526043123.GC19728@kryten>
Date: Fri, 29 May 2009 15:16:47 +0200
Message-ID: <c62985530905290616j73b12c73yeed52854b9d86c9@mail.gmail.com>
Subject: Re: [PATCH] tracing/events: Rename worklet_execute to worklet_entry 
	and worklet_complete to worklet_exit
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>, Zhaolei <zhaolei@cn.fujitsu.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton, Zhaolei,

You tracing/workqueues patches look good and I've tested them succesfully.
I will apply them soon, thanks!

2009/5/26 Anton Blanchard <anton@samba.org>:
>
> Keep a common naming convention for tracing the latency of events such as
> softirq_entry/softirq_exit.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>
> What do people think? It seems like a good idea to have a naming convention
> when tracing event latency for softirqs, timers, worklets, etc.
>
> Index: linux-2.6-master/include/trace/events/workqueue.h
> ===================================================================
> --- linux-2.6-master.orig/include/trace/events/workqueue.h      2009-05-26 12:40:01.000000000 +1000
> +++ linux-2.6-master/include/trace/events/workqueue.h   2009-05-26 12:40:16.000000000 +1000
> @@ -68,7 +68,7 @@
>                __entry->cpu, __entry->delay)
>  );
>
> -TRACE_EVENT(worklet_execute,
> +TRACE_EVENT(worklet_entry,
>
>        TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
>
> @@ -93,7 +93,7 @@
>  );
>
>  /* Declare work as void *, because we can't use work->... in after f(work) */
> -TRACE_EVENT(worklet_complete,
> +TRACE_EVENT(worklet_exit,
>        TP_PROTO(struct task_struct *wq_thread, void *work),
>
>        TP_ARGS(wq_thread, work),
> Index: linux-2.6-master/kernel/trace/trace_workqueue.c
> ===================================================================
> --- linux-2.6-master.orig/kernel/trace/trace_workqueue.c        2009-05-26 12:43:27.000000000 +1000
> +++ linux-2.6-master/kernel/trace/trace_workqueue.c     2009-05-26 12:43:36.000000000 +1000
> @@ -27,7 +27,7 @@
>
>        /*
>         * save latest work_struct's pointer to use as identifier in
> -        * probe_worklet_complete, because we can't use work_struct->...
> +        * probe_worklet_exit, because we can't use work_struct->...
>         * after worklet got executed
>         */
>        void                            *work;
> @@ -141,7 +141,7 @@
>
>  /* Execution of a work */
>  static void
> -probe_worklet_execute(struct task_struct *wq_thread, struct work_struct *work)
> +probe_worklet_entry(struct task_struct *wq_thread, struct work_struct *work)
>  {
>        int cpu = cpumask_first(&wq_thread->cpus_allowed);
>        struct cpu_workqueue_stats *node;
> @@ -176,7 +176,7 @@
>
>  /* Complete of a work */
>  static void
> -probe_worklet_complete(struct task_struct *wq_thread, void *work)
> +probe_worklet_exit(struct task_struct *wq_thread, void *work)
>  {
>        int cpu = cpumask_first(&wq_thread->cpus_allowed);
>        struct cpu_workqueue_stats *node;
> @@ -504,17 +504,17 @@
>        if (ret)
>                goto out_worklet_enqueue;
>
> -       ret = register_trace_worklet_execute(probe_worklet_execute);
> +       ret = register_trace_worklet_entry(probe_worklet_entry);
>        if (ret)
>                goto out_worklet_enqueue_delayed;
>
> -       ret = register_trace_worklet_complete(probe_worklet_complete);
> +       ret = register_trace_worklet_exit(probe_worklet_exit);
>        if (ret)
> -               goto out_worklet_execute;
> +               goto out_worklet_entry;
>
>        ret = register_trace_workqueue_creation(probe_workqueue_creation);
>        if (ret)
> -               goto out_worklet_complete;
> +               goto out_worklet_exit;
>
>        ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
>        if (ret)
> @@ -529,10 +529,10 @@
>
>  out_workqueue_creation:
>        unregister_trace_workqueue_creation(probe_workqueue_creation);
> -out_worklet_complete:
> -       unregister_trace_worklet_complete(probe_worklet_complete);
> -out_worklet_execute:
> -       unregister_trace_worklet_execute(probe_worklet_execute);
> +out_worklet_exit:
> +       unregister_trace_worklet_exit(probe_worklet_exit);
> +out_worklet_entry:
> +       unregister_trace_worklet_entry(probe_worklet_entry);
>  out_worklet_enqueue_delayed:
>        unregister_trace_worklet_enqueue_delayed(probe_worklet_enqueue_delayed);
>  out_worklet_enqueue:
> Index: linux-2.6-master/kernel/workqueue.c
> ===================================================================
> --- linux-2.6-master.orig/kernel/workqueue.c    2009-05-26 12:43:59.000000000 +1000
> +++ linux-2.6-master/kernel/workqueue.c 2009-05-26 12:44:01.000000000 +1000
> @@ -296,9 +296,9 @@
>                work_clear_pending(work);
>                lock_map_acquire(&cwq->wq->lockdep_map);
>                lock_map_acquire(&lockdep_map);
> -               trace_worklet_execute(cwq->thread, work);
> +               trace_worklet_entry(cwq->thread, work);
>                f(work);
> -               trace_worklet_complete(cwq->thread, work);
> +               trace_worklet_exit(cwq->thread, work);
>                lock_map_release(&lockdep_map);
>                lock_map_release(&cwq->wq->lockdep_map);
>
> Index: linux-2.6-master/Documentation/trace/workqueue.txt
> ===================================================================
> --- linux-2.6-master.orig/Documentation/trace/workqueue.txt     2009-05-26 12:44:44.000000000 +1000
> +++ linux-2.6-master/Documentation/trace/workqueue.txt  2009-05-26 12:45:05.000000000 +1000
> @@ -98,8 +98,8 @@
>  # mount -t debugfs debug /sys/kernel/debug/
>  # cd /sys/kernel/debug/tracing/events/workqueue
>  # ls
> -filter          worklet_complete  worklet_enqueue_delayed  workqueue_creation     workqueue_flush
> -worklet_cancel  worklet_enqueue   worklet_execute          workqueue_destruction
> +filter          worklet_exit  worklet_enqueue_delayed  workqueue_creation     workqueue_flush
> +worklet_cancel  worklet_enqueue   worklet_entry          workqueue_destruction
>  # for e in $(ls); do echo 1 > $e/enable; done
>  # cat /sys/kernel/debug/tracing/trace
>
> @@ -108,7 +108,7 @@
>  #   | |       |          |         |
>
>  <...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task+0x0/0x280 cpu=0
> -<...>-508   [000]  4597.858660: worklet_execute: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task+0x0/0x280
> -<...>-508   [000]  4597.858684: worklet_complete: thread=ata/0:508 work=ffff88007e9e67b8
> +<...>-508   [000]  4597.858660: worklet_entry: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task+0x0/0x280
> +<...>-508   [000]  4597.858684: worklet_exit: thread=ata/0:508 work=ffff88007e9e67b8
>  <...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task+0x0/0x280
>  [...]
>
