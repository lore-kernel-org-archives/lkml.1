Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbZFWPVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbZFWPVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZFWPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:21:32 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:38620 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbZFWPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:21:31 -0400
X-IronPort-AV: E=Sophos;i="4.42,276,1243807200"; 
   d="scan'208";a="28605845"
Message-ID: <4A40F31F.4030609@inria.fr>
Date: Tue, 23 Jun 2009 17:22:07 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu>
In-Reply-To: <20090623143601.GA13415@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., it might make sense to expose NUMA inbalance via generic 
> enumeration. Right now we have:
>
>         PERF_COUNT_HW_CPU_CYCLES                = 0,
>         PERF_COUNT_HW_INSTRUCTIONS              = 1,
>         PERF_COUNT_HW_CACHE_REFERENCES          = 2,
>         PERF_COUNT_HW_CACHE_MISSES              = 3,
>         PERF_COUNT_HW_BRANCH_INSTRUCTIONS       = 4,
>         PERF_COUNT_HW_BRANCH_MISSES             = 5,
>         PERF_COUNT_HW_BUS_CYCLES                = 6,
>
> plus we have cache stats:
>
>  * Generalized hardware cache counters:
>  *
>  *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
>  *       { read, write, prefetch } x
>  *       { accesses, misses }
>   

By the way, is there a way to know which cache was actually used when we
request cache references/misses? Always the largest/top one by default?

> NUMA is here to stay, and expressing local versus remote access 
> stats seems useful. We could add two generic counters:
>
>         PERF_COUNT_HW_RAM_LOCAL                 = 7,
>         PERF_COUNT_HW_RAM_REMOTE                = 8,
>
> And map them properly on all CPUs that support such stats. They'd be 
> accessible via '-e ram-local-refs' and '-e ram-remote-refs' type of 
> event symbols.
>
> What is your typical usage pattern of this counter? What (general) 
> kind of app do you profile with it and how do you make use of the 
> specific node masks?
>
> Would a local/all-remote distinction be enough, or do you need to 
> make a distinction between the individual nodes to get the best 
> insight into the workload?
>   

People here work on OpenMP runtime systems where you try to keep threads
and data together. So in the end, what's important is to maximize the
overall local/remote access ratio. But during development, it may useful
to have a distinction between individual nodes so as to understand
what's going on. That said, we still have raw numbers when we really
need that many details, and I don't know if it'd be easy for you to add
a generic counter with a sort of node-number attribute.


(including part of your other email here since it's relevant)

> How many threads does your workload typically run, and how do you 
> get their stats displayed?
>   

In the aforementioned OpenMP stuff, we use pfmon to get the local/remote
numa memory access ratio of each thread. In this specific case, we bind
one thread per core (even with a O(1) scheduler, people tend to avoid
launching hundreds of threads on current machines). pfmon gives us
something similar to the output of 'perf stat' in a file whose filename
contains process and thread IDs. We apply our own custom script to
convert these many pfmon output files into a single summary saying for
each thread, its thread ID, its core binding, its individual numa node
access numbers and percentages, and if they were local or remote (with
the Barcelona counters we were talking about, you need to check where
you were running before you know if accesses to node X are actually
local or remote accesses).

thanks,
Brice

