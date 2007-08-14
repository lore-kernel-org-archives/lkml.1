Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXHNX0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXHNX0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbXHNX0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:26:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbXHNX0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:26:06 -0400
Message-ID: <46C239F0.3030004@redhat.com>
Date: Tue, 14 Aug 2007 19:25:36 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com> <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com> <46C2325C.8040900@redhat.com> <Pine.LNX.4.64.0708141555300.579@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708141555300.579@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Chris Snook wrote:
> 
>>> volatile means that there is some vague notion of "read it now". But that
>>> really does not exist. Instead we control visibility via barriers (smp_wmb,
>>> smp_rmb). Would it not be best to not have volatile at all in atomic
>>> operations and let the barriers do the work?
>> From my reply in the other thread...
>>
>> But barriers force a flush of *everything* in scope, which we generally don't
>> want.  On the other hand, we pretty much always want to flush atomic_*
>> operations.  One way or another, we should be restricting the volatile
>> behavior to the thing that needs it.  On most architectures, this patch set
>> just moves that from the declaration, where it is considered harmful, to the
>> use, where it is considered an occasional necessary evil.
>>
>> If you really, *really* distrust the compiler that much, you shouldn't be
>> using barrier, since that uses volatile under the hood too.  You should just
>> go ahead and implement the atomic operations in assembler, like Segher
>> Boessenkool did for powerpc in response to my previous patchset.
> 
> From my reply on the other thread:
> 
> Maybe we need two read functions? One volatile, one not?

If we're going to do this, and I don't think we need to, I'd prefer that 
atomic_read() be volatile, and something like atomic_read_opt() be non-volatile, 
to discourage premature optimization.

> The atomic_read()s that I have in slub really do not care about when the 
> variables are read. And if volatile creates overhead then I rather not have it.

A single volatile access is no more expensive than a non-volatile access.  It's 
when you have dependencies that you start to see overhead.  If you're doing a 
bunch of atomic operations on the same atomic_t in quick succession, then you 
will see some overhead.  Of course, if you're doing that, I think you have a 
design problem.

On modern, register-rich CPUs with cache latencies of a couple clock cycles, 
volatile generally isn't as much of a performance hit as it used to be.  I think 
that going out of your way to avoid it would be premature optimization on modern 
hardware.

	-- Chris
