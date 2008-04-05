Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbYDEOsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbYDEOsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 10:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYDEOsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 10:48:25 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:34607 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYDEOsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 10:48:24 -0400
Message-ID: <47F79102.6090406@linux.vnet.ibm.com>
Date: Sat, 05 Apr 2008 20:17:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <6599ad830804040112q3dd5333aodf6a170c78e61dc8@mail.gmail.com> <47F5E69C.9@linux.vnet.ibm.com> <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com> <47F5F3FA.7060709@linux.vnet.ibm.com> <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com>
In-Reply-To: <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Apr 4, 2008 at 2:25 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  >>  For other controllers,
>>  >>  they'll need to monitor exit() callbacks to know when the leader is dead :( (sigh).
>>  >
>>  > That sounds like a nightmare ...
>>  >
>>
>>  Yes, it would be, but worth the trouble. Is it really critical to move a dead
>>  cgroup leader to init_css_set in cgroup_exit()?
> 
> It struck me that this whole group leader optimization is broken as it
> stands since there could (in strange configurations) be multiple
> thread groups sharing the same mm.
> 
> I wonder if we can't just delay the exit_mm() call of a group leader
> until all its threads have exited?
> 

Not sure about this one, I suspect keeping the group_leader around is an
optimization, changing exit_mm() for the group_leader, not sure how that will
impact functionality or standards. It might even break some applications.

Repeating my question earlier

Can we delay setting task->cgroups = &init_css_set for the group_leader, until
all threads have exited? If the user is unable to remove a cgroup node, it will
be due a valid reason, the group_leader is still around, since the threads are
still around. The user in that case should wait for notify_on_release.

>>  > As long as we find someone to pass the mm to quickly, it shouldn't be
>>  > too bad - I think we're already optimized for that case. Generally the
>>  > group leader's first child will be the new owner, and any subsequent
>>  > times the owner exits, they're unlikely to have any children so
>>  > they'll go straight to the sibling check and pass the mm to the
>>  > parent's first child.
>>  >
>>  > Unless they all exit in strict sibling order and hence pass the mm
>>  > along the chain one by one, we should be fine. And if that exit
>>  > ordering does turn out to be common, then simply walking the child and
>>  > sibling lists in reverse order to find a victim will minimize the
>>  > amount of passing.
>>  >
>>
>>
>>  Finding the next mm might not be all that bad, but doing it each time a task
>>  exits, can be an overhead, specially for large multi threaded programs.
> 
> Right, but we only have that overhead if we actually end up passing
> the mm from one to another each time they exit. It would be
> interesting to know what order the threads in a large multi-threaded
> process exit typically (when the main process exits and all the
> threads die).
> 
> I guess it's likely to be one of:
> 
> - in thread creation order (i.e. in order of parent->children list),
> in which case we should try to throw the mm to the parent's last child
> - in reverse creation order, in which case we should try to throw the
> mm to the parent's first child
> - in random order depending on which threads the scheduler runs first
> (in which case we can expect that a small fraction of the threads will
> have to throw the mm whichever end we start from)
> 
>>  This can
>>  get severe if the new mm->owner belongs to a different cgroup, in which case we
>>  need to use callbacks as well.
>>
>>  If half the threads belonged to a different cgroup and the new mm->owner kept
>>  switching between cgroups, the overhead would be really high, with the callbacks
>>  and the mm->owner changing frequently.
> 
> To me, it seems that setting up a *virtual address space* cgroup
> hierarchy and then putting half your threads in one group and half in
> the another is asking for trouble. We need to not break in that
> situation, but I'm not sure it's a case to optimize for.

That could potentially happen, if the virtual address space cgroup and cpu
control cgroup were bound together in the same hierarchy by the sysadmin.

I measured the overhead of removing the delay_group_leader optimization and
found a 4% impact on throughput (with volanomark, that is one of the
multi-threaded benchmarks I know of).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
