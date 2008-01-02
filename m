Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbYABXfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbYABXfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYABXfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:35:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413AbYABXfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:35:22 -0500
Message-ID: <477C1FB6.5050905@sgi.com>
Date: Wed, 02 Jan 2008 15:35:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
References: <20071218211539.250334036@redhat.com> <200712201040.29040.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0712192301120.13118@schroedinger.engr.sgi.com> <200712201859.12934.nickpiggin@yahoo.com.au>
In-Reply-To: <200712201859.12934.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Have you done anything more with allowing > 256 CPUS in this spinlock
patch?  We've been testing with 1k cpus and to verify with -mm kernel,
we need to "unpatch" these spinlock changes.

Thanks,
Mike

Nick Piggin wrote:
> On Thursday 20 December 2007 18:04, Christoph Lameter wrote:
>>> The only reason the x86 ticket locks have the 256 CPu limit is that
>>> if they go any bigger, we can't use the partial registers so would
>>> have to have a few more instructions.
>> x86_64 is going up to 4k or 16k cpus soon for our new hardware.
>>
>>> A 32 bit spinlock would allow 64K cpus (ticket lock has 2 counters,
>>> each would be 16 bits). And it would actually shrink the spinlock in
>>> the case of preempt kernels too (because it would no longer have the
>>> lockbreak field).
>>>
>>> And yes, I'll go out on a limb and say that 64k CPUs ought to be
>>> enough for anyone ;)
>> I think those things need a timeframe applied to it. Thats likely
>> going to be true for the next 3 years (optimistic assessment ;-)).
> 
> Yeah, that was tongue in cheek ;)
> 
> 
>> Could you go to 32bit spinlock by default?
> 
> On x86, the size of the ticket locks is 32 bit, simply because I didn't
> want to risk possible alignment bugs (a subsequent patch cuts it down to
> 16 bits, but this is a much smaller win than 64->32 in general because
> of natural alignment of types).
> 
> Note that the ticket locks still support twice the number as the old
> spinlocks, so I'm not causing a regression here... but yes, increasing
> the size further will require an extra instruction or two.
> 
>> How about NUMA awareness for the spinlocks? Larger backoff periods for
>> off node lock contentions please.
> 
> ticket locks can naturally tell you how many waiters there are, and how
> many waiters are in front of you, so it is really nice for doing backoff
> (eg. you can adapt the backoff *very* nicely depending on how many are in
> front of you, and how quickly you are moving toward the front).
> 
> Also, since I got rid of the ->break_lock field, you could use that space
> perhaps to add a cpu # of the lock holder for even more backoff context
> (if you find that helps).
> 
> Anyway, I didn't do any of that because it obviously needs someone with
> real hardware in order to tune it properly.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

