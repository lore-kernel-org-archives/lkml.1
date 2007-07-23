Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbXGWTHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbXGWTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761637AbXGWTG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:06:58 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:33606
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034AbXGWTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:06:57 -0400
Date: Mon, 23 Jul 2007 12:01:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707231035150.3545-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707231121220.3828@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707231035150.3545-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Alan Stern wrote:

> On Sun, 22 Jul 2007 david@lang.hm wrote:
>

>> Ok, I did misunderstand you. it sound slike all you need to do to make
>> sure that locks are not held is to allow system calls to return before
>> trying to do the suspend/kexec/etc. that sounds like not only a trivial
>> thing to do, but something that would probably be done anyway.
>
> If you could actually do it, it would work.  But you can't do it.  If
> it were feasible, the freezer would have used that approach in the
> first place.
>
> For one thing, checking for a suspend-in-progress at the beginning of
> each and every system call would add overhead to a hot path in the
> kernel, one which is already very heavily optimized.  People wouldn't
> stand for it.

I thought that the suspend stuff did this easily, but the freezer really 
starts running into trouble when it wants to freeze some things, but not 
other things. this seems to be the biggest area of churn and problems.

>> although syscalls that then call out to userspace tasks before they can
>> complete cause potential deadlocks (without that issue you can just wait
>> until all syscalls have returned, and not allow anything to issue new
>> syscalls) is this the issue that's killing FUSE+suspend?
>
> You get similar problems from system calls that wait in kernel mode
> until something has happened.  For example, a read() call for the
> console device will wait until somebody types on the keyboard.  At any
> point in time, many (or even most) user threads are blocked in a system
> call.

but are locks held while they are blocked like this?

>>> But it also means that tasks which otherwise would have been frozen are
>>> actually free to run before the kexec call is made (and after the call
>>> returns, if the kexec'd kernel returns back to the original kernel).
>>> Any driver which was written with the assumption that tasks would be
>>> frozen at those times will need to be changed.
>>
>> here is where you loose me.
>>
>> why should jumping back to the original kernel immedialty start running
>> these processes?
>
> Let's let kernel K1 be the original kernel, the one which is going into
> hibernation.  Kernel K2 is the one started by kexec to write out the
> memory image.
>
> Your question becomes: Why should K2 jumping back to K1 cause K1
> immediately to start running user tasks?  Answer: Because K1 has been
> running user tasks all along (except while K2 was active) and nothing
> has told it to stop.  In fact, about the only things which _can_ cause
> K1 to stop running user threads are the freezer (which you want to
> eliminate) and disabling interrupts (not possible since some drivers
> require interrupts to be enabled when putting devices in low-power
> mode).

when you jump to a body of code you jump to a specific point in the code, 
not to some nebulous 'everything running' state.

>>  the process of doing a kexec requires things to happen in
>> the drivers before normal activity can happen, so there is a phase in
>> there where the kernel being jumped to has drivers initializing, but still
>> does not allow anything else to run.
>
> So when K2 starts up, it will have a phase in which user threads don't
> run.  That doesn't affect K1.  When K2 returns to K1, K1 does not go
> through this sort of phase.  It simply picks up from where it left off.

then how can it restart drivers before the user threads need them?

>> why can't this phase be extended to
>> allow for the possibility of transitioning these drivers to a sleep mode
>> instead of to full operation?
>
> Indeed, Rafael has suggested that K2 be responsible for putting devices
> in low-power mode.  This has the disadvantage of requiring K2 to
> include drivers for every device used by K1, but otherwise it would
> work.
>
> However there still remains the problem of user tasks running after
> devices are supposed to be quiescent and before K1 starts.  There's
> currently nothing to stop such tasks from making I/O requests and
> thereby causing a quiescent device to become active again.

but if the devices are in low power mode then K1 needs to get them out of 
low power mode before user tasks try to access them.

>>> The situation as regards locking is harder to discuss since I don't
>>> know of any code examples to use as a guide.  The fact remains that if
>>> user tasks aren't frozen then they can make system calls, and while
>>> running in kernel mode they can acquire locks, which might cause
>>> problems -- even though I can't identify any definite examples.
>>
>> yes, if userspace is running jobs and submitting I/O and system calls
>> while drivers are trying to initalize there is a big problem, but I am
>> missing the reason this must be the case.
>
> We aren't talking about drivers initializing devices.  We are talking
> about what happens during the time when drivers are trying to quiesce
> devices (i.e., before K1 has started up K2) or power them down (after
> K2 has returned to K1).

or if you are doing a resume instead of a suspend to ram the drivers need 
to initialize or otherwise move to full power on K1 before user tasks hit 
them.

>> the part of the freezer that everyone is trying to eliminate is the
>> exceptions (freeze everything except X,Y,Z becouse we will need to use
>> those later for A)
>
> Wrong.  People are trying to eliminate the freezer entirely.  Go back
> and reread some of the postings at the beginning of this long thread,
> especially those from Paul Mackerras and Ben Herrenschmidt.
>
> Alan Stern
>
>
