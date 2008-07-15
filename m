Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYGORTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYGORTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYGORTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:19:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53065 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYGORTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:19:37 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5339"; a="4557397"
Message-ID: <487CDC27.7000304@qualcomm.com>
Date: Tue, 15 Jul 2008 10:19:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any
 context
References: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>	 <20080715110726.5837c783.pj@sgi.com> <6599ad830807150911jede167ewbcdfdff905b5059e@mail.gmail.com>
In-Reply-To: <6599ad830807150911jede167ewbcdfdff905b5059e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Jul 15, 2008 at 9:07 AM, Paul Jackson <pj@sgi.com> wrote:
>> If this rebuild thread was the -only- way that sched domains were
>> allowed to be rebuilt, and if this rebuild was done -asynchronously-
>> sometime shortly after requested, without any error or status feedback,
>> then it would seem to simplify the locking issues.
> 
> I sent a patch that was similar a couple of weeks ago, that used a
> workqueue to do the rebuild. It didn't quite work then since it wasn't
> safe to call get_online_cpus() from a multi-threaded workqueue then,
> but I believe there's been a patch since then that makes this safe.
> And if not, we could always have a single-threaded workqueue that
> wasn't bound to any particular CPU.

Actually I think we do not have to make it super strict "only rebuilt 
from that thread rule". I'd only off-load cpuset_write64(), 
update_flag() to the thread. It'd be nice to keep hotplug path clean 
synchronous. It's synchronous without cpusets so there is really no good 
reason when it needs to be async without them. And the toughest part is 
not even hotplug where lock nesting is pretty clear
get_online_cpus() ->
	rebuild_sched_domains() ->
		cgroup_lock();
		// Build cpumaps
			cpuset_callback_lock();
			...
			cpuset_callback_unlock();
		cgroup_unlock();
		
		partition_sched_domains() ->
			mutex_unlock(&sched_domains_mutex);
			// Rebuild sched domains
			mutex_unlock(&sched_domains_mutex);
put_online_cpus()

It's the other paths where cgroup_lock() is taken by cgroups before even 
calling into cpusets, like cgroup destroy case.
So I think we should just off-load those.

Max
