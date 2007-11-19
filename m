Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbXKSOud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbXKSOud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbXKSOuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:50:25 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49219 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXKSOuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:50:25 -0500
Date: Mon, 19 Nov 2007 20:33:12 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] sched: Improve fairness of cpu allocation for task groups
Message-ID: <20071119150312.GA2365@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119131201.GB31491@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 02:12:01PM +0100, Ingo Molnar wrote:
> >  include/linux/sched.h |    4 
> >  kernel/sched.c        |  292 +++++++++++++++++++++++++++++++++++++++++++++-----
> >  kernel/sched_fair.c   |   95 ++++++++++------
> >  kernel/sched_rt.c     |    2 
> >  kernel/sysctl.c       |   16 ++
> >  5 files changed, 348 insertions(+), 61 deletions(-)
> 
> i'm leaning towards making this v2.6.25 material, as it affects the 
> non-group-scheduling bits too and is rather large. When i tested it, 
> group scheduling worked pretty well - at least for CPU bound tasks - and 
> on SMP too. Could we live with what we have for now and defer this patch 
> to v2.6.25?

Hi Ingo,
	I would prefer this to go in 2.6.24 if possible. 2.6.24 would be the
first kernel to support a group scheduler in its entirety (user interface +
related support in scheduler) and also that works reasonably well :) It would 
also give me early test feedback.

> If not, could you split up this patch in a way to defer all 
> the FAIR_GROUP_SCHED relevant changes to a separate patch which will not 
> affect the !FAIR_GROUP_SCHED case at all? That will make the case much 
> clearer.

>From my inspection, here are the changes introduced by this patch
for !CONFIG_FAIR_GROUP_SCHED case:

- inc/dec_load() takes a load input instead of task pointer input as their
  2nd arg
- inc/dec_nr_running don't call inc/dec_load. Instead,
- enqueue/dequeue_task class callbacks call inc/dec_load
- [Unintended/will-fix change] min/max tunables added in
  /proc/sys/kernel

All of above changes (except last, which I will fix) should have zero
functional+runtime effect for !CONFIG_FAIR_GROUP_SCHED case. So I don't see how
I can split Patch 2/2 further.

Or do you prefer I introduce #ifdef's such that even these minor changes to 
inc/dec_load are avoided for !CONFIG_FAIR_GROUP_SCHED case? That would
make the code slightly ugly I suspect.

-- 
Regards,
vatsa
