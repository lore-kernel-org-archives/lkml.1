Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbXKFKIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbXKFKIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXKFKIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:08:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbXKFKIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:08:12 -0500
Message-ID: <47303D07.4050404@redhat.com>
Date: Tue, 06 Nov 2007 05:08:07 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Don Porter <porterde@cs.utexas.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Optimize zone allocator synchronization
References: <20071104195212.GF16354@olive-green.cs.utexas.edu>
In-Reply-To: <20071104195212.GF16354@olive-green.cs.utexas.edu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don Porter wrote:
> From: Donald E. Porter <porterde@cs.utexas.edu>
> 
> In the bulk page allocation/free routines in mm/page_alloc.c, the zone
> lock is held across all iterations.  For certain parallel workloads, I
> have found that releasing and reacquiring the lock for each iteration
> yields better performance, especially at higher CPU counts.  For
> instance, kernel compilation is sped up by 5% on an 8 CPU test
> machine.  In most cases, there is no significant effect on performance
> (although the effect tends to be slightly positive).  This seems quite
> reasonable for the very small scope of the change.
> 
> My intuition is that this patch prevents smaller requests from waiting
> on larger ones.  While grabbing and releasing the lock within the loop
> adds a few instructions, it can lower the latency for a particular
> thread's allocation which is often on the thread's critical path.
> Lowering the average latency for allocation can increase system throughput.
> 
> More detailed information, including data from the tests I ran to
> validate this change are available at
> http://www.cs.utexas.edu/~porterde/kernel-patch.html .
> 
> Thanks in advance for your consideration and feedback.

That's an interesting insight.  My intuition is that Nick Piggin's 
recently-posted ticket spinlocks patches[1] will reduce the need for this patch, 
though it may be useful to have both.  Can you benchmark again with only ticket 
spinlocks, and with ticket spinlocks + this patch?  You'll probably want to use 
2.6.24-rc1 as your baseline, due to the x86 architecture merge.

	-- Chris

[1] http://lkml.org/lkml/2007/11/1/123
