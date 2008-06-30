Return-Path: <linux-kernel-owner+w=401wt.eu-S1763778AbYF3Tth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763778AbYF3Tth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYF3Tt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:49:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18666 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYF3Tt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:49:28 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5328"; a="4340367"
Message-ID: <486938C1.90907@qualcomm.com>
Date: Mon, 30 Jun 2008 12:49:21 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: heiko.carstens@de.ibm.com, oleg@tv-sign.ru, akpm@linux-foundation.org,
       ego@in.ibm.com, menage@google.com, peterz@infradead.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] S390 topology: don't use kthread() for arch_reinit_sched_domains()
References: <20080629165132.GA11218@tv-sign.ru>	<20080630134537.GC7686@osiris.boeblingen.de.ibm.com>	<48692D7C.10403@qualcomm.com> <20080630143334.66033f60.pj@sgi.com>
In-Reply-To: <20080630143334.66033f60.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> we either have to ... or change arch_init_sched_domains() to no destroy 
>> current domains.
> 
> I might be misreading this, but I doubt that just not destroying
> current domains is an option.  Once any CPU goes on or off line, the
> only way back to the new correct sched domain configuration is via the
> rebuild_sched_domains() routine in kernel/cpuset.c.
> 

Despite all the typos and missing words you read it correctly :). Here 
is what I'm thinking.
When a CPU goes off line overall partitioning does not change we just 
need to update current domains and remove the CPU that is no longer 
available. When a CPU goes online it always ends up in the root cpuset, 
which means it can be added to the first load-balanced sched domain.

In other words I'm thinking of simulating what rebuild_sched_domains() 
would've done on hotplug events and calling partition_sched_domains() 
directly from sched cpu hotplug code.
That way we can avoid cpuset/cgroup locking in that path.
Now, I haven't really looked into details. Maybe it's not feasible. In 
which case Paul M.'s new locking scheme is the way to go.

Max
