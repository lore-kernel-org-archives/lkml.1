Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323Ab0BZGSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 01:18:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56957 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935299Ab0BZGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 01:18:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 15:15:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Righi <arighi@develer.com>, Vivek Goyal <vgoyal@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting 
 infrastructure
Message-Id: <20100226151506.c78b4312.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361002252153s587b70ecxf89eda9a642e527c@mail.gmail.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<1266765525-30890-2-git-send-email-arighi@develer.com>
	<alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
	<20100221221700.GA5233@linux>
	<20100222180732.GC3096@redhat.com>
	<20100223115846.GI1882@linux>
	<28c262361002250736k57543379j8291e0dfb8df194e@mail.gmail.com>
	<20100226092339.1f639cbf.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361002252050r29f54ea2u6c6e87f1f702d195@mail.gmail.com>
	<20100226140135.23c32a8d.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361002252153s587b70ecxf89eda9a642e527c@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 14:53:39 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Feb 26, 2010 at 2:01 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Hi,
> >
> > On Fri, 26 Feb 2010 13:50:04 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> > Hm ? I don't read the whole thread but can_attach() is called under
> >> > cgroup_mutex(). So, it doesn't need to use RCU.
> >>
> >> Vivek mentioned memcg is protected by RCU if I understand his intention right.
> >> So I commented that without enough knowledge of memcg.
> >> After your comment, I dive into the code.
> >>
> >> Just out of curiosity.
> >>
> >> Really, memcg is protected by RCU?
> > yes. All cgroup subsystem is protected by RCU.
> >
> >> I think most of RCU around memcg is for protecting task_struct and
> >> cgroup_subsys_state.
> >> The memcg is protected by cgroup_mutex as you mentioned.
> >> Am I missing something?
> >
> > There are several levels of protections.
> >
> > cgroup subsystem's ->destroy() call back is finally called by
> >
> > As this.
> >
> >  768                 synchronize_rcu();
> >  769
> >  770                 mutex_lock(&cgroup_mutex);
> >  771                 /*
> >  772                  * Release the subsystem state objects.
> >  773                  */
> >  774                 for_each_subsys(cgrp->root, ss)
> >  775                         ss->destroy(ss, cgrp);
> >  776
> >  777                 cgrp->root->number_of_cgroups--;
> >  778                 mutex_unlock(&cgroup_mutex);
> >
> > Before here,
> >        - there are no tasks under this cgroup (cgroup's refcnt is 0)
> >          && cgroup is marked as REMOVED.
> >
> > Then, this access
> >        rcu_read_lock();
> >        mem = mem_cgroup_from_task(task);
> >        if (css_tryget(mem->css))   <===============checks cgroup refcnt
> 
> If it it, do we always need css_tryget after mem_cgroup_from_task
> without cgroup_mutex to make sure css is vaild?
> 
On a case by cases. 

> But I found several cases that don't call css_tryget
> 
> 1. mm_match_cgroup
> It's used by page_referenced_xxx. so we I think we don't grab
> cgroup_mutex at that time.
> 
yes. but all check are done under RCU. And this function never
access contents of memory which pointer holds.
And, please conider the whole context.

	mem_cgroup_try_charge()
		mem_cout =..... (refcnt +1)
		....
		try_to_free_mem_cgroup_pages(mem_cont)
		....
		shrink_xxx_list()
		....
			page_referenced_anon(page, mem_cont)
				mm_match_cgroup(mm, mem_cont)

Then, this mem_cont (2nd argument to mm_match_cgroup) is always valid.
	rcu_read_lock();
	memcg = mem_cgroup_from_task(rcu_dereference(mm->ownder));
	rcu_read_unlock();
	return memcg != mem_cont;

Here,
	1. mem_cont is never reused. (because refcnt+1)
	2. we don't access memcg's contents.

I think even rcu_read_lock()/unlock() is unnecessary.



> 2. mem_cgroup_oom_called
> I think in here we don't grab cgroup_mutex, too.
> 
In OOM-killer context, memcg which causes OOM has refcnt +1.
Then, not necessary. 


> I guess some design would cover that problems.
Maybe.

> Could you tell me if you don't mind?
> Sorry for bothering you.
> 

In my point of view, the most terrible porblem is heavy cost of
css_tryget() when you run multi-thread heavy program.
So, I want to see some inovation, but haven't find yet.

I admit this RCU+refcnt is tend to be hard to review. But it's costly
operation to take refcnt and it's worth to be handled in the best
usage of each logics, on a case by cases for now.

Thanks,
-Kame


