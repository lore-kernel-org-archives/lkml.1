Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYHTH0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYHTH0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYHTH0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:26:13 -0400
Received: from mga07.intel.com ([143.182.124.22]:18097 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750766AbYHTH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:26:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,238,1217833200"; 
   d="scan'208";a="35583620"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080818052155.GA5063@linux.vnet.ibm.com>
References: <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com> <1217831171.9016.42.camel@twins>
	 <20080804070508.GA4028@linux.vnet.ibm.com> <1217833939.9016.47.camel@twins>
	 <1912217169.25608.228.camel@ymzhang> <1218180605.8625.64.camel@twins>
	 <20080811185008.GA29291@linux.vnet.ibm.com>
	 <1912726331.25608.235.camel@ymzhang>
	 <20080817115035.GA32223@linux.vnet.ibm.com>
	 <20080818052155.GA5063@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 15:24:49 +0800
Message-Id: <1219217089.8781.27.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-18 at 10:51 +0530, Dhaval Giani wrote: 
> > > > > > So with kernel 2.6.27-rc1, the successful wakeup_affine is about
> > > > > > double of the one of 2.6.27-rc1
> > > > > > on domain 0, but about 10 times on domain 1. That means more tasks are
> > > > > > woken up on waker cpus.
> > > > > > 
> > > > > > Does that mean it doesn't follow cache-hot checking?
> > > > > 
> > > > > I'm a bit puzzled, but you're right - I too noticed that volanomark is
> > > > > _very_ sensitive to affine wakeups.
> > > > > 
> > > > > I'll try and find what changed in that code for GROUP=n.
> > > > 
> > > > hi Yanmin,
> > > > 
> > > > I was wondering if you could send me your config and what sysctls you
> > > > have set. I have not been able to reproduce the 2.6.26 -> 2.6.27-rc1
> > > > GROUP=n regression.
> > > Pls. see the attachment. As for sysctl, I just set /proc/sys/kernel/sched_compat_yield=1.
> > > 
> > > I am wondering if the load balance causes the regression when group=n. I manually delete
> > > all GROUP codes and do a diff against 26 and 27-rc1.
> > > 
> > 
> > You can disable load balancing by being in uniprocessor mode.
> > 
> 
> Hi,
> 
> I can see this regression only with sched_compat_yield=1. Some numbers
> though, I see a 5% regression with max_cpus=1 whereas close to 50% with
> SMP on a 8 way.
After reverting below patch, volanoMark regression becomes less than 2% with CONFIG_GROUP_SCHED=n
on my 8-core stoakely. The improvement on 16-core tigerton is about 44%, but there is still about
 20% regression, comparing with 2.6.26_nogroup.


commit 93b75217df39e6d75889cc6f8050343286aff4a5
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jun 27 13:41:33 2008 +0200

    sched: disable source/target_load bias
    
    The bias given by source/target_load functions can be very large, disable
    it by default to get faster convergence.
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>



This patch adds a new feature LB_BIAS, but uses it with a NOT, so I lost it when I tested
single sched feature one by one. That also explains why wake_affine and load_balance_newidle
have more successful task pulling with kernel 2.6.27-rc, because MC and CPU domain's wake_idx
is 1, so this patch has impact on them.

Dhaval, could you test it on your 8-way machine?

> 
> Peter do you have any patches already, which I can try?
> 
> Thanks,

