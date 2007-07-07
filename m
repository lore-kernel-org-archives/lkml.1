Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXGGXBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXGGXBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 19:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXGGXBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 19:01:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXGGXBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 19:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sun, 8 Jul 2007 01:08:16 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@ucw.cz>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0707061039380.3737-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707061039380.3737-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707080108.17371.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 17:01, Alan Stern wrote:
> On Fri, 6 Jul 2007, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > The main limitation of the freezer is that it cannot handle uninterruptible
> > tasks.  Namely, if there are uninterruptible tasks in the system, the freezer
> > returns an error, which makes it impossible to suspend the system.
> > 
> > This mechanism is used to prevent the situations in which the suspend process
> > can deadlock with a task holding a lock needed by it from happening.  However,
> > AFAICS, the probability of that happening is very small and if the freezer is
> > removed from the suspend code patch, then the suspend process will be exposed to
> > deadlocking in this manner anyway.
> > 
> > Unfortunately, this mechanism also leads to severe limitations, such as that it
> > makes the freezer unable to handle systems using FUSE in a reliable way.
> > 
> > This patch makes the freezer skip uninterruptible user space tasks (ie. such
> > that have an mm of their own) when counting the tasks to be frozen.  As a
> > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> > freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> > will enter the refrigerator as soon as they change their state.
> 
> This is a very interesting idea.  Are you certain it is safe?  That is,
> if a task is waiting for a mutex and sometime later the mutex becomes
> available, will the task then enter the freezer immediately -- before
> it can do any I/O or call any drivers?

Well, I _think_ it is safe, although I can't prove it.

> If you can't make this guarantee, then you might as well simply not try 
> to freeze any user task until it returns from kernel mode to user mode.  

No, it's not that bad.  The majority of user land tasks are not uninterruptible
and if they are, then usually for a very short time only.

> And then you will face the problem of a user task doing I/O during 
> hibernate after the atomic snapshot has been made.

I don't think that this is possible in normal conditions.  It would be possible
if, for example, the task were waiting for an unavailable resource and that
resource became available after the hibernation image had been created.
In that case, however, to do any damage, the task would have to cause some
filesystem-related data to be flushed in the same syscall (ie. before returning
to user space).

Such situations may be prevented by a mechanizm detecting if any uniterruptible
and freezing task has been woken up after creating the image and aborting the
hibernation in that cases.  For this purpose, we only need to add an
appropriate condition to try_to_wake_up() and make it start to trigger after,
for example, enabling the nonboot CPUs.

> I had in mind something more complicated.  My idea was to define 
> certain mutexes as "freezable", with the thought that it would be okay 
> for a task in the freezer to own freezable mutexes.  None of the 
> mutexes needed by drivers or the PM core during a suspend transition 
> should be freezable.
> 
> Presumably the VFS locks _would_ fall into the freezable category.  In 
> order for this to work, we would have to guarantee the following:
> 
> 	A thread blocked in the kernel waiting for some response
> 	from userspace is allowed to hold freezable mutexes but no
> 	other locks.
> 
> 	When a thread tries to acquire a freezable mutex, it is allowed
> 	to hold other freezable mutexes but no other locks.
> 
> 	When the freezer is running, any task that is blocked on a
> 	freezable mutex (maybe also any task that tries to acquire 
> 	an unlocked freezable mutex) would immediately go into the 
> 	freezer.  So would any task waiting for a response from
> 	userspace.
> 
> I think this would solve the VFS-related problems (FUSE's and others).  

Well, the main difficluty with that would be to convince people to use it. ;-)

> But obviously Raphael's approach is preferable, if it works.

Right now, it sometimes fails to freeze all tasks that in theory should be
freezable.  Investigating.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
