Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbYCFVpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbYCFVpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYCFVpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:45:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYCFVpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:45:32 -0500
Date: Thu, 6 Mar 2008 22:45:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jens Osterkamp <Jens.Osterkamp@gmx.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] in 2.6.25-rc3 with 64k page size and SLUB_DEBUG_ON
Message-ID: <20080306214516.GB886@elte.hu>
References: <200803061447.05797.Jens.Osterkamp@gmx.de> <84144f020803061327r2310b23ew6211bc09f9ba25a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020803061327r2310b23ew6211bc09f9ba25a3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> >  Mount-cache hash table entries: 4096
> >  BUG: scheduling while atomic: kthreadd/2/0x00056ef8
> >  Call Trace:
> >  [c00000003c187b68] [c00000000000f140] .show_stack+0x70/0x1bc (unreliable)
> >  [c00000003c187c18] [c000000000052d0c] .__schedule_bug+0x64/0x80
> >  [c00000003c187ca8] [c00000000036fa84] .schedule+0xc4/0x6b0
> >  [c00000003c187d98] [c0000000003702d0] .schedule_timeout+0x3c/0xe8
> >  [c00000003c187e68] [c00000000036f82c] .wait_for_common+0x150/0x22c
> >  [c00000003c187f28] [c000000000074868] .kthreadd+0x12c/0x1f0
> >  [c00000003c187fd8] [c000000000024864] .kernel_thread+0x4c/0x68
> >  ------------[ cut here ]------------
> >  kernel BUG at /home/auto/jens/kernels/linux-2.6.25-rc3/kernel/sched.c:4532!
> >  cpu 0x0: Vector: 700 (Program Check) at [c00000003c187bc8]
> >     pc: c000000000051f8c: .sched_setscheduler+0x5c/0x48c
> >     lr: c0000000000748b0: .kthreadd+0x174/0x1f0
> >     sp: c00000003c187e48
> >    msr: 9000000000029032
> >   current = 0xc00000007e0808a0
> >   paca    = 0xc0000000004cf880
> >     pid   = 2, comm = kthreadd
> >  kernel BUG at /home/auto/jens/kernels/linux-2.6.25-rc3/kernel/sched.c:4532!
> >  enter ? for help
> >  [c00000003c187f28] c0000000000748b0 .kthreadd+0x174/0x1f0
> >  [c00000003c187fd8] c000000000024864 .kernel_thread+0x4c/0x68
> >  0:mon>
> >
> >  In the code this corresponds to
> >
> >  int sched_setscheduler(struct task_struct *p, int policy,
> >                        struct sched_param *param)
> >  {
> >         int retval, oldprio, oldpolicy = -1, on_rq, running;
> >         unsigned long flags;
> >         const struct sched_class *prev_class = p->sched_class;
> >         struct rq *rq;
> >
> >         /* may grab non-irq protected spin_locks */
> >         BUG_ON(in_interrupt());
> >  recheck:
> >         /* double check policy once rq lock held */
> >         if (policy < 0)
> >                 policy = oldpolicy = p->policy;
> >         else if (policy != SCHED_FIFO && policy != SCHED_RR &&
> >                         policy != SCHED_NORMAL && policy != SCHED_BATCH &&
> >                         policy != SCHED_IDLE)
> >                 return -EINVAL;
> >
> >  With slub_debug=- on the kernel command line, the problem is gone.
> >  With 4k page size the problem also does not occur.
> >
> >  Any ideas on why this occurs and how to debug this further ?
> 
> There's no SLUB in the stack traces. Ingo, any suggestions how to debug this?

hm, no idea - is this powerpc? It seems to have hit a atomicity check 
due to:

> >  BUG: scheduling while atomic: kthreadd/2/0x00056ef8

preempt-count 0x00056ef8 is totally out of whack. Serious memory 
corruption.

	Ingo
