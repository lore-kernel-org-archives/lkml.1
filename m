Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbXELAJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbXELAJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbXELAJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:09:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760034AbXELAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:09:21 -0400
Date: Fri, 11 May 2007 17:08:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
In-Reply-To: <20070511234819.GA508@tv-sign.ru>
Message-ID: <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl>
 <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl>
 <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
 <20070511232024.GA489@tv-sign.ru> <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org>
 <20070511234819.GA508@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Oleg Nesterov wrote:
> 
> things change, ->mm is not stable if the kernel thread does use_mm/unuse_mm.

->mm is not stable *regardless*!

Trivial examples:
 - kernel thread does execve()
 - user thread does exit().

The use "use_mm()" and "unuse_mm()" things are total red herrings.

If the freezer depends on the difference between user and kernel threads, 
then THAT PATCH IS BUGGY. It's that simple. It tests something that simply 
isn't stable outside the lock, and then returns that value after having 
unlocked it.

It might as well return a random number.

> However, the return value == 0 does not change in that particular case,
> exactly because is_user_space() takes task_lock().

As does exit_mm() etc.

That's NOT THE POINT. You cannot use the end result after releasing the 
task lock, because the moment you release the task lock, it becomes 
totally irrelevant, and may not be true any more.

Example (a):
 - you ask "is_user_space(p)", it returns 1.
 - before you actually have time to do anything about it, the task exists, 
   and (since you don't hold the lock any more) will now have a NULL 
   tsk->mm again (and would now return 0 if you called it again).

Example (b):
 - you ask "is_user_space(p)" and it returns 0, because it's a kernel 
   thread
 - before you actually do anything about it (but after you released the 
   task lock), the kernel thread does an "execve(/sbin/hotplug)" and is no 
   longer a kernel thread.

In both cases will the caller have a return value THAT IS NO LONGER TRUE.

See? The locking was pointless. Exactly because you release the lock 
before the user can actually do anything about the return value!

The fact that the locking protects against the very specific case of AIO 
where the threads _stay_ user tasks and don't really change is pretty much 
irrelevant, as far as I can see. 

Anyway, I think the whole freezer thing is broken. There's no reason to 
freeze kernel threads. 

If you want to freeze user processes, go ahead. But then you need a lock 
to make sure that new processes don't *become* user processes (ie you need 
to disable hotplug). 

And if you want to protect against cpufreq, do so. But don't try to say 
that you want to freeze all kernel threads. Just protect against cpufreq 
threads. Don't make all the other threads that have *zero* interest in 
freezing have to worry about it.

			Linus
