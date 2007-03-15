Return-Path: <linux-kernel-owner+w=401wt.eu-S1422723AbXCOO1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422723AbXCOO1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 10:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422726AbXCOO1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 10:27:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43979 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422723AbXCOO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 10:27:20 -0400
Date: Thu, 15 Mar 2007 10:27:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0703150953420.13086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Cornelia Huck wrote:

> > > The naming seems a bit unintuitive, but I don't have a good
> > > alternative idea. Perhaps sysfs_work_struct, sysfs_delayed_work()?
> > 
> > sysfs_work_struct is too generic; other parts of sysfs might also want to
> > use workqueues for different purposes.
> 
> > I don't like calling it "delayed"-anything, because the operations aren't
> > necessarily delayed!  On an SMP system they might even execute before the
> > sysfs_access_in_other_task() call returns.  (Although the two examples we
> > have so far can't do that because of lock contention.)
> 
> Sure. But then you shouldn't refer to "delay" in the comments for the
> functions as well :)

Fair enough.  One use of "delay" is in a comment you wrote; I'll change it 
as well.

> > The major feature added here is that the work takes place in a different 
> > task's context, not that it is delayed.  Hence the choice of names.
> 
> Hm. Perhaps device_schedule_access()?

On Thu, 15 Mar 2007, Hugh Dickins wrote:

> It's really none of my business, I'm merely the reporter the
> deadlock being fixed, and I don't know my way around sysfs at all ...
> 
> ... but I have to say I share your discomfort with Alan's
> "sysfs_access_in_other_task" naming, it sounded very weird to me.
> 
> Quite apart from this mysterious "other task", I don't understand
> "access" either.
> 
> Perhaps "defer" would best capture the idea of another-task and
> maybe-delay?  sysfs_defer_work(), struct sysfs_deferred_work?  

On Thu, 15 Mar 2007, Oliver Neukum wrote:

> But we do not wish to defer or delay anything.
> How about: sysfs_action_from_neutral_context  

On Thu, 15 Mar 2007, Dmitry Torokhov wrote:

> How about sysfs_schedule_work? That is what it does - schedules a work
> on a sysfs object and everyone here knows what schedule_work() does.  

On Thu, 15 Mar 2007, Hugh Dickins wrote:

> I'm ashamed to have suggested anything else: certainly gets my vote.

Personally I don't understand what was wrong with my name.  What's weird 
or unintuitive about doing something in a different task's context?

Dmitry's suggestion is slightly inappropriate because the function doesn't
take a workstruct as an argument and it isn't itself a workqueue callback.  

Would people be happier with sysfs_schedule_callback() and
device_schedule_callback()?  At least the functions do take a callback 
pointer as an argument, even though they aren't callbacks themselves.

Alan Stern

