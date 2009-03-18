Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZCRBkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZCRBkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZCRBki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:40:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65322 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbZCRBkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:40:37 -0400
Message-ID: <49C0511C.9030508@cn.fujitsu.com>
Date: Wed, 18 Mar 2009 09:40:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in	cpuacct_charge()
 safe when rcupreempt is used.
References: <20090317061754.GD3314@in.ibm.com> <49BF42FB.4030103@cn.fujitsu.com> <20090317124031.GT16897@balbir.in.ibm.com>
In-Reply-To: <20090317124031.GT16897@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Li Zefan <lizf@cn.fujitsu.com> [2009-03-17 14:28:11]:
> 
>> Bharata B Rao wrote:
>>> cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
>>> 	rcupreempt is used.
>>>
>>> cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
>>> This can race with the task's movement between cgroups. This race
>>> can cause an access to freed ca pointer in cpuacct_charge(). This will not
>> Actually it can also end up access invalid tsk->cgroups. ;)
>>
>> get tsk->cgroups (cg)
>>                          (move tsk to another cgroup) or (tsk exiting)
>>                          -> kfree(tsk->cgroups)
>> get cg->subsys[..]
>>
> 
> That problem should only occur if we dereference tsk->cgroups
> separately and then use that to dereference cg->subsys. Since we use

Do you mean tsk->cgroups->subsys is safe and
cg = tsk->cgroups;...; cg->subsys is unsafe ?
This is wrong.

> task_subsys_state() and that is RCU safe, we should be OK.
> 

Yes, it's RCU safe, which means it's unsafe without rcu_read_lock/unlock.
