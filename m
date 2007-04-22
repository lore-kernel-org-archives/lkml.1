Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXDVWKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXDVWKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXDVWKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:10:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbXDVWKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:10:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Mon, 23 Apr 2007 00:14:40 +0200
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, mingo@elte.hu, ego@in.ibm.com, oleg@tv-sign.ru,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704222139.27128.rjw@sisk.pl> <20070422141452.a7855599.pj@sgi.com>
In-Reply-To: <20070422141452.a7855599.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704230014.42100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 22 April 2007 23:14, Paul Jackson wrote:
> Rafael wrote:
> > Move all of the freezer-related flags to a separate field in task_struct and
> > introduce functions to operate them using set_bit() etc.
> 
> It's getting time I learned what this freezer thing is.
> 
> What would you suggest I read?
> 
> I looked in include/linux/freezer.h and didn't see any explanations.
> I found one Documenation file, power/kernel_threads.txt, that explained
> the interaction of freezing and kernel threads.  I looked in the
> comments for various 2.6.21-rc6-mm1 freezer* patches, and saw various
> interesting details.
> 
> But I couldn't find any documentation telling me what a freezer was,
> or what a refrigerator is.
> 
> Did I miss something?

Well, unfortunately not.  The freezer is not separately documented, mainly
because (1) for a long time it's been a part of the suspend code and no one
else used it, and (2) because it's been changing a lot recently and it's been
a 'moving target' from the documentation point of view.

I'll try to explain how it works.

In short, we use the freezer to make tasks enter a specific function, called
the refrigerator, and stay there until they are let out.  This is done by
calling freeze_processes() (in 2.6.21-rc7 it is located in
kernel/power/process.c) that executes try_to_freeze_tasks() separately for
userland processes and kernel threads (the sync() in between is needed by
the suspend code).  try_to_freeze_tasks() sets the FREEZE flag (TIF_FREEZE in
2.6.21-rc7) for each freezable (I'll explain what that means in a while) task
and sends a fake signal to it.

Userland processes then go to get_signal_to_deliver(), where they execute
try_to_freeze() (defined in include/linux/freezer.h) and call refrigerator()
(in kernel/power/process.c), since the FREEZE flag is set.  In refrigerator()
they reset the FREEZE flag and set the FROZEN flag (in 2.6.21-rc7 it is a
process flag defined in sched.h).  Next, they loop in refrigerator() until
someone resets the FROZEN flag for them.  Then we say that they are 'frozen'.

Kernel threads don't call get_signal_to_deliver(), so they have to execute
try_to_freeze() directly to go to the refrigerator.  Moreover, kernel threads
may not want to go there at all, in which case they should set the NOFREEZE
flag (in 2.6.21-rc7 it is a process flag defined in sched.h), that makes
try_to_freeze_tasks() ignore them.

Apart from the kernel threads that have the NOFREEZE flag set,
try_to_freeze_tasks() ignores the task that's running it (its current task)
and the tasks that have exit_state different from 0.  They all are regarded
as 'not freezable'.

Of course, kernel threads that declare themselves as not freezable, by setting
the NOFREEZE flag, should be careful enough not to interfere with the subsystem
that is using the freezer (ie. has called freeze_processes()), which may be
quite difficult in practice, so only a few kernel threads do it (and even some
of them really shouldn't).

The subsystem that has called freeze_processes() is responsible for the
'thawing' of tasks, which is done by calling thaw_processes() (defined in
kernel/power/process.c).  It runs thaw_tasks() (in the same file) for kernel
threads and userland processes.  This function loops over all tasks and
resets the FROZEN flag for them, so that they can leave the refrigerator.

The suspend code uses the freezer to make sure that processes won't get
in the way when some suspend-related low-level operations are carried out
(like suspending devices, the creation of a suspend image by swsusp etc.).
Other subsystems may use it for similar purposes.

Greetings,
Rafael
