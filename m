Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbXFLG2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbXFLG2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbXFLG1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:27:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55243 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbXFLG1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:27:54 -0400
Date: Tue, 12 Jun 2007 08:26:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com,
       Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 0/6] Add group fairness to CFS - v1
Message-ID: <20070612062612.GA19637@elte.hu>
References: <20070611154724.GA32435@in.ibm.com> <20070611193735.GA22152@elte.hu> <20070612055024.GA26957@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612055024.GA26957@in.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Mon, Jun 11, 2007 at 09:39:31PM +0200, Ingo Molnar wrote:
> > i mean bit 6, value 64. I flipped around its meaning in -v17-rc4, so the
> > new precise stats code there is now default-enabled - making SMP
> > load-balancing more accurate.
> 
> I must be missing something here. AFAICS, cpu_load calculation still 
> is timer-interrupt driven in the -v17 snapshot you sent me. Besides, 
> there is no change in default value of bit 6 b/n v16 and v17:
> 
> -unsigned int sysctl_sched_features __read_mostly = 1 | 2 | 4 | 8 | 0 | 0;
> +unsigned int sysctl_sched_features __read_mostly = 0 | 2 | 4 | 8 | 0 | 0;
> 
> So where's this precise stats based calculation of cpu_load?

but there's a change in the interpretation of bit 6:

-       if (!(sysctl_sched_features & 64)) {
-               this_load = this_rq->raw_weighted_load;
+       if (sysctl_sched_features & 64) {
+               this_load = this_rq->lrq.raw_weighted_load;

the update of the cpu_load[] value is timer interrupt driven, but the 
_value_ that is sampled is not. Previously we used ->raw_weighted_load 
(at whatever value it happened to be at the moment the timer irq hit the 
system), now we basically use a load derived from the fair-time passed 
since the last scheduler tick. (Mathematically it's close to an integral 
of load done over that period) So it takes all scheduling activities and 
all load values into account to calculate the average, not just the 
value that was sampled by the scheduler tick.

this, besides being more precise (it for example correctly samples 
short-lived, timer-interrupt-driven workloads too, which were largely 
'invisible' to the previous load calculation method), also enables us to 
make the scheduler tick hrtimer based in the (near) future. (in essence 
making the scheduler tick-less even when there are tasks running)

> Anyway, do you agree that splitting the cpu_load/nr_running fields so 
> that:
> 
> rq->nr_running 	   	  = total count of -all- tasks in runqueue
> rq->raw_weighted_load	  = total weight of -all- tasks in runqueue
> rq->lrq.nr_running 	  = total count of SCHED_NORMAL/BATCH tasks in runqueue
> rq->lrq.raw_weighted_load = total weight of SCHED_NORMAL/BATCH tasks in runqueue
> 
> is a good thing to avoid SCHED_RT<->SCHED_NORMAL/BATCH mixup (as 
> accomplished in Patch #4)?

yes, i agree in general, even though this causes some small overhead. 
This also has another advantage: the inter-policy isolation and load 
balancing is similar to what fair group scheduling does, so even 'plain' 
Linux will use the majority of the framework.

> If you don't agree, then I will make this split dependent on 
> CONFIG_FAIR_GROUP_SCHED

no, i'd rather avoid that #ifdeffery.

> > > Patch 6 hooks up scheduler with container patches in mm (as an 
> > > interface for task-grouping functionality).
> 
> Just to be clear, by container patches, I am referring to "process" 
> container patches from Paul Menage [1]. They aren't necessarily tied 
> to "virtualization-related" container support in -mm tree, although I 
> believe that "virtualization-related" container patches will make use 
> of the same "process-related" container patches for their 
> task-grouping requirements. Phew ..we need better names!

i'd still like to hear back from Kirill & co whether this framework is 
flexible enough for their work (OpenVZ, etc.) too.

	Ingo
