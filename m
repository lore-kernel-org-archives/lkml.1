Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbXGEP6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbXGEP6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbXGEP62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:58:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37524 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXGEP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:58:27 -0400
Subject: Re: [RFC PATCH 1/6] Driver Tracing Interface (DTI) Documentation
From: Tom Zanussi <zanussi@us.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, michaele@au1.ibm.com, dwilder@us.ibm.com,
       HOLZHEU@de.ibm.com
In-Reply-To: <20070704031300.GA24341@Krystal>
References: <1183173817.24291.137.camel@ubuntu>
	 <20070704031300.GA24341@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 10:57:44 -0500
Message-Id: <1183651064.4517.162.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Thanks for your comments, mine below...

On Tue, 2007-07-03 at 23:13 -0400, Mathieu Desnoyers wrote: 
> Hi Tom,
> 
> I'm glad to see that other people are tackling the tracing task.
> I must say that there is a lot here that was already out there in LTTng.

Yes and no.  For the binary tracing parts, there probably is some
overlap with LTTng.  But since there's no LTTng in the kernel, we do
without it.

> I will be happy to review the code you present. Please see comments
> below.
> 
> * Tom Zanussi (zanussi@us.ibm.com) wrote:
> > +On the user side, the combined contents of all the data present in the
> > +per-cpu relay files can be read from a single debugfs file that merges
> > +and presents the contents of the per-cpu data files.  This is mostly
> > +useful for text-based logging, but also works for binary logging.  For
> > +binary logging, there is a small userspace library and examples
> > +available which merge and display the binary per-cpu data in userspace
> > +rather than in the kernel.  See http://sourceforge.net/projects/dti.
> > +
> 
> Right.. LTTng does not use text-based tracing at all, nor global
> buffers, because of the performance hit. I see that it can be usseful in
> some cases, but the fact that we have a post-processing binary-to-text
> converter that uses the timestamp to merge the per-cpu buffers makes the
> global channel useless.
> 

DTI doesn't use a global channel either - the 'merged views' present the
data as if there were a global channel, but logging to the channel is
still per-cpu.

As for text-based tracing, of course I agree it's not the most efficient
way to do tracing, but from my perspective, it's probably the most
useful part of DTI.  I'm continually getting mail from people saying
'the relay API is just too hard to use' or 'I just want to log some
data, I don't want to know jack about debugfs' or 'I just want to log
some data, I don't want to know jack about merging per-cpu files'.  DTI
in my opinion (the other authors may disagree) is mainly about making
those things as easy as possible and providing a more usable API for
kernel debugging - one line of code to set things up, dti_printk() calls
to do per-cpu logging, and at the end, a cat of a single file to see the
merged results.  I don't know how to make it any simpler.

But DTI can also log binary data if needed, and it's not that hard to
write a quick-and-dirty post-processing converter to present it nicely
(or the one-size-fits-all dtiprint utility can be used to look at any
trace).  The emphasis I think is on 'quick-and-dirty' - LTTng is
targeted at production systems and therefore goes to a lot of trouble
making sure that users can do everything they need to without ever
having to reboot.  With DTI, a reboot is pretty much assumed, so there's
no extra data definition layer to worry about - just define the data you
want to log and make sure you have the same thing on the other side when
you want to make sense of it.

Anyway, every so often someone posts a debugging tool similar to DTI -
DTI is basically an attempt to try and make a lot of that effort
unnecessary by making relay easier to use for ad hoc debugging; in fact,
the relay_kernel_read() used by the merged views was something I wrote a
couple of years ago for logdev and that IIRC that was using it for the
same purpose.

> > +
> > +In the kernel, DTI provides both a low-level interface and a
> > +high-level 'handle-based' interface.  The handle-based interface is
> > +built on top of the low-level interface.  The main difference between
> > +the low and high-level interfaces is that in addition to being easier
> > +to use, the high-level interface only allocates the channel buffers
> > +'on-demand', when the first event of a high enough priority comes in.
> 
> Ouch ? What tells you that you are running in a context where it is safe
> to allocate a channel buffer when you hit the first event of that
> loglevel ? I see it is done in complete_channel(), which fails silently
> if the code is called from an atomic context. tsk tsk.. who would like
> to miss important events just because their buffer was not allocated and
> they were unable to allocate it.
> 

complete_channel() doesn't fail silently - if it's in an unsafe context
for allocating a channel, it does it in a work queue.  So yes, you'll
miss some events at the beginning.  If that's a problem, you can use the
low-level interface for the channel (or maybe there should be a flag on
DEFINE_DTI_HANDLE() that has it created immediately).

> > +
> > +  static char early_tracebuf[4096 * 4];
> > +
> > +  DEFINE_DTI_EARLY_HANDLE(early_dti_handle, "early", 4096 * 8,
> > +                          DTI_LEVEL_DEFAULT, early_tracebuf,
> > +                          sizeof(early_tracebuf));
> > +
> 
> What tells you that your timestamps will not be jumping randomly ?
> 

Why would they be jumping randomly?  Here's output from the early boot
example - I don't see any random jumping:

[    0.000000][0]first statement in start_kernel()
[    0.000000][0]after smp_setup_processor_id()
[    0.000000][0]before tick_init()
[    0.000000][0]after tick_init()
[    0.000000][0]after boot_cpu_init()
[    0.000000][0]after setup_arch()
[    0.000000][0]after smp_prepare_boot_cpu()
[    0.000000][0]after sched_init()
[    0.000000][0]after page_alloc_init()
[    0.000000][0]after init_timers()
[    0.000000][0]after hrtimers_init()
[   54.947609][0]after time_init()
[   54.950886][0]after console_init()
[   54.979736][0]after locking_selftest()
[   55.062384][0]before rest_init()

But I'm quite sure you know a lot more about foolproof timestamping than
I do, and that it's all encapsulated in something like an
lttng_timestamp() that I could grab out of lttng?

> Same thing for the if (handle->initbuf test in dti_reserve_early_fn:
> it should keep a counter of events missed, not discard them silently.
> 
> > +This example creates a 32k per-cpu DTI channel having the default log
> > +level, and in addition specifies a single 16k buffer that will be used
> > +to log data into until the relay channels can be created at handle
> > +initialization time.  In this case, after the system boots up, the file
> > +
> > +  /sys/kernel/debug/dti/early/merged
> > +
> > +will contain the data collected during early tracing.
> > +
> > +Handles created with DEFINE_DTI_EARLY_HANDLE are exactly the same as
> > +handles created using DEFINE_DTI_HANDLE() except that a static init
> > +buffer is attached to the handle.  This static buffer is logged into
> > +until the relay channel becomes available, at which point the contents
> > +of the static buffer are re-logged into the relay buffer.  Early
> > +handles have the same lifetimes as normal handles and can be used in
> > +the same way after initialization.  There are no special logging
> > +functions needed for logging early data - the same dti_printk(), etc,
> > +functions are used to log to an early channel.
> 
> How can the copy be done without mixing TSCs from early and non-early
> events ? Why should it be done at all ?
> 

Again, please point me to an lttng_timestamp() that I could use if this
is a problem.

The reason we do it at all is that we want the events to be available in
the normal relay channel after the system boots up instead of as some
special add-on to relay.  Doing it with a single static buffer seemed
like the simplest thing to do both from a user and implementation
perspective.

Tom




