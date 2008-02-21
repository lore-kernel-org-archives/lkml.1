Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbYBUWNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbYBUWNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbYBUWMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:12:53 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49429 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbYBUWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:12:52 -0500
Subject: Re: [PATCH [RT] 00/14] RFC - adaptive real-time locks
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, mkohari@novell.com
In-Reply-To: <20080221212420.GA20953@elte.hu>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221212420.GA20953@elte.hu>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 21 Feb 2008 15:12:46 -0700
Message-Id: <1203631966.4232.62.camel@hermosa.morrealenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 22:24 +0100, Ingo Molnar wrote:
> hm. Why is the ticket spinlock patch included in this patchset? It just 
> skews your performance results unnecessarily. Ticket spinlocks are 
> independent conceptually, they are already upstream in 2.6.25-rc2 and 
> -rt will have them automatically once we rebase to .25.
> 

True, the ticket spinlock certainly adds to the throughput results we
have seen.  However, the results without the ticket patch are still very
significant.   (IIRC, 500-600MB/s instead of the ~730MB/s advertised) We
can easily re-gen the previous results for an apples-to-apples
comparison.

Without the ticket locks we see spikes in cyclictest that have been
mapped (via latency trace) to the non-deterministic behavior of the raw
rt lock "wait_lock" (which is used in the rt lock code).   These spikes
disappear with the ticket lock patch installed. 

Note that we see these spikes while running cyclictest concurrently with
dbench/hackbench/kernel builds.  

> and if we take the ticket spinlock patch out of your series, the the 
> size of the patchset shrinks in half and touches only 200-300 lines of 
> code ;-) Considering the total size of the -rt patchset:
> 
>    652 files changed, 23830 insertions(+), 4636 deletions(-)
> 
> we can regard it a routine optimization ;-)
> 
> regarding the concept: adaptive mutexes have been talked about in the 
> past, but their advantage is not at all clear, that's why we havent done 
> them. It's definitely not an unambigiously win-win concept.
> 

Can you elaborate?  Where did you previously see that this would be
problematic?

> So lets get some real marketing-free benchmarking done, and we are not 
> just interested in the workloads where a bit of polling on contended 
> locks helps, but we are also interested in workloads where the polling 
> hurts ... And lets please do the comparisons without the ticket spinlock 
> patch ...
> 
> 	Ingo

Certainly.  One of the things we have struggled with are real-world
loads that prove/disprove the implementation.  Thus far, everything we
have come up with has only seen improvement.  

The worst case we have come up with so far is running dbench/hackbench
in FIFO.  Here we have multiple tasks at the same priority contending on
the same locks.  This should give a worst case performance since the
tasks cannot preempt each other, and the nesting of locks should produce
significant latencies.  However, with the addition of the lateral-steal
patch, we do not witness that at all, rather the throughput is on par
with CFS results.

Higher priority FIFO tasks will preempt the polling tasks, and the lower
priority tasks will wait, as they should.

Are there some suggestions on workloads that would show how the polling
hurts?  

Thanks,
-PWM


