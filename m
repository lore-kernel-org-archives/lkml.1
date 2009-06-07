Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZFGKNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZFGKNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZFGKNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:13:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35912 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZFGKNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:13:02 -0400
Date: Sun, 7 Jun 2009 15:41:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Menage <menage@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090607101120.GB16211@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <20090605113217.GA20786@in.ibm.com> <6599ad830906050518t6cd7d477h36a187f2eaf55578@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830906050518t6cd7d477h36a187f2eaf55578@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 05:18:13AM -0700, Paul Menage wrote:
> Well yes, it's true that you *could* just enforce shares over a
> granularity of minutes, and limits over a granularity of milliseconds.
> But why would you? It could well make sense that you can adjust the
> granularity over which shares are enforced - e.g. for batch jobs, only
> enforcing over minutes or tens of seconds might be fine. But if you're
> doing the fine-grained accounting and scheduling required for the
> tight hard limit enforcement, it doesn't seem as though it should be
> much harder to enforce shares at the same granularity for those
> cgroups that matter. In fact I thought that's what CFS already did -
> updated the virtual time accounting at each context switch, and picked
> the runnable child with the oldest virtual time. (Maybe someone like
> Ingo or Peter who's more familiar than I with the CFS implementation
> could comment here?)

Using shares to guarantee resources over short period (<2-3 seconds) works 
just well on a single CPU. The complexity is with multi-cpu case, where CFS can 
take a long time to converge to a fair point. This is because fairness is based 
on rebalancing tasks equally across all CPUs.

For something like 4 tasks on 4 CPUs, it will converge pretty quickly 
(2-3 seconds):

[top o/p refreshed every 2sec on 2.6.30-rc5-tip]

14753 vatsa     20   0 63812 1072  924 R 99.9  0.0   0:39.54 hog
14754 vatsa     20   0 63812 1072  924 R 99.9  0.0   0:38.69 hog
14756 vatsa     20   0 63812 1076  924 R 99.9  0.0   0:38.27 hog
14755 vatsa     20   0 63812 1072  924 R 99.6  0.0   0:38.27 hog

whereas for something like 5 tasks on 4 CPUs, it will take a sufficiently 
longer time (>30 seconds)

[top o/p refreshed every 2sec]:

14754 vatsa     20   0 63812 1072  924 R 86.0  0.0   2:06.45 hog
14766 vatsa     20   0 63812 1072  924 R 83.0  0.0   0:07.95 hog
14756 vatsa     20   0 63812 1076  924 R 81.7  0.0   2:06.48 hog
14753 vatsa     20   0 63812 1072  924 R 78.7  0.0   2:07.10 hog
14755 vatsa     20   0 63812 1072  924 R 69.4  0.0   2:05.62 hog

[top o/p refreshed every 120sec]:

14766 vatsa     20   0 63812 1072  924 R 90.1  0.0   5:57.22 hog
14755 vatsa     20   0 63812 1072  924 R 84.8  0.0   8:01.61 hog
14754 vatsa     20   0 63812 1072  924 R 77.3  0.0   7:52.04 hog
14753 vatsa     20   0 63812 1072  924 R 74.1  0.0   7:29.01 hog
14756 vatsa     20   0 63812 1076  924 R 73.5  0.0   7:34.69 hog

[Note that even over 2min, we haven't achieved perfect fairness]

> > By having hard-limits, we are
> > "reserving" (potentially idle) slots where the high-priority group can run and
> > claim its guaranteed share almost immediately.

On further thinking, this is not as simple as that. In above example of
5 tasks on 4 CPUs, we could cap each task at a hard limit of 80% 
(4 CPUs/5 tasks), which is still not sufficient to ensure that each
task gets the perfect fairness of 80%! Not just that, hard-limit 
for a group (on each CPU) will have to be adjusted based on its task
distribution. For ex: a group that has a hard-limit of 25% on a 4-cpu
system and that has a single task, is entitled to claim a whole CPU. So
the per-cpu hard-limit for the group should be 100% on whatever CPU the
task is running. This adjustment of per-cpu hard-limit should happen
whenever the task distribution of the group across CPUs change - which
in theory would require you to monitor every task exit/migration
event and readjust limits, making it very complex and high-overhead.

Balbir,
	I dont think guarantee can be met easily thr' hard-limits in
case of CPU resource. Atleast its not as straightforward as in case of
memory!

- vatsa
