Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYJUMrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYJUMrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYJUMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:47:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:30504 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYJUMrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uS4bjxnMxKJgFhk98nGILwxvmtD7X93mR/6NhRlT77fmcuJW9KH9F9jPsGEQsTFJD3
         NNMNwOyf576ldtGF6sLfUG86NDz48ZDo/Mr5aHWtFI25yxaz0fktaZXaRShe8+FbMmbC
         Aa7vXZB+4UX/54ykQX+YQk6d1jF9F1Aq803t0=
Message-ID: <c62985530810210547i3291d065m734fdf0e6b90a6b6@mail.gmail.com>
Date: Tue, 21 Oct 2008 14:47:19 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/5] tracing/fastboot: Make the boot tracer use the cpu_clock
Cc: "Arjan van de Ven" <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <48F109D5.9030703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F109D5.9030703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/11 Frederic Weisbecker <fweisbec@gmail.com>:
> Make the boot tracer use the cpu_clock() rather than the ktime
> API. This way we will be able to unify the time capture with
> the sched_switch tracer.
> Also delete the duration attribute which is not needed and can be
> retrieved at print time.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  include/linux/ftrace.h    |    5 ++---
>  init/main.c               |   25 ++++++++++++++++++-------
>  kernel/trace/trace_boot.c |   18 ++++++++++--------
>  3 files changed, 30 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 135a33f..36b570b 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -222,9 +222,8 @@ struct boot_trace {
>        pid_t                   caller;
>        char                    func[KSYM_NAME_LEN];
>        int                     result;
> -       unsigned long long      duration;
> -       ktime_t                 calltime;
> -       ktime_t                 rettime;
> +       unsigned long long      calltime;
> +       unsigned long long      rettime;
>  };
>
>  #ifdef CONFIG_BOOT_TRACER
> diff --git a/init/main.c b/init/main.c
> index 98c05aa..bf13013 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -721,27 +721,38 @@ __setup("initcall_debug", initcall_debug_setup);
>  int do_one_initcall(initcall_t fn)
>  {
>        int count = preempt_count();
> -       ktime_t delta;
> +       ktime_t delta, t0, t1;
>        char msgbuf[64];
> +       unsigned long long duration;
>        struct boot_trace it;
>
>        if (initcall_debug) {
> +               long cpu;
>                it.caller = task_pid_nr(current);
>                printk("calling  %pF @ %i\n", fn, it.caller);
> -               it.calltime = ktime_get();
> +               t0 = ktime_get();
> +               preempt_disable();
> +               cpu = raw_smp_processor_id();
> +               it.calltime = cpu_clock(cpu);
> +               preempt_enable();
>                enable_boot_trace();
>        }
>
>        it.result = fn();
>
>        if (initcall_debug) {
> -               it.rettime = ktime_get();
> -               delta = ktime_sub(it.rettime, it.calltime);
> -               it.duration = (unsigned long long) delta.tv64 >> 20;
> +               long cpu;
> +               disable_boot_trace();
> +               t1 = ktime_get();
> +               preempt_disable();
> +               cpu = raw_smp_processor_id();
> +               it.rettime = cpu_clock(cpu);
> +               preempt_enable();
> +               delta = ktime_sub(t1, t0);
> +               duration = (unsigned long long) delta.tv64 >> 20;
>                printk("initcall %pF returned %d after %Ld msecs\n", fn,
> -                       it.result, it.duration);
> +                       it.result, duration);
>                trace_boot(&it, fn);
> -               disable_boot_trace();
>        }
>
>        msgbuf[0] = 0;
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index bd5046c..20d326b 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -68,22 +68,24 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
>        struct trace_boot *field = (struct trace_boot *)entry;
>        struct boot_trace *it = &field->initcall;
>        struct trace_seq *s = &iter->seq;
> -       struct timespec calltime = ktime_to_timespec(it->calltime);
> -       struct timespec rettime = ktime_to_timespec(it->rettime);
> +       unsigned long sec, nsec_rem;
> +       unsigned long long duration = it->rettime - it->calltime;
>
>        if (entry->type == TRACE_BOOT) {
> +               nsec_rem = do_div(it->calltime, 1000000000);
> +               sec = (unsigned long) it->calltime;
>                ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
> -                                         calltime.tv_sec,
> -                                         calltime.tv_nsec,
> -                                         it->func, it->caller);
> +                                         sec, nsec_rem, it->func, it->caller);
>                if (!ret)
>                        return TRACE_TYPE_PARTIAL_LINE;
>
> +               nsec_rem = do_div(it->rettime, 1000000000);
> +               sec = (unsigned long) it->rettime;
> +               do_div(duration, 1000);
>                ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
>                                          "returned %d after %lld msecs\n",
> -                                         rettime.tv_sec,
> -                                         rettime.tv_nsec,
> -                                         it->func, it->result, it->duration);
> +                                         sec, nsec_rem, it->func, it->result,
> +                                         duration);
>
>                if (!ret)
>                        return TRACE_TYPE_PARTIAL_LINE;
>

Please just ignore this patch. I think I will change a bit the design
of the boot tracer by sending
two types of entries: the call and the return. With this new approach,
I will be able to use the internal
timestamp of the ring buffer and stay consistent with the same used
for sched switch entries.

Thanks.
