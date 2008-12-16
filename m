Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYLPOXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYLPOXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYLPOXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:23:22 -0500
Received: from viefep12-int.chello.at ([62.179.121.32]:24326 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYLPOXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:23:21 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Performance Counters for Linux, v4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
In-Reply-To: <18758.18810.350923.806445@cargo.ozlabs.ibm.com>
References: <20081214212829.GA9435@elte.hu>
	 <18758.18810.350923.806445@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 15:22:21 +0100
Message-Id: <1229437341.7025.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 23:11 +1100, Paul Mackerras wrote:
> Ingo Molnar writes:
> 
> > We are pleased to announce the v4 release of our performance counters 
> > subsystem implementation.
> 
> Looking at the code, I am wondering what you are planning to do to
> support machines that have constraints on what sets of events can be
> counted simultaneously.  Currently you have the core code calling
> counter->hw_ops->hw_perf_counter_enable which can't return an error.
> The core expects it to be able to add any counter regardless of what
> event it's counting, subject only to a maximum number of counters.
> I assume you're going to change that.
> 
> I think the core should put together a list of counters and counter
> groups that it would like to have on the PMU simultaneously and then
> make one call to the arch layer to ask if that is possible.  That
> could either return success or failure.  If it returns failure then
> the core needs to ask for something less, or something different.  I'm
> not sure how the core should choose what to ask for instead, though.

I think the constraint set should be applied when we add to a group, if
when we add a counter to the group, the result isn't schedulable
anymore, we should fail the group addition - and thereby the counter
creation.

This would leave us with groups that are always schedulable in an atomic
fashion.

>From what I understand the code RRs groups (co-scheduling groups where
possible) (ungrouped counter is a group of one), this means that with
the above addition you'd have the needed control over things.

If you need things to be atomic, create a single group, if you're fine
with RR time-sharing, create multiple.

This seems to leave a hole where multiple monitors collide and create
multiple groups unaware of each-other - could we plug this hole with a
group attribute?



