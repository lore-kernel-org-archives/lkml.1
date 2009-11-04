Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZKDAz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZKDAz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZKDAz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:55:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZKDAzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:55:55 -0500
Subject: Re: [PATCH 10/10] send events using read
From: Eric Paris <eparis@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       vegard.nossum@gmail.com
In-Reply-To: <20091103165947.35bd78d7@bike.lwn.net>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
	 <20091031184819.17244.55795.stgit@paris.rdu.redhat.com>
	 <20091103165947.35bd78d7@bike.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 19:55:48 -0500
Message-Id: <1257296148.2891.223.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 16:59 -0700, Jonathan Corbet wrote:
> Hi, Eric,
> 
> This is not a full review, but I did notice a problem as I was trying to
> figure out the new API...

This is a rip off of inotify which was introduced in commit 3632dee2f8b
from Vegard Nossum back in January.  I can't seem to find any discussion
of this before it went into Linus' tree, so if someone knows how this
patch got to Linus and what was said about it, I'd like to know.  Thanks
for unwittingly finding and inotify bug!

I looked back over it and it looks to me like it will work although
there may be a race like situation if there are multiple things trying
to read events.  I can see how with perfect timing and precision Task A
might try to get the mutex and it is being held by task B.  Task B drops
the mutex and Task A gets it, this causes Task A to be TASK_RUNNABLE.
Lets assume Task B runs back around the loop and tries to get it while
Task A still holds it.  Task A will drop the mutex and Task B gets it,
now B is runnable.  Repeat until infinity with perfect timing!  It's not
really a live-lock, if either of them ever gets the mutex uncontested or
if an event ever arrives they are going to sleep and/or break the cycle.

Certainly I'll take a look at it.

> > +static ssize_t fanotify_read(struct file *file, char __user *buf,
> > +			     size_t count, loff_t *pos)
> > +{
> > +	struct fsnotify_group *group;
> > +	struct fsnotify_event *kevent;
> > +	char __user *start;
> > +	int ret;
> > +	DEFINE_WAIT(wait);
> > +
> > +	start = buf;
> > +	group = file->private_data;
> > +
> > +	pr_debug("%s: group=%p\n", __func__, group);
> > +
> > +	while (1) {
> > +		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
> > +
> > +		mutex_lock(&group->notification_mutex);
> > +		kevent = get_one_event(group, count);
> > +		mutex_unlock(&group->notification_mutex);
> 
> prepare_to_wait(), among other things, sets the task state.  But then you
> go into various sleeping calls (mutex_lock(), for starters); that will undo
> what prepare_to_wait has done.  You'll be back in TASK_RUNNING at this
> point, so you'll never sleep.

