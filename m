Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYK1XkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYK1XkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYK1XkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:40:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:43124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYK1XkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:40:00 -0500
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
	backend
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1227914568.3393.5.camel@localhost.localdomain>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
	 <1227802849.4454.1765.camel@twins>
	 <1227914568.3393.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 29 Nov 2008 00:39:29 +0100
Message-Id: <1227915570.24749.13.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 18:22 -0500, Eric Paris wrote:
> On Thu, 2008-11-27 at 17:20 +0100, Peter Zijlstra wrote:
> > On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> > > +int fsnotify_check_notif_queue(struct fsnotify_group *group)
> > > +{
> > > +       mutex_lock(&group->notification_mutex);
> > > +       if (!list_empty(&group->notification_list))
> > > +               return 1;
> > > +       mutex_unlock(&group->notification_mutex);
> > > +       return 0;
> > > +}
> > 
> > > +void fsnotify_clear_notif(struct fsnotify_group *group)
> > > +{
> > > +       struct fsnotify_event *event;
> > > +
> > > +       while (fsnotify_check_notif_queue(group)) {
> > > +               event = get_event_from_notif(group);
> > > +               fsnotify_put_event(event);
> > > +               /* fsnotify_check_notif_queue() took this lock */
> > > +               mutex_unlock(&group->notification_mutex);
> > > +       }
> > > +}
> > 
> > That is quite horrible, please just open code that to keep the locking
> > symmetric.
> 
> While horrible, I use fsnotify_check_notif_queue in my fsnotify (not in
> this series as this only includes dnotify) has
> 
> wait_event_interruptible(group->notification_waitq, fanotify_check_notif_queue(group));
> 
> So I wouldn't know how to open code that...  I can open code this
> instance, but it's going to mean redoing all of that other code to
> handle having thing not be present when we return.  Since I didn't
> submit that as well I guess I'm not allowed to use it as a reason...

Or you add a lock parameter to wait_event*() which gets unlocked before
schedule and locks again afterwards.

That would allow you to write it like so:

 mutex_lock(&group->notification_mutex);
 wait_event_interruptible_lock(group->notification_waitq,
                               !list_empty(&group_notificatioin_list), 
                               &group_notification_mutex);

 /* handle the !empty list */
 mutex_unlock(&group->notification_mutex);

You could use the type matching magic we have to select between
spinlock/mutex operations for the lock argument.

I've come across such a pattern a few times, most of the times we end up
open coding the wait_event stuff.

