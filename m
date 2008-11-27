Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYK0SwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYK0SwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYK0SwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:52:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:50250 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYK0SwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=fDj5rMHDRV4Jckh+sZE9BjbrvQwKtwZjK4Gu5pviYtHr7fxMAu1ETPpl6Xbdu4dUH5
         e/oj49oEZWTkcjTmtFPd9LUzTxvDo2WOdyM+UELWQehS3rCfc29zUbVNP5RLyKXsL1v4
         1f8BpVYlSelOC46sdxSba0rAFG3dhBFaog1oQ=
Message-ID: <7c86c4470811271051g66669197qb6b5fd39961668a9@mail.gmail.com>
Date: Thu, 27 Nov 2008 19:51:59 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 02/24] perfmon: base code
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
	 <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>
	 <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>
	 <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thomas,

On Thu, Nov 27, 2008 at 7:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Stephane,
>
> On Thu, 27 Nov 2008, stephane eranian wrote:
>> > What's the purpose of this being a structure if it's just a single
>> > instance ?
>> >
>> There is a single instance.
>> I was just trying to regroup related fields together instead of having them as
>> separate variables. I can make the change.
>
> Well, if you do a structure then put the lock in it as well, so its on
> one cacheline.
>
Good point.

>> >> + *   -EBUSY: if conflicting session exist
>> >
>> >  Where ?
>>
>> Not in the patchset, conflict can arise when you add system-wide sessions.
>
> Well, conflicts arise when oprofile is running as well, isn't it ?
>
Correct.

>> >  How please ? pfm_res.sys_cpumask is local to this file and you want
>> >  to check it under the lock and _before_ you increment
>> >  thread_sessions blindly.
>> >
>> Stale comment.
>
> Well, where is it checked ? Where is checked whether Oprofile runs or not ?
>
It does not care whether it is Oprofile, NMI or any other subsystem.
What matters
is:
   - what PMU registers are available?
   - what CPU are not used for monitoring?
   - are there per-thread sessions running?

>> > All what that code should do (in fact it does not) is preventing the
>> > mix of thread and system wide sessions.
>> >
>> True. That is a current limitation.
>>
>> > It does neither need a cpumask nor tons of useless loops and debug
>> > outputs with zero value.
>> >
>> Well, the the cpumask is indeed needed but you don't see the reason
>> why in the patchset!
>
> If its not needed now, then we can either remove it or do at least
> something useful with it.
>
That something useful is the reserve all or nothing for Oprofile.

>> Perfmon in system-wide does not operate like Oprofile. In system-wide
>> a perfmon session (context) monitors only ONE CPU at a time. Each
>
> Then it is a percpu session and not system wide. Please use less
> confusing names.
>
I know that. I have used this name since the beginning, it's more legacy
than anything else. Let's call this cpu-wide mode. I think people are more
familiar with the notion of system-wide than cpu-wide.


>> session is independent of each other. You can therefore measure different
>> things on different CPUs. Reservation is thus done independently for each
>> CPU, therefore we need a cpu bitmask  to track allocation.
>
> Ok. Question: if you do a one CPU wide session with perfom, can you
> still do thread monitoring on the same CPU ?
>
No. They are currently mutually exclusive.

> If no, what prevents that a monitored thread is migrated to such a CPU ?
>
Nothing. AND you don't want to change affinity because you are monitoring.
So the current restriction is that cpu-wide and per-thread are
mutually exclusive.
The only way to avoid that is to partition the PMU register so each can co-exist
on the same CPU. I have not reached that point yet. They are also some hardware
limitations which prevent that from being implemented, e.g., on Itanium.

>> The Oprofile reservation you see is built on top of the cpumask reservation.
>> It tries to allocate in one call and atomically ALL the CPUs as this is the way
>> Oprofile operates. Thus it fails if one perfmon system-wide session or one
>> perfmon per-thread exists.
>
> This only prevents oprofile from starting, but it does neither prevent
> thread sessions nor does it prevent a perfmon per cpu session on a cpu
> which was onlined after oprofile started, simply because it's bit is
> missing in the CPU mask.
>
That is a good point!

The test needs to be more sophisticated than that. I guess we can keep the
'global' variable you've introduced and check against that first, then check
individual bits for conflicting perfmon cpu-wide session.

> Oprofile if active starts profiling on cpu hotplug, but if you look at
> the cpumask with a perfmon per cpu request it will succeed.
>
> If you do resource management and that is what the file claims to do,
> then you need to do it in a consistent way:
>
> Oprofile can only run, when no thread and per cpu perfmon jobs are active.
>
> Perfmon per cpu and thread jobs can only run when oprofile is not active.
>
> Not sure about the thread vs. per cpu perfmon situation. See question above.
