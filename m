Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZBZILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZBZILf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZBZILW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:11:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZBZILV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:11:21 -0500
Message-ID: <49A64EB8.9020203@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 16:11:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] New cgroup subsystem API (->initialize())
References: <20090225105730.GA4008@in.ibm.com> <20090225105831.GB4008@in.ibm.com> <49A604BA.9090407@cn.fujitsu.com> <20090226075259.GA3312@in.ibm.com>
In-Reply-To: <20090226075259.GA3312@in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Thu, Feb 26, 2009 at 10:55:54AM +0800, Li Zefan wrote:
>> Bharata B Rao wrote:
>>> From: Balaji Rao <balajirrao@gmail.com>
>>>
>>> cgroup: Add ->initialize() to cgroup_subsys structure
>>>
>>> Some cgroup subsystems (like cpu controller) would need subsystem
>>> specific initialization. Such subsystems can define ->initialize()
>>> which gets called during cgroup_init() (and not cgroup_init_early()).
>>>
>> I think it's better to avoid adding this.
>>
>> It would be best if we can add a hook to initialize init_task_group.stat where
>> kmalloc is available but acount_xxx_time() hasn't been called. Otherwise, we
>> have to check (tg->stat == NULL) in account_task_group_time(), then why not add
>> a hook in smp_init_smp() to do initialization?
> 
> account_xxx_time() is called from scheduler ticks and AFAICS they end up
> getting called much before kmalloc is available. In any case, I would think
> any hook to just initialize stats for init_task_group would be
> very very (cpu controller) subsytem specific. Isn't that bad ?
> 

Since it's very very cpu subsystem specific, so it's better to use it's own hook.
(and because the initialize() API is not so elegant..)

> Another solution I see which can prevent all this is not to collect
> stats for init_task_group at all with the understanding that system wide

This came to my mind too. ;)

> stime/utime accounting (which is already present) is essentially the
> accounting for init_task_group because init_task_group comprises of all
> the tasks in the system. But this would necessiate us to make collection
> of cpu controller stats hierarchial. This was one of the questions I asked
> in my 0/2 thread. Shouldn't we be doing hierarchial accounting for
> cpu controller ?
> 

Don't know. I have no strong opinion about this. I'm a bit doubt how useful
this is.

> Another thing that could be done is to enhance already existing
> cpuacct controller to do stime/utime accouting also. cpuacct controller
> exists precisely for doing per-cgroup accounting and is there any reason
> why these stats shouldn't be part of cpuacct controller. If we do this,
> users would be forced to use cpu controller and cpuacct controller
> together. Is that a problem ?
> 

I wondered why these stats is part of cpu subsystem but not cpuacct.
And I don't see any problem to use these 2 subsystems together. Actually
this is one of the advantage of cgroup.

