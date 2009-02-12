Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZBLJLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZBLJLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 04:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZBLJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 04:11:36 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:40225 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZBLJLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 04:11:34 -0500
X-SourceIP: 213.46.9.244
Subject: Re: Time slice for SCHED_BATCH ( CFS)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: J K Rai <jk.anurag@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <441046.97200.qm@web94712.mail.in2.yahoo.com>
References: <315626.71453.qm@web94713.mail.in2.yahoo.com>
	 <20090211102024.GI20518@elte.hu> <1234348436.23438.119.camel@twins>
	 <303179.28635.qm@web94707.mail.in2.yahoo.com>
	 <1234357350.23438.149.camel@twins>
	 <441046.97200.qm@web94712.mail.in2.yahoo.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 10:13:31 +0100
Message-Id: <1234430011.23438.200.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 11:17 +0530, J K Rai wrote:
> 
> May I have little more clarification on this:
>  
> latency := 20ms * (1 + log2(nr_cpus))
> min_granularity := 4ms * (1 + log2(nr_cpus))
> nr_latency := floor(latency / min_granularity)
> 
> 1) In above the 20ms and 4 ms seems to be the default values of
> sched_latency_ns and sched_min_granularity_ns, that means if we change
> them thru sysctl -w then we should keep those changed values in the
> above relationship in place of 20ms and 4 ms. Am I correct?

Yes, sysctl setting replaces the whole expression, that is, including
the log2 cpu factor.

> 2) What exactly or tentatively  we signify by latency, min_granularity
> and nr_latency?

latency -- the desired scheduling latency of applications on low/medium
load machines (20ms is around the human observable).

min_granularity -- since we let slices get smaller the more tasks there
are in roughly: latency/nr_running fashion, we want to avoid them
getting too small. min_granularity provides a lower bound.

nr_latency -- the cut off point where we let go of the desired
scheduling latency and start growing linearly.

>         latency ; nr_running <= nr_latency
> period = {
>           nr_running * min_granularity ; nr_running > nr_latency
> 
> slice = task_weight * period / runqueue_weight
> 
> 
> 3) Here in above, what is meant by task_weight and runqueue_weight ?

Since CFS is a proportional weight scheduler, each task is assigned a
relative weight. Two tasks with weight 1 will get similar amounts of cpu
time, a weight ratio of 1:2 will get the former task half as much cpu
time as the latter.

The runqueue weight is the sum of all task weights.

> Load-balancing of course makes this an even more interesting thing.
> 
> 4) Can we say something more about load-balancing effect on
> time-slice. 
> How the load-balancing works at present, is it by making the trees of
> equal hight / no of elements?

Well, load balancing just moves tasks around trying to ensure the sum of
weights on each cpu is roughly equal, the slice calculation is done with
whatever is present on a single cpu.

