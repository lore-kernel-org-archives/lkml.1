Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbXJRWUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbXJRWUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbXJRWUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:20:01 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52033 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753703AbXJRWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:20:00 -0400
Date: Thu, 18 Oct 2007 18:19:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: schedstat needs a diet
Message-ID: <20071018221957.GA31609@Krystal>
References: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com> <20071017072323.GB18044@elte.hu> <1192613387.27435.114.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1192613387.27435.114.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:51:26 up 80 days, 22:10,  4 users,  load average: 2.44, 2.09, 1.37
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2007-10-17 at 09:23 +0200, Ingo Molnar wrote:
> > * Ken Chen <kenchen@google.com> wrote:
> > 
> > > schedstat is useful in investigating CPU scheduler behavior.  Ideally, 
> > > I think it is beneficial to have it on all the time.  However, the 
> > > cost of turning it on in production system is quite high, largely due 
> > > to number of events it collects and also due to its large memory 
> > > footprint.
> > > 
> > > Most of the fields probably don't need to be full 64-bit on 64-bit 
> > > arch.  Rolling over 4 billion events will most like take a long time 
> > > and user space tool can be made to accommodate that.  I'm proposing 
> > > kernel to cut back most of variable width on 64-bit system.  (note, 
> > > the following patch doesn't affect 32-bit system).
> > 
> > thanks, applied.
> > 
> > note that current -git has a whole bunch of new schedstats fields in 
> > /proc/<PID>/sched which can be used to track the exact balancing 
> > behavior of tasks. It can be cleared via echoing 0 to the file - so 
> > overflow is not an issue. Most of those new fields should probably be 
> > unsigned int too. (they are u64 right now.)
> > 
> 
> FWIW I can't see how this patch saves a _lot_ of space. The stats are
> per domain or per rq, neither are things that have a lot of instances.
> 
> That said, I have no actual objection to the patch, just not getting it.
> 
> 

Good question indeed. How large is this memory footprint exactly ? If it
is as small as you say, I suspect that the real issue could be that
these variable are accessed by the scheduler critical paths and
therefore trash the caches.

(in bytes with 8 bytes longs)
(in 2.6.23-mm1)

task struct
  struct sched_entity 9 * 8 bytes
  struct sched_info 5 * 8 bytes
(as Ingo noted, this is only in -mm. It really hurts since it grows the
task structs)

struct sched_domain
  20 * 8 bytes
O(nr cpus) or a little more on tricky setups

struct rq
  struct sched_info 5 * 8 bytes
  10 * 8 bytes
O(nr cpus), which is not much.

If the memory footprint of struct sched_domain and struct rq really
matters, one should set its NR_CPUS to the lowest value required by his
setup to help reduce the memory size. And forget about per task
statistics.

Adding data to the task struct will turn out to be a real problem, both
for memory consumption and cache trashing. Could we think of allocating
the memory required for statistics (scheduler, vm, ...) only when stats
collection is required ? It could add one pointer to the task struct
(NULL by default, set to a memory location used to accumulate per-task
stats before we activate system wide stats counting). It could fit well
with the immediate values, which could be used to enable/disable the
statistic collection dynamically at runtime with minimal impact in the
scheduler code.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
