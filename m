Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbZLPHWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbZLPHWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933947AbZLPHWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:22:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636AbZLPHWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:22:07 -0500
Date: Wed, 16 Dec 2009 08:21:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20091216072147.GC11825@elte.hu>
References: <20090624131104.705c828d@skybase>
 <20090624112929.GB2079@linux-sh.org>
 <20090624142828.7c6a2337@skybase>
 <20090624123416.GB9510@linux-sh.org>
 <20090624145406.7f0f579b@skybase>
 <20091216045245.GC31265@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216045245.GC31265@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> Hi Martin,
> 
> On Wed, Jun 24, 2009 at 02:54:06PM +0200, Martin Schwidefsky wrote:
> > On Wed, 24 Jun 2009 21:34:16 +0900
> > Paul Mundt <lethal@linux-sh.org> wrote:
> > > On Wed, Jun 24, 2009 at 02:28:28PM +0200, Martin Schwidefsky wrote:
> > > > On Wed, 24 Jun 2009 20:29:29 +0900
> > > > Paul Mundt <lethal@linux-sh.org> wrote:
> > > > > No. oprofile_timer_init() is only entered if the performance counters
> > > > > fail to register in the SH7750 case, so there is only one timer hook user
> > > > > at a time:
> > > > > 
> > > > > static int __init oprofile_init(void)
> > > > > {
> > > > >         int err;
> > > > > 
> > > > >         err = oprofile_arch_init(&oprofile_ops);
> > > > > 
> > > > >         if (err < 0 || timer) {
> > > > >                 printk(KERN_INFO "oprofile: using timer interrupt.\n");
> > > > >                 oprofile_timer_init(&oprofile_ops);
> > > > >         }
> > > > > ...
> > > > 
> > > > Oh, I see. That is the reason why the s390 version of
> > > > oprofile_arch_init returns -ENODEV. It does so to trigger the fallback
> > > > to the timer_hook. That should work for sh as well, no?
> > > > 
> > > It would, yes, but it would also disable access to the SH7750 counters at
> > > the same time, so we don't really want to do that. The sh7750 counters
> > > are more like timer based profiling with some extra events that can be
> > > set and read, so reverting to oprofile_timer_init() would reduce
> > > functionality.
> > > 
> > > My current plan is to migrate things over to the perf_counter API and
> > > annoy Ingo with my interrupt deprived counters ;-)
> > > 
> > > Given that hrtimers are already generically supported there, it should
> > > tie in much cleaner there than in the oprofile case at least.
> > 
> > Ok, that makes sense. So I guess for now I should stop trying to get
> > rid of the timer_hook and concentrate to convert the fallback code
> > in timer_int.c to hrtimer. Then after sh is fully converted to the
> > perf_counter API we can do the cleanup.
> > 
> 
> This is just a follow-up to let you know that the first-step transition to 
> the perf_counter API is done. There's still more work to do, but we're 
> already more functional on the perf_counter side than we ever were on 
> oprofile. [...]

Nice to hear!

Please let us know if you have any problems on the tools/perf/ side as well - 
in particular everyday usability. Even small details matter.

Also, embedded-system usability would be of interest as well. Most of the perf 
tooling gets tested on x86 so it's quite possible that some aspects are not as 
slim as they could be.

One key point of performance is the bona fide overhead of a default "perf 
record" profile recording session. On x86, it's roughly in the following 
range:

 aldebaran:~> perf stat --repeat 3 -e instructions ./loop_10b_instructions

 Performance counter stats for './loop_10b_instructions' (3 runs):

    10009061648  instructions             #      0.000 IPC     ( +-   0.067% )

    2.407052637  seconds time elapsed   ( +-   1.259% )

 aldebaran:~> perf stat --repeat 3 -e instructions perf record -f ./loop_10b_instructions
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.073 MB perf.data (~3191 samples) ]
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.073 MB perf.data (~3183 samples) ]
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.073 MB perf.data (~3190 samples) ]

 Performance counter stats for 'perf record -f ./loop_10b_instructions' (3 runs):

    10029183818  instructions             #      0.000 IPC     ( +-   0.004% )

    2.377064570  seconds time elapsed   ( +-   0.215% )

I.e. 10029183818/10009061648 ~== 0.2% direct overhead.

For something very system and task intense (such as hackbench) it can go up to 
2.5%.

Thanks,

	Ingo
