Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZJAANF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZJAANF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZJAANE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbZJAAND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:13:03 -0400
Message-ID: <4AC3F411.5040506@redhat.com>
Date: Wed, 30 Sep 2009 17:13:05 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Add a stub for mpage_da_data in the trace header
References: <1254260407-14276-1-git-send-email-jistone@redhat.com> <20090930133335.GA14585@infradead.org> <20090930142049.GH24383@mit.edu> <4AC3B553.7070704@redhat.com> <20090930212332.GN24383@mit.edu>
In-Reply-To: <20090930212332.GN24383@mit.edu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 02:23 PM, Theodore Tso wrote:
> On Wed, Sep 30, 2009 at 12:45:23PM -0700, Josh Stone wrote:
>> If you just want the data in the trace buffer, then SystemTap is not the
>> tool for you.  By all means, just write yourself a perl script or
>> something that parses the trace buffer however you like.
>>
>> On the other hand, stap is useful to do some processing/inspection
>> *live*, at the moment the event happens.  For that, we register our own
>> tracepoint handler that can do something different than ftrace.
> 
> So there are two things I would point out here.  First of all, now
> that ftrace has the ability to do basic filtering, just about the only
> thing SystemTap can do which is unique is either complex filtering,
> summary statistics, or some kind of correlation between multiple
> events (within the limits of restricted memory allocation limits of
> SystemTap).

This "only thing" seems like quite a lot to me, but I suppose the
significance could be a matter of opinion.  I would also add that
SystemTap can better support concurrent users who want to monitor
different things.

> So I'm not sure it's such a great idea to cede a large bit of
> functionality to as being something that SystemTap will never 
> accomplish --- especially when it's far more convenient and stable
> to depend on fixed trace points than setting arbitrary dynamic trace 
> points in the middle of source files which will break all the time 
> when distro's release new kernels, etc.

I don't understand your point about ceding here.  But yes, I agree that
fixed trace points are more convenient and stable, which is why we've
long supported static instrumentation in the kernel.

> Secondly, while I'm not so sure it's that big of a restriction to have
> Systemtap pull events out of the trace buffer, if you must capture the
> event right as it happens, it should be possible set a kprobe in the
> ftrace subsystem, and then pull out the data of the event from the
> trace buffer.

This is possible, but it's a step backward for a few reasons:

- A kprobe will be inherently slower than a tracepoint handler.
- It requires debuginfo (maybe not to place the probe, but surely to dig
into ftrace's internal data structures).
- It requires knowledge about the ftrace internals, which is fragile and
unmaintainable.
- It assumes that every bit of data that the user wants is captured in
the trace buffer.

I think that last point is particularly significant.  Kernel devs are
not prescient, so the trace event might not be capturing all of the data
that's relevant to a particular troubleshooting effort.  With stap you
can gather whatever data you want.

(By the way, I seem to recall that we once discussed adding a proper
hook for stap to grab ftrace data as it comes, but I don't think that
went anywhere.)

> Keep in mind that one of the advantage DTrace has over SystemTap is
> that it can use pre-defined events in the kernel, and not have to
> keep userspace macro files in sync with a changing kernel source
> base.  It seems counterproductive to throw away the opportunity of
> being able to read the tracepoint event data, since it would give 
> SystemTap a lot more power.

Aren't "pre-defined events" == tracepoints?  That's exactly what we're
trying to use in SystemTap!  But then, DTrace doesn't dictate what data
is captured at those events, so I don't understand why you think we
should be more restrictive.

>> However, SystemTap does *not* require the kernel debuginfo for using
>> tracepoints, even when reading parameters.  It should work in the
>> complete absence of CONFIG_DEBUGINFO, so if you find otherwise, please
>> let me know and I will fix it.
> 
> Well, how is it going to do that if you don't have access to the
> structure definition?  This is why fetching the information from the
> ring buffer is much more powerful.

True, when neither a header nor debuginfo for a private type is
available, then it will be opaque to us, so the ring buffer can offer
pre-defined insight into those structures.  But in sched_switch, for
example, the ring buffer only knows prev/next->comm/pid/prio/state,
whereas stap has the entire rq and task_structs at your disposal.  Each
has power in their own place...

Josh
