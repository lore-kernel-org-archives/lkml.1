Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbZAPQ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbZAPQ6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZAPQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:58:26 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33884 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZAPQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LZWSKI9UlTNFDWKL2cXRfFqFsc0YPkbwDLTPWwzrBGyREUOJ38pdAXilHVVVUf/Mk9
         329k9DpY5TGzzLlJ0e8BETNPN9eKwa76Q2VE29ND0OF61bX1e3/g2ofyk2sxuS2EzKI5
         Gbt7mW2dNWWTgS6wFKdF8N6sFDxf/ocsvsEYo=
Message-ID: <c62985530901160858j3a8cd7b9o216cda473bc585e9@mail.gmail.com>
Date: Fri, 16 Jan 2009 17:58:22 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Mandeep Singh Baines" <msb@google.com>
Subject: Re: [PATCH v2] softlockup: decouple hung tasks check from softlockup detection
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
In-Reply-To: <20090112065213.GA19795@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112065213.GA19795@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mandeep,


2009/1/12 Mandeep Singh Baines <msb@google.com>:
> -/*
> - * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
> - * a really long time (120 seconds). If that happens, print out
> - * a warning.
> - */
> -static void check_hung_uninterruptible_tasks(int this_cpu)
> -{
> -       int max_count = sysctl_hung_task_check_count;
> -       unsigned long now = get_timestamp(this_cpu);
> -       struct task_struct *g, *t;
> -
> -       /*
> -        * If the system crashed already then all bets are off,
> -        * do not report extra hung tasks:
> -        */
> -       if (test_taint(TAINT_DIE) || did_panic)
> -               return;
> -
> -       read_lock(&tasklist_lock);
> -       do_each_thread(g, t) {
> -               if (!--max_count)
> -                       goto unlock;


Instead of having this arbitrary limit of tasks, why not just
lurk the need_resched() and then schedule if it needs too.

I know that sounds a bit racy, because you will have to release the
tasklist_lock and
a lot of things can happen in the task list until you become resched.
But you can do a get_task_struct() on g and t before your thread is
going to sleep and then put them
when it is awaken.
Perhaps some tasks will disappear or be appended in the list before g
and t, but that doesn't really matter:
if they disappear, they didn't lockup, and if they were appended, they
are not enough cold to be analyzed :-)

This way you can drop the arbitrary limit of task number given by the user....

Frederic.


> -               /* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
> -               if (t->state == TASK_UNINTERRUPTIBLE)
> -                       check_hung_task(t, now);
> -       } while_each_thread(g, t);
> - unlock:
> -       read_unlock(&tasklist_lock);
> -}
> -
> -/*
>  * The watchdog thread - runs every second and touches the timestamp.
>  */
>  static int watchdog(void *__bind_cpu)
>  {
>        struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> -       int this_cpu = (long)__bind_cpu;
>
>        sched_setscheduler(current, SCHED_FIFO, &param);
>
> @@ -267,11 +181,6 @@ static int watchdog(void *__bind_cpu)
>                if (kthread_should_stop())
>                        break;
>
> -               if (this_cpu == check_cpu) {
> -                       if (sysctl_hung_task_timeout_secs)
> -                               check_hung_uninterruptible_tasks(this_cpu);
> -               }
> -
>                set_current_state(TASK_INTERRUPTIBLE);
>        }
>        __set_current_state(TASK_RUNNING);
> @@ -303,20 +212,9 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>                break;
>        case CPU_ONLINE:
>        case CPU_ONLINE_FROZEN:
> -               check_cpu = any_online_cpu(cpu_online_map);
>                wake_up_process(per_cpu(watchdog_task, hotcpu));
>                break;
>  #ifdef CONFIG_HOTPLUG_CPU
> -       case CPU_DOWN_PREPARE:
> -       case CPU_DOWN_PREPARE_FROZEN:
> -               if (hotcpu == check_cpu) {
> -                       cpumask_t temp_cpu_online_map = cpu_online_map;
> -
> -                       cpu_clear(hotcpu, temp_cpu_online_map);
> -                       check_cpu = any_online_cpu(temp_cpu_online_map);
> -               }
> -               break;
> -
>        case CPU_UP_CANCELED:
>        case CPU_UP_CANCELED_FROZEN:
>                if (!per_cpu(watchdog_task, hotcpu))
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 3d56fe7..51a4748 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -771,6 +771,19 @@ static struct ctl_table kern_table[] = {
>                .extra1         = &neg_one,
>                .extra2         = &sixty,
>        },
> +#endif
> +#ifdef CONFIG_HUNG_TASK
> +       {
> +               .ctl_name       = CTL_UNNUMBERED,
> +               .procname       = "hung_task_panic",
> +               .data           = &sysctl_hung_task_panic,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = &proc_dointvec_minmax,
> +               .strategy       = &sysctl_intvec,
> +               .extra1         = &zero,
> +               .extra2         = &one,
> +       },
>        {
>                .ctl_name       = CTL_UNNUMBERED,
>                .procname       = "hung_task_check_count",
> @@ -786,7 +799,7 @@ static struct ctl_table kern_table[] = {
>                .data           = &sysctl_hung_task_timeout_secs,
>                .maxlen         = sizeof(unsigned long),
>                .mode           = 0644,
> -               .proc_handler   = &proc_doulongvec_minmax,
> +               .proc_handler   = &proc_dohung_task_timeout_secs,
>                .strategy       = &sysctl_intvec,
>        },
>        {
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index b0f239e..a52aa38 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -186,6 +186,44 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
>        default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
>        default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
>
> +config DETECT_HUNG_TASK
> +       bool "Detect Hung Tasks"
> +       depends on DEBUG_KERNEL
> +       default y
> +       help
> +         Say Y here to enable the kernel to detect "hung tasks",
> +         which are bugs that cause the task to be stuck in
> +         uninterruptible "D" state indefinitiley.
> +
> +         When a hung task is detected, the kernel will print the
> +         current stack trace (which you should report), but the
> +         task will stay in uninterruptible state. If lockdep is
> +         enabled then all held locks will also be reported. This
> +         feature has negligible overhead.
> +
> +config BOOTPARAM_HUNG_TASK_PANIC
> +       bool "Panic (Reboot) On Hung Tasks"
> +       depends on DETECT_HUNG_TASK
> +       help
> +         Say Y here to enable the kernel to panic on "hung tasks",
> +         which are bugs that cause the kernel to leave a task stuck
> +         in uninterruptible "D" state.
> +
> +         The panic can be used in combination with panic_timeout,
> +         to cause the system to reboot automatically after a
> +         hung task has been detected. This feature is useful for
> +         high-availability systems that have uptime guarantees and
> +         where a hung tasks must be resolved ASAP.
> +
> +         Say N if unsure.
> +
> +config BOOTPARAM_HUNG_TASK_PANIC_VALUE
> +       int
> +       depends on DETECT_HUNG_TASK
> +       range 0 1
> +       default 0 if !BOOTPARAM_HUNG_TASK_PANIC
> +       default 1 if BOOTPARAM_HUNG_TASK_PANIC
> +
>  config SCHED_DEBUG
>        bool "Collect scheduler debugging info"
>        depends on DEBUG_KERNEL && PROC_FS
> --
> 1.5.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
