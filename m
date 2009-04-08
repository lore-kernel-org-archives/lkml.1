Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbZDHF3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbZDHF3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbZDHF3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:29:40 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58210 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZDHF3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:29:40 -0400
Date: Wed, 8 Apr 2009 10:59:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFI] Shared accounting for memory resource controller
Message-ID: <20090408052904.GY7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090407063722.GQ7082@balbir.in.ibm.com> <20090407160014.8c545c3c.kamezawa.hiroyu@jp.fujitsu.com> <20090407071825.GR7082@balbir.in.ibm.com> <20090407163331.8e577170.kamezawa.hiroyu@jp.fujitsu.com> <20090407080355.GS7082@balbir.in.ibm.com> <20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-07 17:24:19]:

> On Tue, 7 Apr 2009 13:33:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-07 16:33:31]:
> > 
> > > On Tue, 7 Apr 2009 12:48:25 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-07 16:00:14]:
> > > > 
> > > > > On Tue, 7 Apr 2009 12:07:22 +0530
> > > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > Hi, All,
> > > > > > 
> > > > > > This is a request for input for the design of shared page accounting for
> > > > > > the memory resource controller, here is what I have so far
> > > > > > 
> > > > > 
> > > > > In my first impression, I think simple counting is impossible.
> > > > > IOW, "usage count" and "shared or not" is very different problem.
> > > > > 
> > > > > Assume a page and its page_cgroup.
> > > > > 
> > > > > Case 1)
> > > > >   1. a page is mapped by process-X under group-A
> > > > >   2. its mapped by process-Y in group-B (now, shared and charged under group-A)
> > > > >   3. move process-X to group-B
> > > > >   4. now the page is not shared.
> > > > > 
> > > > 
> > > > By shared I don't mean only between cgroups, it could be a page shared
> > > > in the same cgroup
> > > > 
> > > Hmm, is it good information ?
> > > 
> > > Such kind of information can be calucated by
> > > ==
> > >    rss = 0;
> > >    for_each_process_under_cgroup() {
> > >        mm = tsk->mm
> > >        rss += mm->anon_rss;
> > >    }
> > >    some_of_all_rss = rss;
> > >    
> > >    shared_ratio = mem_cgrou->rss *100 / some_of_all_rss.
> > > ==
> > >    if 100%, all anon memory are not shared.
> > >
> > 
> > Why only anon? 
> 
> no serious intention.
> Just because you wrote "expect the user to account all cached pages as shared" ;)
>

OK, I noticed another thing, our RSS accounting is not RSS per-se, it
includes only anon RSS, file backed pages are accounted as cached.
I'll send out a patch to see if we can include anon RSS as well.
 
> > This seems like a good idea, except when we have a page
> > charged to a cgroup and the task that charged it has migrated, in that
> > case sum_of_all_rss will be 0.
> > 
> Yes. But we don't move pages at task-move under expectation that moved
> process will call fork() soon.
> "task move" has its own problem, so ignoring it for now is a choice.
> That kind of troubls can be treated when we fixes "task move".
> (or fix "task move" first.)
> 
> Thanks,
> -Kame
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 

-- 
	Balbir
