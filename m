Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZAWKek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZAWKek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZAWKec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:34:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:49775 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZAWKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:34:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=LuQhf+RCtN2yW2c2KQxZovT9UkcucLTjXEphvfGIsNd1+jJt1vAI+WUk+EJvSJ6/P
	n1/wYZhqc/GjZNuV7aSKQ==
Date: Fri, 23 Jan 2009 02:33:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901231515.37442.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901230223500.15719@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <200901231515.37442.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.101
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nikanth Karthikesan wrote:

> > Of course, because the oom killer must be aware that tasks in disjoint
> > cpusets are more likely than not to result in no memory freeing for
> > current's subsequent allocations.
> >
> 
> Yes, the problem is cpuset does not track the tasks which has allocated from 
> this node - who has either moved or changed it set of allowable nodes. And 
> because of that it does not limit oom killing to the tasks with in those tasks 
> and could kill some innocent tasks at times.
> 

Right, the logic to prefer tasks that share the same set of allowable 
nodes as the oom-triggering task is implemented in badness() and being in 
a completely disjoint cpuset does not specifically exclude a task from 
being chosen as the oom killer's victim.  That's because, as you said, it 
could have allocated memory elsewhere before changing cpusets or its set 
of allowable mems.

> As it is unable to take deterministic decision as memcg does, it plays with 
> badness value and only suggests but does not restricts within those tasks that 
> has to be killed.
> 
> This bug is present even without this patch.
> 

It's not a bug, it can actually help in a couple instances:

 - a much larger memory hogging task is identified in a disjoint cpuset
   and the liklihood it has allocated memory elsewhere either previously 
   or atomically, or

 - an administrator tunes the oom_adj value for such a task to describe 
   the above behavior even for smaller tasks and their liklihood to 
   allocate outside of their exclusive cpuset.

> This patch adds one more easier way for the administrator to over-ride.
> 

Yeah, I know.  But the problem with the approach is that it specifies an 
oom priority for both global unconstrained ooms and cpuset-constrained 
ooms.

It's quite possible with your patch to identify an aggregate of tasks that 
should be killed first whenever the system is completely out of memory.  
That's great, and solves your problem.  But that same system cannot 
correctly use cpusets that have the potential to ever oom because your 
patch completely overrides the victim priority and could needlessly kill 
tasks that will not lead to future memory freeing.

That's my objection to the proposal: it doesn't behave appropriately for 
both global unconstrained ooms and cpuset-constrained ooms at the same 
time.

I think if you look at the cgroup oom notifier patch I referred you to, 
you will find it trivial to implement a handler that can issue a SIGKILL 
for an aggregate of tasks and implement the functional equivalent of this 
patch in userspace where it belongs.  It's nearly impossible to code oom 
killer heuristics in the kernel that work for every possible workload and 
configuration without some unfortunate casualties.

> The current cpuset oom handling has to be fixed and the exact problem of 
> killing innocent processes exists even without the oom-controller.
> 

I think the heuristic could be tuned to penalize tasks in disjoint cpusets 
a little more, but its implementation as a factor of the badness score is 
actually very well placed.
