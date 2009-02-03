Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZBCAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZBCAF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZBCAFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:05:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZBCAFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:05:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:content-transfer-encoding:in-reply-to:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=rjGK/YebfDzHI6XMoY35y/2QqE8RpVpdgQJ1dGQAwU/hDbH0Vg/waDaQj4Znsa2Wa
	+u8NdLKMv/d3l5xeQisxA==
Date: Mon, 2 Feb 2009 16:05:05 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2 v2] softlockup: check all tasks in hung_task
Message-ID: <20090203000505.GA10316@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1233429757.4787.40.camel@laptop>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 11:22 AM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> On Fri, 2009-01-30 at 12:49 -0800, Mandeep Singh Baines wrote:

<snip>

>> +static void check_hung_rcu_refresh(struct task_struct *g, struct task_s=
truct *t)
>> +{
>> +     get_task_struct(g);
>> +     get_task_struct(t);
>> +     rcu_read_unlock();
>> +     if (need_resched())
>> +             schedule();
>
> won't a simple cond_resched(), do?
>

Yes, it will. Thanks Peter!

>> +     rcu_read_lock();
>> +     put_task_struct(t);
>> +     put_task_struct(g);
>> +}
>> +
>>  /*
>>   * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
>>   * a really long time (120 seconds). If that happens, print out
>> @@ -129,8 +148,13 @@ static void check_hung_uninterruptible_tasks(unsign=
ed long timeout)
>>
>>       rcu_read_lock();
>>       do_each_thread(g, t) {
>> -             if (!--max_count)
>> -                     goto unlock;
>> +             if (sysctl_hung_task_check_count && !(max_count--)) {
>> +                     max_count =3D sysctl_hung_task_check_count;
>> +                     check_hung_rcu_refresh(g, t);
>> +                     /* Exit if t or g was unhashed during refresh. */
>> +                     if (t->state =3D=3D TASK_DEAD || g->state =3D=3D T=
ASK_DEAD)
>> +                             goto unlock;
>> +             }
>
> Its all a bit ugly, but I suppose there's no way around that.

Yeah, need to guarantee that next of t and g isn't pointing to a freed
task_struct. If the t or g has not been unlinked, then its guaranteed that
the next fields are valid.

If the state is != TASK_DEAD then its guaranteed that the task hasn't been
unlinked. I guess that's the shakiest assumption in the chain. If the code were
ever changed to set the state to TASK_DEAD after unlinking ...

<snip>

Here's v2 of this patch. The only thing that's changed is the cond_resched().

---
Instead of checking only hung_task_check_count tasks, all tasks are checked.
hung_task_check_count is still used to put an upper bound on the critical
section. Every hung_task_check_count checks, the critical section is
refreshed. Keeping the critical section small minimizes time preemption is
disabled and keeps rcu grace periods small.

To prevent following a stale pointer, get_task_struct is called on g and t.
To verify that g and t have not been unhashed while outside the critical
section, the task states are checked.

The design was proposed by Frédéric Weisbecker.

Frédéric Weisbecker (fweisbec@gmail.com) wrote:
>
> Instead of having this arbitrary limit of tasks, why not just
> lurk the need_resched() and then schedule if it needs too.
>
> I know that sounds a bit racy, because you will have to release the
> tasklist_lock and
> a lot of things can happen in the task list until you become resched.
> But you can do a get_task_struct() on g and t before your thread is
> going to sleep and then put them
> when it is awaken.
> Perhaps some tasks will disappear or be appended in the list before g
> and t, but that doesn't really matter:
> if they disappear, they didn't lockup, and if they were appended, they
> are not enough cold to be analyzed :-)
>
> This way you can drop the arbitrary limit of task number given by the user....
>
> Frederic.
>

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 kernel/hung_task.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index a841db3..464c96e 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -109,6 +109,24 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
 		panic("hung_task: blocked tasks");
 }
 
+ /*
+  * To avoid extending the RCU grace period for an unbounded amount of time,
+  * periodically exit the critical section and enter a new one.
+  *
+  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
+  * exit the grace period. For classic RCU, a reschedule is required.
+  */
+static void check_hung_rcu_refresh(struct task_struct *g, struct task_struct *t)
+{
+	get_task_struct(g);
+	get_task_struct(t);
+	rcu_read_unlock();
+	cond_resched();
+	rcu_read_lock();
+	put_task_struct(t);
+	put_task_struct(g);
+}
+
 /*
  * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
  * a really long time (120 seconds). If that happens, print out
@@ -129,8 +147,13 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 	rcu_read_lock();
 	do_each_thread(g, t) {
-		if (!--max_count)
-			goto unlock;
+		if (sysctl_hung_task_check_count && !(max_count--)) {
+			max_count = sysctl_hung_task_check_count;
+			check_hung_rcu_refresh(g, t);
+			/* Exit if t or g was unhashed during refresh. */
+			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
+				goto unlock;
+		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now, timeout);
-- 
1.5.4.5

