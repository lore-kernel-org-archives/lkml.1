Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0BOVyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:54:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35011 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0BOVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:54:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=o86t0Z/5kvUugRXUGXM+ovtGuIW6SrSq7FJ7ej8xcGSzds/eATLtNUtmpgo48r2KE
	+o4cG2iB/U4tYutM+xmsg==
Date: Mon, 15 Feb 2010 13:54:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <28c262361002121845w459d0fa0l55a58552c3a6081e@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1002151347470.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com> <1265982984.6207.29.camel@barrios-desktop>
 <alpine.DEB.2.00.1002121251130.7972@chino.kir.corp.google.com> <28c262361002121845w459d0fa0l55a58552c3a6081e@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-328736738-1266270880=:26927"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-328736738-1266270880=:26927
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 13 Feb 2010, Minchan Kim wrote:

> > The oom killer is not the appropriate place for a kernel forkbomb policy
> > to be implemented, you'd need to address that concern in the scheduler.
> 
> I agree. but your's patch try to implement policy(avg rss of children < HZ)
> in oom killer as well as detection.
> so I pointed out that.

That's not what's used, we detect whether a child should be included in 
the forkbomb count by checking for two traits: (i) it doesn't share an 
->mm with the parent, otherwise it wouldn't free any memory unless the 
parent was killed as well, and (ii) its total runtime is less than a 
second since threads in forkbomb scenarios don't typically get any 
runtime.  The _penalization_ is then the average rss of those children 
times how many times the count exceeds oom_forkbomb_thres.

> I think if we want to implement it, we also consider above scenario.
> As you said, it would be better to detect forkbom in scheduler.
> Then, let's remove forkbomb detection in OOM killer.
> Afterward, we can implement it in scheduler and can use it in OOM killer.
> 

We're not enforcing a global, system-wide forkbomb policy in the oom 
killer, but we do need to identify tasks that fork a very large number of 
tasks to break ties with other tasks: in other words, it would not be 
helpful to kill an application that has been running for weeks because 
another application with the same or less memory usage has forked 1000 
children and has caused an oom condition.  That unfairly penalizes the 
former application that is actually doing work.

Again, I'd encourage you to look at this as only a slight penalization 
rather than a policy that strictly needs to be enforced.  If it were 
strictly enforced, it would be a prerequisite for selection if such a task 
were to exist; in my implementation, it is part of the heuristic.

> > That doesn't work with Rik's example of a webserver that forks a large
> > number of threads to handle client connections.  It is _always_ better to
> > kill a child instead of making the entire webserver unresponsive.
> 
> In such case, admin have to handle it by oom_forkbom_thres.
> Isn't it your goal?
> 

oom_forkbomb_thres has a default value, which is 1000, so it should be 
enabled by default.

> My suggestion is how handle buggy forkbomb processes which make
> system almost hang by user's mistake. :)
> 

I don't think you've given a clear description (or, even better, a patch) 
of your suggestion.
--531381004-328736738-1266270880=:26927--
