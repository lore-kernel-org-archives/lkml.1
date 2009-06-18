Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZFRKO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZFRKO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZFRKOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:14:51 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55433 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbZFRKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:14:50 -0400
Date: Thu, 18 Jun 2009 19:14:48 +0900 (JST)
Message-Id: <20090618.191448.886429908004553840.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at
 source code level
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20090617163111.GA16128@elte.hu>
References: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
	<tip-d11ad9b3631b942b0d2e5b754a6c62158efb799f@git.kernel.org>
	<20090617163111.GA16128@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
Date: Wed, 17 Jun 2009 18:31:11 +0200

> ition: inline
> Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
> From: Ingo Molnar <mingo@elte.hu>
> To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
> 	mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de
> Cc: linux-tip-commits@vger.kernel.org
> Date: Wed, 17 Jun 2009 18:31:11 +0200
> User-Agent: Mutt/1.5.18 (2008-05-17)
> Received-SPF: neutral (mx2.mail.elte.hu: 157.181.1.14 is neither permitted nor denied by domain of elte.hu) client-ip=157.181.1.14; envelope-from=mingo@elte.hu; helo=elvis.elte.hu;
> X-Mew: tab/spc characters on Subject: are simplified.
> 
> 
> * tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -6630,7 +6630,7 @@ EXPORT_SYMBOL(yield);
> >   */
> >  void __sched io_schedule(void)
> >  {
> > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > +	struct rq *rq = this_rq();
> >  
> >  	delayacct_blkio_start();
> >  	atomic_inc(&rq->nr_iowait);
> > @@ -6642,7 +6642,7 @@ EXPORT_SYMBOL(io_schedule);
> >  
> >  long __sched io_schedule_timeout(long timeout)
> >  {
> > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > +	struct rq *rq = this_rq();
> >  	long ret;
> 
> I removed these two changes. Did you notice the __raw prefix?
> 
> 	Ingo
> 

Thanks for your fix, I didn't notice...
I wrote a patch to fix these two points.

After applying this patch,
all direct reference to runqueues is in macros. How is this?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

diff --git a/kernel/sched.c b/kernel/sched.c
index 8ec9d13..e2ca8c1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -692,6 +692,7 @@ static inline int cpu_of(struct rq *rq)
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -6625,7 +6626,7 @@ EXPORT_SYMBOL(yield);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
@@ -6637,7 +6638,7 @@ EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 	long ret;
 
 	delayacct_blkio_start();
