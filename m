Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYGCMd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYGCMd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYGCMdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:33:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:36812 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbYGCMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vhcGAEbKfSZBgDGJb+Cz6QSf2s1ILlTC980OgmdAMQCZVzSsoeZFHdj+tqLIF9MJSC
         xMBc5+VkrGE1ijk7p+Juvpp0Scv4k0R7LotmJeFNFEWkSaecozpS2cbEAykBRXZx5MlB
         KGuUj8HHv/NelrhYdNFmm/ylcP/h/tD5FIo54=
Message-ID: <cfd18e0f0807030533q714f4e17w640580a60c300cbd@mail.gmail.com>
Date: Thu, 3 Jul 2008 14:33:12 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: getcpu(2) man page
Cc: lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <486BDDA0.4070306@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486BD19B.7040302@gmail.com> <486BDDA0.4070306@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += tglx, mingo]

Hi Andi

On Wed, Jul 2, 2008 at 9:57 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Michael Kerrisk wrote:
>
>> .\" FIXME(ak) If the following formulation is correct, I think it would
>> .\" be better to substitute it instead of the next sentence:
>> .\"     The information placed in \fIcpu\fP is only guaranteed to be
>> .\"     current at the time of the call: ...
>
> At least sched_setaffinity should be still mentioned.
> Feel free to rephrase it if you think it's better in some other way.

Okay -- I rewored the text there, and kept mention of sched_setaffinity().

>> .\" FIXME(ak) In the following, what precisely do you mean by "advisory"?
>> .\" It is not really clear to me whether you mean the information
>> .\" may not be "true", or whether you are just reiterating the point that
>> .\" the CPU/node might already have changed by the time the call returns.
>
> It's reiterating the point, but in general the caller has to consider
> it advisory as a hint only because it cannot rely on it 100% (unless it set the affinity)

Okay -- because it's just repeating the point, I removed that sentence.

>> .\" FIXME(ak) what does the phrase "but might query the current state
>> .\" only during a short implementation specific interval" mean?
>> it will be faster, but might query the current state only during
>> a short implementation specific interval.
>
> Originally the cache had a time stamp and then would only get the CPU
> information once each jiffie. That works well because the CPU affinity
> is typically hold long enough.
>
> Unfortunately someone who didn't understand the design and didn't think
> it through took that out  so currently applications have to reimplement that
> mechanism in a usually inferior and slower way (querying timers is much slower in
> general user space) or do "endless caches" which are also bad

Okay.  I see the change was in 2.6.24.  I've rewritten the test to
clarify that this argument is no longer used, and I've trimmed the
explanation of tcache and moved it to notes.  Could you please check
the text below, to see if it suffices (Ingo, Thomas, perhaps you also
have some input?).

Cheers,

Michael

.\" This man page is Copyright (C) 2006 Andi Kleen <ak@muc.de>.
.\" Permission is granted to distribute possibly modified copies
.\" of this page provided the header is included verbatim,
.\" and in case of nontrivial modification author and date
.\" of the modification is added to the header.
.\" 2008, mtk, various edits
.TH getcpu 2 2008-06-03 "Linux" "Linux Programmer's Manual"
.SH NAME
getcpu \- determine CPU and NUMA node on which the calling thread is running
.SH SYNOPSIS
.nf
.B #include <linux/getcpu.h>
.sp
.BI "int getcpu(unsigned *" cpu ", unsigned *" node \
", struct getcpu_cache *" tcache );
.fi
.SH DESCRIPTION
The
.BR getcpu ()
system call identifies the processor and node on which the calling
thread or process is currently running and writes them into the
integers pointed to by the
.I cpu
and
.I node
arguments.
The processor is a unique small integer identifying a CPU.
The node is a unique small identifier identifying a NUMA node.
When either
.I cpu
or
.I node
is NULL nothing is written to the respective pointer.

The third argument to this system call is nowadays unused.

The information placed in
.I cpu
is only guaranteed to be current at the time of the call:
unless the CPU affinity has been fixed using
.BR sched_setaffinity (2),
the kernel might change the CPU at any time.
(Normally this does not happen
because the scheduler tries to minimize movements between CPUs to
keep caches hot, but it is possible.)
The caller must be prepared to handle the situation when
.I cpu
and
.I node
are no longer the current CPU and node.
.SH VERSIONS
.BR getcpu ()
was added in kernel 2.6.19 for x86_64 and i386.
.SH CONFORMING TO
.BR getcpu ()
is Linux specific.
.SH NOTES
Linux makes a best effort to make this call as fast possible.
The intention of
.BR getcpu ()
is to allow programs to make optimizations with per-CPU data
or for NUMA optimization.

Glibc does not provide a wrapper for this system call; call it using
.BR syscall (2);
or use
.BR sched_getcpu (3)
instead.

The
.I tcache
argument is unused since Linux 2.6.24.
.\" commit 4307d1e5ada595c87f9a4d16db16ba5edb70dcb1
.\" Author: Ingo Molnar <mingo@elte.hu>
.\" Date:   Wed Nov 7 18:37:48 2007 +0100
.\" x86: ignore the sys_getcpu() tcache parameter
In earlier kernels,
if this argument was non-NULL,
then it specified a pointer to a caller-allocated buffer in thread-local
storage that was used to provide a caching mechanism for
.BR getcpu ().
Use of the cache could speed
.BR getcpu ()
calls, at the cost that there was a very small chance that
the returned information would be out of date.
The caching mechanism was considered to cause problems when
migrating threads between CPUs, and so the argument is now ignored.
.\"
.\" ===== Before kernel 2.6.24: =====
.\" .I tcache
.\" is a pointer to a
.\" .IR "struct getcpu_cache"
.\" that is used as a cache by
.\" .BR getcpu ().
.\" The caller should put the cache into a thread-local variable
.\" if the process is multithreaded,
.\" because the cache cannot be shared between different threads.
.\" .I tcache
.\" can be NULL.
.\" If it is not NULL
.\" .BR getcpu ()
.\" will use it to speed up operation.
.\" The information inside the cache is private to the system call
.\" and should not be accessed by the user program.
.\" The information placed in the cache can change between kernel releases.
.\"
.\" When no cache is specified
.\" .BR getcpu ()
.\" will be slower,
.\" but always retrieve the current CPU and node information.
.\" With a cache
.\" .BR getcpu ()
.\" is faster.
.\" However, the cached information is only updated once per jiffy (see
.\" .BR time (7)).
.\" This means that the information could theoretically be out of date,
.\" although in practice the scheduler's attempt to maintain
.\" soft CPU affinity means that the information is unlikely to change
.\" over the course of the caching interval.
.SH SEE ALSO
.\" FIXME . add SEE ALSO entry in cpuset.7
.BR mbind (2),
.BR set_mempolicy (2),
.BR sched_getcpu (3)
.BR sched_setaffinity (2),
.\" FIXME . cpuset (7)
