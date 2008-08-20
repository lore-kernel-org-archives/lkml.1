Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYHTJUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYHTJUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYHTJTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:19:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42304 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYHTJTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:19:52 -0400
Date: Wed, 20 Aug 2008 11:19:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Donald <gdonald@gmail.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: INFO: task reiserfs/0:1322 blocked for more than 120 seconds
Message-ID: <20080820091918.GB23865@elte.hu>
References: <15e66e4e0808162136r2a439ee9wbb20f2b1f8fabc77@mail.gmail.com> <20080819235258.fa775505.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819235258.fa775505.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 16 Aug 2008 23:36:03 -0500 "Greg Donald" <gdonald@gmail.com> wrote:
> 
> > I got this while rsync'ng an NFS share onto a local disk:
> > 
> > [42374.151062] INFO: task reiserfs/0:1322 blocked for more than 120 seconds.
> > [42374.186295] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [42374.229433] reiserfs/0    D c1f36180     0  1322      2
> > [42374.265246]        f5dbdedc 00000046 c1f36180 c1f36180 f5e932c0
> > 1c823428 00002669 f5e932c0
> > [42374.273706]        f5e93514 c1f36180 00000000 f5dbc000 f62cc780
> > f5e932c0 00000002 00000001
> > [42374.313709]        00000000 00000000 f5e932c0 c013cc01 00000246
> > f5dbded4 c013cbce e31e12ec
> > [42374.356837] Call Trace:
> > [42374.417842]  [<c013cc01>] ? trace_hardirqs_on+0xb/0xd
> > [42374.451201]  [<c013cbce>] ? trace_hardirqs_on_caller+0xe9/0x111
> > [42374.489735]  [<c02e876b>] mutex_lock_nested+0x14b/0x22b
> > [42374.525760]  [<c01c9727>] ? flush_commit_list+0x119/0x505
> > [42374.560839]  [<c01c9727>] flush_commit_list+0x119/0x505
> > [42374.594183]  [<c01cca8e>] flush_async_commits+0x41/0x4b
> > [42374.629770]  [<c012ec1a>] run_workqueue+0xc3/0x18e
> > [42374.662893]  [<c012ebfe>] ? run_workqueue+0xa7/0x18e
> > [42374.697814]  [<c01cca4d>] ? flush_async_commits+0x0/0x4b
> > [42374.732504]  [<c012f609>] ? worker_thread+0x0/0x8a
> > [42374.765765]  [<c012f688>] worker_thread+0x7f/0x8a
> > [42374.797749]  [<c0131d61>] ? autoremove_wake_function+0x0/0x38
> > [42374.833713]  [<c0131c93>] kthread+0x40/0x69
> > [42374.865772]  [<c0131c53>] ? kthread+0x0/0x69
> > [42374.897774]  [<c010392f>] kernel_thread_helper+0x7/0x10
> > [42374.929777]  =======================
> > [42374.957001] 3 locks held by reiserfs/0/1322:
> > [42374.990140]  #0:  (reiserfs){--..}, at: [<c012ebe1>] run_workqueue+0x8a/0x18e
> > [42375.025754]  #1:  (&(&journal->j_work)->work){--..}, at:
> > [<c012ebfe>] run_workqueue+0xa7/0x18e
> > [42375.062963]  #2:  (&jl->j_commit_mutex){--..}, at: [<c01c9727>]
> > flush_commit_list+0x119/0x505
> > 
> > 
> > I deleted a few GBs of data and ran it again but was unable to
> > reproduce it.  This was on 2.6.27-rc3.
> > 
> > I don't see any corruption.  Fluke?
> > 
> 
> Seems that about 100% of the reports we get of this warning triggering 
> are sys_sync, transaction commit, etc.
> 
> Does kerneloops.org disagree with me?
> 
> If not, I vote we kill it.

ok. How about quadrupling the timeout, as per the patch below?

more than 8 minutes uninterruptible wait, is that a reasonable limit?

I had this warning trigger a couple of times during development, 
alerting me to hung tasks.

	Ingo

------------------>
>From 3fb4198766c38aa03492cc3996475076073c22ea Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 20 Aug 2008 11:17:40 +0200
Subject: [PATCH] softlockup: increase hung tasks check from 2 minutes to 8 minutes

Andrew says:

> Seems that about 100% of the reports we get of this warning triggering
> are sys_sync, transaction commit, etc.

increase the timeout. If it still triggers for people, we can kill it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index b75b492..17a0580 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -164,7 +164,7 @@ unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
 /*
  * Zero means infinite timeout - no checking done:
  */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = 480;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
