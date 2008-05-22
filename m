Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbYEVMZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbYEVMZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYEVMZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:25:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYEVMZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:25:18 -0400
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211458176.5693.6.camel@marge.simson.net>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:24:41 +0200
Message-Id: <1211459081.29104.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 14:09 +0200, Mike Galbraith wrote:
> On Thu, 2008-05-22 at 13:44 +0200, Peter Zijlstra wrote:
> 
> > Humm,.. how to fix this.. we'd need to somehow detect the 1:n nature of
> > its operation - I'm sure there are other scenarios that could benefit
> > from this.
> 
> Maybe simple (minded): cache waker's last non-interrupt context wakee,
> if the wakee != cached, ignore SYNC_WAKEUP unless sync was requested at
> call time?

Yeah, something like so - or perhaps like you say cache the wakee.

I picked the wake_affine() condition, because I think that is the
biggest factor in this behaviour. You could of course also disable all
of sync.



diff --git a/include/linux/sched.h b/include/linux/sched.h
index c86c5c5..856c2a8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -950,6 +950,8 @@ struct sched_entity {
 	u64			last_wakeup;
 	u64			avg_overlap;
 
+	struct sched_entity 	*waker;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 894a702..8971044 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1036,7 +1036,8 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && curr->sched_class == &fair_sched_class) {
+	if (sync && curr->sched_class == &fair_sched_class &&
+	    p->se.waker == curr->se->waker) {
 		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
 				p->se.avg_overlap < sysctl_sched_migration_cost)
 			return 1;
@@ -1210,6 +1211,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (unlikely(se == pse))
 		return;
 
+	se->waker = pse;
 	cfs_rq_of(pse)->next = pse;
 
 	/*



