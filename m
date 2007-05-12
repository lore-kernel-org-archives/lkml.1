Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXELBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXELBHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760579AbXELBHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:07:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbXELBHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:07:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 03:11:42 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <20070511234819.GA508@tv-sign.ru> <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705120311.43258.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 02:08, Linus Torvalds wrote:
> 
> On Sat, 12 May 2007, Oleg Nesterov wrote:
> > 
> > things change, ->mm is not stable if the kernel thread does use_mm/unuse_mm.
> 
> ->mm is not stable *regardless*!
> 
> Trivial examples:
>  - kernel thread does execve()
>  - user thread does exit().
> 
> The use "use_mm()" and "unuse_mm()" things are total red herrings.
> 
> If the freezer depends on the difference between user and kernel threads, 
> then THAT PATCH IS BUGGY. It's that simple. It tests something that simply 
> isn't stable outside the lock, and then returns that value after having 
> unlocked it.
> 
> It might as well return a random number.
> 
> > However, the return value == 0 does not change in that particular case,
> > exactly because is_user_space() takes task_lock().
> 
> As does exit_mm() etc.
> 
> That's NOT THE POINT. You cannot use the end result after releasing the 
> task lock, because the moment you release the task lock, it becomes 
> totally irrelevant, and may not be true any more.
> 
> Example (a):
>  - you ask "is_user_space(p)", it returns 1.
>  - before you actually have time to do anything about it, the task exists, 
>    and (since you don't hold the lock any more) will now have a NULL 
>    tsk->mm again (and would now return 0 if you called it again).

In which case we won't be freezing this task at all.

> Example (b):
>  - you ask "is_user_space(p)" and it returns 0, because it's a kernel 
>    thread
>  - before you actually do anything about it (but after you released the 
>    task lock), the kernel thread does an "execve(/sbin/hotplug)" and is no 
>    longer a kernel thread.

This is a special case that needs special handling.

> In both cases will the caller have a return value THAT IS NO LONGER TRUE.
> 
> See? The locking was pointless. Exactly because you release the lock 
> before the user can actually do anything about the return value!
> 
> The fact that the locking protects against the very specific case of AIO 
> where the threads _stay_ user tasks and don't really change is pretty much 
> irrelevant, as far as I can see. 

Well, I disagree.  We need the locking *exactly* to avoid situations in which
the threads don't really change, but we might think that they *have changed*.
More precisely, it's needed, because without it kernel threads which execute
use_mm()/unuse_mm() might be identified as user space processes, and that
would be wrong.  The other cases are beyond the scope of this patch.

Rafael
