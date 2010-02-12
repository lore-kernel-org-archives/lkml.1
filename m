Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0BLVAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:00:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19910 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0BLVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:00:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Mal37MIIjKXyAvyXQ1z0BoqOJCiWsaHTKw+kDBFqsk1OCBU3DYKEA3rGqdxAQGR+C
	m0lqfRp89gTF8GKzNu8Uw==
Date: Fri, 12 Feb 2010 13:00:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <1265982984.6207.29.camel@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
 <1265982984.6207.29.camel@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, Minchan Kim wrote:

> > True, that's a great example of why child tasks should be sacrificed for 
> > the parent: if the oom killer is being called then we are truly overloaded 
> > and there's no shame in killing excessive client connections to recover, 
> > otherwise we might find the entire server becoming unresponsive.  The user 
> > can easily tune to /proc/sys/vm/oom_forkbomb_thres to define what 
> > "excessive" is to assess the penalty, if any.  I'll add that to the 
> > comment if we require a second revision.
> > 
> 
> I am worried about opposite case.
> 
> If forkbomb parent makes so many children in a short time(ex, 2000 per
> second) continuously and we kill a child continuously not parent, system
> is almost unresponsible, I think.  

The oom killer is not the appropriate place for a kernel forkbomb policy 
to be implemented, you'd need to address that concern in the scheduler.  
When I've brought that up in the past, the response is that if we aren't 
out of memory, then it isn't a problem.  It is a problem for buggy 
applications because their timeslice is now spread across an egregious 
amount of tasks that they are perhaps leaking and is detrimental to their 
server's performance.  I'm not saying that we need to enforce a hard limit 
on how many tasks a server forks, for instance, but the scheduler can 
detect forkbombs much easier than the oom killer's tasklist scan by at 
least indicating to us with a process flag that it is a likely forkbomb.

> I suffered from that case in LTP and no swap system.
> It might be a corner case but might happen in real. 
> 

If you look at the patchset overall and not just this one patch, you'll 
notice that we now kill the child with the highest badness() score first, 
i.e. generally the one consuming the most memory.  That is radically 
different than the previous behavior and should prevent the system from 
becoming unresponsive.  The goal is to allow the user to react to the 
forkbomb rather than implement a strict detection and handling heuristic 
that kills innocent servers and system daemons.

> If we make sure this task is buggy forkbomb, it would be better to kill
> it. But it's hard to make sure it's a buggy forkbomb.
> 
> Could we solve this problem by following as?
> If OOM selects victim and then the one was selected victim right before
> and it's repeatable 5 times for example, then we kill the victim(buggy
> forkbom) itself not child of one. It is assumed normal forkbomb is
> controlled by admin who uses oom_forkbomb_thres well. So it doesn't
> happen selecting victim continuously above five time.
> 

That doesn't work with Rik's example of a webserver that forks a large 
number of threads to handle client connections.  It is _always_ better to 
kill a child instead of making the entire webserver unresponsive.

In other words, doing anything in the oom killer other than slightly 
penalizing these tasks and killing a child is really a non-starter because 
there are too many critical use cases (we have many) that would be 
unfairly biased against.
