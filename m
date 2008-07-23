Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYGWWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYGWWB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYGWWBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:01:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:45744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYGWWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AfuIJ1T1LFY3tuWf+xg6n5zPJkAs4+Dm5Iw9l35Dp4PWYyNxkC8qSj5qS2zHkKJSdZ
         adXgbLNocn4yW6V4zcn3Xe76cJHFcYkUk8f7IylzwIb1z/06JSicU6nu8JkGvHEcfGpY
         mRUTI9SpnMSVmJOBYF6tbJpmQ1CwLJ1g0GeXk=
Message-ID: <b647ffbd0807231501va30f6d4kee49d1daa30227fc@mail.gmail.com>
Date: Thu, 24 Jul 2008 00:01:46 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <19f34abd0807231445h79fac5cbwecd0563b74bc18ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
	 <19f34abd0807231352j1ba1414am84ee9683df9b5657@mail.gmail.com>
	 <b647ffbd0807231422w546e59e9p8362ee798b169a25@mail.gmail.com>
	 <b647ffbd0807231435h73740808p76143d3d4457b597@mail.gmail.com>
	 <19f34abd0807231445h79fac5cbwecd0563b74bc18ad@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/23 Vegard Nossum <vegard.nossum@gmail.com>:
> On Wed, Jul 23, 2008 at 11:35 PM, Dmitry Adamushko
> <dmitry.adamushko@gmail.com> wrote:
>> 2008/7/23 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>>> 2008/7/23 Vegard Nossum <vegard.nossum@gmail.com>:
>>>> ------------[ cut here ]------------
>>>> WARNING: at kernel/sched_fair.c:815 hrtick_start_fair+0x158/0x170()
>>>
>>> that's interesting. As a first step and if it's easily reproducible,
>>> would you try something like below?
>>
>> If not, maybe object files are still in-tact? Just to see where
>> exactly in schedule() it crashed so maybe we may get an idea on what
>> was a result of next = pick_next_task(rq, prev);
>
> Yes, indeed. You mean this part?
>
> BUG: unable to handle kernel paging request at c0804358
> IP: [<c057e38d>] schedule+0x1ed/0x850
> *pde = 3780e163 *pte = 00804162
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 5575, comm: migration/1 Tainted: G        W (2.6.26 #1)
> EIP: 0060:[<c057e38d>] EFLAGS: 00010086 CPU: 1
> EIP is at schedule+0x1ed/0x850
> EAX: c0803f00 EBX: 00000001 ECX: f4d10000 EDX: 00450008
> ESI: f4c91fe0 EDI: c0803f00 EBP: f4c85fa0 ESP: f4c85f3c
>
> $ addr2line -e vmlinux -i c057e38d
> kernel/sched_stats.h:164
> kernel/sched_stats.h:236
> kernel/sched_stats.h:242
> kernel/sched.c:4191
>
> (Keep in mind that the line numbers are for v2.6.26.)
>
> Looks to be this line (kernel/sched.c):
>
>                sched_info_switch(prev, next);
>
> or for kernel/sched_stats.h:164:
>
>        unsigned long long now = task_rq(t)->clock, delta = 0;
>
> ..I'm not sure how much information this is?

combining with other information from this thread (which I have
happily ignored before jumping in :-/), it's quite a lot.

't' ('next' from schedule()) is ok in this case. The problem might be
with its thread_info structure. In this case, task_rq(t) resorts to
task_cpu(t) which, in turn, comes to task_thread_info(t)->cpu.

So I guess, 'cpu' value is slightly, well, out of reality. Check the
address of "runqueues" in your kernel image...
I guess, it should be quite close to the "fault" address... then we
can even calculate 'cpu' :-)

task's thread_info is on the stack so if it gets corrupted we may get
something like this.


>
> Most likely the task_struct just got corrupted, like for the xstate
> crashes... Should I still try the patch? :-)

No. It has the same symptoms as above, namely task_cpu() is likely
wrong. So it fits in this "perhaps task's thread_info gets corrupted"
theory.


>
> Vegard
>

-- 
Best regards,
Dmitry Adamushko
