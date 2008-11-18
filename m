Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbYKRHdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbYKRHdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKRHdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:33:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:4111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYKRHdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:33:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=rbHuWGweW235S6kX+w1QKR/6TixRuBOrb/oW95And0w2rdMgI56i6B37bHE1Biubq
	Gai+kXsCPZRnMC+OfnuSA==
MIME-Version: 1.0
In-Reply-To: <1226985548.29743.6.camel@lappy.programming.kicks-ass.net>
References: <20081115011452.GA28135@google.com> <49218FB4.6090805@nortel.com>
	 <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
	 <4921DFD8.9060509@nortel.com>
	 <1226985548.29743.6.camel@lappy.programming.kicks-ass.net>
Date: Mon, 17 Nov 2008 23:33:05 -0800
Message-ID: <b040c32a0811172333k5a89ccfy6438bf66d32dca5d@mail.gmail.com>
Subject: Re: busted CFS group load balancer?
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Friesen <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 9:19 PM, Peter Zijlstra wrote:
> Note that with larger cpu count and/or lower group weight we'll quickly
> run into numerical trouble...
>
> I would recommend trying this with the minimum weight in the order of
> 8-16 times number of cpus on your system.
>
> There is only so much one can do with 10 bit fixed precision math :/

That is probably one of the many problems.  I also found that the
updates to the per-cpu task_group's sched_entity load weight
(tg->se[cpu]->load.weight) is very problematic and very erratic.

The total rq_weight is calculated at one beginning of tg_shares_up(),

        for_each_cpu_mask(i, sd->span) {
                rq_weight += tg->cfs_rq[i]->load.weight;
                shares += tg->cfs_rq[i]->shares;
        }

However, the scaling of per-cpu se->load.weight in function
__update_group_shares_cpu() takes another lookup of
tg->cfs_rq[cpu]->load.weight at a different time.
cfs_rq[cpu].load.weight aren't always consistent across these two
times.  Due to these inconsistency of value taken on per cpu cfs_rq,
I've see tg->se[cpu]->load.weight jumping all over the place.  In our
environment, the cpu loads are very dynamic.  Process
queuing/dequeuing at high rate.

I'm also very troubled with this calculation in __update_group_shares_cpu():

        shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);

Won't you have rounding problem here?  value 'shares' will gradually
decrease for each iteration of __update_group_shares_cpu()?

- Ken
