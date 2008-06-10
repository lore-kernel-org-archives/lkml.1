Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYFJVPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYFJVPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYFJVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:15:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10863 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbYFJVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:15:15 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5314"; a="3650004"
Message-ID: <484EEF05.3060807@qualcomm.com>
Date: Tue, 10 Jun 2008 14:15:49 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: cpusets and kthreads, inconsistent behaviour
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com> <484EAC2F.5020103@qualcomm.com> <alpine.DEB.1.10.0806101135050.28953@chino.kir.corp.google.com> <484EE7BE.3000606@qualcomm.com> <alpine.DEB.1.10.0806101350110.29422@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.10.0806101350110.29422@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 10 Jun 2008, Max Krasnyansky wrote:
> 
>> Hmm, technically you are correct of course. But we do not have any other
>> kernel tasks besides kthreads. All the kernel tasks I have on my machines have
>> kthreadd as their parent.
>> And I'm not aware of any kernel code that changes affinity mask of a
>> user-space task without paying attention to the cpuset the task belongs to. If
>> you know of any we should fix it because it'd clearly be a bug.
>>
> 
> This is why it shouldn't belong in the sched or kthread code; the 
> discrepency that you point out between p->cpus_allowed and 
> task_cs(p)->cpus_allowed is a cpuset created one.
I guess I do not see how the kernel task case is different from the
sched_setaffinity(). ie sched_setaffinity() is in the scheduler but it deals
with cpusets.

Also in this case the discrepancy is created _not_ by the cpuset, it's created
due to the lack of the appropriate API. In other words if we had something
kthread_setaffinty() from day one this would have been a non-issue :).

> So to avoid having tasks with a cpus_allowed mask that is not a subset of 
> its cpuset's set of allowable cpus, the solution would probably be to add 
> a flavor of cpuset_update_task_memory_state() for a cpus generation value.
Post policing would not work well in some scenarios due to lag time. ie By the
time cpusets realized that some kthread is running on the wrong cpus it maybe
too late.
We should just enforce cpuset constraint when kthreads change their affinity
mask, just like sched_setaffinity() already does.

Max
