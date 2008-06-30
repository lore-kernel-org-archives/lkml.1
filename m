Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbYF3Urh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbYF3Urh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbYF3Ur1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:47:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60647 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbYF3Ur0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:47:26 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5328"; a="4342469"
Message-ID: <48694659.2040709@qualcomm.com>
Date: Mon, 30 Jun 2008 13:47:21 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: heiko.carstens@de.ibm.com, oleg@tv-sign.ru, akpm@linux-foundation.org,
       ego@in.ibm.com, menage@google.com, peterz@infradead.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] S390 topology: don't use kthread() for arch_reinit_sched_domains()
References: <20080629165132.GA11218@tv-sign.ru>	<20080630134537.GC7686@osiris.boeblingen.de.ibm.com>	<48692D7C.10403@qualcomm.com>	<20080630143334.66033f60.pj@sgi.com>	<486938C1.90907@qualcomm.com> <20080630152838.e793cb10.pj@sgi.com>
In-Reply-To: <20080630152838.e793cb10.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> When a CPU goes off line overall partitioning does not change we just 
>> need to update current domains and remove the CPU that is no longer 
>> available.
> 
> I don't believe that this is correct.
> 
> If one had say just the following three cpusets in a system:
> 
> 	/dev/cpuset		# sched_load_balance == 0
> 	/dev/cpuset/alpha	# sched_load_balance == 1
> 	/dev/cpuset/beta	# sched_load_balance == 1
> 
> where the 'cpus' of alpha and beta overlapped by a single CPU,
> and if one then took that single CPU offline, then the overall
> partitioning of the system would change, from a single sched
> domain covering the combined 'cpus' of alpha and beta, to two
> separate sched domains, handling the 'cpus' of alpha and beta
> separately.
> 
>> When a CPU goes online it always ends up in the root cpuset, 
>> which means it can be added to the first load-balanced sched domain.
> 
> Also not correct, but at least in this case, one might be able
> to avoid doing a full fledged 'rebuild_sched_domains()' call,
> by the following reasoning.
> 
>     When bringing CPUs online, either the top cpuset has
>     sched_load_balance set (1) or off (0).  If it is set, then one
>     has a single sched domain covering all online CPUs, and yes one
>     could just add the new CPU to that sched domain.  If off, then
>     the newly online CPU would only be in the top cpuset, which does
>     not by itself put that CPU in any sched domain, and that new CPU
>     should not be added to -any- cpuset.
> 
> However, since we have to handle the offline case as well as the online
> case, and since that case requires (to the best of my understanding)
> calling rebuild_sched_domains(), I think it is best to just call that
> routine in all cases.
> 
> An earlier version of this sched domain code always attempted to
> incrementally adjust sched domains to online and offline events,
> and that code ended up being a maintenance nightmare.  I will be most
> reluctant to attempt to go back to such calculations.

Makes perfect sense. Thanx for the explanation. You've just saved me a 
bunch of time :). I'll give up on that idea then and instead will go and 
play with Paul M.'s latest patch.

btw We should update s390 to not call arch_init_sched_domains() directly 
once we know that rebuild_sched_domains() is safe to call from most 
contexts.

Max





