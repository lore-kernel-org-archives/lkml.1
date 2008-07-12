Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYGLWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYGLWsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYGLWsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:48:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8741 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbYGLWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:48:37 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5337"; a="4664565"
Message-ID: <487934C6.9060802@qualcomm.com>
Date: Sat, 12 Jul 2008 15:48:38 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: a.p.zijlstra@chello.nl, pj@sgi.com, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] CGroups: Add a per-subsystem hierarchy lock
References: <20080627075912.92AE43D6907@localhost>	 <6599ad830806271702y2c1df2edh3a75dda75336ddad@mail.gmail.com>	 <486AFC33.7010901@qualcomm.com>	 <6599ad830807021531r16013460re28f813be8293d6c@mail.gmail.com>	 <486C59BE.3020400@qualcomm.com> <6599ad830807101732w43e09514t281455861da53bad@mail.gmail.com>
In-Reply-To: <6599ad830807101732w43e09514t281455861da53bad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Jul 2, 2008 at 9:46 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> mkdir /dev/cpuset
>> mount -t cgroup -o cpuset cpuset /dev/cpuset
>> mkdir /dev/cpuset/0
>> mkdir /dev/cpuset/1
>> echo 0-2 > /dev/cpuset/0/cpuset.cpus
>> echo 3   > /dev/cpuset/1/cpuset.cpus
>> echo 0 > /dev/cpuset/cpuset.sched_load_balance
>> echo 0 > /sys/devices/system/cpu/cpu3/online
>>
> 
> OK, I still can't reproduce this, on a 2-cpu system using one cpu for
> each cpuset.
> 
> But the basic problem seemns to be that we have cpu_hotplug.lock taken
> at the outer level (when offlining a CPU) and at the inner level (via
> get_online_cpus() called from the guts of partition_sched_domains(),
> if we didn't already take it at the outer level.
Yes. I'm looking at this stuff right now.

> While looking at the code trying to figure out a nice way around this,
> it struck me that we have the call path
> 
> cpuset_track_online_nodes() ->
>   common_cpu_mem_hotplug_unplug() ->
>     scan_for_empty_cpusets() ->
>       access cpu_online_map with no calls to get_online_cpus()
> 
> Is that allowed? Maybe we need separate versions of
> scan_for_empty_cpusets() that look at memory and cpus?
Yes. This also came up in the other discussions. ie That we need to have this
split up somehow. Looks like my fix for domain handling exposed all kinds of
problems that we punted on before :).

> I think that we're going to want eventually a solution such pushing
> the locking of cpuset_subsys.hierarchy_mutex down into the first part
> of partition_sched_domains, that actually walks the cpuset tree
Right now I'm trying to get away with not using new locks. Since we need some
solution for 2.6.26 and new cgroup locking that you added is probably a .27
material.

Max
