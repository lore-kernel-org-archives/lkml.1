Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYJQOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYJQOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYJQOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:08:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYJQOII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,431,1220252400"; 
   d="scan'208";a="452536273"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [discuss] x86, bts, pebs: user-mode buffers
Date: Fri, 17 Oct 2008 15:08:01 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF5544402938673@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20081014005615.5DB3E154284@magilla.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [discuss] x86, bts, pebs: user-mode buffers
Thread-Index: AcktmJPHmzy9Qq6RTh64UrK0LsoMkQCsNdsw
References: <1222723282.6177.42.camel@raistlin><7c86c4470809300546i18583729m2982cae955584134@mail.gmail.com><029E5BE7F699594398CA44E3DDF5544402813A01@swsmsx413.ger.corp.intel.com> <20081014005615.5DB3E154284@magilla.localdomain>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Roland McGrath" <roland@redhat.com>
Cc: <eranian@gmail.com>, "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi-suse@firstfloor.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Oct 2008 14:08:04.0508 (UTC) FILETIME=[C5C9FDC0:01C93061]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Roland McGrath [mailto:roland@redhat.com] 
>Sent: Dienstag, 14. Oktober 2008 02:56
>To: Metzger, Markus T

Roland,

I have some questions regarding the multiplexing model, below.

[...]

>Before we go on, let me explain the "multiplexing" notion.  
>There are several kinds of BTS consumer that make sense:
>
>* global (per-CPU), kernel only
>* global (per-CPU), kernel/user both together
>* per-thread, kernel only
>* per-thread, user only
>* per-thread, kernel/user both together
>
>In the "kernel only" varieties, the consumer wants a trace 
>that has "jumped
>from <address> out to user" records and "jumped in from user 
>to <address>"
>records.  i.e., it's as if the whole time in user mode is one big basic
>block.  (It could well be desireable to record the particular user PC
>instead of just "to/from user".)
>
>Likewise, in the "user only" varieties, the consumer wants a 
>trace that has
>"jumped from <address> into kernel" and "jumped from kernel 
>out to <address>".
>i.e., it's as if the whole time kernel mode is one big basic block.
>(Furthermore, you don't want records for involuntary jumps 
>like interrupts,
>only for explicit exceptions in user mode and syscalls.  It is probably
>undesireable to expose particular kernel PCs to a user-only 
>consumer--but it
>is probably nice to replace them with well-defined pseudo-PC 
>values that
>indicate the type of exception or syscall instruction.)
>
>The "global" per-CPU varieties mean a system-wide perspective 
>asking, "What
>is the machine doing?"  Here context switch is just another 
>code path the
>CPU is going through--the "switching out" task and the 
>"switching in" task
>are part of the same trace.
>
>In the global kernel/user mixed variety, the consumer wants 
>one big bag of
>collated tracing, the full view of, "What is the machine doing?"  e.g.,
>"flight recorder mode" style.  (Here you would probably like 
>switch_mm to
>insert an annotation that somehow indicates the mm pointer or 
>the cr3 value.
>Then you could interpret the trace along with high-level 
>traces about mm
>setups, to identify what each user PC really meant.)
>
>Each of these kinds might be in use by different consumers that aren't
>aware of each other, at any given time.  So a "filter and 
>splay" model fits
>as the baseline.  Also, there is apparently some hardware with BTS but
>without the ds_cpl feature.  On that hardware, supporting any 
>"kernel only"
>or "user only" kind always requires filtering.  For all the 
>permutations of
>which kinds are active at once, there are different optimization
>opportunities given the possibilities the hardware supports.
>
>Furthermore, each individual consumer might either want "last N" traces
>(ring buffer) or want "continuous" traces (callbacks on full buffer).
>
>Any userland interface for user-only traces should have a 
>uniform interface
>for 32-bit userland on either 32-bit kernels or 64-bit 
>kernels.  That means
>either a uniform 64-bit ABI, and 32-bit kernels translate the 
>hardware BTS
>format to the 64-bit ABI format, or a 32-bit ABI for 32-bit 
>userland, and
>the 64-bit kernels translate to the 32-bit ABI format for 32-bit users.
>
>From a userland perspective, it might be entirely reasonable to want
>continuous traces and to devote gigabytes of RAM to collecting them.
>e.g., debugging an application that uses 3G on an 8G machine, a random
>(unprivileged) user might think it makes plenty of sense to 
>devote 2G to
>live traces.  But, we'd never let that user mlock the 3G just 
>to do that,
>let alone use 3G of kernel address space.
>
>For all these reasons, I don't think it makes sense to have 
>the hardware
>buffers programmed into the DS be the actual user-supplied 
>user buffers.
>Perhaps one day we'll optimize for the case when all these stars are
>aligned and you really can have the hardware filling the user's buffer
>directly.  But I don't think we need to consider that for now.

That makes sense.


Regarding the multiplexing model,
- if we have more than one tracer (either on the same thread/cpu
  or per-thread and per-cpu) trace data needs to be copied (on
  context switch or when the buffer overflows).
  This copying cannot be traced by system tracers (they would trace
their
  own trace copying, thus overwriting the good trace data with useless
  information).
- copying trace can only be done with interrupts disabled, if all
  receiving tracer's buffers are mlock'ed.
  Since we don't want to lock too much memory, copying trace would need
  to be done with interrupts enabled.
  - for per-thread trace, this should be ok
  - for per-cpu trace, we have to suspend tracing until all the copying
    work is completed.
    I was planning to schedule_work() the copying, but this would mean
    that we would lose trace (e.g. interrupts, higher-priority work,
    paging to bring in the destination buffer) until all the copying
    is done.
- if we allow overflow notifications, we should give the tracer a chance
  to run before we continue tracing.
  - if we wait for the tracer to tell us he processed the new data,
    a single non-responsive tracer may prevent the traced thread from
    making progress.
    That's probably OK, if the thread is ptraced, but in general?
  - if we do not wait for the tracer (e.g. automatically suspend tracing
    for this tracer and continue), he will lose trace.
  - if we're talking about cpu trace, it's even worse; if we do not
    suspend tracing for the tracer whose buffer overflows, all other
    tracers would lose trace.


I don't think we should allow overflow notifications for cpu tracers.
Even then, we will lose trace if there is more than one tracer on one
cpu (not necessarily a cpu tracer).

I don't know how to handle overflow notifications. It seems we can
choose
between incomplete trace or an insecure system.


[...]

>capped to some reasonable fixed limit.  The general cases (e.g. a
>trace-everything consumer simultaneous with any other flavor, 
>or anything
>else when !ds_cpl) require an in-kernel buffer that gets 
>filtered anyway.

It's even worse. As soon as the tracers do not agree on what they want
to trace, we need filtering, and we need to run in interrupt mode, even
if all tracers are happy enough with a small circular buffer, each.


>The callback model for different "continuous mode" consumers 
>is important.
>For a user-only consumer, it might be very natural for the 
>consumer's own
>buffer management model to rely on doing things from a safe 
>point close to
>user mode.  From that consumer's perspective, it makes sense 
>to just disable
>BTS from when the buffer fills and defer dealing with it until about to
>return to user (i.e. do_notify_resume, e.g. via 
>TIF_NOTIFY_RESUME).  But
>when kernel tracing is active, it's natural that a buffer 
>should be drained
>and replenished ASAP, maybe even in the interrupt handler 
>itself.  So it
>will take some thought with all this in mind to choose the 
>exact in-kernel
>API for BTS.

Are you saying that what I described above is not the concern of
the DS layer but of higher layers?

>From that point of view, DS could accept an overflow callback and
expect that the tracer is done when the callback call returns.

But how would a DS user use that feature?


>I said earlier "the maximum or the minimum".  When all consumers use
>"last N mode", then you'd want the maximum of their sizes.  When some
>consumers use "continuous mode", then you'd need the minimum of their
>sizes to alert the consumer with the smallest limit to drain/replenish
>buffers.  I'm sure there will be a lot of tuning to figure that stuff
>out exactly.

Agreed.


thanks for your feedback,
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

