Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZDXW7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZDXW7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZDXW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:59:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46947 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZDXW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KRMlHK7QEjauBMisXfHa04TCQ3o/oJGNyTPvOWxGtrUKPBbsQPspvUb2C/4FrxwYag
         f/VvVnEbekOz8lE7Ja5en5tLLMJTojvsGygZ/jguxUDb9yu5r9diaAWuv/tolVKYViD0
         LQc5ndhf3IJJQUIM90y99UQ4UxMmbWpu0u9E8=
Date: Sat, 25 Apr 2009 00:59:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090424225909.GA6658@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424130616.a3c217cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 01:06:16PM -0700, Andrew Morton wrote:
> On Fri, 24 Apr 2009 19:42:19 +0800
> Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
> > These patchs add tracepoints for per-worklet tracing.
> > Now we have enough tracepoints to start makeing trace_workqueue.c support
> > worklet time mesurement.
> 
> I'm not seing anywhere in this patchset a description of the user
> interface.  What does the operator/programmer actually get to see from
> the kernel as a result of these changes?
> 
> A complete usage example would be an appropriate way of communicating
> all of this.
> 
> The patches introduce a moderate amount of tracing-specific hooks into
> the core workqueue code, which inevitably increases the maintenance
> load for that code.  It is important that it be demonstrated that the
> benefts of the code are worth that cost.  Hence it is important that
> these benefits be demonstrated to us, by yourself.  Please.
> 
> Another way of looking at it: which previously-encountered problems
> would this facility have helped us to solve?  How will this facility
> help us to solve problems in the future?  Looking at this patch series
> I cannot answer those questions!
> 


Hi Andrew,

Although I'm not the author of this patchset, I'm somewhat
involved in the workqueue tracer and I would like to express
my opinion on what is happening.

Until recently, the workqueue tracer was a basic machine.
It was designed to trace the workqueue level. We were not yet
thinking about the worklet level:

- creation of a workqueue thread
- cleanup/destruction of these threads
- insertion of a work in a workqueue
- execution of this work

The output looked like such following histogram:

#   CPU   INSERTED  EXECUTED   WORKQUEUE THREAD
#
      1    125        125       reiserfs/1
      1      0          0       scsi_tgtd/1
      1      0          0       aio/1
      1      0          0       ata/1
      1    114        114       kblockd/1
      1      0          0       kintegrityd/1
      1   2147       2147       events/1
    
      0      0          0       kpsmoused
      0    105        105       reiserfs/0
      0      0          0       scsi_tgtd/0
      0      0          0       aio/0
      0      0          0       ata_aux
      0      0          0       ata/0
      0      0          0       cqueue
      0      0          0       kacpi_notify
      0      0          0       kacpid
      0    149        149       kblockd/0
      0      0          0       kintegrityd/0
      0   1000       1000       khelper
      0   2270       2270       events/0


Its purpose and the information it gave was limited, though
somehow useful.
It was able to provide some informations about the frequency
of the works inserted.

Why that? Because it pushed some useful informations to help a
kernel developer when it's time to decide how to defer async jobs.
Should he use the traditional and whole purposed events workqueues
or a devoted workqueue?

The decision has to be made relatively to:

- the workload it induces. If we might insert too much
  works at a time, we can create unacceptable latencies
  that may delay other queued works. Events/%d are such
  fragile pieces.

- The workload is not only about work insertion frequency
  but also about how much time is spent to process a work.
  Could it be trying to perform too much things which involve
  too much cpu time? Could it sleep for too much time, waiting
  for an event, a very contended lock or something?

- Another kind of reasons that may encumber the events and
  create bad latencies.

After reading this list of requirements, I guess you noticed
that only capturing the frequency of inserted events is only
one variable that composes the workload recipe.
Not only is it giving incomplete information, but it is also
providing erroneous datas to the user which might focuse
on these frequencies when they become large whereas a single work
can create more burden than hundreds of others.


Then, Zhaolei and Kosaki Motohiro came up recently with a good
update for this tracer by posting a patchset which integrates
the per-worklet tracing dimension.
And the output on my laptop became the following:

$ cat /debug/tracing/trace_stat/workqueues 
# CPU  INSERTED  EXECUTED   TASKNAME:PID
# |      |         |        `-WORKFUNC
# |      |         |          |
  0   3822       3898       events/0:9
  0      1          1        |-hpet_work+0x0/0x340
  0     47         46        |-rt_worker_func+0x0/0x400
  0   2655       2654        |-vmstat_update+0x0/0x40
  0      1          1        |-power_supply_changed_work+0x0/0x60
  0    212        212        |-fb_flashcursor+0x0/0x3c0
  0     80         80        |-test_work+0x0/0x64
  0     10          9        |-rekey_seq_generator+0x0/0x70
  0      8          7        |-lru_add_drain_per_cpu+0x0/0x10
  0    455        455        |-console_callback+0x0/0x1e0
  0    249        249        |-flush_to_ldisc+0x0/0x2f0
  0      1          1        |-atkbd_event_work+0x0/0xb0
  0    103         96        `-dst_gc_task+0x0/0x340
  0      0          0       cpuset:11
  0   1378       1378       khelper:12
  0   1378       1378        `-__call_usermodehelper+0x0/0xe0
  0      0          0       kintegrityd/0:178
  0    333        333       kblockd/0:184
  0    233        233        |-blk_unplug_work+0x0/0x110
  0    100        100        `-cfq_kick_queue+0x0/0x50
  0      0          0       kacpid:190
  0      0          0       kacpi_notify:191
  0      0          0       tifm:498
  0   8048       8048       ata/0:507
  0   8048       8048        `-ata_pio_task+0x0/0x280
  0      0          0       ata_aux:511
  0      0          0       aio/0:871
  0      0          0       crypto/0:897
  0      0          0       scsi_tgtd/0:2368
  0      0          0       iscsi_eh:2387
  0      0          0       kpsmoused:2521
  0      0          0       hd-audio0:2660
  0      0          0       krxrpcd/0:2745
  0     59         59       reiserfs/0:2895
  0     59         59        `-flush_async_commits+0x0/0x90
  1   5480       5503       events/1:10
  1      1          1        |-hpet_work+0x0/0x340
  1   2819       2818        |-vmstat_update+0x0/0x40
  1    464        464        |-console_callback+0x0/0x1e0
  1     80         80        |-test_work+0x0/0x64
  1      1          1        |-sysfs_add_func+0x0/0xb0
  1      8          8        |-lru_add_drain_per_cpu+0x0/0x10
  1      1          1        |-sync_cmos_clock+0x0/0x140
  1   1823       1823        |-fb_flashcursor+0x0/0x3c0
  1    282        282        |-flush_to_ldisc+0x0/0x2f0
  1      1          1        `-atkbd_event_work+0x0/0xb0
  1      0          0       kintegrityd/1:181
  1    254        254       kblockd/1:185
  1    148        148        |-blk_unplug_work+0x0/0x110
  1    106        106        `-cfq_kick_queue+0x0/0x50
  1  10988      10988       ata/1:509
  1  10988      10988        `-ata_pio_task+0x0/0x280
  1      0          0       aio/1:878
  1      0          0       crypto/1:898
  1      0          0       scsi_tgtd/1:2370
  1      0          0       krxrpcd/1:2746
  1     25         25       reiserfs/1:2896
  1     25         25        `-flush_async_commits+0x0/0x90


The trace has evolved by decomposing these frequency stats
per-worklet. Not only does it help for a driver writer to
instrument its own async jobs, but also it can help
any developer to find the culprit source of a latency
issued from a workqueue.

It can at least show a first direction of investigation, because
we are still only talking about frequency.
And speaking about incomplete informations, this output is only
a step before the main goal which is to provide the average and the
maximum time of execution for each worklet.


# CPU  INSERTED  EXECUTED  AVG TIME  MAX TIME	 TASKNAME:PID
# |      |         |          |         |        `-WORKFUNC
# |      |         |          |         |          |
  0   3822       3898        100 us    200us       events/0:9
  0      1          1        12 us     15us        |-hpet_work+0x0/0x340
  0     47         46        10 us     45us        |-rt_worker_func+0x0/0x400


With that we'll have much more indications to start a latency investigation.
But to get this end result, we needed the changes done on this latest patchset
from Zhaolei and Kosaki which, in the middle of other useful changes, turns
the workqueue_execution event into a new dichotomous capture with:

- trace_work_execute
- trace_work_complete

It was a required piece to perform the time of execution measurement.

Also, as I said, the statistical/histogram output is only the first step
of any worklet instrumentation. Once we focuse in a specific culprit,
we can trace all of its lifecycle using the trace events:
insertion, execution, completion, delayed insertion, cancelling, and so on.

All these events provide all the required fine grained instrumentation
to learn any worklet lifecycle details. Combining with well chosen events
toggling and event's fields filtering, we can focus on the only relevant
events at the time. 

Example of such trace:

# cd /debug/tracing

# ls events/workqueue/
filter          worklet_complete  worklet_enqueue_delayed  workqueue_creation     workqueue_flush
worklet_cancel  worklet_enqueue   worklet_execute          workqueue_destruction

# for e in $(ls events/workqueue); do echo 1 > events/workqueue/$e/enable; done

# tail -f trace

 events/1-10    [001]  4687.187314: worklet_execute: thread=events/1:10 work=ffff880001b27200 func=vmstat_update+0x0/0x40
 events/1-10    [001]  4687.187330: worklet_enqueue_delayed: thread=events/1:10 func=vmstat_update+0x0/0x40 cpu=-1 delay=250
 events/1-10    [001]  4687.187331: worklet_complete: thread=events/1:10 work=ffff880001b27200
 events/0-9     [000]  4687.250236: worklet_execute: thread=events/0:9 work=ffff880001b0c200 func=vmstat_update+0x0/0x40
 events/0-9     [000]  4687.250250: worklet_enqueue_delayed: thread=events/0:9 func=vmstat_update+0x0/0x40 cpu=-1 delay=237
 events/0-9     [000]  4687.250251: worklet_complete: thread=events/0:9 work=ffff880001b0c200

If more details are needed, such events could fit nicely inside with a
function graph tracer output.

So this latest patchset provides all these required informations on the events
tracing level. The next step is likely to be on the stat tracing to provide the avg/max time
of execution.


Thanks,
Frederic.

