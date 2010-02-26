Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827Ab0BZFFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:05:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58818 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0BZFFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:05:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 14:01:35 +0900
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
Message-Id: <20100226140135.23c32a8d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361002252050r29f54ea2u6c6e87f1f702d195@mail.gmail.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<1266765525-30890-2-git-send-email-arighi@develer.com>
	<alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
	<20100221221700.GA5233@linux>
	<20100222180732.GC3096@redhat.com>
	<20100223115846.GI1882@linux>
	<28c262361002250736k57543379j8291e0dfb8df194e@mail.gmail.com>
	<20100226092339.1f639cbf.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361002252050r29f54ea2u6c6e87f1f702d195@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 26 Feb 2010 13:50:04 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> > Hm ? I don't read the whole thread but can_attach() is called under
> > cgroup_mutex(). So, it doesn't need to use RCU.
> 
> Vivek mentioned memcg is protected by RCU if I understand his intention right.
> So I commented that without enough knowledge of memcg.
> After your comment, I dive into the code.
> 
> Just out of curiosity.
> 
> Really, memcg is protected by RCU?
yes. All cgroup subsystem is protected by RCU.

> I think most of RCU around memcg is for protecting task_struct and
> cgroup_subsys_state.
> The memcg is protected by cgroup_mutex as you mentioned.
> Am I missing something?

There are several levels of protections.

cgroup subsystem's ->destroy() call back is finally called by

As this.

 768                 synchronize_rcu();
 769 
 770                 mutex_lock(&cgroup_mutex);
 771                 /*
 772                  * Release the subsystem state objects.
 773                  */
 774                 for_each_subsys(cgrp->root, ss)
 775                         ss->destroy(ss, cgrp);
 776 
 777                 cgrp->root->number_of_cgroups--;
 778                 mutex_unlock(&cgroup_mutex);

Before here, 
	- there are no tasks under this cgroup (cgroup's refcnt is 0)
          && cgroup is marked as REMOVED.

Then, this access
	rcu_read_lock();
	mem = mem_cgroup_from_task(task);
	if (css_tryget(mem->css))   <===============checks cgroup refcnt
		....
	rcu_read_unlock()
is O.K.

And, it's graranteed that we don't have to do complicated fine-grain check
if cgroup_mutex() is held.

Because cgroup_mutex() is system-wide heavy lock, this refcnt+RCU trick is
used and works quite well.

Thanks,
-Kame

