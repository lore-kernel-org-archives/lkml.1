Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbYBNTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbYBNTXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYBNTXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:23:07 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:50016 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbYBNTXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:23:06 -0500
Message-Id: <47B44D35.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 14 Feb 2008 12:16:21 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <arjan@infradead.org>,
       <tglx@linutronix.de>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] reworking load_balance_monitor
References: <20080214155724.772744000@chello.nl>
 <20080214121544.941d91f1.pj@sgi.com>
In-Reply-To: <20080214121544.941d91f1.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Feb 14, 2008 at  1:15 PM, in message
<20080214121544.941d91f1.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Peter wrote of:
>> the lack of rd->load_balance.
> 
> Could you explain to me a bit what that means?
> 
> Does this mean that the existing code would, by default (default being
> a single sched domain, covering the entire system's CPUs) load balance
> across the entire system, but with your rework, not so load balance
> there?  That seems unlikely.
> 
> In any event, from my rather cpuset-centric perspective, there are only
> two common cases to consider.
> 
>  1. In the default case, build_sched_domains() gets called once,
>     at init, with a cpu_map of all non-isolated CPUs, and we should
>     forever after load balance across all those non-isolated CPUs.
> 
>  2. In some carefully managed systems using the per-cpuset
>     'sched_load_balance' flags, we tear down that first default
>     sched domain, by calling detach_destroy_domains() on it, and we
>     then setup some number of sched_domains (typically in the range
>     of two to ten, though I suppose we should design to scale to
>     hundreds of sched domains, on systems with thousands of CPUs)
>     by additional calls to build_sched_domains(), such that their
>     CPUs don't overlap (pairwise disjoint) and such that the union
>     of all their CPUs may, or may not, include all non-isolated CPUs
>     (some CPUs might be left 'out in the cold', intentionally, as
>     essentially additional isolated CPUs.)  We would then expect load
>     balancing within each of these pair-wise disjoint sched domains,
>     but not between one of them and another.


Hi Paul,
  I think it will still work as you describe.  We create a new root-domain object for each pair-wise disjoint sched-domain.  In your case (1) above, we would only have one instance of a root-domain which contains (of course) a single instance of the rd->load_balance object.  This would, in fact operate like the global variable that Peter is suggesting it replace (IIUC).  However, for case (2), we would instantiate a root-domain object per pairwise-disjoint sched-domain, and therefore each one would have its own instance of rd->load_balance.

HTH
-Greg
