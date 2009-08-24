Return-Path: <linux-kernel-owner+w=401wt.eu-S1751617AbZHXGAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbZHXGAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZHXGAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:00:06 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49940 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZHXGAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:00:06 -0400
Message-ID: <4A922BF6.4010607@ct.jp.nec.com>
Date: Mon, 24 Aug 2009 14:58:14 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] fix race copy_process() vs de_thread()
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824141141.0893a2c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090824141141.0893a2c0.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 24 Aug 2009 13:01:40 +0900
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
>  
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  kernel/fork.c |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 3ffa10f..be6c5b5 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -882,6 +882,9 @@ static void cleanup_signal(struct task_struct *tsk)
>>  {
>>  	struct signal_struct *sig = tsk->signal;
>>  
>> +	if (!sig)
>> +		return;
>> +
>>  	atomic_dec(&sig->live);
>>  
>>  	if (atomic_dec_and_test(&sig->count))
>> @@ -1230,6 +1233,15 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>   	 */
>>  	recalc_sigpending();
>>  	if (signal_pending(current)) {
>> +		/* If there is any task waiting for the group exit, notify it */
>> +		if ((clone_flags & CLONE_THREAD) &&
>> +		    p->signal->group_exit_task) {
>> +			atomic_dec(&p->signal->live);
>> +			atomic_dec(&p->signal->count);
>> +			if (atomic_read(&p->signal->count) == p->signal->notify_count)
>> +				wake_up_process(p->signal->group_exit_task);
>> +			p->signal = NULL;
>> +		}
>>  		spin_unlock(&current->sighand->siglock);
>>  		write_unlock_irq(&tasklist_lock);
>>  		retval = -ERESTARTNOINTR;
> 
> I'm not sure whehter I catch the issue correctly but, shouldn't we encapsulate
> this check in cleanup_signal() ?

Ah, you're right. clone_process() may fail several reasons and failures after
copy_signal() will cause this issue.

> 
> like...
> 
> static void cleanup_signal(struct task_struct *tsk)
> {
>         struct signal_struct *sig = tsk->signal;
> 	sighand = rcu_dereference(tsk->sighand);
>  
>         spin_lock(&sighand->siglock);
>         if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
>  		wake_up_process(sig->group_exit_task);
> 	spin_unlock(&sighand->siglock);
> 
> 	atomic_dec(&sig->live);
> 	if (!atomic_dec_and_test(&sig->count))
> 		 __cleanup_signal(sig);
> }
> 
> 
> BTW, why sig->xxx members in "signal" struct is guarded by lock in "sighand"
> struct ??

I don't know.

Update version is below.

Thanks,
Hiroshi

========
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

There is a race between de_thread() and copy_process().
When a thread is during execve and another thread is during clone, a exec-ing
thread may be hung up in de_thread() waiting other threads are finished.
The root cause is that cleanup_signal() which is called when fork() failed
doesn't cause wake up the waiting thread at de_thread(), because there is no
check signal->count.

We need the check signal->group_exit_task and signal->notify_count.

Here is a reproducer, it may generate a thread which never die.

void *null_thread(void *p)
{
	for (;;)
		sleep(1);

	return NULL;
}

void *exec_thread(void *p)
{
	execl("/bin/true", "/bin/true", NULL);

	return null_thread(p);
}

int main(int argc, char **argv)
{
	for (;;) {
		pid_t pid;
		int ret, status;

		pid = fork();
		if (pid < 0)
			break;

		if (!pid) {
			pthread_t tid;

			pthread_create(&tid, NULL, exec_thread, NULL);
			for (;;)
				pthread_create(&tid, NULL, null_thread, NULL);
		}

		do {
			ret = waitpid(pid, &status, 0);
		} while (ret == -1 && errno == EINTR);
	}

	return 0;
}

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/fork.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3ffa10f..bc41c41 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -886,6 +886,14 @@ static void cleanup_signal(struct task_struct *tsk)
 
 	if (atomic_dec_and_test(&sig->count))
 		__cleanup_signal(sig);
+	else {
+		/* If there is any task waiting for the group exit, notify it */
+		spin_lock(&tsk->sighand->siglock);
+		if (sig->group_exit_task &&
+		    atomic_read(&sig->count) == sig->notify_count)
+			wake_up_process(sig->group_exit_task);
+		spin_unlock(&tsk->sighand->siglock);
+	}
 }
 
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
-- 
1.6.3.3

