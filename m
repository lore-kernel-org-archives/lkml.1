Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbZDAINU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbZDAINU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbZDAINF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:13:05 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:40831 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbZDAINB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:13:01 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
 counting counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18898.53849.913178.781844@drongo.ozlabs.ibm.com>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	 <20090325082844.GA11217@elte.hu>
	 <18889.61903.636761.471281@cargo.ozlabs.ibm.com>
	 <20090325090336.GC2341@elte.hu>
	 <18889.64659.917207.685779@cargo.ozlabs.ibm.com>
	 <1238526907.3898.93.camel@laptop>
	 <18898.53849.913178.781844@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 10:13:42 +0200
Message-Id: <1238573622.8530.2582.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 13:32 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > On Wed, 2009-03-25 at 20:42 +1100, Paul Mackerras wrote:
> > > 
> > > And here's something else that is semi-related: the PAPI guys want a
> > > kind of counter that counts until it overflows, and then sends a
> > > signal to the process and disables itself (and the whole group it's
> > > in).
> > 
> > I tried doing this this evening, and its remarkably hard. Disabling a
> > counter relies on reading the time, and taking ctx->lock and such.
> > Things that are impossible to do in NMI context.
> 
> So, if I have a group where the leader is a hardware counter set to
> use NMIs, and there is a task_clock software counter in the group,
> don't we hit exactly the same issue with reading the time?

Hmm, I think you're right there. Nasty.

> I'd be OK with saying that you can't use stop-and-signal with NMI
> counters.

Right, so let them use regular IRQs, yes, that will work. Let me code
that.

>   There will still be some issues on powerpc because of our
> lazy interrupt disabling scheme, so some work might have to get
> deferred until we soft-enable interrupts, but we have a way to manage
> that.

Hmm, you're saying ppc always uses NMIs, even when !hw_event.nmi?

> On another topic, I noticed that we have a race with perf_counter_read
> where we do the IPI but don't check in __read() on the destination cpu
> that the task we're after is still running on that cpu.  It needs
> checking and retry logic like we have in other places in
> perf_counter.c.

Yep, you're right again. Should we perhaps generalize that whole code
and provide a method vector for the various bits. That way we could
collapse all that code replication.

This TODO list keeps growing :-)

BTW, how's progress with the lazy switching?

