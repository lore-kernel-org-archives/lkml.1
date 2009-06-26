Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbZFZSGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbZFZSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZFZSG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:06:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59896 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755828AbZFZSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:06:26 -0400
Date: Fri, 26 Jun 2009 14:06:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] [patch update] PM: Introduce core framework for
 run-time PM of I/O devices (rev. 5)
In-Reply-To: <200906252358.56909.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906261155160.2965-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Rafael J. Wysocki wrote:

> > The whole business about the runtime_notify and RPM_NOTIFY flags is 
> > impenetrable.  My suggestion: Rename runtime_notify to notify_pending 
> > and eliminate RPM_NOTIFY.  Then make sure that notify_pending is set 
> > whenever a notify work item is queued.
> 
> I was going to do exactly that, but I realized it wouldn't work in general,
> because ->runtime_idle() could run __pm_runtime_suspend() in theory.

I'll cut this short by noting the dilemma.  If the runtime_idle 
callback does a synchronous suspend, and __pm_runtime_suspend sees the 
status is already RPM_SUSPENDING, then it will wait for the suspend to 
finish.  Hence it's not safe to do cancel_work_sync from within 
__pm_runtime_suspend; it might deadlock.

It occurs to me that the problem would be solved if were a cancel_work
routine.  In the same vein, it ought to be possible for
cancel_delayed_work to run in interrupt context.  I'll see what can be
done.

What do you think about adding a version of pm_runtime_put that would 
call pm_runtime_idle directly when the counter reaches 0, instead of 
queuing an idle request?  I feel that drivers should have a choice 
about which sort of notification to use.


> > And don't forget to decrement the parent's child_count again if the resume
> > fails.
> 
> I didn't _forget_it, because the device can't be RPM_SUSPENDED after
> __pm_runtime_resume().

You're right; that fact escaped me.

> > In __pm_runtime_suspend, you should decrement the parent's child_count
> > before releasing the child's lock.
> 
> Why exactly is that necessary?

I guess it isn't.  But it won't hurt to keep the parent's counter
synchronized with the child's state as closely as possible.

Alan Stern

