Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbYESRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbYESRuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYESRug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:50:36 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57294 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYESRuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:50:35 -0400
Message-ID: <4831BDBA.6090609@linux.vnet.ibm.com>
Date: Mon, 19 May 2008 23:19:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: righiandr@users.sourceforge.net
CC: Shailabh Nagar <nagar@watson.ibm.com>, Mark Seger <Mark.Seger@hp.com>,
       Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] distinct tgid/tid I/O statistics (was: taskstats and
 /proc/.../io asymmetry?)
References: <482DF0C0.6050208@users.sourceforge.net>
In-Reply-To: <482DF0C0.6050208@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Balbir Singh wrote:
>> Mark Seger wrote:
>>> If you look at /proc/pid/stat, you can get the total CPU consumed by a
>>> process.  If you look at /proc/pid/task/tid/stat you can get the cpu
>>> consumed by a thread and if the tid is that of the parent you only gets
>>> its consumption as opposed to all its children.
>>>
>>> I was surprised to see that the way process I/O is reported doesn't
>>> follow this model.  There are no /prod/pid/task/tid/io entries but
>>> rather you need to look in /proc/tid/io.  While I view this as a minor
>>> inconvenience, I can certainly live with it.  However, /proc/pid/io does
>>> not show the aggregate I/O numbers for the whole process and that both
>>> surprises and disappoints.  This means if I have a process that starts a
>>> bunch of worker threads that do the real work and I want to find the top
>>> I/O consumers I can't simply walk the /proc/pid tree but rather have to
>>> look at all the threads of each process and add them up.
>>>
>>> Or am I missing something?
>>>
>>
>> I looked through the code and your argument seems to be correct. The
>> behaviour
>> is inconsistent w.r.t. other statistics like utime and stime. We
>> currently
>> accumulate tgid information in signal_struct, we need to do something
>> similar
>> for io as well. If nobody gets to it by the time I finish my backlog,
>> I'll try
>> and get to it.
> 
> Balbir, Mark,
> 
> what do you think about the following approach?
> Patch against 2.6.25.4, tested in KVM.
> 
> -Andrea
> 
> -- 
> Report per-thread I/O statistics in /proc/pid/task/tid/io and aggregate
> parent I/O statistics in /proc/pid/io. This approach follows the same
> model used to account per-process and per-thread CPU times.
> 
> As a practial application, this allows for example to quickly find the
> top I/O consumer when a process spawns many child threads that perform
> the actual I/O work, because the aggregated I/O statistics can always be
> found in /proc/pid/io.
> 
> Bug reported by Mark Seger <Mark.Seger@hp.com>.
> 

Comments below. Overall looks pretty well covered. Have you tested the patches?
Mark could you please test these and see?

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


> Signed-off-by: Andrea Righi <righiandr@users.sourceforge.net>
> ---
> fs/proc/base.c        |   83
> +++++++++++++++++++++++++++++++++++++++++++------
> include/linux/sched.h |    4 ++
> kernel/exit.c         |   27 ++++++++++++++++
> kernel/fork.c         |    6 +++
> 4 files changed, 110 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 81d7d14..23763c5 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2255,8 +2255,58 @@ static int proc_base_fill_cache(struct file
> *filp, void *dirent,
> }
> 
> #ifdef CONFIG_TASK_IO_ACCOUNTING
> -static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
> +static int do_io_accounting(struct task_struct *task, char *buffer, int
> whole)
> {
> +    unsigned long flags;
> +    u64 rchar, wchar, syscr, syscw;
> +    struct task_io_accounting ioac;
> +
> +    if (!whole) {
> +#ifdef CONFIG_TASK_XACCT

Can't we abstract this into a function for ease?

> +        rchar = task->rchar;
> +        wchar = task->wchar;
> +        syscr = task->syscr;
> +        syscw = task->syscw;
> +#endif
> +        memcpy(&ioac, &task->ioac, sizeof(ioac));
> +    } else {
> +        rchar = wchar = syscr = syscw = 0;
> +        memset(&ioac, 0, sizeof(ioac));
> +        rcu_read_lock();
> +        if (lock_task_sighand(task, &flags)) {

If lock(), what happens otherwise?

> +        struct signal_struct *sig = task->signal;
> +        struct task_struct *t = task;
> +
> +            do {
> +#ifdef CONFIG_TASK_XACCT
> +                rchar += t->rchar;
> +                wchar += t->wchar;
> +                syscr += t->syscr;
> +                syscw += t->syscw;
> +#endif
> +                ioac.read_bytes += t->ioac.read_bytes;
> +                ioac.write_bytes += t->ioac.write_bytes;
> +                ioac.cancelled_write_bytes +=
> +                        t->ioac.cancelled_write_bytes;
> +                t = next_thread(t);
> +            } while (t != task);
> +
> +#ifdef CONFIG_TASK_XACCT
> +            rchar += sig->rchar;
> +            wchar += sig->wchar;
> +            syscr += sig->syscr;
> +            syscw += sig->syscw;
> +#endif
> +            ioac.read_bytes += sig->ioac.read_bytes;
> +            ioac.write_bytes += sig->ioac.write_bytes;
> +            ioac.cancelled_write_bytes +=
> +                    sig->ioac.cancelled_write_bytes;
> +
> +            unlock_task_sighand(task, &flags);
> +        }
> +        rcu_read_unlock();
> +    }
> +
>     return sprintf(buffer,
> #ifdef CONFIG_TASK_XACCT
>             "rchar: %llu\n"
> @@ -2268,16 +2318,26 @@ static int proc_pid_io_accounting(struct
> task_struct *task, char *buffer)
>             "write_bytes: %llu\n"
>             "cancelled_write_bytes: %llu\n",
> #ifdef CONFIG_TASK_XACCT
> -            (unsigned long long)task->rchar,
> -            (unsigned long long)task->wchar,
> -            (unsigned long long)task->syscr,
> -            (unsigned long long)task->syscw,
> +            (unsigned long long)rchar,
> +            (unsigned long long)wchar,
> +            (unsigned long long)syscr,
> +            (unsigned long long)syscw,
> #endif
> -            (unsigned long long)task->ioac.read_bytes,
> -            (unsigned long long)task->ioac.write_bytes,
> -            (unsigned long long)task->ioac.cancelled_write_bytes);
> +            (unsigned long long)ioac.read_bytes,
> +            (unsigned long long)ioac.write_bytes,
> +            (unsigned long long)ioac.cancelled_write_bytes);
> +}
> +
> +static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
> +{
> +    return do_io_accounting(task, buffer, 0);
> }
> -#endif
> +
> +static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
> +{
> +    return do_io_accounting(task, buffer, 1);
> +}
> +#endif /* CONFIG_TASK_IO_ACCOUNTING */
> 
> /*
>  * Thread groups
> @@ -2348,7 +2408,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>     REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
> #endif
> #ifdef CONFIG_TASK_IO_ACCOUNTING
> -    INF("io",    S_IRUGO, pid_io_accounting),
> +    INF("io",    S_IRUGO, tgid_io_accounting),
> #endif
> };
> 
> @@ -2675,6 +2735,9 @@ static const struct pid_entry tid_base_stuff[] = {
> #ifdef CONFIG_FAULT_INJECTION
>     REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
> #endif
> +#ifdef CONFIG_TASK_IO_ACCOUNTING
> +    INF("io",    S_IRUGO, tid_io_accounting),
> +#endif
> };
> 
> static int proc_tid_base_readdir(struct file * filp,
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6a1e7af..ebf8b45 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -504,6 +504,10 @@ struct signal_struct {
>     unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
>     unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
>     unsigned long inblock, oublock, cinblock, coublock;
> +#ifdef CONFIG_TASK_XACCT
> +    u64 rchar, wchar, syscr, syscw;
> +#endif
> +    struct task_io_accounting ioac;
> 
>     /*
>      * Cumulative ns of scheduled CPU time for dead threads in the
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 073005b..1a35583 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -114,6 +114,18 @@ static void __exit_signal(struct task_struct *tsk)
>         sig->nivcsw += tsk->nivcsw;
>         sig->inblock += task_io_get_inblock(tsk);
>         sig->oublock += task_io_get_oublock(tsk);
> +#ifdef CONFIG_TASK_XACCT
> +        sig->rchar += tsk->rchar;
> +        sig->wchar += tsk->wchar;
> +        sig->syscr += tsk->syscr;
> +        sig->syscw += tsk->syscw;
> +#endif /* CONFIG_TASK_XACCT */
> +#ifdef CONFIG_TASK_IO_ACCOUNTING
> +        sig->ioac.read_bytes += tsk->ioac.read_bytes;
> +        sig->ioac.write_bytes += tsk->ioac.write_bytes;
> +        sig->ioac.cancelled_write_bytes +=
> +                    tsk->ioac.cancelled_write_bytes;
> +#endif /* CONFIG_TASK_IO_ACCOUNTING */
>         sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
>         sig = NULL; /* Marker for below. */
>     }
> @@ -1250,6 +1262,21 @@ static int wait_task_zombie(struct task_struct
> *p, int noreap,
>         psig->coublock +=
>             task_io_get_oublock(p) +
>             sig->oublock + sig->coublock;
> +#ifdef CONFIG_TASK_XACCT
> +        psig->rchar += p->rchar + sig->rchar;
> +        psig->wchar += p->wchar + sig->wchar;
> +        psig->syscr += p->syscr + sig->syscr;
> +        psig->syscw += p->syscw + sig->syscw;
> +#endif /* CONFIG_TASK_XACCT */
> +#ifdef CONFIG_TASK_IO_ACCOUNTING
> +        psig->ioac.read_bytes +=
> +            p->ioac.read_bytes + sig->ioac.read_bytes;
> +        psig->ioac.write_bytes +=
> +            p->ioac.write_bytes + sig->ioac.write_bytes;
> +        psig->ioac.cancelled_write_bytes +=
> +                p->ioac.cancelled_write_bytes +
> +                sig->ioac.cancelled_write_bytes;
> +#endif /* CONFIG_TASK_IO_ACCOUNTING */
>         spin_unlock_irq(&p->parent->sighand->siglock);
>     }
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 9c042f9..b8f408e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -924,6 +924,12 @@ static int copy_signal(unsigned long clone_flags,
> struct task_struct *tsk)
>     sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
>     sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
>     sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
> +#ifdef CONFIG_TASK_XACCT
> +    sig->rchar = sig->wchar = sig->syscr = sig->syscw = 0;
> +#endif
> +#ifdef CONFIG_TASK_IO_ACCOUNTING
> +    memset(&sig->ioac, 0, sizeof(sig->ioac));
> +#endif
>     sig->sum_sched_runtime = 0;
>     INIT_LIST_HEAD(&sig->cpu_timers[0]);
>     INIT_LIST_HEAD(&sig->cpu_timers[1]);


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
