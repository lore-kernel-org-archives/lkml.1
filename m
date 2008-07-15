Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYGOUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYGOUv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYGOUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:51:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14193 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYGOUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:51:18 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5339"; a="4736287"
Message-ID: <487D0DC4.8090103@qualcomm.com>
Date: Tue, 15 Jul 2008 13:51:16 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: mingo@elte.hu, pj@sgi.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any
 context
References: <1216122293-4888-1-git-send-email-maxk@qualcomm.com> <6599ad830807150914h152e3716n914dfa5e28288d28@mail.gmail.com>
In-Reply-To: <6599ad830807150914h152e3716n914dfa5e28288d28@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Jul 15, 2008 at 4:44 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> From: Max Krasnyanskiy <maxk@qualcomm.com>
>>
>> I do not really like the current solution of dropping cgroup lock
>> but it shows what I have in mind in general.
> 
> I think that dropping the cgroup lock will open up races for cpusets.
> The idea of a separate workqueue/thread to do the sched domain
> rebuilding is simplest.

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
