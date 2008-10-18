Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbYJRFKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbYJRFKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 01:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYJRFKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 01:10:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYJRFKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 01:10:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
X-Fcc: ~/Mail/linus
Cc: <eranian@gmail.com>, "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi-suse@firstfloor.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [discuss] x86, bts, pebs: user-mode buffers
In-Reply-To: Metzger, Markus T's message of  Friday, 17 October 2008 15:08:01 +0100 <029E5BE7F699594398CA44E3DDF5544402938673@swsmsx413.ger.corp.intel.com>
References: <1222723282.6177.42.camel@raistlin>
	<7c86c4470809300546i18583729m2982cae955584134@mail.gmail.com>
	<029E5BE7F699594398CA44E3DDF5544402813A01@swsmsx413.ger.corp.intel.com>
	<20081014005615.5DB3E154284@magilla.localdomain>
	<029E5BE7F699594398CA44E3DDF5544402938673@swsmsx413.ger.corp.intel.com>
X-Zippy-Says: Hello...  IRON CURTAIN?  Send over a SAUSAGE PIZZA!  World War III?
    No thanks!
Message-Id: <20081018050449.D28311544CB@magilla.localdomain>
Date: Fri, 17 Oct 2008 22:04:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regarding the multiplexing model,
> - if we have more than one tracer (either on the same thread/cpu
>   or per-thread and per-cpu) trace data needs to be copied (on
>   context switch or when the buffer overflows).
>   This copying cannot be traced by system tracers (they would trace
> their
>   own trace copying, thus overwriting the good trace data with useless
>   information).

Right.

> - copying trace can only be done with interrupts disabled, if all
>   receiving tracer's buffers are mlock'ed.

Right.

>   Since we don't want to lock too much memory, copying trace would need
>   to be done with interrupts enabled.

Maybe.  I don't think it has to be the only choice, or that the DS layer
exactly has to decide this ahead of time.

>     I was planning to schedule_work() the copying, but this would mean
>     that we would lose trace (e.g. interrupts, higher-priority work,
>     paging to bring in the destination buffer) until all the copying
>     is done.

The other option is to have some spare free buffers ready to swap into the
DS pointers quickly so the old buffers can be copied with ongoing traces
re-enabled.

> - if we allow overflow notifications, we should give the tracer a chance
>   to run before we continue tracing.
>   - if we wait for the tracer to tell us he processed the new data,
>     a single non-responsive tracer may prevent the traced thread from
>     making progress.

A tracer taking kernel data is kernel-internal by definition.  I think it's
ok to rely on a kernel-internal tracer to meet its obligations.

For a tracer only taking user data, there is no need to get a response from
it quickly at all.  You can just disable user tracing in the interrupt
handler, and set TIF_NOTIFY_RESUME.  When you have kernel tracing enabled
too and have to filter, that might require quickly swapping in a new
kernel-only tracing buffer to preserve the full one with the user-mode
data.  Then, in the do_notify_resume code that checks TIF_NOTIFY_RESUME,
you can process any necessary buffer management code to re-enable the
user-mode tracing.

> I don't think we should allow overflow notifications for cpu tracers.
> Even then, we will lose trace if there is more than one tracer on one
> cpu (not necessarily a cpu tracer).

I disagree.  It is certainly not inevitable that the only things that can
be implemented will be lossy.

> I don't know how to handle overflow notifications. It seems we can choose
> between incomplete trace or an insecure system.

Nothing about it has to be "insecure".  I think "incomplete traces" is
being a bit dramatic when it just means the trace of the buffer management
code between when buffers fill and when they've been swapped or drained
into other buffers so tracing can be reenabled.

> It's even worse. As soon as the tracers do not agree on what they want
> to trace, we need filtering, and we need to run in interrupt mode, even
> if all tracers are happy enough with a small circular buffer, each.

That's true.  Any time you need filtering, then the circular buffer might
fill up with kernel-mode entries and lose all your user-mode ones.  I think
the only case there's a way to optimize is when you fill up while in kernel
mode and all kernel-mode tracers only want circular.  Then you can switch
buffers and let it fill up in circular mode, and then switch back to
filtering when returning to user mode.

> Are you saying that what I described above is not the concern of
> the DS layer but of higher layers?
>
> From that point of view, DS could accept an overflow callback and
> expect that the tracer is done when the callback call returns.

Yes, something like that.  I figure the DS layer would deal with disabling
tracing and making a callback with interrupts disabled.  It would then make
it easy (callback return value, more calls, whatever API) to either leave
it disabled or offer another buffer to reenable tracing before returning
and enabling interrupts.  Also make it easy to reenable later (if someone
wants a callback that posts a softirq or whatever).

That callback could be used to set TIF_NOTIFY_RESUME so as to do later
reenabling for user-only tracing.  But possibly that would just be rolled
into the DS layer, so it has a non-interrupt callback for user-only tracers.

> But how would a DS user use that feature?

Well, however they want.  For kernel-only tracers, whatever they're part of
may already have a mechanism that's convenient to get wired tracing buffer
space at interrupt level.  There might come along some generic such thing
that is easy to tie into.  Whatever fits the use.

For purely user-only tracing features, there is a lot more latitude to
implement it however you want, since you don't need to worry about
interrupt level and all that.  In a callback from do_notify_resume, you can
do anything you like in kernel mode in that thread's context, block it if
you need to, etc..  Re-enable user tracing and return to user mode only
whenever you are ready with fresh buffers, whatever that entails.


Thanks,
Roland
