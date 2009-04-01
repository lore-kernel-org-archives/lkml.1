Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbZDACd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbZDACd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 22:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZDACdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 22:33:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57604 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbZDACdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 22:33:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18898.53849.913178.781844@drongo.ozlabs.ibm.com>
Date: Wed, 1 Apr 2009 13:32:57 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
 counting counters
In-Reply-To: <1238526907.3898.93.camel@laptop>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	<20090325082844.GA11217@elte.hu>
	<18889.61903.636761.471281@cargo.ozlabs.ibm.com>
	<20090325090336.GC2341@elte.hu>
	<18889.64659.917207.685779@cargo.ozlabs.ibm.com>
	<1238526907.3898.93.camel@laptop>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Wed, 2009-03-25 at 20:42 +1100, Paul Mackerras wrote:
> > 
> > And here's something else that is semi-related: the PAPI guys want a
> > kind of counter that counts until it overflows, and then sends a
> > signal to the process and disables itself (and the whole group it's
> > in).
> 
> I tried doing this this evening, and its remarkably hard. Disabling a
> counter relies on reading the time, and taking ctx->lock and such.
> Things that are impossible to do in NMI context.

So, if I have a group where the leader is a hardware counter set to
use NMIs, and there is a task_clock software counter in the group,
don't we hit exactly the same issue with reading the time?

I'd be OK with saying that you can't use stop-and-signal with NMI
counters.  There will still be some issues on powerpc because of our
lazy interrupt disabling scheme, so some work might have to get
deferred until we soft-enable interrupts, but we have a way to manage
that.

On another topic, I noticed that we have a race with perf_counter_read
where we do the IPI but don't check in __read() on the destination cpu
that the task we're after is still running on that cpu.  It needs
checking and retry logic like we have in other places in
perf_counter.c.

Paul.
