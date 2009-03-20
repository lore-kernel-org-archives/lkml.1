Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZCTFHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZCTFHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZCTFHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:07:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60383 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZCTFHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:07:36 -0400
Date: Thu, 19 Mar 2009 21:40:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Avi Kivity <avi@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
Message-ID: <20090320044029.GD6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49C148AF.5050601@goop.org> <200903191232.05459.nickpiggin@yahoo.com.au> <49C2818B.9060201@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2818B.9060201@goop.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:31:55AM -0700, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
>>> Also, assuming that disabling the interrupt is enough to get the
>>> guarantees we need here, there's a Xen problem because we don't use IPIs
>>> for cross-cpu tlb flushes (well, it happens within Xen).  I'll have to
>>> think a bit about how to deal with that, but I'm thinking that we could
>>> add a per-cpu "tlb flushes blocked" flag, and maintain some kind of
>>> per-cpu deferred tlb flush count so we can get around to doing the flush
>>> eventually.
>>>
>>> But I want to make sure I understand the exact algorithm here.
>>
>> FWIW, powerpc actually can flush tlbs without IPIs, and it also has
>> a gup_fast. powerpc RCU frees its page _tables_ so we can walk them,
>> and then I use speculative page references in order to be able to
>> take a reference on the page without having it pinned.
>
> Ah, interesting.  So disabling interrupts prevents the RCU free from 
> happening, and non-atomic pte fetching is a non-issue.  So it doesn't 
> address the PAE side of the problem.

This would be rcu_sched, correct?

							Thanx, Paul

>> Turning gup_get_pte into a pvop would be a bit nasty because on !PAE
>> it is just a single load, and even on PAE it is pretty cheap.
>>   
>
> Well, it wouldn't be too bad; for !PAE it would turn into something we 
> could inline, so there'd be little to no cost.  For PAE it would be out of 
> line, but a direct function call, which would be nicely cached and very 
> predictable once we've gone through the the loop once (and for Xen I think 
> I'd just make it a cmpxchg8b-based implementation, assuming that the tlb 
> flush hypercall would offset the cost of making gup_fast a bit slower).
>
> But it would be better if we can address it at a higher level.
>
>    J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
