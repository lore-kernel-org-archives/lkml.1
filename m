Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050Ab0A0VXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0A0VXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034Ab0A0VXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:23:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab0A0VXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:23:07 -0500
Date: Wed, 27 Jan 2010 13:22:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: cpuacct: Use bigger percpu counter 
 batch values for stats counters
Message-Id: <20100127132212.cd43cd94.akpm@linux-foundation.org>
In-Reply-To: <661de9471001270534ve6f7bf0nb58ef58f9a6ff10e@mail.gmail.com>
References: <20100118044142.GS12666@kryten>
	<tip-43f85eab1411905afe5db510fbf9841b516e7e6a@git.kernel.org>
	<661de9471001270534ve6f7bf0nb58ef58f9a6ff10e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 19:04:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Wed, Jan 27, 2010 at 6:45 PM, tip-bot for Anton Blanchard
> <anton@samba.org> wrote:
> > Commit-ID: __43f85eb1411905afe5db510fbf9841b516e7e6a
> > Gitweb: __ __ http://git.kernel.org/tip/43f85eab1411905afe5db510fbf9841b516e7e6a
> > Author: __ __ Anton Blanchard <anton@samba.org>
> > AuthorDate: Mon, 18 Jan 2010 15:41:42 +1100
> > Committer: __Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 27 Jan 2010 08:34:38 +0100
> >
> > sched: cpuacct: Use bigger percpu counter batch values for stats counters
> >
> > When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we
> > can call cpuacct_update_stats with values much larger than
> > percpu_counter_batch. This means the call to percpu_counter_add will
> > always add to the global count which is protected by a spinlock and we
> > end up with a global spinlock in the scheduler.
> >
> > Based on an idea by KOSAKI Motohiro, this patch scales the batch value by
> > cputime_one_jiffy such that we have the same batch limit as we would if
> > CONFIG_VIRT_CPU_ACCOUNTING was disabled. His patch did this once at boot
> > but that initialisation happened too early on PowerPC (before time_init)
> > and it was never updated at runtime as a result of a hotplug cpu
> > add/remove.
> >
> > This patch instead scales percpu_counter_batch by cputime_one_jiffy at
> > runtime, which keeps the batch correct even after cpu hotplug operations.
> > We cap it at INT_MAX in case of overflow.
> >
> > For architectures that do not support CONFIG_VIRT_CPU_ACCOUNTING,
> > cputime_one_jiffy is the constant 1 and gcc is smart enough to optimise
> > min(s32 percpu_counter_batch, INT_MAX) to just percpu_counter_batch at
> > least on x86 and PowerPC. So there is no need to add an #ifdef.
> >
> > On a 64 thread PowerPC box with CONFIG_VIRT_CPU_ACCOUNTING and
> > CONFIG_CGROUP_CPUACCT enabled, a context switch microbenchmark is 234x
> > faster and almost matches a CONFIG_CGROUP_CPUACCT disabled kernel:
> >
> > CONFIG_CGROUP_CPUACCT disabled: __ __ __ __ 16906698 ctx switches/sec
> > CONFIG_CGROUP_CPUACCT enabled: __ __ __ __ __ __ 61720 ctx switches/sec
> > CONFIG_CGROUP_CPUACCT + patch: __ __ __ __ __16663217 ctx switches/sec
> >
> > Tested with:
> >
> > __wget http://ozlabs.org/~anton/junkcode/context_switch.c
> > __make context_switch
> > __for i in `seq 0 63`; do taskset -c $i ./context_switch & done
> > __vmstat 1
> >
> > Signed-off-by: Anton Blanchard <anton@samba.org>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <20100118044142.GS12666@kryten>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> > __kernel/sched.c | __ __4 +++-
> > __1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 3a8fb30..8f94138 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -10906,6 +10906,7 @@ static void cpuacct_update_stats(struct task_struct *tsk,
> > __ __ __ __ __ __ __ __enum cpuacct_stat_index idx, cputime_t val)
> > __{
> > __ __ __ __struct cpuacct *ca;
> > + __ __ __ int batch;
> >
> > __ __ __ __if (unlikely(!cpuacct_subsys.active))
> > __ __ __ __ __ __ __ __return;
> > @@ -10913,8 +10914,9 @@ static void cpuacct_update_stats(struct task_struct *tsk,
> > __ __ __ __rcu_read_lock();
> > __ __ __ __ca = task_ca(tsk);
> >
> > + __ __ __ batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
> > __ __ __ __do {
> > - __ __ __ __ __ __ __ percpu_counter_add(&ca->cpustat[idx], val);
> > + __ __ __ __ __ __ __ __percpu_counter_add(&ca->cpustat[idx], val, batch);
> > __ __ __ __ __ __ __ __ca = ca->parent;
> > __ __ __ __} while (ca);
> > __ __ __ __rcu_read_unlock();

^^ your email client inexplicably fills emails with 0xa0

> IIRC, Andrew picked up this patch as well and applied some checkpatch
> fixes too..

No, I have no changes.

Last I heard, Anton was "working on a useful comment" and will be
redoing the patch.

