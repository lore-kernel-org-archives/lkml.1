Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYJVRp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYJVRp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbYJVRf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:35:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:11050 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbYJVRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=io3CvR7DL6lKTEYwhcM7JjYU/Z2kIMBTeiEsmsYAisn7/YoXMVpWs1fukO6UxgITIF
         S8B3MyMXq1m7WyAGnsgd/6voHSXcjSNkTD5K/f2JnI54DhHLeG+7kcz2PrjpZTyQrV+7
         iCBJaFxlxy7xUupw75KgYusUDgmPzJnOXk4z8=
Message-ID: <c62985530810221035y6c19f364k3e07512bdf17b59a@mail.gmail.com>
Date: Wed, 22 Oct 2008 19:35:54 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] tracing/ftrace: Types and naming corrections for sched tracer
In-Reply-To: <48FF636F.6090804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FF636F.6090804@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/22 Frederic Weisbecker <fweisbec@gmail.com>:
> This patch applies some corrections suggested by Steven Rostedt.
>
> Change the type of shed_ref into int since it is used
> into a Mutex, we don't need it anymore as an atomic
> variable in the sched_switch tracer.
> Also change the name of the register mutex.
>
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_sched_switch.c |   30 +++++++++++++-----------------
>  1 files changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/kernel/trace/trace_sched_switch.c
> b/kernel/trace/trace_sched_switch.c
> index 9d7bdac..969953b 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -16,8 +16,8 @@
>
>  static struct trace_array      *ctx_trace;
>  static int __read_mostly       tracer_enabled;
> -static atomic_t                sched_ref;
> -static DEFINE_MUTEX(tracepoint_mutex);
> +static int                     sched_ref;
> +static DEFINE_MUTEX(sched_register_mutex);
>
>  static void
>  probe_sched_switch(struct rq *__rq, struct task_struct *prev,
> @@ -28,7 +28,7 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
>        int cpu;
>        int pc;
>
> -       if (!atomic_read(&sched_ref))
> +       if (!sched_ref)
>                return;
>
>        tracing_record_cmdline(prev);
> @@ -124,26 +124,22 @@ static void tracing_sched_unregister(void)
>
>  static void tracing_start_sched_switch(void)
>  {
> -       long ref;
> -
> -       mutex_lock(&tracepoint_mutex);
> -        tracer_enabled = 1;
> -       ref = atomic_inc_return(&sched_ref);
> -       if (ref == 1)
> +       mutex_lock(&sched_register_mutex);
> +       if (!(sched_ref++)) {
> +               tracer_enabled = 1;
>                tracing_sched_register();
> -       mutex_unlock(&tracepoint_mutex);
> +       }
> +       mutex_unlock(&sched_register_mutex);
>  }
>
>  static void tracing_stop_sched_switch(void)
>  {
> -       long ref;
> -
> -       mutex_lock(&tracepoint_mutex);
> -       tracer_enabled = 0;
> -       ref = atomic_dec_and_test(&sched_ref);
> -       if (ref)
> +       mutex_lock(&sched_register_mutex);
> +       if (!(--sched_ref)) {
>                tracing_sched_unregister();
> -       mutex_unlock(&tracepoint_mutex);
> +               tracer_enabled = 0;
> +       }
> +       mutex_unlock(&sched_register_mutex);
>  }
>
>  void tracing_start_cmdline_record(void)
>

Correction, it's not anymore a 1/5, it's just a resend.
