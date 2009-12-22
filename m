Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZLVIfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZLVIfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZLVIfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:35:00 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56786 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZLVIe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i7vHcGDKnAl0aL4GDMZIje5mpa4NS4js1j43Y+jpr+fRuzDCg573MiCGN8i/7FSciQ
         xku2OEC25SHhRD8A0Rcxo4pFFaB0apqON+Ko2AjNCR97AVpK0+ct2+kDuKYw/98lzsGd
         yQyD+60hxRI9yg2+J2RV+rziW9XE3LvQsvjeI=
MIME-Version: 1.0
In-Reply-To: <2375c9f90912212350s7e48a4bfp2c5b3863f5969097@mail.gmail.com>
References: <1261441037.3273.254.camel@localhost>
	 <7b6bb4a50912212142i6892320q7a84cf185a4a2621@mail.gmail.com>
	 <2375c9f90912212319v63dc692bg13b918fe6ea03299@mail.gmail.com>
	 <7b6bb4a50912212341q1e35689cuc40394ae31f96bd0@mail.gmail.com>
	 <2375c9f90912212350s7e48a4bfp2c5b3863f5969097@mail.gmail.com>
Date: Tue, 22 Dec 2009 16:34:57 +0800
Message-ID: <7b6bb4a50912220034w1e49055dob1afff292becaf02@mail.gmail.com>
Subject: Re: 2.6.33-rc1 unusable due to scheduler issues, circular locking, 
	WARNs and BUGs
From: Xiaotian Feng <xtfeng@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org, efault@gmx.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 3:50 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Dec 22, 2009 at 3:41 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>> On Tue, Dec 22, 2009 at 3:19 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> [Fix top-posting]
>>>
>>> On Tue, Dec 22, 2009 at 1:42 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>>>>
>>>> On Tue, Dec 22, 2009 at 8:17 AM, Eric Paris <eparis@redhat.com> wrote:
>>>>> Trying to build a kernel on a 48 core x86_64 box using make -j 64 and
>>>>> I'm exploding in the scheduler.  I'm running (and building) kernel
>>>>> f7b84a6ba7eaeba4e1df8feddca1473a7db369a5  There are three distinct
>>>>> signatures of problems.  Some boots I'll see all 3 of these failures
>>>>> sometimes only 1 or 2 of them.  That's the reason they are kinda split
>>>>> up in dmesg.
>>>>>
>>>>> 1) gcc/3141 is trying to acquire lock:
>>>>>  (&(&sem->wait_lock)->rlock){......}, at: [<ffffffff81223234>] __down_read_trylock+0x13/0x46
>>>>>
>>>>> but task is already holding lock:
>>>>>  (&rq->lock){-.-.-.}, at: [<ffffffff8103dd2d>] task_rq_lock+0x51/0x83
>>>>>
>>>>> 2) WARN() in kernel/sched_fair.c:1001 hrtick_start_fair()
>>>>>
>>>>> 3) NULL pointer dereference at 0000000000000168 in check_preempt_wakeup
>>>>>      kernel/sched_fair.c
>>>>>
>>>>> Full backtraces are in the attached dmesg.
>>>>>
>>>> Does a revert of cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6 fix this problem?
>>>
>>>
>>> I don't think so...
>>>
>>> I think the most suspicious commit here is ab19cb23. It kicked
>>> "local_irq_save()"
>>> out, which means if the task is selected to run on another cpu which doesn't
>>> disable irq, we will have a page fault, thun we will try to hold mm->mmap_sem
>>> while we are holding rq->lock already.
>>
>> The page fault is from kernel  NULL pointer deref.  You should connect
>> the lockdep warning and kernel BUG together.
>>
>
> Interesting.
>
> 1) Doesn't this NULL ptr def expose that we have a potential problem?
>
> 2) For NULL ptr def problem, commit 3a7e73a2e2 seems more suspicious..

I don't think so,
(gdb) l *check_preempt_wakeup+0x170
0xffffffff8103c815 is in is_same_group (kernel/sched_fair.c:154).
(gdb) assemble check_preempt_wakeup
<snip>
0xffffffff8103c815 <is_same_group+0>:   mov    0x168(%rsi),%rax
<snip>

The panic is from NULL pointer deref at 0000000000000168, so some time
in is_same_group() while loop,
parent_entity(*pse) = NULL, then is_same_group() trying to visit
pse->cfs_rq, NULL pointer deref was triggered.

commit 3a7e73, the behaviour for find_matching_se() is same as before,
this commit should not be the buggy one.

>
