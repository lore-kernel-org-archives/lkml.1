Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYLPMYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYLPMYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLPMYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:24:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYLPMYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:24:13 -0500
Date: Tue, 16 Dec 2008 13:23:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
Message-ID: <20081216122350.GB25019@elte.hu>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu> <4944754F.8050503@cn.fujitsu.com> <49476049.7000403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49476049.7000403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Li Zefan wrote:
> >> i merged it up in tip/master, could you please check whether it's ok?
> >>
> > 
> > Sorry, though this patch avoids accessing a half-created cgroup, but I found
> > current code may access a cgroup which has been destroyed.
> > 
> > The simplest fix is to take cgroup_lock() before for_each_leaf_cfs_rq.
> > 
> > Could you revert this patch and apply the following new one? My box has
> > survived for 16 hours with it applied.
> > 
> 
> Hi, Ingo
> 
> Can we have this bug fixed for 2.6.28 using this patch ? This patch is 
> the simplest fix and has been fully tested.

the mutex used by cgroup_lock() is pretty crappy to nest inside the 
runqueue lock:

 BUG: sleeping function called from invalid context at kernel/mutex7
 in_atomic(): 0, irqs_disabled(): 1, pid: 1790, name: cat
 2 locks held by cat/1790:
  #0:  (&p->lock){--..}, at: [<c02a6328>] seq_read+0x25/0x2b8
  #1:  (tasklist_lock){..--}, at: [<c021f5bc>] 
sched_debug_show+0xaa7/0xe90
 Call Trace:
  [<c0222612>] __might_sleep+0xd6/0xdd
  [<c05ff1eb>] mutex_lock_nested+0x1d/0x245
  [<c021f88b>] ? sched_debug_show+0xd76/0xe90
  [<c0256223>] cgroup_lock+0xf/0x11
  [<c021f893>] sched_debug_show+0xd7e/0xe90
  [<c0248696>] ? __lock_acquire+0x637/0x69d
  [<c028e7cd>] ? check_object+0x111/0x18c
  [<c028f435>] ? kmem_cache_alloc+0x70/0xa5
  [<c02a6355>] ? seq_read+0x52/0x2b8
  [<c0246ee2>] ? trace_hardirqs_on_caller+0x105/0x13d
  [<c0246f25>] ? trace_hardirqs_on+0xb/0xd
  [<c02a6355>] ? seq_read+0x52/0x2b8
  [<c02a63f7>] seq_read+0xf4/0x2b8
  [<c02a6303>] ? seq_read+0x0/0x2b8
  [<c02c411a>] proc_reg_read+0x60/0x74

so i had to remove your patch.

also, while looking at what cgroup_lock does - it's a trivial wrapper:

 void cgroup_lock(void)
 {
         mutex_lock(&cgroup_mutex);
 }

why isnt that done explicitly in all usage sites? If cgroup-unaware code 
ever has to take the cgroup lock outside of CONFIG_CGROUPS, that's a code 
structure problem.

	Ingo
