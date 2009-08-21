Return-Path: <linux-kernel-owner+w=401wt.eu-S932858AbZHUXc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbZHUXc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbZHUXc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:32:26 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:63831 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbZHUXcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dxFoV4kqHYrPuTTi8YGIK+b8PfguqWdsjtBL/d7DBg7byA+iBervkORAGHNwS7pTJH
         /AHXeHmcYf+rK9HXeLJDwFfyEdSHPBonWytYC/1ZRfP0V0DBinFp/aYf0mwbZw9unEOu
         BniWk2D19AMWSbt5ekmR1fN3ZQHbiDzoAv0QQ=
MIME-Version: 1.0
In-Reply-To: <1250848605.7538.16.camel@twins>
References: <1250848605.7538.16.camel@twins>
Date: Fri, 21 Aug 2009 16:32:26 -0700
X-Google-Sender-Auth: e497f0e4ebaada66
Message-ID: <1f1b08da0908211632v441505ebm9a63bc0fa8f53d91@mail.gmail.com>
Subject: Re: [PATCH -rt] timer: delay waking softirqs from the jiffy tick
From: john stultz <johnstul@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000325574c96e8712a0471af4711
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000325574c96e8712a0471af4711
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2009 at 2:56 AM, Peter Zijlstra<peterz@infradead.org> wrote=
:
> most people were complaining about broken balancing with the recent -rt
> series.
>
> A look at /proc/sched_debug yielded:
>
> cpu#0, 2393.874 MHz
> =A0.nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: 0
> =A0.load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: 0
> =A0.cpu_load[0] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 177522
> =A0.cpu_load[1] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 177522
> =A0.cpu_load[2] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 177522
> =A0.cpu_load[3] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 177522
> =A0.cpu_load[4] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 177522
> cpu#1, 2393.874 MHz
> =A0.nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: 4
> =A0.load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: 4096
> =A0.cpu_load[0] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 181618
> =A0.cpu_load[1] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 180850
> =A0.cpu_load[2] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 180274
> =A0.cpu_load[3] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 179938
> =A0.cpu_load[4] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 179758
>
>
> Which indicated the cpu_load computation was hosed, the 177522 value
> indicates that there is one RT task runnable. Initially I thought the
> old problem of calculating the cpu_load from a softirq had re-surfaced,
> however looking at the code shows its being done from scheduler_tick().
>
> [ we really should fix this RT/cfs interaction some day... ]
>
> A few trace_printk()s later:
>
> =A0 =A0sirq-timer/1-19 =A0 =A0[001] =A0 174.289744: =A0 =A0 19: 50:S =3D=
=3D> [001] =A0 =A0 0:140:R <idle>
> =A0 =A0 =A0 =A0 =A0<idle>-0 =A0 =A0 [001] =A0 174.290724: enqueue_task_rt=
: adding task: 19/sirq-timer/1 with load: 177522
> =A0 =A0 =A0 =A0 =A0<idle>-0 =A0 =A0 [001] =A0 174.290725: =A0 =A0 =A00:14=
0:R =A0 + [001] =A0 =A019: 50:S sirq-timer/1
> =A0 =A0 =A0 =A0 =A0<idle>-0 =A0 =A0 [001] =A0 174.290730: scheduler_tick:=
 current load: 177522
> =A0 =A0 =A0 =A0 =A0<idle>-0 =A0 =A0 [001] =A0 174.290732: scheduler_tick:=
 current: 0/swapper
> =A0 =A0 =A0 =A0 =A0<idle>-0 =A0 =A0 [001] =A0 174.290736: =A0 =A0 =A00:14=
0:R =3D=3D> [001] =A0 =A019: 50:R sirq-timer/1
> =A0 =A0sirq-timer/1-19 =A0 =A0[001] =A0 174.290741: dequeue_task_rt: remo=
ving task: 19/sirq-timer/1 with load: 177522
> =A0 =A0sirq-timer/1-19 =A0 =A0[001] =A0 174.290743: =A0 =A0 19: 50:S =3D=
=3D> [001] =A0 =A0 0:140:R <idle>
>
> We see that we always raise the timer softirq before doing the load
> calculation. Avoid this by re-ordering the scheduler_tick() call in
> update_process_times() to occur before we deal with timers.
>
> This lowers the load back to sanity and restores regular load-balancing
> behaviour.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> =A0kernel/timer.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 8137cce..96ac1b4 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1221,10 +1221,10 @@ void update_process_times(int user_tick)
>
> =A0 =A0 =A0 =A0/* Note: this timer irq context must be accounted for as w=
ell. */
> =A0 =A0 =A0 =A0account_process_tick(p, user_tick);
> + =A0 =A0 =A0 scheduler_tick();
> =A0 =A0 =A0 =A0run_local_timers();
> =A0 =A0 =A0 =A0if (rcu_pending(cpu))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_check_callbacks(cpu, user_tick);
> - =A0 =A0 =A0 scheduler_tick();
> =A0 =A0 =A0 =A0run_posix_cpu_timers(p);
> =A0}

So I gave this a shot, and its somewhat improved, but I'm still seeing
a number of threads bunch up while other cpus go idle.

Simple c test case attached.

thanks
-john



sched_debug output:

Sched Debug Version: v0.09, 2.6.31-rc6-rt5fixed #11
now at 1452228.842078 msecs
  .jiffies                                 : 4296119524
  .sysctl_sched_latency                    : 60.000000
  .sysctl_sched_min_granularity            : 12.000000
  .sysctl_sched_wakeup_granularity         : 15.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 113917

cpu#0, 2193.084 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 3625608
  .nr_load_updates               : 1452203
  .nr_uninterruptible            : 355
  .next_balance                  : 4296.119775
  .curr->pid                     : 0
  .clock                         : 1452228.012605
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 384
  .cpu_load[3]                   : 224
  .cpu_load[4]                   : 120
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -2
  .rto_schedule                  : 1478928
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3636126
  .sched_goidle                  : 960497
  .ttwu_count                    : 1938509
  .ttwu_local                    : 1878333
  .bkl_count                     : 165

cfs_rq[0]:
  .exec_clock                    : 525430.235581
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1770489.332594
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.254107
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
---------------------------------------------------------------------------=
-------------------------------

cpu#1, 2193.084 MHz
  .nr_running                    : 5
  .load                          : 5120
  .nr_switches                   : 4824708
  .nr_load_updates               : 1451675
  .nr_uninterruptible            : -135
  .next_balance                  : 4296.119574
  .curr->pid                     : 19623
  .clock                         : 1452228.136825
  .cpu_load[0]                   : 5120
  .cpu_load[1]                   : 49500
  .cpu_load[2]                   : 38405
  .cpu_load[3]                   : 24537
  .cpu_load[4]                   : 15522
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -2
  .rto_schedule                  : 1472565
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 1
  .sched_switch                  : 0
  .sched_count                   : 6529209
  .sched_goidle                  : 432143
  .ttwu_count                    : 3181567
  .ttwu_local                    : 3128804
  .bkl_count                     : 250

cfs_rq[1]:
  .exec_clock                    : 1051264.911762
  .MIN_vruntime                  : 1550428.769298
  .min_vruntime                  : 1550428.613868
  .max_vruntime                  : 1550429.162494
  .spread                        : 0.393196
  .spread0                       : -220060.718726
  .nr_running                    : 5
  .load                          : 5120
  .nr_spread_over                : 4

rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.343947
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
---------------------------------------------------------------------------=
-------------------------------
            spin 19620   1550428.769298      3236   120
1550428.769298      3201.087846         0.133102
            spin 19621   1550428.916072      3230   120
1550428.916072      3205.577748         0.000000
            spin 19622   1550429.162494      3244   120
1550429.162494      3208.822004         0.000000
R           spin 19623   1550428.613868      3245   120
1550428.613868      3208.273826         0.000000
            spin 19624   1550428.914231      3320   120
1550428.914231      3279.605516         0.000000

cpu#2, 2193.084 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 3654869
  .nr_load_updates               : 1451358
  .nr_uninterruptible            : -161
  .next_balance                  : 4296.119525
  .curr->pid                     : 19626
  .clock                         : 1452228.262756
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 128
  .cpu_load[4]                   : 64
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -2
  .rto_schedule                  : 1489508
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3659050
  .sched_goidle                  : 1210178
  .ttwu_count                    : 1982899
  .ttwu_local                    : 1937837
  .bkl_count                     : 316

cfs_rq[2]:
  .exec_clock                    : 271064.442561
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1252745.472872
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -517743.859722
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

rt_rq[2]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.245213
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
---------------------------------------------------------------------------=
-------------------------------
R            cat 19626   1252745.472872         4   120
1252745.472872         0.938117         0.001859

cpu#3, 2193.084 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 3642923
  .nr_load_updates               : 1451041
  .nr_uninterruptible            : -59
  .next_balance                  : 4296.119528
  .curr->pid                     : 0
  .clock                         : 1452228.390208
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 256
  .cpu_load[2]                   : 192
  .cpu_load[3]                   : 112
  .cpu_load[4]                   : 60
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -2
  .rto_schedule                  : 1488745
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3647105
  .sched_goidle                  : 1205735
  .ttwu_count                    : 1971911
  .ttwu_local                    : 1935417
  .bkl_count                     : 938

cfs_rq[3]:
  .exec_clock                    : 278467.804587
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1506528.907842
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -263960.424752
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 2

rt_rq[3]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.304767
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
---------------------------------------------------------------------------=
-------------------------------

--000325574c96e8712a0471af4711
Content-Type: text/x-csrc; charset=US-ASCII; name="spin.c"
Content-Disposition: attachment; filename="spin.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fynk1hhk0

I2luY2x1ZGUgPHN0ZGlvLmg+CgoKCgp2b2lkIHNwaW4odm9pZCkKewoJd2hpbGUgICgxKSA7Cn0K
Cgp2b2lkIG1haW4odm9pZCkKewoJaW50IGk7Cglmb3IoaT0wO2k8NDtpKyspCgkJaWYoZm9yaygp
KQoJCQlzcGluKCk7CglzcGluKCk7Cgp9Cg==
--000325574c96e8712a0471af4711--
