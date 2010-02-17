Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab0BQHlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:41:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934010Ab0BQHlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qfzq5zmw1c9ys6aWiWmHVyYA81Y2wxaofZksjEVF/Y0rA3zhsMdVU75YLB8KrXuD5y
         lGMGXctDbqoLYzDyeZRYkSa+ojcd3Mtkv7l4es4GHZhUh2Hq9sncdM0dH1hZ9c5kyUgl
         k6mqnuVsg+K8Uzq6gqzW6Py9+2GrCO1GXH560=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002161323450.23037@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com>
	 <4B73833D.5070008@redhat.com>
	 <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
	 <1265982984.6207.29.camel@barrios-desktop>
	 <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com>
	 <28c262361002121845w459d0fa0l55a58552c3a6081e@mail.gmail.com>
	 <alpine.DEB.2.00.1002151347470.26927@chino.kir.corp.google.com>
	 <1266326086.1709.50.camel@barrios-desktop>
	 <alpine.DEB.2.00.1002161323450.23037@chino.kir.corp.google.com>
Date: Wed, 17 Feb 2010 16:41:13 +0900
Message-ID: <28c262361002162341m1d77509dv37d7d13b4ccd0ef9@mail.gmail.com>
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 6:41 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 16 Feb 2010, Minchan Kim wrote:
>
>> > Again, I'd encourage you to look at this as only a slight penalization
>> > rather than a policy that strictly needs to be enforced.  If it were
>> > strictly enforced, it would be a prerequisite for selection if such a task
>> > were to exist; in my implementation, it is part of the heuristic.
>>
>> Okay. I can think it of slight penalization in this patch.
>> But in current OOM logic, we try to kill child instead of forkbomb
>> itself. My concern was that.
>
> We still do with my rewrite, that is handled in oom_kill_process().  The
> forkbomb penalization takes place in badness().


I thought this patch is closely related to [patch  2/7].
I can move this discussion to [patch 2/7] if you want.
Another guys already pointed out why we care child.

>
>> 1. Forkbomb A task makes 2000 children in a second.
>> 2. 2000 children has almost same memory usage. I know another factors
>> affect oom_score. but in here, I assume all of children have almost same
>> badness score.
>> 3. Your heuristic penalizes A task so it would be detected as forkbomb.
>> 4. So OOM killer select A task as bad task.
>> 5. oom_kill_process kills high badness one of children, _NOT_ task A
>> itself. Unfortunately high badness child doesn't has big memory usage
>> compared to sibling. It means sooner or later we would need OOM again.
>>
>
> Couple points: killing a task with a comparatively small rss and swap
> usage to the parent does not imply that we need the call the oom killer
> again later, killing the child will allow for future memory freeing that
> may be all that is necessary.  If the parent continues to fork, that will
> continue to be an issue, but the constant killing of its children should
> allow the user to intervene without bring the system to a grinding halt.

I said this scenario is BUGGY forkbomb process. It will fork + exec continuously
if it isn't killed. How does user intervene to fix the system?
System was almost hang due to unresponsive.

For extreme example,
User is writing some important document by OpenOffice and
he decided to execute hackbench 1000000 process 1000000.

Could user save his important office data without halt if we kill
child continuously?
I think this scenario can be happened enough if the user didn't know
parameter of hackbench.

> I'd strongly prefer to kill a child from a forkbombing task, however, than
> an innocent application that has been running for days or weeks only to
> find that the forkbombing parent will consume its memory as well and then
> need have its children killed.  Secondly, the forkbomb detection does not

Okay.
consider my argue related to  2/7, pz.

> simply require 2000 children to be forked in a second, it requires
> oom_forkbomb_thres children that have called execve(), i.e. they have
> seperate address spaces, to have a runtime of less than one second.
>
>> My point was 5.
>>
>> 1. oom_kill_process have to take a long time to scan tasklist for
>> selecting just one high badness task. Okay. It's right since OOM system
>> hang is much bad and it would be better to kill just first task(ie,
>> random one) in tasklist.
>>
>> 2. But in above scenario, sibling have almost same memory. So we would
>> need OOM again sooner or later and OOM logic could do above scenario
>> repeatably.
>>
>
> In Rik's web server example, this is the preferred outcome: kill a thread
> handling a single client connection rather than kill a "legitimate"
> forkbombing server to make the entire service unresponsive.
>
>> I said _BUGGY_ forkbomb task. That's because Rik's example isn't buggy
>> task. Administrator already knows apache can make many task in a second.
>> So he can handle it by your oom_forkbomb_thres knob. It's goal of your
>> knob.
>>
>
> We can't force all web servers to tune oom_forkbomb_thres.
>
>> So my suggestion is following as.
>>
>> I assume normal forkbomb tasks are handled well by admin who use your
>> oom_forkbom_thres. The remained problem is just BUGGY forkbomb process.
>> So if your logic selects same victim task as forkbomb by your heuristic
>> and it's 5th time continuously in 10 second, let's kill forkbomb instead
>> of child.
>>
>> tsk = select_victim_task(&cause);
>> if (tsk == last_victim_tsk && cause == BUGGY_FORKBOMB)
>>       if (++count == 5 && time_since_first_detect_forkbomb <= 10*HZ)
>>               kill(tsk);
>> else {
>>    last_victim_tsk = NULL; count = 0; time_since... = 0;
>>    kill(tsk's child);
>> }
>>
>> It's just example of my concern. It might never good solution.
>> What I mean is just whether we have to care this.
>>
>
> This unfairly penalizes tasks that have a large number of execve()
> children, we can't possibly know how to define BUGGY_FORKBOMB.  In other
> words, a system-wide forkbombing policy in the oom killer will always have
> a chance of killing a legitimate task, such as a web server, that will be
> an undesired result.  Setting the parent to OOM_DISABLE isn't really an
> option in this case since that value is inherited by children and would
> need to explicitly be cleared by each thread prior to execve(); this is
> one of the reasons why I proposed /proc/pid/oom_adj_child a few months
> ago, but it wasn't well received.
>

I don't want to annoy you if others guys don't have any complain.
If it has a problem in future, at that time we could discuss further
in detail with
real example.
I hope we don't received any complain report. :)

Thanks for good discussion, David.

-- 
Kind regards,
Minchan Kim
