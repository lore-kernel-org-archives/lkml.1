Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197Ab0AKAjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0AKAjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 19:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896Ab0AKAjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 19:39:12 -0500
Received: from ozlabs.org ([203.10.76.45]:44423 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0AKAjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 19:39:11 -0500
Date: Mon, 11 Jan 2010 11:39:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 6/6] perf: Increase round-robin fairness of flexible
 events
Message-ID: <20100111003905.GA6066@brick.ozlabs.ibm.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
 <1263087500-14215-7-git-send-regression-fweisbec@gmail.com>
 <20100110220440.GA4595@brick.ozlabs.ibm.com>
 <20100110235758.GC5039@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110235758.GC5039@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 12:57:59AM +0100, Frederic Weisbecker wrote:

> I think the constraint of "either every or none get
> scheduled in a group" makes a lot of sense for pinned
> groups.
> 
> But I don't see the point in applying this
> rule inside flexible groups because the nature
> of flexible events implies these have been created to
> fight against a limited resource. So if this fight
> is done only between groups, this is like raising
> a voluntary starvation.
> 
> Or..or..May be I just realize too late that the semantic
> of a group implies that all events inside must be always
> counted simultaneously? In which case I agree with you,
> this patch makes no sense and must be dropped.

The original idea of the groups was for situations where you want to
take the difference or ratio of two counts.  For example, if you want
to measure cache hits but the hardware can only count cache accesses
and cache misses.  In that situation you want to compute accesses
minus misses, but if the counters for accesses and for misses are
independently scheduled, statistical fluctuations can mean there is a
lot of noise in the result, and it might even be negative.  Putting
the two counters into one group means that you can meaningfully
compute the difference or ratio since the two counter values relate to
the same set of instructions (even if that isn't the whole execution
of the program).

The default situation is that each event is in its own group, so the
starvation you talk about won't arise.  If the user has gone to the
trouble of putting two events into one group, then they are saying
that they need the events to be scheduled on and off together, and if
that leads to starvation, that's unfortunate but we can't do any
better within the limitations of the hardware.

Paul.
