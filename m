Return-Path: <linux-kernel-owner+w=401wt.eu-S1765402AbXGaQP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765402AbXGaQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759887AbXGaQOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:14:53 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:22610 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752930AbXGaQOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:14:51 -0400
Message-Id: <46AF2756.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 31 Jul 2007 12:14:45 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/2][RFC] VFCIPI v3
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
 <1185891957.12034.12.camel@twins> <46AF1DA6.BA47.005A.0@novell.com>
 <1185896412.12034.17.camel@twins>
In-Reply-To: <1185896412.12034.17.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jul 31, 2007 at 11:40 AM, in message <1185896412.12034.17.camel@twins>,
Peter Zijlstra <peterz@infradead.org> wrote: 
> On Tue, 2007-07-31 at 11:33 -0400, Gregory Haskins wrote:
>> 
>> If there was anything more than what you already mention here, please
>> point them out so I don't "port" them over to the workqueues
>> implemenation ;)
> 
> The two that jumped out at me while skimming over the code were:
> 
>  - use of raw_spinlock_t (while not always a bug, it does need _very_
>    good justification)

Ah, yes.  This was done on purpose based on the design parameters.  I needed the calls to work from atomic context (which smp_call_function() often is called under).  However, note that I am sensitive to the impact this decision causes and you will see that the lock scopes are all very tight and light (at least, IMHO).

>  - not cpu hotplug safe

Yeah, agreed.  I was aware of this potential race against the "for_each_online_cpu()".   However, I am not knowledgeable enough (yet) to have even attempted a cursory stab at how to support the notification mechanism, so I just left the gaping hole.   It will definitely need to be addressed before any serious merge consideration for whatever final form this thing takes.  I should have commented that.


> 
> The thing is, we should never need to allocate from a real atomic
> context

I agree with you on principle.  Making unnecessary external calls within a lock scope should always be avoided when possible.  However, in this case I had the following design parameters:

1) "heap" allocations over something like static/stack allocations allowed a higher degree of parallelization while supporting asynchronous calls, which was an existing feature of smp_call().

2) The context in which the function could be invoked is beyond my control, and is often atomic.

> every time you end up in that situation, ask yourself if the
> problem can be solved differently. 

Ah, but it was.  I wrote my own cheeseball heap manager ;)  And it was nicely abstracted and conditionally compiled in case GFP_ATOMIC (or equivalent) ever popped up on the radar.

The fact is, when deciding between finer grained parallelism and managing a simple heap myself....the heap code really isn't rocket science ;)

Out of curiosity and for my own edification:  What *is* GFP_ATOMIC meant for?

Regards,
-Greg


