Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZA2SlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZA2SlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZA2SlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:41:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbZA2SlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:41:10 -0500
Date: Thu, 29 Jan 2009 10:39:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
In-Reply-To: <1233253380.4495.123.camel@laptop>
Message-ID: <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org>  <1233218954.7835.11.camel@twins>
  <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>  <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
 <1233253380.4495.123.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Peter Zijlstra wrote:
> 
> Calls with wait=1 are deadlockable when done from within irqs or irq
> disabled sections because two cpus could cross ipi each other and stay
> waiting.

Sure. But this isn't the "wait=1" case. In the waiting case, we don't need 
to allocate anything at all, we can just use the stack.

So the only case that matters for interrupts is indeed "wait=0", but 
that's very much also the case we're talking about.

> That leaves us with the !wait case, which wasn't safe because that
> kmalloc could fail, and the fallback was wait, which yields the same
> deadlock.

Yes. I agree that the _concept_ of the patch is good. No argument there. 

I'm just worried about the details.

> That leaves us with 6 cases,
> 
> root@laptop:/usr/src/linux-2.6# git grep "smp_call_function_single(.*0)"

This misses a _lot_ of cases. What about this one:

	kernel/relay.c:                 err = smp_call_function_single(i,

where you're not seeing if it's a non-waiting one or not (it's a waiting 
one, but my point is that your grep is missing cases).

Doing

	git grep -w smp_call_function_single | grep -v '1);'

is probably more likely to find the cases to look for.

But you're right, I'm still not seeing anything that looks _likely_ to be 
a problem. But I worry that it's something somebody may want to do.

		Linus
