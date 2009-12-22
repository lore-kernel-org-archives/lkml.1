Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZLVHT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZLVHT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 02:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZLVHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 02:19:46 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:62991 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZLVHTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 02:19:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vqaYSgrBd2DPjxNIygWmGWSUPUwTAv/vTAycbFVhkDHGf33vfiM0f9rayRkOEubGoI
         DUKS/xrNnIoD13/9Ga8Zs/qqlEdlCvg3gibhfVzWby2r+7QEFUkldQxGDZQNrlKMhqr6
         cTQI1txZlaFCeUEWTi5dTXA0AIUW7ITZhUL80=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a50912212142i6892320q7a84cf185a4a2621@mail.gmail.com>
References: <1261441037.3273.254.camel@localhost>
	 <7b6bb4a50912212142i6892320q7a84cf185a4a2621@mail.gmail.com>
Date: Tue, 22 Dec 2009 15:19:44 +0800
Message-ID: <2375c9f90912212319v63dc692bg13b918fe6ea03299@mail.gmail.com>
Subject: Re: 2.6.33-rc1 unusable due to scheduler issues, circular locking, 
	WARNs and BUGs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org, efault@gmx.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fix top-posting]

On Tue, Dec 22, 2009 at 1:42 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>
> On Tue, Dec 22, 2009 at 8:17 AM, Eric Paris <eparis@redhat.com> wrote:
>> Trying to build a kernel on a 48 core x86_64 box using make -j 64 and
>> I'm exploding in the scheduler.  I'm running (and building) kernel
>> f7b84a6ba7eaeba4e1df8feddca1473a7db369a5  There are three distinct
>> signatures of problems.  Some boots I'll see all 3 of these failures
>> sometimes only 1 or 2 of them.  That's the reason they are kinda split
>> up in dmesg.
>>
>> 1) gcc/3141 is trying to acquire lock:
>>  (&(&sem->wait_lock)->rlock){......}, at: [<ffffffff81223234>] __down_read_trylock+0x13/0x46
>>
>> but task is already holding lock:
>>  (&rq->lock){-.-.-.}, at: [<ffffffff8103dd2d>] task_rq_lock+0x51/0x83
>>
>> 2) WARN() in kernel/sched_fair.c:1001 hrtick_start_fair()
>>
>> 3) NULL pointer dereference at 0000000000000168 in check_preempt_wakeup
>>      kernel/sched_fair.c
>>
>> Full backtraces are in the attached dmesg.
>>
> Does a revert of cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6 fix this problem?


I don't think so...

I think the most suspicious commit here is ab19cb23. It kicked
"local_irq_save()"
out, which means if the task is selected to run on another cpu which doesn't
disable irq, we will have a page fault, thun we will try to hold mm->mmap_sem
while we are holding rq->lock already.

Does the following untested patch fix the problem?

NOT-signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

------
diff --git a/kernel/sched.c b/kernel/sched.c
index 87f1f47..221ab59 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2408,13 +2408,13 @@ static int try_to_wake_up(struct task_struct
*p, unsigned int state,
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(rq, p);

-	__task_rq_unlock(rq);
+	task_rq_unlock(rq);

 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);

-	rq = __task_rq_lock(p);
+	rq = task_rq_lock(p);
 	update_rq_clock(rq);

 	WARN_ON(p->state != TASK_WAKING);
