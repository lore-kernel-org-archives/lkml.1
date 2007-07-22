Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXGVDot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXGVDot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 23:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXGVDok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 23:44:40 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53136
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbXGVDok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 23:44:40 -0400
Date: Sat, 21 Jul 2007 20:43:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707210956320.8201-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0707212000380.6747@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707210956320.8201-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Alan Stern wrote:

> On Fri, 20 Jul 2007 david@lang.hm wrote:
>
>>> How would you prevent tasks from being scheduled?  How would you
>>> prevent drivers from deadlocking because in order to put their device
>>> in a low-power state they need to acquire a lock which is held by a
>>> user task?
>>
>> you give up on the suspend becouse you have no way of getting the user
>> task to give up the lock.
>
> Once the deadlock has occurred it's too late.  You can't give up; in
> fact you can't do anything at all.  The system has hung.
>
>> however, kernel locks should not be held by user tasks, user tasks are not
>> expected to behave in rational ways, allowing them to compete with kernel
>> tasks for locks is a sure way to get a deadlock or indefinate stall.
>
> What on Earth are you talking about?  "Kernel locks should not be held
> by user tasks"?  Then who _should_ hold them?  You are aware, I hope,
> that down() and mutex_lock() can be called only in process context?
>
>> what locks are accessed this way?
>
> Lots of them.  For example, most drivers won't want a suspend to occur
> right in the middle of an I/O transfer.  To prevent this, the driver
> might use a mutex.  The task doing the I/O (which will be a user task)
> acquires the mutex during a transfer and the suspend routine acquires
> the mutex while quiescing the device.

wait a min her, it's possible we are misunderstanding each other.

as I see it.

if userspace can aquire locks that prevent the kernel from shutting off 
(or doing anything else in particular) then it's possible for misbehaving 
userspace code to stop the kernel by simply choosing to never release the 
lock.

this would be a trivial DOS from userspace.

now, if you are talking instead about the fact that when userspace makes a 
system call, the execution of that system call involves aquiring locks 
that are released before the system call completes you have a very 
different situation.

if you have locks that are held across system calls then you should 
already have problems. becouse you can't count on userspace ever taking 
whatever action is appropriate to release the lock.

what am I missing that concerns you so much?

>>>> Does it really (fundamentally) require scheduling tasks, particularly in
>>>> the case that the devices have already been put in the "quiesced" state?
>>>
>>> I can't say for sure.  That's the way we have been doing it.  It
>>> wouldn't be easy to change, because the driver would have to busy-wait
>>> during delays -- which would mean it would need to use different code
>>> for system-wide suspend and runtime suspend.
>>
>> please define terms so that we are all on the same page
>
> Please read Documentation/power/devices.txt.

I have done so.

>> what do you mean by
>> system-wide suspend
>
> That's what you would call standby, suspend-to-RAM, or hibernate.  The
> entire system goes to sleep.
>
>> runtime suspend
>
> That's when an individual device is placed in a low-power state to
> save energy while it isn't being used.  The system as a whole remains
> awake and the device will be resumed the next time it is needed for
> anything.

thanks for the defintitions.

having read through Documentation/power/devices.txt I remain convinced 
that you are making a fundamental mistake.

you are designing a system that will only work if everything (every 
driver, every state transition) participates fully in the process at all 
times. You started with the facts 'this is the info that ACPI provides and 
this is how it is designed to be used' and worked from there instead of 
looking to see what the kernel really needed and figuring how to provide a 
good interface for that that happens to be implemented (today) with ACPI. 
(a proper power management framework shouldn't care if you have ACPI, APM, 
or some other method of controlling the devices)

this leads to resume functions that can only work if the proper suspend 
function was called rather then makeing 'resume' just mean 'go to full 
operation', which is the same thing that gets called when the device is 
first initialized. internally it can examine the hardware and follow 
different paths depending on what it finds the current state of the 
hardware is, but the outside world (including the rest of the kernel) 
should not care. the fact that the rest of the kernel needs to know if it 
should call 'resume' or 'initialize' is a failure in the abstraction.

in fact, a better abstraction would be something like

report_power_modes
   which would return a series of modes (sorted only by modeID)
   modeID, %power_used_in_this_mode, %capability_in_this_mode
   (I would make mode 0 always be complete power off, and mode 1 always be 
full capacity)

report_power_mode_speed
   which would return a matrix giving how long it takes to transition from 
any mode to any other mode. this should be a relative number, not an 
absolute number since it will be different at different clock speeds.

set_operational_mode(modeID)
   which would take you from whatever mode you are in now to the requested 
mode.

most devices would report the simple list of modes

0,0,0
1,100,100

with a mode_speed matrix of
   0 1
   ---
0|0 1
1|1 0

it may be that there is more info needed for the powr management engine to 
decide what modes it wants to put things into, if so identify what type of 
info you need and add another column to the modes list.
for example:
   you may want to add a flag for 'does this mode allow downstream devices 
to operate?'
   you may want to make a mode for 'this mode doesn't allow any new 
requests, but continues to process pending requests' and have a flag that 
indicates this

currently it looks like there's no way to find out what modes are 
available, and you have to know what mode something is in currently before 
you can request it change to a different mode. both of these prevent 
effective power management without encoding intimate knowledge of the 
capability of the particular hardware in your management tool.

some of this may be discoverable via the ACPI interface (it's not talked 
about much in the devices.txt file), but the mode setting is still wrong.

note that in the example above it's accpetable for a driver to cache what 
mode it thinks the device is in, but it needs to properly set the new 
mode even if it's cached data is incorrect.

this approach would allow the transition of ALL drivers to the new mode of 
operation in one fell swoop, and then adding additional power management 
features is just adding to the existing list rather then implementing new 
functions.

David Lang
