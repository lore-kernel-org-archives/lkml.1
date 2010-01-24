Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557Ab0AXCth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0AXCth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 21:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650Ab0AXCte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 21:49:34 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:37758 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0AXCtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 21:49:33 -0500
Date: Sat, 23 Jan 2010 21:49:25 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Bisected rcu hang (kernel/sched.c): was 2.6.33rc4 RCU hang mm
 spin_lock deadlock(?) after running libvirtd - reproducible.
In-reply-to: <4B4E1461.4010806@majjas.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-id: <4B5BB535.8040200@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B49015D.9000903@majjas.com> <4B4A341B.6010800@majjas.com>
 <20100112014909.GB10869@linux.vnet.ibm.com> <4B4E1461.4010806@majjas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5)
 Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 01:43 PM, Michael Breuer wrote:
> [Originally posted as: "Re: 2.6.33RC3 libvirtd ->sky2 & rcu oops (was 
> Sky2 oops - Driver    tries to sync DMA memory it has not allocated)"]
>
> On 1/11/2010 8:49 PM, Paul E. McKenney wrote:
>> On Sun, Jan 10, 2010 at 03:10:03PM -0500, Michael Breuer wrote:
>>> On 1/9/2010 5:21 PM, Michael Breuer wrote:
>>>> Hi,
>>>>
>>>> Attempting to move back to mainline after my recent 2.6.32 issues...
>>>> Config is make oldconfig from working 2.6.32 config. Patch for 
>>>> af_packet.c
>>>> (for skb issue found in 2.6.32) included. Attaching .config and NMI
>>>> backtraces.
>>>>
>>>> System becomes unusable after bringing up the network:
>>>>
>>>> ...
>> RCU stall warnings are usually due to an infinite loop somewhere in the
>> kernel.  If you are running !CONFIG_PREEMPT, then any infinite loop not
>> containing some call to schedule will get you a stall warning.  If you
>> are running CONFIG_PREEMPT, then the infinite loop is in some section of
>> code with preemption disabled (or irqs disabled).
>>
>> The stall-warning dump will normally finger one or more of the CPUs.
>> Since you are getting repeated warnings, look at the stacks and see
>> which of the most-recently-called functions stays the same in successive
>> stack traces.  This information should help you finger the infinite (or
>> longer than average) loop.
>> ...
> I can now recreate this simply by "service start libvirtd" on an F12 
> box. My earlier report that suggested this had something to do with 
> the sky2 driver was incorrect. Interestingly, it's always CPU1 
> whenever I start libvirtd.
> Attaching two of the traces (I've got about ten, but they're all 
> pretty much the same). Looks pretty consistent - libvirtd in CPU1 is 
> hung forking. Not sure why yet - perhaps someone who knows this better 
> than I can jump in.
> Summary of hang appears to be libvirtd forks - two threads show with 
> same pid deadlocked on a spin_lock
>> Then if looking at the stack traces doesn't locate the offending loop,
>> bisection might help.
> It would, however it's going to be really difficult as I wasn't able 
> to get this far with rc1 & rc2 :(
>>                             Thanx, Paul
>
I was finally able to bisect this to commit: 
3802290628348674985d14914f9bfee7b9084548 (see below)

Libvirtd always triggers the crash; other things that fork and use mmap 
sometimes do (vsftpd, for example).

Author: Peter Zijlstra <a.p.zijlstra@chello.nl>  2009-12-16 12:04:37
Committer: Ingo Molnar <mingo@elte.hu>  2009-12-16 13:01:56
Parent: e2912009fb7b715728311b0d8fe327a1432b3f79 (sched: Ensure 
set_task_cpu() is never called on blocked tasks)
Branches: remotes/origin/master
Follows: v2.6.32
Precedes: v2.6.33-rc2

     sched: Fix sched_exec() balancing

     Since we access ->cpus_allowed without holding rq->lock we need
     a retry loop to validate the result, this comes for near free
     when we merge sched_migrate_task() into sched_exec() since that
     already does the needed check.

     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     Cc: Mike Galbraith <efault@gmx.de>
     LKML-Reference: <20091216170517.884743662@chello.nl>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>

-------------------------------- kernel/sched.c 
--------------------------------
index 33d7965..63e55ac 100644
@@ -2322,7 +2322,7 @@ void task_oncpu_function_call(struct task_struct *p,
   *
   *  - fork, @p is stable because it isn't on the tasklist yet
   *
- *  - exec, @p is unstable XXX
+ *  - exec, @p is unstable, retry loop
   *
   *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
   *             we should be good.
@@ -3132,21 +3132,36 @@ static void double_rq_unlock(struct rq *rq1, 
struct rq *rq2)
  }

  /*
- * If dest_cpu is allowed for this process, migrate the task to it.
- * This is accomplished by forcing the cpu_allowed mask to only
- * allow dest_cpu, which will force the cpu onto dest_cpu. Then
- * the cpu_allowed mask is restored.
+ * sched_exec - execve() is a valuable balancing opportunity, because at
+ * this point the task has the smallest effective memory and cache 
footprint.
   */
-static void sched_migrate_task(struct task_struct *p, int dest_cpu)
+void sched_exec(void)
  {
+    struct task_struct *p = current;
      struct migration_req req;
+    int dest_cpu, this_cpu;
      unsigned long flags;
      struct rq *rq;

+again:
+    this_cpu = get_cpu();
+    dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+    if (dest_cpu == this_cpu) {
+        put_cpu();
+        return;
+    }
+
      rq = task_rq_lock(p, &flags);
+    put_cpu();
+
+    /*
+     * select_task_rq() can race against ->cpus_allowed
+     */
      if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-        || unlikely(!cpu_active(dest_cpu)))
-        goto out;
+        || unlikely(!cpu_active(dest_cpu))) {
+        task_rq_unlock(rq, &flags);
+        goto again;
+    }

      /* force the process onto the specified CPU */
      if (migrate_task(p, dest_cpu, &req)) {
@@ -3161,24 +3176,10 @@ static void sched_migrate_task(struct 
task_struct *p, int dest_cpu)

          return;
      }
-out:
      task_rq_unlock(rq, &flags);
  }

  /*
- * sched_exec - execve() is a valuable balancing opportunity, because at
- * this point the task has the smallest effective memory and cache 
footprint.
- */
-void sched_exec(void)
-{
-    int new_cpu, this_cpu = get_cpu();
-    new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
-    put_cpu();
-    if (new_cpu != this_cpu)
-        sched_migrate_task(current, new_cpu);
-}
-
-/*
   * pull_task - move a task from a remote runqueue to the local runqueue.
   * Both runqueues must be locked.
   */


