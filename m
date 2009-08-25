Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZHYIwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZHYIwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZHYIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:52:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:10081
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751851AbZHYIwY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:52:24 -0400
X-SpamScore: -10
X-BigFish: VPS-10(z46fm34a4jz1432R98dN936eMa594izz1202hzzz32i6bh203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KOXCMT-02-6J5-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 10:51:24 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/15] sched: Pass unlimited __cpu_power information to
	upper domain level groups
Message-ID: <20090825085124.GF20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134155.GZ29327@alberich.amd.com> <1251127297.7538.291.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251127297.7538.291.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 08:51:25.0326 (UTC) FILETIME=[3A46E2E0:01CA2561]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:21:37PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:41 +0200, Andreas Herrmann wrote:
> > For performance reasons __cpu_power in a sched_group might be limited
> > such that the group can handle only one task. To correctly calculate
> > the capacity in upper domain level groups the unlimited power
> > information is required. This patch stores unlimited __cpu_power
> > information in sched_groups.orig_power and uses this when calculating
> > __cpu_power in upper domain level groups.
> 
> OK, so this tries to fix the cpu_power wreckage?

Not completely. Just (partially) for my MN domain needs.

> ok, so let me try this with an example:
> 
> Suppose we have a dual-core with shared cache and SMT
> 
>   0-3     MC
> 0-1 2-3   SMT
> 
> Then both levels fancy setting SHARED_RESOURCES and both levels end up
> normalizing the cpu_power to 1, so when we unplug cpu 2, load-balancing
> gets all screwy because the whole system doesn't get normalized
> properly.

So normalization is broken already, right?

In case of sched_smt_power_savings we have 1024 as __cpu_power for
each SMT sched_group. And at MC level we have always 2048 as long as
we have two sched_groups in the SMT level.

> What you propose here is every time we muck with cpu_power we keep the
> real stuff in orig_power and use that to compute the level above.

Yes.

> Except you don't use it in the load-balancer proper, so normalization is
> still hosed.

Yes, the normalization problem that you've mentioned is not fixed by that.
But it might be advisable to fix it.

> Its a creative solution, but I'd rather see cpu_power returned to a
> straight sum of actual power to normalize the inter-cpu runqueue weights
> and do the placement decision using something else.

This means not to artificially restrict __cpu_power to 1024 for performance
scheduling?

Seconded.
But I don't have an impromptu patch for this. ;-(


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


