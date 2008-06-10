Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYFJUoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYFJUoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYFJUoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:44:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38450 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYFJUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:44:13 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5314"; a="3648909"
Message-ID: <484EE7BE.3000606@qualcomm.com>
Date: Tue, 10 Jun 2008 13:44:46 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: cpusets and kthreads, inconsistent behaviour
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com> <484EAC2F.5020103@qualcomm.com> <alpine.DEB.1.10.0806101135050.28953@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.10.0806101135050.28953@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Rientjes wrote:
> On Tue, 10 Jun 2008, Max Krasnyansky wrote:
> 
>> Basically the issue is that current behaviour of the cpusets is inconsistent
>> with regards to kthreads. Kthreads inherit cpuset from a parent properly but
>> they simply ignore cpuset.cpus when their cpu affinity is set/updated.
>> I think the behaviour must be consistent across the board. cpuset.cpus must
>> apply to _all_ the tasks in the set, not just some of the tasks. If kthread
>> must run on the cpus other than current_cpuset.cpus then it should detach from
>> the cpuset.
>>
> 
> I disagree that a cpuset's set of allowable cpus should apply to all tasks 
> attached to that cpuset.  It's certainly beneficial to be able to further 
> constrict the set of allowed cpus for a task using sched_setaffinity().
> 
> It makes more sense to argue that for each task p, p->cpus_allowed is a 
> subset of task_cs(p)->cpus_allowed.
Yes that's exactly what I meant :). Sorry for not being clear. I did not mean
that each task in a cpuset must have the same affinity mask. So we're on the
same page here.

>> To give you an example kthreads like scsi_eh, kswapd, kacpid, pdflush,
>> kseriod, etc are all started with cpus_allows=ALL_CPUS even though they
>> inherit a cpuset from kthreadd. Yes they can moved manually (with
>> sched_setaffinity) but the behaviour is not consistent, and for no good
>> reason. kthreads can be stopped/started at any time (module load for example)
>> which means that the user will have to keep moving them.
>>
> 
> This doesn't seem to be purely a kthread issue.  Tasks can be moved to a 
> disjoint set of cpus by any caller to set_cpus_allowed_ptr() in the 
> kernel.
Hmm, technically you are correct of course. But we do not have any other
kernel tasks besides kthreads. All the kernel tasks I have on my machines have
kthreadd as their parent.
And I'm not aware of any kernel code that changes affinity mask of a
user-space task without paying attention to the cpuset the task belongs to. If
you know of any we should fix it because it'd clearly be a bug.

Thanx
Max
