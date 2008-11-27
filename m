Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYK0S3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYK0S3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYK0S3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:29:06 -0500
Received: from www.tglx.de ([62.245.132.106]:39093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYK0S3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:29:05 -0500
Date: Thu, 27 Nov 2008 19:28:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
In-Reply-To: <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>  <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain> <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Thu, 27 Nov 2008, stephane eranian wrote:
> > What's the purpose of this being a structure if it's just a single
> > instance ?
> >
> There is a single instance.
> I was just trying to regroup related fields together instead of having them as
> separate variables. I can make the change.

Well, if you do a structure then put the lock in it as well, so its on
one cacheline.
 
> >> + *   -EBUSY: if conflicting session exist
> >
> >  Where ?
> 
> Not in the patchset, conflict can arise when you add system-wide sessions.

Well, conflicts arise when oprofile is running as well, isn't it ?
 
> >  How please ? pfm_res.sys_cpumask is local to this file and you want
> >  to check it under the lock and _before_ you increment
> >  thread_sessions blindly.
> >
> Stale comment.

Well, where is it checked ? Where is checked whether Oprofile runs or not ?

> > All what that code should do (in fact it does not) is preventing the
> > mix of thread and system wide sessions.
> >
> True. That is a current limitation.
> 
> > It does neither need a cpumask nor tons of useless loops and debug
> > outputs with zero value.
> >
> Well, the the cpumask is indeed needed but you don't see the reason
> why in the patchset!

If its not needed now, then we can either remove it or do at least
something useful with it.
 
> Perfmon in system-wide does not operate like Oprofile. In system-wide
> a perfmon session (context) monitors only ONE CPU at a time. Each

Then it is a percpu session and not system wide. Please use less
confusing names.

> session is independent of each other. You can therefore measure different
> things on different CPUs. Reservation is thus done independently for each
> CPU, therefore we need a cpu bitmask  to track allocation.

Ok. Question: if you do a one CPU wide session with perfom, can you
still do thread monitoring on the same CPU ?

If no, what prevents that a monitored thread is migrated to such a CPU ?
 
> The Oprofile reservation you see is built on top of the cpumask reservation.
> It tries to allocate in one call and atomically ALL the CPUs as this is the way
> Oprofile operates. Thus it fails if one perfmon system-wide session or one
> perfmon per-thread exists.

This only prevents oprofile from starting, but it does neither prevent
thread sessions nor does it prevent a perfmon per cpu session on a cpu
which was onlined after oprofile started, simply because it's bit is
missing in the CPU mask. 

Oprofile if active starts profiling on cpu hotplug, but if you look at
the cpumask with a perfmon per cpu request it will succeed.

If you do resource management and that is what the file claims to do,
then you need to do it in a consistent way:

Oprofile can only run, when no thread and per cpu perfmon jobs are active.

Perfmon per cpu and thread jobs can only run when oprofile is not active.

Not sure about the thread vs. per cpu perfmon situation. See question above.

Thanks,

	tglx
