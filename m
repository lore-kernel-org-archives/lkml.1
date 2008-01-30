Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYA3LBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYA3LBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYA3LB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:01:29 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:1574 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYA3LB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VzM04C0hXMcEfZkeHqBmaWpmkNWHRJBohJaFVERfgdXKOTxpWFvjkYAhbayvjKphpkksh7yKjaBTwT5WPn2gphaCcqSaY6koHz+0Hqujdrtw89lVPhQh1iSZYxjo0fATOhNHxEeqorkmfFR559WX1UoQRhUnM8p5Wy4QGCsqqK8=
Message-ID: <7c86c4470801300301n426f3ab4n94419db3a5553936@mail.gmail.com>
Date: Wed, 30 Jan 2008 12:01:26 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: ptrace API extensions for BTS
Cc: "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, markus.t.metzger@gmail.com
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444014A55DD@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
	 <20080130072557.EC73C26F9A7@magilla.localdomain>
	 <029E5BE7F699594398CA44E3DDF55444014A55DD@swsmsx413.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Markus,

On Jan 30, 2008 11:32 AM, Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> >From: Roland McGrath [mailto:roland@redhat.com]
> >Sent: Mittwoch, 30. Januar 2008 08:26
> >To: Metzger, Markus T
>
> >I think this work has a great deal of overlap with the
> >perfmon2 project.
> >There are two facets that overlap, which together are the
> >whole BTS feature.
> >
> >The same x86 "debug store" hardware is programmed for both the
> >BTS and the
> >performance monitoring features.  The implementations clearly have to
> >cooperate on managing that hardware.  Your ds.c is a start in the right
> >direction, to abstract the hardware configuration from the BTS
> >feature and
> >its interface.  I'm not familiar with the perfmon2 code, but
> >it may have
> >something similar already.
>
> I am not familiar with the perfmon project. I looked briefly at
> arch/x86/kernel/cpu/perfctr-watchdog.c and before I started this, I
> grep'ed for DS_AREA to find out who else is using it, but did not find
> anything.
>
You can get information about the perfmon2 project at: http://perfmon2.sf.net

On processors that do support PEBS, perfmon2 does provide support. As such
it needs access o the DS_AREA.

You can browse our git tree on kernel.org, follow the pointer form our
project's page.

I would like to take a look at your patches. Where can I get them?

My understanding at this point is that we would need to coordinate
access to the
DS_AREA. It would likely have to be mutually exclusive access. I am planning on
adding support for LBRs in the next few months. But BTS the way it is
currently defined
is useless for performance monitoring. I think this a great debug
feature, though.

Now, there is some preliminary perf. MSR allocator in the kernel.
However, it does not know
of all available MSRs out there. It focuses on the counters mostly.
Perfmon, oprofile and
the NMI watchdog use it. I think it could be generalized to other MSR
(non-contiguous).

I would be happy to work with you in refining this MSR allocator.

Thanks.

> As far as I know, performance monitoring can be done in two ways:
> - collect performance event counts
> - collect machine state samples on (the n-th) performance event(s)
>
> The former is done entirely in registers. The latter (spelled PEBS) uses
> a buffer to store the machine state samples.
>
> The configuration of this buffer shares the DS SAVE_AREA MSR with the
> configuration of BTS. That is, DS_AREA points to a struct that
> configures both BTS and PEBS.
>
> My first impression of perfctr-watchdog is that is collects events and
> does not use PEBS at all. There is neither a conflict nor an overlap.
>
> I do agree that they share a common interest. Both collect information
> about a task's execution. The information they collect is disjoint,
> though.
>
>
> >The rest of the BTS feature is the buffer management and the interface.
> >It has to deal with the hardware buffer setup, context switching, and
> >overflow interrupts, and delivering data from the hardware
> >buffers to the
> >interface in appropriate formats.  We'd also like it to be
> >able to trace
> >kernel-mode as well as user-mode, and either deliver combined data or
> >segregate the data between the two for user-space and
> >kernel-space users
> >who need not know about each other's tracing.
>
> Kernel mode users would want a per-cpu (system) trace, whereas user mode
> users would want a per-task trace.
>
> So far, I thought that you could have either or. I'm beginning to think
> that you could serve both at the same time if you are willing to accept
> a few hiccups in the system trace.
>
> For a system trace, we would stick with the per-task trace but trace all
> tasks. We would need to extend the trace format to encode the cpuid.
> This would allow us to serve all per-task trace requests. On a system
> trace request, we would combine the per-task traces to for a (mostly
> complete) per-cpu system trace.
>
> I'm afraid that this would require us to move the buffers to pageable
> memory; something I was very much against, so far.
>
> This logic would be shared between performance monitoring and last
> branch recording.
>
>
> >I don't much like the way you've shoe-horned the
> >context-switch timestamp
> >logging into the BTS feature.  It's a nice feature to have in
> >some form,
> >and I sympathize with your seeing it as easy pickings once you had the
> >BTS buffer machinery handy.  But really it is not part of the
> >BTS feature
> >and there is nothing arch-dependent about it.  Given some other general
> >thing providing the buffer management et al, that could just be done in
> >schedule(), i.e.:
> >
> >               departs(prev);
> >               context_switch(rq, prev, next); /* unlocks the rq */
> >               arrives(prev);
> >
>
> I agree that this is not arch dependent.
>
> I need the context-switch timestamps in the BTS trace, though, and the
> BTS buffer is arch dependent. Since there is only one arch that supports
> this, at the moment, I just put it there.
>
> Once we get more archs, it would begin to make sense to introduce
> another layer and have the context-switch timestamps taken in
> schedule(). The functionality still needs to be provided by the arch
> (which knows about the BTS format), so I wonder whether it would not
> cause more work and confusion than it helps.
>
>
> >If there is a general thing for event-reporting from perfmon2 or
> >whatever, then it might be natural to have the context-switch event
> >reports configurable to different record formats you might be using
> >for other things.  For a BTS-style record, I would use:
> >
> >     departs: { .from = task_pt_regs(prev)->ip, .to = jiffies,
> >.flag = MAGIC1 }
> >     arrives: { .from = jiffies, .to = task_pt_regs(next)->ip,
> >.flag = MAGIC2 }
> >     MAGIC1 = 0xffff0001
> >     MAGIC2 = 0xffff0002
> >
>
> You put the magic into the flags field, I put it into an escape from
> address.
>
> The flags variant seems more natural to me and I like your way of
> reading it; the escape address variant could be implemented on arch's
> that do not support an extra field.
>
> I don't have a strong preference, either way. If there is going to be a
> new abstraction layer, I would leave it to the arch.
>
>
> >I'm no expert on perfmon2 and I understand there are many issues to be
> >resolved to get it into the kernel.  But if you are not
> >desperate to have
> >the BTS feature in the kernel ASAP, it would ideal IMHO if you can work
> >with Stephane et al on putting this work together.
>
> I would like to see the per-task BTS feature in the kernel and
> accessible from user space.
>
> This would allow people to program against the API and start using the
> hardware's feature for application debugging.
>
> Do you have concerns regarding the user API?
>
>
>
> On the other hand, I see the possibility and the necessity to provide a
> common kernel interface for all kinds of task and system profiling - and
> maybe a user interface, as well.
>
> I do see the two parts independent from each other, though.
>
> The BTS patch series establishes the user API for branch recording and
> implements the technique most useful for debuggers. It allows one aspect
> of it to be used right away.
>
> We are discussing extensions that happen behind the scenes to make this
> more useful from inside the kernel and to structure it in a better way.
>
> I would be happy to work with Stephane to get this additional work done.
>
>
>
> >I'd like to see the
> >work go into the kernel in much smaller pieces even than your BTS patch
> >set that's in -mm.  The first thing is just the DS hardware management,
> >context switch and hardware-facing parts of the buffer
> >management (one or
> >three or fourth small bisect-friendly patches just for that much).  If
> >you and Stephane can hash out a fresh patch that provides what you both
> >need for that, that would be a great start.
>
> I think that the low-level parts are pretty much disjoint - unless I
> completely missed the PEBS aspect of perfmon. That would leave the patch
> pretty much as it is.
>
> >Personally, I'd prefer to
> >abandon the ptrace extensions altogether in favor of some generalized
> >event buffer interface that comes from merging perfmon2.  But if you
> >still want to do the ptrace interface, it can be built on the shared
> >DS-management code.  What do you think?
>
> I think that the ptrace interface is useful for the debugging aspect of
> it.
>
> The way it was written, it is intended to be extended to cover other
> events, as well. Whether we want to actually extend it or use some other
> mechanism is another question.
>
>
>
> I would prefer the two features to live independently in the kernel
> while Stephane, I, and whoever is interested work on identifying
> commonalities and merge the two features.
>
> I would like to start with a better understanding of perfmon. If I grep
> for perfmon, I find arch/x86/kernel/cpu/perfctr-watchdog.c and
> include/asm-x86/intel_arch_perfmon.h. Could someone point me to more
> information and more source files?
>
> I see a lot of hits in arch/ia64, though. Is there a project to extend
> this to arch/x86?
>
>
> thanks and regards,
> markus.
>
