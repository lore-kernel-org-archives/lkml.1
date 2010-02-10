Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0BJWZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:25:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58168 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0BJWZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:25:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=W+nEswJCRbsgiIHiQBhGHkbm7sFzJfmdjN2pYGLx4KN7ko7RE0PWz8yZKPeOzWfyW
	63y8G1fuLxaLPIBwXSuZw==
Date: Wed, 10 Feb 2010 14:25:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lubos Lunak <l.lunak@suse.cz>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <201002102154.39771.l.lunak@suse.cz>
Message-ID: <alpine.DEB.2.00.1002101405530.29007@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <201002040858.33046.l.lunak@suse.cz> <alpine.DEB.2.00.1002041255080.6071@chino.kir.corp.google.com> <201002102154.39771.l.lunak@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Lubos Lunak wrote:

> > Yes, forkbombs are not always malicious, they can be the result of buggy
> > code and there's no other kernel mechanism that will hold them off so that
> > the machine is still usable.  If a task forks and execve's thousands of
> > threads on your 2GB desktop machine either because its malicious, its a
> > bug, or a the user made a mistake, that's going to be detrimental
> > depending on the nature of what was executed especially to your
> > interactivity :)  Keep in mind that the forking parent such as a job
> > scheduler or terminal and all of its individual children may have very
> > small rss and swap statistics, even though cumulatively its a problem.
> 
>  Which is why I suggested summing up the memory of the parent and its 
> children.
> 

That's almost identical to the current heuristic where we sum half the 
size of the children's VM size, unfortunately it's not a good indicator of 
forkbombs since in your particular example it would be detrimental to 
kdeinit.  My heursitic considers runtime of the children as an indicator 
of a forkbombing parent since such tasks don't typically get to run 
anyway.  The rss or swap usage of a child with a seperate address space 
simply isn't relevant to the badness score of the parent, it unfairly 
penalizes medium/large server jobs.

> > We can't address recursive forkbombing in the oom killer with any
> > efficiency, but luckily those cases aren't very common.
> 
>  Right, I've never run a recursive make that brought my machine to its knees. 
> Oh, wait.
> 

That's completely outside the scope of the oom killer, though: it is _not_ 
the oom killer's responsibility for enforcing a kernel-wide forkbomb 
policy, which would be much better handled at execve() time.

It's a very small part of my badness heuristic, depending on the average 
size of the children's rss and swap usage, because we want to slightly 
penalize tasks that fork an extremely large number of tasks that have no 
substantial runtime; memory is being consumed but very little work is 
getting done by those thousand children.  This would most often than not 
be used only to break ties when two parents have similar memory 
consumption themselves but one is obviously oversubscribing the system.

>  And why exactly is iterating over 1st level children efficient enough and 
> doing that recursively is not? I don't find it significantly more expensive 
> and badness() is hardly a bottleneck anyway.
> 

If we look at children's memory usage recursively, then we'll always end 
up selecting init_task.

> > The memory consumption of these children were not considered in my rough
> > draft, it was simply a counter of how many first-generation children each
> > task has.
> 
>  Why exactly do you think only 1st generation children matter? Look again at 
> the process tree posted by me and you'll see it solves nothing there. I still 
> fail to see why counting also all other generations should be considered 
> anything more than a negligible penalty for something that's not a bottleneck 
> at all.
> 

You're specifying a problem that is outside the scope of the oom killer, 
sorry.
