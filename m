Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbXJPIa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbXJPIa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXJPIaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:30:10 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:36091 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXJPIaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:30:06 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Tue, 16 Oct 2007 10:29:27 +0200
User-Agent: KMail/1.9.7
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <200710130953.22099.elendil@planet.nl> <200710142236.10768.borntraeger@de.ibm.com>
In-Reply-To: <200710142236.10768.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710161029.27132.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck, Balbir,

we still have a problem with stime occosionally going backwards. I stated
below that I think this is not fixable with the current utime/stime split
algorithm.

Balbir, you wrote this code, Chuck you tried to fix it. Any ideas how to
fix this properly? The only idea I have requires that we save the old value
of utime and stime and therefore requires additional locking.

Otherwise I suggest to apply my reversion patch from below:

Am Sonntag, 14. Oktober 2007 schrieb Christian Borntraeger:
> Am Samstag, 13. Oktober 2007 schrieb Frans Pop:
> > > > Please consider this patch for 2.6.23.2
> > > > http://lkml.org/lkml/2007/10/4/389
> > > Is it already in Linus's tree?  If so, do you have a git commit id?  If
> > > not, please let us (stable@) know when it is, and what the id is, and
> > > then we can add it to our tree.
> > 
> > Not AFAICT.
> > CCing Christian (as patch author) and Ingo (as author of the change that 
> > caused the regression) so they can push it through the correct channels.
> > 
> 
> I dont know how to proceed with this issue. The more I think about it, the
> more I am convinced that using sum_exec_runtime together with sampled utime
> and stime will never guarantee monotonicity for utime and stime in proc. 
> Just imagine an process with 9 ticks for utime and 0 ticks for stime. If
> we now sample one tick for stime (but having only a small increase in
> sum_exec_runtime) the next utime value will only be 90% of the last value. 
> So returning to the 2.6.22 model seems to be the safest solution until 
> somebody else comes up with an idea that works proper.
> 
> Ingo, any opinion?

--------- patch-----------

Fix stime going backwards

after 2.6.22 the accounting was changes to use sched_clock and to use stime 
and utime only for the split. This is where task_utime and task_stime were 
introduced. See the code in 2.6.23-rc1.
Unfortunately this broke the accouting on s390 which already has precise 
numbers in utime and stime. So the code was partially reverted to use stime 
and utime again where appropriate, which are of type  cputime_t. 

It now seems, that the rest of the logic is still broken.

This patch basically reverts the rest of b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa
and  should restore the 2.6.22 behavior. The process time is used from tasks
utime  and stime instead of the scheduler clock. That means, in general after
a long period of time, it is less accurate than the sum_exec_runtime based 
code, but it doesnt break top.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 fs/proc/array.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -323,7 +323,6 @@ int proc_pid_status(struct task_struct *
 /*
  * Use precise platform statistics if available:
  */
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 static cputime_t task_utime(struct task_struct *p)
 {
 	return p->utime;
@@ -333,42 +332,6 @@ static cputime_t task_stime(struct task_
 {
 	return p->stime;
 }
-#else
-static cputime_t task_utime(struct task_struct *p)
-{
-	clock_t utime = cputime_to_clock_t(p->utime),
-		total = utime + cputime_to_clock_t(p->stime);
-	u64 temp;
-
-	/*
-	 * Use CFS's precise accounting:
-	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
-
-	if (total) {
-		temp *= utime;
-		do_div(temp, total);
-	}
-	utime = (clock_t)temp;
-
-	return clock_t_to_cputime(utime);
-}
-
-static cputime_t task_stime(struct task_struct *p)
-{
-	clock_t stime;
-
-	/*
-	 * Use CFS's precise accounting. (we subtract utime from
-	 * the total, to make sure the total observed by userspace
-	 * grows monotonically - apps rely on that):
-	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
-
-	return clock_t_to_cputime(stime);
-}
-#endif
 
 static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 {
