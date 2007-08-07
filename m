Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbXHGTvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbXHGTvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXHGTvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:51:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXHGTvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:51:08 -0400
To: Noah Watkins <nwatkins@ittc.ku.edu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: [patch 0/1] extending low-level markers
References: <20070801215723.GA10470@ittc.ku.edu>
	<20070802164437.GA27003@Krystal> <20070802183251.GA15216@ittc.ku.edu>
	<20070802190211.GA12124@Krystal> <20070802193106.GC15216@ittc.ku.edu>
	<20070802193851.GA15883@Krystal> <20070802195837.GD15216@ittc.ku.edu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 07 Aug 2007 15:50:37 -0400
In-Reply-To: <20070802195837.GD15216@ittc.ku.edu>
Message-ID: <y0m4pjbxgxe.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noah Watkins <nwatkins@ittc.ku.edu> writes:

> [...]
> The locks are aquired and released in each _start and _end marker, so
> the equilibrium is not a issue.

But it becomes an issue should preemption, or control flow upset such
as an early return or recursion, occurs between the start and end
markers.

> A more sane example is the insertion of values into a histogram. Instead
> of the instrumenation point logging the values and having the histogram
> constructed during a post-process step, data structures implemented the
> histogrm are associated with the instrumenation point. The lock protects
> this structure in a more intuitive way than the interval example.

A better way may be to do what we do in systemtap scripts: in a
interval-start type probe, store the start value in a table indexed by
thread-id and nesting-level; in the interval-end type probe, find the
corresponding value, compute the difference (as appropriate), and
store the result only then into your long-term lookup table.  This
approach requires *no locks* to survive between start & end: the
probes remain atomic.

> I think most of problems involving non atomicity of the
> connection/disconnection of probes can be accomplished by good house
> keeping and settings things up in phases which insure consistency.

A marker callback can take shortcuts, I guess, if it allows itself to
make assumptions about the ways it can be called.

I scanned over the thread, but still haven't seen a specific argument
for extra marker-type annotations that would relate to this issue.
What tool would need to scan the available markers, and how would
extra information allow it to do its job?

- FChE
