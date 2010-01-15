Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab0AOWlu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514Ab0AOWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:41:49 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41302 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab0AOWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:41:49 -0500
Date: Fri, 15 Jan 2010 13:21:46 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Matthew Helsley <matt.helsley@gmail.com>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] fanotify: Add pids to events
Message-ID: <20100115212146.GA3714@count0.beaverton.ibm.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
 <20091202141458.12819.96170.stgit@paris.rdu.redhat.com>
 <6a12d2f31001142041j7f917b07l1e1a728790175321@mail.gmail.com>
 <201001151612.10032.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001151612.10032.agruen@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 04:12:09PM +0100, Andreas Gruenbacher wrote:
> On Friday 15 January 2010 05:41:10 Matthew Helsley wrote:
> > Eric, you never replied to my point about pid namespaces
> > (http://lkml.org/lkml/2009/7/1/2). I'm still concerned that it's a
> > problem for this patch. I've cc'd some pid namespace folks, listed the
> > problems, and some alternative solutions (where I could think of any)
> > below:
> > 
> > 1. Since fanotify doesn't hold a reference to the struct pid then the
> > pid can become stale before the event is acted upon.
> >     solution a: Just ignoring this problem, like other interfaces
> > often do, is probably ok.
> >     ... ?
> >     solution z: Seems to require taking a reference to the pid and
> > giving userspace a way to drop the reference after it's done using
> > this value to refer to the process (yuck).
> 
> struct fsnotify_event->tgid does hold a reference to the appropriate struct 
> pid.  The reference is released when that struct fsnotify_event is freed.

OK.

> 
> > 2. If the event recipient does a clone and enters a new pidns the pid
> > number will be incorrect without any indication.
> 
> No, if a process has a pid within the listener's namespace the listener will 
> see this pid; otherwise, the resulting pid value is 0.

So the pid reference is resolved at read(), correct? If so then that's fine.
(Otherwise I'd think the values could still become stale).

> > 3. If the listening process is not in the same or an ancestor pid
> > namespace of the triggering process then there is no correct pid
> > corresponding to the event.
> 
> Indeed, if the listener is not in the same or an ancestor pid namespace, the 
> pid in the event will end up as 0.  The event still indicates that something 
> has happened to a file the listener is interested in though, it's just unclear 
> who triggered the event.  I don't see a problem with that though -- do you?

Nope. Overall, looks good to me. Thanks!

Cheers,
	-Matt Helsley
