Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbXGVVwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbXGVVwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbXGVVwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:52:37 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42143
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXGVVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:52:36 -0400
Date: Sun, 22 Jul 2007 14:50:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707221126280.15224-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0707221426290.6350@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707221126280.15224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Alan Stern wrote:

> On Sat, 21 Jul 2007 david@lang.hm wrote:
>
>> wait a min her, it's possible we are misunderstanding each other.
>
> I'd describe it as: You are misunderstanding me.  :-)

very possibly :-)

>> as I see it.
>>
>> if userspace can aquire locks that prevent the kernel from shutting off
>> (or doing anything else in particular) then it's possible for misbehaving
>> userspace code to stop the kernel by simply choosing to never release the
>> lock.
>>
>> this would be a trivial DOS from userspace.
>
> You are confusing "userspace" with "user tasks".  And not only that,
> you often use the term "userspace" when you should say "user mode".
>
> If you want I can explain the differences.

please do, I have been treating all three as the same catagory.

>> now, if you are talking instead about the fact that when userspace makes a
>> system call, the execution of that system call involves aquiring locks
>> that are released before the system call completes you have a very
>> different situation.
>
> That is exactly what I have been talking about.  It may be different
> from what you _thought_, but it's not different from what I actually
> _said_.

Ok, I did misunderstand you. it sound slike all you need to do to make 
sure that locks are not held is to allow system calls to return before 
trying to do the suspend/kexec/etc. that sounds like not only a trivial 
thing to do, but something that would probably be done anyway.

although syscalls that then call out to userspace tasks before they can 
complete cause potential deadlocks (without that issue you can just wait 
until all syscalls have returned, and not allow anything to issue new 
syscalls) is this the issue that's killing FUSE+suspend?

>> if you have locks that are held across system calls then you should
>> already have problems. becouse you can't count on userspace ever taking
>> whatever action is appropriate to release the lock.
>>
>> what am I missing that concerns you so much?
>
> Here's what you are missing:
>
> The new kexec approach eliminates the freezer and relies instead on the
> fact that none of the tasks in the original kernel can execute while
> the new kexec'd kernel is running.  This means the new kernel can write
> out a memory image with no fear of interference or corruption.

correct

> But it also means that tasks which otherwise would have been frozen are
> actually free to run before the kexec call is made (and after the call
> returns, if the kexec'd kernel returns back to the original kernel).
> Any driver which was written with the assumption that tasks would be
> frozen at those times will need to be changed.

here is where you loose me.

why should jumping back to the original kernel immedialty start running 
these processes? the process of doing a kexec requires things to happen in 
the drivers before normal activity can happen, so there is a phase in 
there where the kernel being jumped to has drivers initializing, but still 
does not allow anything else to run. why can't this phase be extended to 
allow for the possibility of transitioning these drivers to a sleep mode 
instead of to full operation?

> For example, drivers know that they have to quiesce their device in
> preparation for creating the memory snapshot.  But they assume that no
> I/O requests will be made while the device is quiesced (because no user
> task is capable of generating an I/O request if they are all frozen),
> so the driver doesn't try to prevent such requests from reactivating
> the device.
>
> The situation as regards locking is harder to discuss since I don't
> know of any code examples to use as a guide.  The fact remains that if
> user tasks aren't frozen then they can make system calls, and while
> running in kernel mode they can acquire locks, which might cause
> problems -- even though I can't identify any definite examples.

yes, if userspace is running jobs and submitting I/O and system calls 
while drivers are trying to initalize there is a big problem, but I am 
missing the reason this must be the case.

> Because of these problems, it's too early to start trying to use kexec
> to avoid the need for the freezer.
>
> Of course, exactly the same possible problems exist when one tries to
> remove the freezer from suspend-to-RAM.  It has nothing to do with
> kexec in particular (and certainly nothing to do with ACPI).

the part of the freezer that everyone is trying to eliminate is the 
exceptions (freeze everything except X,Y,Z becouse we will need to use 
those later for A)

>> having read through Documentation/power/devices.txt I remain convinced
>> that you are making a fundamental mistake.
>>
>> you are designing a system
>
> I'm not designing anything!  _You_ are.  I'm merely pointing out
> problems in your design which you haven't considered.

a better way of phrasing what I meant goes more along the lines of 'the 
current design of the system...'

>>  that will only work if everything (every
>> driver, every state transition) participates fully in the process at all
>> times. You started with the facts 'this is the info that ACPI provides
>
> Look again; I wasn't talking about ACPI.  You have mixed up the issues
> in this email thread.  (Not hard to do, since it has been a very long
> and complicated thread.)

very possibly. there are so many different sub-threads that part of my 
answer was to you, and part is addressing other things brought up during 
the thread

>> and
>> this is how it is designed to be used' and worked from there instead of
>> looking to see what the kernel really needed and figuring how to provide a
>> good interface for that that happens to be implemented (today) with ACPI.
>> (a proper power management framework shouldn't care if you have ACPI, APM,
>> or some other method of controlling the devices)
>
> This and the rest of your email have no bearing on what I was talking
> about, so I have snipped out the remainder.

this was in reaction to reading the power/devices.txt. my first thought 
was along the lines of "no wonder device driver authors don't implement 
all this, it's obviously evolved from the needs of the people doing the 
suspend, one call at a time" and from there I started thinking about what 
would make sense to driver authors and provide the capability that's 
needed for the job. I broke that off into a seperate thread anyway.

David Lang
