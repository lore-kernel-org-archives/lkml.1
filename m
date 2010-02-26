Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0BZFxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:53:48 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:42636 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935241Ab0BZFxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:53:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ezKs4bwc/8WH7GCo9eTjT0voqrFGjwHjqTkZnMXS4WG0P2fSQcaiDo9ENtYZN9Umq8
         w0erL6quBJh0U7S8xItsL2X1XpxfvFlOgdE5YWZKPi6InmmHRMsfjfc6IupnScfuid0p
         8co4E4ZsyqKSTLtu5fxc4cn0ZcS7FfVmmrxc4=
MIME-Version: 1.0
In-Reply-To: <20100226140135.23c32a8d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	 <1266765525-30890-2-git-send-email-arighi@develer.com>
	 <alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
	 <20100221221700.GA5233@linux> <20100222180732.GC3096@redhat.com>
	 <20100223115846.GI1882@linux>
	 <28c262361002250736k57543379j8291e0dfb8df194e@mail.gmail.com>
	 <20100226092339.1f639cbf.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361002252050r29f54ea2u6c6e87f1f702d195@mail.gmail.com>
	 <20100226140135.23c32a8d.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 26 Feb 2010 14:53:39 +0900
Message-ID: <28c262361002252153s587b70ecxf89eda9a642e527c@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting 
	infrastructure
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>, Vivek Goyal <vgoyal@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 2:01 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hi,
>
> On Fri, 26 Feb 2010 13:50:04 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> > Hm ? I don't read the whole thread but can_attach() is called under
>> > cgroup_mutex(). So, it doesn't need to use RCU.
>>
>> Vivek mentioned memcg is protected by RCU if I understand his intention right.
>> So I commented that without enough knowledge of memcg.
>> After your comment, I dive into the code.
>>
>> Just out of curiosity.
>>
>> Really, memcg is protected by RCU?
> yes. All cgroup subsystem is protected by RCU.
>
>> I think most of RCU around memcg is for protecting task_struct and
>> cgroup_subsys_state.
>> The memcg is protected by cgroup_mutex as you mentioned.
>> Am I missing something?
>
> There are several levels of protections.
>
> cgroup subsystem's ->destroy() call back is finally called by
>
> As this.
>
>  768                 synchronize_rcu();
>  769
>  770                 mutex_lock(&cgroup_mutex);
>  771                 /*
>  772                  * Release the subsystem state objects.
>  773                  */
>  774                 for_each_subsys(cgrp->root, ss)
>  775                         ss->destroy(ss, cgrp);
>  776
>  777                 cgrp->root->number_of_cgroups--;
>  778                 mutex_unlock(&cgroup_mutex);
>
> Before here,
>        - there are no tasks under this cgroup (cgroup's refcnt is 0)
>          && cgroup is marked as REMOVED.
>
> Then, this access
>        rcu_read_lock();
>        mem = mem_cgroup_from_task(task);
>        if (css_tryget(mem->css))   <===============checks cgroup refcnt

If it it, do we always need css_tryget after mem_cgroup_from_task
without cgroup_mutex to make sure css is vaild?

But I found several cases that don't call css_tryget

1. mm_match_cgroup
It's used by page_referenced_xxx. so we I think we don't grab
cgroup_mutex at that time.

2. mem_cgroup_oom_called
I think in here we don't grab cgroup_mutex, too.

I guess some design would cover that problems.
Could you tell me if you don't mind?
Sorry for bothering you.

Thanks, Kame.



-- 
Kind regards,
Minchan Kim
