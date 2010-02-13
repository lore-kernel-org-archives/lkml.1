Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0BMCpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:45:10 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:60538 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab0BMCpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HE8dHvHS5lysti423uMbyiK/zzukHf1MjBcdxb85WzyX0tpwNPZ9DJtqSJc7bzr7nJ
         DYZOetMez8TGncXS65tHfUXqu387mSB2mNk3b0uoL6E1788zvjVpiSn6DvZDpuFcCPE/
         WTUjWRdl0ub77balcVdHecLkiMFEa1cHfg2OY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com>
	 <4B73833D.5070008@redhat.com>
	 <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
	 <1265982984.6207.29.camel@barrios-desktop>
	 <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com>
Date: Sat, 13 Feb 2010 11:45:07 +0900
Message-ID: <28c262361002121845w459d0fa0l55a58552c3a6081e@mail.gmail.com>
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

On Sat, Feb 13, 2010 at 6:00 AM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 12 Feb 2010, Minchan Kim wrote:
>
>> > True, that's a great example of why child tasks should be sacrificed for
>> > the parent: if the oom killer is being called then we are truly overloaded
>> > and there's no shame in killing excessive client connections to recover,
>> > otherwise we might find the entire server becoming unresponsive.  The user
>> > can easily tune to /proc/sys/vm/oom_forkbomb_thres to define what
>> > "excessive" is to assess the penalty, if any.  I'll add that to the
>> > comment if we require a second revision.
>> >
>>
>> I am worried about opposite case.
>>
>> If forkbomb parent makes so many children in a short time(ex, 2000 per
>> second) continuously and we kill a child continuously not parent, system
>> is almost unresponsible, I think.
>
> The oom killer is not the appropriate place for a kernel forkbomb policy
> to be implemented, you'd need to address that concern in the scheduler.

I agree. but your's patch try to implement policy(avg rss of children < HZ)
in oom killer as well as detection.
so I pointed out that.
I think if we want to implement it, we also consider above scenario.
As you said, it would be better to detect forkbom in scheduler.
Then, let's remove forkbomb detection in OOM killer.
Afterward, we can implement it in scheduler and can use it in OOM killer.

It makes OOM killer more simple and predictable.

> When I've brought that up in the past, the response is that if we aren't
> out of memory, then it isn't a problem.  It is a problem for buggy

I said the situation out of memory.

> applications because their timeslice is now spread across an egregious
> amount of tasks that they are perhaps leaking and is detrimental to their
> server's performance.  I'm not saying that we need to enforce a hard limit
> on how many tasks a server forks, for instance, but the scheduler can
> detect forkbombs much easier than the oom killer's tasklist scan by at
> least indicating to us with a process flag that it is a likely forkbomb.
>
>> I suffered from that case in LTP and no swap system.
>> It might be a corner case but might happen in real.
>>
>
> If you look at the patchset overall and not just this one patch, you'll
> notice that we now kill the child with the highest badness() score first,
> i.e. generally the one consuming the most memory.  That is radically

It would work well just in case children have big difference badness scores.

> different than the previous behavior and should prevent the system from
> becoming unresponsive.  The goal is to allow the user to react to the
> forkbomb rather than implement a strict detection and handling heuristic
> that kills innocent servers and system daemons.
>
>> If we make sure this task is buggy forkbomb, it would be better to kill
>> it. But it's hard to make sure it's a buggy forkbomb.
>>
>> Could we solve this problem by following as?
>> If OOM selects victim and then the one was selected victim right before
>> and it's repeatable 5 times for example, then we kill the victim(buggy
>> forkbom) itself not child of one. It is assumed normal forkbomb is
>> controlled by admin who uses oom_forkbomb_thres well. So it doesn't
>> happen selecting victim continuously above five time.
>>
>
> That doesn't work with Rik's example of a webserver that forks a large
> number of threads to handle client connections.  It is _always_ better to
> kill a child instead of making the entire webserver unresponsive.

In such case, admin have to handle it by oom_forkbom_thres.
Isn't it your goal?

My suggestion is how handle buggy forkbomb processes which make
system almost hang by user's mistake. :)

>
> In other words, doing anything in the oom killer other than slightly
> penalizing these tasks and killing a child is really a non-starter because
> there are too many critical use cases (we have many) that would be
> unfairly biased against.
>

Tend to agree. So I hope we shouldn't have consider forkbomb in OOM killer.
I guess forkbomb logic in OOM killer could make many issues in future, still.
As you said, it would be better to implement in scheduler and OOM
killer just uses it.

Thanks for quick reply, David.
-- 
Kind regards,
Minchan Kim
