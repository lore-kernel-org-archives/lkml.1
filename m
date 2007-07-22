Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXGVQAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXGVQAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXGVQA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:00:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1921 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752189AbXGVQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:00:27 -0400
Date: Sun, 22 Jul 2007 12:00:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: david@lang.hm
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707212000380.6747@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707221126280.15224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 david@lang.hm wrote:

> wait a min her, it's possible we are misunderstanding each other.

I'd describe it as: You are misunderstanding me.  :-)

> as I see it.
> 
> if userspace can aquire locks that prevent the kernel from shutting off 
> (or doing anything else in particular) then it's possible for misbehaving 
> userspace code to stop the kernel by simply choosing to never release the 
> lock.
> 
> this would be a trivial DOS from userspace.

You are confusing "userspace" with "user tasks".  And not only that,
you often use the term "userspace" when you should say "user mode".

If you want I can explain the differences.

> now, if you are talking instead about the fact that when userspace makes a 
> system call, the execution of that system call involves aquiring locks 
> that are released before the system call completes you have a very 
> different situation.

That is exactly what I have been talking about.  It may be different
from what you _thought_, but it's not different from what I actually
_said_.

> if you have locks that are held across system calls then you should 
> already have problems. becouse you can't count on userspace ever taking 
> whatever action is appropriate to release the lock.
> 
> what am I missing that concerns you so much?

Here's what you are missing:

The new kexec approach eliminates the freezer and relies instead on the
fact that none of the tasks in the original kernel can execute while
the new kexec'd kernel is running.  This means the new kernel can write
out a memory image with no fear of interference or corruption.

But it also means that tasks which otherwise would have been frozen are 
actually free to run before the kexec call is made (and after the call 
returns, if the kexec'd kernel returns back to the original kernel).  
Any driver which was written with the assumption that tasks would be 
frozen at those times will need to be changed.

For example, drivers know that they have to quiesce their device in
preparation for creating the memory snapshot.  But they assume that no
I/O requests will be made while the device is quiesced (because no user
task is capable of generating an I/O request if they are all frozen),
so the driver doesn't try to prevent such requests from reactivating
the device.

The situation as regards locking is harder to discuss since I don't 
know of any code examples to use as a guide.  The fact remains that if 
user tasks aren't frozen then they can make system calls, and while 
running in kernel mode they can acquire locks, which might cause 
problems -- even though I can't identify any definite examples.

Because of these problems, it's too early to start trying to use kexec
to avoid the need for the freezer.

Of course, exactly the same possible problems exist when one tries to
remove the freezer from suspend-to-RAM.  It has nothing to do with 
kexec in particular (and certainly nothing to do with ACPI).

> having read through Documentation/power/devices.txt I remain convinced 
> that you are making a fundamental mistake.
> 
> you are designing a system

I'm not designing anything!  _You_ are.  I'm merely pointing out
problems in your design which you haven't considered.

>  that will only work if everything (every 
> driver, every state transition) participates fully in the process at all 
> times. You started with the facts 'this is the info that ACPI provides

Look again; I wasn't talking about ACPI.  You have mixed up the issues
in this email thread.  (Not hard to do, since it has been a very long
and complicated thread.)

> and 
> this is how it is designed to be used' and worked from there instead of 
> looking to see what the kernel really needed and figuring how to provide a 
> good interface for that that happens to be implemented (today) with ACPI. 
> (a proper power management framework shouldn't care if you have ACPI, APM, 
> or some other method of controlling the devices)

This and the rest of your email have no bearing on what I was talking
about, so I have snipped out the remainder.

Alan Stern

