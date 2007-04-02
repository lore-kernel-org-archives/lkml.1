Return-Path: <linux-kernel-owner+w=401wt.eu-S965987AbXDBWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965987AbXDBWJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965992AbXDBWJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:09:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55620 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965987AbXDBWJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:09:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Date: Tue, 3 Apr 2007 00:12:30 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com, Pavel Machek <pavel@ucw.cz>
References: <20070402053457.GA9076@in.ibm.com> <20070402111900.GA30946@in.ibm.com> <20070402112745.GB27891@elte.hu>
In-Reply-To: <20070402112745.GB27891@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704030012.32113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2 April 2007 13:27, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > From what I can make out, we fail to freeze if we have some task in 
> > the TASK_UNINTERRUPTIBLE state for more than the timeout period.
> 
> > Question is can we have some task in TASK_UNINTERRUPTIBLE state for 
> > such a long duration (20sec) ??
> 
> yes, easily so - just have a really long disk queue. Or really heavy 
> mutex contention.
> 
> i really think we should add a freezing hook to schedule too (no need to 
> change anything else - just add a PF_FREEZE check into the schedule() 
> function) - and add a wakeup method that moves TASK_UNINTERRUPTIBLE 
> tasks to the runqueue but does not touch their task->state.

Yes, something like this would be necessary to handle TASK_UNINTERRUPTIBLE
tasks.  _Still_, currently we just fail the freezing if there are
uninterruptible tasks, because they can hold locks and may potentially
deadlock with device drivers' .suspend() or .resume() routines (please remember
that the freezer is used for suspending in the first place :-)).

I think we can freeze uninterruptible tasks for the CPU hotplug, but we should
avoid freezing them for the suspend.
 
> ( the copy_process() handling is still needed, so that no new tasks
>   without PF_FREEZE get created that could slip out of control. )

We can catch them while we're freezing kernel threads (provided that the kernel
threads themselves aren't forking like mad, but this doesn't seem to happen in
practice).
 
Greetings,
Rafael
