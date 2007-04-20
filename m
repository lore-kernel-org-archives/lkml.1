Return-Path: <linux-kernel-owner+w=401wt.eu-S2992690AbXDTMqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992690AbXDTMqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992718AbXDTMqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:46:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992690AbXDTMqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:46:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Date: Fri, 20 Apr 2007 14:50:05 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704201359.30490.rjw@sisk.pl> <20070420122609.GA22325@in.ibm.com>
In-Reply-To: <20070420122609.GA22325@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201450.06487.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 April 2007 14:26, Gautham R Shenoy wrote:
> On Fri, Apr 20, 2007 at 01:59:29PM +0200, Rafael J. Wysocki wrote:
> > 
> > Actually, I thought about it for a while.  The thread that is going to stop
> > another one may temporarily mark itself as freezable in all cases, which
> > will have no effect on it, since it's not going to cally try_to_freeze(), but
> > will make the freezer wait for it.  Next, after returning from
> > wait_for_completion(), it should restore its old freezability status and that
> > should make the freezer finish.
> 
> But that will have no affect if the thread to be stopped is already
> frozen. The only affect might be that now, freezer will fail whether
> the thread that is going to stop another one was freezeable or not.
> 
> Concern is whether we can somehow complete these wait_for_completion()'s in 
> the freezing context and reduce the probabilty of freezer failing.

To be precise, I was thinking about something like this (in pseudo-code):

	kthread_stop_info.k = k;
	save_freezable_status(current);
	set_always_freezable(current);
	/* Now, we know that the freezer will wait for us, although we're not
	 * really going to freeze
	 */
	task_lock(k);
	k->flags |= PF_NOFREEZE;
	if (frozen(k))
		k->flags &= ~PF_FROZEN;

	task_unlock(k);
	wake_up_process(k);
	put_task_struct(k);

	/* Once it dies, reset stop ptr, gather result and we're done. */
	wait_for_completion(&kthread_stop_info.done);
	restore_freezable_status(current);

> > > However, I was attempting to solve the generic problem where
> > > A waits on B and B is frozen. If A is freezeable (under one of the
> > > events) then the freezer will fail. So a solution would be for A to
> > > somehow inform B of the dependency and postpone it's freezing.
> > 
> > Well, I think it might be simpler to consider each case separately.  This way
> > we may be able to avoid introducing the additional TIF_ flag.
> > 
> 
> Makes sense.
> 
> > > Since akpm mentioned that flush_workqueue() needs to go, I guess, I am
> > > ok with fixing only kthread_stop/kthread_should_stop for the moment.
> > > Unless I can spot any other valid case :)
> > 
> > Sure. :-)
> > 
> > BTW, if it turns out that we need to introduce yet another freezer-related
> > TIF_ flag, it may be acceptable (?) to move all of the freezer-related flags
> > into a separate member of task_struct (eg. freezer_flags) that can only be
> > manipulated under task_lock().
> > 
> > I mean, we already have four of them (PF_NOFREEZE, PF_FROZEN,
> > PF_FREEZER_SKIP, TIF_FREEZE), and you will need to introduce two more for
> > the freezer-based CPU hotplug, so if yet another one is needed, that will make
> > up almost a separate u8 field ...
> 
> I am perfectly ok with it. But I am not sure if everybody would agree to have
> another field in the task struct, though in this case it does make sense :-)

Well, I'm not sure either, but I guess the most practical way to learn it is to
send a patch. ;-)

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
