Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYBNSQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYBNSQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYBNSPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:15:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47526 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752103AbYBNSPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:15:52 -0500
Date: Thu, 14 Feb 2008 12:15:44 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: vatsa@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, arjan@infradead.org,
       mingo@elte.hu, tglx@linutronix.de, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC][PATCH 0/2] reworking load_balance_monitor
Message-Id: <20080214121544.941d91f1.pj@sgi.com>
In-Reply-To: <20080214155724.772744000@chello.nl>
References: <20080214155724.772744000@chello.nl>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote of:
> the lack of rd->load_balance.

Could you explain to me a bit what that means?

Does this mean that the existing code would, by default (default being
a single sched domain, covering the entire system's CPUs) load balance
across the entire system, but with your rework, not so load balance
there?  That seems unlikely.

In any event, from my rather cpuset-centric perspective, there are only
two common cases to consider.

 1. In the default case, build_sched_domains() gets called once,
    at init, with a cpu_map of all non-isolated CPUs, and we should
    forever after load balance across all those non-isolated CPUs.

 2. In some carefully managed systems using the per-cpuset
    'sched_load_balance' flags, we tear down that first default
    sched domain, by calling detach_destroy_domains() on it, and we
    then setup some number of sched_domains (typically in the range
    of two to ten, though I suppose we should design to scale to
    hundreds of sched domains, on systems with thousands of CPUs)
    by additional calls to build_sched_domains(), such that their
    CPUs don't overlap (pairwise disjoint) and such that the union
    of all their CPUs may, or may not, include all non-isolated CPUs
    (some CPUs might be left 'out in the cold', intentionally, as
    essentially additional isolated CPUs.)  We would then expect load
    balancing within each of these pair-wise disjoint sched domains,
    but not between one of them and another.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
