Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0BKJuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:50:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0BKJum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:50:42 -0500
From: Lubos Lunak <l.lunak@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Improving OOM killer
Date: Thu, 11 Feb 2010 10:50:36 +0100
User-Agent: KMail/1.9.10
Cc: Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
References: <201002012302.37380.l.lunak@suse.cz> <4B7320BF.2020800@redhat.com> <20100210221847.5d7bb3cb@lxorguk.ukuu.org.uk>
In-Reply-To: <20100210221847.5d7bb3cb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201002111050.36709.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of February 2010, Alan Cox wrote:
> > Killing the system daemon *is* a DoS.
> >
> > It would stop eg. the database or the web server, which is
> > generally the main task of systems that run a database or
> > a web server.
>
> One of the problems with picking on tasks that fork a lot is that
> describes apache perfectly. So a high loaded apache will get shot over a
> rapid memory eating cgi script.

 It will not. If it's only a single cgi script, that that child should be 
selected by badness(), not the parent.

 I personally consider the logic of trying to find the offender using 
badness() and then killing its child instead to be flawed. Already badness() 
itself should select what to kill and that should be killed. If it's a single 
process that is the offender, it should be killed. If badness() decides it is 
a whole subtree responsible for the situation, then the top of it needs to be 
killed, otherwise the reason for the problem will remain.

 I expect the current logic of trying to kill children first is based on the 
system daemon logic, but if e.g. Apache master process itself causes OOM, 
then the kernel itself has to way to find out if it's an important process 
that should be protected or if it's some random process causing a forkbomb. 
>From the kernel point's of view, if the Apache master process caused the 
problem, the the problem should be solved there. If the reason for the 
problem was actually e.g. a temporary high load on the server, then Apache is 
probably misconfigured, and if it really should stay running no matter what, 
then I guess that's the case to use oom_adj. But otherwise, from OOM killer's 
point of view, that is where the problem was.

 Of course, the algorithm used in badness() should be careful not to propagate 
the excessive memory usage in that case to the innocent parent. This problem 
existed in the current code until it was fixed by the "/2" recently, and at 
least my current proposal actually suffers from it too. But I envision 
something like this could handle it nicely (pseudocode):

int oom_children_memory_usage(task)
    {
    // Memory shared with the parent should not be counted again.
    // Since it's expensive to find that out exactly, just assume
    // that the amount of shared memory that is not shared with the parent
    // is insignificant.
    total = unshared_rss(task)+unshared_swap(task);
    foreach_child(child,task)
        total += oom_children_memory_usage(child);
    return total;
    }
int badness(task)
    {
    int total_memory = 0;
    ...
    int max_child_memory = 0; // memory used by that child
    int max_child_memory_2 = 0; // the 2nd most memory used by a child
    foreach_child(child,task)
        {
        if(sharing_the_same_memory(child,task))
            continue;
        if( real_time(child) > 1minute )
            continue; // running long, not a forkbomb
        int memory = oom_children_memory_usage(task);
        total_memory += memory;
        if( memory > max_child_memory )
            {
            max_child_memory_2 = max_child_memory;
            max_child_memory = memory;
            }
        else if( memory > max_child_memory_2 )
            max_child_memory_2 = memory;
        }
    if( max_child_memory_2 != 0 ) // there were at least two children
        {
        if( max_child_memory > max_child_memory_2 / 2 )
            {
// There is only a single child that contributes the majority of memory
// used by all children. Do not add it to the total, so that if that process
// is the biggest offender, the killer picks it instead of this parent.
            total_memory -= max_child_memory;
            }
        }
    ...
    }

 The logic is simply that a process is responsible for its children only if 
their cost is similar. If one of them stands out, it is responsible for 
itself and the parent is not. This is intentionally not done recursively in 
oom_children_memory_usage() to cover also the case when e.g. parallel make 
runs too many processes wrapped by shell, in that case making any of those 
shell instances responsible for its child doesn't help anything, but making 
make responsible for all of them helps.

 Alternatively, if somebody has a good use case where first going after a 
child may make sense, then it perhaps would help to 
add 'oom_recently_killed_children' to each task, and increasing it whenever a 
child is killed instead of the responsible parent. As soon as the value 
within a reasonably short time is higher than let's say 5, then apparently 
killing children does not help and the mastermind has to go.

-- 
 Lubos Lunak
 openSUSE Boosters team, KDE developer
 l.lunak@suse.cz , l.lunak@kde.org
