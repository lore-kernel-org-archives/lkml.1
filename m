Return-Path: <linux-kernel-owner+w=401wt.eu-S934725AbYEWHR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725AbYEWHR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYEWHRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:17:49 -0400
Received: from westnet.com ([216.187.52.2]:39359 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYEWHRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:17:48 -0400
Date: Fri, 23 May 2008 03:13:32 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
In-Reply-To: <1211459081.29104.40.camel@twins>
Message-ID: <Pine.GSO.4.64.0805230232190.28654@westnet.com>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com> 
 <1211440207.5733.8.camel@marge.simson.net>  <20080522082814.GA4499@linux.vnet.ibm.com>
  <1211447105.4823.7.camel@marge.simson.net>  <1211452465.7606.8.camel@marge.simson.net>
  <1211455553.4381.9.camel@marge.simson.net>  <1211456659.29104.20.camel@twins>
  <1211458176.5693.6.camel@marge.simson.net> <1211459081.29104.40.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Peter Zijlstra wrote:

> I picked the wake_affine() condition, because I think that is the
> biggest factor in this behaviour.

I tested out Peter's patch (updated version against -rc3 with a typo fix 
from Mike below) and it's a big step in the right direction.  Here are 
updated results from my benchmark script, adding 2.6.26-rc3 and that rev 
with this patch applied:

Clients	2.6.22	2.6.24	2.6.25	-rc3	patch
1	11052	10526	10700	10193	10439
2	16352	14447	10370	9817	13289
3	15414	17784	9403	9428	13678
4	14290	16832	8882	9533	13033
5	14211	16356	8527	9558	12790
6	13291	16763	9473	9367	12660
8	12374	15343	9093	9159	12357
10	11218	10732	9057	8711	11839
15	11116	7460	7113	7620	11267
20	11412	7171	7017	7707	10531
30	11191	7049	6896	7195	9766
40	11062	7001	6820	7079	9668
50	11255	6915	6797	7202	9588

Exact versions I tested because I think it may start mattering now: 
2.6.22.19, 2.6.24.3, 2.6.25.  I didn't save 2.6.23 results but recall them 
being similar to 2.6.24.

On this dual-core system, without this patch there's an average of a a 33% 
regression in -rc3 compared to 2.6.22.  With it that's dropped to 8%; some 
cases (around 10 clients) even improve a touch (it's enough within the 
margin of error here I wouldn't conclude too much from that).  The big 
jump in high client count cases is the first I've seen that since CFS was 
introduced.  It seems a bit odd to me that there's still such a large 
regression in the 2-8 client cases compared with not only 2.6.22 but 
2.6.24, which owned this benchmark in that area.

With this feedback, any ideas on where to go next?  There seems like's 
some room for improvement still left here.


diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5395a61..e160f71 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -965,6 +965,8 @@ struct sched_entity {
         u64                     last_wakeup;
         u64                     avg_overlap;

+       struct sched_entity     *waker;
+
  #ifdef CONFIG_SCHEDSTATS
         u64                     wait_start;
         u64                     wait_max;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e24ecd3..9db3cb4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1066,7 +1066,8 @@ wake_affine(struct rq *rq, struct sched_domain 
*this_sd, struct rq *this_rq,
          * a reasonable amount of time then attract this newly
          * woken task:
          */
-       if (sync && curr->sched_class == &fair_sched_class) {
+       if (sync && curr->sched_class == &fair_sched_class &&
+           p->se.waker == curr->se.waker) {
                 if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
                                 p->se.avg_overlap < 
sysctl_sched_migration_cost)
                         return 1;
@@ -1238,6 +1239,7 @@ static void check_preempt_wakeup(struct rq *rq, 
struct task_struct *p)
         if (unlikely(se == pse))
                 return;

+       se->waker = pse;
         cfs_rq_of(pse)->next = pse;

         /*

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
