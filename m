Return-Path: <linux-kernel-owner+w=401wt.eu-S2993083AbXCIJHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993083AbXCIJHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXCIJHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:07:14 -0500
Received: from depni.sinp.msu.ru ([213.131.7.21]:42977 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXCIJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:07:10 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
References: <20070309053931.GA10459@waste.org>
	<200703091728.03978.kernel@kolivas.org>
	<20070309075358.GA10394@waste.org>
	<200703091936.47128.kernel@kolivas.org>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Fri, 09 Mar 2007 12:07:06 +0300
In-Reply-To: <200703091936.47128.kernel@kolivas.org> (Con Kolivas's message of "Fri\, 9 Mar 2007 19\:36\:46 +1100")
Message-ID: <87slce945h.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas <kernel@kolivas.org> writes:

> On Friday 09 March 2007 18:53, Matt Mackall wrote:
...
>>
>> With a single non-parallel make running (all in cache, mind you), the
>> system kicks up into just about 100% CPU usage at full speed. Desktop
>> spinning becomes between 10x to 100x slower (from ~30fps to < 1fps).
>> Galeon scrolling pauses for as much as a second. Mouse movement pauses
>> for as much as a second. Typing in terminals lags noticeably.
>>
>> This is not the expected behavior of a fair, low-latency scheduler.
>
> No indeed it does not sound right at all to me either. Last time I encountered 
> something like this we traced it and hit sched_yield calls somewhere in the 
> graphic pipeline. So first question is, how does mainline perform with the 
> same testcase, and second question is umm whatever it is that is slow is 
> there a way to trace it to see if it yields?

Matt, some 3d drivers are known to do sched_yield() behind user's back,

(notably dri radeon ones, grep for sched_yield:
http://webcvs.freedesktop.org/mesa/Mesa/src/mesa/drivers/dri/r200/r200_ioctl.c?revision=1.37&view=markup
http://webcvs.freedesktop.org/mesa/Mesa/src/mesa/drivers/dri/r300/radeon_ioctl.c?revision=1.14&view=markup)

thus absolutely killing any desktop interactivity whatsoever.

If you see sched_yield() when stracing any 3d program, I suggest you
to try this bruteforce workaround, which works fine for me,
disable sched_yield():


 kernel/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4285,7 +4285,7 @@ asmlinkage long sys_sched_getaffinity(pi
  * This function yields the current CPU by dropping the priority of current
  * to the lowest priority.
  */
-asmlinkage long sys_sched_yield(void)
+static long sys_sched_yield1(void)
 {
 	struct rq *rq = this_rq_lock();
 	struct task_struct *p = current;
@@ -4312,6 +4312,11 @@ asmlinkage long sys_sched_yield(void)
 	return 0;
 }
 
+asmlinkage long sys_sched_yield(void)
+{
+	return 0;
+}
+
 static void __cond_resched(void)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
@@ -4395,7 +4400,7 @@ EXPORT_SYMBOL(cond_resched_softirq);
 void __sched yield(void)
 {
 	set_current_state(TASK_RUNNING);
-	sys_sched_yield();
+	sys_sched_yield1();
 }
 EXPORT_SYMBOL(yield);
 
