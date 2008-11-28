Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYK1XXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYK1XXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYK1XXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:23:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51115 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYK1XXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:23:34 -0500
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
 backend
From: Eric Paris <eparis@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <1227802849.4454.1765.camel@twins>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
	 <1227802849.4454.1765.camel@twins>
Content-Type: text/plain
Date: Fri, 28 Nov 2008 18:22:48 -0500
Message-Id: <1227914568.3393.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 17:20 +0100, Peter Zijlstra wrote:
> On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> > +int fsnotify_check_notif_queue(struct fsnotify_group *group)
> > +{
> > +       mutex_lock(&group->notification_mutex);
> > +       if (!list_empty(&group->notification_list))
> > +               return 1;
> > +       mutex_unlock(&group->notification_mutex);
> > +       return 0;
> > +}
> 
> > +void fsnotify_clear_notif(struct fsnotify_group *group)
> > +{
> > +       struct fsnotify_event *event;
> > +
> > +       while (fsnotify_check_notif_queue(group)) {
> > +               event = get_event_from_notif(group);
> > +               fsnotify_put_event(event);
> > +               /* fsnotify_check_notif_queue() took this lock */
> > +               mutex_unlock(&group->notification_mutex);
> > +       }
> > +}
> 
> That is quite horrible, please just open code that to keep the locking
> symmetric.

While horrible, I use fsnotify_check_notif_queue in my fsnotify (not in
this series as this only includes dnotify) has

wait_event_interruptible(group->notification_waitq, fanotify_check_notif_queue(group));

So I wouldn't know how to open code that...  I can open code this
instance, but it's going to mean redoing all of that other code to
handle having thing not be present when we return.  Since I didn't
submit that as well I guess I'm not allowed to use it as a reason...

