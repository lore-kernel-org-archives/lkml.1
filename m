Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0BPFkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:40:06 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40293 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0BPFkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:40:03 -0500
Date: Tue, 16 Feb 2010 11:09:46 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC PATCH v1 0/4] CFS Bandwidth Control
Message-ID: <20100216053946.GA3492@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 06:54:52PM -0800, Paul Turner wrote:
> 
> The skeleton of our approach is as follows:
> - As above we maintain a global pool, per-tg, pool of unassigned quota.  On it
>   we track the bandwidth period, quota per period, and runtime remaining in
>   the current period.  As bandwidth is used within a period it is decremented
>   from runtime.  Runtime is currently synchronized using a spinlock, in the
>   current implementation there's no reason this couldn't be done using
>   atomic ops instead however the spinlock allows for a little more flexibility
>   in experimentation with other schemes.
> - When a cfs_rq participating in a bandwidth constrained task_group executes
>   it acquires time in sysctl_sched_cfs_bandwidth_slice (default currently
>   10ms) size chunks from the global pool, this synchronizes under rq->lock and
>   is part of the update_curr path.
> - Throttled entities are dequeued immediately (as opposed to delaying this
>   operation to the put path), this avoids some potentially poor load-balancer
>   interactions and preserves the 'verbage' of the put_task semantic.
>   Throttled entities are gated from participating in the tree at the
>   {enqueue, dequeue}_entity level.  They are also skipped for load
>   balance in the same manner as Bharatta's patch-series employs.

I did defer the dequeue until next put because walking the se hierarchy
multiple times (from update_curr -> dequeue_entity -> update_curr) appeared
too complex when I started with it.

> 
> Interface:
> ----------
> Two new cgroupfs files are added to the cpu subsystem:
> - cpu.cfs_period_us : period over which bandwidth is to be regulated
> - cpu.cfs_quota_us  : bandwidth available for consumption per period
> 
> One important interface change that this introduces (versus the rate limits
> proposal) is that the defined bandwidth becomes an absolute quantifier.
> 
> e.g. a bandwidth of 5 seconds (cpu.cfs_quota_us=5000000) on a period of 1 second
> (cpu.cfs_period_us=1000000) would result in 5 wall seconds of cpu time being
> consumable every 1 wall second.

As I have said earlier, I would like to hear what others say about this
interface. Especially from Linux-vserver project since it is already
using the cfs hard limit patches in their test release. Herbert ?

Thanks for your work. More later when I review the individual patches
in detail.

Regards,
Bharata.
