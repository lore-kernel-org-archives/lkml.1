Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbYEEXDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbYEEXDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYEEXDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:03:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYEEXDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:03:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
X-Fcc: ~/Mail/linus
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
Subject: RE: [patch] x86, ptrace: in-kernel BTS interface
In-Reply-To: Metzger, Markus T's message of  Monday, 5 May 2008 10:09:33 +0100 <029E5BE7F699594398CA44E3DDF5544401D11191@swsmsx413.ger.corp.intel.com>
References: <20080430135440.A359@sedona.ch.intel.com>
	<20080503014342.3882226FA07@magilla.localdomain>
	<029E5BE7F699594398CA44E3DDF5544401D11191@swsmsx413.ger.corp.intel.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080505230318.F3AF126FA20@magilla.localdomain>
Date: Mon,  5 May 2008 16:03:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess timestamps should be always on.

Not necessarily.  I was just talking about the branch-tracing parts.

> This would affect the ptrace interface. There will be less options and I
> need to drop the DRAIN and CLEAR commands. With multiple tracers, I can
> no longer clear the BTS buffer. Drain will morph into a whole-buffer
> read.

I didn't comment about the higher-level interfaces.  For now, I'm
concentrating just on the basic BTS layer (and below).  The key point to
me is that the internal buffer the hardware writes need not have a 1:1
relation with any particular higher-level interface's ways of buffering.

> Branch trace buffers tend to run full pretty fast.
[...]

Those numbers are helpful to have in mind while considering this stuff.
Thanks.

> If we add ~10k to the buffer size the user requested, we should be able
> to hold the extra kernel-mode trace and do the filtering in software -
> assuming that we will never hold more trace than the tail of a single
> time slice.

I'd write up a few macros (expressed as number of entries) for the
"rules of thumb" numbers you mentioned, like the user->ctxsw path count.
Then we can calculate from these and tune the values for various
scenarios as we go.  Note that for e.g. user-only tracing on hardware
without ds_cpl, there could be many more branch entries for other kinds
of in-kernel paths (system calls, page faults).  And, of course, on
ds_cpl hardware when noone wants kernel traces, we don't need to add any
overhead space at all (or maybe one entry to be pedantic).

> Who should pay for this memory?
[...]

My first point about this is that it is not the ds.c layer's problem.
I don't have anything to offer vis a vis PEBS right now.  For BTS, the
buffer allocation has a lot to do with how we work out the multiplexing.

> Given the vast memory consumption, I would only consider circular
> buffers. [...]

Firstly, this is not a decision for the ds.c layer.  It is
straightforward enough to let the caller who sets up a BTS or PEBS
buffer say whether they want circular or interrupt-threshold mode.  It's
easy to implement a basic DS interrupt handler that does trivial
dispatch to make one or both callbacks to function pointers provided by
the BTS/PEBS caller (whichever has hit its threshold).  The ds.c layer
would also take care of clearing the MSR bit to disable BTS as the
manual says to do, while the callback runs, and then reenable it (and
the analogous thing for PEBS), but that's about it.

> I'm fine to move it into the BTS layer. But it would duplicate the
> allocation and accounting code into all of DS users.

If both the PEBS code and the BTS code turn out to have similar needs,
nothing says they can't both call the same code for their buffer
allocation.  That's just not the ds.c layer's business if they do.

> The model was to allow a single owner of the BTS and PEBS configurations
> to prevent different users from overwriting their settings.
> The first task to make a ds_request() for BTS or PEBS, would own the
> respective configuration until it ds_release()s it.
> This is essentially a BTS/PEBS resource allocator.

The simple mutual exclusion is the right thing to have in the ds.c
layer--it's just that it should not be implicitly tied to calling task.
Instead have it be a struct pointer the caller passes in, or a pointer
the allocator passes back, that must match on later requests or a later
release call.  That's all.  It's up to each caller to decide how to
organize what callers constitute "its" exclusive use of the DS layer.

> If we cut down on the BTS interface and collect all trace at all times,
> anyway, we would not need this, any more.

This is an orthogonal issue.  What I'm saying about the DS layer stands
on its own.  The DS layer should be straightforward and complete in
these ways.  Then this simple low layer can be finished and stable now,
regardless of how the code that uses the BTS slot or the code that uses
the PEBS slot wind up.

> PEBS would still need something like that, though. I wonder whether a
> multiplexing model makes sense for PEBS, at all.

My discussion about multiplexing referred only to the BTS layer.  I have
not discussed PEBS at all, except that the DS layer should provide the
same trivially simple interface to control it.  For this discussion, I'm
assuming that PEBS is in the hands of perfmon2 and leaving it at that.

If we're agreed about the plan to make the ds.c layer just the simple
thing it needs to be, we can tie up that part of the code and let it be
stable.  Then we can move on to the details of the BTS layer.  I'm not
sure I communicated clearly what I had in mind for that, but we can get
back into that.


Thanks,
Roland
