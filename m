Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYF0FKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYF0FKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYF0FKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:10:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58021 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYF0FKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:10:37 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5326"; a="4096364"
Message-ID: <48647652.5050001@qualcomm.com>
Date: Thu, 26 Jun 2008 22:10:42 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Paul Jackson <pj@sgi.com>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Gautham shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains()
 to the workqueue
References: <48634BC1.8@google.com>	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>	 <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>	 <4863E4C8.9050705@qualcomm.com>	 <6599ad830806261334y6def5f7an57ac8f071a08eb4b@mail.gmail.com> <6599ad830806261417u3015a9b2i6318841de866d768@mail.gmail.com>
In-Reply-To: <6599ad830806261417u3015a9b2i6318841de866d768@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Jun 26, 2008 at 1:34 PM, Paul Menage <menage@google.com> wrote:
>> void get_online_cpus(void)
>> {
>>        might_sleep();
>>        if (cpu_hotplug.active_writer == current)
>>                return;
>>        down_read(&cpu_hotplug.lock);
>> }
>>
>> void put_online_cpus(void)
>> {
>>        if (cpu_hotplug.active_writer == current)
>>                return;
>>        up_read(&cpu_hotplug.lock);
>> }
>>
>> static void cpu_hotplug_begin(void)
>> {
>>        down_write(&cpu_hotplug.lock);
>>        cpu_hotplug.active_writer = current;
>> }
>>
>> static void cpu_hotplug_done(void)
>> {
>>        cpu_hotplug.active_writer = NULL;
>>        up_write(&cpu_hotplug.lock);
>> }
>>
>> I think that combined with moving the async rebuild_sched_domains to a
>> separate thread should solve the problem, but I'm wondering why
>> cpu_hotplug.lock was implemented this way in the first place.
> 
> Oh, I guess that doesn't work because of recursive calls to
> get_online_cpus(). Maybe we need a down_read_recursive() that skips
> ahead of waiting writers if the lock is already held in read mode?

Instead of changing cpu_hotplug locking should we maybe try to avoid using
cgroup_lock in rebuild_sched_domains() ?
There is a comment in cpuset.c that says
 * If a task is only holding callback_mutex, then it has read-only
 * access to cpusets.

I'm not sure if it's still valid. rebuild_sched_domains() only needs read only
access, it does not really modify any cpuset structures.

Max


