Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbYLOWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbYLOWyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYLOWxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:53:50 -0500
Received: from ozlabs.org ([203.10.76.45]:50645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYLOWxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:53:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18758.57327.966434.840755@cargo.ozlabs.ibm.com>
Date: Tue, 16 Dec 2008 09:53:35 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vince Weaver <vince@deater.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
In-Reply-To: <20081214231332.GA26942@elte.hu>
References: <20081211155230.GA4230@elte.hu>
	<Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	<1229070345.12883.12.camel@twins>
	<7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	<1229073834.12883.41.camel@twins>
	<7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	<7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
	<20081214231332.GA26942@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> If there's a single unit of sharable resource [such as an event counter, 
> or a physical CPU], then there's just three main possibilities: either 
> user 1 gets it all, or user 2 gets it all, or they share it.
> 
> We've implemented the essence of these variants, with sharing the resource 
> being the sane default, and with the sysadmin also having a configuration 
> vector to reserve the resource to himself permanently. (There could be 
> more variations of this.)

Thinking about this a bit more, it seems to me that there is an
unstated assumption that dealing with performance counters is mostly a
scheduling problem - that the hardware resource of a fixed number of
performance counters can be virtualized to provide a larger number of
software counters in much the same way that a fixed number of physical
cpus are virtualized to support a larger number of tasks.

Put another way, your assumption seems to be that software counters
can be transparently time-multiplexed onto the physical counters,
without affecting the end results.  In other words, you assume that
time-multiplexing is a reasonable way to implement sharing of hardware
performance counters, and that users shouldn't have to know or care
that their counters are being time-multiplexed.  Is that an accurate
statement of your belief?

If it is (and the code you've posted seems to indicate that it is)
then you are going to have unhappy users, because counting part of the
time is not at all the same thing as counting all the time.  As just
one example, imagine that the period over which you are counting is
shorter than the counter timeslice period (for example because the
executable you are measuring doesn't run for very long).  If you have
N software counters but only M < N hardware counters, then only the
first M software counters will report anything useful, and the
remaining M - N will report zero!

Sampling, as opposed to counting, may be more tolerant of
time-multiplexing of counters, particularly for long-running programs,
but even there time-multiplexing will affect the results and users
need to know about it.

It seems to me that this assumption is pretty deeply rooted in the
design of your performance counter subsystem, and I'm not sure at this
point what is the best way to fix it.

Paul.
