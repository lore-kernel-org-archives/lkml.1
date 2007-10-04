Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbXJDVKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbXJDVKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbXJDVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:10:30 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:17899 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbXJDVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:10:29 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: [PATCH for testing] Re: Decreasing stime running confuses top
Date: Thu, 4 Oct 2007 23:10:25 +0200
User-Agent: KMail/1.9.7
Cc: Luca Tettamanti <kronos.it@gmail.com>, Frans Pop <elendil@planet.nl>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       Ingo Molnar <mingo@elte.hu>
References: <200710031433.34504.elendil@planet.nl> <200710042200.03489.borntraeger@de.ibm.com> <47054B2E.1050906@redhat.com>
In-Reply-To: <47054B2E.1050906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710042310.25223.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Oktober 2007 schrieb Chuck Ebbert:
> On 10/04/2007 04:00 PM, Christian Borntraeger wrote:
> > Am Donnerstag, 4. Oktober 2007 schrieb Chuck Ebbert:
> >> Is CONFIG_VIRT_CPU_ACCOUNTING set?
> > 
> > This is s390 and powerpc only, so the answer is probably no ;-)
> > 
> 
> The code in fs/proc/array.c is... interesting.

Short history what I know about this file:
after 2.6.22 the accounting was changes to use sched_clock and to use stime 
and utime only for the split. This is where task_utime and task_stime were 
introduced. See the code in 2.6.23-rc1.
Unfortunately this broke the accouting on s390 which already has precise 
numbers in utime and stime. So the code was partially reverted to use stime 
and utime again where appropriate, which are of type  cputime_t. 

> 
> 1. task_stime() converts p->se.sum_exec_runtime to a clock_t

correct.

> 
> 2. it calls task_utime() which does the same thing (can it change
>    between the two reads?), does some calculations that yield a 
>    clock_t, turns the result into a cputime and returns that
> 
> 3. task_stime() then converts that result back into a clock_t and
>    uses it!

These conversions can reduce the accuracy to jiffie resolution, but should not
make the value non-monotonic. I dont think that here is the problem. 

But: it seems that p->se.sum_exec_runtime can change indeed. That would 
explain stime going backward, if sum_exec_runtime was increases in the middle 
of the calculation. 
The logic of task_stime and task_utime was introduced by 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa


Frans can you test this patch if this makes stime and utime monotic again?

It basically reverts the rest of  b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa and 
should restore the 2.6.22 behavior. The process time is used from tasks utime 
and stime instead of the scheduler clock. That means, in general after a long 
period of time, it is less accurate than the current time and behaves like 
2.6.22.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 array.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)


diff --git a/fs/proc/array.c b/fs/proc/array.c
index ee4814d..e42c76e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -323,7 +323,6 @@ int proc_pid_status(struct task_struct *task, char 
*buffer)
 /*
  * Use precise platform statistics if available:
  */
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 static cputime_t task_utime(struct task_struct *p)
 {
 	return p->utime;
@@ -333,42 +332,6 @@ static cputime_t task_stime(struct task_struct *p)
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
