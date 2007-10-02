Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXJBTtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXJBTtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXJBTtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:49:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:16023 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXJBTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MKjV6RHaq/REhT1aBz6Rmiilf5yE02NOXmcF0cff+bWXIMZDByAY8RScGp2U+jT9+5K3S/Iiqh/285YX1O0nqQbXfa7THXiOmOkJ5j2aVME1THvV87t84H+mtA5zvbWbclwnPgxWeP7Wwf6Qti60ZuZGWx2iqdviEljstil17wY=
Subject: Re: [git] CFS-devel, latest code
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 02 Oct 2007 21:49:16 +0200
Message-Id: <1191354556.5664.7.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/10/2007, Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> 
> > here is a few patches on top of the recent 'sched-dev':
> >
> > (1) [ proposal ] make timeslices of SCHED_RR tasks constant and not
> > dependent on task's static_prio;
> >
> > (2) [ cleanup ] calc_weighted() is obsolete, remove it;
> >
> > (3) [ refactoring ] make dequeue_entity() / enqueue_entity()
> > and update_stats_dequeue() / update_stats_enqueue() look similar, structure-wise.
> 
> thanks - i've applied all 3 patches of yours.
> 
> > (compiles well, not functionally tested yet)
> 
> (it boots fine here and SCHED_RR seems to work - but i've not tested
> getinterval.)

/me is guilty... it was a bit broken :-/ here is the fix.

results:

(SCHED_FIFO)

dimm@earth:~/storage/prog$ sudo chrt -f 10 ./rr_interval 
time_slice: 0 : 0

(SCHED_RR)

dimm@earth:~/storage/prog$ sudo chrt 10 ./rr_interval 
time_slice: 0 : 99984800

(SCHED_NORMAL)

dimm@earth:~/storage/prog$ ./rr_interval 
time_slice: 0 : 19996960

(SCHED_NORMAL + a cpu_hog of similar 'weight' on the same CPU --- so should be a half of the previous result)

dimm@earth:~/storage/prog$ taskset 1 ./rr_interval 
time_slice: 0 : 9998480


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched.c b/kernel/sched.c
index d835cd2..cce22ff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4745,11 +4745,12 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 	else if (p->policy == SCHED_RR)
 		time_slice = DEF_TIMESLICE;
 	else {
+		struct sched_entity *se = &p->se;
 		unsigned long flags;
 		struct rq *rq;
 
 		rq = task_rq_lock(p, &flags);
-		time_slice = sched_slice(&rq->cfs, &p->se);
+		time_slice = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 		task_rq_unlock(rq, &flags);
 	}
 	read_unlock(&tasklist_lock);

---



