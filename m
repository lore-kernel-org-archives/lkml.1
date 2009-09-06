Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZIFGdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZIFGdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 02:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZIFGdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 02:33:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:55207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754252AbZIFGdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 02:33:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX194zlU8tFh4qliwt0+ybOE7Gcq5Ib8pfdZ1xfsuNH
	fzEoRUIgSpbv3v
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Ani <asinha@zeugmasystems.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 08:32:59 +0200
Message-Id: <1252218779.6126.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 19:32 -0700, Ani wrote: 
> On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com> wrote:
> >
> > Indeed. I've tested this same test program in a single core machine and it
> > produces the expected behavior:
> >
> > rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> > 95%                              4.48%
> > 60%                              54.84%
> > 50%                              86.03%
> > 40%                              OTHER completed first
> >
> 
> Hmm. This does seem to indicate that there is some kind of
> relationship with SMP. So I wonder whether there is a way to turn this
> 'RT bandwidth accumulation' heuristic off.

No there isn't, but maybe there should be, since this isn't the first
time it's come up.  One pro argument is that pinned tasks are thoroughly
screwed when an RT hog lands on their runqueue.  On the con side, the
whole RT bandwidth restriction thing is intended (AFAIK) to allow an
admin to regain control should RT app go insane, which the default 5%
aggregate accomplishes just fine.

Dunno.  Fly or die little patchlet (toss). 

sched: allow the user to disable RT bandwidth aggregation.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8736ba1..6e6d4c7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1881,6 +1881,7 @@ static inline unsigned int get_sysctl_timer_migration(void)
 #endif
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
+extern int sysctl_sched_rt_bandwidth_aggregate;
 
 int sched_rt_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
diff --git a/kernel/sched.c b/kernel/sched.c
index c512a02..ca6a378 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -864,6 +864,12 @@ static __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
+/*
+ * aggregate bandwidth, ie allow borrowing from neighbors when
+ * bandwidth for an individual runqueue is exhausted.
+ */
+int sysctl_sched_rt_bandwidth_aggregate = 1;
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2eb4bd6..75daf88 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -495,6 +495,9 @@ static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
 
+	if (!sysctl_sched_rt_bandwidth_aggregate)
+		return 0;
+
 	if (rt_rq->rt_time > rt_rq->rt_runtime) {
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		more = do_balance_runtime(rt_rq);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cdbe8d0..0ad08e5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -368,6 +368,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_bandwidth_aggregate",
+		.data		= &sysctl_sched_rt_bandwidth_aggregate,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &sched_rt_handler,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_compat_yield",
 		.data		= &sysctl_sched_compat_yield,
 		.maxlen		= sizeof(unsigned int),


