Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXGTTJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXGTTJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbXGTTIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:08:54 -0400
Received: from mercury.realtime.net ([205.238.132.86]:46100 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758901AbXGTTIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:08:53 -0400
In-Reply-To: <Pine.LNX.4.44L0.0707201408060.2546-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707201408060.2546-100000@iolanthe.rowland.org>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <fe998950b9d5ad317d5c1f5ff4e21ac9@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 14:08:26 -0500
To: Alan Stern <stern@rowland.harvard.edu>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2007, at 1:17 PM, Alan Stern wrote:

> On Fri, 20 Jul 2007, Milton Miller wrote:
>
>> On Jul 20, 2007, at 11:20 AM, Alan Stern wrote:
>>> On Fri, 20 Jul 2007, Milton Miller wrote:
>>>>> We can't do this unless we have frozen tasks (this way, or another)
>>>>> before
>>>>> carrying out the entire operation.
>>>>
>>>> What can't we do?   We've already worked with the drivers to quesce
>>>> the
>>>> hardware and put any information to resume the device in ram.  Now 
>>>> we
>>>> ask them to put their device in low power mode so we can go to 
>>>> sleep.
>>>> Even if we schedule, the only thing userspace could touch is memory.
>>>
>>> Userspace can submit I/O requests.  Someone will have to audit every
>>> driver to make sure that such I/O requests don't cause a quiesced
>>> device to become active.  If the device is active, it will make the
>>> memory snapshot inconsistent with the on-device data.
>>
>> If a driver is waking a device between the time it was told by
>> hibernation "suspend all operations and save your device state to ram"
>> and "resume your device" then it is a buggy driver.
>
> That's exactly my point.  As far as I know nobody has done a survey,
> but I bet you'd find _many_ drivers are buggy either in this way or the
> converse (forcing an I/O request to fail immediately instead of waiting
> until the suspend is over when it could succeed).  They have this bug
> because they were written -- those which include any suspend/resume
> support at all -- under the assumption that they could rely on the
> freezer.
>
> And that's why Rafael said "We can't do this unless we have frozen
> tasks (this way, or another) before carrying out the entire operation."
> Until the drivers are fixed -- which seems like a tremendous job --
> none of this will work.

So this is in the way of removing the freezer ... but as we are not 
relying on doing any io other than suspend device operation, save state 
to ram, then later put device in low power mode for s3 and/or s4, and 
finally restore and resume to running.

>> I argue the process can make the io request after we write to disk, we
>> just can't service it.  If we are suspended it will go to the request
>> queue, and eventually the process will wait for normal throttling
>> mechanisms until the driver is woken up.
>
> Many drivers don't have request queues.  Even for the ones that do,
> there are I/O pathways that bypass the queue (think of ioctl or sysfs).

So its not a flag in make_request, fine.

>> Actually, my point was more "what kernel services do the drivers need
>> to transition from quiesced to low power for acpi S4 or
>> suspend-to-ram"?  We can't give them allocate-memory (but we give them
>> a call "we are going to suspend" when they can), but does "run this
>> tasklet" help?  What timer facilities are needed?
>
> Some drivers need the ability to schedule.  Some will need the ability
> to allocate memory (although GFP_ATOMIC is probably sufficient).  Some
> will need timers to run.

Can they allocate the memory in advance?  (Call them when we know we 
want to suspend, they make the allocations they will need; we later 
call them again to release the allocations).

If you need timers, you probably want some scheduling?

>> Do we need to differentate init (por by bios) and resume from quiesced
>> (for reboot, kexec start/resume)?  I hope not.
>
> Yes we do.

can you elabrate?   Note I was not asking resume-from-low power vs 
init-from-por.  We still get that distinction.

How do these drivers work today when we kexec?

The reason I'm asking is its hard to tell the first kernel what 
happened.  We can say "we powered off, and we were restarted", but it 
becomes much harder when each device may or may not have a driver in 
the save kernel if we have to differentate for each device if it was 
initialized and later quiesced by the jump kernel during save or never 
touched.  And we need to tell the resume from hybernate code "i touched 
it" "no i didn't" and "we resumed from s4" "no it was from s5".

This is why I've been proposing that we don't create the suspend image 
with devices in the low power state, but only in a quiesced state 
similar to the initial state.


I'm proposing a sequence like:

(1) start allocating pinned memory to reduce saved image size
(2) allocate and map blocks to save maximum image (we know how much ram 
is not in 1, so the max size)
(3) tell drivers we are going to suspend.   userspace is still running, 
swaping still active, etc.  now is the time to allocate memory to save 
device state.
(4) do what we want to slow down userspace making requests (ie run 
freezer today)
(5) call drivers while still scheduling with interrupts "save 
oppertunitiy".  From this point, any new request should be queued or 
the process put on a wait queue.
(6) suspend timers, turn off interrupts
(7) call drivers with interrupts off (final save)
(8) jump to other kernel to save the image
(9) call drivers to transition to low power
(10) finish operations to platform suspend on hybernate
(11) call drivers to resume, telling them if from suspend-to-ram or 
suspend-to-disk, possibly in two stages (interrupts off no scheduling 
and interrupts on scheduling allowed)
(12) unfreeze processes, kill the the thread holding the extra memroy 
used to reserve

So I'm asking what needs to happen in 9.  If we have to turn interrupts 
on and schedule, that's ok.  If the low power state is the initial 
state then fine.

Note that in 11, we could further differentate "from image restore in 
S4" and "from image restore in S5", and "from failed image save", but 
what needs to happen differently?


I'm guessing that the work that will take some time is seperating the 
go to low power from quiesce operations for snapshot, as it sounds like 
this is done with one driver call today?  Making this separation will 
give us our driver audit :-), but only if we decide on the requiements 
before the start.

miton

