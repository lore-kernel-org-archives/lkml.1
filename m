Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYAOWHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYAOWHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbYAOWG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:06:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbYAOWG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:06:56 -0500
Date: Tue, 15 Jan 2008 23:06:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Colin Fowler <elethiomel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive
	benchmark on 8 Core Xeon
Message-ID: <20080115220641.GC2665@elte.hu>
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com> <20080114185520.GA26540@elte.hu> <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com> <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Colin Fowler <elethiomel@gmail.com> wrote:

> These data may be much better for you. It's a single 15 second data 
> collection run only when the actual ray-tracing is happening. These 
> data do not therefore cover the data structure building phase.
> 
> http://vangogh.cs.tcd.ie/fowler/cfs2/

hm, the system has considerable idle time left:

 r  b swpd   free   buff  cache   si so  bi bo   in    cs  us sy id wa
 8  0    0 1201920 683840 1039100  0  0   3  2   27    46   1  0 99  0
 2  0    0 1202168 683840 1039112  0  0   0  0  245 45339  80  2 17  0
 2  0    0 1202168 683840 1039112  0  0   0  0  263 47349  84  3 14  0
 2  0    0 1202300 683848 1039112  0  0   0 76  255 47057  84  3 13  0

and context-switches 45K times a second. Do you know what is going on 
there? I thought ray-tracing is something that can be parallelized 
pretty efficiently, without having to contend and schedule too much.

could you try to do a similar capture on 2.6.22 as well (under the same 
phase of the same workload), as comparison?

there are a handful of 'scheduler feature bits' in 
/proc/sys/kernel/sched_features:

enum {
        SCHED_FEAT_NEW_FAIR_SLEEPERS    = 1,
        SCHED_FEAT_WAKEUP_PREEMPT       = 2,
        SCHED_FEAT_START_DEBIT          = 4,
        SCHED_FEAT_TREE_AVG             = 8,
        SCHED_FEAT_APPROX_AVG           = 16,
};

const_debug unsigned int sysctl_sched_features =
                SCHED_FEAT_NEW_FAIR_SLEEPERS    * 1 |
                SCHED_FEAT_WAKEUP_PREEMPT       * 1 |
                SCHED_FEAT_START_DEBIT          * 1 |
                SCHED_FEAT_TREE_AVG             * 0 |
                SCHED_FEAT_APPROX_AVG           * 0;

[as of 2.6.24-rc7]

could you try to turn some of them off/on. In particular toggling 
WAKEUP_PREEMPT might have an effect, and NEW_FAIR_SLEEPERS might have an 
effect as well. (TREE_AVG and APPROX_AVG has probably little effect)

other debug-tunables you might want to look into are in the 
/proc/sys/kernel/sched_domains hierarchy.

also, if you toggle:

  /sys/devices/system/cpu/sched_mc_power_savings

does that change the results?

	Ingo
