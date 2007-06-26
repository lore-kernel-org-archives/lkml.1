Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbXFZDE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbXFZDE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXFZDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:04:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbXFZDEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:04:16 -0400
Date: Mon, 25 Jun 2007 20:02:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?UTF-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-Id: <20070625200235.9d24f6cd.akpm@linux-foundation.org>
In-Reply-To: <20070622222036.GC27445@elte.hu>
References: <20070622220202.GA16872@elte.hu>
	<200706230109.08310.caglar@pardus.org.tr>
	<200706230116.29615.caglar@pardus.org.tr>
	<20070622222036.GC27445@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 00:20:36 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * S.Çağlar Onur <caglar@pardus.org.tr> wrote:
> 
> > > kernel/sched.c:745:28: sched_idletask.c: No such file or directory
> > 
> > Ahh and this happens with [1], grabbing sched_idletask.c from .18 one solves 
> > the problem...
> 
> oops, indeed - i've fixed up the -git patch:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22-git-v18.patch
> 

So I locally generated the diff to take -mm up to the above version of CFS.


- sys_sched_yield_to() went away?  I guess I missed that.

- Curious.  the simplification of task_tick_rt() seems to go only
  halfway.  Could do

	if (p->policy != SCHED_RR)
		return;

	if (--p->time_slice)
		return;

	/* stuff goes here */

- dud macro:
					
#define is_rt_policy(p)		((p) == SCHED_FIFO || (p) == SCHED_RR)

  It evaluates its arg twice and could and should be coded in C.

  There are a bunch of other don't-need-to-be-implemented-as-a-macro
  macros around there too.  Generally, I suggest you review all the
  patchset for macros-which-don't-need-to-be-macros.

- Extraneous newline:

enum cpu_idle_type
{

- Style thing:

struct sched_entity {
	struct load_weight load;	/* for nice- load-balancing purposes */
	int on_rq;
	struct rb_node run_node;
	unsigned long delta_exec;
	s64 delta_fair;

	u64 wait_start_fair;
	u64 wait_start;
	u64 exec_start;
	u64 sleep_start, sleep_start_fair;
	u64 block_start;
	u64 sleep_max;
	u64 block_max;
	u64 exec_max;
	u64 wait_max;
	u64 last_ran;

	s64 wait_runtime;
	u64 sum_exec_runtime;
	s64 fair_key;
	s64 sum_wait_runtime, sum_sleep_runtime;
	unsigned long wait_runtime_overruns, wait_runtime_underruns;
};

  I think the one-definition-per-line style is better than the `unsigned
  long foo,bar,zot,zit;' thing.  Easier to read, easier to read subsequent
  patches and it leaves more room for a comment describing what the field
  does.

- None of these fields have comments describing what they do ;)

- __exit_signal() does apparently-unlocked 64-bit arith.  Is there some
  implicit locking here or do we not care about the occasional race-induced
  inaccuracy?

  (ditto, lots of places, I expect)

  (Gee, there's shitloads of 64-bit stuff in there.  Does it all _really_
  need to be 64-bit on 32-bit?)

- weight_s64() (what does this do?) looks too big to inline on 32-bit.

- update_stats_enqueue() looks too big to inline even on 64-bit.

- Overall, this change is tremendously huge for something which is
  supposedly ready-to-merge.  Looks like a lot of that is the sched_entity
  conversion, but afaict there's quite a lot besides.

- Should "4" in

	(sysctl_sched_features & 4)

  be enumerated?

- Maybe even __check_preempt_curr_fair() is too porky to inline.

- There really is an astonishing amount of 64-bit arith in here...

- Some opportunities for useful comments have been missed ;)

#define NICE_0_LOAD	SCHED_LOAD_SCALE
#define NICE_0_SHIFT	SCHED_LOAD_SHIFT

  <wonders what these mean>

- Should any of those new 64-bit arith functions in sched.c be pulled out
  and made generic?

- update_curr_load() is huge, inlined and has several callsites?

- lots more macros-which-dont-need-to-be-macros in sched.c:
  load_weight(), PRIO_TO_load_weight(), RTPRIO_TO_load_weight(), maybe
  others.  People are more inclined to comment functions than they are
  macros, for some reason.

- inc_load(), dec_load(), inc_nr_running(), dec_nr_running(): these will
  generate plenty of code on 32-bit and they're all inlined with multiple
  callsites.

- overall, CFS takes sched.o from 41157 of .text up to 48781 on x86_64,
  which at 18% is rather a large bloat.  Hopefully a lot of this is the new
  debug stuff.

- On i386 sched.o went from 33755 up to 43660 which is 29% growth. 
  Possibly acceptable, but why did it increase a lot more than the x86_64
  version?  All that 64-bit arith, I assume?

- style (or the lack thereof):

	p->se.sum_wait_runtime = p->se.sum_sleep_runtime = 0;
	p->se.sleep_start = p->se.sleep_start_fair = p->se.block_start = 0;
	p->se.sleep_max = p->se.block_max = p->se.exec_max = p->se.wait_max = 0;
	p->se.wait_runtime_overruns = p->se.wait_runtime_underruns = 0;

  bit of an eyesore?

- in sched_init() this looks funny:

		rq->ls.load_update_last = sched_clock();
		rq->ls.load_update_start = sched_clock();

  was it intended that these both get the same value?

	
