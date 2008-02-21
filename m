Return-Path: <linux-kernel-owner+w=401wt.eu-S1764975AbYBUG40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764975AbYBUG40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYBUG4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:56:11 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:39397 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753506AbYBUG4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:56:09 -0500
Message-ID: <47BD1F75.5030506@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 12:21:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu>
In-Reply-To: <20080221060427.GA9159@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> __pick_last_entity() walks the entire tree on O(lgn) time to find the 
>> rightmost entry. This patch makes the routine more efficient by 
>> reducing the cost of the lookup
> 
> hm, i'm not sure we want to do this: we'd be slowing down the fastpath 
> of all the other common scheduler functions, for the sake of a rarely 
> used (and broken ...) API: yield. And note that an rbtree walk is not 
> slow at all - if you are yielding frequently it's probably all cached.
> 
> 	Ingo

Ingo,

I disagree. The cost is only adding a field to cfs_rq and we already have the
logic to track the leftmost node, we just update the rightmost node as well.
For a large number of tasks - say 10000, we need to walk 14 levels before we
reach the node (each time). Doesn't matter if the data is cached, we are still
spending CPU time looking through pointers and walking to the right node. If all
the threads get a chance to run, you can imagine the effect it has on efficiency
and the data cache.

I see a boost in sched_yield performance and no big hit on regular performance.
Could you please test it to see if your apprehensions are correct.

PS: You missed to add me on the cc/to list.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
