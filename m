Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZCRC77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZCRC77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZCRC7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:59:49 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:57483 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbZCRC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:59:49 -0400
Date: Wed, 18 Mar 2009 08:29:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090318025933.GW16897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090317061754.GD3314@in.ibm.com> <49BF42FB.4030103@cn.fujitsu.com> <20090317124031.GT16897@balbir.in.ibm.com> <49C0511C.9030508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49C0511C.9030508@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-03-18 09:40:44]:

> Balbir Singh wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> [2009-03-17 14:28:11]:
> > 
> >> Bharata B Rao wrote:
> >>> cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> >>> 	rcupreempt is used.
> >>>
> >>> cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> >>> This can race with the task's movement between cgroups. This race
> >>> can cause an access to freed ca pointer in cpuacct_charge(). This will not
> >> Actually it can also end up access invalid tsk->cgroups. ;)
> >>
> >> get tsk->cgroups (cg)
> >>                          (move tsk to another cgroup) or (tsk exiting)
> >>                          -> kfree(tsk->cgroups)
> >> get cg->subsys[..]
> >>
> > 
> > That problem should only occur if we dereference tsk->cgroups
> > separately and then use that to dereference cg->subsys. Since we use
> 
> Do you mean tsk->cgroups->subsys is safe and
> cg = tsk->cgroups;...; cg->subsys is unsafe ?
> This is wrong.

Without rcu_read_lock/unlock they are unsafe, even with the lock, we
need to use rcu_dereference() to make sure we get consistent values.

> 
> > task_subsys_state() and that is RCU safe, we should be OK.
> > 
> 
> Yes, it's RCU safe, which means it's unsafe without rcu_read_lock/unlock.
>

Yes, I meant under rcu_read_lock/unlock. 

-- 
	Balbir
