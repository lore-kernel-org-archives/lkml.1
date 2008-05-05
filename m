Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYEEJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYEEJJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYEEJJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:09:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:15287 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbYEEJJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,437,1204531200"; 
   d="scan'208";a="242037023"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: in-kernel BTS interface
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 5 May 2008 10:09:33 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF5544401D11191@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080503014342.3882226FA07@magilla.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: in-kernel BTS interface
thread-index: AcisvyK6h9NerRJUQBqLYZ0NemNkrQBy9kSA
References: <20080430135440.A359@sedona.ch.intel.com> <20080503014342.3882226FA07@magilla.localdomain>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Roland McGrath" <roland@redhat.com>
Cc: <andi-suse@firstfloor.org>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 05 May 2008 09:09:28.0171 (UTC) FILETIME=[B8A92BB0:01C8AE8F]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Roland McGrath [mailto:roland@redhat.com] 
>Sent: Samstag, 3. Mai 2008 03:44
>To: Metzger, Markus T


>Now, on more substantive concerns.  This is heading in the 
>right general
>direction, to having a well-specified internal interface to build from.
>
>      * Not all processors support all variants.
>      * If a variant is not supported, the respective flag is ignored.
>      ...
>     #define BTS_O_TRACE	(1<<0)	/* record branch trace */
>     #define BTS_O_TIMESTAMP	(1<<1)	/* record scheduling 
>timestamps */
>     #define BTS_O_USER_OFF	(1<<2)	/* do not trace user mode */
>     #define BTS_O_KERNEL_OFF	(1<<3)	/* do not trace kernel mode */
>
>The three +-- flags are not the natural interface (even if 
>that is what the
>hardware bits look like).  Just have two bits: trace kernel 
>branches, trace
>user branches.  Also, the style of silently ignoring flags is generally
>bad.  I recognize that you have bts_status() to tell what 
>took.  But still,
>it's awkward.  In this case I don't think we need to worry 
>about interface
>details for what's not supported, because we can just expose a 
>consistent
>interface on all the hardware.

OK.

I guess timestamps should be always on.

This would affect the ptrace interface. There will be less options and I
need to drop the DRAIN and CLEAR commands. With multiple tracers, I can
no longer clear the BTS buffer. Drain will morph into a whole-buffer
read.


>Since we are already transcribing each BTS entry into the ABI 
>form anyway,
>it's easy to weed out the ones for the wrong mode along the 
>way.  We can
>distinguish user from kernel entries with ip < TASK_SIZE.  So 
>what I'd do
>is code it that way and make it work with ignoring the 
>unwanted entries in
>software.  Then, add the support for ds_cpl hardware to let 
>the CPU do it,
>but that is just an optimization that doesn't change the interface.

OK. 


>This relates to the major thing I find missing in the interface:
>multiplexing.  I'd like to support an in-kernel global tracing request
>at the same time as a user-mode request for tracing on an individual
>task.  In fact, all permutations and multiple of each.  For the
>in-kernel interface, I'd like to see an interface to request a new
>"tracing context" that can be one task or global and kernel-only or
>user-only or both.  The hardware setup is to trace the union of all
>those requests for the current task plus all the global requests.  When
>delivering samples from the buffer, we sort them out to who 
>wants to see
>what.  It seems pretty straightforward.  The main thing is deciding how
>big a buffer to use.


Branch trace buffers tend to run full pretty fast.
For example:
- switching from a task (from user-mode to __switch_to_xtra()) takes
~300 entries (7.2k) - handling a segv (from null function pointer call
to __switch_to_xtra()) takes ~400 entries (9.6k)
- 512k are not enough to hold a single time slice (measured on a printf
loop)

On the other hand:
- knowing where you died takes 1 entry
- knowing how you got there takes <100 entries or you lose track, anyway


If we add ~10k to the buffer size the user requested, we should be able
to hold the extra kernel-mode trace and do the filtering in software -
assuming that we will never hold more trace than the tail of a single
time slice.

Who should pay for this memory?
Should it be taken from the requesting task's rlimit?
Who should pay in the case of multiple tracers?
What if the initial tracer leaves while other tracers remain? (the
initial tracer would want its rlimit adjusted, but other tracers may not
even have enough resources).
Should I drop the whole rlimit check and allow everybody to request
arbitrarily big buffers?


>For global tracing simultaneous with per-task tracing, there are two
>ways to go.  You can use a single hardware buffer and just 
>write markers
>into it at context switch time to distinguish which task each 
>stretch of
>entries was in.  Or you can switch buffers on context switch, and then
>collecting global samples means collecting samples from every task
>buffer that's been active since last collection, plus a global buffer
>that's switched in for any task that doesn't have anyone doing per-task
>tracing.


Given the vast memory consumption, I would only consider circular
buffers. That's all you need for debugging. Trying to collect a full
system trace even for a few seconds will likely fill up an entire disk
server. We may add support for an overflow interrupt for each of the
various buffers, but I doubt that it will be very useful. Trying to get
a consistent global trace will likely eat up more memory and compute
time than its worth.

I would go for per-task buffers and a catch-all per-cpu buffer (if
per-cpu trace is requested).
I would not try to remember the sequence of recent tasks and construct a
consistent global trace on the fly - we would need too big per-task
buffers. We could copy the per-task trace into the per-cpu buffer on
context switch, but, again, I doubt that this is overly useful.


>I don't think ds_request should do the buffer allocation, just the
>ds_context.  

I'm fine to move it into the BTS layer. But it would duplicate the
allocation and accounting code into all of DS users.



>What is ds_validate_access for?  I don't think this level of 
>code should
>be thinking about concepts like permission at all.  What the current
>task is making the calls into the ds.c layer should not matter.  It's
>the job of higher-level code to decide if this is a proper thing to be
>doing.

The model was to allow a single owner of the BTS and PEBS configurations
to prevent different users from overwriting their settings.
The first task to make a ds_request() for BTS or PEBS, would own the
respective configuration until it ds_release()s it.
This is essentially a BTS/PEBS resource allocator.

If we cut down on the BTS interface and collect all trace at all times,
anyway, we would not need this, any more.
PEBS would still need something like that, though. I wonder whether a
multiplexing model makes sense for PEBS, at all.


regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

