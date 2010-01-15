Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0AOPPE (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230Ab0AOPPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:15:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:55070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab0AOPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:15:01 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [PATCH 2/4] fanotify: Add pids to events
Date: Fri, 15 Jan 2010 16:12:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; i686; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, containers@lists.linux-foundation.org,
        matthltc@us.ibm.com, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com> <20091202141458.12819.96170.stgit@paris.rdu.redhat.com> <6a12d2f31001142041j7f917b07l1e1a728790175321@mail.gmail.com>
In-Reply-To: <6a12d2f31001142041j7f917b07l1e1a728790175321@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001151612.10032.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 January 2010 05:41:10 Matthew Helsley wrote:
> Eric, you never replied to my point about pid namespaces
> (http://lkml.org/lkml/2009/7/1/2). I'm still concerned that it's a
> problem for this patch. I've cc'd some pid namespace folks, listed the
> problems, and some alternative solutions (where I could think of any)
> below:
> 
> 1. Since fanotify doesn't hold a reference to the struct pid then the
> pid can become stale before the event is acted upon.
>     solution a: Just ignoring this problem, like other interfaces
> often do, is probably ok.
>     ... ?
>     solution z: Seems to require taking a reference to the pid and
> giving userspace a way to drop the reference after it's done using
> this value to refer to the process (yuck).

struct fsnotify_event->tgid does hold a reference to the appropriate struct 
pid.  The reference is released when that struct fsnotify_event is freed.

> 2. If the event recipient does a clone and enters a new pidns the pid
> number will be incorrect without any indication.

No, if a process has a pid within the listener's namespace the listener will 
see this pid; otherwise, the resulting pid value is 0.

> 3. If the listening process is not in the same or an ancestor pid
> namespace of the triggering process then there is no correct pid
> corresponding to the event.

Indeed, if the listener is not in the same or an ancestor pid namespace, the 
pid in the event will end up as 0.  The event still indicates that something 
has happened to a file the listener is interested in though, it's just unclear 
who triggered the event.  I don't see a problem with that though -- do you?

Thanks,
Andreas
